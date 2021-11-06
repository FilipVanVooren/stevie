XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b1.asm.30692
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 211106-1515410
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
                   < stevie_b1.asm.30692
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
                   < stevie_b1.asm.30692
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
0081               ;   Dialog ID's >= 100 indicate that command prompt should be
0082               ;   hidden and no characters added to CMDB keyboard buffer
0083               ;-----------------------------------------------------------------
0084      000A     id.dialog.load            equ  10      ; "Load DV80 file"
0085      000B     id.dialog.save            equ  11      ; "Save DV80 file"
0086      000C     id.dialog.saveblock       equ  12      ; "Save codeblock to DV80 file"
0087      000D     id.dialog.insert          equ  13      ; "Insert DV80 file"
0088      0064     id.dialog.menu            equ  100     ; "Stevie Menu"
0089      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0090      0066     id.dialog.block           equ  102     ; "Block move/copy/delete"
0091      0067     id.dialog.help            equ  103     ; "About"
0092      0068     id.dialog.file            equ  104     ; "File"
0093      0069     id.dialog.basic           equ  105     ; "Basic"
0094               *--------------------------------------------------------------
0095               * Stevie specific equates
0096               *--------------------------------------------------------------
0097      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0098      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0099      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0100      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0101      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0102      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0103                                                      ; VDP TAT address of 1st CMDB row
0104      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0105      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0106                                                      ; VDP SIT size 80 columns, 24/30 rows
0107      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0108      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0109               *--------------------------------------------------------------
0110               * SPECTRA2 / Stevie startup options
0111               *--------------------------------------------------------------
0112      0001     debug                     equ  1       ; Turn on spectra2 debugging
0113      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0114      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0115      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0116               
0117      7E00     cpu.scrpad.src            equ  >7e00   ; \ Dump of OS monitor scratchpad
0118                                                      ; | stored in cartridge ROM
0119                                                      ; / bank3.asm
0120               
0121      F960     cpu.scrpad.tgt            equ  >f960   ; \ Destination for copy of TI Basic
0122                                                      ; | scratchpad RAM (SAMS bank #08)
0123                                                      ; /
0124               
0125               
0126               *--------------------------------------------------------------
0127               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0128               *--------------------------------------------------------------
0129      A000     core1.top         equ  >a000           ; Structure begin
0130      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0131      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0132      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0133      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0134      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0135      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0136      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0137      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0138      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0139      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0140      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0141      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0142      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0143      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0144      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0145      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0146      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0147      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0148      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0149      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0150      A02C     tibasic.status    equ  core1.top + 44  ; TI Basic status flags
0151                                                      ; 0000 = Initialize TI-Basic
0152                                                      ; 0001 = TI-Basic reentry
0153      A02E     core1.free        equ  core1.top + 46  ; End of structure
0154               *--------------------------------------------------------------
0155               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0156               *--------------------------------------------------------------
0157      A100     core2.top         equ  >a100           ; Structure begin
0158      A100     timers            equ  core2.top       ; Timer table
0159      A140     rambuf            equ  core2.top + 64  ; RAM workbuffer (160 bytes)
0160      A1E0     ramsat            equ  core2.top + 224 ; Sprite Attr. Table in RAM (14 bytes)
0161      A1EE     core2.free        equ  core2.top + 238 ; End of structure
0162               *--------------------------------------------------------------
0163               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0164               *--------------------------------------------------------------
0165      A200     tv.top            equ  >a200           ; Structure begin
0166      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0167      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0168      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0169      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0170      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0171      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0172      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0173      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0174      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0175      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0176      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0177      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0178      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0179      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0180      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0181      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0182      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0183      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0184      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0185      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0186      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0187      A22A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0188      A2CA     tv.free           equ  tv.top + 202    ; End of structure
0189               *--------------------------------------------------------------
0190               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0191               *--------------------------------------------------------------
0192      A300     fb.struct         equ  >a300           ; Structure begin
0193      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0194      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0195      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0196                                                      ; line X in editor buffer).
0197      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0198                                                      ; (offset 0 .. @fb.scrrows)
0199      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0200      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0201      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0202      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0203      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0204      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0205      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0206      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0207      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0208      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0209      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0210      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0211      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0212      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0213               *--------------------------------------------------------------
0214               * File handle structure               @>a400-a4ff   (256 bytes)
0215               *--------------------------------------------------------------
0216      A400     fh.struct         equ  >a400           ; stevie file handling structures
0217               ;***********************************************************************
0218               ; ATTENTION
0219               ; The dsrlnk variables must form a continuous memory block and keep
0220               ; their order!
0221               ;***********************************************************************
0222      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0223      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0224      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0225      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0226      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0227      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0228      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0229      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0230      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0231      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0232      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0233      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0234      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0235      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0236      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0237      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0238      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0239      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0240      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0241      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0242      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0243      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0244      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0245      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0246      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0247      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0248      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0249      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0250      A45C     fh.line           equ  fh.struct + 92  ; Editor buffer line currently processing
0251      A45E     fh.temp1          equ  fh.struct + 94  ; Temporary variable 1
0252      A460     fh.temp2          equ  fh.struct + 96  ; Temporary variable 2
0253      A462     fh.temp3          equ  fh.struct + 98  ; Temporary variable 3
0254      A464     fh.membuffer      equ  fh.struct +100  ; 80 bytes file memory buffer
0255      A4B4     fh.free           equ  fh.struct +180  ; End of structure
0256      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0257      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0258               *--------------------------------------------------------------
0259               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0260               *--------------------------------------------------------------
0261      A500     edb.struct        equ  >a500           ; Begin structure
0262      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0263      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0264      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0265      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0266      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0267      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0268      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0269      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0270      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0271      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0272                                                      ; with current filename.
0273      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0274                                                      ; with current file type.
0275      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0276      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0277      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0278                                                      ; for filename, but not always used.
0279      A569     edb.free          equ  edb.struct + 105; End of structure
0280               *--------------------------------------------------------------
0281               * Index structure                     @>a600-a6ff   (256 bytes)
0282               *--------------------------------------------------------------
0283      A600     idx.struct        equ  >a600           ; stevie index structure
0284      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0285      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0286      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0287      A606     idx.free          equ  idx.struct + 6  ; End of structure
0288               *--------------------------------------------------------------
0289               * Command buffer structure            @>a700-a7ff   (256 bytes)
0290               *--------------------------------------------------------------
0291      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0292      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0293      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0294      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0295      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0296      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0297      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0298      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0299      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0300      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0301      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0302      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0303      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0304      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0305      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0306      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0307      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0308      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0309      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0310      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0311      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0312      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0313      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0314      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0315      A7C8     cmdb.free         equ  cmdb.struct +200; End of structure
0316               *--------------------------------------------------------------
0317               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0318               *--------------------------------------------------------------
0319      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0320               *--------------------------------------------------------------
0321               * Farjump return stack                @>af00-afff   (256 bytes)
0322               *--------------------------------------------------------------
0323      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0324                                                      ; Grows downwards from high to low.
0325               *--------------------------------------------------------------
0326               * Index                               @>b000-bfff  (4096 bytes)
0327               *--------------------------------------------------------------
0328      B000     idx.top           equ  >b000           ; Top of index
0329      1000     idx.size          equ  4096            ; Index size
0330               *--------------------------------------------------------------
0331               * Editor buffer                       @>c000-cfff  (4096 bytes)
0332               *--------------------------------------------------------------
0333      C000     edb.top           equ  >c000           ; Editor buffer high memory
0334      1000     edb.size          equ  4096            ; Editor buffer size
0335               *--------------------------------------------------------------
0336               * Frame buffer                        @>d000-dfff  (4096 bytes)
0337               *--------------------------------------------------------------
0338      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0339      0960     fb.size           equ  80*30           ; Frame buffer size
0340               *--------------------------------------------------------------
0341               * Command buffer history              @>e000-efff  (4096 bytes)
0342               *--------------------------------------------------------------
0343      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0344      1000     cmdb.size         equ  4096            ; Command buffer size
0345               *--------------------------------------------------------------
0346               * Heap                                @>f000-ffff  (4096 bytes)
0347               *--------------------------------------------------------------
0348      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b1.asm.30692
0017                       copy  "data.keymap.keys.asm"; Equates for keyboard mapping
     **** ****     > data.keymap.keys.asm
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
0012      0049     key.uc.i      equ >49               ; I
0013      004E     key.uc.n      equ >4e               ; N
0014      0053     key.uc.s      equ >53               ; S
0015      004F     key.uc.o      equ >4f               ; O
0016      0051     key.uc.q      equ >51               ; Q
0017      00A2     key.lc.b      equ >a2               ; b
0018      00A5     key.lc.e      equ >a5               ; e
0019      00A6     key.lc.f      equ >a6               ; f
0020      00A8     key.lc.h      equ >a8               ; h
0021      006E     key.lc.n      equ >6e               ; n
0022      0073     key.lc.s      equ >73               ; s
0023      006F     key.lc.o      equ >6f               ; o
0024      0071     key.lc.q      equ >71               ; q
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Keyboard scancodes - Function keys
0029               *-------------|---------------------|---------------------------
0030      00BC     key.fctn.0    equ >bc               ; fctn + 0
0031      0003     key.fctn.1    equ >03               ; fctn + 1
0032      0004     key.fctn.2    equ >04               ; fctn + 2
0033      0007     key.fctn.3    equ >07               ; fctn + 3
0034      0002     key.fctn.4    equ >02               ; fctn + 4
0035      000E     key.fctn.5    equ >0e               ; fctn + 5
0036      000C     key.fctn.6    equ >0c               ; fctn + 6
0037      0001     key.fctn.7    equ >01               ; fctn + 7
0038      0006     key.fctn.8    equ >06               ; fctn + 8
0039      000F     key.fctn.9    equ >0f               ; fctn + 9
0040      0000     key.fctn.a    equ >00               ; fctn + a
0041      00BE     key.fctn.b    equ >be               ; fctn + b
0042      0000     key.fctn.c    equ >00               ; fctn + c
0043      0009     key.fctn.d    equ >09               ; fctn + d
0044      000B     key.fctn.e    equ >0b               ; fctn + e
0045      0000     key.fctn.f    equ >00               ; fctn + f
0046      0000     key.fctn.g    equ >00               ; fctn + g
0047      00BF     key.fctn.h    equ >bf               ; fctn + h
0048      0000     key.fctn.i    equ >00               ; fctn + i
0049      00C0     key.fctn.j    equ >c0               ; fctn + j
0050      00C1     key.fctn.k    equ >c1               ; fctn + k
0051      00C2     key.fctn.l    equ >c2               ; fctn + l
0052      00C3     key.fctn.m    equ >c3               ; fctn + m
0053      00C4     key.fctn.n    equ >c4               ; fctn + n
0054      0000     key.fctn.o    equ >00               ; fctn + o
0055      0000     key.fctn.p    equ >00               ; fctn + p
0056      00C5     key.fctn.q    equ >c5               ; fctn + q
0057      0000     key.fctn.r    equ >00               ; fctn + r
0058      0008     key.fctn.s    equ >08               ; fctn + s
0059      0000     key.fctn.t    equ >00               ; fctn + t
0060      0000     key.fctn.u    equ >00               ; fctn + u
0061      007F     key.fctn.v    equ >7f               ; fctn + v
0062      007E     key.fctn.w    equ >7e               ; fctn + w
0063      000A     key.fctn.x    equ >0a               ; fctn + x
0064      00C6     key.fctn.y    equ >c6               ; fctn + y
0065      0000     key.fctn.z    equ >00               ; fctn + z
0066               *---------------------------------------------------------------
0067               * Keyboard scancodes - Function keys extra
0068               *---------------------------------------------------------------
0069      00B9     key.fctn.dot    equ >b9             ; fctn + .
0070      00B8     key.fctn.comma  equ >b8             ; fctn + ,
0071      0005     key.fctn.plus   equ >05             ; fctn + +
0072               *---------------------------------------------------------------
0073               * Keyboard scancodes - control keys
0074               *-------------|---------------------|---------------------------
0075      00B0     key.ctrl.0    equ >b0               ; ctrl + 0
0076      00B1     key.ctrl.1    equ >b1               ; ctrl + 1
0077      00B2     key.ctrl.2    equ >b2               ; ctrl + 2
0078      00B3     key.ctrl.3    equ >b3               ; ctrl + 3
0079      00B4     key.ctrl.4    equ >b4               ; ctrl + 4
0080      00B5     key.ctrl.5    equ >b5               ; ctrl + 5
0081      00B6     key.ctrl.6    equ >b6               ; ctrl + 6
0082      00B7     key.ctrl.7    equ >b7               ; ctrl + 7
0083      009E     key.ctrl.8    equ >9e               ; ctrl + 8
0084      009F     key.ctrl.9    equ >9f               ; ctrl + 9
0085      0081     key.ctrl.a    equ >81               ; ctrl + a
0086      0082     key.ctrl.b    equ >82               ; ctrl + b
0087      0083     key.ctrl.c    equ >83               ; ctrl + c
0088      0084     key.ctrl.d    equ >84               ; ctrl + d
0089      0085     key.ctrl.e    equ >85               ; ctrl + e
0090      0086     key.ctrl.f    equ >86               ; ctrl + f
0091      0087     key.ctrl.g    equ >87               ; ctrl + g
0092      0088     key.ctrl.h    equ >88               ; ctrl + h
0093      0089     key.ctrl.i    equ >89               ; ctrl + i
0094      008A     key.ctrl.j    equ >8a               ; ctrl + j
0095      008B     key.ctrl.k    equ >8b               ; ctrl + k
0096      008C     key.ctrl.l    equ >8c               ; ctrl + l
0097      008D     key.ctrl.m    equ >8d               ; ctrl + m
0098      008E     key.ctrl.n    equ >8e               ; ctrl + n
0099      008F     key.ctrl.o    equ >8f               ; ctrl + o
0100      0090     key.ctrl.p    equ >90               ; ctrl + p
0101      0091     key.ctrl.q    equ >91               ; ctrl + q
0102      0092     key.ctrl.r    equ >92               ; ctrl + r
0103      0093     key.ctrl.s    equ >93               ; ctrl + s
0104      0094     key.ctrl.t    equ >94               ; ctrl + t
0105      0095     key.ctrl.u    equ >95               ; ctrl + u
0106      0096     key.ctrl.v    equ >96               ; ctrl + v
0107      0097     key.ctrl.w    equ >97               ; ctrl + w
0108      0098     key.ctrl.x    equ >98               ; ctrl + x
0109      0099     key.ctrl.y    equ >99               ; ctrl + y
0110      009A     key.ctrl.z    equ >9a               ; ctrl + z
0111               *---------------------------------------------------------------
0112               * Keyboard scancodes - control keys extra
0113               *---------------------------------------------------------------
0114      009B     key.ctrl.dot    equ >9b             ; ctrl + .
0115      0080     key.ctrl.comma  equ >80             ; ctrl + ,
0116      009D     key.ctrl.plus   equ >9d             ; ctrl + +
0117      00BB     key.ctrl.slash  equ >bb             ; ctrl + /
0118               *---------------------------------------------------------------
0119               * Special keys
0120               *---------------------------------------------------------------
0121      000D     key.enter     equ >0d               ; enter
                   < stevie_b1.asm.30692
0018               
0019               ***************************************************************
0020               * Spectra2 core configuration
0021               ********|*****|*********************|**************************
0022      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0023                                                   ; grows from high to low.
0024               ***************************************************************
0025               * BANK 1
0026               ********|*****|*********************|**************************
0027      6002     bankid  equ   bank1.rom             ; Set bank identifier to current bank
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
0045 6011   53             text  'STEVIE 1.2B'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3242     
0046                       even
0047               
0049               
                   < stevie_b1.asm.30692
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
0040                       xorg  >2000                 ; Relocate to >2000
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
     60C8 2FEA     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 60CA 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     60CC 230C     
0078 60CE 2206                   data graph1           ; \ i  p0 = pointer to video mode table
0079                                                   ; /
0080               
0081 60D0 06A0  32         bl    @ldfnt
     60D2 2374     
0082 60D4 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     60D6 000C     
0083               
0084 60D8 06A0  32         bl    @filv
     60DA 22A2     
0085 60DC 0000                   data >0000,32,32*24   ; Clear screen
     60DE 0020     
     60E0 0300     
0086               
0087 60E2 06A0  32         bl    @filv
     60E4 22A2     
0088 60E6 0380                   data >0380,>f0,32*24  ; Load color table
     60E8 00F0     
     60EA 0300     
0089                       ;------------------------------------------------------
0090                       ; Show crash address
0091                       ;------------------------------------------------------
0092 60EC 06A0  32         bl    @putat                ; Show crash message
     60EE 2456     
0093 60F0 0000                   data >0000,cpu.crash.msg.crashed
     60F2 2192     
0094               
0095 60F4 06A0  32         bl    @puthex               ; Put hex value on screen
     60F6 2AA0     
0096 60F8 0015                   byte 0,21             ; \ i  p0 = YX position
0097 60FA FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0098 60FC A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0099 60FE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0100                                                   ; /         LSB offset for ASCII digit 0-9
0101                       ;------------------------------------------------------
0102                       ; Show caller address
0103                       ;------------------------------------------------------
0104 6100 06A0  32         bl    @putat                ; Show caller message
     6102 2456     
0105 6104 0100                   data >0100,cpu.crash.msg.caller
     6106 21A8     
0106               
0107 6108 06A0  32         bl    @puthex               ; Put hex value on screen
     610A 2AA0     
0108 610C 0115                   byte 1,21             ; \ i  p0 = YX position
0109 610E FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0110 6110 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0111 6112 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0112                                                   ; /         LSB offset for ASCII digit 0-9
0113                       ;------------------------------------------------------
0114                       ; Display labels
0115                       ;------------------------------------------------------
0116 6114 06A0  32         bl    @putat
     6116 2456     
0117 6118 0300                   byte 3,0
0118 611A 21C4                   data cpu.crash.msg.wp
0119 611C 06A0  32         bl    @putat
     611E 2456     
0120 6120 0400                   byte 4,0
0121 6122 21CA                   data cpu.crash.msg.st
0122 6124 06A0  32         bl    @putat
     6126 2456     
0123 6128 1600                   byte 22,0
0124 612A 21D0                   data cpu.crash.msg.source
0125 612C 06A0  32         bl    @putat
     612E 2456     
0126 6130 1700                   byte 23,0
0127 6132 21EC                   data cpu.crash.msg.id
0128                       ;------------------------------------------------------
0129                       ; Show crash registers WP, ST, R0 - R15
0130                       ;------------------------------------------------------
0131 6134 06A0  32         bl    @at                   ; Put cursor at YX
     6136 26E2     
0132 6138 0304                   byte 3,4              ; \ i p0 = YX position
0133                                                   ; /
0134               
0135 613A 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     613C FFDC     
0136 613E 04C6  14         clr   tmp2                  ; Loop counter
0137               
0138               cpu.crash.showreg:
0139 6140 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0140               
0141 6142 0649  14         dect  stack
0142 6144 C644  30         mov   tmp0,*stack           ; Push tmp0
0143 6146 0649  14         dect  stack
0144 6148 C645  30         mov   tmp1,*stack           ; Push tmp1
0145 614A 0649  14         dect  stack
0146 614C C646  30         mov   tmp2,*stack           ; Push tmp2
0147                       ;------------------------------------------------------
0148                       ; Display crash register number
0149                       ;------------------------------------------------------
0150               cpu.crash.showreg.label:
0151 614E C046  18         mov   tmp2,r1               ; Save register number
0152 6150 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6152 0001     
0153 6154 1220  14         jle   cpu.crash.showreg.content
0154                                                   ; Yes, skip
0155               
0156 6156 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0157 6158 06A0  32         bl    @mknum
     615A 2AAA     
0158 615C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 615E A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0160 6160 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0161                                                   ; /         LSB offset for ASCII digit 0-9
0162               
0163 6162 06A0  32         bl    @setx                 ; Set cursor X position
     6164 26F8     
0164 6166 0000                   data 0                ; \ i  p0 =  Cursor Y position
0165                                                   ; /
0166               
0167 6168 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     616A 0400     
0168 616C D804  38         movb  tmp0,@rambuf          ;
     616E A140     
0169               
0170 6170 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6172 2432     
0171 6174 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0172                                                   ; /
0173               
0174 6176 06A0  32         bl    @setx                 ; Set cursor X position
     6178 26F8     
0175 617A 0002                   data 2                ; \ i  p0 =  Cursor Y position
0176                                                   ; /
0177               
0178 617C 0281  22         ci    r1,10
     617E 000A     
0179 6180 1102  14         jlt   !
0180 6182 0620  34         dec   @wyx                  ; x=x-1
     6184 832A     
0181               
0182 6186 06A0  32 !       bl    @putstr
     6188 2432     
0183 618A 21BE                   data cpu.crash.msg.r
0184               
0185 618C 06A0  32         bl    @mknum
     618E 2AAA     
0186 6190 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 6192 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 6194 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 6196 06A0  32         bl    @mkhex                ; Convert hex word to string
     6198 2A1C     
0195 619A 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 619C A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0197 619E 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0198                                                   ; /         LSB offset for ASCII digit 0-9
0199               
0200 61A0 06A0  32         bl    @setx                 ; Set cursor X position
     61A2 26F8     
0201 61A4 0004                   data 4                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61A6 06A0  32         bl    @putstr               ; Put '  >'
     61A8 2432     
0205 61AA 21C0                   data cpu.crash.msg.marker
0206               
0207 61AC 06A0  32         bl    @setx                 ; Set cursor X position
     61AE 26F8     
0208 61B0 0007                   data 7                ; \ i  p0 =  Cursor Y position
0209                                                   ; /
0210               
0211 61B2 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     61B4 0400     
0212 61B6 D804  38         movb  tmp0,@rambuf          ;
     61B8 A140     
0213               
0214 61BA 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61BC 2432     
0215 61BE A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0216                                                   ; /
0217               
0218 61C0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0219 61C2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0220 61C4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0221               
0222 61C6 06A0  32         bl    @down                 ; y=y+1
     61C8 26E8     
0223               
0224 61CA 0586  14         inc   tmp2
0225 61CC 0286  22         ci    tmp2,17
     61CE 0011     
0226 61D0 12B7  14         jle   cpu.crash.showreg     ; Show next register
0227                       ;------------------------------------------------------
0228                       ; Kernel takes over
0229                       ;------------------------------------------------------
0230 61D2 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61D4 2EDE     
0231               
0232               
0233               cpu.crash.msg.crashed
0234 61D6 15               byte  21
0235 61D7   53             text  'System crashed near >'
     61D8 7973     
     61DA 7465     
     61DC 6D20     
     61DE 6372     
     61E0 6173     
     61E2 6865     
     61E4 6420     
     61E6 6E65     
     61E8 6172     
     61EA 203E     
0236                       even
0237               
0238               cpu.crash.msg.caller
0239 61EC 15               byte  21
0240 61ED   43             text  'Caller address near >'
     61EE 616C     
     61F0 6C65     
     61F2 7220     
     61F4 6164     
     61F6 6472     
     61F8 6573     
     61FA 7320     
     61FC 6E65     
     61FE 6172     
     6200 203E     
0241                       even
0242               
0243               cpu.crash.msg.r
0244 6202 01               byte  1
0245 6203   52             text  'R'
0246                       even
0247               
0248               cpu.crash.msg.marker
0249 6204 03               byte  3
0250 6205   20             text  '  >'
     6206 203E     
0251                       even
0252               
0253               cpu.crash.msg.wp
0254 6208 04               byte  4
0255 6209   2A             text  '**WP'
     620A 2A57     
     620C 50       
0256                       even
0257               
0258               cpu.crash.msg.st
0259 620E 04               byte  4
0260 620F   2A             text  '**ST'
     6210 2A53     
     6212 54       
0261                       even
0262               
0263               cpu.crash.msg.source
0264 6214 1B               byte  27
0265 6215   53             text  'Source    stevie_b1.lst.asm'
     6216 6F75     
     6218 7263     
     621A 6520     
     621C 2020     
     621E 2073     
     6220 7465     
     6222 7669     
     6224 655F     
     6226 6231     
     6228 2E6C     
     622A 7374     
     622C 2E61     
     622E 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 6230 18               byte  24
0270 6231   42             text  'Build-ID  211106-1515410'
     6232 7569     
     6234 6C64     
     6236 2D49     
     6238 4420     
     623A 2032     
     623C 3131     
     623E 3130     
     6240 362D     
     6242 3135     
     6244 3135     
     6246 3431     
     6248 30       
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
0007 624A 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     624C 000E     
     624E 0106     
     6250 0204     
     6252 0020     
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
0032 6254 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6256 000E     
     6258 0106     
     625A 00F4     
     625C 0028     
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
0058 625E 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6260 003F     
     6262 0240     
     6264 03F4     
     6266 0050     
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
0013 6268 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 626A 16FD             data  >16fd                 ; |         jne   mcloop
0015 626C 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 626E D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6270 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 6272 0201  20         li    r1,mccode             ; Machinecode to patch
     6274 2224     
0037 6276 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6278 8322     
0038 627A CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 627C CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 627E CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 6280 045B  20         b     *r11                  ; Return to caller
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
0056 6282 C0F9  30 popr3   mov   *stack+,r3
0057 6284 C0B9  30 popr2   mov   *stack+,r2
0058 6286 C079  30 popr1   mov   *stack+,r1
0059 6288 C039  30 popr0   mov   *stack+,r0
0060 628A C2F9  30 poprt   mov   *stack+,r11
0061 628C 045B  20         b     *r11
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
0085 628E C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 6290 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 6292 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 6294 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 6296 1604  14         jne   filchk                ; No, continue checking
0093               
0094 6298 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     629A FFCE     
0095 629C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     629E 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62A0 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62A2 830B     
     62A4 830A     
0100               
0101 62A6 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62A8 0001     
0102 62AA 1602  14         jne   filchk2
0103 62AC DD05  32         movb  tmp1,*tmp0+
0104 62AE 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62B0 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62B2 0002     
0109 62B4 1603  14         jne   filchk3
0110 62B6 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62B8 DD05  32         movb  tmp1,*tmp0+
0112 62BA 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62BC C1C4  18 filchk3 mov   tmp0,tmp3
0117 62BE 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62C0 0001     
0118 62C2 1305  14         jeq   fil16b
0119 62C4 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62C6 0606  14         dec   tmp2
0121 62C8 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62CA 0002     
0122 62CC 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62CE C1C6  18 fil16b  mov   tmp2,tmp3
0127 62D0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62D2 0001     
0128 62D4 1301  14         jeq   dofill
0129 62D6 0606  14         dec   tmp2                  ; Make TMP2 even
0130 62D8 CD05  34 dofill  mov   tmp1,*tmp0+
0131 62DA 0646  14         dect  tmp2
0132 62DC 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 62DE C1C7  18         mov   tmp3,tmp3
0137 62E0 1301  14         jeq   fil.exit
0138 62E2 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 62E4 045B  20         b     *r11
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
0159 62E6 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 62E8 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 62EA C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 62EC 0264  22 xfilv   ori   tmp0,>4000
     62EE 4000     
0166 62F0 06C4  14         swpb  tmp0
0167 62F2 D804  38         movb  tmp0,@vdpa
     62F4 8C02     
0168 62F6 06C4  14         swpb  tmp0
0169 62F8 D804  38         movb  tmp0,@vdpa
     62FA 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 62FC 020F  20         li    r15,vdpw              ; Set VDP write address
     62FE 8C00     
0174 6300 06C5  14         swpb  tmp1
0175 6302 C820  54         mov   @filzz,@mcloop        ; Setup move command
     6304 22C8     
     6306 8320     
0176 6308 0460  28         b     @mcloop               ; Write data to VDP
     630A 8320     
0177               *--------------------------------------------------------------
0181 630C D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 630E 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6310 4000     
0202 6312 06C4  14 vdra    swpb  tmp0
0203 6314 D804  38         movb  tmp0,@vdpa
     6316 8C02     
0204 6318 06C4  14         swpb  tmp0
0205 631A D804  38         movb  tmp0,@vdpa            ; Set VDP address
     631C 8C02     
0206 631E 045B  20         b     *r11                  ; Exit
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
0217 6320 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6322 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 6324 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6326 4000     
0223 6328 06C4  14         swpb  tmp0                  ; \
0224 632A D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     632C 8C02     
0225 632E 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6330 D804  38         movb  tmp0,@vdpa            ; /
     6332 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 6334 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6336 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 6338 045B  20         b     *r11                  ; Exit
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
0251 633A C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 633C 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 633E D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6340 8C02     
0257 6342 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 6344 D804  38         movb  tmp0,@vdpa            ; /
     6346 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 6348 D120  34         movb  @vdpr,tmp0            ; Read byte
     634A 8800     
0263 634C 0984  56         srl   tmp0,8                ; Right align
0264 634E 045B  20         b     *r11                  ; Exit
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
0283 6350 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6352 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 6354 C144  18         mov   tmp0,tmp1
0289 6356 05C5  14         inct  tmp1
0290 6358 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 635A 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     635C FF00     
0292 635E 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 6360 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6362 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 6364 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6366 8000     
0298 6368 0206  20         li    tmp2,8
     636A 0008     
0299 636C D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     636E 830B     
0300 6370 06C5  14         swpb  tmp1
0301 6372 D805  38         movb  tmp1,@vdpa
     6374 8C02     
0302 6376 06C5  14         swpb  tmp1
0303 6378 D805  38         movb  tmp1,@vdpa
     637A 8C02     
0304 637C 0225  22         ai    tmp1,>0100
     637E 0100     
0305 6380 0606  14         dec   tmp2
0306 6382 16F4  14         jne   vidta1                ; Next register
0307 6384 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6386 833A     
0308 6388 045B  20         b     *r11
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
0325 638A C13B  30 putvr   mov   *r11+,tmp0
0326 638C 0264  22 putvrx  ori   tmp0,>8000
     638E 8000     
0327 6390 06C4  14         swpb  tmp0
0328 6392 D804  38         movb  tmp0,@vdpa
     6394 8C02     
0329 6396 06C4  14         swpb  tmp0
0330 6398 D804  38         movb  tmp0,@vdpa
     639A 8C02     
0331 639C 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 639E C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63A0 C10E  18         mov   r14,tmp0
0341 63A2 0984  56         srl   tmp0,8
0342 63A4 06A0  32         bl    @putvrx               ; Write VR#0
     63A6 2348     
0343 63A8 0204  20         li    tmp0,>0100
     63AA 0100     
0344 63AC D820  54         movb  @r14lb,@tmp0lb
     63AE 831D     
     63B0 8309     
0345 63B2 06A0  32         bl    @putvrx               ; Write VR#1
     63B4 2348     
0346 63B6 0458  20         b     *tmp4                 ; Exit
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
0360 63B8 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63BA 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63BC C11B  26         mov   *r11,tmp0             ; Get P0
0363 63BE 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63C0 7FFF     
0364 63C2 2120  38         coc   @wbit0,tmp0
     63C4 2020     
0365 63C6 1604  14         jne   ldfnt1
0366 63C8 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63CA 8000     
0367 63CC 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63CE 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63D0 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63D2 23F6     
0372 63D4 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63D6 9C02     
0373 63D8 06C4  14         swpb  tmp0
0374 63DA D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     63DC 9C02     
0375 63DE D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     63E0 9800     
0376 63E2 06C5  14         swpb  tmp1
0377 63E4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     63E6 9800     
0378 63E8 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 63EA D805  38         movb  tmp1,@grmwa
     63EC 9C02     
0383 63EE 06C5  14         swpb  tmp1
0384 63F0 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     63F2 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 63F4 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 63F6 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     63F8 22CA     
0390 63FA 05C8  14         inct  tmp4                  ; R11=R11+2
0391 63FC C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 63FE 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6400 7FFF     
0393 6402 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6404 23F8     
0394 6406 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6408 23FA     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 640A 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 640C 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 640E D120  34         movb  @grmrd,tmp0
     6410 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 6412 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6414 2020     
0405 6416 1603  14         jne   ldfnt3                ; No, so skip
0406 6418 D1C4  18         movb  tmp0,tmp3
0407 641A 0917  56         srl   tmp3,1
0408 641C E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 641E D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6420 8C00     
0413 6422 0606  14         dec   tmp2
0414 6424 16F2  14         jne   ldfnt2
0415 6426 05C8  14         inct  tmp4                  ; R11=R11+2
0416 6428 020F  20         li    r15,vdpw              ; Set VDP write address
     642A 8C00     
0417 642C 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     642E 7FFF     
0418 6430 0458  20         b     *tmp4                 ; Exit
0419 6432 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6434 2000     
     6436 8C00     
0420 6438 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 643A 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     643C 0200     
     643E 0000     
0425 6440 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6442 01C0     
     6444 0101     
0426 6446 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6448 02A0     
     644A 0101     
0427 644C 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     644E 00E0     
     6450 0101     
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
0445 6452 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 6454 C3A0  34         mov   @wyx,r14              ; Get YX
     6456 832A     
0447 6458 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 645A 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     645C 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 645E C3A0  34         mov   @wyx,r14              ; Get YX
     6460 832A     
0454 6462 024E  22         andi  r14,>00ff             ; Remove Y
     6464 00FF     
0455 6466 A3CE  18         a     r14,r15               ; pos = pos + X
0456 6468 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     646A 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 646C C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 646E C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 6470 020F  20         li    r15,vdpw              ; VDP write address
     6472 8C00     
0463 6474 045B  20         b     *r11
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
0481 6476 C17B  30 putstr  mov   *r11+,tmp1
0482 6478 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 647A C1CB  18 xutstr  mov   r11,tmp3
0484 647C 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     647E 240E     
0485 6480 C2C7  18         mov   tmp3,r11
0486 6482 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 6484 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 6486 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 6488 0286  22         ci    tmp2,255              ; Length > 255 ?
     648A 00FF     
0494 648C 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 648E 0460  28         b     @xpym2v               ; Display string
     6490 24A0     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 6492 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6494 FFCE     
0501 6496 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6498 2026     
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
0517 649A C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     649C 832A     
0518 649E 0460  28         b     @putstr
     64A0 2432     
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
0539 64A2 0649  14         dect  stack
0540 64A4 C64B  30         mov   r11,*stack            ; Save return address
0541 64A6 0649  14         dect  stack
0542 64A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64AA D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64AC 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64AE 0649  14         dect  stack
0551 64B0 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 64B2 0649  14         dect  stack
0553 64B4 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 64B6 0649  14         dect  stack
0555 64B8 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64BA 06A0  32         bl    @xutst0               ; Display string
     64BC 2434     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64BE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64C0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64C2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64C4 06A0  32         bl    @down                 ; Move cursor down
     64C6 26E8     
0566               
0567 64C8 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 64CA 0585  14         inc   tmp1                  ; Consider length byte
0569 64CC 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     64CE 2002     
0570 64D0 1301  14         jeq   !                     ; Yes, skip adjustment
0571 64D2 0585  14         inc   tmp1                  ; Make address even
0572 64D4 0606  14 !       dec   tmp2
0573 64D6 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 64D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 64DA C2F9  30         mov   *stack+,r11           ; Pop r11
0580 64DC 045B  20         b     *r11                  ; Return
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
0020 64DE C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64E0 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64E2 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 64E4 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64E6 1604  14         jne   !                     ; No, continue
0028               
0029 64E8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64EA FFCE     
0030 64EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64EE 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64F0 0264  22 !       ori   tmp0,>4000
     64F2 4000     
0035 64F4 06C4  14         swpb  tmp0
0036 64F6 D804  38         movb  tmp0,@vdpa
     64F8 8C02     
0037 64FA 06C4  14         swpb  tmp0
0038 64FC D804  38         movb  tmp0,@vdpa
     64FE 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 6500 020F  20         li    r15,vdpw              ; Set VDP write address
     6502 8C00     
0043 6504 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6506 24CA     
     6508 8320     
0044 650A 0460  28         b     @mcloop               ; Write data to VDP and return
     650C 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 650E D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6510 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6512 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6514 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6516 06C4  14 xpyv2m  swpb  tmp0
0027 6518 D804  38         movb  tmp0,@vdpa
     651A 8C02     
0028 651C 06C4  14         swpb  tmp0
0029 651E D804  38         movb  tmp0,@vdpa
     6520 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6522 020F  20         li    r15,vdpr              ; Set VDP read address
     6524 8800     
0034 6526 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6528 24EC     
     652A 8320     
0035 652C 0460  28         b     @mcloop               ; Read data from VDP
     652E 8320     
0036 6530 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6532 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6534 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6536 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6538 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 653A 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 653C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     653E FFCE     
0034 6540 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6542 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6544 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6546 0001     
0039 6548 1603  14         jne   cpym0                 ; No, continue checking
0040 654A DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 654C 04C6  14         clr   tmp2                  ; Reset counter
0042 654E 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6550 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6552 7FFF     
0047 6554 C1C4  18         mov   tmp0,tmp3
0048 6556 0247  22         andi  tmp3,1
     6558 0001     
0049 655A 1618  14         jne   cpyodd                ; Odd source address handling
0050 655C C1C5  18 cpym1   mov   tmp1,tmp3
0051 655E 0247  22         andi  tmp3,1
     6560 0001     
0052 6562 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 6564 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6566 2020     
0057 6568 1605  14         jne   cpym3
0058 656A C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     656C 254E     
     656E 8320     
0059 6570 0460  28         b     @mcloop               ; Copy memory and exit
     6572 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 6574 C1C6  18 cpym3   mov   tmp2,tmp3
0064 6576 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6578 0001     
0065 657A 1301  14         jeq   cpym4
0066 657C 0606  14         dec   tmp2                  ; Make TMP2 even
0067 657E CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 6580 0646  14         dect  tmp2
0069 6582 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 6584 C1C7  18         mov   tmp3,tmp3
0074 6586 1301  14         jeq   cpymz
0075 6588 D554  38         movb  *tmp0,*tmp1
0076 658A 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 658C 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     658E 8000     
0081 6590 10E9  14         jmp   cpym2
0082 6592 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 6594 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6596 0649  14         dect  stack
0065 6598 C64B  30         mov   r11,*stack            ; Push return address
0066 659A 0649  14         dect  stack
0067 659C C640  30         mov   r0,*stack             ; Push r0
0068 659E 0649  14         dect  stack
0069 65A0 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 65A2 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 65A4 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65A6 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65A8 4000     
0077 65AA C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65AC 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65AE 020C  20         li    r12,>1e00             ; SAMS CRU address
     65B0 1E00     
0082 65B2 04C0  14         clr   r0
0083 65B4 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65B6 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65B8 D100  18         movb  r0,tmp0
0086 65BA 0984  56         srl   tmp0,8                ; Right align
0087 65BC C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65BE 833C     
0088 65C0 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65C2 C339  30         mov   *stack+,r12           ; Pop r12
0094 65C4 C039  30         mov   *stack+,r0            ; Pop r0
0095 65C6 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65C8 045B  20         b     *r11                  ; Return to caller
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
0131 65CA C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65CC C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65CE 0649  14         dect  stack
0135 65D0 C64B  30         mov   r11,*stack            ; Push return address
0136 65D2 0649  14         dect  stack
0137 65D4 C640  30         mov   r0,*stack             ; Push r0
0138 65D6 0649  14         dect  stack
0139 65D8 C64C  30         mov   r12,*stack            ; Push r12
0140 65DA 0649  14         dect  stack
0141 65DC C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65DE 0649  14         dect  stack
0143 65E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65E2 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65E4 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 65E6 0284  22         ci    tmp0,255              ; Crash if page > 255
     65E8 00FF     
0153 65EA 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 65EC 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65EE 001E     
0158 65F0 150A  14         jgt   !
0159 65F2 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65F4 0004     
0160 65F6 1107  14         jlt   !
0161 65F8 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65FA 0012     
0162 65FC 1508  14         jgt   sams.page.set.switch_page
0163 65FE 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6600 0006     
0164 6602 1501  14         jgt   !
0165 6604 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 6606 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6608 FFCE     
0170 660A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     660C 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 660E 020C  20         li    r12,>1e00             ; SAMS CRU address
     6610 1E00     
0176 6612 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 6614 06C0  14         swpb  r0                    ; LSB to MSB
0178 6616 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6618 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     661A 4000     
0180 661C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 661E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6620 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6622 C339  30         mov   *stack+,r12           ; Pop r12
0188 6624 C039  30         mov   *stack+,r0            ; Pop r0
0189 6626 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 6628 045B  20         b     *r11                  ; Return to caller
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
0204 662A 020C  20         li    r12,>1e00             ; SAMS CRU address
     662C 1E00     
0205 662E 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6630 045B  20         b     *r11                  ; Return to caller
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
0227 6632 020C  20         li    r12,>1e00             ; SAMS CRU address
     6634 1E00     
0228 6636 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6638 045B  20         b     *r11                  ; Return to caller
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
0260 663A C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 663C 0649  14         dect  stack
0263 663E C64B  30         mov   r11,*stack            ; Save return address
0264 6640 0649  14         dect  stack
0265 6642 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 6644 0649  14         dect  stack
0267 6646 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6648 0649  14         dect  stack
0269 664A C646  30         mov   tmp2,*stack           ; Save tmp2
0270 664C 0649  14         dect  stack
0271 664E C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6650 0206  20         li    tmp2,8                ; Set loop counter
     6652 0008     
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 6654 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6656 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 6658 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     665A 258A     
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 665C 0606  14         dec   tmp2                  ; Next iteration
0288 665E 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6660 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6662 25E6     
0294                                                   ; / activating changes.
0295               
0296 6664 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 6666 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 6668 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 666A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 666C C2F9  30         mov   *stack+,r11           ; Pop r11
0301 666E 045B  20         b     *r11                  ; Return to caller
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
0318 6670 0649  14         dect  stack
0319 6672 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 6674 06A0  32         bl    @sams.layout
     6676 25F6     
0324 6678 263A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 667A C2F9  30         mov   *stack+,r11           ; Pop r11
0330 667C 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 667E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6680 0002     
0336 6682 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6684 0003     
0337 6686 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6688 000A     
0338 668A B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     668C 000B     
0339 668E C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6690 000C     
0340 6692 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     6694 000D     
0341 6696 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6698 000E     
0342 669A F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     669C 000F     
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
0363 669E C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 66A0 0649  14         dect  stack
0366 66A2 C64B  30         mov   r11,*stack            ; Push return address
0367 66A4 0649  14         dect  stack
0368 66A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66A8 0649  14         dect  stack
0370 66AA C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66AC 0649  14         dect  stack
0372 66AE C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66B0 0649  14         dect  stack
0374 66B2 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66B4 0205  20         li    tmp1,sams.layout.copy.data
     66B6 2692     
0379 66B8 0206  20         li    tmp2,8                ; Set loop counter
     66BA 0008     
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66BC C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66BE 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66C0 2552     
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66C2 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66C4 833C     
0390               
0391 66C6 0606  14         dec   tmp2                  ; Next iteration
0392 66C8 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66CA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66CC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66CE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66D0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66D2 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66D4 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66D6 2000             data  >2000                 ; >2000-2fff
0408 66D8 3000             data  >3000                 ; >3000-3fff
0409 66DA A000             data  >a000                 ; >a000-afff
0410 66DC B000             data  >b000                 ; >b000-bfff
0411 66DE C000             data  >c000                 ; >c000-cfff
0412 66E0 D000             data  >d000                 ; >d000-dfff
0413 66E2 E000             data  >e000                 ; >e000-efff
0414 66E4 F000             data  >f000                 ; >f000-ffff
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
0009 66E6 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66E8 FFBF     
0010 66EA 0460  28         b     @putv01
     66EC 235A     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66EE 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66F0 0040     
0018 66F2 0460  28         b     @putv01
     66F4 235A     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66F6 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66F8 FFDF     
0026 66FA 0460  28         b     @putv01
     66FC 235A     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66FE 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6700 0020     
0034 6702 0460  28         b     @putv01
     6704 235A     
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
0010 6706 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6708 FFFE     
0011 670A 0460  28         b     @putv01
     670C 235A     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 670E 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6710 0001     
0019 6712 0460  28         b     @putv01
     6714 235A     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6716 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6718 FFFD     
0027 671A 0460  28         b     @putv01
     671C 235A     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 671E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6720 0002     
0035 6722 0460  28         b     @putv01
     6724 235A     
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
0018 6726 C83B  50 at      mov   *r11+,@wyx
     6728 832A     
0019 672A 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 672C B820  54 down    ab    @hb$01,@wyx
     672E 2012     
     6730 832A     
0028 6732 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6734 7820  54 up      sb    @hb$01,@wyx
     6736 2012     
     6738 832A     
0037 673A 045B  20         b     *r11
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
0049 673C C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 673E D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6740 832A     
0051 6742 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6744 832A     
0052 6746 045B  20         b     *r11
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
0021 6748 C120  34 yx2px   mov   @wyx,tmp0
     674A 832A     
0022 674C C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 674E 06C4  14         swpb  tmp0                  ; Y<->X
0024 6750 04C5  14         clr   tmp1                  ; Clear before copy
0025 6752 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6754 20A0  38         coc   @wbit1,config         ; f18a present ?
     6756 201E     
0030 6758 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 675A 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     675C 833A     
     675E 2744     
0032 6760 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6762 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6764 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6766 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6768 0500     
0037 676A 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 676C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 676E 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6770 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6772 D105  18         movb  tmp1,tmp0
0051 6774 06C4  14         swpb  tmp0                  ; X<->Y
0052 6776 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6778 2020     
0053 677A 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 677C 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     677E 2012     
0059 6780 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6782 2024     
0060 6784 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6786 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6788 0050            data   80
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
0013 678A C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 678C 06A0  32         bl    @putvr                ; Write once
     678E 2346     
0015 6790 391C             data  >391c                 ; VR1/57, value 00011100
0016 6792 06A0  32         bl    @putvr                ; Write twice
     6794 2346     
0017 6796 391C             data  >391c                 ; VR1/57, value 00011100
0018 6798 06A0  32         bl    @putvr
     679A 2346     
0019 679C 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 679E 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 67A0 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 67A2 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67A4 2346     
0030 67A6 3900             data  >3900
0031 67A8 0458  20         b     *tmp4                 ; Exit
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
0043 67AA C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 67AC 06A0  32         bl    @cpym2v
     67AE 249A     
0045 67B0 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     67B2 27AA     
     67B4 0006     
0046 67B6 06A0  32         bl    @putvr
     67B8 2346     
0047 67BA 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 67BC 06A0  32         bl    @putvr
     67BE 2346     
0049 67C0 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67C2 0204  20         li    tmp0,>3f00
     67C4 3F00     
0055 67C6 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67C8 22CE     
0056 67CA D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67CC 8800     
0057 67CE 0984  56         srl   tmp0,8
0058 67D0 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67D2 8800     
0059 67D4 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 67D6 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 67D8 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67DA BFFF     
0063 67DC 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 67DE 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67E0 4000     
0066               f18chk_exit:
0067 67E2 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     67E4 22A2     
0068 67E6 3F00             data  >3f00,>00,6
     67E8 0000     
     67EA 0006     
0069 67EC 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 67EE 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 67F0 3F00             data  >3f00                 ; 3f02 / 3f00
0076 67F2 0340             data  >0340                 ; 3f04   0340  idle
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
0097 67F4 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 67F6 06A0  32         bl    @putvr
     67F8 2346     
0102 67FA 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 67FC 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67FE 2346     
0105 6800 3900             data  >3900                 ; Lock the F18a
0106 6802 0458  20         b     *tmp4                 ; Exit
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
0125 6804 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 6806 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6808 201E     
0127 680A 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 680C C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     680E 8802     
0132 6810 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6812 2346     
0133 6814 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 6816 04C4  14         clr   tmp0
0135 6818 D120  34         movb  @vdps,tmp0
     681A 8802     
0136 681C 0984  56         srl   tmp0,8
0137 681E 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6820 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6822 832A     
0018 6824 D17B  28         movb  *r11+,tmp1
0019 6826 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6828 D1BB  28         movb  *r11+,tmp2
0021 682A 0986  56         srl   tmp2,8                ; Repeat count
0022 682C C1CB  18         mov   r11,tmp3
0023 682E 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6830 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6832 020B  20         li    r11,hchar1
     6834 27F6     
0028 6836 0460  28         b     @xfilv                ; Draw
     6838 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 683A 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     683C 2022     
0033 683E 1302  14         jeq   hchar2                ; Yes, exit
0034 6840 C2C7  18         mov   tmp3,r11
0035 6842 10EE  14         jmp   hchar                 ; Next one
0036 6844 05C7  14 hchar2  inct  tmp3
0037 6846 0457  20         b     *tmp3                 ; Exit
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
0014 6848 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     684A 8334     
0015 684C 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     684E 2006     
0016 6850 0204  20         li    tmp0,muttab
     6852 281E     
0017 6854 0205  20         li    tmp1,sound            ; Sound generator port >8400
     6856 8400     
0018 6858 D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 685A D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 685C D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 685E D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 6860 045B  20         b     *r11
0023 6862 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     6864 DFFF     
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
0043 6866 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     6868 8334     
0044 686A C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     686C 8336     
0045 686E 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     6870 FFF8     
0046 6872 E0BB  30         soc   *r11+,config          ; Set options
0047 6874 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     6876 2012     
     6878 831B     
0048 687A 045B  20         b     *r11
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
0059 687C 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     687E 2006     
0060 6880 1301  14         jeq   sdpla1                ; Yes, play
0061 6882 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 6884 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 6886 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     6888 831B     
     688A 2000     
0067 688C 1301  14         jeq   sdpla3                ; Play next note
0068 688E 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6890 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6892 2002     
0070 6894 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 6896 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     6898 8336     
0075 689A 06C4  14         swpb  tmp0
0076 689C D804  38         movb  tmp0,@vdpa
     689E 8C02     
0077 68A0 06C4  14         swpb  tmp0
0078 68A2 D804  38         movb  tmp0,@vdpa
     68A4 8C02     
0079 68A6 04C4  14         clr   tmp0
0080 68A8 D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     68AA 8800     
0081 68AC 131E  14         jeq   sdexit                ; Yes. exit
0082 68AE 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 68B0 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     68B2 8336     
0084 68B4 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     68B6 8800     
     68B8 8400     
0085 68BA 0604  14         dec   tmp0
0086 68BC 16FB  14         jne   vdpla2
0087 68BE D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     68C0 8800     
     68C2 831B     
0088 68C4 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68C6 8336     
0089 68C8 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 68CA C120  34 mmplay  mov   @wsdtmp,tmp0
     68CC 8336     
0094 68CE D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 68D0 130C  14         jeq   sdexit                ; Yes, exit
0096 68D2 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 68D4 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     68D6 8336     
0098 68D8 D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     68DA 8400     
0099 68DC 0605  14         dec   tmp1
0100 68DE 16FC  14         jne   mmpla2
0101 68E0 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     68E2 831B     
0102 68E4 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68E6 8336     
0103 68E8 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 68EA 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     68EC 2004     
0108 68EE 1607  14         jne   sdexi2                ; No, exit
0109 68F0 C820  54         mov   @wsdlst,@wsdtmp
     68F2 8334     
     68F4 8336     
0110 68F6 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     68F8 2012     
     68FA 831B     
0111 68FC 045B  20 sdexi1  b     *r11                  ; Exit
0112 68FE 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     6900 FFF8     
0113 6902 045B  20         b     *r11                  ; Exit
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
0016 6904 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6906 2020     
0017 6908 020C  20         li    r12,>0024
     690A 0024     
0018 690C 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     690E 295C     
0019 6910 04C6  14         clr   tmp2
0020 6912 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6914 04CC  14         clr   r12
0025 6916 1F08  20         tb    >0008                 ; Shift-key ?
0026 6918 1302  14         jeq   realk1                ; No
0027 691A 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     691C 298C     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 691E 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6920 1302  14         jeq   realk2                ; No
0033 6922 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6924 29BC     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6926 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6928 1302  14         jeq   realk3                ; No
0039 692A 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     692C 29EC     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 692E 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     6930 200C     
0044 6932 1E15  20         sbz   >0015                 ; Set P5
0045 6934 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 6936 1302  14         jeq   realk4                ; No
0047 6938 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     693A 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 693C 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 693E 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6940 0006     
0053 6942 0606  14 realk5  dec   tmp2
0054 6944 020C  20         li    r12,>24               ; CRU address for P2-P4
     6946 0024     
0055 6948 06C6  14         swpb  tmp2
0056 694A 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 694C 06C6  14         swpb  tmp2
0058 694E 020C  20         li    r12,6                 ; CRU read address
     6950 0006     
0059 6952 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 6954 0547  14         inv   tmp3                  ;
0061 6956 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6958 FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 695A 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 695C 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 695E 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 6960 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 6962 0285  22         ci    tmp1,8
     6964 0008     
0070 6966 1AFA  14         jl    realk6
0071 6968 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 696A 1BEB  14         jh    realk5                ; No, next column
0073 696C 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 696E C206  18 realk8  mov   tmp2,tmp4
0078 6970 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 6972 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 6974 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 6976 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 6978 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 697A D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 697C 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     697E 200C     
0089 6980 1608  14         jne   realka                ; No, continue saving key
0090 6982 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6984 2986     
0091 6986 1A05  14         jl    realka
0092 6988 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     698A 2984     
0093 698C 1B02  14         jh    realka                ; No, continue
0094 698E 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     6990 E000     
0095 6992 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6994 833C     
0096 6996 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6998 200A     
0097 699A 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     699C 8C00     
0098                                                   ; / using R15 as temp storage
0099 699E 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 69A0 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     69A2 0000     
     69A4 FF0D     
     69A6 203D     
0102 69A8 7877             text  'xws29ol.'
     69AA 7332     
     69AC 396F     
     69AE 6C2E     
0103 69B0 6365             text  'ced38ik,'
     69B2 6433     
     69B4 3869     
     69B6 6B2C     
0104 69B8 7672             text  'vrf47ujm'
     69BA 6634     
     69BC 3775     
     69BE 6A6D     
0105 69C0 6274             text  'btg56yhn'
     69C2 6735     
     69C4 3679     
     69C6 686E     
0106 69C8 7A71             text  'zqa10p;/'
     69CA 6131     
     69CC 3070     
     69CE 3B2F     
0107 69D0 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     69D2 0000     
     69D4 FF0D     
     69D6 202B     
0108 69D8 5857             text  'XWS@(OL>'
     69DA 5340     
     69DC 284F     
     69DE 4C3E     
0109 69E0 4345             text  'CED#*IK<'
     69E2 4423     
     69E4 2A49     
     69E6 4B3C     
0110 69E8 5652             text  'VRF$&UJM'
     69EA 4624     
     69EC 2655     
     69EE 4A4D     
0111 69F0 4254             text  'BTG%^YHN'
     69F2 4725     
     69F4 5E59     
     69F6 484E     
0112 69F8 5A51             text  'ZQA!)P:-'
     69FA 4121     
     69FC 2950     
     69FE 3A2D     
0113 6A00 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6A02 0000     
     6A04 FF0D     
     6A06 2005     
0114 6A08 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6A0A 0804     
     6A0C 0F27     
     6A0E C2B9     
0115 6A10 600B             data  >600b,>0907,>063f,>c1B8
     6A12 0907     
     6A14 063F     
     6A16 C1B8     
0116 6A18 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6A1A 7B02     
     6A1C 015F     
     6A1E C0C3     
0117 6A20 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6A22 7D0E     
     6A24 0CC6     
     6A26 BFC4     
0118 6A28 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6A2A 7C03     
     6A2C BC22     
     6A2E BDBA     
0119 6A30 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6A32 0000     
     6A34 FF0D     
     6A36 209D     
0120 6A38 9897             data  >9897,>93b2,>9f8f,>8c9B
     6A3A 93B2     
     6A3C 9F8F     
     6A3E 8C9B     
0121 6A40 8385             data  >8385,>84b3,>9e89,>8b80
     6A42 84B3     
     6A44 9E89     
     6A46 8B80     
0122 6A48 9692             data  >9692,>86b4,>b795,>8a8D
     6A4A 86B4     
     6A4C B795     
     6A4E 8A8D     
0123 6A50 8294             data  >8294,>87b5,>b698,>888E
     6A52 87B5     
     6A54 B698     
     6A56 888E     
0124 6A58 9A91             data  >9a91,>81b1,>b090,>9cBB
     6A5A 81B1     
     6A5C B090     
     6A5E 9CBB     
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
0023 6A60 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6A62 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6A64 8340     
0025 6A66 04E0  34         clr   @waux1
     6A68 833C     
0026 6A6A 04E0  34         clr   @waux2
     6A6C 833E     
0027 6A6E 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6A70 833C     
0028 6A72 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6A74 0205  20         li    tmp1,4                ; 4 nibbles
     6A76 0004     
0033 6A78 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6A7A 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6A7C 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A7E 0286  22         ci    tmp2,>000a
     6A80 000A     
0039 6A82 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A84 C21B  26         mov   *r11,tmp4
0045 6A86 0988  56         srl   tmp4,8                ; Right justify
0046 6A88 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A8A FFF6     
0047 6A8C 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A8E C21B  26         mov   *r11,tmp4
0054 6A90 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A92 00FF     
0055               
0056 6A94 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A96 06C6  14         swpb  tmp2
0058 6A98 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A9A 0944  56         srl   tmp0,4                ; Next nibble
0060 6A9C 0605  14         dec   tmp1
0061 6A9E 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6AA0 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6AA2 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6AA4 C160  34         mov   @waux3,tmp1           ; Get pointer
     6AA6 8340     
0067 6AA8 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6AAA 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6AAC C120  34         mov   @waux2,tmp0
     6AAE 833E     
0070 6AB0 06C4  14         swpb  tmp0
0071 6AB2 DD44  32         movb  tmp0,*tmp1+
0072 6AB4 06C4  14         swpb  tmp0
0073 6AB6 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6AB8 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6ABA 8340     
0078 6ABC D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6ABE 2016     
0079 6AC0 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6AC2 C120  34         mov   @waux1,tmp0
     6AC4 833C     
0084 6AC6 06C4  14         swpb  tmp0
0085 6AC8 DD44  32         movb  tmp0,*tmp1+
0086 6ACA 06C4  14         swpb  tmp0
0087 6ACC DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6ACE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6AD0 2020     
0092 6AD2 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6AD4 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6AD6 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6AD8 7FFF     
0098 6ADA C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6ADC 8340     
0099 6ADE 0460  28         b     @xutst0               ; Display string
     6AE0 2434     
0100 6AE2 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6AE4 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6AE6 832A     
0122 6AE8 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AEA 8000     
0123 6AEC 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6AEE 0207  20 mknum   li    tmp3,5                ; Digit counter
     6AF0 0005     
0020 6AF2 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6AF4 C155  26         mov   *tmp1,tmp1            ; /
0022 6AF6 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6AF8 0228  22         ai    tmp4,4                ; Get end of buffer
     6AFA 0004     
0024 6AFC 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6AFE 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6B00 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6B02 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6B04 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6B06 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6B08 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6B0A C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6B0C 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6B0E 0607  14         dec   tmp3                  ; Decrease counter
0036 6B10 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6B12 0207  20         li    tmp3,4                ; Check first 4 digits
     6B14 0004     
0041 6B16 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6B18 C11B  26         mov   *r11,tmp0
0043 6B1A 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6B1C 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6B1E 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6B20 05CB  14 mknum3  inct  r11
0047 6B22 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B24 2020     
0048 6B26 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6B28 045B  20         b     *r11                  ; Exit
0050 6B2A DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6B2C 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6B2E 13F8  14         jeq   mknum3                ; Yes, exit
0053 6B30 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6B32 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6B34 7FFF     
0058 6B36 C10B  18         mov   r11,tmp0
0059 6B38 0224  22         ai    tmp0,-4
     6B3A FFFC     
0060 6B3C C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6B3E 0206  20         li    tmp2,>0500            ; String length = 5
     6B40 0500     
0062 6B42 0460  28         b     @xutstr               ; Display string
     6B44 2436     
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
0093 6B46 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6B48 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6B4A C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6B4C 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6B4E 0207  20         li    tmp3,5                ; Set counter
     6B50 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6B52 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6B54 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6B56 0584  14         inc   tmp0                  ; Next character
0105 6B58 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6B5A 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6B5C 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6B5E 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6B60 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6B62 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6B64 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6B66 0607  14         dec   tmp3                  ; Last character ?
0121 6B68 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6B6A 045B  20         b     *r11                  ; Return
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
0139 6B6C C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6B6E 832A     
0140 6B70 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B72 8000     
0141 6B74 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6B76 0649  14         dect  stack
0023 6B78 C64B  30         mov   r11,*stack            ; Save return address
0024 6B7A 0649  14         dect  stack
0025 6B7C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B7E 0649  14         dect  stack
0027 6B80 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B82 0649  14         dect  stack
0029 6B84 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B86 0649  14         dect  stack
0031 6B88 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B8A C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B8C C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B8E C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B90 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B92 0649  14         dect  stack
0044 6B94 C64B  30         mov   r11,*stack            ; Save return address
0045 6B96 0649  14         dect  stack
0046 6B98 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B9A 0649  14         dect  stack
0048 6B9C C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B9E 0649  14         dect  stack
0050 6BA0 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6BA2 0649  14         dect  stack
0052 6BA4 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6BA6 C1D4  26 !       mov   *tmp0,tmp3
0057 6BA8 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6BAA 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6BAC 00FF     
0059 6BAE 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6BB0 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6BB2 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6BB4 0584  14         inc   tmp0                  ; Next byte
0067 6BB6 0607  14         dec   tmp3                  ; Shorten string length
0068 6BB8 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6BBA 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6BBC 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6BBE C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6BC0 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6BC2 C187  18         mov   tmp3,tmp2
0078 6BC4 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6BC6 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6BC8 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6BCA 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6BCC 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6BCE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BD0 FFCE     
0090 6BD2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BD4 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6BD6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6BD8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6BDA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6BDC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6BDE C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6BE0 045B  20         b     *r11                  ; Return to caller
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
0123 6BE2 0649  14         dect  stack
0124 6BE4 C64B  30         mov   r11,*stack            ; Save return address
0125 6BE6 05D9  26         inct  *stack                ; Skip "data P0"
0126 6BE8 05D9  26         inct  *stack                ; Skip "data P1"
0127 6BEA 0649  14         dect  stack
0128 6BEC C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6BEE 0649  14         dect  stack
0130 6BF0 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6BF2 0649  14         dect  stack
0132 6BF4 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6BF6 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6BF8 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6BFA 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6BFC 0649  14         dect  stack
0144 6BFE C64B  30         mov   r11,*stack            ; Save return address
0145 6C00 0649  14         dect  stack
0146 6C02 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6C04 0649  14         dect  stack
0148 6C06 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6C08 0649  14         dect  stack
0150 6C0A C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6C0C 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6C0E 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6C10 0586  14         inc   tmp2
0161 6C12 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6C14 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6C16 0286  22         ci    tmp2,255
     6C18 00FF     
0167 6C1A 1505  14         jgt   string.getlenc.panic
0168 6C1C 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6C1E 0606  14         dec   tmp2                  ; One time adjustment
0174 6C20 C806  38         mov   tmp2,@waux1           ; Store length
     6C22 833C     
0175 6C24 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6C26 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C28 FFCE     
0181 6C2A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C2C 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6C2E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6C30 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6C32 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6C34 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6C36 045B  20         b     *r11                  ; Return to caller
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
0023 6C38 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6C3A F960     
0024 6C3C C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6C3E F962     
0025 6C40 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6C42 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6C44 0200  20         li    r0,>8306              ; Scratchpad source address
     6C46 8306     
0030 6C48 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6C4A F966     
0031 6C4C 0202  20         li    r2,62                 ; Loop counter
     6C4E 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 6C50 CC70  46         mov   *r0+,*r1+
0037 6C52 CC70  46         mov   *r0+,*r1+
0038 6C54 0642  14         dect  r2
0039 6C56 16FC  14         jne   cpu.scrpad.backup.copy
0040 6C58 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6C5A 83FE     
     6C5C FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6C5E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6C60 F960     
0046 6C62 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6C64 F962     
0047 6C66 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6C68 F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 6C6A 045B  20         b     *r11                  ; Return to caller
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
0069 6C6C 0649  14         dect  stack
0070 6C6E C64B  30         mov   r11,*stack            ; Save return address
0071 6C70 0649  14         dect  stack
0072 6C72 C640  30         mov   r0,*stack             ; Push r0
0073 6C74 0649  14         dect  stack
0074 6C76 C641  30         mov   r1,*stack             ; Push r1
0075 6C78 0649  14         dect  stack
0076 6C7A C642  30         mov   r2,*stack             ; Push r2
0077                       ;------------------------------------------------------
0078                       ; Prepare for copy loop, WS
0079                       ;------------------------------------------------------
0080 6C7C 0200  20         li    r0,cpu.scrpad.tgt
     6C7E F960     
0081 6C80 0201  20         li    r1,>8300
     6C82 8300     
0082 6C84 0202  20         li    r2,64
     6C86 0040     
0083                       ;------------------------------------------------------
0084                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0085                       ;------------------------------------------------------
0086               cpu.scrpad.restore.copy:
0087 6C88 CC70  46         mov   *r0+,*r1+
0088 6C8A CC70  46         mov   *r0+,*r1+
0089 6C8C 0602  14         dec   r2
0090 6C8E 16FC  14         jne   cpu.scrpad.restore.copy
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               cpu.scrpad.restore.exit:
0095 6C90 C0B9  30         mov   *stack+,r2            ; Pop r2
0096 6C92 C079  30         mov   *stack+,r1            ; Pop r1
0097 6C94 C039  30         mov   *stack+,r0            ; Pop r0
0098 6C96 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 6C98 045B  20         b     *r11                  ; Return to caller
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
0038 6C9A C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 6C9C CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 6C9E CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 6CA0 CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 6CA2 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 6CA4 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 6CA6 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 6CA8 CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 6CAA CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 6CAC 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     6CAE 8310     
0055                                                   ;        as of register r8
0056 6CB0 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     6CB2 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 6CB4 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 6CB6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 6CB8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 6CBA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 6CBC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 6CBE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 6CC0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 6CC2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 6CC4 0606  14         dec   tmp2
0069 6CC6 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 6CC8 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 6CCA 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6CCC 2C8E     
0075                                                   ; R14=PC
0076 6CCE 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 6CD0 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 6CD2 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6CD4 2C28     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 6CD6 045B  20         b     *r11                  ; Return to caller
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
0119 6CD8 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0120                       ;------------------------------------------------------
0121                       ; Copy scratchpad memory to destination
0122                       ;------------------------------------------------------
0123               xcpu.scrpad.pgin:
0124 6CDA 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6CDC 8300     
0125 6CDE 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6CE0 0010     
0126                       ;------------------------------------------------------
0127                       ; Copy memory
0128                       ;------------------------------------------------------
0129 6CE2 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0130 6CE4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0131 6CE6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0132 6CE8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0133 6CEA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0134 6CEC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0135 6CEE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0136 6CF0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0137 6CF2 0606  14         dec   tmp2
0138 6CF4 16F6  14         jne   -!                    ; Loop until done
0139                       ;------------------------------------------------------
0140                       ; Switch workspace to scratchpad memory
0141                       ;------------------------------------------------------
0142 6CF6 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6CF8 8300     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               cpu.scrpad.pgin.exit:
0147 6CFA 045B  20         b     *r11                  ; Return to caller
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
0056 6CFC A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6CFE 2CBC             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6D00 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6D02 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6D04 A428     
0064 6D06 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6D08 201C     
0065 6D0A C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6D0C 8356     
0066 6D0E C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6D10 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6D12 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6D14 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6D16 A434     
0073                       ;---------------------------; Inline VSBR start
0074 6D18 06C0  14         swpb  r0                    ;
0075 6D1A D800  38         movb  r0,@vdpa              ; Send low byte
     6D1C 8C02     
0076 6D1E 06C0  14         swpb  r0                    ;
0077 6D20 D800  38         movb  r0,@vdpa              ; Send high byte
     6D22 8C02     
0078 6D24 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6D26 8800     
0079                       ;---------------------------; Inline VSBR end
0080 6D28 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6D2A 0704  14         seto  r4                    ; Init counter
0086 6D2C 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D2E A420     
0087 6D30 0580  14 !       inc   r0                    ; Point to next char of name
0088 6D32 0584  14         inc   r4                    ; Increment char counter
0089 6D34 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6D36 0007     
0090 6D38 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6D3A 80C4  18         c     r4,r3                 ; End of name?
0093 6D3C 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6D3E 06C0  14         swpb  r0                    ;
0098 6D40 D800  38         movb  r0,@vdpa              ; Send low byte
     6D42 8C02     
0099 6D44 06C0  14         swpb  r0                    ;
0100 6D46 D800  38         movb  r0,@vdpa              ; Send high byte
     6D48 8C02     
0101 6D4A D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6D4C 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6D4E DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6D50 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6D52 2E24     
0109 6D54 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6D56 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6D58 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6D5A 04E0  34         clr   @>83d0
     6D5C 83D0     
0118 6D5E C804  38         mov   r4,@>8354             ; Save name length for search (length
     6D60 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6D62 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6D64 A432     
0121               
0122 6D66 0584  14         inc   r4                    ; Adjust for dot
0123 6D68 A804  38         a     r4,@>8356             ; Point to position after name
     6D6A 8356     
0124 6D6C C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6D6E 8356     
     6D70 A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6D72 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D74 83E0     
0130 6D76 04C1  14         clr   r1                    ; Version found of dsr
0131 6D78 020C  20         li    r12,>0f00             ; Init cru address
     6D7A 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6D7C C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6D7E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6D80 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6D82 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6D84 0100     
0145 6D86 04E0  34         clr   @>83d0                ; Clear in case we are done
     6D88 83D0     
0146 6D8A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D8C 2000     
0147 6D8E 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6D90 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6D92 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6D94 1D00  20         sbo   0                     ; Turn on ROM
0154 6D96 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6D98 4000     
0155 6D9A 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6D9C 2E20     
0156 6D9E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6DA0 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6DA2 A40A     
0166 6DA4 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6DA6 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6DA8 83D2     
0172                                                   ; subprogram
0173               
0174 6DAA 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6DAC C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6DAE 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6DB0 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6DB2 83D2     
0183                                                   ; subprogram
0184               
0185 6DB4 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6DB6 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6DB8 04C5  14         clr   r5                    ; Remove any old stuff
0194 6DBA D160  34         movb  @>8355,r5             ; Get length as counter
     6DBC 8355     
0195 6DBE 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6DC0 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6DC2 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6DC4 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6DC6 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6DC8 A420     
0206 6DCA 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6DCC 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6DCE 0605  14         dec   r5                    ; Update loop counter
0211 6DD0 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6DD2 0581  14         inc   r1                    ; Next version found
0217 6DD4 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6DD6 A42A     
0218 6DD8 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6DDA A42C     
0219 6DDC C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6DDE A430     
0220               
0221 6DE0 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6DE2 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6DE4 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6DE6 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6DE8 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6DEA 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6DEC A400     
0233 6DEE C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6DF0 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6DF2 A428     
0239                                                   ; (8 or >a)
0240 6DF4 0281  22         ci    r1,8                  ; was it 8?
     6DF6 0008     
0241 6DF8 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6DFA D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6DFC 8350     
0243                                                   ; Get error byte from @>8350
0244 6DFE 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6E00 06C0  14         swpb  r0                    ;
0252 6E02 D800  38         movb  r0,@vdpa              ; send low byte
     6E04 8C02     
0253 6E06 06C0  14         swpb  r0                    ;
0254 6E08 D800  38         movb  r0,@vdpa              ; send high byte
     6E0A 8C02     
0255 6E0C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E0E 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6E10 09D1  56         srl   r1,13                 ; just keep error bits
0263 6E12 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6E14 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6E16 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6E18 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E1A A400     
0275               dsrlnk.error.devicename_invalid:
0276 6E1C 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6E1E 06C1  14         swpb  r1                    ; put error in hi byte
0279 6E20 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6E22 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6E24 201C     
0281                                                   ; / to indicate error
0282 6E26 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6E28 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6E2A 2DE8             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6E2C 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E2E 83E0     
0316               
0317 6E30 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6E32 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6E34 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6E36 A42A     
0322 6E38 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6E3A C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6E3C C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6E3E 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6E40 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6E42 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6E44 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6E46 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E48 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6E4A 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6E4C 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6E4E 4000     
     6E50 2E20     
0337 6E52 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6E54 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6E56 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6E58 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6E5A 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6E5C A400     
0355 6E5E C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6E60 A434     
0356               
0357 6E62 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6E64 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6E66 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6E68 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6E6A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6E6C C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6E6E 0649  14         dect  stack
0052 6E70 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6E72 0204  20         li    tmp0,dsrlnk.savcru
     6E74 A42A     
0057 6E76 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6E78 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6E7A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6E7C 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6E7E 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6E80 37D7     
0065 6E82 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6E84 8370     
0066                                                   ; / location
0067 6E86 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6E88 A44C     
0068 6E8A 04C5  14         clr   tmp1                  ; io.op.open
0069 6E8C 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6E8E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6E90 0649  14         dect  stack
0097 6E92 C64B  30         mov   r11,*stack            ; Save return address
0098 6E94 0205  20         li    tmp1,io.op.close      ; io.op.close
     6E96 0001     
0099 6E98 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6E9A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6E9C 0649  14         dect  stack
0125 6E9E C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6EA0 0205  20         li    tmp1,io.op.read       ; io.op.read
     6EA2 0002     
0128 6EA4 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6EA6 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6EA8 0649  14         dect  stack
0155 6EAA C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6EAC C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6EAE 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6EB0 0005     
0159               
0160 6EB2 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6EB4 A43E     
0161               
0162 6EB6 06A0  32         bl    @xvputb               ; Write character count to PAB
     6EB8 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6EBA 0205  20         li    tmp1,io.op.write      ; io.op.write
     6EBC 0003     
0167 6EBE 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6EC0 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6EC2 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6EC4 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6EC6 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6EC8 1000  14         nop
0189               
0190               
0191               file.status:
0192 6ECA 1000  14         nop
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
0227 6ECC C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6ECE A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6ED0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6ED2 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6ED4 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6ED6 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6ED8 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6EDA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6EDC 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6EDE C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6EE0 A44C     
0246               
0247 6EE2 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6EE4 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6EE6 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6EE8 0009     
0254 6EEA C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EEC 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6EEE C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6EF0 8322     
     6EF2 833C     
0259               
0260 6EF4 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6EF6 A42A     
0261 6EF8 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6EFA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EFC 2CB8     
0268 6EFE 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6F00 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6F02 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6F04 2DE4     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6F06 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6F08 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6F0A 833C     
     6F0C 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6F0E C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6F10 A436     
0292 6F12 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F14 0005     
0293 6F16 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F18 22F8     
0294 6F1A C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6F1C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6F1E C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6F20 045B  20         b     *r11                  ; Return to caller
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
0020 6F22 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F24 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F26 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F28 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F2A 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F2C 201C     
0029 6F2E 1602  14         jne   tmgr1a                ; No, so move on
0030 6F30 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F32 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F34 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F36 2020     
0035 6F38 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F3A 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F3C 2010     
0048 6F3E 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F40 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F42 200E     
0050 6F44 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F46 0460  28         b     @kthread              ; Run kernel thread
     6F48 2F7C     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F4A 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F4C 2014     
0056 6F4E 13EB  14         jeq   tmgr1
0057 6F50 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F52 2012     
0058 6F54 16E8  14         jne   tmgr1
0059 6F56 C120  34         mov   @wtiusr,tmp0
     6F58 832E     
0060 6F5A 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F5C 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F5E 2F7A     
0065 6F60 C10A  18         mov   r10,tmp0
0066 6F62 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F64 00FF     
0067 6F66 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F68 201C     
0068 6F6A 1303  14         jeq   tmgr5
0069 6F6C 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F6E 003C     
0070 6F70 1002  14         jmp   tmgr6
0071 6F72 0284  22 tmgr5   ci    tmp0,50
     6F74 0032     
0072 6F76 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F78 1001  14         jmp   tmgr8
0074 6F7A 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F7C C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F7E 832C     
0079 6F80 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F82 FF00     
0080 6F84 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F86 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F88 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F8A 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F8C C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F8E 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F90 830C     
     6F92 830D     
0089 6F94 1608  14         jne   tmgr10                ; No, get next slot
0090 6F96 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F98 FF00     
0091 6F9A C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F9C C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F9E 8330     
0096 6FA0 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6FA2 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6FA4 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6FA6 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6FA8 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6FAA 8315     
     6FAC 8314     
0103 6FAE 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6FB0 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6FB2 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6FB4 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6FB6 10F7  14         jmp   tmgr10                ; Process next slot
0108 6FB8 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FBA FF00     
0109 6FBC 10B4  14         jmp   tmgr1
0110 6FBE 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6FC0 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FC2 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6FC4 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6FC6 2006     
0023 6FC8 1602  14         jne   kthread_kb
0024 6FCA 06A0  32         bl    @sdpla1               ; Run sound player
     6FCC 2840     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FCE 06A0  32         bl    @realkb               ; Scan full keyboard
     6FD0 28C0     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FD2 0460  28         b     @tmgr3                ; Exit
     6FD4 2F06     
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
0017 6FD6 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FD8 832E     
0018 6FDA E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FDC 2012     
0019 6FDE 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EE2     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6FE0 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FE2 832E     
0029 6FE4 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FE6 FEFF     
0030 6FE8 045B  20         b     *r11                  ; Return
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
0017 6FEA C13B  30 mkslot  mov   *r11+,tmp0
0018 6FEC C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6FEE C184  18         mov   tmp0,tmp2
0023 6FF0 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6FF2 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6FF4 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6FF6 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6FF8 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6FFA C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6FFC 881B  46         c     *r11,@w$ffff          ; End of list ?
     6FFE 2022     
0035 7000 1301  14         jeq   mkslo1                ; Yes, exit
0036 7002 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 7004 05CB  14 mkslo1  inct  r11
0041 7006 045B  20         b     *r11                  ; Exit
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
0052 7008 C13B  30 clslot  mov   *r11+,tmp0
0053 700A 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 700C A120  34         a     @wtitab,tmp0          ; Add table base
     700E 832C     
0055 7010 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7012 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 7014 045B  20         b     *r11                  ; Exit
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
0068 7016 C13B  30 rsslot  mov   *r11+,tmp0
0069 7018 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 701A A120  34         a     @wtitab,tmp0          ; Add table base
     701C 832C     
0071 701E 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 7020 C154  26         mov   *tmp0,tmp1
0073 7022 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     7024 FF00     
0074 7026 C505  30         mov   tmp1,*tmp0
0075 7028 045B  20         b     *r11                  ; Exit
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
0261 702A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     702C 8302     
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 702E 0300  24 runli1  limi  0                     ; Turn off interrupts
     7030 0000     
0267 7032 02E0  18         lwpi  ws1                   ; Activate workspace 1
     7034 8300     
0268 7036 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     7038 83C0     
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 703A 0202  20 runli2  li    r2,>8308
     703C 8308     
0273 703E 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 7040 0282  22         ci    r2,>8400
     7042 8400     
0275 7044 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 7046 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     7048 FFFF     
0280 704A 1602  14         jne   runli4                ; No, continue
0281 704C 0420  54         blwp  @0                    ; Yes, bye bye
     704E 0000     
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 7050 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7052 833C     
0286 7054 04C1  14         clr   r1                    ; Reset counter
0287 7056 0202  20         li    r2,10                 ; We test 10 times
     7058 000A     
0288 705A C0E0  34 runli5  mov   @vdps,r3
     705C 8802     
0289 705E 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7060 2020     
0290 7062 1302  14         jeq   runli6
0291 7064 0581  14         inc   r1                    ; Increase counter
0292 7066 10F9  14         jmp   runli5
0293 7068 0602  14 runli6  dec   r2                    ; Next test
0294 706A 16F7  14         jne   runli5
0295 706C 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     706E 1250     
0296 7070 1202  14         jle   runli7                ; No, so it must be NTSC
0297 7072 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     7074 201C     
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 7076 06A0  32 runli7  bl    @loadmc
     7078 222E     
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 707A 04C1  14 runli9  clr   r1
0306 707C 04C2  14         clr   r2
0307 707E 04C3  14         clr   r3
0308 7080 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     7082 AF00     
0309 7084 020F  20         li    r15,vdpw              ; Set VDP write address
     7086 8C00     
0311 7088 06A0  32         bl    @mute                 ; Mute sound generators
     708A 2804     
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 708C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     708E 4A4A     
0318 7090 1605  14         jne   runlia
0319 7092 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7094 22A2     
0320 7096 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     7098 0000     
     709A 3000     
0325 709C 06A0  32 runlia  bl    @filv
     709E 22A2     
0326 70A0 0FC0             data  pctadr,spfclr,16      ; Load color table
     70A2 00F4     
     70A4 0010     
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 70A6 06A0  32         bl    @f18unl               ; Unlock the F18A
     70A8 2746     
0334 70AA 06A0  32         bl    @f18chk               ; Check if F18A is there \
     70AC 2766     
0335 70AE 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     70B0 2766     
0336 70B2 06A0  32         bl    @f18chk               ; Check if F18A is there /
     70B4 2766     
0337 70B6 06A0  32         bl    @f18lck               ; Lock the F18A again
     70B8 275C     
0338               
0339 70BA 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     70BC 2346     
0340 70BE 3201                   data >3201            ; F18a VR50 (>32), bit 1
0342               *--------------------------------------------------------------
0343               * Check if there is a speech synthesizer attached
0344               *--------------------------------------------------------------
0346               *       <<skipped>>
0350               *--------------------------------------------------------------
0351               * Load video mode table & font
0352               *--------------------------------------------------------------
0353 70C0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70C2 230C     
0354 70C4 3458             data  spvmod                ; Equate selected video mode table
0355 70C6 0204  20         li    tmp0,spfont           ; Get font option
     70C8 000C     
0356 70CA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0357 70CC 1304  14         jeq   runlid                ; Yes, skip it
0358 70CE 06A0  32         bl    @ldfnt
     70D0 2374     
0359 70D2 1100             data  fntadr,spfont         ; Load specified font
     70D4 000C     
0360               *--------------------------------------------------------------
0361               * Did a system crash occur before runlib was called?
0362               *--------------------------------------------------------------
0363 70D6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70D8 4A4A     
0364 70DA 1602  14         jne   runlie                ; No, continue
0365 70DC 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     70DE 2086     
0366               *--------------------------------------------------------------
0367               * Branch to main program
0368               *--------------------------------------------------------------
0369 70E0 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70E2 0040     
0370 70E4 0460  28         b     @main                 ; Give control to main program
     70E6 6046     
                   < stevie_b1.asm.30692
0042                       copy  "ram.resident.asm"
     **** ****     > ram.resident.asm
0001               * FILE......: ram.resident.asm
0002               * Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules
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
0021 70E8 C13B  30         mov   *r11+,tmp0            ; P0
0022 70EA C17B  30         mov   *r11+,tmp1            ; P1
0023 70EC C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 70EE 0649  14         dect  stack
0029 70F0 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 70F2 0649  14         dect  stack
0031 70F4 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 70F6 0649  14         dect  stack
0033 70F8 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 70FA 0649  14         dect  stack
0035 70FC C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 70FE 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     7100 6000     
0040 7102 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 7104 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     7106 A226     
0044 7108 0647  14         dect  tmp3
0045 710A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 710C 0647  14         dect  tmp3
0047 710E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 7110 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     7112 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 7114 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 7116 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 7118 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 711A 0224  22         ai    tmp0,>0800
     711C 0800     
0066 711E 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 7120 0285  22         ci    tmp1,>ffff
     7122 FFFF     
0075 7124 1602  14         jne   !
0076 7126 C160  34         mov   @parm1,tmp1
     7128 A000     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 712A C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 712C 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 712E 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 7130 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7132 FFCE     
0092 7134 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7136 2026     
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 7138 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 713A C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     713C A226     
0103 713E C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 7140 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 7142 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 7144 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 7146 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 7148 028B  22         ci    r11,>6000
     714A 6000     
0116 714C 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 714E 028B  22         ci    r11,>7fff
     7150 7FFF     
0118 7152 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 7154 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     7156 A226     
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 7158 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 715A 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 715C 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 715E 0225  22         ai    tmp1,>0800
     7160 0800     
0138 7162 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 7164 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 7166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7168 FFCE     
0145 716A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     716C 2026     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 716E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 7170 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 7172 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 7174 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 7176 045B  20         b     *r11                  ; Return to caller
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
0020 7178 0649  14         dect  stack
0021 717A C64B  30         mov   r11,*stack            ; Save return address
0022 717C 0649  14         dect  stack
0023 717E C644  30         mov   tmp0,*stack           ; Push tmp0
0024 7180 0649  14         dect  stack
0025 7182 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7184 0204  20         li    tmp0,fb.top
     7186 D000     
0030 7188 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     718A A300     
0031 718C 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     718E A304     
0032 7190 04E0  34         clr   @fb.row               ; Current row=0
     7192 A306     
0033 7194 04E0  34         clr   @fb.column            ; Current column=0
     7196 A30C     
0034               
0035 7198 0204  20         li    tmp0,colrow
     719A 0050     
0036 719C C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     719E A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 71A0 C160  34         mov   @tv.ruler.visible,tmp1
     71A2 A210     
0041 71A4 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 71A6 0204  20         li    tmp0,pane.botrow-2
     71A8 001B     
0043 71AA 1002  14         jmp   fb.init.cont
0044 71AC 0204  20 !       li    tmp0,pane.botrow-1
     71AE 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 71B0 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     71B2 A31A     
0050 71B4 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     71B6 A31C     
0051               
0052 71B8 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     71BA A222     
0053 71BC 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     71BE A310     
0054 71C0 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     71C2 A316     
0055 71C4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     71C6 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 71C8 06A0  32         bl    @film
     71CA 224A     
0060 71CC D000             data  fb.top,>00,fb.size    ; Clear it all the way
     71CE 0000     
     71D0 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 71D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 71D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 71D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 71D8 045B  20         b     *r11                  ; Return to caller
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
0051 71DA 0649  14         dect  stack
0052 71DC C64B  30         mov   r11,*stack            ; Save return address
0053 71DE 0649  14         dect  stack
0054 71E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 71E2 0204  20         li    tmp0,idx.top
     71E4 B000     
0059 71E6 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     71E8 A502     
0060               
0061 71EA C120  34         mov   @tv.sams.b000,tmp0
     71EC A206     
0062 71EE C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     71F0 A600     
0063 71F2 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     71F4 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 71F6 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     71F8 0004     
0068 71FA C804  38         mov   tmp0,@idx.sams.hipage ; /
     71FC A604     
0069               
0070 71FE 06A0  32         bl    @_idx.sams.mapcolumn.on
     7200 31D8     
0071                                                   ; Index in continuous memory region
0072               
0073 7202 06A0  32         bl    @film
     7204 224A     
0074 7206 B000                   data idx.top,>00,idx.size * 5
     7208 0000     
     720A 5000     
0075                                                   ; Clear index
0076               
0077 720C 06A0  32         bl    @_idx.sams.mapcolumn.off
     720E 320C     
0078                                                   ; Restore memory window layout
0079               
0080 7210 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     7212 A602     
     7214 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 7216 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 7218 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 721A 045B  20         b     *r11                  ; Return to caller
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
0101 721C 0649  14         dect  stack
0102 721E C64B  30         mov   r11,*stack            ; Push return address
0103 7220 0649  14         dect  stack
0104 7222 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 7224 0649  14         dect  stack
0106 7226 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 7228 0649  14         dect  stack
0108 722A C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 722C C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     722E A602     
0113 7230 0205  20         li    tmp1,idx.top
     7232 B000     
0114 7234 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     7236 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 7238 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     723A 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 723C 0584  14         inc   tmp0                  ; Next SAMS index page
0123 723E 0225  22         ai    tmp1,>1000            ; Next memory region
     7240 1000     
0124 7242 0606  14         dec   tmp2                  ; Update loop counter
0125 7244 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 7246 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 7248 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 724A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 724C C2F9  30         mov   *stack+,r11           ; Pop return address
0134 724E 045B  20         b     *r11                  ; Return to caller
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
0150 7250 0649  14         dect  stack
0151 7252 C64B  30         mov   r11,*stack            ; Push return address
0152 7254 0649  14         dect  stack
0153 7256 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 7258 0649  14         dect  stack
0155 725A C645  30         mov   tmp1,*stack           ; Push tmp1
0156 725C 0649  14         dect  stack
0157 725E C646  30         mov   tmp2,*stack           ; Push tmp2
0158 7260 0649  14         dect  stack
0159 7262 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 7264 0205  20         li    tmp1,idx.top
     7266 B000     
0164 7268 0206  20         li    tmp2,5                ; Always 5 pages
     726A 0005     
0165 726C 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     726E A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 7270 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 7272 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7274 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 7276 0225  22         ai    tmp1,>1000            ; Next memory region
     7278 1000     
0176 727A 0606  14         dec   tmp2                  ; Update loop counter
0177 727C 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 727E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 7280 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 7282 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 7284 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 7286 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 7288 045B  20         b     *r11                  ; Return to caller
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
0211 728A 0649  14         dect  stack
0212 728C C64B  30         mov   r11,*stack            ; Save return address
0213 728E 0649  14         dect  stack
0214 7290 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 7292 0649  14         dect  stack
0216 7294 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 7296 0649  14         dect  stack
0218 7298 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 729A C184  18         mov   tmp0,tmp2             ; Line number
0223 729C 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 729E 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     72A0 0800     
0225               
0226 72A2 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 72A4 0A16  56         sla   tmp2,1                ; line number * 2
0231 72A6 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     72A8 A010     
0232               
0233 72AA A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     72AC A602     
0234 72AE 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     72B0 A600     
0235               
0236 72B2 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 72B4 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     72B6 A600     
0242 72B8 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     72BA A206     
0243 72BC C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 72BE 0205  20         li    tmp1,>b000            ; Memory window for index page
     72C0 B000     
0246               
0247 72C2 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     72C4 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 72C6 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     72C8 A604     
0254 72CA 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 72CC C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     72CE A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 72D0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 72D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 72D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 72D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 72D8 045B  20         b     *r11                  ; Return to caller
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
0022 72DA 0649  14         dect  stack
0023 72DC C64B  30         mov   r11,*stack            ; Save return address
0024 72DE 0649  14         dect  stack
0025 72E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72E2 06A0  32         bl    @mem.sams.layout      ; Load standard SAMS pages again
     72E4 3438     
0030               
0031 72E6 0204  20         li    tmp0,edb.top          ; \
     72E8 C000     
0032 72EA C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     72EC A500     
0033 72EE C804  38         mov   tmp0,@edb.next_free.ptr
     72F0 A508     
0034                                                   ; Set pointer to next free line
0035               
0036 72F2 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     72F4 A50A     
0037               
0038 72F6 0204  20         li    tmp0,1
     72F8 0001     
0039 72FA C804  38         mov   tmp0,@edb.lines       ; Lines=1
     72FC A504     
0040               
0041 72FE 0720  34         seto  @edb.block.m1         ; Reset block start line
     7300 A50C     
0042 7302 0720  34         seto  @edb.block.m2         ; Reset block end line
     7304 A50E     
0043               
0044 7306 0204  20         li    tmp0,txt.newfile      ; "New file"
     7308 35F0     
0045 730A C804  38         mov   tmp0,@edb.filename.ptr
     730C A512     
0046               
0047 730E 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     7310 A440     
0048 7312 04E0  34         clr   @fh.kilobytes.prev    ; /
     7314 A45A     
0049               
0050 7316 0204  20         li    tmp0,txt.filetype.none
     7318 36A2     
0051 731A C804  38         mov   tmp0,@edb.filetype.ptr
     731C A514     
0052               
0053               edb.init.exit:
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057 731E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7320 C2F9  30         mov   *stack+,r11           ; Pop r11
0059 7322 045B  20         b     *r11                  ; Return to caller
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
0022 7324 0649  14         dect  stack
0023 7326 C64B  30         mov   r11,*stack            ; Save return address
0024 7328 0649  14         dect  stack
0025 732A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 732C 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     732E E000     
0030 7330 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     7332 A700     
0031               
0032 7334 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     7336 A702     
0033 7338 0204  20         li    tmp0,4
     733A 0004     
0034 733C C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     733E A706     
0035 7340 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     7342 A708     
0036               
0037 7344 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     7346 A716     
0038 7348 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     734A A718     
0039 734C 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     734E A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7350 06A0  32         bl    @film
     7352 224A     
0044 7354 E000             data  cmdb.top,>00,cmdb.size
     7356 0000     
     7358 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 735A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 735C C2F9  30         mov   *stack+,r11           ; Pop r11
0052 735E 045B  20         b     *r11                  ; Return to caller
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
0022 7360 0649  14         dect  stack
0023 7362 C64B  30         mov   r11,*stack            ; Save return address
0024 7364 0649  14         dect  stack
0025 7366 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7368 04E0  34         clr   @tv.error.visible     ; Set to hidden
     736A A228     
0030               
0031 736C 06A0  32         bl    @film
     736E 224A     
0032 7370 A22A                   data tv.error.msg,0,160
     7372 0000     
     7374 00A0     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 7376 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 7378 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 737A 045B  20         b     *r11                  ; Return to caller
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
0022 737C 0649  14         dect  stack
0023 737E C64B  30         mov   r11,*stack            ; Save return address
0024 7380 0649  14         dect  stack
0025 7382 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7384 0204  20         li    tmp0,1                ; \ Set default color scheme
     7386 0001     
0030 7388 C804  38         mov   tmp0,@tv.colorscheme  ; /
     738A A212     
0031               
0032 738C 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     738E A224     
0033 7390 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     7392 200C     
0034               
0035 7394 0204  20         li    tmp0,fj.bottom
     7396 B000     
0036 7398 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     739A A226     
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 739C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 739E C2F9  30         mov   *stack+,r11           ; Pop R11
0043 73A0 045B  20         b     *r11                  ; Return to caller
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
0065 73A2 0649  14         dect  stack
0066 73A4 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 73A6 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     73A8 32E0     
0071 73AA 06A0  32         bl    @edb.init             ; Initialize editor buffer
     73AC 3296     
0072 73AE 06A0  32         bl    @idx.init             ; Initialize index
     73B0 3196     
0073 73B2 06A0  32         bl    @fb.init              ; Initialize framebuffer
     73B4 3134     
0074 73B6 06A0  32         bl    @errline.init         ; Initialize error line
     73B8 331C     
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 73BA 06A0  32         bl    @hchar
     73BC 27DC     
0079 73BE 0034                   byte 0,52,32,18           ; Remove markers
     73C0 2012     
0080 73C2 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     73C4 2033     
0081 73C6 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 73C8 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 73CA 045B  20         b     *r11                  ; Return to caller
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
0020 73CC 0649  14         dect  stack
0021 73CE C64B  30         mov   r11,*stack            ; Save return address
0022 73D0 0649  14         dect  stack
0023 73D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 73D4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     73D6 2AAA     
0028 73D8 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 73DA A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 73DC 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 73DD   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 73DE 0204  20         li    tmp0,unpacked.string
     73E0 A026     
0034 73E2 04F4  30         clr   *tmp0+                ; Clear string 01
0035 73E4 04F4  30         clr   *tmp0+                ; Clear string 23
0036 73E6 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 73E8 06A0  32         bl    @trimnum              ; Trim unsigned number string
     73EA 2B02     
0039 73EC A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 73EE A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 73F0 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73F6 045B  20         b     *r11                  ; Return to caller
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
0073 73F8 0649  14         dect  stack
0074 73FA C64B  30         mov   r11,*stack            ; Push return address
0075 73FC 0649  14         dect  stack
0076 73FE C644  30         mov   tmp0,*stack           ; Push tmp0
0077 7400 0649  14         dect  stack
0078 7402 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 7404 0649  14         dect  stack
0080 7406 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 7408 0649  14         dect  stack
0082 740A C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 740C C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     740E A000     
0087 7410 D194  26         movb  *tmp0,tmp2            ; /
0088 7412 0986  56         srl   tmp2,8                ; Right align
0089 7414 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 7416 8806  38         c     tmp2,@parm2           ; String length > requested length?
     7418 A002     
0092 741A 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 741C C120  34         mov   @parm1,tmp0           ; Get source address
     741E A000     
0097 7420 C160  34         mov   @parm4,tmp1           ; Get destination address
     7422 A006     
0098 7424 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 7426 0649  14         dect  stack
0101 7428 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 742A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     742C 24F4     
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 742E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 7430 C120  34         mov   @parm2,tmp0           ; Get requested length
     7432 A002     
0113 7434 0A84  56         sla   tmp0,8                ; Left align
0114 7436 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     7438 A006     
0115 743A D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 743C A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 743E 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7440 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     7442 A002     
0122 7444 6187  18         s     tmp3,tmp2             ; |
0123 7446 0586  14         inc   tmp2                  ; /
0124               
0125 7448 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     744A A004     
0126 744C 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 744E DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 7450 0606  14         dec   tmp2                  ; Update loop counter
0133 7452 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 7454 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     7456 A006     
     7458 A010     
0136 745A 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 745C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     745E FFCE     
0142 7460 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7462 2026     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 7464 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 7466 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 7468 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 746A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 746C C2F9  30         mov   *stack+,r11           ; Pop r11
0152 746E 045B  20         b     *r11                  ; Return to caller
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
0174 7470 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7472 27B0     
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 7474 04E0  34         clr   @bank0.rom            ; Activate bank 0
     7476 6000     
0179 7478 0420  54         blwp  @0                    ; Reset to monitor
     747A 0000     
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
0017 747C 0649  14         dect  stack
0018 747E C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 7480 06A0  32         bl    @sams.layout
     7482 25F6     
0023 7484 3484                   data mem.sams.layout.data
0024               
0025 7486 06A0  32         bl    @sams.layout.copy
     7488 265A     
0026 748A A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 748C C820  54         mov   @tv.sams.c000,@edb.sams.page
     748E A208     
     7490 A516     
0029 7492 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     7494 A516     
     7496 A518     
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 7498 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 749A 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0016                       copy  "data.constants.asm"     ; Data Constants
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
0033 749C 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     749E 003F     
     74A0 0243     
     74A2 05F4     
     74A4 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 74A6 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     74A8 000C     
     74AA 0006     
     74AC 0007     
     74AE 0020     
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
0067 74B0 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     74B2 000C     
     74B4 0006     
     74B6 0007     
     74B8 0020     
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
0090 74BA 0000             data  >0000,>0001           ; Cursor
     74BC 0001     
0091 74BE 0000             data  >0000,>0101           ; Current line indicator     <
     74C0 0101     
0092 74C2 0820             data  >0820,>0201           ; Current column indicator   v
     74C4 0201     
0093               nosprite:
0094 74C6 D000             data  >d000                 ; End-of-Sprites list
0095               
0096               
0097               ***************************************************************
0098               * SAMS page layout table for Stevie (16 words)
0099               *--------------------------------------------------------------
0100               mem.sams.layout.data:
0101 74C8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74CA 0002     
0102 74CC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74CE 0003     
0103 74D0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74D2 000A     
0104 74D4 B000             data  >b000,>0020           ; >b000-bfff, SAMS page >20
     74D6 0020     
0105                                                   ;   Index can allocate
0106                                                   ;   pages >20 to >3f.
0107 74D8 C000             data  >c000,>0040           ; >c000-cfff, SAMS page >40
     74DA 0040     
0108                                                   ;   Editor buffer can allocate
0109                                                   ;   pages >40 to >ff.
0110 74DC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     74DE 000D     
0111 74E0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     74E2 000E     
0112 74E4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     74E6 000F     
0113               
0114               
0115               ***************************************************************
0116               * SAMS page layout table for calling external progam (16 words)
0117               *--------------------------------------------------------------
0118               mem.sams.external:
0119 74E8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74EA 0002     
0120 74EC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74EE 0003     
0121 74F0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74F2 000A     
0122 74F4 B000             data  >b000,>0030           ; >b000-bfff, SAMS page >30
     74F6 0030     
0123 74F8 C000             data  >c000,>0031           ; >c000-cfff, SAMS page >31
     74FA 0031     
0124 74FC D000             data  >d000,>0032           ; >d000-dfff, SAMS page >32
     74FE 0032     
0125 7500 E000             data  >e000,>0033           ; >e000-efff, SAMS page >33
     7502 0033     
0126 7504 F000             data  >f000,>0034           ; >f000-ffff, SAMS page >34
     7506 0034     
0127               
0128               
0129               ***************************************************************
0130               * SAMS page layout table for TI Basic (16 words)
0131               *--------------------------------------------------------------
0132               mem.sams.tibasic:
0133 7508 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     750A 0002     
0134 750C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     750E 0003     
0135 7510 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7512 000A     
0136 7514 B000             data  >b000,>0004           ; >b000-bfff, SAMS page >04
     7516 0004     
0137 7518 C000             data  >c000,>0005           ; >c000-cfff, SAMS page >05
     751A 0005     
0138 751C D000             data  >d000,>0006           ; >d000-dfff, SAMS page >06
     751E 0006     
0139 7520 E000             data  >e000,>0007           ; >e000-efff, SAMS page >07
     7522 0007     
0140 7524 F000             data  >f000,>0008           ; >f000-ffff, SAMS page >08
     7526 0008     
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
0194 7528 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     752A F171     
     752C 1B1F     
     752E 71B1     
0195 7530 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     7532 F0FF     
     7534 1F1A     
     7536 F1FF     
0196 7538 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     753A F0FF     
     753C 1F12     
     753E F1F6     
0197 7540 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     7542 1E11     
     7544 1A17     
     7546 1E11     
0198 7548 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     754A E1FF     
     754C 1F1E     
     754E E1FF     
0199 7550 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     7552 1016     
     7554 1B71     
     7556 1711     
0200 7558 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     755A 1011     
     755C F1F1     
     755E 1F11     
0201 7560 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     7562 A1FF     
     7564 1F1F     
     7566 F11F     
0202 7568 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     756A 12FF     
     756C 1B12     
     756E 12FF     
0203 7570 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     7572 E1FF     
     7574 1B1F     
     7576 F131     
0204                       even
0205               
0206               tv.tabs.table:
0207 7578 0007             byte  0,7,12,25               ; \   Default tab positions as used
     757A 0C19     
0208 757C 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     757E 3B4F     
0209 7580 FF00             byte  >ff,0,0,0               ; |
     7582 0000     
0210 7584 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     7586 0000     
0211 7588 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     758A 0000     
0212                       even
                   < ram.resident.asm
0017                       copy  "data.strings.asm"       ; Data segment - Strings
     **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               txt.delim
0009 758C 01               byte  1
0010 758D   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 758E 05               byte  5
0015 758F   20             text  '  BOT'
     7590 2042     
     7592 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 7594 03               byte  3
0020 7595   4F             text  'OVR'
     7596 5652     
0021                       even
0022               
0023               txt.insert
0024 7598 03               byte  3
0025 7599   49             text  'INS'
     759A 4E53     
0026                       even
0027               
0028               txt.star
0029 759C 01               byte  1
0030 759D   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 759E 0A               byte  10
0035 759F   4C             text  'Loading...'
     75A0 6F61     
     75A2 6469     
     75A4 6E67     
     75A6 2E2E     
     75A8 2E       
0036                       even
0037               
0038               txt.saving
0039 75AA 0A               byte  10
0040 75AB   53             text  'Saving....'
     75AC 6176     
     75AE 696E     
     75B0 672E     
     75B2 2E2E     
     75B4 2E       
0041                       even
0042               
0043               txt.block.del
0044 75B6 12               byte  18
0045 75B7   44             text  'Deleting block....'
     75B8 656C     
     75BA 6574     
     75BC 696E     
     75BE 6720     
     75C0 626C     
     75C2 6F63     
     75C4 6B2E     
     75C6 2E2E     
     75C8 2E       
0046                       even
0047               
0048               txt.block.copy
0049 75CA 11               byte  17
0050 75CB   43             text  'Copying block....'
     75CC 6F70     
     75CE 7969     
     75D0 6E67     
     75D2 2062     
     75D4 6C6F     
     75D6 636B     
     75D8 2E2E     
     75DA 2E2E     
0051                       even
0052               
0053               txt.block.move
0054 75DC 10               byte  16
0055 75DD   4D             text  'Moving block....'
     75DE 6F76     
     75E0 696E     
     75E2 6720     
     75E4 626C     
     75E6 6F63     
     75E8 6B2E     
     75EA 2E2E     
     75EC 2E       
0056                       even
0057               
0058               txt.block.save
0059 75EE 1D               byte  29
0060 75EF   53             text  'Saving block to DV80 file....'
     75F0 6176     
     75F2 696E     
     75F4 6720     
     75F6 626C     
     75F8 6F63     
     75FA 6B20     
     75FC 746F     
     75FE 2044     
     7600 5638     
     7602 3020     
     7604 6669     
     7606 6C65     
     7608 2E2E     
     760A 2E2E     
0061                       even
0062               
0063               txt.clearmem
0064 760C 13               byte  19
0065 760D   43             text  "Clearing memory...."
     760E 6C65     
     7610 6172     
     7612 696E     
     7614 6720     
     7616 6D65     
     7618 6D6F     
     761A 7279     
     761C 2E2E     
     761E 2E2E     
0066                       even
0067               
0068               txt.fastmode
0069 7620 08               byte  8
0070 7621   46             text  'Fastmode'
     7622 6173     
     7624 746D     
     7626 6F64     
     7628 65       
0071                       even
0072               
0073               txt.kb
0074 762A 02               byte  2
0075 762B   6B             text  'kb'
     762C 62       
0076                       even
0077               
0078               txt.lines
0079 762E 05               byte  5
0080 762F   4C             text  'Lines'
     7630 696E     
     7632 6573     
0081                       even
0082               
0083               txt.newfile
0084 7634 0A               byte  10
0085 7635   5B             text  '[New file]'
     7636 4E65     
     7638 7720     
     763A 6669     
     763C 6C65     
     763E 5D       
0086                       even
0087               
0088               txt.filetype.dv80
0089 7640 04               byte  4
0090 7641   44             text  'DV80'
     7642 5638     
     7644 30       
0091                       even
0092               
0093               txt.m1
0094 7646 03               byte  3
0095 7647   4D             text  'M1='
     7648 313D     
0096                       even
0097               
0098               txt.m2
0099 764A 03               byte  3
0100 764B   4D             text  'M2='
     764C 323D     
0101                       even
0102               
0103               txt.keys.default
0104 764E 07               byte  7
0105 764F   46             text  'F9-Menu'
     7650 392D     
     7652 4D65     
     7654 6E75     
0106                       even
0107               
0108               txt.keys.block
0109 7656 2C               byte  44
0110 7657   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Goto-M1'
     7658 392D     
     765A 4261     
     765C 636B     
     765E 2020     
     7660 5E43     
     7662 6F70     
     7664 7920     
     7666 205E     
     7668 4D6F     
     766A 7665     
     766C 2020     
     766E 5E44     
     7670 656C     
     7672 2020     
     7674 5E53     
     7676 6176     
     7678 6520     
     767A 205E     
     767C 476F     
     767E 746F     
     7680 2D4D     
     7682 31       
0111                       even
0112               
0113 7684 2E2E     txt.ruler          text    '.........'
     7686 2E2E     
     7688 2E2E     
     768A 2E2E     
     768C 2E       
0114 768D   12                        byte    18
0115 768E 2E2E                        text    '.........'
     7690 2E2E     
     7692 2E2E     
     7694 2E2E     
     7696 2E       
0116 7697   13                        byte    19
0117 7698 2E2E                        text    '.........'
     769A 2E2E     
     769C 2E2E     
     769E 2E2E     
     76A0 2E       
0118 76A1   14                        byte    20
0119 76A2 2E2E                        text    '.........'
     76A4 2E2E     
     76A6 2E2E     
     76A8 2E2E     
     76AA 2E       
0120 76AB   15                        byte    21
0121 76AC 2E2E                        text    '.........'
     76AE 2E2E     
     76B0 2E2E     
     76B2 2E2E     
     76B4 2E       
0122 76B5   16                        byte    22
0123 76B6 2E2E                        text    '.........'
     76B8 2E2E     
     76BA 2E2E     
     76BC 2E2E     
     76BE 2E       
0124 76BF   17                        byte    23
0125 76C0 2E2E                        text    '.........'
     76C2 2E2E     
     76C4 2E2E     
     76C6 2E2E     
     76C8 2E       
0126 76C9   18                        byte    24
0127 76CA 2E2E                        text    '.........'
     76CC 2E2E     
     76CE 2E2E     
     76D0 2E2E     
     76D2 2E       
0128 76D3   19                        byte    25
0129                                  even
0130 76D4 020E     txt.alpha.down     data >020e,>0f00
     76D6 0F00     
0131 76D8 0110     txt.vertline       data >0110
0132 76DA 011C     txt.keymarker      byte 1,28
0133               
0134               txt.ws1
0135 76DC 01               byte  1
0136 76DD   20             text  ' '
0137                       even
0138               
0139               txt.ws2
0140 76DE 02               byte  2
0141 76DF   20             text  '  '
     76E0 20       
0142                       even
0143               
0144               txt.ws3
0145 76E2 03               byte  3
0146 76E3   20             text  '   '
     76E4 2020     
0147                       even
0148               
0149               txt.ws4
0150 76E6 04               byte  4
0151 76E7   20             text  '    '
     76E8 2020     
     76EA 20       
0152                       even
0153               
0154               txt.ws5
0155 76EC 05               byte  5
0156 76ED   20             text  '     '
     76EE 2020     
     76F0 2020     
0157                       even
0158               
0159      36A2     txt.filetype.none  equ txt.ws4
0160               
0161               
0162               ;--------------------------------------------------------------
0163               ; Strings for error line pane
0164               ;--------------------------------------------------------------
0165               txt.ioerr.load
0166 76F2 20               byte  32
0167 76F3   49             text  'I/O error. Failed loading file: '
     76F4 2F4F     
     76F6 2065     
     76F8 7272     
     76FA 6F72     
     76FC 2E20     
     76FE 4661     
     7700 696C     
     7702 6564     
     7704 206C     
     7706 6F61     
     7708 6469     
     770A 6E67     
     770C 2066     
     770E 696C     
     7710 653A     
     7712 20       
0168                       even
0169               
0170               txt.ioerr.save
0171 7714 20               byte  32
0172 7715   49             text  'I/O error. Failed saving file:  '
     7716 2F4F     
     7718 2065     
     771A 7272     
     771C 6F72     
     771E 2E20     
     7720 4661     
     7722 696C     
     7724 6564     
     7726 2073     
     7728 6176     
     772A 696E     
     772C 6720     
     772E 6669     
     7730 6C65     
     7732 3A20     
     7734 20       
0173                       even
0174               
0175               txt.memfull.load
0176 7736 40               byte  64
0177 7737   49             text  'Index memory full. Could not fully load file into editor buffer.'
     7738 6E64     
     773A 6578     
     773C 206D     
     773E 656D     
     7740 6F72     
     7742 7920     
     7744 6675     
     7746 6C6C     
     7748 2E20     
     774A 436F     
     774C 756C     
     774E 6420     
     7750 6E6F     
     7752 7420     
     7754 6675     
     7756 6C6C     
     7758 7920     
     775A 6C6F     
     775C 6164     
     775E 2066     
     7760 696C     
     7762 6520     
     7764 696E     
     7766 746F     
     7768 2065     
     776A 6469     
     776C 746F     
     776E 7220     
     7770 6275     
     7772 6666     
     7774 6572     
     7776 2E       
0178                       even
0179               
0180               txt.io.nofile
0181 7778 21               byte  33
0182 7779   49             text  'I/O error. No filename specified.'
     777A 2F4F     
     777C 2065     
     777E 7272     
     7780 6F72     
     7782 2E20     
     7784 4E6F     
     7786 2066     
     7788 696C     
     778A 656E     
     778C 616D     
     778E 6520     
     7790 7370     
     7792 6563     
     7794 6966     
     7796 6965     
     7798 642E     
0183                       even
0184               
0185               txt.block.inside
0186 779A 34               byte  52
0187 779B   45             text  'Error. Copy/Move target must be outside block M1-M2.'
     779C 7272     
     779E 6F72     
     77A0 2E20     
     77A2 436F     
     77A4 7079     
     77A6 2F4D     
     77A8 6F76     
     77AA 6520     
     77AC 7461     
     77AE 7267     
     77B0 6574     
     77B2 206D     
     77B4 7573     
     77B6 7420     
     77B8 6265     
     77BA 206F     
     77BC 7574     
     77BE 7369     
     77C0 6465     
     77C2 2062     
     77C4 6C6F     
     77C6 636B     
     77C8 204D     
     77CA 312D     
     77CC 4D32     
     77CE 2E       
0188                       even
0189               
0190               
0191               ;--------------------------------------------------------------
0192               ; Strings for command buffer
0193               ;--------------------------------------------------------------
0194               txt.cmdb.prompt
0195 77D0 01               byte  1
0196 77D1   3E             text  '>'
0197                       even
0198               
0199               txt.colorscheme
0200 77D2 0D               byte  13
0201 77D3   43             text  'Color scheme:'
     77D4 6F6C     
     77D6 6F72     
     77D8 2073     
     77DA 6368     
     77DC 656D     
     77DE 653A     
0202                       even
0203               
                   < ram.resident.asm
                   < stevie_b1.asm.30692
0043                       ;------------------------------------------------------
0044                       ; Activate bank 1 and branch to  >6036
0045                       ;------------------------------------------------------
0046 77E0 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     77E2 6002     
0047               
0051               
0052 77E4 0460  28         b     @kickstart.code2      ; Jump to entry routine
     77E6 6046     
0053               ***************************************************************
0054               * Step 3: Include main editor modules
0055               ********|*****|*********************|**************************
0056               main:
0057                       aorg  kickstart.code2       ; >6046
0058 6046 0460  28         b     @main.stevie          ; Start editor
     6048 604A     
0059                       ;-----------------------------------------------------------------------
0060                       ; Include files
0061                       ;-----------------------------------------------------------------------
0062                       copy  "main.asm"            ; Main file (entrypoint)
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
     6054 2804     
0037 6056 06A0  32         bl    @scroff               ; Turn screen off
     6058 26A2     
0038               
0039 605A 06A0  32         bl    @f18unl               ; Unlock the F18a
     605C 2746     
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
0065                       ; Setup SAMS windows
0066                       ;------------------------------------------------------
0067 6084 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6086 3438     
0068                       ;------------------------------------------------------
0069                       ; Setup cursor, screen, etc.
0070                       ;------------------------------------------------------
0071 6088 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608A 26C2     
0072 608C 06A0  32         bl    @s8x8                 ; Small sprite
     608E 26D2     
0073               
0074 6090 06A0  32         bl    @cpym2m
     6092 24EE     
0075 6094 3476                   data romsat,ramsat,14 ; Load sprite SAT
     6096 A1E0     
     6098 000E     
0076               
0077 609A C820  54         mov   @romsat+2,@tv.curshape
     609C 3478     
     609E A214     
0078                                                   ; Save cursor shape & color
0079               
0080 60A0 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     60A2 7CD8     
0081               *--------------------------------------------------------------
0082               * Initialize
0083               *--------------------------------------------------------------
0084 60A4 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A6 3338     
0085 60A8 06A0  32         bl    @tv.reset             ; Reset editor
     60AA 335E     
0086                       ;------------------------------------------------------
0087                       ; Load colorscheme amd turn on screen
0088                       ;------------------------------------------------------
0089 60AC 06A0  32         bl    @pane.action.colorscheme.Load
     60AE 7766     
0090                                                   ; Load color scheme and turn on screen
0091                       ;-------------------------------------------------------
0092                       ; Setup editor tasks & hook
0093                       ;-------------------------------------------------------
0094 60B0 0204  20         li    tmp0,>0300
     60B2 0300     
0095 60B4 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60B6 8314     
0096               
0097 60B8 06A0  32         bl    @at
     60BA 26E2     
0098 60BC 0000                   data  >0000           ; Cursor YX position = >0000
0099               
0100 60BE 0204  20         li    tmp0,timers
     60C0 A100     
0101 60C2 C804  38         mov   tmp0,@wtitab
     60C4 832C     
0102               
0104               
0105 60C6 06A0  32         bl    @mkslot
     60C8 2FA6     
0106 60CA 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CC 75FE     
0107 60CE 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60D0 760C     
0108 60D2 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D4 76AE     
0109 60D6 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D8 76DC     
0110 60DA FFFF                   data eol
0111               
0121               
0122               
0123 60DC 06A0  32         bl    @mkhook
     60DE 2F92     
0124 60E0 75A8                   data hook.keyscan     ; Setup user hook
0125               
0126 60E2 0460  28         b     @tmgr                 ; Start timers and kthread
     60E4 2EDE     
                   < stevie_b1.asm.30692
0063                       ;-----------------------------------------------------------------------
0064                       ; Keyboard actions
0065                       ;-----------------------------------------------------------------------
0066                       copy  "edkey.key.process.asm"
     **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 60E6 C160  34         mov   @waux1,tmp1           ; \
     60E8 833C     
0009 60EA 0245  22         andi  tmp1,>ff00            ; | Get key value and clear LSB
     60EC FF00     
0010 60EE C805  38         mov   tmp1,@waux1           ; /
     60F0 833C     
0011 60F2 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 60F4 C1A0  34         mov   @tv.pane.focus,tmp2
     60F6 A222     
0016 60F8 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60FA 0000     
0017 60FC 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 60FE 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6100 0001     
0021 6102 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 6104 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6106 FFCE     
0027 6108 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     610A 2026     
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 610C 0206  20         li    tmp2,keymap_actions.editor
     610E 7E92     
0033 6110 1002  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6112 0206  20         li    tmp2,keymap_actions.cmdb
     6114 7F3C     
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 6116 91D6  26         cb    *tmp2,tmp3            ; EOL reached ?
0044 6118 1327  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed, so
0046                                                   ; add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 611A 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0051 611C 130F  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053                       ;-------------------------------------------------------
0054                       ; If key in range 'a..z' then also check 'A..Z'
0055                       ;-------------------------------------------------------
0056 611E 0285  22         ci    tmp1,>6100            ; ASCII 97 'a'
     6120 6100     
0057 6122 1109  14         jlt   edkey.key.check.next.entry
0058               
0059 6124 0285  22         ci    tmp1,>7a00            ; ASCII 122 'z'
     6126 7A00     
0060 6128 1506  14         jgt   edkey.key.check.next.entry
0061               
0062 612A 0225  22         ai    tmp1,->2000           ; Make uppercase
     612C E000     
0063 612E 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0064 6130 1305  14         jeq   edkey.key.check.scope
0065                                                   ; Yes, check scope
0066                       ;-------------------------------------------------------
0067                       ; Key is no action key, keep case for later (buffer)
0068                       ;-------------------------------------------------------
0069 6132 0225  22         ai    tmp1,>2000            ; Make lowercase
     6134 2000     
0070               
0071               edkey.key.check.next.entry:
0072 6136 0226  22         ai    tmp2,4                ; Skip current entry
     6138 0004     
0073 613A 10ED  14         jmp   edkey.key.check.next  ; Check next entry
0074                       ;-------------------------------------------------------
0075                       ; Check scope of key
0076                       ;-------------------------------------------------------
0077               edkey.key.check.scope:
0078 613C 0586  14         inc   tmp2                  ; Move to scope
0079 613E 9816  46         cb    *tmp2,@tv.pane.focus+1
     6140 A223     
0080                                                   ; (1) Process key if scope matches pane
0081 6142 1308  14         jeq   edkey.key.process.action
0082               
0083 6144 9816  46         cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
     6146 A71B     
0084 6148 1305  14         jeq   edkey.key.process.action
0085                       ;-------------------------------------------------------
0086                       ; Key pressed outside valid scope, ignore action entry
0087                       ;-------------------------------------------------------
0088 614A 0226  22         ai    tmp2,3                ; Skip current entry
     614C 0003     
0089 614E C160  34         mov   @waux1,tmp1           ; Restore original case of key
     6150 833C     
0090 6152 10E1  14         jmp   edkey.key.check.next  ; Process next action entry
0091                       ;-------------------------------------------------------
0092                       ; Trigger keyboard action
0093                       ;-------------------------------------------------------
0094               edkey.key.process.action:
0095 6154 0586  14         inc   tmp2                  ; Move to action address
0096 6156 C196  26         mov   *tmp2,tmp2            ; Get action address
0097               
0098 6158 0204  20         li    tmp0,id.dialog.unsaved
     615A 0065     
0099 615C 8120  34         c     @cmdb.dialog,tmp0
     615E A71A     
0100 6160 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0101               
0102 6162 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6164 A726     
0103 6166 0456  20 !       b     *tmp2                 ; Process key action
0104                       ;-------------------------------------------------------
0105                       ; Add character to editor or cmdb buffer
0106                       ;-------------------------------------------------------
0107               edkey.key.process.addbuffer:
0108 6168 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     616A A222     
0109 616C 1602  14         jne   !                     ; No, skip frame buffer
0110 616E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6170 664A     
0111                       ;-------------------------------------------------------
0112                       ; CMDB buffer
0113                       ;-------------------------------------------------------
0114 6172 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6174 0001     
0115 6176 1607  14         jne   edkey.key.process.crash
0116                                                   ; No, crash
0117                       ;-------------------------------------------------------
0118                       ; Don't add character if dialog has ID >= 100
0119                       ;-------------------------------------------------------
0120 6178 C120  34         mov   @cmdb.dialog,tmp0
     617A A71A     
0121 617C 0284  22         ci    tmp0,99
     617E 0063     
0122 6180 1506  14         jgt   edkey.key.process.exit
0123                       ;-------------------------------------------------------
0124                       ; Add character to CMDB
0125                       ;-------------------------------------------------------
0126 6182 0460  28         b     @edkey.action.cmdb.char
     6184 687C     
0127                                                   ; Add character to CMDB buffer
0128                       ;-------------------------------------------------------
0129                       ; Crash
0130                       ;-------------------------------------------------------
0131               edkey.key.process.crash:
0132 6186 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6188 FFCE     
0133 618A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     618C 2026     
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137               edkey.key.process.exit:
0138 618E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6190 75F2     
                   < stevie_b1.asm.30692
0067                                                   ; Process keyboard actions
0068                       ;-----------------------------------------------------------------------
0069                       ; Keyboard actions - Framebuffer (1)
0070                       ;-----------------------------------------------------------------------
0071                       copy  "edkey.fb.mov.leftright.asm"
     **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 6192 C120  34         mov   @fb.column,tmp0
     6194 A30C     
0009 6196 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6198 0620  34         dec   @fb.column            ; Column-- in screen buffer
     619A A30C     
0014 619C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     619E 832A     
0015 61A0 0620  34         dec   @fb.current
     61A2 A302     
0016 61A4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61A6 A318     
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 61A8 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61AA 75F2     
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 61AC 8820  54         c     @fb.column,@fb.row.length
     61AE A30C     
     61B0 A308     
0028 61B2 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 61B4 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     61B6 A30C     
0033 61B8 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     61BA 832A     
0034 61BC 05A0  34         inc   @fb.current
     61BE A302     
0035 61C0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C2 A318     
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 61C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61C6 75F2     
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61C8 06A0  32         bl    @fb.cursor.home       ; Move cursor to beginning of line
     61CA 6B88     
0047                       ;-------------------------------------------------------
0048                       ; Exit
0049                       ;-------------------------------------------------------
0050 61CC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61CE 75F2     
0051               
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.end:
0057 61D0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61D2 A318     
0058 61D4 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61D6 A308     
0059 61D8 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61DA 0050     
0060 61DC 1102  14         jlt   !                     ; | is right of last character on line,
0061 61DE 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61E0 004F     
0062                       ;-------------------------------------------------------
0063                       ; Set cursor X position
0064                       ;-------------------------------------------------------
0065 61E2 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61E4 A30C     
0066 61E6 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61E8 26FA     
0067 61EA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61EC 6A8A     
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071 61EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61F0 75F2     
                   < stevie_b1.asm.30692
0072                                                        ; Move left / right / home / end
0073                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
     **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61F2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61F4 A318     
0009 61F6 C120  34         mov   @fb.column,tmp0
     61F8 A30C     
0010 61FA 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61FC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61FE A302     
0015 6200 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 6202 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 6204 0605  14         dec   tmp1
0022 6206 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 6208 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 620A D195  26         movb  *tmp1,tmp2            ; Get character
0030 620C 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 620E D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 6210 0986  56         srl   tmp2,8                ; Right justify
0033 6212 0286  22         ci    tmp2,32               ; Space character found?
     6214 0020     
0034 6216 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 6218 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     621A 2020     
0040 621C 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 621E 0287  22         ci    tmp3,>20ff            ; First character is space
     6220 20FF     
0043 6222 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 6224 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6226 A30C     
0048 6228 61C4  18         s     tmp0,tmp3
0049 622A 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     622C 0002     
0050 622E 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 6230 0585  14         inc   tmp1
0056 6232 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 6234 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6236 A30C     
0062 6238 06A0  32         bl    @xsetx                ; Set VDP cursor X
     623A 26FA     
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 623C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     623E 6A8A     
0068 6240 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6242 75F2     
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 6244 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6246 A318     
0077 6248 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 624A C120  34         mov   @fb.column,tmp0
     624C A30C     
0079 624E 8804  38         c     tmp0,@fb.row.length
     6250 A308     
0080 6252 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 6254 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6256 A302     
0085 6258 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 625A 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 625C 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 625E 0585  14         inc   tmp1
0097 6260 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6262 8804  38         c     tmp0,@fb.row.length
     6264 A308     
0099 6266 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6268 D195  26         movb  *tmp1,tmp2            ; Get character
0106 626A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 626C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 626E 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6270 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6272 FFFF     
0111 6274 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 6276 0286  22         ci    tmp2,32
     6278 0020     
0117 627A 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 627C 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 627E 0286  22         ci    tmp2,32               ; Space character found?
     6280 0020     
0125 6282 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 6284 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6286 2020     
0131 6288 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 628A 0287  22         ci    tmp3,>20ff            ; First characer is space?
     628C 20FF     
0134 628E 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 6290 0585  14         inc   tmp1
0139 6292 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 6294 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6296 A30C     
0145 6298 06A0  32         bl    @xsetx                ; Set VDP cursor X
     629A 26FA     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 629C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     629E 6A8A     
0151 62A0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62A2 75F2     
0152               
0153               
                   < stevie_b1.asm.30692
0074                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
     **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 62A4 06A0  32         bl    @fb.cursor.up         ; Move cursor up
     62A6 6AB2     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.up.exit:
0013 62A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62AA 75F2     
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Cursor down
0019               *---------------------------------------------------------------
0020               edkey.action.down:
0021 62AC 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     62AE 6B10     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.down.exit:
0026 62B0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62B2 75F2     
                   < stevie_b1.asm.30692
0075                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
     **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 62B4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62B6 A318     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 62B8 8820  54         c     @fb.row.dirty,@w$ffff
     62BA A30A     
     62BC 2022     
0013 62BE 1604  14         jne   edkey.action.ppage.sanity
0014 62C0 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62C2 6F5E     
0015 62C4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62C6 A30A     
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 62C8 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     62CA A304     
0021 62CC 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 62CE 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     62D0 A31A     
0026 62D2 1503  14         jgt   edkey.action.ppage.topline
0027 62D4 04E0  34         clr   @fb.topline           ; topline = 0
     62D6 A304     
0028 62D8 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 62DA 6820  54         s     @fb.scrrows,@fb.topline
     62DC A31A     
     62DE A304     
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 62E0 C820  54         mov   @fb.topline,@parm1
     62E2 A304     
     62E4 A000     
0039 62E6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62E8 A310     
0040               
0041 62EA 1070  14         jmp   edkey.goto.fb.toprow  ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 62EC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62EE 75F2     
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 62F0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62F2 A318     
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 62F4 8820  54         c     @fb.row.dirty,@w$ffff
     62F6 A30A     
     62F8 2022     
0061 62FA 1604  14         jne   edkey.action.npage.sanity
0062 62FC 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62FE 6F5E     
0063 6300 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6302 A30A     
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 6304 C120  34         mov   @fb.topline,tmp0
     6306 A304     
0069 6308 A120  34         a     @fb.scrrows,tmp0
     630A A31A     
0070 630C 0584  14         inc   tmp0                  ; Base 1 offset !
0071 630E 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6310 A504     
0072 6312 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 6314 A820  54         a     @fb.scrrows,@fb.topline
     6316 A31A     
     6318 A304     
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 631A C820  54         mov   @fb.topline,@parm1
     631C A304     
     631E A000     
0083 6320 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6322 A310     
0084               
0085 6324 1053  14         jmp   edkey.goto.fb.toprow  ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 6326 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6328 75F2     
                   < stevie_b1.asm.30692
0076                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
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
0011 632A 8820  54         c     @fb.row.dirty,@w$ffff
     632C A30A     
     632E 2022     
0012 6330 1604  14         jne   edkey.action.top.refresh
0013 6332 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6334 6F5E     
0014 6336 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6338 A30A     
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 633A 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     633C A000     
0020 633E 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6340 A310     
0021               
0022 6342 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6344 63CC     
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
0033 6346 8820  54         c     @fb.row.dirty,@w$ffff
     6348 A30A     
     634A 2022     
0034 634C 1604  14         jne   edkey.action.topscr.refresh
0035 634E 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6350 6F5E     
0036 6352 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6354 A30A     
0037               edkey.action.topscr.refresh:
0038 6356 C820  54         mov   @fb.topline,@parm1    ; Set to top line in frame buffer
     6358 A304     
     635A A000     
0039 635C 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     635E 63CC     
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
0051 6360 8820  54         c     @fb.row.dirty,@w$ffff
     6362 A30A     
     6364 2022     
0052 6366 1604  14         jne   edkey.action.bot.refresh
0053 6368 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     636A 6F5E     
0054 636C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     636E A30A     
0055                       ;-------------------------------------------------------
0056                       ; Refresh page
0057                       ;-------------------------------------------------------
0058               edkey.action.bot.refresh:
0059 6370 8820  54         c     @edb.lines,@fb.scrrows
     6372 A504     
     6374 A31A     
0060 6376 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0061               
0062 6378 C120  34         mov   @edb.lines,tmp0
     637A A504     
0063 637C 6120  34         s     @fb.scrrows,tmp0
     637E A31A     
0064 6380 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6382 A000     
0065 6384 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6386 A310     
0066               
0067 6388 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     638A 63CC     
0068                                                   ; / i  @parm1 = Line in editor buffer
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               edkey.action.bot.exit:
0073 638C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     638E 75F2     
0074               
0075               
0076               
0077               *---------------------------------------------------------------
0078               * Goto bottom of screen
0079               *---------------------------------------------------------------
0080               edkey.action.botscr:
0081 6390 0649  14         dect  stack
0082 6392 C644  30         mov   tmp0,*stack           ; Push tmp0
0083                       ;-------------------------------------------------------
0084                       ; Crunch current row if dirty
0085                       ;-------------------------------------------------------
0086 6394 8820  54         c     @fb.row.dirty,@w$ffff
     6396 A30A     
     6398 2022     
0087 639A 16EA  14         jne   edkey.action.bot.refresh
0088 639C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     639E 6F5E     
0089 63A0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63A2 A30A     
0090                       ;-------------------------------------------------------
0091                       ; Refresh page
0092                       ;-------------------------------------------------------
0093               edkey.action.botscr.refresh:
0094 63A4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63A6 A318     
0095               
0096 63A8 C820  54         mov   @fb.scrrows,@fb.row   ; Frame buffer bottom line
     63AA A31A     
     63AC A306     
0097 63AE 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63B0 A30C     
0098               
0099 63B2 C120  34         mov   @fb.row,tmp0
     63B4 A306     
0100 63B6 0A84  56         sla   tmp0,8
0101 63B8 C820  54         mov   @tmp0,@wyx
     63BA 0004     
     63BC 832A     
0102               
0103 63BE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63C0 6A8A     
0104               
0105 63C2 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63C4 7158     
0106                                                   ; | i  @fb.row        = Row in frame buffer
0107                                                   ; / o  @fb.row.length = Length of row
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               edkey.action.botscr.exit:
0112 63C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0113 63C8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63CA 75F2     
                   < stevie_b1.asm.30692
0077                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
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
0022 63CC 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63CE A318     
0023               
0024 63D0 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     63D2 6C7A     
0025                                                   ; | i  @parm1 = Line to start with
0026                                                   ; /             (becomes @fb.topline)
0027               
0028 63D4 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63D6 A306     
0029 63D8 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63DA A30C     
0030 63DC 04E0  34         clr   @wyx                  ; Position VDP cursor
     63DE 832A     
0031 63E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63E2 6A8A     
0032               
0033 63E4 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63E6 7158     
0034                                                   ; | i  @fb.row        = Row in frame buffer
0035                                                   ; / o  @fb.row.length = Length of row
0036               
0037 63E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63EA 75F2     
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Goto specified line (@parm1) in editor buffer
0042               *---------------------------------------------------------------
0043               edkey.action.goto:
0044                       ;-------------------------------------------------------
0045                       ; Crunch current row if dirty
0046                       ;-------------------------------------------------------
0047 63EC 8820  54         c     @fb.row.dirty,@w$ffff
     63EE A30A     
     63F0 2022     
0048 63F2 1609  14         jne   edkey.action.goto.refresh
0049               
0050 63F4 0649  14         dect  stack
0051 63F6 C660  46         mov   @parm1,*stack         ; Push parm1
     63F8 A000     
0052 63FA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63FC 6F5E     
0053 63FE C839  50         mov   *stack+,@parm1        ; Pop parm1
     6400 A000     
0054               
0055 6402 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6404 A30A     
0056                       ;-------------------------------------------------------
0057                       ; Refresh page
0058                       ;-------------------------------------------------------
0059               edkey.action.goto.refresh:
0060 6406 0720  34         seto  @fb.colorize           ; Colorize M1/M2 marked lines (if present)
     6408 A310     
0061               
0062 640A 0460  28         b     @edkey.goto.fb.toprow  ; Position cursor and exit
     640C 63CC     
0063                                                    ; \ i  @parm1 = Line in editor buffer
0064                                                    ; /
                   < stevie_b1.asm.30692
0078                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
     **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 640E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6410 A506     
0009 6412 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6414 6A8A     
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 6416 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6418 A308     
0015 641A 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 641C C120  34         mov   @fb.current,tmp0      ; Get pointer
     641E A302     
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6420 C1C6  18         mov   tmp2,tmp3             ; \
0024 6422 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 6424 81E0  34         c     @fb.column,tmp3
     6426 A30C     
0026 6428 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 642A 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 642C D505  30         movb  tmp1,*tmp0            ; /
0033 642E C820  54         mov   @fb.column,@fb.row.length
     6430 A30C     
     6432 A308     
0034                                                   ; Row length - 1
0035 6434 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6436 A30A     
0036 6438 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     643A A316     
0037 643C 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 643E 0286  22         ci    tmp2,colrow
     6440 0050     
0043 6442 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 6444 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6446 FFCE     
0049 6448 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     644A 2026     
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 644C C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 644E 61E0  34         s     @fb.column,tmp3
     6450 A30C     
0056 6452 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 6454 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 6456 C144  18         mov   tmp0,tmp1
0059 6458 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 645A 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     645C A30C     
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 645E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6460 A302     
0065 6462 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 6464 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 6466 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 6468 0606  14         dec   tmp2
0073 646A 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 646C 0206  20         li    tmp2,colrow
     646E 0050     
0078 6470 81A0  34         c     @fb.row.length,tmp2
     6472 A308     
0079 6474 1603  14         jne   edkey.action.del_char.save
0080 6476 0604  14         dec   tmp0                  ; One time adjustment
0081 6478 04C5  14         clr   tmp1
0082 647A D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 647C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     647E A30A     
0088 6480 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6482 A316     
0089 6484 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6486 A308     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 6488 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     648A 75F2     
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 648C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     648E A506     
0102 6490 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6492 6A8A     
0103 6494 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6496 A308     
0104 6498 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 649A C120  34         mov   @fb.current,tmp0      ; Get pointer
     649C A302     
0110 649E C1A0  34         mov   @fb.colsline,tmp2
     64A0 A30E     
0111 64A2 61A0  34         s     @fb.column,tmp2
     64A4 A30C     
0112 64A6 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 64A8 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 64AA 0606  14         dec   tmp2
0119 64AC 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 64AE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64B0 A30A     
0124 64B2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64B4 A316     
0125               
0126 64B6 C820  54         mov   @fb.column,@fb.row.length
     64B8 A30C     
     64BA A308     
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 64BC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64BE 75F2     
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 64C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64C2 6A8A     
0143 64C4 04E0  34         clr   @fb.row.dirty         ; Discard current line
     64C6 A30A     
0144               
0145 64C8 C820  54         mov   @fb.topline,@parm1    ; \
     64CA A304     
     64CC A000     
0146 64CE A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     64D0 A306     
     64D2 A000     
0147 64D4 05A0  34         inc   @parm1                ; /
     64D6 A000     
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 64D8 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     64DA A000     
     64DC A504     
0153 64DE 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 64E0 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     64E2 A304     
     64E4 A000     
0157 64E6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     64E8 6C7A     
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 64EA 0460  28         b     @edkey.action.up      ; Move cursor one line up
     64EC 62A4     
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 64EE 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     64F0 725E     
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 64F2 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     64F4 A000     
     64F6 A504     
0170 64F8 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 64FA 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     64FC 7158     
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 64FE C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6500 A304     
     6502 A000     
0183               
0184 6504 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6506 6C7A     
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 6508 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     650A A506     
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 650C C120  34         mov   @fb.topline,tmp0
     650E A304     
0193 6510 A120  34         a     @fb.row,tmp0
     6512 A306     
0194               
0195 6514 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6516 A504     
0196 6518 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 651A 0460  28         b     @edkey.action.up      ; Move cursor one line up
     651C 62A4     
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 651E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6520 61C8     
                   < stevie_b1.asm.30692
0079                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0010 6522 0204  20         li    tmp0,>2000            ; White space
     6524 2000     
0011 6526 C804  38         mov   tmp0,@parm1
     6528 A000     
0012               edkey.action.ins_char:
0013 652A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     652C A506     
0014 652E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6530 6A8A     
0015                       ;-------------------------------------------------------
0016                       ; Check 1 - Empty line
0017                       ;-------------------------------------------------------
0018               edkey.actions.ins.char.empty_line:
0019 6532 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6534 A302     
0020 6536 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6538 A308     
0021 653A 133A  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Check 2 - line-wrap if at character 80
0025                       ;-------------------------------------------------------
0026 653C C160  34         mov   @fb.column,tmp1
     653E A30C     
0027 6540 0285  22         ci    tmp1,colrow-1         ; At 80th character?
     6542 004F     
0028 6544 1110  14         jlt   !
0029 6546 C160  34         mov   @fb.row.length,tmp1
     6548 A308     
0030 654A 0285  22         ci    tmp1,colrow
     654C 0050     
0031 654E 160B  14         jne   !
0032                       ;-------------------------------------------------------
0033                       ; Wrap to new line
0034                       ;-------------------------------------------------------
0035 6550 0649  14         dect  Stack
0036 6552 C660  46         mov   @parm1,*stack         ; Save character to add
     6554 A000     
0037 6556 06A0  32         bl    @fb.cursor.down       ; Move cursor down 1 line
     6558 6B10     
0038 655A 06A0  32         bl    @fb.insert.line       ; Insert empty line
     655C 6BB2     
0039 655E C839  50         mov   *stack+,@parm1        ; Restore character to add
     6560 A000     
0040 6562 04C6  14         clr   tmp2                  ; Clear line length
0041 6564 1025  14         jmp   edkey.action.ins_char.append
0042                       ;-------------------------------------------------------
0043                       ; Check 3 - EOL
0044                       ;-------------------------------------------------------
0045 6566 8820  54 !       c     @fb.column,@fb.row.length
     6568 A30C     
     656A A308     
0046 656C 1321  14         jeq   edkey.action.ins_char.append
0047                                                   ; Add character in append mode
0048                       ;-------------------------------------------------------
0049                       ; Check 4 - Insert only until line length reaches 80th column
0050                       ;-------------------------------------------------------
0051 656E C160  34         mov   @fb.row.length,tmp1
     6570 A308     
0052 6572 0285  22         ci    tmp1,colrow
     6574 0050     
0053 6576 1101  14         jlt   edkey.action.ins_char.prep
0054 6578 101D  14         jmp   edkey.action.ins_char.exit
0055                       ;-------------------------------------------------------
0056                       ; Calculate number of characters to move
0057                       ;-------------------------------------------------------
0058               edkey.action.ins_char.prep:
0059 657A C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0060 657C 61E0  34         s     @fb.column,tmp3
     657E A30C     
0061 6580 0607  14         dec   tmp3                  ; Remove base 1 offset
0062 6582 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0063 6584 C144  18         mov   tmp0,tmp1
0064 6586 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0065 6588 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     658A A30C     
0066                       ;-------------------------------------------------------
0067                       ; Loop from end of line until current character
0068                       ;-------------------------------------------------------
0069               edkey.action.ins_char.loop:
0070 658C D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0071 658E 0604  14         dec   tmp0
0072 6590 0605  14         dec   tmp1
0073 6592 0606  14         dec   tmp2
0074 6594 16FB  14         jne   edkey.action.ins_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Insert specified character at current position
0077                       ;-------------------------------------------------------
0078 6596 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     6598 A000     
0079                       ;-------------------------------------------------------
0080                       ; Save variables and exit
0081                       ;-------------------------------------------------------
0082 659A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     659C A30A     
0083 659E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65A0 A316     
0084 65A2 05A0  34         inc   @fb.column
     65A4 A30C     
0085 65A6 05A0  34         inc   @wyx
     65A8 832A     
0086 65AA 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65AC A308     
0087 65AE 1002  14         jmp   edkey.action.ins_char.exit
0088                       ;-------------------------------------------------------
0089                       ; Add character in append mode
0090                       ;-------------------------------------------------------
0091               edkey.action.ins_char.append:
0092 65B0 0460  28         b     @edkey.action.char.overwrite
     65B2 6670     
0093                       ;-------------------------------------------------------
0094                       ; Exit
0095                       ;-------------------------------------------------------
0096               edkey.action.ins_char.exit:
0097 65B4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65B6 75F2     
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
0108 65B8 06A0  32         bl    @fb.insert.line       ; Insert new line
     65BA 6BB2     
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.ins_line.exit:
0113 65BC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65BE 75F2     
                   < stevie_b1.asm.30692
0080                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
     **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 65C0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65C2 A318     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 65C4 8820  54         c     @fb.row.dirty,@w$ffff
     65C6 A30A     
     65C8 2022     
0013 65CA 1606  14         jne   edkey.action.enter.upd_counter
0014 65CC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65CE A506     
0015 65D0 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     65D2 6F5E     
0016 65D4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65D6 A30A     
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 65D8 C120  34         mov   @fb.topline,tmp0
     65DA A304     
0022 65DC A120  34         a     @fb.row,tmp0
     65DE A306     
0023 65E0 0584  14         inc   tmp0
0024 65E2 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     65E4 A504     
0025 65E6 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 65E8 05A0  34         inc   @edb.lines            ; Total lines++
     65EA A504     
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 65EC C120  34         mov   @fb.scrrows,tmp0
     65EE A31A     
0035 65F0 0604  14         dec   tmp0
0036 65F2 8120  34         c     @fb.row,tmp0
     65F4 A306     
0037 65F6 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 65F8 C120  34         mov   @fb.scrrows,tmp0
     65FA A31A     
0042 65FC C820  54         mov   @fb.topline,@parm1
     65FE A304     
     6600 A000     
0043 6602 05A0  34         inc   @parm1
     6604 A000     
0044 6606 06A0  32         bl    @fb.refresh
     6608 6C7A     
0045 660A 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     660C A310     
0046 660E 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 6610 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6612 A306     
0052 6614 06A0  32         bl    @down                 ; Row++ VDP cursor
     6616 26E8     
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 6618 06A0  32         bl    @fb.get.firstnonblank
     661A 6C32     
0058 661C C120  34         mov   @outparm1,tmp0
     661E A010     
0059 6620 C804  38         mov   tmp0,@fb.column
     6622 A30C     
0060 6624 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     6626 26FA     
0061 6628 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     662A 7158     
0062 662C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     662E 6A8A     
0063 6630 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6632 A316     
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 6634 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6636 75F2     
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 6638 0649  14         dect  stack
0078 663A C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 663C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     663E A318     
0081 6640 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     6642 A50A     
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 6644 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 6646 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6648 75F2     
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 664A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     664C A318     
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 664E D105  18         movb  tmp1,tmp0             ; Get keycode
0100 6650 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 6652 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6654 0020     
0103 6656 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 6658 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     665A 007E     
0107 665C 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 665E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6660 A506     
0113 6662 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6664 A000     
0114 6666 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6668 A50A     
0115 666A 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 666C 0460  28         b     @edkey.action.ins_char
     666E 652A     
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6670 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6672 6A8A     
0126 6674 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6676 A302     
0127               
0128 6678 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     667A A000     
0129 667C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     667E A30A     
0130 6680 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6682 A316     
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 6684 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6686 A30C     
0135 6688 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     668A 004F     
0136 668C 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 668E 0205  20         li    tmp1,colrow           ; \
     6690 0050     
0140 6692 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     6694 A308     
0141 6696 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 6698 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     669A A30C     
0147 669C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     669E 832A     
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 66A0 8820  54         c     @fb.column,@fb.row.length
     66A2 A30C     
     66A4 A308     
0152                                                   ; column < line length ?
0153 66A6 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 66A8 C820  54         mov   @fb.column,@fb.row.length
     66AA A30C     
     66AC A308     
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 66AE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66B0 75F2     
                   < stevie_b1.asm.30692
0081                       copy  "edkey.fb.ruler.asm"       ; Toggle ruler on/off
     **** ****     > edkey.fb.ruler.asm
0001               * FILE......: edkey.fb.ruler.asm
0002               * Purpose...: Actions to toggle ruler on/off
0003               
0004               *---------------------------------------------------------------
0005               * Toggle ruler on/off
0006               ********|*****|*********************|**************************
0007               edkey.action.toggle.ruler:
0008 66B2 0649  14         dect  stack
0009 66B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0010 66B6 0649  14         dect  stack
0011 66B8 C660  46         mov   @wyx,*stack           ; Push cursor YX
     66BA 832A     
0012                       ;-------------------------------------------------------
0013                       ; Toggle ruler visibility
0014                       ;-------------------------------------------------------
0015 66BC C120  34         mov   @tv.ruler.visible,tmp0
     66BE A210     
0016                                                   ; Ruler currently off?
0017 66C0 1305  14         jeq   edkey.action.toggle.ruler.on
0018                                                   ; Yes, turn it on
0019                       ;-------------------------------------------------------
0020                       ; Turn ruler off
0021                       ;-------------------------------------------------------
0022               edkey.action.toggle.ruler.off:
0023 66C2 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     66C4 A316     
0024 66C6 04E0  34         clr   @tv.ruler.visible     ; Toggle ruler visibility
     66C8 A210     
0025 66CA 100C  14         jmp   edkey.action.toggle.ruler.fb
0026                       ;-------------------------------------------------------
0027                       ; Turn ruler on
0028                       ;-------------------------------------------------------
0029               edkey.action.toggle.ruler.on:
0030 66CC C120  34         mov   @fb.scrrows,tmp0      ; \ Check if on last row in
     66CE A31A     
0031 66D0 0604  14         dec   tmp0                  ; | frame buffer, if yes
0032 66D2 8120  34         c     @fb.row,tmp0          ; | silenty exit without any
     66D4 A306     
0033                                                   ; | action, preventing
0034                                                   ; / overflow on bottom row.
0035 66D6 1308  14         jeq   edkey.action.toggle.ruler.exit
0036               
0037 66D8 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     66DA A316     
0038 66DC 0720  34         seto  @tv.ruler.visible     ; Set ruler visibility
     66DE A210     
0039 66E0 06A0  32         bl    @fb.ruler.init        ; Setup ruler in RAM
     66E2 7E38     
0040                       ;-------------------------------------------------------
0041                       ; Update framebuffer pane
0042                       ;-------------------------------------------------------
0043               edkey.action.toggle.ruler.fb:
0044 66E4 06A0  32         bl    @pane.cmdb.hide       ; Same actions as when hiding CMDB
     66E6 7DE0     
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               edkey.action.toggle.ruler.exit:
0049 66E8 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     66EA 832A     
0050 66EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 66EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66F0 75F2     
                   < stevie_b1.asm.30692
0082                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 66F2 C120  34         mov   @edb.dirty,tmp0
     66F4 A506     
0012 66F6 1302  14         jeq   !
0013 66F8 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66FA 7D96     
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 66FC 0460  28 !       b     @tv.quit
     66FE 342C     
0018               
0019               
0020               
0021               
                   < stevie_b1.asm.30692
0083                       copy  "edkey.fb.file.asm"        ; File related actions
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
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.fb.fname.dec.load:
0017 6700 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6702 A444     
     6704 A000     
0018 6706 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6708 A002     
0019 670A 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 670C C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     670E A444     
     6710 A000     
0023 6712 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6714 A002     
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 6716 C120  34         mov   @parm1,tmp0
     6718 A000     
0030 671A 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 671C C120  34         mov   @edb.dirty,tmp0
     671E A506     
0036 6720 1302  14         jeq   !
0037 6722 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6724 7D96     
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 6726 06A0  32 !       bl    @fm.browse.fname.suffix
     6728 7D28     
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 672A 0204  20         li    tmp0,heap.top         ; 1st line in heap
     672C F000     
0047 672E 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6730 7CEA     
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 6732 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6734 632A     
                   < stevie_b1.asm.30692
0084                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
     **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 6736 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     6738 72EE     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 673A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     673C 75F2     
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 673E 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     6740 7316     
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 6742 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6744 75F2     
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 6746 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     6748 733E     
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 674A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     674C 75F2     
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 674E 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     6750 7AC2     
0043 6752 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     6754 7384     
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 6756 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6758 75F2     
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 675A 0649  14         dect  stack
0055 675C C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 675E 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6760 A50E     
     6762 2022     
0060 6764 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 6766 C120  34         mov   @wyx,tmp0             ; Get cursor position
     6768 832A     
0066 676A 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     676C FF00     
0067 676E C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     6770 A314     
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 6772 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     6774 7AC2     
0072               
0073 6776 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     6778 A000     
0074 677A 06A0  32         bl    @edb.block.copy       ; Copy code block
     677C 73CA     
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 677E 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     6780 A010     
     6782 2000     
0079 6784 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6786 C820  54         mov   @fb.yxsave,@parm1
     6788 A314     
     678A A000     
0083 678C 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     678E 6CEA     
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 6790 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6792 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6794 75F2     
0092               
0093               
0094               
0095               
0096               *---------------------------------------------------------------
0097               * Delete code block
0098               ********|*****|*********************|**************************
0099               edkey.action.block.delete:
0100                       ;-------------------------------------------------------
0101                       ; Exit early if nothing to do
0102                       ;-------------------------------------------------------
0103 6796 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6798 A50E     
     679A 2022     
0104 679C 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 679E 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     67A0 7AC2     
0110               
0111 67A2 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     67A4 A000     
0112 67A6 06A0  32         bl    @edb.block.delete     ; Delete code block
     67A8 74C0     
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 67AA 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     67AC A010     
     67AE 2000     
0119 67B0 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 67B2 C820  54         mov   @fb.topline,@parm1
     67B4 A304     
     67B6 A000     
0123 67B8 0460  28         b     @edkey.goto.fb.toprow ; Position on top row in frame buffer
     67BA 63CC     
0124                                                   ; \ i  @parm1 = Line to display as top row
0125                                                   ; /
0126                       ;-------------------------------------------------------
0127                       ; Exit
0128                       ;-------------------------------------------------------
0129               edkey.action.block.delete.exit:
0130 67BC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67BE 75F2     
0131               
0132               
0133               *---------------------------------------------------------------
0134               * Move code block
0135               ********|*****|*********************|**************************
0136               edkey.action.block.move:
0137                       ;-------------------------------------------------------
0138                       ; Exit early if nothing to do
0139                       ;-------------------------------------------------------
0140 67C0 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67C2 A50E     
     67C4 2022     
0141 67C6 1313  14         jeq   edkey.action.block.move.exit
0142                                                   ; Yes, exit early
0143                       ;-------------------------------------------------------
0144                       ; Delete
0145                       ;-------------------------------------------------------
0146 67C8 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     67CA 7AC2     
0147               
0148 67CC 0720  34         seto  @parm1                ; Set message to "Moving block..."
     67CE A000     
0149 67D0 06A0  32         bl    @edb.block.copy       ; Copy code block
     67D2 73CA     
0150                                                   ; \ i  @parm1    = Message flag
0151                                                   ; / o  @outparm1 = >ffff if success
0152               
0153 67D4 0720  34         seto  @parm1                ; Don't display delete message
     67D6 A000     
0154 67D8 06A0  32         bl    @edb.block.delete     ; Delete code block
     67DA 74C0     
0155                                                   ; \ i  @parm1    = Display message Yes/No
0156                                                   ; / o  @outparm1 = >ffff if success
0157                       ;-------------------------------------------------------
0158                       ; Reposition in frame buffer
0159                       ;-------------------------------------------------------
0160 67DC 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     67DE A010     
     67E0 2000     
0161 67E2 13EC  14         jeq   edkey.action.block.delete.exit
0162                                                   ; If yes, exit early
0163               
0164 67E4 C820  54         mov   @fb.topline,@parm1
     67E6 A304     
     67E8 A000     
0165 67EA 0460  28         b     @edkey.goto.fb.toprow ; Position on top row in frame buffer
     67EC 63CC     
0166                                                   ; \ i  @parm1 = Line to display as top row
0167                                                   ; /
0168                       ;-------------------------------------------------------
0169                       ; Exit
0170                       ;-------------------------------------------------------
0171               edkey.action.block.move.exit:
0172 67EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67F0 75F2     
0173               
0174               
0175               *---------------------------------------------------------------
0176               * Goto marker M1
0177               ********|*****|*********************|**************************
0178               edkey.action.block.goto.m1:
0179 67F2 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     67F4 A50C     
     67F6 2022     
0180 67F8 1307  14         jeq   edkey.action.block.goto.m1.exit
0181                                                   ; Yes, exit early
0182                       ;-------------------------------------------------------
0183                       ; Goto marker M1
0184                       ;-------------------------------------------------------
0185 67FA C820  54         mov   @edb.block.m1,@parm1
     67FC A50C     
     67FE A000     
0186 6800 0620  34         dec   @parm1                ; Base 0 offset
     6802 A000     
0187               
0188 6804 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6806 63EC     
0189                                                   ; \ i @parm1 = Target line in EB
0190                                                   ; /
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.block.goto.m1.exit:
0195 6808 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     680A 75F2     
                   < stevie_b1.asm.30692
0085                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
     **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 680C 0649  14         dect  stack
0009 680E C64B  30         mov   r11,*stack            ; Save return address
0010 6810 06A0  32         bl    @fb.tab.next          ; Jump to next tab position on line
     6812 7E26     
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 6814 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 6816 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6818 75F2     
                   < stevie_b1.asm.30692
0086                       ;-----------------------------------------------------------------------
0087                       ; Keyboard actions - Command Buffer
0088                       ;-----------------------------------------------------------------------
0089                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
     **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 681A C120  34         mov   @cmdb.column,tmp0
     681C A712     
0009 681E 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6820 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6822 A712     
0014 6824 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6826 A70A     
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 6828 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     682A 75F2     
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 682C 06A0  32         bl    @cmdb.cmd.getlength
     682E 7E08     
0026 6830 8820  54         c     @cmdb.column,@outparm1
     6832 A712     
     6834 A010     
0027 6836 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 6838 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     683A A712     
0032 683C 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     683E A70A     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 6840 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6842 75F2     
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 6844 04C4  14         clr   tmp0
0045 6846 C804  38         mov   tmp0,@cmdb.column      ; First column
     6848 A712     
0046 684A 0584  14         inc   tmp0
0047 684C D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     684E A70A     
0048 6850 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     6852 A70A     
0049               
0050 6854 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6856 75F2     
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 6858 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     685A A728     
0057 685C 0984  56         srl   tmp0,8                 ; Right justify
0058 685E C804  38         mov   tmp0,@cmdb.column      ; Save column position
     6860 A712     
0059 6862 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 6864 0224  22         ai    tmp0,>1a00             ; Y=26
     6866 1A00     
0061 6868 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     686A A70A     
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 686C 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     686E 75F2     
                   < stevie_b1.asm.30692
0090                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 6870 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6872 7DFE     
0026 6874 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6876 A718     
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 6878 0460  28         b     @edkey.action.cmdb.home
     687A 6844     
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
0060 687C D105  18         movb  tmp1,tmp0             ; Get keycode
0061 687E 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6880 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6882 0020     
0064 6884 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6886 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6888 007E     
0068 688A 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 688C 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     688E A718     
0074               
0075 6890 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6892 A729     
0076 6894 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6896 A712     
0077 6898 D505  30         movb  tmp1,*tmp0            ; Add character
0078 689A 05A0  34         inc   @cmdb.column          ; Next column
     689C A712     
0079 689E 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     68A0 A70A     
0080               
0081 68A2 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68A4 7E08     
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 68A6 C120  34         mov   @outparm1,tmp0
     68A8 A010     
0088 68AA 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 68AC D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68AE A728     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 68B0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     68B2 75F2     
                   < stevie_b1.asm.30692
0091                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
     **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 68B4 C120  34         mov   @cmdb.visible,tmp0
     68B6 A702     
0009 68B8 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 68BA 04E0  34         clr   @cmdb.column          ; Column = 0
     68BC A712     
0015 68BE 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     68C0 7DD6     
0016 68C2 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 68C4 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     68C6 7DE0     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 68C8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     68CA 75F2     
                   < stevie_b1.asm.30692
0092                       copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
     **** ****     > edkey.cmdb.file.new.asm
0001               * FILE......: edkey.cmdb.fíle.new.asm
0002               * Purpose...: New file from command buffer pane
0003               
0004               *---------------------------------------------------------------
0005               * New DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.file.new:
0008                       ;-------------------------------------------------------
0009                       ; New file
0010                       ;-------------------------------------------------------
0011 68CC 0649  14         dect  stack
0012 68CE C64B  30         mov   r11,*stack            ; Save return address
0013 68D0 0649  14         dect  stack
0014 68D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 68D4 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     68D6 A506     
0019 68D8 1303  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 68DA 06A0  32         bl    @dialog.unsaved       ; Show dialog
     68DC 7D96     
0022 68DE 1004  14         jmp   edkey.action.cmdb.file.new.exit
0023                       ;-------------------------------------------------------
0024                       ; Reset editor
0025                       ;-------------------------------------------------------
0026 68E0 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     68E2 7DE0     
0027 68E4 06A0  32         bl    @fm.newfile           ; New file in editor
     68E6 7D4C     
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.file.new.exit:
0032 68E8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0033 68EA C2F9  30         mov   *stack+,r11           ; Pop R11
0034 68EC 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     68EE 632A     
                   < stevie_b1.asm.30692
0093                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
     **** ****     > edkey.cmdb.file.load.asm
0001               * FILE......: edkey.cmdb.fíle.load.asm
0002               * Purpose...: Load file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.load:
0008                       ;-------------------------------------------------------
0009                       ; Load file
0010                       ;-------------------------------------------------------
0011 68F0 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     68F2 7DE0     
0012               
0013 68F4 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68F6 7E08     
0014 68F8 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     68FA A010     
0015 68FC 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 68FE 06A0  32         bl    @pane.errline.show    ; Show error line
     6900 7A5A     
0020               
0021 6902 06A0  32         bl    @pane.show_hint
     6904 7DCC     
0022 6906 1C00                   byte pane.botrow-1,0
0023 6908 3734                   data txt.io.nofile
0024               
0025 690A 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 690C 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 690E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6910 A728     
0031               
0032 6912 06A0  32         bl    @cpym2m
     6914 24EE     
0033 6916 A728                   data cmdb.cmdlen,heap.top,80
     6918 F000     
     691A 0050     
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 691C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     691E F000     
0039 6920 C804  38         mov   tmp0,@parm1
     6922 A000     
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 6924 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6926 F000     
0045 6928 C804  38         mov   tmp0,@parm1
     692A A000     
0046               
0047 692C 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     692E 7CEA     
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 6930 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6932 632A     
                   < stevie_b1.asm.30692
0094                       copy  "edkey.cmdb.file.ins.asm"  ; Insert DV80 file
     **** ****     > edkey.cmdb.file.ins.asm
0001               * FILE......: edkey.cmdb.fíle.ins.asm
0002               * Purpose...: Insert file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.ins:
0008 6934 0649  14         dect  stack
0009 6936 C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6938 0649  14         dect  stack
0011 693A C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     693C A304     
0012                       ;-------------------------------------------------------
0013                       ; Insert file at current line in editor buffer
0014                       ;-------------------------------------------------------
0015 693E 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6940 7DE0     
0016               
0017 6942 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6944 7E08     
0018 6946 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6948 A010     
0019 694A 1607  14         jne   !                     ; No, prepare for load
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 694C 06A0  32         bl    @pane.errline.show    ; Show error line
     694E 7A5A     
0024               
0025 6950 06A0  32         bl    @pane.show_hint
     6952 7DCC     
0026 6954 1C00                   byte pane.botrow-1,0
0027 6956 3734                   data txt.io.nofile
0028               
0029 6958 1023  14         jmp   edkey.action.cmdb.ins.exit
0030                       ;-------------------------------------------------------
0031                       ; Get filename
0032                       ;-------------------------------------------------------
0033 695A 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0034 695C D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     695E A728     
0035               
0036 6960 06A0  32         bl    @cpym2m
     6962 24EE     
0037 6964 A728                   data cmdb.cmdlen,heap.top,80
     6966 F000     
     6968 0050     
0038                                                   ; Copy filename from command line to buffer
0039                       ;-------------------------------------------------------
0040                       ; Pass filename as parm1
0041                       ;-------------------------------------------------------
0042 696A 0204  20         li    tmp0,heap.top         ; 1st line in heap
     696C F000     
0043 696E C804  38         mov   tmp0,@parm1
     6970 A000     
0044                       ;-------------------------------------------------------
0045                       ; Insert file at line
0046                       ;-------------------------------------------------------
0047               edkey.action.cmdb.ins.file:
0048                       ;-------------------------------------------------------
0049                       ; Get line
0050                       ;-------------------------------------------------------
0051 6972 C820  54         mov   @fb.row,@parm1
     6974 A306     
     6976 A000     
0052 6978 06A0  32         bl    @fb.row2line          ; Row to editor line
     697A 6A70     
0053                                                   ; \ i @fb.topline = Top line in frame buffer
0054                                                   ; | i @parm1      = Row in frame buffer
0055                                                   ; / o @outparm1   = Matching line in EB
0056               
0057 697C C820  54         mov   @outparm1,@parm2
     697E A010     
     6980 A002     
0058                       ;-------------------------------------------------------
0059                       ; Get device/filename
0060                       ;-------------------------------------------------------
0061 6982 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6984 F000     
0062 6986 C804  38         mov   tmp0,@parm1
     6988 A000     
0063                       ;-------------------------------------------------------
0064                       ; Insert file
0065                       ;-------------------------------------------------------
0066 698A 06A0  32         bl    @fm.insertfile        ; Insert DV80 file
     698C 7D10     
0067                                                   ; \ i  parm1 = Pointer to length-prefixed
0068                                                   ; |            device/filename string
0069                                                   ; | i  parm2 = Line number to load file at
0070                       ;-------------------------------------------------------
0071                       ; Refresh frame buffer
0072                       ;-------------------------------------------------------
0073 698E 0720  34         seto  @fb.dirty             ; Refresh frame buffer
     6990 A316     
0074 6992 0720  34         seto  @edb.dirty            ; Editor buffer dirty
     6994 A506     
0075               
0076 6996 C820  54         mov   @fb.topline,@parm1
     6998 A304     
     699A A000     
0077 699C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     699E 6C7A     
0078                                                   ; | i  @parm1 = Line to start with
0079                                                   ; /             (becomes @fb.topline)
0080               
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.cmdb.ins.exit:
0085 69A0 C839  50         mov   *stack+,@parm1        ; Pop top row
     69A2 A000     
0086 69A4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 69A6 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     69A8 63CC     
0088                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.30692
0095                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
     **** ****     > edkey.cmdb.file.save.asm
0001               * FILE......: edkey.cmdb.fíle.save.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.save:
0008 69AA 0649  14         dect  stack
0009 69AC C644  30         mov   tmp0,*stack           ; Push tmp0
0010 69AE 0649  14         dect  stack
0011 69B0 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     69B2 A304     
0012                       ;-------------------------------------------------------
0013                       ; Save file
0014                       ;-------------------------------------------------------
0015 69B4 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     69B6 7DE0     
0016               
0017 69B8 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     69BA 7E08     
0018 69BC C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     69BE A010     
0019 69C0 1607  14         jne   !                     ; No, prepare for save
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 69C2 06A0  32         bl    @pane.errline.show    ; Show error line
     69C4 7A5A     
0024               
0025 69C6 06A0  32         bl    @pane.show_hint
     69C8 7DCC     
0026 69CA 1C00                   byte pane.botrow-1,0
0027 69CC 3734                   data txt.io.nofile
0028               
0029 69CE 1020  14         jmp   edkey.action.cmdb.save.exit
0030                       ;-------------------------------------------------------
0031                       ; Get filename
0032                       ;-------------------------------------------------------
0033 69D0 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0034 69D2 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69D4 A728     
0035               
0036 69D6 06A0  32         bl    @cpym2m
     69D8 24EE     
0037 69DA A728                   data cmdb.cmdlen,heap.top,80
     69DC F000     
     69DE 0050     
0038                                                   ; Copy filename from command line to buffer
0039                       ;-------------------------------------------------------
0040                       ; Pass filename as parm1
0041                       ;-------------------------------------------------------
0042 69E0 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69E2 F000     
0043 69E4 C804  38         mov   tmp0,@parm1
     69E6 A000     
0044                       ;-------------------------------------------------------
0045                       ; Save all lines in editor buffer?
0046                       ;-------------------------------------------------------
0047 69E8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     69EA A50E     
     69EC 2022     
0048 69EE 1309  14         jeq   edkey.action.cmdb.save.all
0049                                                   ; Yes, so save all lines in editor buffer
0050                       ;-------------------------------------------------------
0051                       ; Only save code block M1-M2
0052                       ;-------------------------------------------------------
0053 69F0 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     69F2 A50C     
     69F4 A002     
0054 69F6 0620  34         dec   @parm2                ; /
     69F8 A002     
0055               
0056 69FA C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     69FC A50E     
     69FE A004     
0057               
0058 6A00 1005  14         jmp   edkey.action.cmdb.save.file
0059                       ;-------------------------------------------------------
0060                       ; Save all lines in editor buffer
0061                       ;-------------------------------------------------------
0062               edkey.action.cmdb.save.all:
0063 6A02 04E0  34         clr   @parm2                ; First line to save
     6A04 A002     
0064 6A06 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6A08 A504     
     6A0A A004     
0065                       ;-------------------------------------------------------
0066                       ; Save file
0067                       ;-------------------------------------------------------
0068               edkey.action.cmdb.save.file:
0069 6A0C 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6A0E 7D3A     
0070                                                   ; \ i  parm1 = Pointer to length-prefixed
0071                                                   ; |            device/filename string
0072                                                   ; | i  parm2 = First line to save (base 0)
0073                                                   ; | i  parm3 = Last line to save  (base 0)
0074                                                   ; /
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               edkey.action.cmdb.save.exit:
0079 6A10 C839  50         mov   *stack+,@parm1        ; Pop top row
     6A12 A000     
0080 6A14 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0081 6A16 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6A18 63CC     
0082                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.30692
0096                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0011               * @cmdb.action.ptr = Pointer to keyboard action
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.cmdb.proceed:
0017                       ;-------------------------------------------------------
0018                       ; Intialisation
0019                       ;-------------------------------------------------------
0020 6A1A 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6A1C A506     
0021 6A1E 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     6A20 7954     
0022 6A22 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6A24 7DFE     
0023 6A26 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6A28 A726     
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6A2A 0284  22         ci    tmp0,>2000
     6A2C 2000     
0028 6A2E 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 6A30 0284  22         ci    tmp0,>7fff
     6A32 7FFF     
0031 6A34 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6A36 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6A38 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6A3A FFCE     
0040 6A3C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A3E 2026     
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6A40 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A42 75F2     
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
0063 6A44 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6A46 7E1C     
0064 6A48 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6A4A A718     
0065 6A4C 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6A4E 75F2     
0066               
0067               
0068               
0069               
0070               ***************************************************************
0071               * dialog.close
0072               * Close dialog "About"
0073               ***************************************************************
0074               * b   @edkey.action.cmdb.close.about
0075               *--------------------------------------------------------------
0076               * OUTPUT
0077               * none
0078               *--------------------------------------------------------------
0079               * Register usage
0080               * none
0081               ********|*****|*********************|**************************
0082               edkey.action.cmdb.close.about:
0083                       ;------------------------------------------------------
0084                       ; Erase header line
0085                       ;------------------------------------------------------
0086 6A50 06A0  32         bl    @hchar
     6A52 27DC     
0087 6A54 0000                   byte 0,0,32,80*2
     6A56 20A0     
0088 6A58 FFFF                   data EOL
0089 6A5A 1000  14         jmp   edkey.action.cmdb.close.dialog
0090               
0091               
0092               ***************************************************************
0093               * dialog.close
0094               * Close dialog
0095               ***************************************************************
0096               * b   @edkey.action.cmdb.close.dialog
0097               *--------------------------------------------------------------
0098               * OUTPUT
0099               * none
0100               *--------------------------------------------------------------
0101               * Register usage
0102               * none
0103               ********|*****|*********************|**************************
0104               edkey.action.cmdb.close.dialog:
0105                       ;------------------------------------------------------
0106                       ; Close dialog
0107                       ;------------------------------------------------------
0108 6A5C 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6A5E A71A     
0109 6A60 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A62 7954     
0110 6A64 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A66 7DE0     
0111 6A68 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6A6A A318     
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6A6C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A6E 75F2     
                   < stevie_b1.asm.30692
0097                       ;-----------------------------------------------------------------------
0098                       ; Logic for Framebuffer (1)
0099                       ;-----------------------------------------------------------------------
0100                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 6A70 0649  14         dect  stack
0025 6A72 C64B  30         mov   r11,*stack            ; Save return address
0026 6A74 0649  14         dect  stack
0027 6A76 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6A78 C120  34         mov   @parm1,tmp0
     6A7A A000     
0032 6A7C A120  34         a     @fb.topline,tmp0
     6A7E A304     
0033 6A80 C804  38         mov   tmp0,@outparm1
     6A82 A010     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6A84 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6A86 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6A88 045B  20         b     *r11                  ; Return to caller
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
0068 6A8A 0649  14         dect  stack
0069 6A8C C64B  30         mov   r11,*stack            ; Save return address
0070 6A8E 0649  14         dect  stack
0071 6A90 C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A92 0649  14         dect  stack
0073 6A94 C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A96 C120  34         mov   @fb.row,tmp0
     6A98 A306     
0078 6A9A 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A9C A30E     
0079 6A9E A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6AA0 A30C     
0080 6AA2 A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6AA4 A300     
0081 6AA6 C805  38         mov   tmp1,@fb.current
     6AA8 A302     
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6AAA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6AAC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6AAE C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6AB0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0101                       copy  "fb.cursor.up.asm"    ; Cursor up
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
0021 6AB2 0649  14         dect  stack
0022 6AB4 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;-------------------------------------------------------
0024                       ; Crunch current line if dirty
0025                       ;-------------------------------------------------------
0026 6AB6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6AB8 A318     
0027 6ABA 8820  54         c     @fb.row.dirty,@w$ffff
     6ABC A30A     
     6ABE 2022     
0028 6AC0 1604  14         jne   fb.cursor.up.cursor
0029 6AC2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6AC4 6F5E     
0030 6AC6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6AC8 A30A     
0031                       ;-------------------------------------------------------
0032                       ; Move cursor
0033                       ;-------------------------------------------------------
0034               fb.cursor.up.cursor:
0035 6ACA C120  34         mov   @fb.row,tmp0
     6ACC A306     
0036 6ACE 150B  14         jgt   fb.cursor.up.cursor_up
0037                                                   ; Move cursor up if fb.row > 0
0038 6AD0 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6AD2 A304     
0039 6AD4 130C  14         jeq   fb.cursor.up.set_cursorx
0040                                                   ; At top, only position cursor X
0041                       ;-------------------------------------------------------
0042                       ; Scroll 1 line
0043                       ;-------------------------------------------------------
0044 6AD6 0604  14         dec   tmp0                  ; fb.topline--
0045 6AD8 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     6ADA A000     
0046               
0047 6ADC 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6ADE 6C7A     
0048                                                   ; | i  @parm1 = Line to start with
0049                                                   ; /             (becomes @fb.topline)
0050               
0051 6AE0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6AE2 A310     
0052 6AE4 1004  14         jmp   fb.cursor.up.set_cursorx
0053                       ;-------------------------------------------------------
0054                       ; Move cursor up
0055                       ;-------------------------------------------------------
0056               fb.cursor.up.cursor_up:
0057 6AE6 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6AE8 A306     
0058 6AEA 06A0  32         bl    @up                   ; Row-- VDP cursor
     6AEC 26F0     
0059                       ;-------------------------------------------------------
0060                       ; Check line length and position cursor
0061                       ;-------------------------------------------------------
0062               fb.cursor.up.set_cursorx:
0063 6AEE 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6AF0 7158     
0064                                                   ; | i  @fb.row        = Row in frame buffer
0065                                                   ; / o  @fb.row.length = Length of row
0066               
0067 6AF2 8820  54         c     @fb.column,@fb.row.length
     6AF4 A30C     
     6AF6 A308     
0068 6AF8 1207  14         jle   fb.cursor.up.exit
0069                       ;-------------------------------------------------------
0070                       ; Adjust cursor column position
0071                       ;-------------------------------------------------------
0072 6AFA C820  54         mov   @fb.row.length,@fb.column
     6AFC A308     
     6AFE A30C     
0073 6B00 C120  34         mov   @fb.column,tmp0
     6B02 A30C     
0074 6B04 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6B06 26FA     
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               fb.cursor.up.exit:
0079 6B08 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6B0A 6A8A     
0080 6B0C C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6B0E 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0102                       copy  "fb.cursor.down.asm"  ; Cursor down
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
0021 6B10 0649  14         dect  stack
0022 6B12 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6B14 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6B16 A306     
     6B18 A504     
0027 6B1A 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6B1C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6B1E A318     
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6B20 8820  54         c     @fb.row.dirty,@w$ffff
     6B22 A30A     
     6B24 2022     
0034 6B26 1604  14         jne   fb.cursor.down.move
0035 6B28 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6B2A 6F5E     
0036 6B2C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6B2E A30A     
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6B30 C120  34         mov   @fb.topline,tmp0
     6B32 A304     
0045 6B34 A120  34         a     @fb.row,tmp0
     6B36 A306     
0046 6B38 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6B3A A504     
0047 6B3C 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6B3E C120  34         mov   @fb.scrrows,tmp0
     6B40 A31A     
0053 6B42 0604  14         dec   tmp0
0054 6B44 8120  34         c     @fb.row,tmp0
     6B46 A306     
0055 6B48 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6B4A C820  54         mov   @fb.topline,@parm1
     6B4C A304     
     6B4E A000     
0060 6B50 05A0  34         inc   @parm1
     6B52 A000     
0061               
0062 6B54 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6B56 6C7A     
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6B58 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6B5A A310     
0067 6B5C 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6B5E 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6B60 A306     
0073 6B62 06A0  32         bl    @down                 ; Row++ VDP cursor
     6B64 26E8     
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6B66 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6B68 7158     
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6B6A 8820  54         c     @fb.column,@fb.row.length
     6B6C A30C     
     6B6E A308     
0083 6B70 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6B72 C820  54         mov   @fb.row.length,@fb.column
     6B74 A308     
     6B76 A30C     
0089 6B78 C120  34         mov   @fb.column,tmp0
     6B7A A30C     
0090 6B7C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6B7E 26FA     
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6B80 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6B82 6A8A     
0096 6B84 C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6B86 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0103                       copy  "fb.cursor.home.asm"  ; Cursor home
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
0021 6B88 0649  14         dect  stack
0022 6B8A C64B  30         mov   r11,*stack            ; Save return address
0023 6B8C 0649  14         dect  stack
0024 6B8E C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;------------------------------------------------------
0026                       ; Cursor home
0027                       ;------------------------------------------------------
0028 6B90 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6B92 A318     
0029 6B94 C120  34         mov   @wyx,tmp0
     6B96 832A     
0030 6B98 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6B9A FF00     
0031 6B9C C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6B9E 832A     
0032 6BA0 04E0  34         clr   @fb.column
     6BA2 A30C     
0033 6BA4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6BA6 6A8A     
0034 6BA8 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6BAA A318     
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               fb.cursor.home.exit:
0039 6BAC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6BAE C2F9  30         mov   *stack+,r11           ; Pop r11
0041 6BB0 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0104                       copy  "fb.insert.line.asm"  ; Insert new line
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
0020 6BB2 0649  14         dect  stack
0021 6BB4 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Initialisation
0024                       ;-------------------------------------------------------
0025 6BB6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6BB8 A506     
0026                       ;-------------------------------------------------------
0027                       ; Crunch current line if dirty
0028                       ;-------------------------------------------------------
0029 6BBA 8820  54         c     @fb.row.dirty,@w$ffff
     6BBC A30A     
     6BBE 2022     
0030 6BC0 1604  14         jne   fb.insert.line.insert
0031 6BC2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6BC4 6F5E     
0032 6BC6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6BC8 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Insert entry in index
0035                       ;-------------------------------------------------------
0036               fb.insert.line.insert:
0037 6BCA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6BCC 6A8A     
0038 6BCE C820  54         mov   @fb.topline,@parm1
     6BD0 A304     
     6BD2 A000     
0039 6BD4 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6BD6 A306     
     6BD8 A000     
0040 6BDA C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6BDC A504     
     6BDE A002     
0041               
0042 6BE0 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6BE2 6E76     
0043                                                   ; \ i  parm1 = Line for insert
0044                                                   ; / i  parm2 = Last line to reorg
0045               
0046 6BE4 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6BE6 A504     
0047 6BE8 04E0  34         clr   @fb.row.length        ; Current row length = 0
     6BEA A308     
0048                       ;-------------------------------------------------------
0049                       ; Check/Adjust marker M1
0050                       ;-------------------------------------------------------
0051               fb.insert.line.m1:
0052 6BEC 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6BEE A50C     
     6BF0 2022     
0053 6BF2 1308  14         jeq   fb.insert.line.m2
0054                                                   ; Yes, skip to M2 check
0055               
0056 6BF4 8820  54         c     @parm1,@edb.block.m1
     6BF6 A000     
     6BF8 A50C     
0057 6BFA 1504  14         jgt   fb.insert.line.m2
0058 6BFC 05A0  34         inc   @edb.block.m1         ; M1++
     6BFE A50C     
0059 6C00 0720  34         seto  @fb.colorize          ; Set colorize flag
     6C02 A310     
0060                       ;-------------------------------------------------------
0061                       ; Check/Adjust marker M2
0062                       ;-------------------------------------------------------
0063               fb.insert.line.m2:
0064 6C04 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6C06 A50E     
     6C08 2022     
0065 6C0A 1308  14         jeq   fb.insert.line.refresh
0066                                                   ; Yes, skip to refresh frame buffer
0067               
0068 6C0C 8820  54         c     @parm1,@edb.block.m2
     6C0E A000     
     6C10 A50E     
0069 6C12 1504  14         jgt   fb.insert.line.refresh
0070 6C14 05A0  34         inc   @edb.block.m2         ; M2++
     6C16 A50E     
0071 6C18 0720  34         seto  @fb.colorize          ; Set colorize flag
     6C1A A310     
0072                       ;-------------------------------------------------------
0073                       ; Refresh frame buffer and physical screen
0074                       ;-------------------------------------------------------
0075               fb.insert.line.refresh:
0076 6C1C C820  54         mov   @fb.topline,@parm1
     6C1E A304     
     6C20 A000     
0077               
0078 6C22 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6C24 6C7A     
0079                                                   ; | i  @parm1 = Line to start with
0080                                                   ; /             (becomes @fb.topline)
0081               
0082 6C26 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6C28 A316     
0083 6C2A 06A0  32         bl    @fb.cursor.home       ; Move cursor home
     6C2C 6B88     
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               fb.insert.line.exit:
0088 6C2E C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6C30 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0105                       copy  "fb.get.firstnonblank.asm"
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
0015 6C32 0649  14         dect  stack
0016 6C34 C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6C36 04E0  34         clr   @fb.column
     6C38 A30C     
0021 6C3A 06A0  32         bl    @fb.calc_pointer
     6C3C 6A8A     
0022 6C3E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6C40 7158     
0023 6C42 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6C44 A308     
0024 6C46 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6C48 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6C4A A302     
0027 6C4C 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6C4E D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6C50 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6C52 0285  22         ci    tmp1,>2000            ; Whitespace?
     6C54 2000     
0036 6C56 1503  14         jgt   fb.get.firstnonblank.match
0037 6C58 0606  14         dec   tmp2                  ; Counter--
0038 6C5A 16F9  14         jne   fb.get.firstnonblank.loop
0039 6C5C 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6C5E 6120  34         s     @fb.current,tmp0      ; Calculate column
     6C60 A302     
0045 6C62 0604  14         dec   tmp0
0046 6C64 C804  38         mov   tmp0,@outparm1        ; Save column
     6C66 A010     
0047 6C68 D805  38         movb  tmp1,@outparm2        ; Save character
     6C6A A012     
0048 6C6C 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6C6E 04E0  34         clr   @outparm1             ; X=0
     6C70 A010     
0054 6C72 04E0  34         clr   @outparm2             ; Null
     6C74 A012     
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6C76 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6C78 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0106                                                   ; Get column of first non-blank character
0107                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6C7A 0649  14         dect  stack
0021 6C7C C64B  30         mov   r11,*stack            ; Push return address
0022 6C7E 0649  14         dect  stack
0023 6C80 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6C82 0649  14         dect  stack
0025 6C84 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6C86 0649  14         dect  stack
0027 6C88 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6C8A C820  54         mov   @parm1,@fb.topline
     6C8C A000     
     6C8E A304     
0032 6C90 04E0  34         clr   @parm2                ; Target row in frame buffer
     6C92 A002     
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6C94 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6C96 A000     
     6C98 A504     
0037 6C9A 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6C9C 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6C9E 7056     
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6CA0 05A0  34         inc   @parm1                ; Next line in editor buffer
     6CA2 A000     
0048 6CA4 05A0  34         inc   @parm2                ; Next row in frame buffer
     6CA6 A002     
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6CA8 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6CAA A000     
     6CAC A504     
0053 6CAE 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6CB0 8820  54         c     @parm2,@fb.scrrows
     6CB2 A002     
     6CB4 A31A     
0056 6CB6 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6CB8 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6CBA C120  34         mov   @parm2,tmp0           ; Current row
     6CBC A002     
0064 6CBE C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6CC0 A31A     
0065 6CC2 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6CC4 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6CC6 A30E     
0067               
0068 6CC8 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6CCA 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6CCC 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6CCE A30E     
0072 6CD0 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6CD2 A300     
0073               
0074 6CD4 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6CD6 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6CD8 06A0  32         bl    @xfilm                ; \ Fill memory
     6CDA 2250     
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6CDC 0720  34         seto  @fb.dirty             ; Refresh screen
     6CDE A316     
0086               
0087 6CE0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0088 6CE2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0089 6CE4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0090 6CE6 C2F9  30         mov   *stack+,r11           ; Pop r11
0091 6CE8 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0108                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6CEA 0649  14         dect  stack
0022 6CEC C64B  30         mov   r11,*stack            ; Save return address
0023 6CEE 0649  14         dect  stack
0024 6CF0 C660  46         mov   @parm1,*stack         ; Push @parm1
     6CF2 A000     
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6CF4 C820  54         mov   @fb.topline,@parm1
     6CF6 A304     
     6CF8 A000     
0029 6CFA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6CFC 6C7A     
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6CFE 0720  34         seto  @parm1                ; Skip Asserts
     6D00 A000     
0035 6D02 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6D04 7E4A     
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6D06 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6D08 A218     
     6D0A A000     
0042 6D0C 06A0  32         bl    @pane.action.colorscheme.statlines
     6D0E 791C     
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6D10 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6D12 A318     
0050               
0051 6D14 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6D16 7954     
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6D18 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6D1A A000     
0057 6D1C C820  54         mov   @parm1,@wyx           ; Set cursor position
     6D1E A000     
     6D20 832A     
0058 6D22 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6D24 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0109                       ;-----------------------------------------------------------------------
0110                       ; Logic for Index management
0111                       ;-----------------------------------------------------------------------
0112                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6D26 0649  14         dect  stack
0023 6D28 C64B  30         mov   r11,*stack            ; Save return address
0024 6D2A 0649  14         dect  stack
0025 6D2C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6D2E 0649  14         dect  stack
0027 6D30 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6D32 C120  34         mov   @parm1,tmp0           ; Get line number
     6D34 A000     
0032 6D36 C160  34         mov   @parm2,tmp1           ; Get pointer
     6D38 A002     
0033 6D3A 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6D3C 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6D3E 0FFF     
0039 6D40 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6D42 06E0  34         swpb  @parm3
     6D44 A004     
0044 6D46 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6D48 A004     
0045 6D4A 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6D4C A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6D4E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D50 3246     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6D52 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6D54 A010     
0056 6D56 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6D58 B000     
0057 6D5A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6D5C A010     
0058 6D5E 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6D60 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D62 3246     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6D64 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6D66 A010     
0068 6D68 04E4  34         clr   @idx.top(tmp0)        ; /
     6D6A B000     
0069 6D6C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6D6E A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6D70 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6D72 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6D74 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6D76 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0113                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6D78 0649  14         dect  stack
0022 6D7A C64B  30         mov   r11,*stack            ; Save return address
0023 6D7C 0649  14         dect  stack
0024 6D7E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6D80 0649  14         dect  stack
0026 6D82 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6D84 0649  14         dect  stack
0028 6D86 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6D88 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6D8A A000     
0033               
0034 6D8C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6D8E 3246     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6D90 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6D92 A010     
0039 6D94 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6D96 B000     
0040               
0041 6D98 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6D9A C185  18         mov   tmp1,tmp2             ; \
0047 6D9C 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6D9E 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6DA0 00FF     
0052 6DA2 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6DA4 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6DA6 C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6DA8 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6DAA A010     
0059 6DAC C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6DAE A012     
0060 6DB0 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6DB2 04E0  34         clr   @outparm1
     6DB4 A010     
0066 6DB6 04E0  34         clr   @outparm2
     6DB8 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6DBA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6DBC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6DBE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6DC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6DC2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0114                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6DC4 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6DC6 B000     
0018 6DC8 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6DCA 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6DCC CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6DCE 0606  14         dec   tmp2                  ; tmp2--
0026 6DD0 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6DD2 045B  20         b     *r11                  ; Return to caller
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
0046 6DD4 0649  14         dect  stack
0047 6DD6 C64B  30         mov   r11,*stack            ; Save return address
0048 6DD8 0649  14         dect  stack
0049 6DDA C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6DDC 0649  14         dect  stack
0051 6DDE C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6DE0 0649  14         dect  stack
0053 6DE2 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6DE4 0649  14         dect  stack
0055 6DE6 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6DE8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6DEA A000     
0060               
0061 6DEC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6DEE 3246     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6DF0 C120  34         mov   @outparm1,tmp0        ; Index offset
     6DF2 A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6DF4 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6DF6 A002     
0070 6DF8 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6DFA 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6DFC A000     
0074 6DFE 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6E00 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6E02 B000     
0081 6E04 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6E06 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6E08 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6E0A A002     
0088 6E0C 0287  22         ci    tmp3,2048
     6E0E 0800     
0089 6E10 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6E12 06A0  32         bl    @_idx.sams.mapcolumn.on
     6E14 31D8     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6E16 C120  34         mov   @parm1,tmp0           ; Restore line number
     6E18 A000     
0103 6E1A 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6E1C 06A0  32         bl    @_idx.entry.delete.reorg
     6E1E 6DC4     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6E20 06A0  32         bl    @_idx.sams.mapcolumn.off
     6E22 320C     
0111                                                   ; Restore memory window layout
0112               
0113 6E24 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6E26 06A0  32         bl    @_idx.entry.delete.reorg
     6E28 6DC4     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6E2A 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6E2C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6E2E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6E30 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6E32 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6E34 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6E36 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0115                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 6E38 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6E3A 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 6E3C 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 6E3E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E40 FFCE     
0027 6E42 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E44 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 6E46 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6E48 B000     
0032 6E4A C144  18         mov   tmp0,tmp1             ; a = current slot
0033 6E4C 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 6E4E 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 6E50 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 6E52 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 6E54 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 6E56 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 6E58 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     6E5A AFFC     
0043 6E5C 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 6E5E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E60 FFCE     
0049 6E62 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E64 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 6E66 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 6E68 0644  14         dect  tmp0                  ; Move pointer up
0056 6E6A 0645  14         dect  tmp1                  ; Move pointer up
0057 6E6C 0606  14         dec   tmp2                  ; Next index entry
0058 6E6E 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 6E70 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 6E72 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 6E74 045B  20         b     *r11                  ; Return to caller
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
0088 6E76 0649  14         dect  stack
0089 6E78 C64B  30         mov   r11,*stack            ; Save return address
0090 6E7A 0649  14         dect  stack
0091 6E7C C644  30         mov   tmp0,*stack           ; Push tmp0
0092 6E7E 0649  14         dect  stack
0093 6E80 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 6E82 0649  14         dect  stack
0095 6E84 C646  30         mov   tmp2,*stack           ; Push tmp2
0096 6E86 0649  14         dect  stack
0097 6E88 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 6E8A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6E8C A002     
0102 6E8E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6E90 A000     
0103 6E92 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 6E94 C1E0  34         mov   @parm2,tmp3
     6E96 A002     
0110 6E98 0287  22         ci    tmp3,2048
     6E9A 0800     
0111 6E9C 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 6E9E 06A0  32         bl    @_idx.sams.mapcolumn.on
     6EA0 31D8     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 6EA2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6EA4 A002     
0123 6EA6 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 6EA8 06A0  32         bl    @_idx.entry.insert.reorg
     6EAA 6E38     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 6EAC 06A0  32         bl    @_idx.sams.mapcolumn.off
     6EAE 320C     
0131                                                   ; Restore memory window layout
0132               
0133 6EB0 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 6EB2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6EB4 A002     
0139               
0140 6EB6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6EB8 3246     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 6EBA C120  34         mov   @outparm1,tmp0        ; Index offset
     6EBC A010     
0145               
0146 6EBE 06A0  32         bl    @_idx.entry.insert.reorg
     6EC0 6E38     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 6EC2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 6EC4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 6EC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 6EC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 6ECA C2F9  30         mov   *stack+,r11           ; Pop r11
0160 6ECC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0116                       ;-----------------------------------------------------------------------
0117                       ; Logic for Editor Buffer
0118                       ;-----------------------------------------------------------------------
0119                       copy  "edb.hipage.alloc.asm"   ; Allocate SAMS page for editor buffer
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
0020 6ECE 0649  14         dect  stack
0021 6ED0 C64B  30         mov   r11,*stack            ; Save return address
0022 6ED2 0649  14         dect  stack
0023 6ED4 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6ED6 0649  14         dect  stack
0025 6ED8 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.hipage.alloc.check_setpage:
0030 6EDA C120  34         mov   @edb.next_free.ptr,tmp0
     6EDC A508     
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6EDE 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6EE0 0FFF     
0035 6EE2 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6EE4 0052     
0036 6EE6 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6EE8 0FF0     
0037 6EEA 1105  14         jlt   edb.hipage.alloc.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6EEC 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6EEE A518     
0043 6EF0 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6EF2 A500     
     6EF4 A508     
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.hipage.alloc.setpage:
0049 6EF6 C120  34         mov   @edb.sams.hipage,tmp0
     6EF8 A518     
0050 6EFA C160  34         mov   @edb.top.ptr,tmp1
     6EFC A500     
0051 6EFE 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6F00 258A     
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6F02 1004  14         jmp   edb.hipage.alloc.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.hipage.alloc.crash:
0060 6F04 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F06 FFCE     
0061 6F08 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F0A 2026     
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.hipage.alloc.exit:
0066 6F0C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6F0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6F10 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6F12 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0120                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6F14 0649  14         dect  stack
0022 6F16 C64B  30         mov   r11,*stack            ; Push return address
0023 6F18 0649  14         dect  stack
0024 6F1A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6F1C 0649  14         dect  stack
0026 6F1E C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6F20 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6F22 A504     
0031 6F24 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6F26 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F28 FFCE     
0037 6F2A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F2C 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6F2E C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6F30 A000     
0043               
0044 6F32 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6F34 6D78     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6F36 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6F38 A012     
0050 6F3A C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6F3C A010     
0051 6F3E 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6F40 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6F42 A208     
0057 6F44 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6F46 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6F48 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6F4A C820  54         mov   @outparm2,@tv.sams.c000
     6F4C A012     
     6F4E A208     
0066                                                   ; Set page in shadow registers
0067               
0068 6F50 C820  54         mov   @outparm2,@edb.sams.page
     6F52 A012     
     6F54 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6F56 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6F58 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6F5A C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6F5C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0121                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6F5E 0649  14         dect  stack
0028 6F60 C64B  30         mov   r11,*stack            ; Save return address
0029 6F62 0649  14         dect  stack
0030 6F64 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6F66 0649  14         dect  stack
0032 6F68 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6F6A 0649  14         dect  stack
0034 6F6C C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6F6E 0649  14         dect  stack
0036 6F70 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6F72 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6F74 A30C     
     6F76 A140     
0041 6F78 04E0  34         clr   @fb.column
     6F7A A30C     
0042 6F7C 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6F7E 6A8A     
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6F80 04C4  14         clr   tmp0                  ; Counter
0047 6F82 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6F84 C160  34         mov   @fb.current,tmp1      ; Get position
     6F86 A302     
0049 6F88 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6F8A A142     
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6F8C D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6F8E 0986  56         srl   tmp2,8                ; Right justify
0056 6F90 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6F92 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6F94 0286  22         ci    tmp2,32               ; Was it a space character?
     6F96 0020     
0063 6F98 1301  14         jeq   edb.line.pack.fb.check80
0064 6F9A C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6F9C 0284  22         ci    tmp0,colrow
     6F9E 0050     
0070 6FA0 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6FA2 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6FA4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FA6 FFCE     
0078 6FA8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FAA 2026     
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6FAC 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6FAE 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6FB0 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6FB2 A144     
0086 6FB4 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6FB6 C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6FB8 A144     
0092               
0093 6FBA 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6FBC C184  18         mov   tmp0,tmp2             ; \
0096 6FBE 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6FC0 0586  14         inc   tmp2                  ; /
0098               
0099 6FC2 C107  18         mov   tmp3,tmp0             ; \
0100 6FC4 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6FC6 A142     
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6FC8 DD05  32         movb  tmp1,*tmp0+
0104 6FCA 0606  14         dec   tmp2
0105 6FCC 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6FCE 06A0  32 !       bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
     6FD0 6ECE     
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6FD2 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6FD4 A304     
     6FD6 A000     
0117 6FD8 A820  54         a     @fb.row,@parm1        ; /
     6FDA A306     
     6FDC A000     
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6FDE C820  54         mov   @edb.next_free.ptr,@parm2
     6FE0 A508     
     6FE2 A002     
0123                                                   ; Pointer to new line
0124 6FE4 C820  54         mov   @edb.sams.hipage,@parm3
     6FE6 A518     
     6FE8 A004     
0125                                                   ; SAMS page to use
0126               
0127 6FEA 06A0  32         bl    @idx.entry.update     ; Update index
     6FEC 6D26     
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6FEE C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6FF0 A142     
0136 6FF2 C160  34         mov   @edb.next_free.ptr,tmp1
     6FF4 A508     
0137                                                   ; Address of line in editor buffer
0138               
0139 6FF6 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6FF8 A508     
0140               
0141 6FFA C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6FFC A144     
0142 6FFE CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 7000 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 7002 0286  22         ci    tmp2,2
     7004 0002     
0150 7006 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 7008 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 700A DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 700C 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 700E 0286  22         ci    tmp2,1
     7010 0001     
0157 7012 1602  14         jne   edb.line.pack.fb.copyline.block
0158 7014 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 7016 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 7018 06A0  32         bl    @xpym2m               ; Copy memory block
     701A 24F4     
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 701C A820  54         a     @rambuf+4,@edb.next_free.ptr
     701E A144     
     7020 A508     
0171                                                      ; Add length of line
0172               
0173 7022 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7024 A508     
0174 7026 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 7028 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     702A 000F     
0176 702C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     702E A508     
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 7030 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7032 A140     
     7034 A30C     
0182               
0183 7036 8820  54         c     @edb.sams.hipage,@edb.sams.page
     7038 A518     
     703A A516     
0184 703C 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 703E C120  34         mov   @edb.sams.page,tmp0
     7040 A516     
0187 7042 C160  34         mov   @edb.top.ptr,tmp1
     7044 A500     
0188 7046 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7048 258A     
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 704A C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 704C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 704E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 7050 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 7052 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 7054 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0122                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0028 7056 0649  14         dect  stack
0029 7058 C64B  30         mov   r11,*stack            ; Save return address
0030 705A 0649  14         dect  stack
0031 705C C644  30         mov   tmp0,*stack           ; Push tmp0
0032 705E 0649  14         dect  stack
0033 7060 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 7062 0649  14         dect  stack
0035 7064 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 7066 C820  54         mov   @parm1,@rambuf
     7068 A000     
     706A A140     
0040 706C C820  54         mov   @parm2,@rambuf+2
     706E A002     
     7070 A142     
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 7072 C120  34         mov   @fb.colsline,tmp0
     7074 A30E     
0045 7076 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7078 A002     
0046 707A C1A0  34         mov   @fb.top.ptr,tmp2
     707C A300     
0047 707E A146  18         a     tmp2,tmp1             ; Add base to offset
0048 7080 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7082 A146     
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 7084 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     7086 A000     
     7088 A504     
0053 708A 1103  14         jlt   !                     ; No, continue processing
0054               
0055 708C 04E0  34         clr   @rambuf+8             ; Set length=0
     708E A148     
0056 7090 1018  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 7092 C120  34 !       mov   @parm1,tmp0
     7094 A000     
0061 7096 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7098 6F14     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 709A C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     709C A010     
0069 709E 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 70A0 04E0  34         clr   @rambuf+8             ; Set length=0
     70A2 A148     
0073 70A4 100E  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 70A6 C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 70A8 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     70AA A144     
0080 70AC C805  38         mov   tmp1,@rambuf+8        ; Save line length
     70AE A148     
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 70B0 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     70B2 0050     
0085                                                   ; /
0086 70B4 1206  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 70B6 C0E0  34         mov   @rambuf,r3            ; Get Line number to unpack (base 0)
     70B8 A140     
0091                                                   ; No purpose, only makes debugging easier
0092               
0093 70BA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70BC FFCE     
0094 70BE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70C0 2026     
0095                       ;------------------------------------------------------
0096                       ; Erase chars from last column until column 80
0097                       ;------------------------------------------------------
0098               edb.line.unpack.fb.clear:
0099 70C2 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     70C4 A146     
0100 70C6 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     70C8 A148     
0101               
0102 70CA 04C5  14         clr   tmp1                  ; Fill with >00
0103 70CC C1A0  34         mov   @fb.colsline,tmp2
     70CE A30E     
0104 70D0 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     70D2 A148     
0105 70D4 0586  14         inc   tmp2
0106               
0107 70D6 06A0  32         bl    @xfilm                ; Fill CPU memory
     70D8 2250     
0108                                                   ; \ i  tmp0 = Target address
0109                                                   ; | i  tmp1 = Byte to fill
0110                                                   ; / i  tmp2 = Repeat count
0111                       ;------------------------------------------------------
0112                       ; Prepare for unpacking data
0113                       ;------------------------------------------------------
0114               edb.line.unpack.fb.prepare:
0115 70DA C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     70DC A148     
0116 70DE 130F  14         jeq   edb.line.unpack.fb.exit
0117                                                   ; Exit if length = 0
0118 70E0 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     70E2 A144     
0119 70E4 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     70E6 A146     
0120                       ;------------------------------------------------------
0121                       ; Assert on line length
0122                       ;------------------------------------------------------
0123               edb.line.unpack.fb.copy:
0124 70E8 0286  22         ci    tmp2,80               ; Check line length
     70EA 0050     
0125 70EC 1204  14         jle   edb.line.unpack.fb.copy.doit
0126                       ;------------------------------------------------------
0127                       ; Crash the system
0128                       ;------------------------------------------------------
0129 70EE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70F0 FFCE     
0130 70F2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70F4 2026     
0131                       ;------------------------------------------------------
0132                       ; Copy memory block
0133                       ;------------------------------------------------------
0134               edb.line.unpack.fb.copy.doit:
0135 70F6 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     70F8 A010     
0136               
0137 70FA 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     70FC 24F4     
0138                                                   ; \ i  tmp0 = Source address
0139                                                   ; | i  tmp1 = Target address
0140                                                   ; / i  tmp2 = Bytes to copy
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               edb.line.unpack.fb.exit:
0145 70FE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0146 7100 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0147 7102 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0148 7104 C2F9  30         mov   *stack+,r11           ; Pop r11
0149 7106 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0123                       copy  "edb.line.getlen.asm"    ; Get line length
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
0021 7108 0649  14         dect  stack
0022 710A C64B  30         mov   r11,*stack            ; Push return address
0023 710C 0649  14         dect  stack
0024 710E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7110 0649  14         dect  stack
0026 7112 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 7114 04E0  34         clr   @outparm1             ; Reset length
     7116 A010     
0031 7118 04E0  34         clr   @outparm2             ; Reset SAMS bank
     711A A012     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 711C C120  34         mov   @parm1,tmp0           ; \
     711E A000     
0036 7120 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 7122 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     7124 A504     
0039 7126 1101  14         jlt   !                     ; No, continue processing
0040 7128 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 712A C120  34 !       mov   @parm1,tmp0           ; Get line
     712C A000     
0046               
0047 712E 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7130 6F14     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 7132 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     7134 A010     
0053 7136 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 7138 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 713A C805  38         mov   tmp1,@outparm1        ; Save length
     713C A010     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 713E 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     7140 0050     
0064 7142 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 7144 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7146 FFCE     
0070 7148 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     714A 2026     
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 714C 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     714E A010     
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 7150 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 7152 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 7154 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 7156 045B  20         b     *r11                  ; Return to caller
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
0103 7158 0649  14         dect  stack
0104 715A C64B  30         mov   r11,*stack            ; Save return address
0105 715C 0649  14         dect  stack
0106 715E C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 7160 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7162 A304     
0111 7164 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7166 A306     
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 7168 C804  38         mov   tmp0,@parm1
     716A A000     
0116 716C 06A0  32         bl    @edb.line.getlength
     716E 7108     
0117 7170 C820  54         mov   @outparm1,@fb.row.length
     7172 A010     
     7174 A308     
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 7176 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 7178 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 717A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0124                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 717C 0649  14         dect  stack
0032 717E C64B  30         mov   r11,*stack            ; Save return address
0033 7180 0649  14         dect  stack
0034 7182 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 7184 0649  14         dect  stack
0036 7186 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 7188 0649  14         dect  stack
0038 718A C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 718C 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     718E A000     
     7190 A504     
0043 7192 1204  14         jle   !
0044 7194 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7196 FFCE     
0045 7198 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     719A 2026     
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 719C C120  34 !       mov   @parm2,tmp0           ; Get target line number
     719E A002     
0050 71A0 0604  14         dec   tmp0                  ; Base 0
0051 71A2 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     71A4 A142     
0052 71A6 04E0  34         clr   @rambuf               ; Set source line length=0
     71A8 A140     
0053 71AA 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     71AC A144     
0054 71AE 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     71B0 A146     
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 71B2 C120  34         mov   @parm1,tmp0           ; Get source line number
     71B4 A000     
0059 71B6 0604  14         dec   tmp0                  ; Base 0
0060               
0061 71B8 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     71BA 6F14     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 71BC C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     71BE A010     
0069 71C0 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 71C2 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 71C4 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 71C6 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     71C8 A140     
0077 71CA 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     71CC A140     
0078 71CE C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     71D0 A144     
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 71D2 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     71D4 0050     
0083 71D6 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 71D8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     71DA FFCE     
0088 71DC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     71DE 2026     
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 71E0 A820  54         a     @w$1000,@edb.top.ptr
     71E2 201A     
     71E4 A500     
0094 71E6 A820  54         a     @w$1000,@edb.next_free.ptr
     71E8 201A     
     71EA A508     
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 71EC 06A0  32         bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
     71EE 6ECE     
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 71F0 C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     71F2 A144     
0111 71F4 C160  34         mov   @edb.next_free.ptr,tmp1
     71F6 A508     
0112                                                   ; Pointer to space for new target line
0113               
0114 71F8 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     71FA A140     
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 71FC 06A0  32         bl    @xpym2m               ; Copy memory block
     71FE 24F4     
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 7200 6820  54         s     @w$1000,@edb.top.ptr
     7202 201A     
     7204 A500     
0127 7206 6820  54         s     @w$1000,@edb.next_free.ptr
     7208 201A     
     720A A508     
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 720C C820  54         mov   @edb.next_free.ptr,@rambuf+6
     720E A508     
     7210 A146     
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 7212 C120  34         mov   @edb.sams.page,tmp0
     7214 A516     
0138 7216 C160  34         mov   @edb.top.ptr,tmp1
     7218 A500     
0139 721A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     721C 258A     
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 721E C120  34         mov   @tv.sams.d000,tmp0
     7220 A20A     
0146 7222 0205  20         li    tmp1,>d000
     7224 D000     
0147 7226 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7228 258A     
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 722A A820  54         a     @rambuf,@edb.next_free.ptr
     722C A140     
     722E A508     
0154                                                      ; Add length of line
0155               
0156 7230 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7232 A508     
0157 7234 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7236 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7238 000F     
0159 723A A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     723C A508     
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 723E C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     7240 A142     
     7242 A000     
0165 7244 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     7246 A146     
     7248 A002     
0166 724A C820  54         mov   @edb.sams.hipage,@parm3
     724C A518     
     724E A004     
0167                                                   ; SAMS page to use
0168               
0169 7250 06A0  32         bl    @idx.entry.update     ; Update index
     7252 6D26     
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 7254 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7256 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7258 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 725A C2F9  30         mov   *stack+,r11           ; Pop r11
0182 725C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0125                       copy  "edb.line.del.asm"       ; Delete line
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
0024 725E 0649  14         dect  stack
0025 7260 C64B  30         mov   r11,*stack            ; Save return address
0026 7262 0649  14         dect  stack
0027 7264 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 7266 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     7268 A000     
     726A A504     
0032 726C 1204  14         jle   !
0033 726E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7270 FFCE     
0034 7272 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7274 2026     
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 7276 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7278 A506     
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 727A C120  34          mov   @edb.lines,tmp0      ; \
     727C A504     
0043 727E 0284  22          ci    tmp0,1               ; | Only single line?
     7280 0001     
0044 7282 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 7284 0620  34         dec   @parm1                ; Base 0
     7286 A000     
0049 7288 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     728A A504     
     728C A002     
0050               
0051 728E 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7290 6DD4     
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 7292 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7294 A504     
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 7296 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7298 A50C     
     729A 2022     
0061 729C 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 729E 8820  54         c     @parm1,@edb.block.m1  ; \
     72A0 A000     
     72A2 A50C     
0064 72A4 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 72A6 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 72A8 8820  54         c     @edb.block.m1,@w$0001 ; \
     72AA A50C     
     72AC 2002     
0068 72AE 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 72B0 0620  34         dec   @edb.block.m1         ; M1--
     72B2 A50C     
0071 72B4 0720  34         seto  @fb.colorize          ; Set colorize flag
     72B6 A310     
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 72B8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     72BA A50E     
     72BC 2022     
0077 72BE 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 72C0 8820  54         c     @parm1,@edb.block.m2  ; \
     72C2 A000     
     72C4 A50E     
0080 72C6 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 72C8 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 72CA 8820  54         c     @edb.block.m2,@w$0001 ; \
     72CC A50E     
     72CE 2002     
0084 72D0 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 72D2 0620  34         dec   @edb.block.m2         ; M2--
     72D4 A50E     
0087 72D6 0720  34         seto  @fb.colorize          ; Set colorize flag
     72D8 A310     
0088 72DA 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 72DC 04E0  34         clr   @parm1                ; 1st line
     72DE A000     
0094 72E0 04E0  34         clr   @parm2                ; 1st line
     72E2 A002     
0095               
0096 72E4 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     72E6 6DD4     
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 72E8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 72EA C2F9  30         mov   *stack+,r11           ; Pop r11
0105 72EC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0126                       copy  "edb.block.mark.asm"     ; Mark code block
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
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * NONE
0018               ********|*****|*********************|**************************
0019               edb.block.mark.m1:
0020 72EE 0649  14         dect  stack
0021 72F0 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 72F2 C820  54         mov   @fb.row,@parm1
     72F4 A306     
     72F6 A000     
0026 72F8 06A0  32         bl    @fb.row2line          ; Row to editor line
     72FA 6A70     
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 72FC 05A0  34         inc   @outparm1             ; Add base 1
     72FE A010     
0032               
0033 7300 C820  54         mov   @outparm1,@edb.block.m1
     7302 A010     
     7304 A50C     
0034                                                   ; Set block marker M1
0035 7306 0720  34         seto  @fb.colorize          ; Set colorize flag
     7308 A310     
0036 730A 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     730C A316     
0037 730E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7310 A318     
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 7312 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 7314 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               ***************************************************************
0047               * edb.block.mark.m2
0048               * Mark M2 line for block operation
0049               ***************************************************************
0050               *  bl   @edb.block.mark.m2
0051               *--------------------------------------------------------------
0052               * INPUT
0053               * NONE
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               * NONE
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * NONE
0060               ********|*****|*********************|**************************
0061               edb.block.mark.m2:
0062 7316 0649  14         dect  stack
0063 7318 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 731A C820  54         mov   @fb.row,@parm1
     731C A306     
     731E A000     
0068 7320 06A0  32         bl    @fb.row2line          ; Row to editor line
     7322 6A70     
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7324 05A0  34         inc   @outparm1             ; Add base 1
     7326 A010     
0074               
0075 7328 C820  54         mov   @outparm1,@edb.block.m2
     732A A010     
     732C A50E     
0076                                                   ; Set block marker M2
0077               
0078 732E 0720  34         seto  @fb.colorize          ; Set colorize flag
     7330 A310     
0079 7332 0720  34         seto  @fb.dirty             ; Trigger refresh
     7334 A316     
0080 7336 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7338 A318     
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 733A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 733C 045B  20         b     *r11                  ; Return to caller
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
0097               * NONE
0098               *--------------------------------------------------------------
0099               * OUTPUT
0100               * NONE
0101               *--------------------------------------------------------------
0102               * Register usage
0103               * tmp0, tmp1
0104               ********|*****|*********************|**************************
0105               edb.block.mark:
0106 733E 0649  14         dect  stack
0107 7340 C64B  30         mov   r11,*stack            ; Push return address
0108 7342 0649  14         dect  stack
0109 7344 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 7346 0649  14         dect  stack
0111 7348 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 734A C820  54         mov   @fb.row,@parm1
     734C A306     
     734E A000     
0116 7350 06A0  32         bl    @fb.row2line          ; Row to editor line
     7352 6A70     
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 7354 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     7356 A010     
0122 7358 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 and M2 must be set
0125                       ;------------------------------------------------------
0126 735A C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     735C A50C     
0127 735E 0584  14         inc   tmp0                  ; /
0128 7360 1608  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and M2 and exit
0132                       ;------------------------------------------------------
0133 7362 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     7364 72EE     
0134 7366 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     7368 7316     
0135 736A 1008  14         jmp   edb.block.mark.exit
0136                       ;------------------------------------------------------
0137                       ; Set M1 and exit
0138                       ;------------------------------------------------------
0139               _edb.block.mark.m1.set:
0140 736C 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     736E 72EE     
0141 7370 1005  14         jmp   edb.block.mark.exit
0142                       ;------------------------------------------------------
0143                       ; Update M1 if current line < M1
0144                       ;------------------------------------------------------
0145               edb.block.mark.is_line_m1:
0146 7372 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     7374 A50C     
0147 7376 15FA  14         jgt   _edb.block.mark.m1.set
0148                                                   ; Set M1 to current line and exit
0149                       ;------------------------------------------------------
0150                       ; Set M2 and exit
0151                       ;------------------------------------------------------
0152 7378 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     737A 7316     
0153                       ;------------------------------------------------------
0154                       ; Exit
0155                       ;------------------------------------------------------
0156               edb.block.mark.exit:
0157 737C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 737E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 7380 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 7382 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0127                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 7384 0649  14         dect  stack
0018 7386 C64B  30         mov   r11,*stack            ; Push return address
0019 7388 0649  14         dect  stack
0020 738A C660  46         mov   @wyx,*stack           ; Push cursor position
     738C 832A     
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 738E 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     7390 A50C     
0025 7392 0720  34         seto  @edb.block.m2         ; /
     7394 A50E     
0026               
0027 7396 0720  34         seto  @fb.colorize          ; Set colorize flag
     7398 A310     
0028 739A 0720  34         seto  @fb.dirty             ; Trigger refresh
     739C A316     
0029 739E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     73A0 A318     
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 73A2 0720  34         seto  @parm1
     73A4 A000     
0034 73A6 06A0  32         bl    @pane.action.colorscheme.load
     73A8 7766     
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 73AA C820  54         mov   @tv.color,@parm1      ; Set normal color
     73AC A218     
     73AE A000     
0042 73B0 06A0  32         bl    @pane.action.colorscheme.statlines
     73B2 791C     
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 73B4 06A0  32         bl    @hchar
     73B6 27DC     
0048 73B8 0034                   byte 0,52,32,18           ; Remove markers
     73BA 2012     
0049 73BC 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     73BE 2037     
0050 73C0 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 73C2 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     73C4 832A     
0056 73C6 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 73C8 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0128                       copy  "edb.block.copy.asm"     ; Copy code block
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
0011               * @parm1 = Message flag
0012               *          (>0000 = Display message "Copying block...")
0013               *          (>ffff = Display message "Moving block....")
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = success (>ffff), no action (>0000)
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * For simplicity reasons we're assuming base 1 during copy
0023               * (first line starts at 1 instead of 0).
0024               * Makes it easier when comparing values.
0025               ********|*****|*********************|**************************
0026               edb.block.copy:
0027 73CA 0649  14         dect  stack
0028 73CC C64B  30         mov   r11,*stack            ; Save return address
0029 73CE 0649  14         dect  stack
0030 73D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 73D2 0649  14         dect  stack
0032 73D4 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 73D6 0649  14         dect  stack
0034 73D8 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 73DA 0649  14         dect  stack
0036 73DC C660  46         mov   @parm1,*stack         ; Push parm1
     73DE A000     
0037 73E0 04E0  34         clr   @outparm1             ; No action (>0000)
     73E2 A010     
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 73E4 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     73E6 A50C     
     73E8 2022     
0042 73EA 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 73EC 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     73EE A50E     
     73F0 2022     
0045 73F2 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 73F4 8820  54         c     @edb.block.m1,@edb.block.m2
     73F6 A50C     
     73F8 A50E     
0048                                                   ; M1 > M2 ?
0049 73FA 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 73FC C820  54         mov   @fb.row,@parm1
     73FE A306     
     7400 A000     
0054 7402 06A0  32         bl    @fb.row2line          ; Row to editor line
     7404 6A70     
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 7406 C120  34         mov   @outparm1,tmp0        ; \
     7408 A010     
0060 740A 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 740C C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     740E A510     
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 7410 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7412 A010     
0066 7414 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 7416 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     7418 A010     
0069 741A 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 741C 06A0  32         bl    @cpym2m
     741E 24EE     
0072 7420 3756                   data txt.block.inside,tv.error.msg,53
     7422 A22A     
     7424 0035     
0073               
0074 7426 06A0  32         bl    @pane.errline.show    ; Show error line
     7428 7A5A     
0075               
0076 742A 04E0  34         clr   @outparm1             ; No action (>0000)
     742C A010     
0077 742E 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 7430 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7432 A21C     
     7434 A000     
0082 7436 06A0  32         bl    @pane.action.colorscheme.statlines
     7438 791C     
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 743A 06A0  32         bl    @hchar
     743C 27DC     
0088 743E 1D00                   byte pane.botrow,0,32,55
     7440 2037     
0089 7442 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 7444 C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 7446 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 7448 06A0  32         bl    @putat
     744A 2456     
0098 744C 1D00                   byte pane.botrow,0
0099 744E 3586                   data txt.block.copy   ; Display "Copying block...."
0100 7450 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 7452 06A0  32         bl    @putat
     7454 2456     
0104 7456 1D00                   byte pane.botrow,0
0105 7458 3598                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 745A C120  34         mov   @edb.block.m1,tmp0    ; M1
     745C A50C     
0111 745E C1A0  34         mov   @edb.block.m2,tmp2    ; \
     7460 A50E     
0112 7462 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 7464 0586  14         inc   tmp2                  ; /
0114               
0115 7466 C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     7468 A510     
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 746A C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     746C A000     
0121 746E 0620  34         dec   @parm1                ; Base 0 offset for index required
     7470 A000     
0122 7472 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7474 A504     
     7476 A002     
0123               
0124 7478 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     747A 6E76     
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 747C 8805  38         c     tmp1,@edb.block.m1
     747E A50C     
0131 7480 1506  14         jgt   edb.block.copy.loop.docopy
0132 7482 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 7484 05A0  34         inc   @edb.block.m1         ; M1++
     7486 A50C     
0135 7488 05A0  34         inc   @edb.block.m2         ; M2++
     748A A50E     
0136 748C 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 748E C804  38         mov   tmp0,@parm1           ; Source line for copy
     7490 A000     
0142 7492 C805  38         mov   tmp1,@parm2           ; Target line for copy
     7494 A002     
0143               
0144 7496 06A0  32         bl    @edb.line.copy        ; Copy line
     7498 717C     
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 749A 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     749C A504     
0151 749E 0584  14         inc   tmp0                  ; Next source line
0152 74A0 0585  14         inc   tmp1                  ; Next target line
0153 74A2 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 74A4 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 74A6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     74A8 A506     
0159 74AA 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     74AC A316     
0160 74AE 0720  34         seto  @outparm1             ; Copy completed
     74B0 A010     
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 74B2 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     74B4 A000     
0166 74B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 74B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 74BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 74BC C2F9  30         mov   *stack+,r11           ; Pop R11
0170 74BE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0129                       copy  "edb.block.del.asm"      ; Delete code block
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
0011               * @parm1 = Message flag
0012               *          (>0000 = Display message "Deleting block")
0013               *          (>ffff = Skip message display)
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = success (>ffff), no action (>0000)
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Remarks
0022               * For simplicity reasons we're assuming base 1 during copy
0023               * (first line starts at 1 instead of 0).
0024               * Makes it easier when comparing values.
0025               ********|*****|*********************|**************************
0026               edb.block.delete:
0027 74C0 0649  14         dect  stack
0028 74C2 C64B  30         mov   r11,*stack            ; Save return address
0029 74C4 0649  14         dect  stack
0030 74C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 74C8 0649  14         dect  stack
0032 74CA C645  30         mov   tmp1,*stack           ; Push tmp1
0033 74CC 0649  14         dect  stack
0034 74CE C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 74D0 04E0  34         clr   @outparm1             ; No action (>0000)
     74D2 A010     
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 74D4 C120  34         mov   @edb.block.m1,tmp0    ; \
     74D6 A50C     
0041 74D8 0584  14         inc   tmp0                  ; | M1 unset?
0042 74DA 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 74DC C160  34         mov   @edb.block.m2,tmp1    ; \
     74DE A50E     
0045 74E0 0584  14         inc   tmp0                  ; | M2 unset?
0046 74E2 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 74E4 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     74E6 A000     
0051 74E8 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 74EA C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     74EC A21C     
     74EE A000     
0056               
0057 74F0 06A0  32         bl    @pane.action.colorscheme.statlines
     74F2 791C     
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 74F4 06A0  32         bl    @hchar
     74F6 27DC     
0063 74F8 1D00                   byte pane.botrow,0,32,55
     74FA 2037     
0064 74FC FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 74FE 06A0  32         bl    @putat
     7500 2456     
0067 7502 1D00                   byte pane.botrow,0
0068 7504 3572                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 7506 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     7508 A50C     
0074 750A 0604  14         dec   tmp0                  ; Base 0
0075               
0076 750C C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     750E A50E     
0077 7510 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7512 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     7514 A000     
0080 7516 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7518 A504     
     751A A002     
0081 751C 0620  34         dec   @parm2                ; Base 0
     751E A002     
0082               
0083 7520 C185  18         mov   tmp1,tmp2             ; \
0084 7522 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 7524 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 7526 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7528 6DD4     
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 752A 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     752C A504     
0095 752E 0620  34         dec   @parm2                ; /
     7530 A002     
0096               
0097 7532 0606  14         dec   tmp2
0098 7534 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 7536 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7538 A506     
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 753A 8820  54         c     @fb.topline,@edb.lines
     753C A304     
     753E A504     
0104                                                   ; Beyond editor buffer?
0105 7540 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7542 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     7544 A304     
     7546 A000     
0108 7548 1002  14         jmp   edb.block.delete.fb.refresh
0109 754A 04E0  34 !       clr   @parm1                ; Set line to start with
     754C A000     
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 754E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     7550 6C7A     
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 7552 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     7554 7384     
0119               
0120 7556 0720  34         seto  @outparm1             ; Delete completed
     7558 A010     
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 755A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 755C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 755E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7560 C2F9  30         mov   *stack+,r11           ; Pop R11
                   < stevie_b1.asm.30692
0130                       copy  "edb.clear.sams.asm"     ; Clear SAMS pages of editor buffer
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
0020 7562 0649  14         dect  stack
0021 7564 C64B  30         mov   r11,*stack            ; Save return address
0022 7566 0649  14         dect  stack
0023 7568 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 756A 0649  14         dect  stack
0025 756C C645  30         mov   tmp1,*stack           ; Push tmp1
0026 756E 0649  14         dect  stack
0027 7570 C646  30         mov   tmp2,*stack           ; Push tmp2
0028 7572 0649  14         dect  stack
0029 7574 C647  30         mov   tmp3,*stack           ; Push tmp3
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 7576 C1A0  34         mov   @edb.sams.hipage,tmp2 ; Highest SAMS page used
     7578 A518     
0034                       ;------------------------------------------------------
0035                       ; Clear SAMS memory
0036                       ;------------------------------------------------------
0037               edb.clear.sams.loop:
0038 757A C106  18         mov   tmp2,tmp0             ; SAMS page
0039 757C 0205  20         li    tmp1,>c000            ; Memory region to map
     757E C000     
0040               
0041 7580 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     7582 258A     
0042                                                   ; \ i  tmp0 = SAMS page
0043                                                   ; / i  tmp1 = Memory address
0044               
0045 7584 0649  14         dect  stack
0046 7586 C646  30         mov   tmp2,*stack           ; Push tmp2
0047               
0048 7588 06A0  32         bl    @film                 ; \ Clear memory
     758A 224A     
0049 758C C000                   data >c000,0,4096     ; / Overwrites tmp0-tmp3 (!)
     758E 0000     
     7590 1000     
0050               
0051 7592 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0052               
0053 7594 0606  14         dec   tmp2
0054 7596 0286  22         ci    tmp2,>3f              ; First page (>40) reached?
     7598 003F     
0055 759A 15EF  14         jgt   edb.clear.sams.loop   ; No, next iteration
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               edb.clear.sams.exit:
0060 759C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0061 759E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 75A0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 75A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 75A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 75A6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0131                       ;-----------------------------------------------------------------------
0132                       ; User hook, background tasks
0133                       ;-----------------------------------------------------------------------
0134                       copy  "hook.keyscan.asm"       ; spectra2 user hook: keyboard scan
     **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 75A8 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     75AA 200A     
0009 75AC 161C  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 75AE C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     75B0 833C     
     75B2 A022     
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 75B4 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     75B6 200A     
0016 75B8 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     75BA A022     
     75BC A024     
0017 75BE 1608  14         jne   hook.keyscan.new      ; New key pressed
0018               *---------------------------------------------------------------
0019               * Activate auto-repeat ?
0020               *---------------------------------------------------------------
0021 75C0 05A0  34         inc   @keyrptcnt
     75C2 A020     
0022 75C4 C120  34         mov   @keyrptcnt,tmp0
     75C6 A020     
0023 75C8 0284  22         ci    tmp0,30
     75CA 001E     
0024 75CC 1112  14         jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
0025 75CE 1002  14         jmp   hook.keyscan.autorepeat
0026               *--------------------------------------------------------------
0027               * New key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.new:
0030 75D0 04E0  34         clr   @keyrptcnt            ; Reset key-repeat counter
     75D2 A020     
0031               hook.keyscan.autorepeat:
0032 75D4 0204  20         li    tmp0,250              ; \
     75D6 00FA     
0033 75D8 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0034 75DA 16FE  14         jne   -!                    ; /
0035 75DC C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     75DE A022     
     75E0 A024     
0036 75E2 0460  28         b     @edkey.key.process    ; Process key
     75E4 60E6     
0037               *--------------------------------------------------------------
0038               * Clear keyboard buffer if no key pressed
0039               *--------------------------------------------------------------
0040               hook.keyscan.clear_kbbuffer:
0041 75E6 04E0  34         clr   @keycode1
     75E8 A022     
0042 75EA 04E0  34         clr   @keycode2
     75EC A024     
0043 75EE 04E0  34         clr   @keyrptcnt
     75F0 A020     
0044               *--------------------------------------------------------------
0045               * Delay to avoid key bouncing
0046               *--------------------------------------------------------------
0047               hook.keyscan.bounce:
0048 75F2 0204  20         li    tmp0,2000             ; Avoid key bouncing
     75F4 07D0     
0049                       ;------------------------------------------------------
0050                       ; Delay loop
0051                       ;------------------------------------------------------
0052               hook.keyscan.bounce.loop:
0053 75F6 0604  14         dec   tmp0
0054 75F8 16FE  14         jne   hook.keyscan.bounce.loop
0055 75FA 0460  28         b     @hookok               ; Return
     75FC 2EE2     
0056               
                   < stevie_b1.asm.30692
0135                       copy  "task.vdp.panes.asm"     ; Draw editor panes in VDP
     **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 75FE 0649  14         dect  stack
0009 7600 C64B  30         mov   r11,*stack            ; Save return address
0010                       ;------------------------------------------------------
0011                       ; Dump panes to VDP memory
0012                       ;------------------------------------------------------
0013 7602 06A0  32         bl    @pane.vdpdump
     7604 7C4E     
0014                       ;------------------------------------------------------
0015                       ; Exit task
0016                       ;------------------------------------------------------
0017               task.vdp.panes.exit:
0018 7606 C2F9  30         mov   *stack+,r11           ; Pop r11
0019 7608 0460  28         b     @slotok
     760A 2F5E     
                   < stevie_b1.asm.30692
0136               
0138               
0139                       copy  "task.vdp.cursor.sat.asm"
     **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 760C 0649  14         dect  stack
0009 760E C64B  30         mov   r11,*stack            ; Save return address
0010 7610 0649  14         dect  stack
0011 7612 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7614 0649  14         dect  stack
0013 7616 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7618 0649  14         dect  stack
0015 761A C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 761C C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     761E A222     
0020               
0021 7620 0284  22         ci    tmp0,pane.focus.fb
     7622 0000     
0022 7624 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7626 0284  22         ci    tmp0,pane.focus.cmdb
     7628 0001     
0025 762A 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 762C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     762E FFCE     
0031 7630 06A0  32         bl    @cpu.crash            ; / Halt system.
     7632 2026     
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7634 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7636 A70A     
     7638 832A     
0037 763A E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     763C 2020     
0038 763E 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7640 2704     
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 7642 100C  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 7644 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7646 2020     
0048 7648 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     764A 2704     
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052                       ;------------------------------------------------------
0053                       ; Cursor Y adjustment (topline, ruler, ...)
0054                       ;------------------------------------------------------
0055 764C C160  34         mov   @tv.ruler.visible,tmp1
     764E A210     
0056 7650 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0057 7652 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     7654 1000     
0058 7656 1002  14         jmp   task.vdp.copy.sat.write
0059               
0060               task.vdp.copy.sat.fb.noruler:
0061 7658 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     765A 0800     
0062                       ;------------------------------------------------------
0063                       ; Dump sprite attribute table
0064                       ;------------------------------------------------------
0065               task.vdp.copy.sat.write:
0066 765C C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     765E A1E0     
0067                       ;------------------------------------------------------
0068                       ; Handle column and row indicators
0069                       ;------------------------------------------------------
0070 7660 C160  34         mov   @tv.ruler.visible,tmp1
     7662 A210     
0071                                                   ; Ruler visible?
0072 7664 1314  14         jeq   task.vdp.copy.sat.hide.indicators
0073                                                   ; Not visible, skip
0074               
0075 7666 C160  34         mov   @cmdb.visible,tmp1
     7668 A702     
0076 766A 0285  22         ci    tmp1,>ffff            ; CMDB pane visible?
     766C FFFF     
0077 766E 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0078                                                   ; Not visible, skip
0079               
0080 7670 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     7672 FF00     
0081 7674 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     7676 00F0     
0082 7678 C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     767A A1E4     
0083               
0084 767C C120  34         mov   @ramsat,tmp0
     767E A1E0     
0085 7680 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     7682 00FF     
0086 7684 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     7686 0800     
0087 7688 C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     768A A1E8     
0088               
0089 768C 1005  14         jmp   task.vdp.copy.sat.write2
0090                       ;------------------------------------------------------
0091                       ; Do not show column and row indicators
0092                       ;------------------------------------------------------
0093               task.vdp.copy.sat.hide.indicators:
0094 768E 04C5  14         clr   tmp1
0095 7690 D805  38         movb  tmp1,@ramsat+7        ; \ Hide line indicator    <
     7692 A1E7     
0096                                                   ; / by transparant color
0097 7694 D805  38         movb  tmp1,@ramsat+11       ; \ Hide column indicator  v
     7696 A1EB     
0098                                                   ; / by transparant color
0099                       ;------------------------------------------------------
0100                       ; Dump to VDP
0101                       ;------------------------------------------------------
0102               task.vdp.copy.sat.write2:
0103 7698 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     769A 249A     
0104 769C 2180                   data sprsat,ramsat,14 ; \ i  p0 = VDP destination
     769E A1E0     
     76A0 000E     
0105                                                   ; | i  p1 = ROM/RAM source
0106                                                   ; / i  p2 = Number of bytes to write
0107                       ;------------------------------------------------------
0108                       ; Exit
0109                       ;------------------------------------------------------
0110               task.vdp.copy.sat.exit:
0111 76A2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0112 76A4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0113 76A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0114 76A8 C2F9  30         mov   *stack+,r11           ; Pop r11
0115 76AA 0460  28         b     @slotok               ; Exit task
     76AC 2F5E     
                   < stevie_b1.asm.30692
0140                                                      ; Copy cursor SAT to VDP
0141                       copy  "task.vdp.cursor.f18a.asm"
     **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 76AE 0649  14         dect  stack
0009 76B0 C64B  30         mov   r11,*stack            ; Save return address
0010 76B2 0649  14         dect  stack
0011 76B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 76B6 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     76B8 A312     
0016 76BA 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 76BC 04C4  14         clr   tmp0
0021 76BE D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     76C0 A1E3     
0022 76C2 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 76C4 C820  54         mov   @tv.curshape,@ramsat+2
     76C6 A214     
     76C8 A1E2     
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 76CA 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     76CC 249A     
0035 76CE 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     76D0 A1E0     
     76D2 0004     
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 76D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 76D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0044 76D8 0460  28         b     @slotok               ; Exit task
     76DA 2F5E     
                   < stevie_b1.asm.30692
0142                                                      ; Set cursor shape in VDP (blink)
0149               
0150                       copy  "task.oneshot.asm"       ; Run "one shot" task
     **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 76DC C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     76DE A224     
0010 76E0 1301  14         jeq   task.oneshot.exit
0011               
0012 76E2 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 76E4 0460  28         b     @slotok                ; Exit task
     76E6 2F5E     
                   < stevie_b1.asm.30692
0151                       ;-----------------------------------------------------------------------
0152                       ; Screen pane utilities
0153                       ;-----------------------------------------------------------------------
0154                       copy  "pane.utils.asm"         ; Pane utility functions
     **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Some utility functions. Shared code for all panes
0003               
0004               ***************************************************************
0005               * pane.clearmsg.task.callback
0006               * Remove message
0007               ***************************************************************
0008               * Called from one-shot task
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
0019               pane.clearmsg.task.callback:
0020 76E8 0649  14         dect  stack
0021 76EA C64B  30         mov   r11,*stack            ; Push return address
0022 76EC 0649  14         dect  stack
0023 76EE C660  46         mov   @wyx,*stack           ; Push cursor position
     76F0 832A     
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 76F2 06A0  32         bl    @hchar
     76F4 27DC     
0028 76F6 0034                   byte 0,52,32,18
     76F8 2012     
0029 76FA FFFF                   data EOL              ; Clear message
0030               
0031 76FC 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     76FE A224     
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 7700 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7702 832A     
0037 7704 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 7706 045B  20         b     *r11                  ; Return to task
                   < stevie_b1.asm.30692
0155                       copy  "pane.utils.colorscheme.asm"
     **** ****     > pane.utils.colorscheme.asm
0001               * FILE......: pane.utils.colorscheme.asm
0002               * Purpose...: Stevie Editor - Color scheme for panes
0003               
0004               ***************************************************************
0005               * pane.action.colorschene.cycle
0006               * Cycle through available color scheme
0007               ***************************************************************
0008               * bl  @pane.action.colorscheme.cycle
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.action.colorscheme.cycle:
0017 7708 0649  14         dect  stack
0018 770A C64B  30         mov   r11,*stack            ; Push return address
0019 770C 0649  14         dect  stack
0020 770E C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 7710 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7712 A212     
0023 7714 0284  22         ci    tmp0,tv.colorscheme.entries
     7716 000A     
0024                                                   ; Last entry reached?
0025 7718 1103  14         jlt   !
0026 771A 0204  20         li    tmp0,1                ; Reset color scheme index
     771C 0001     
0027 771E 1001  14         jmp   pane.action.colorscheme.switch
0028 7720 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 7722 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7724 A212     
0034               
0035 7726 06A0  32         bl    @pane.action.colorscheme.load
     7728 7766     
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 772A C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     772C 832A     
     772E 833C     
0041               
0042 7730 06A0  32         bl    @putnum
     7732 2B28     
0043 7734 003E                   byte 0,62
0044 7736 A212                   data tv.colorscheme,rambuf,>3020
     7738 A140     
     773A 3020     
0045               
0046 773C 06A0  32         bl    @putat
     773E 2456     
0047 7740 0034                   byte 0,52
0048 7742 378E                   data txt.colorscheme  ; Show color palette message
0049               
0050 7744 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     7746 833C     
     7748 832A     
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 774A 0204  20         li    tmp0,12000
     774C 2EE0     
0055 774E 0604  14 !       dec   tmp0
0056 7750 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 7752 0204  20         li    tmp0,pane.clearmsg.task.callback
     7754 76E8     
0061 7756 C804  38         mov   tmp0,@tv.task.oneshot
     7758 A224     
0062               
0063 775A 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     775C 2FD2     
0064 775E 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 7760 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7762 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 7764 045B  20         b     *r11                  ; Return to caller
0072               
0073               
0074               
0075               ***************************************************************
0076               * pane.action.colorscheme.load
0077               * Load color scheme
0078               ***************************************************************
0079               * bl  @pane.action.colorscheme.load
0080               *--------------------------------------------------------------
0081               * INPUT
0082               * @tv.colorscheme = Index into color scheme table
0083               * @parm1          = Skip screen off if >FFFF
0084               * @parm2          = Skip colorizing marked lines if >FFFF
0085               *--------------------------------------------------------------
0086               * OUTPUT
0087               * none
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0,tmp1,tmp2,tmp3,tmp4
0091               ********|*****|*********************|**************************
0092               pane.action.colorscheme.load:
0093 7766 0649  14         dect  stack
0094 7768 C64B  30         mov   r11,*stack            ; Save return address
0095 776A 0649  14         dect  stack
0096 776C C644  30         mov   tmp0,*stack           ; Push tmp0
0097 776E 0649  14         dect  stack
0098 7770 C645  30         mov   tmp1,*stack           ; Push tmp1
0099 7772 0649  14         dect  stack
0100 7774 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 7776 0649  14         dect  stack
0102 7778 C647  30         mov   tmp3,*stack           ; Push tmp3
0103 777A 0649  14         dect  stack
0104 777C C648  30         mov   tmp4,*stack           ; Push tmp4
0105 777E 0649  14         dect  stack
0106 7780 C660  46         mov   @parm1,*stack         ; Push parm1
     7782 A000     
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 7784 C120  34         mov   @parm1,tmp0
     7786 A000     
0111 7788 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     778A FFFF     
0112 778C 1302  14         jeq   !                     ; Yes, so skip screen off
0113 778E 06A0  32         bl    @scroff               ; Turn screen off
     7790 26A2     
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7792 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7794 A212     
0118 7796 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 7798 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 779A 0224  22         ai    tmp0,tv.colorscheme.table
     779C 34E4     
0122                                                   ; Add base for color scheme data table
0123 779E C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 77A0 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     77A2 A218     
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 77A4 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 77A6 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     77A8 00FF     
0130 77AA C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     77AC A216     
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 77AE C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 77B0 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     77B2 FF00     
0136 77B4 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 77B6 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 77B8 C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 77BA 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 77BC C806  38         mov   tmp2,@tv.busycolor    ; /
     77BE A21C     
0142               
0143 77C0 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     77C2 00FF     
0144 77C4 C805  38         mov   tmp1,@tv.markcolor    ; /
     77C6 A21A     
0145               
0146 77C8 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 77CA 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 77CC C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     77CE A220     
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 77D0 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 77D2 0245  22         andi  tmp1,>000f            ; Only keep P
     77D4 000F     
0154 77D6 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 77D8 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     77DA A21E     
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 77DC C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 77DE 0245  22         andi  tmp1,>00f0            ; Only keep O
     77E0 00F0     
0161 77E2 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 77E4 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     77E6 A1E7     
0163 77E8 D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     77EA A1EB     
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 77EC C147  18         mov   tmp3,tmp1             ; Get work copy
0168 77EE 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 77F0 0265  22         ori   tmp1,>0700
     77F2 0700     
0170 77F4 C105  18         mov   tmp1,tmp0
0171 77F6 06A0  32         bl    @putvrx               ; Write VDP register
     77F8 2348     
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 77FA C120  34         mov   @tv.ruler.visible,tmp0
     77FC A210     
0176 77FE 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177                       ;-------------------------------------------------------
0178                       ; Ruler visible on screen (TAT)
0179                       ;-------------------------------------------------------
0180 7800 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     7802 18A0     
0181                                                   ; VDP start address (frame buffer area)
0182               
0183 7804 0206  20         li    tmp2,(pane.botrow-2)*80
     7806 0870     
0184                                                   ; Number of bytes to fill
0185 7808 1004  14         jmp   pane.action.colorscheme.checkcmdb
0186               
0187               pane.action.colorscheme.fbdump.noruler:
0188                       ;-------------------------------------------------------
0189                       ; No ruler visible on screen (TAT)
0190                       ;-------------------------------------------------------
0191 780A 0204  20         li    tmp0,vdp.fb.toprow.tat
     780C 1850     
0192                                                   ; VDP start address (frame buffer area)
0193 780E 0206  20         li    tmp2,(pane.botrow-1)*80
     7810 08C0     
0194                                                   ; Number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Adjust bottom of frame buffer if CMDB visible
0197                       ;-------------------------------------------------------
0198               pane.action.colorscheme.checkcmdb:
0199 7812 C820  54         mov   @cmdb.visible,@cmdb.visible
     7814 A702     
     7816 A702     
0200 7818 1302  14         jeq   pane.action.colorscheme.fbdump
0201                                                   ; Not visible, skip adjustment
0202 781A 0226  22         ai    tmp2,-320             ; CMDB adjustment
     781C FEC0     
0203                       ;-------------------------------------------------------
0204                       ; Dump colors to VDP (TAT)
0205                       ;-------------------------------------------------------
0206               pane.action.colorscheme.fbdump:
0207 781E C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0208 7820 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0209               
0210 7822 06A0  32         bl    @xfilv                ; Fill colors
     7824 22A8     
0211                                                   ; i \  tmp0 = start address
0212                                                   ; i |  tmp1 = byte to fill
0213                                                   ; i /  tmp2 = number of bytes to fill
0214                       ;-------------------------------------------------------
0215                       ; Colorize marked lines
0216                       ;-------------------------------------------------------
0217 7826 C120  34         mov   @parm2,tmp0
     7828 A002     
0218 782A 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     782C FFFF     
0219 782E 1304  14         jeq   pane.action.colorscheme.cmdbpane
0220               
0221 7830 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     7832 A310     
0222 7834 06A0  32         bl    @fb.colorlines
     7836 7E4A     
0223                       ;-------------------------------------------------------
0224                       ; Dump colors for CMDB header line (TAT)
0225                       ;-------------------------------------------------------
0226               pane.action.colorscheme.cmdbpane:
0227 7838 C120  34         mov   @cmdb.visible,tmp0
     783A A702     
0228 783C 132B  14         jeq   pane.action.colorscheme.errpane
0229                                                   ; Skip if CMDB pane is hidden
0230               
0231 783E 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     7840 1FD0     
0232                                                   ; VDP start address (CMDB top line)
0233               
0234 7842 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     7844 A220     
0235 7846 0206  20         li    tmp2,1*67             ; Number of bytes to fill
     7848 0043     
0236 784A 06A0  32         bl    @xfilv                ; Fill colors
     784C 22A8     
0237                                                   ; i \  tmp0 = start address
0238                                                   ; i |  tmp1 = byte to fill
0239                                                   ; i /  tmp2 = number of bytes to fill
0240                       ;-------------------------------------------------------
0241                       ; Dump colors for CMDB Stevie logo (TAT)
0242                       ;-------------------------------------------------------
0243 784E 0204  20         li    tmp0,vdp.cmdb.toprow.tat+67
     7850 2013     
0244 7852 C160  34         mov   @tv.cmdb.hcolor,tmp1  ;
     7854 A220     
0245 7856 D160  34         movb  @tv.cmdb.hcolor+1,tmp1
     7858 A221     
0246                                                   ; Copy same value into MSB
0247 785A 0945  56         srl   tmp1,4                ;
0248 785C 0245  22         andi  tmp1,>00ff            ; Only keep LSB
     785E 00FF     
0249               
0250 7860 0206  20         li    tmp2,13               ; Number of bytes to fill
     7862 000D     
0251 7864 06A0  32         bl    @xfilv                ; Fill colors
     7866 22A8     
0252                                                   ; i \  tmp0 = start address
0253                                                   ; i |  tmp1 = byte to fill
0254                                                   ; i /  tmp2 = number of bytes to fill
0255                       ;-------------------------------------------------------
0256                       ; Dump colors for CMDB pane content (TAT)
0257                       ;-------------------------------------------------------
0258 7868 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     786A 2020     
0259                                                   ; VDP start address (CMDB top line + 1)
0260 786C C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0261 786E 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7870 0050     
0262 7872 06A0  32         bl    @xfilv                ; Fill colors
     7874 22A8     
0263                                                   ; i \  tmp0 = start address
0264                                                   ; i |  tmp1 = byte to fill
0265                                                   ; i /  tmp2 = number of bytes to fill
0266               
0267 7876 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 160
     7878 2070     
0268                                                   ; VDP start address (CMDB top line + 2)
0269 787A C160  34         mov   @tv.cmdb.hcolor,tmp1  ; Same color as header line
     787C A220     
0270 787E 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7880 0050     
0271 7882 06A0  32         bl    @xfilv                ; Fill colors
     7884 22A8     
0272                                                   ; i \  tmp0 = start address
0273                                                   ; i |  tmp1 = byte to fill
0274                                                   ; i /  tmp2 = number of bytes to fill
0275               
0276 7886 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 240
     7888 20C0     
0277                                                   ; VDP start address (CMDB top line + 3)
0278 788A C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0279 788C 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     788E 0050     
0280 7890 06A0  32         bl    @xfilv                ; Fill colors
     7892 22A8     
0281                                                   ; i \  tmp0 = start address
0282                                                   ; i |  tmp1 = byte to fill
0283                                                   ; i /  tmp2 = number of bytes to fill
0284                       ;-------------------------------------------------------
0285                       ; Dump colors for error line (TAT)
0286                       ;-------------------------------------------------------
0287               pane.action.colorscheme.errpane:
0288 7894 C120  34         mov   @tv.error.visible,tmp0
     7896 A228     
0289 7898 130A  14         jeq   pane.action.colorscheme.statline
0290                                                   ; Skip if error line pane is hidden
0291               
0292 789A 0205  20         li    tmp1,>00f6            ; White on dark red
     789C 00F6     
0293 789E C805  38         mov   tmp1,@parm1           ; Pass color combination
     78A0 A000     
0294               
0295 78A2 0205  20         li    tmp1,pane.botrow-1    ;
     78A4 001C     
0296 78A6 C805  38         mov   tmp1,@parm2           ; Error line on screen
     78A8 A002     
0297               
0298 78AA 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78AC 7974     
0299                                                   ; \ i  @parm1 = Color combination
0300                                                   ; / i  @parm2 = Row on physical screen
0301                       ;-------------------------------------------------------
0302                       ; Dump colors for top line and bottom line (TAT)
0303                       ;-------------------------------------------------------
0304               pane.action.colorscheme.statline:
0305 78AE C160  34         mov   @tv.color,tmp1
     78B0 A218     
0306 78B2 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     78B4 00FF     
0307 78B6 C805  38         mov   tmp1,@parm1           ; Set color combination
     78B8 A000     
0308               
0309               
0310 78BA 04E0  34         clr   @parm2                ; Top row on screen
     78BC A002     
0311 78BE 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78C0 7974     
0312                                                   ; \ i  @parm1 = Color combination
0313                                                   ; / i  @parm2 = Row on physical screen
0314               
0315 78C2 0205  20         li    tmp1,pane.botrow
     78C4 001D     
0316 78C6 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     78C8 A002     
0317 78CA 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78CC 7974     
0318                                                   ; \ i  @parm1 = Color combination
0319                                                   ; / i  @parm2 = Row on physical screen
0320                       ;-------------------------------------------------------
0321                       ; Dump colors for ruler if visible (TAT)
0322                       ;-------------------------------------------------------
0323 78CE C160  34         mov   @tv.ruler.visible,tmp1
     78D0 A210     
0324 78D2 1307  14         jeq   pane.action.colorscheme.cursorcolor
0325               
0326 78D4 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     78D6 7E38     
0327 78D8 06A0  32         bl    @cpym2v
     78DA 249A     
0328 78DC 1850                   data vdp.fb.toprow.tat
0329 78DE A36E                   data fb.ruler.tat
0330 78E0 0050                   data 80               ; Show ruler colors
0331                       ;-------------------------------------------------------
0332                       ; Dump cursor FG color to sprite table (SAT)
0333                       ;-------------------------------------------------------
0334               pane.action.colorscheme.cursorcolor:
0335 78E2 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     78E4 A216     
0336               
0337 78E6 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     78E8 A222     
0338 78EA 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     78EC 0000     
0339 78EE 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0340                                                   ; Yes, set cursor color
0341               
0342               pane.action.colorscheme.cursorcolor.cmdb:
0343 78F0 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     78F2 00F0     
0344 78F4 0A48  56         sla   tmp4,4                ; Move to MSB
0345 78F6 1003  14         jmp   !
0346               
0347               pane.action.colorscheme.cursorcolor.fb:
0348 78F8 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     78FA 000F     
0349 78FC 0A88  56         sla   tmp4,8                ; Move to MSB
0350               
0351 78FE D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7900 A1E3     
0352 7902 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7904 A215     
0353                       ;-------------------------------------------------------
0354                       ; Exit
0355                       ;-------------------------------------------------------
0356               pane.action.colorscheme.load.exit:
0357 7906 06A0  32         bl    @scron                ; Turn screen on
     7908 26AA     
0358 790A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     790C A000     
0359 790E C239  30         mov   *stack+,tmp4          ; Pop tmp4
0360 7910 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0361 7912 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0362 7914 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0363 7916 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0364 7918 C2F9  30         mov   *stack+,r11           ; Pop R11
0365 791A 045B  20         b     *r11                  ; Return to caller
0366               
0367               
0368               
0369               ***************************************************************
0370               * pane.action.colorscheme.statline
0371               * Set color combination for bottom status line
0372               ***************************************************************
0373               * bl @pane.action.colorscheme.statlines
0374               *--------------------------------------------------------------
0375               * INPUT
0376               * @parm1 = Color combination to set
0377               *--------------------------------------------------------------
0378               * OUTPUT
0379               * none
0380               *--------------------------------------------------------------
0381               * Register usage
0382               * tmp0, tmp1, tmp2
0383               ********|*****|*********************|**************************
0384               pane.action.colorscheme.statlines:
0385 791C 0649  14         dect  stack
0386 791E C64B  30         mov   r11,*stack            ; Save return address
0387 7920 0649  14         dect  stack
0388 7922 C644  30         mov   tmp0,*stack           ; Push tmp0
0389                       ;------------------------------------------------------
0390                       ; Bottom line
0391                       ;------------------------------------------------------
0392 7924 0204  20         li    tmp0,pane.botrow
     7926 001D     
0393 7928 C804  38         mov   tmp0,@parm2           ; Last row on screen
     792A A002     
0394 792C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     792E 7974     
0395                                                   ; \ i  @parm1 = Color combination
0396                                                   ; / i  @parm2 = Row on physical screen
0397                       ;------------------------------------------------------
0398                       ; Exit
0399                       ;------------------------------------------------------
0400               pane.action.colorscheme.statlines.exit:
0401 7930 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0402 7932 C2F9  30         mov   *stack+,r11           ; Pop R11
0403 7934 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0156                                                      ; Colorscheme handling in panes
0157                       copy  "pane.cursor.asm"        ; Cursor utility functions
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
0020 7936 0649  14         dect  stack
0021 7938 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 793A 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     793C 22A2     
0026 793E 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     7940 0000     
     7942 0008     
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 7944 06A0  32         bl    @clslot
     7946 2FC4     
0031 7948 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 794A 06A0  32         bl    @clslot
     794C 2FC4     
0034 794E 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 7950 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 7952 045B  20         b     *r11                  ; Return to caller
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
0060 7954 0649  14         dect  stack
0061 7956 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 7958 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     795A 22A2     
0066 795C 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     795E 0000     
     7960 0004     
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 7962 06A0  32         bl    @mkslot
     7964 2FA6     
0073 7966 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     7968 760C     
0074 796A 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     796C 76AE     
0075 796E FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 7970 C2F9  30         mov   *stack+,r11           ; Pop R11
0090 7972 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0158                       ;-----------------------------------------------------------------------
0159                       ; Screen panes
0160                       ;-----------------------------------------------------------------------
0161                       copy  "colors.line.set.asm"    ; Set color combination for line
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
0021 7974 0649  14         dect  stack
0022 7976 C64B  30         mov   r11,*stack            ; Save return address
0023 7978 0649  14         dect  stack
0024 797A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 797C 0649  14         dect  stack
0026 797E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7980 0649  14         dect  stack
0028 7982 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7984 0649  14         dect  stack
0030 7986 C660  46         mov   @parm1,*stack         ; Push parm1
     7988 A000     
0031 798A 0649  14         dect  stack
0032 798C C660  46         mov   @parm2,*stack         ; Push parm2
     798E A002     
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 7990 C120  34         mov   @parm2,tmp0           ; Get target line
     7992 A002     
0037 7994 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7996 0050     
0038 7998 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 799A C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 799C 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     799E 1800     
0042 79A0 C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     79A2 A000     
0043 79A4 0206  20         li    tmp2,80               ; Number of bytes to fill
     79A6 0050     
0044               
0045 79A8 06A0  32         bl    @xfilv                ; Fill colors
     79AA 22A8     
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 79AC C839  50         mov   *stack+,@parm2        ; Pop @parm2
     79AE A002     
0054 79B0 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     79B2 A000     
0055 79B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 79B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 79B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 79BA C2F9  30         mov   *stack+,r11           ; Pop R11
0059 79BC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0162                       copy  "pane.topline.asm"       ; Top line
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
0017 79BE 0649  14         dect  stack
0018 79C0 C64B  30         mov   r11,*stack            ; Save return address
0019 79C2 0649  14         dect  stack
0020 79C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79C6 0649  14         dect  stack
0022 79C8 C660  46         mov   @wyx,*stack           ; Push cursor position
     79CA 832A     
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 79CC 06A0  32         bl    @at
     79CE 26E2     
0028 79D0 0000                   byte 0,0              ; y=0, x=0
0029               
0030 79D2 C820  54         mov   @edb.filename.ptr,@parm1
     79D4 A512     
     79D6 A000     
0031                                                   ; Get string to display
0032 79D8 0204  20         li    tmp0,47
     79DA 002F     
0033 79DC C804  38         mov   tmp0,@parm2           ; Set requested length
     79DE A002     
0034 79E0 0204  20         li    tmp0,32
     79E2 0020     
0035 79E4 C804  38         mov   tmp0,@parm3           ; Set character to fill
     79E6 A004     
0036 79E8 0204  20         li    tmp0,rambuf
     79EA A140     
0037 79EC C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     79EE A006     
0038               
0039               
0040 79F0 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     79F2 33B4     
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 79F4 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     79F6 A010     
0048 79F8 06A0  32         bl    @xutst0               ; /
     79FA 2434     
0049                       ;------------------------------------------------------
0050                       ; Show M1 marker
0051                       ;------------------------------------------------------
0052 79FC C120  34         mov   @edb.block.m1,tmp0    ; \
     79FE A50C     
0053 7A00 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0054 7A02 1326  14         jeq   pane.topline.exit     ; /
0055               
0056 7A04 06A0  32         bl    @putat
     7A06 2456     
0057 7A08 0034                   byte 0,52
0058 7A0A 3602                   data txt.m1           ; Show M1 marker message
0059               
0060 7A0C C820  54         mov   @edb.block.m1,@parm1
     7A0E A50C     
     7A10 A000     
0061 7A12 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7A14 3388     
0062                                                   ; \ i @parm1           = uint16
0063                                                   ; / o @unpacked.string = Output string
0064               
0065 7A16 0204  20         li    tmp0,>0500
     7A18 0500     
0066 7A1A D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7A1C A026     
0067               
0068 7A1E 06A0  32         bl    @putat
     7A20 2456     
0069 7A22 0037                   byte 0,55
0070 7A24 A026                   data unpacked.string  ; Show M1 value
0071                       ;------------------------------------------------------
0072                       ; Show M2 marker
0073                       ;------------------------------------------------------
0074 7A26 C120  34         mov   @edb.block.m2,tmp0    ; \
     7A28 A50E     
0075 7A2A 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0076 7A2C 1311  14         jeq   pane.topline.exit     ; /
0077               
0078 7A2E 06A0  32         bl    @putat
     7A30 2456     
0079 7A32 003E                   byte 0,62
0080 7A34 3606                   data txt.m2           ; Show M2 marker message
0081               
0082 7A36 C820  54         mov   @edb.block.m2,@parm1
     7A38 A50E     
     7A3A A000     
0083 7A3C 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7A3E 3388     
0084                                                   ; \ i @parm1           = uint16
0085                                                   ; / o @unpacked.string = Output string
0086               
0087 7A40 0204  20         li    tmp0,>0500
     7A42 0500     
0088 7A44 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7A46 A026     
0089               
0090 7A48 06A0  32         bl    @putat
     7A4A 2456     
0091 7A4C 0041                   byte 0,65
0092 7A4E A026                   data unpacked.string  ; Show M2 value
0093                       ;------------------------------------------------------
0094                       ; Exit
0095                       ;------------------------------------------------------
0096               pane.topline.exit:
0097 7A50 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7A52 832A     
0098 7A54 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 7A56 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 7A58 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0163                       copy  "pane.errline.asm"       ; Error line
     **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Stevie Editor - Error line pane
0003               
0004               ***************************************************************
0005               * pane.errline.show
0006               * Show command buffer pane
0007               ***************************************************************
0008               * bl @pane.errline.show
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               pane.errline.show:
0022 7A5A 0649  14         dect  stack
0023 7A5C C64B  30         mov   r11,*stack            ; Save return address
0024 7A5E 0649  14         dect  stack
0025 7A60 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7A62 0649  14         dect  stack
0027 7A64 C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7A66 0205  20         li    tmp1,>00f6            ; White on dark red
     7A68 00F6     
0030 7A6A C805  38         mov   tmp1,@parm1
     7A6C A000     
0031               
0032 7A6E 0205  20         li    tmp1,pane.botrow-1    ;
     7A70 001C     
0033 7A72 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7A74 A002     
0034               
0035 7A76 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7A78 7974     
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7A7A 0204  20         li    tmp0,tv.error.msg
     7A7C A22A     
0043 7A7E C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7A80 A000     
0044               
0045 7A82 0204  20         li    tmp0,80
     7A84 0050     
0046 7A86 C804  38         mov   tmp0,@parm2           ; Set requested length
     7A88 A002     
0047               
0048 7A8A 0204  20         li    tmp0,32
     7A8C 0020     
0049 7A8E C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A90 A004     
0050               
0051 7A92 0204  20         li    tmp0,rambuf
     7A94 A140     
0052 7A96 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A98 A006     
0053               
0054 7A9A 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A9C 33B4     
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7A9E 06A0  32         bl    @at
     7AA0 26E2     
0064 7AA2 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7AA4 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7AA6 A010     
0067 7AA8 06A0  32         bl    @xutst0               ; /
     7AAA 2434     
0068               
0069 7AAC C120  34         mov   @fb.scrrows.max,tmp0
     7AAE A31C     
0070 7AB0 0604  14         dec   tmp0
0071 7AB2 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7AB4 A31A     
0072               
0073 7AB6 0720  34         seto  @tv.error.visible     ; Error line is visible
     7AB8 A228     
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7ABA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7ABC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7ABE C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7AC0 045B  20         b     *r11                  ; Return to caller
0082               
0083               
0084               
0085               ***************************************************************
0086               * pane.errline.hide
0087               * Hide error line
0088               ***************************************************************
0089               * bl @pane.errline.hide
0090               *--------------------------------------------------------------
0091               * INPUT
0092               * none
0093               *--------------------------------------------------------------
0094               * OUTPUT
0095               * none
0096               *--------------------------------------------------------------
0097               * Register usage
0098               * none
0099               *--------------------------------------------------------------
0100               * Hiding the error line passes pane focus to frame buffer.
0101               ********|*****|*********************|**************************
0102               pane.errline.hide:
0103 7AC2 0649  14         dect  stack
0104 7AC4 C64B  30         mov   r11,*stack            ; Save return address
0105 7AC6 0649  14         dect  stack
0106 7AC8 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Get color combination
0109                       ;------------------------------------------------------
0110 7ACA 06A0  32         bl    @errline.init         ; Clear error line string in RAM
     7ACC 331C     
0111               
0112 7ACE C120  34         mov   @cmdb.visible,tmp0
     7AD0 A702     
0113 7AD2 1303  14         jeq   pane.errline.hide.fbcolor
0114                       ;------------------------------------------------------
0115                       ; CMDB pane color
0116                       ;------------------------------------------------------
0117 7AD4 C120  34         mov   @tv.cmdb.hcolor,tmp0  ; Get colors of CMDB header line
     7AD6 A220     
0118 7AD8 1003  14         jmp   !
0119                       ;------------------------------------------------------
0120                       ; Frame buffer color
0121                       ;------------------------------------------------------
0122               pane.errline.hide.fbcolor:
0123 7ADA C120  34         mov   @tv.color,tmp0        ; Get colors
     7ADC A218     
0124 7ADE 0984  56         srl   tmp0,8                ; Get rid of status line colors
0125                       ;------------------------------------------------------
0126                       ; Dump colors
0127                       ;------------------------------------------------------
0128 7AE0 C804  38 !       mov   tmp0,@parm1           ; set foreground/background color
     7AE2 A000     
0129 7AE4 0205  20         li    tmp1,pane.botrow-1    ;
     7AE6 001C     
0130 7AE8 C805  38         mov   tmp1,@parm2           ; Position of error line on screen
     7AEA A002     
0131               
0132 7AEC 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7AEE 7974     
0133                                                   ; \ i  @parm1 = Color combination
0134                                                   ; / i  @parm2 = Row on physical screen
0135               
0136 7AF0 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7AF2 A228     
0137 7AF4 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7AF6 A31C     
     7AF8 A31A     
0138                                                   ; Set frame buffer to full size again
0139                       ;------------------------------------------------------
0140                       ; Exit
0141                       ;------------------------------------------------------
0142               pane.errline.hide.exit:
0143 7AFA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0144 7AFC C2F9  30         mov   *stack+,r11           ; Pop r11
0145 7AFE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0164                       copy  "pane.botline.asm"       ; Bottom line
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
0017 7B00 0649  14         dect  stack
0018 7B02 C64B  30         mov   r11,*stack            ; Save return address
0019 7B04 0649  14         dect  stack
0020 7B06 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7B08 0649  14         dect  stack
0022 7B0A C660  46         mov   @wyx,*stack           ; Push cursor position
     7B0C 832A     
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 7B0E C120  34         mov   @edb.block.m2,tmp0    ; \
     7B10 A50E     
0027 7B12 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 7B14 1305  14         jeq   pane.botline.show_keys
0030               
0031 7B16 06A0  32         bl    @putat
     7B18 2456     
0032 7B1A 1D00                   byte pane.botrow,0
0033 7B1C 3612                   data txt.keys.block   ; Show block shortcuts
0034               
0035 7B1E 1004  14         jmp   pane.botline.show_dirty
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 7B20 06A0  32         bl    @putat
     7B22 2456     
0041 7B24 1D00                   byte pane.botrow,0
0042 7B26 360A                   data txt.keys.default ; Show default shortcuts
0043                       ;------------------------------------------------------
0044                       ; Show if text was changed in editor buffer
0045                       ;------------------------------------------------------
0046               pane.botline.show_dirty:
0047 7B28 C120  34         mov   @edb.dirty,tmp0
     7B2A A506     
0048 7B2C 1305  14         jeq   pane.botline.nochange
0049                       ;------------------------------------------------------
0050                       ; Show "*"
0051                       ;------------------------------------------------------
0052 7B2E 06A0  32         bl    @putat
     7B30 2456     
0053 7B32 1D35                   byte pane.botrow,53   ; x=53
0054 7B34 3558                   data txt.star
0055 7B36 1004  14         jmp   pane.botline.show_mode
0056                       ;------------------------------------------------------
0057                       ; Show " "
0058                       ;------------------------------------------------------
0059               pane.botline.nochange:
0060 7B38 06A0  32         bl    @putat
     7B3A 2456     
0061 7B3C 1D35                   byte pane.botrow,53   ; x=53
0062 7B3E 3698                   data txt.ws1          ; Single white space
0063                       ;------------------------------------------------------
0064                       ; Show text editing mode
0065                       ;------------------------------------------------------
0066               pane.botline.show_mode:
0067 7B40 C120  34         mov   @edb.insmode,tmp0
     7B42 A50A     
0068 7B44 1605  14         jne   pane.botline.show_mode.insert
0069                       ;------------------------------------------------------
0070                       ; Overwrite mode
0071                       ;------------------------------------------------------
0072 7B46 06A0  32         bl    @putat
     7B48 2456     
0073 7B4A 1D37                   byte  pane.botrow,55
0074 7B4C 3550                   data  txt.ovrwrite
0075 7B4E 1004  14         jmp   pane.botline.show_linecol
0076                       ;------------------------------------------------------
0077                       ; Insert mode
0078                       ;------------------------------------------------------
0079               pane.botline.show_mode.insert:
0080 7B50 06A0  32         bl    @putat
     7B52 2456     
0081 7B54 1D37                   byte  pane.botrow,55
0082 7B56 3554                   data  txt.insert
0083                       ;------------------------------------------------------
0084                       ; Show "line,column"
0085                       ;------------------------------------------------------
0086               pane.botline.show_linecol:
0087 7B58 C820  54         mov   @fb.row,@parm1
     7B5A A306     
     7B5C A000     
0088 7B5E 06A0  32         bl    @fb.row2line          ; Row to editor line
     7B60 6A70     
0089                                                   ; \ i @fb.topline = Top line in frame buffer
0090                                                   ; | i @parm1      = Row in frame buffer
0091                                                   ; / o @outparm1   = Matching line in EB
0092               
0093 7B62 05A0  34         inc   @outparm1             ; Add base 1
     7B64 A010     
0094                       ;------------------------------------------------------
0095                       ; Show line
0096                       ;------------------------------------------------------
0097 7B66 06A0  32         bl    @putnum
     7B68 2B28     
0098 7B6A 1D3B                   byte  pane.botrow,59  ; YX
0099 7B6C A010                   data  outparm1,rambuf
     7B6E A140     
0100 7B70 30                     byte  48              ; ASCII offset
0101 7B71   20                   byte  32              ; Padding character
0102                       ;------------------------------------------------------
0103                       ; Show comma
0104                       ;------------------------------------------------------
0105 7B72 06A0  32         bl    @putat
     7B74 2456     
0106 7B76 1D40                   byte  pane.botrow,64
0107 7B78 3548                   data  txt.delim
0108                       ;------------------------------------------------------
0109                       ; Show column
0110                       ;------------------------------------------------------
0111 7B7A 06A0  32         bl    @film
     7B7C 224A     
0112 7B7E A145                   data rambuf+5,32,12   ; Clear work buffer with space character
     7B80 0020     
     7B82 000C     
0113               
0114 7B84 C820  54         mov   @fb.column,@waux1
     7B86 A30C     
     7B88 833C     
0115 7B8A 05A0  34         inc   @waux1                ; Offset 1
     7B8C 833C     
0116               
0117 7B8E 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7B90 2AAA     
0118 7B92 833C                   data  waux1,rambuf
     7B94 A140     
0119 7B96 30                     byte  48              ; ASCII offset
0120 7B97   20                   byte  32              ; Fill character
0121               
0122 7B98 06A0  32         bl    @trimnum              ; Trim number to the left
     7B9A 2B02     
0123 7B9C A140                   data  rambuf,rambuf+5,32
     7B9E A145     
     7BA0 0020     
0124               
0125 7BA2 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7BA4 0600     
0126 7BA6 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7BA8 A145     
0127               
0128                       ;------------------------------------------------------
0129                       ; Decide if row length is to be shown
0130                       ;------------------------------------------------------
0131 7BAA C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7BAC A30C     
0132 7BAE 0584  14         inc   tmp0                  ; /
0133 7BB0 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7BB2 A308     
0134 7BB4 1101  14         jlt   pane.botline.show_linecol.linelen
0135 7BB6 102B  14         jmp   pane.botline.show_linecol.colstring
0136                                                   ; Yes, skip showing row length
0137                       ;------------------------------------------------------
0138                       ; Add ',' delimiter and length of line to string
0139                       ;------------------------------------------------------
0140               pane.botline.show_linecol.linelen:
0141 7BB8 C120  34         mov   @fb.column,tmp0       ; \
     7BBA A30C     
0142 7BBC 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7BBE A147     
0143 7BC0 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7BC2 0009     
0144 7BC4 1101  14         jlt   !                     ; | column.
0145 7BC6 0585  14         inc   tmp1                  ; /
0146               
0147 7BC8 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7BCA 2D00     
0148 7BCC DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0149               
0150 7BCE C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7BD0 833C     
0151               
0152 7BD2 06A0  32         bl    @mknum
     7BD4 2AAA     
0153 7BD6 A308                   data  fb.row.length,rambuf
     7BD8 A140     
0154 7BDA 30                     byte  48              ; ASCII offset
0155 7BDB   20                   byte  32              ; Padding character
0156               
0157 7BDC C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7BDE 833C     
0158               
0159 7BE0 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7BE2 A308     
0160 7BE4 0284  22         ci    tmp0,10               ; /
     7BE6 000A     
0161 7BE8 110B  14         jlt   pane.botline.show_line.1digit
0162                       ;------------------------------------------------------
0163                       ; Assert
0164                       ;------------------------------------------------------
0165 7BEA 0284  22         ci    tmp0,80
     7BEC 0050     
0166 7BEE 1204  14         jle   pane.botline.show_line.2digits
0167                       ;------------------------------------------------------
0168                       ; Asserts failed
0169                       ;------------------------------------------------------
0170 7BF0 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7BF2 FFCE     
0171 7BF4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7BF6 2026     
0172                       ;------------------------------------------------------
0173                       ; Show length of line (2 digits)
0174                       ;------------------------------------------------------
0175               pane.botline.show_line.2digits:
0176 7BF8 0204  20         li    tmp0,rambuf+3
     7BFA A143     
0177 7BFC DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0178 7BFE 1002  14         jmp   pane.botline.show_line.rest
0179                       ;------------------------------------------------------
0180                       ; Show length of line (1 digits)
0181                       ;------------------------------------------------------
0182               pane.botline.show_line.1digit:
0183 7C00 0204  20         li    tmp0,rambuf+4
     7C02 A144     
0184               pane.botline.show_line.rest:
0185 7C04 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0186 7C06 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7C08 A140     
0187 7C0A DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7C0C A140     
0188                       ;------------------------------------------------------
0189                       ; Show column string
0190                       ;------------------------------------------------------
0191               pane.botline.show_linecol.colstring:
0192 7C0E 06A0  32         bl    @putat
     7C10 2456     
0193 7C12 1D41                   byte pane.botrow,65
0194 7C14 A145                   data rambuf+5         ; Show string
0195                       ;------------------------------------------------------
0196                       ; Show lines in buffer unless on last line in file
0197                       ;------------------------------------------------------
0198 7C16 C820  54         mov   @fb.row,@parm1
     7C18 A306     
     7C1A A000     
0199 7C1C 06A0  32         bl    @fb.row2line
     7C1E 6A70     
0200 7C20 8820  54         c     @edb.lines,@outparm1
     7C22 A504     
     7C24 A010     
0201 7C26 1605  14         jne   pane.botline.show_lines_in_buffer
0202               
0203 7C28 06A0  32         bl    @putat
     7C2A 2456     
0204 7C2C 1D48                   byte pane.botrow,72
0205 7C2E 354A                   data txt.bottom
0206               
0207 7C30 1009  14         jmp   pane.botline.exit
0208                       ;------------------------------------------------------
0209                       ; Show lines in buffer
0210                       ;------------------------------------------------------
0211               pane.botline.show_lines_in_buffer:
0212 7C32 C820  54         mov   @edb.lines,@waux1
     7C34 A504     
     7C36 833C     
0213               
0214 7C38 06A0  32         bl    @putnum
     7C3A 2B28     
0215 7C3C 1D48                   byte pane.botrow,72   ; YX
0216 7C3E 833C                   data waux1,rambuf
     7C40 A140     
0217 7C42 30                     byte 48
0218 7C43   20                   byte 32
0219                       ;------------------------------------------------------
0220                       ; Exit
0221                       ;------------------------------------------------------
0222               pane.botline.exit:
0223 7C44 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7C46 832A     
0224 7C48 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0225 7C4A C2F9  30         mov   *stack+,r11           ; Pop r11
0226 7C4C 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.30692
0165                       copy  "pane.vdpdump.asm"       ; Dump panes to VDP memory
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
0024 7C4E 0649  14         dect  stack
0025 7C50 C64B  30         mov   r11,*stack            ; Save return address
0026 7C52 0649  14         dect  stack
0027 7C54 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 7C56 0649  14         dect  stack
0029 7C58 C660  46         mov   @wyx,*stack           ; Push cursor position
     7C5A 832A     
0030                       ;------------------------------------------------------
0031                       ; ALPHA-Lock key down?
0032                       ;------------------------------------------------------
0033               pane.vdpdump.alpha_lock:
0034 7C5C 20A0  38         coc   @wbit10,config
     7C5E 200C     
0035 7C60 1305  14         jeq   pane.vdpdump.alpha_lock.down
0036                       ;------------------------------------------------------
0037                       ; AlPHA-Lock is up
0038                       ;------------------------------------------------------
0039 7C62 06A0  32         bl    @putat
     7C64 2456     
0040 7C66 1D4E                   byte pane.botrow,78
0041 7C68 36A2                   data txt.ws4
0042 7C6A 1004  14         jmp   pane.vdpdump.cmdb.check
0043                       ;------------------------------------------------------
0044                       ; AlPHA-Lock is down
0045                       ;------------------------------------------------------
0046               pane.vdpdump.alpha_lock.down:
0047 7C6C 06A0  32         bl    @putat
     7C6E 2456     
0048 7C70 1D4E                   byte pane.botrow,78
0049 7C72 3690                   data txt.alpha.down
0050                       ;------------------------------------------------------
0051                       ; Command buffer visible ?
0052                       ;------------------------------------------------------
0053               pane.vdpdump.cmdb.check
0054 7C74 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7C76 A702     
0055 7C78 1308  14         jeq   !                     ; No, skip CMDB pane
0056                       ;-------------------------------------------------------
0057                       ; Draw command buffer pane if dirty
0058                       ;-------------------------------------------------------
0059               pane.vdpdump.cmdb.draw:
0060 7C7A C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7C7C A718     
0061 7C7E 1327  14         jeq   pane.vdpdump.exit     ; No, skip update
0062               
0063 7C80 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     7C82 7DEA     
0064 7C84 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7C86 A718     
0065 7C88 1022  14         jmp   pane.vdpdump.exit     ; Exit early
0066                       ;-------------------------------------------------------
0067                       ; Check if frame buffer dirty
0068                       ;-------------------------------------------------------
0069 7C8A C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7C8C A316     
0070 7C8E 130E  14         jeq   pane.vdpdump.statlines
0071                                                   ; No, skip update
0072 7C90 C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     7C92 A31A     
     7C94 A000     
0073               
0074               pane.vdpdump.dump:
0075 7C96 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7C98 7E5C     
0076                                                   ; \ i  @parm1 = number of lines to dump
0077                                                   ; /
0078                       ;------------------------------------------------------
0079                       ; Color the lines in the framebuffer (TAT)
0080                       ;------------------------------------------------------
0081 7C9A C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     7C9C A310     
0082 7C9E 1302  14         jeq   pane.vdpdump.dumped   ; Skip if flag reset
0083               
0084 7CA0 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     7CA2 7E4A     
0085                       ;-------------------------------------------------------
0086                       ; Finished with frame buffer
0087                       ;-------------------------------------------------------
0088               pane.vdpdump.dumped:
0089 7CA4 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7CA6 A316     
0090 7CA8 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     7CAA A318     
0091                       ;-------------------------------------------------------
0092                       ; Refresh top and bottom line
0093                       ;-------------------------------------------------------
0094               pane.vdpdump.statlines:
0095 7CAC C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     7CAE A318     
0096 7CB0 130E  14         jeq   pane.vdpdump.exit     ; No, skip update
0097               
0098 7CB2 06A0  32         bl    @pane.topline         ; Draw top line
     7CB4 79BE     
0099 7CB6 06A0  32         bl    @pane.botline         ; Draw bottom line
     7CB8 7B00     
0100 7CBA 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     7CBC A318     
0101                       ;------------------------------------------------------
0102                       ; Show ruler with tab positions
0103                       ;------------------------------------------------------
0104 7CBE C120  34         mov   @tv.ruler.visible,tmp0
     7CC0 A210     
0105                                                   ; Should ruler be visible?
0106 7CC2 1305  14         jeq   pane.vdpdump.exit     ; No, so exit
0107               
0108 7CC4 06A0  32         bl    @cpym2v
     7CC6 249A     
0109 7CC8 0050                   data vdp.fb.toprow.sit
0110 7CCA A31E                   data fb.ruler.sit
0111 7CCC 0050                   data 80               ; Show ruler
0112                       ;------------------------------------------------------
0113                       ; Exit task
0114                       ;------------------------------------------------------
0115               pane.vdpdump.exit:
0116 7CCE C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7CD0 832A     
0117 7CD2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 7CD4 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 7CD6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0166                       ;-----------------------------------------------------------------------
0167                       ; Stubs
0168                       ;-----------------------------------------------------------------------
0169                       copy  "rom.stubs.bank1.asm"    ; Stubs for functions in other banks
     **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "vdp.patterns.dump"
0007               * bank5 vec.1
0008               ********|*****|*********************|**************************
0009               vdp.patterns.dump:
0010 7CD8 0649  14         dect  stack
0011 7CDA C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7CDC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CDE 30A4     
0016 7CE0 600A                   data bank5.rom        ; | i  p0 = bank address
0017 7CE2 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0018 7CE4 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7CE6 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7CE8 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7CEA 0649  14         dect  stack
0032 7CEC C64B  30         mov   r11,*stack            ; Save return address
0033 7CEE 0649  14         dect  stack
0034 7CF0 C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7CF2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CF4 30A4     
0039 7CF6 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7CF8 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0041 7CFA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7CFC C120  34         mov   @outparm1,tmp0
     7CFE A010     
0046 7D00 1304  14         jeq   fm.loadfile.exit
0047               
0048 7D02 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7D04 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7D06 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D08 7D96     
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7D0A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7D0C C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7D0E 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.insertfile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.insertfile:
0065 7D10 0649  14         dect  stack
0066 7D12 C64B  30         mov   r11,*stack            ; Save return address
0067 7D14 0649  14         dect  stack
0068 7D16 C644  30         mov   tmp0,*stack           ; Push tmp0
0069                       ;------------------------------------------------------
0070                       ; Call function in bank 2
0071                       ;------------------------------------------------------
0072 7D18 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D1A 30A4     
0073 7D1C 6004                   data bank2.rom        ; | i  p0 = bank address
0074 7D1E 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0075 7D20 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               fm.insertfile.exit:
0080 7D22 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0081 7D24 C2F9  30         mov   *stack+,r11           ; Pop r11
0082 7D26 045B  20         b     *r11                  ; Return to caller
0083               
0084               
0085               **************************************************************
0086               * Stub for "fm.browse.fname.suffix"
0087               * bank2 vec.3
0088               ********|*****|*********************|**************************
0089               fm.browse.fname.suffix:
0090 7D28 0649  14         dect  stack
0091 7D2A C64B  30         mov   r11,*stack            ; Save return address
0092                       ;------------------------------------------------------
0093                       ; Call function in bank 2
0094                       ;------------------------------------------------------
0095 7D2C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D2E 30A4     
0096 7D30 6004                   data bank2.rom        ; | i  p0 = bank address
0097 7D32 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0098 7D34 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102 7D36 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7D38 045B  20         b     *r11                  ; Return to caller
0104               
0105               
0106               ***************************************************************
0107               * Stub for "fm.savefile"
0108               * bank2 vec.4
0109               ********|*****|*********************|**************************
0110               fm.savefile:
0111 7D3A 0649  14         dect  stack
0112 7D3C C64B  30         mov   r11,*stack            ; Save return address
0113                       ;------------------------------------------------------
0114                       ; Call function in bank 2
0115                       ;------------------------------------------------------
0116 7D3E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D40 30A4     
0117 7D42 6004                   data bank2.rom        ; | i  p0 = bank address
0118 7D44 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0119 7D46 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123 7D48 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 7D4A 045B  20         b     *r11                  ; Return to caller
0125               
0126               
0127               ***************************************************************
0128               * Stub for "fm.newfile"
0129               * bank2 vec.5
0130               ********|*****|*********************|**************************
0131               fm.newfile:
0132 7D4C 0649  14         dect  stack
0133 7D4E C64B  30         mov   r11,*stack            ; Save return address
0134                       ;------------------------------------------------------
0135                       ; Call function in bank 2
0136                       ;------------------------------------------------------
0137 7D50 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D52 30A4     
0138 7D54 6004                   data bank2.rom        ; | i  p0 = bank address
0139 7D56 7FC8                   data vec.5            ; | i  p1 = Vector with target address
0140 7D58 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144 7D5A C2F9  30         mov   *stack+,r11           ; Pop r11
0145 7D5C 045B  20         b     *r11                  ; Return to caller
0146               
0147               
0148               ***************************************************************
0149               * Stub for dialog "Help"
0150               * bank3 vec.1
0151               ********|*****|*********************|**************************
0152               edkey.action.about:
0153 7D5E C820  54         mov   @edkey.action.about.vector,@parm1
     7D60 7D68     
     7D62 A000     
0154 7D64 0460  28         b     @_trampoline.bank3    ; Show dialog
     7D66 7E6E     
0155               edkey.action.about.vector:
0156 7D68 7FC0             data  vec.1
0157               
0158               
0159               ***************************************************************
0160               * Stub for dialog "Load DV80 file"
0161               * bank3 vec.2
0162               ********|*****|*********************|**************************
0163               dialog.load:
0164 7D6A C820  54         mov   @dialog.load.vector,@parm1
     7D6C 7D74     
     7D6E A000     
0165 7D70 0460  28         b     @_trampoline.bank3    ; Show dialog
     7D72 7E6E     
0166               dialog.load.vector:
0167 7D74 7FC2             data  vec.2
0168               
0169               
0170               ***************************************************************
0171               * Stub for dialog "Save DV80 file"
0172               * bank3 vec.3
0173               ********|*****|*********************|**************************
0174               dialog.save:
0175 7D76 C820  54         mov   @dialog.save.vector,@parm1
     7D78 7D80     
     7D7A A000     
0176 7D7C 0460  28         b     @_trampoline.bank3    ; Show dialog
     7D7E 7E6E     
0177               dialog.save.vector:
0178 7D80 7FC4             data  vec.3
0179               
0180               
0181               ***************************************************************
0182               * Stub for dialog "Insert DV80 file"
0183               * bank3 vec.4
0184               ********|*****|*********************|**************************
0185               dialog.insert:
0186 7D82 C820  54         mov   @dialog.insert.vector,@parm1
     7D84 7D8A     
     7D86 A000     
0187 7D88 1072  14         jmp   _trampoline.bank3     ; Show dialog
0188               dialog.insert.vector:
0189 7D8A 7FC6             data  vec.4
0190               
0191               
0192               ***************************************************************
0193               * Stub for dialog "File"
0194               * bank3 vec.5
0195               ********|*****|*********************|**************************
0196               dialog.file:
0197 7D8C C820  54         mov   @dialog.file.vector,@parm1
     7D8E 7D94     
     7D90 A000     
0198 7D92 106D  14         jmp   _trampoline.bank3     ; Show dialog
0199               dialog.file.vector:
0200 7D94 7FC8             data  vec.5
0201               
0202               
0203               ***************************************************************
0204               * Stub for dialog "Unsaved Changes"
0205               * bank3 vec.6
0206               ********|*****|*********************|**************************
0207               dialog.unsaved:
0208 7D96 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7D98 A722     
0209 7D9A C820  54         mov   @dialog.unsaved.vector,@parm1
     7D9C 7DA2     
     7D9E A000     
0210 7DA0 1066  14         jmp   _trampoline.bank3     ; Show dialog
0211               dialog.unsaved.vector:
0212 7DA2 7FCA             data  vec.6
0213               
0214               
0215               ***************************************************************
0216               * Stub for dialog "Main Menu"
0217               * bank3 vec.30
0218               ********|*****|*********************|**************************
0219               dialog.menu:
0220                       ;------------------------------------------------------
0221                       ; Check if block mode is active
0222                       ;------------------------------------------------------
0223 7DA4 C120  34         mov   @edb.block.m2,tmp0    ; \
     7DA6 A50E     
0224 7DA8 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0225                                                   ; /
0226 7DAA 1302  14         jeq   !                     : Block mode inactive, show dialog
0227                       ;------------------------------------------------------
0228                       ; Special treatment for block mode
0229                       ;------------------------------------------------------
0230 7DAC 0460  28         b     @edkey.action.block.reset
     7DAE 674E     
0231                                                   ; Reset block mode
0232                       ;------------------------------------------------------
0233                       ; Show dialog
0234                       ;------------------------------------------------------
0235 7DB0 C820  54 !       mov   @dialog.menu.vector,@parm1
     7DB2 7DB8     
     7DB4 A000     
0236 7DB6 105B  14         jmp   _trampoline.bank3     ; Show dialog
0237               dialog.menu.vector:
0238 7DB8 7FFA             data  vec.30
0239               
0240               
0241               ***************************************************************
0242               * Stub for "tibasic"
0243               * bank3 vec.10
0244               ********|*****|*********************|**************************
0245               tibasic:
0246 7DBA 0649  14         dect  stack
0247 7DBC C64B  30         mov   r11,*stack            ; Save return address
0248                       ;------------------------------------------------------
0249                       ; Call function in bank 3
0250                       ;------------------------------------------------------
0251 7DBE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DC0 30A4     
0252 7DC2 6006                   data bank3.rom        ; | i  p0 = bank address
0253 7DC4 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0254 7DC6 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0255                       ;------------------------------------------------------
0256                       ; Exit
0257                       ;------------------------------------------------------
0258 7DC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0259 7DCA 045B  20         b     *r11                  ; Return to caller
0260               
0261               
0262               
0263               ***************************************************************
0264               * Stub for "pane.show_hint"
0265               * bank3 vec.18
0266               ********|*****|*********************|**************************
0267               pane.show_hint:
0268 7DCC C820  54         mov   @pane.show_hint,@parm1
     7DCE 7DCC     
     7DD0 A000     
0269 7DD2 1056  14         jmp   _trampoline.bank3.ret ; Longjump
0270               pane.show_hint.vector:
0271 7DD4 7FE2             data  vec.18
0272               
0273               
0274               ***************************************************************
0275               * Stub for "pane.cmdb.show"
0276               * bank3 vec.20
0277               ********|*****|*********************|**************************
0278               pane.cmdb.show:
0279 7DD6 C820  54         mov   @pane.cmdb.show.vector,@parm1
     7DD8 7DDE     
     7DDA A000     
0280 7DDC 1051  14         jmp   _trampoline.bank3.ret ; Longjump
0281               pane.cmdb.show.vector:
0282 7DDE 7FE6             data  vec.20
0283               
0284               
0285               ***************************************************************
0286               * Stub for "pane.cmdb.hide"
0287               * bank3 vec.21
0288               ********|*****|*********************|**************************
0289               pane.cmdb.hide:
0290 7DE0 C820  54         mov   @pane.cmdb.hide.vector,@parm1
     7DE2 7DE8     
     7DE4 A000     
0291 7DE6 104C  14         jmp   _trampoline.bank3.ret ; Longjump
0292               pane.cmdb.hide.vector:
0293 7DE8 7FE8             data  vec.21
0294               
0295               
0296               ***************************************************************
0297               * Stub for "pane.cmdb.draw"
0298               * bank3 vec.22
0299               ********|*****|*********************|**************************
0300               pane.cmdb.draw:
0301 7DEA C820  54         mov   @pane.cmdb.draw.vector,@parm1
     7DEC 7DF2     
     7DEE A000     
0302 7DF0 1047  14         jmp   _trampoline.bank3.ret ; Longjump
0303               pane.cmdb.draw.vector:
0304 7DF2 7FEA             data  vec.22
0305               
0306               
0307               ***************************************************************
0308               * Stub for "cmdb.refresh"
0309               * bank3 vec.24
0310               ********|*****|*********************|**************************
0311               cmdb.refresh:
0312 7DF4 C820  54         mov   @cmdb.refresh.vector,@parm1
     7DF6 7DFC     
     7DF8 A000     
0313 7DFA 1042  14         jmp   _trampoline.bank3.ret ; Longjump
0314               cmdb.refresh.vector:
0315 7DFC 7FEE             data  vec.24
0316               
0317               
0318               ***************************************************************
0319               * Stub for "cmdb.cmd.clear"
0320               * bank3 vec.25
0321               ********|*****|*********************|**************************
0322               cmdb.cmd.clear:
0323 7DFE C820  54         mov   @cmdb.cmd.clear.vector,@parm1
     7E00 7E06     
     7E02 A000     
0324 7E04 103D  14         jmp   _trampoline.bank3.ret ; Longjump
0325               cmdb.cmd.clear.vector:
0326 7E06 7FF0             data  vec.25
0327               
0328               
0329               ***************************************************************
0330               * Stub for "cmdb.cmdb.getlength"
0331               * bank3 vec.26
0332               ********|*****|*********************|**************************
0333               cmdb.cmd.getlength:
0334 7E08 C820  54         mov   @cmdb.cmd.getlength.vector,@parm1
     7E0A 7E10     
     7E0C A000     
0335 7E0E 1038  14         jmp   _trampoline.bank3.ret ; Longjump
0336               cmdb.cmd.getlength.vector:
0337 7E10 7FF2             data  vec.26
0338               
0339               
0340               ***************************************************************
0341               * Stub for "cmdb.cmdb.addhist"
0342               * bank3 vec.27
0343               ********|*****|*********************|**************************
0344               cmdb.cmd.addhist:
0345 7E12 C820  54         mov   @cmdb.cmd.addhist.vector,@parm1
     7E14 7E1A     
     7E16 A000     
0346 7E18 1033  14         jmp   _trampoline.bank3.ret ; Longjump
0347               cmdb.cmd.addhist.vector:
0348 7E1A 7FF4             data  vec.27
0349               
0350               
0351               
0352               
0353               
0354               **************************************************************
0355               * Stub for "fm.fastmode"
0356               * bank3 vec.32
0357               ********|*****|*********************|**************************
0358               fm.fastmode:
0359 7E1C C820  54         mov   @fm.fastmode.vector,@parm1
     7E1E 7E24     
     7E20 A000     
0360 7E22 102E  14         jmp   _trampoline.bank3.ret ; Longjump
0361               fm.fastmode.vector:
0362 7E24 7FFE             data  vec.32
0363               
0364               
0365               ***************************************************************
0366               * Stub for "fb.tab.next"
0367               * bank4 vec.1
0368               ********|*****|*********************|**************************
0369               fb.tab.next:
0370 7E26 0649  14         dect  stack
0371 7E28 C64B  30         mov   r11,*stack            ; Save return address
0372                       ;------------------------------------------------------
0373                       ; Put cursor on next tab position
0374                       ;------------------------------------------------------
0375 7E2A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E2C 30A4     
0376 7E2E 6008                   data bank4.rom        ; | i  p0 = bank address
0377 7E30 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0378 7E32 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0379                       ;------------------------------------------------------
0380                       ; Exit
0381                       ;------------------------------------------------------
0382 7E34 C2F9  30         mov   *stack+,r11           ; Pop r11
0383 7E36 045B  20         b     *r11                  ; Return to caller
0384               
0385               
0386               ***************************************************************
0387               * Stub for "fb.ruler.init"
0388               * bank4 vec.2
0389               ********|*****|*********************|**************************
0390               fb.ruler.init:
0391 7E38 0649  14         dect  stack
0392 7E3A C64B  30         mov   r11,*stack            ; Save return address
0393                       ;------------------------------------------------------
0394                       ; Setup ruler in memory
0395                       ;------------------------------------------------------
0396 7E3C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E3E 30A4     
0397 7E40 6008                   data bank4.rom        ; | i  p0 = bank address
0398 7E42 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0399 7E44 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0400                       ;------------------------------------------------------
0401                       ; Exit
0402                       ;------------------------------------------------------
0403 7E46 C2F9  30         mov   *stack+,r11           ; Pop r11
0404 7E48 045B  20         b     *r11                  ; Return to caller
0405               
0406               
0407               ***************************************************************
0408               * Stub for "fb.colorlines"
0409               * bank4 vec.3
0410               ********|*****|*********************|**************************
0411               fb.colorlines:
0412 7E4A 0649  14         dect  stack
0413 7E4C C64B  30         mov   r11,*stack            ; Save return address
0414                       ;------------------------------------------------------
0415                       ; Colorize frame buffer content
0416                       ;------------------------------------------------------
0417 7E4E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E50 30A4     
0418 7E52 6008                   data bank4.rom        ; | i  p0 = bank address
0419 7E54 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0420 7E56 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0421                       ;------------------------------------------------------
0422                       ; Exit
0423                       ;------------------------------------------------------
0424 7E58 C2F9  30         mov   *stack+,r11           ; Pop r11
0425 7E5A 045B  20         b     *r11                  ; Return to caller
0426               
0427               
0428               ***************************************************************
0429               * Stub for "fb.vdpdump"
0430               * bank4 vec.4
0431               ********|*****|*********************|**************************
0432               fb.vdpdump:
0433 7E5C 0649  14         dect  stack
0434 7E5E C64B  30         mov   r11,*stack            ; Save return address
0435                       ;------------------------------------------------------
0436                       ; Colorize frame buffer content
0437                       ;------------------------------------------------------
0438 7E60 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E62 30A4     
0439 7E64 6008                   data bank4.rom        ; | i  p0 = bank address
0440 7E66 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0441 7E68 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0442                       ;------------------------------------------------------
0443                       ; Exit
0444                       ;------------------------------------------------------
0445 7E6A C2F9  30         mov   *stack+,r11           ; Pop r11
0446 7E6C 045B  20         b     *r11                  ; Return to caller
0447               
0448               
0449               ***************************************************************
0450               * Trampoline 1 (bank 3, dialog)
0451               ********|*****|*********************|**************************
0452               _trampoline.bank3:
0453 7E6E 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E70 7936     
0454                       ;------------------------------------------------------
0455                       ; Call routine in specified bank
0456                       ;------------------------------------------------------
0457 7E72 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E74 30A4     
0458 7E76 6006                   data bank3.rom        ; | i  p0 = bank address
0459 7E78 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0460                                                   ; |         (deref @parm1)
0461 7E7A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0462                       ;------------------------------------------------------
0463                       ; Exit
0464                       ;------------------------------------------------------
0465 7E7C 0460  28         b     @edkey.action.cmdb.show
     7E7E 68BA     
0466                                                   ; Show dialog in CMDB pane
0467               
0468               
0469               ***************************************************************
0470               * Trampoline 2 (bank 3 with return)
0471               ********|*****|*********************|**************************
0472               _trampoline.bank3.ret:
0473 7E80 0649  14         dect  stack
0474 7E82 C64B  30         mov   r11,*stack            ; Save return address
0475                       ;------------------------------------------------------
0476                       ; Call routine in specified bank
0477                       ;------------------------------------------------------
0478 7E84 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E86 30A4     
0479 7E88 6006                   data bank3.rom        ; | i  p0 = bank address
0480 7E8A FFFF                   data >ffff            ; | i  p1 = Vector with target address
0481                                                   ; |         (deref @parm1)
0482 7E8C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0483                       ;------------------------------------------------------
0484                       ; Exit
0485                       ;------------------------------------------------------
0486 7E8E C2F9  30         mov   *stack+,r11           ; Pop r11
0487 7E90 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.30692
0170                       ;-----------------------------------------------------------------------
0171                       ; Program data
0172                       ;-----------------------------------------------------------------------
0173                       copy  "data.keymap.actions.asm"; Data segment - Keyboard actions
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
0011 7E92 0D00             byte  key.enter, pane.focus.fb
0012 7E94 65C0             data  edkey.action.enter
0013               
0014 7E96 0800             byte  key.fctn.s, pane.focus.fb
0015 7E98 6192             data  edkey.action.left
0016               
0017 7E9A 0900             byte  key.fctn.d, pane.focus.fb
0018 7E9C 61AC             data  edkey.action.right
0019               
0020 7E9E 0B00             byte  key.fctn.e, pane.focus.fb
0021 7EA0 62A4             data  edkey.action.up
0022               
0023 7EA2 0A00             byte  key.fctn.x, pane.focus.fb
0024 7EA4 62AC             data  edkey.action.down
0025               
0026 7EA6 BF00             byte  key.fctn.h, pane.focus.fb
0027 7EA8 61C8             data  edkey.action.home
0028               
0029 7EAA C000             byte  key.fctn.j, pane.focus.fb
0030 7EAC 61F2             data  edkey.action.pword
0031               
0032 7EAE C100             byte  key.fctn.k, pane.focus.fb
0033 7EB0 6244             data  edkey.action.nword
0034               
0035 7EB2 C200             byte  key.fctn.l, pane.focus.fb
0036 7EB4 61D0             data  edkey.action.end
0037               
0038 7EB6 0C00             byte  key.fctn.6, pane.focus.fb
0039 7EB8 62B4             data  edkey.action.ppage
0040               
0041 7EBA 0200             byte  key.fctn.4, pane.focus.fb
0042 7EBC 62F0             data  edkey.action.npage
0043               
0044 7EBE 8500             byte  key.ctrl.e, pane.focus.fb
0045 7EC0 62B4             data  edkey.action.ppage
0046               
0047 7EC2 9800             byte  key.ctrl.x, pane.focus.fb
0048 7EC4 62F0             data  edkey.action.npage
0049               
0050 7EC6 9400             byte  key.ctrl.t, pane.focus.fb
0051 7EC8 632A             data  edkey.action.top
0052               
0053 7ECA 8200             byte  key.ctrl.b, pane.focus.fb
0054 7ECC 6360             data  edkey.action.bot
0055               
0056 7ECE 9400             byte  key.ctrl.t, pane.focus.fb
0057 7ED0 632A             data  edkey.action.top
0058               
0059 7ED2 8200             byte  key.ctrl.b, pane.focus.fb
0060 7ED4 6360             data  edkey.action.bot
0061                       ;-------------------------------------------------------
0062                       ; Modifier keys - Delete
0063                       ;-------------------------------------------------------
0064 7ED6 0300             byte  key.fctn.1, pane.focus.fb
0065 7ED8 640E             data  edkey.action.del_char
0066               
0067 7EDA 0700             byte  key.fctn.3, pane.focus.fb
0068 7EDC 64C0             data  edkey.action.del_line
0069               
0070 7EDE 8C00             byte  key.ctrl.l, pane.focus.fb
0071 7EE0 648C             data  edkey.action.del_eol
0072                       ;-------------------------------------------------------
0073                       ; Modifier keys - Insert
0074                       ;-------------------------------------------------------
0075 7EE2 0400             byte  key.fctn.2, pane.focus.fb
0076 7EE4 6522             data  edkey.action.ins_char.ws
0077               
0078 7EE6 B900             byte  key.fctn.dot, pane.focus.fb
0079 7EE8 6638             data  edkey.action.ins_onoff
0080               
0081 7EEA 0100             byte  key.fctn.7, pane.focus.fb
0082 7EEC 680C             data  edkey.action.fb.tab.next
0083               
0084 7EEE 0600             byte  key.fctn.8, pane.focus.fb
0085 7EF0 65B8             data  edkey.action.ins_line
0086                       ;-------------------------------------------------------
0087                       ; Block marking/modifier
0088                       ;-------------------------------------------------------
0089 7EF2 9600             byte  key.ctrl.v, pane.focus.fb
0090 7EF4 6746             data  edkey.action.block.mark
0091               
0092 7EF6 8300             byte  key.ctrl.c, pane.focus.fb
0093 7EF8 675A             data  edkey.action.block.copy
0094               
0095 7EFA 8400             byte  key.ctrl.d, pane.focus.fb
0096 7EFC 6796             data  edkey.action.block.delete
0097               
0098 7EFE 8D00             byte  key.ctrl.m, pane.focus.fb
0099 7F00 67C0             data  edkey.action.block.move
0100               
0101 7F02 8700             byte  key.ctrl.g, pane.focus.fb
0102 7F04 67F2             data  edkey.action.block.goto.m1
0103                       ;-------------------------------------------------------
0104                       ; Other action keys
0105                       ;-------------------------------------------------------
0106 7F06 0500             byte  key.fctn.plus, pane.focus.fb
0107 7F08 66F2             data  edkey.action.quit
0108               
0109 7F0A 9100             byte  key.ctrl.q, pane.focus.fb
0110 7F0C 66F2             data  edkey.action.quit
0111               
0112 7F0E 9500             byte  key.ctrl.u, pane.focus.fb
0113 7F10 66B2             data  edkey.action.toggle.ruler
0114               
0115 7F12 9A00             byte  key.ctrl.z, pane.focus.fb
0116 7F14 7708             data  pane.action.colorscheme.cycle
0117               
0118 7F16 8000             byte  key.ctrl.comma, pane.focus.fb
0119 7F18 6700             data  edkey.action.fb.fname.dec.load
0120               
0121 7F1A 9B00             byte  key.ctrl.dot, pane.focus.fb
0122 7F1C 670C             data  edkey.action.fb.fname.inc.load
0123               
0124 7F1E BB00             byte  key.ctrl.slash, pane.focus.fb
0125 7F20 7DBA             data  tibasic
0126                       ;-------------------------------------------------------
0127                       ; Dialog keys
0128                       ;-------------------------------------------------------
0129 7F22 8800             byte  key.ctrl.h, pane.focus.fb
0130 7F24 7D5E             data  edkey.action.about
0131               
0132 7F26 8600             byte  key.ctrl.f, pane.focus.fb
0133 7F28 7D8C             data  dialog.file
0134               
0135 7F2A 8900             byte  key.ctrl.i, pane.focus.fb
0136 7F2C 7D82             data  dialog.insert
0137               
0138 7F2E 9300             byte  key.ctrl.s, pane.focus.fb
0139 7F30 7D76             data  dialog.save
0140               
0141 7F32 8F00             byte  key.ctrl.o, pane.focus.fb
0142 7F34 7D6A             data  dialog.load
0143               
0144                       ;
0145                       ; FCTN-9 has multipe purposes, if block mode is on it
0146                       ; resets the block, otherwise show Stevie menu dialog.
0147                       ;
0148 7F36 0F00             byte  key.fctn.9, pane.focus.fb
0149 7F38 7DA4             data  dialog.menu
0150                       ;-------------------------------------------------------
0151                       ; End of list
0152                       ;-------------------------------------------------------
0153 7F3A FFFF             data  EOL                           ; EOL
0154               
0155               
0156               
0157               *---------------------------------------------------------------
0158               * Action keys mapping table: Command Buffer (CMDB)
0159               *---------------------------------------------------------------
0160               keymap_actions.cmdb:
0161                       ;-------------------------------------------------------
0162                       ; Dialog: Main Menu
0163                       ;-------------------------------------------------------
0164 7F3C 4664             byte  key.uc.f, id.dialog.menu
0165 7F3E 7D8C             data  dialog.file
0166               
0167 7F40 4264             byte  key.uc.b, id.dialog.menu
0168 7F42 7DBA             data  tibasic
0169               
0170 7F44 4864             byte  key.uc.h, id.dialog.menu
0171 7F46 7D5E             data  edkey.action.about
0172               
0173 7F48 5164             byte  key.uc.q, id.dialog.menu
0174 7F4A 66F2             data  edkey.action.quit
0175                       ;-------------------------------------------------------
0176                       ; Dialog: File
0177                       ;-------------------------------------------------------
0178 7F4C 4E68             byte  key.uc.n, id.dialog.file
0179 7F4E 68CC             data  edkey.action.cmdb.file.new
0180               
0181 7F50 5368             byte  key.uc.s, id.dialog.file
0182 7F52 7D76             data  dialog.save
0183               
0184 7F54 4F68             byte  key.uc.o, id.dialog.file
0185 7F56 7D6A             data  dialog.load
0186               
0187 7F58 4968             byte  key.uc.i, id.dialog.file
0188 7F5A 7D82             data  dialog.insert
0189                       ;-------------------------------------------------------
0190                       ; Dialog: Open DV80 file
0191                       ;-------------------------------------------------------
0192 7F5C 0E0A             byte  key.fctn.5, id.dialog.load
0193 7F5E 6A44             data  edkey.action.cmdb.fastmode.toggle
0194               
0195 7F60 0D0A             byte  key.enter, id.dialog.load
0196 7F62 68F0             data  edkey.action.cmdb.load
0197                       ;-------------------------------------------------------
0198                       ; Dialog: Insert DV80 file
0199                       ;-------------------------------------------------------
0200 7F64 0E0D             byte  key.fctn.5, id.dialog.insert
0201 7F66 6A44             data  edkey.action.cmdb.fastmode.toggle
0202               
0203 7F68 0D0D             byte  key.enter, id.dialog.insert
0204 7F6A 6934             data  edkey.action.cmdb.ins
0205                       ;-------------------------------------------------------
0206                       ; Dialog: Unsaved changes
0207                       ;-------------------------------------------------------
0208 7F6C 0C65             byte  key.fctn.6, id.dialog.unsaved
0209 7F6E 6A1A             data  edkey.action.cmdb.proceed
0210               
0211 7F70 0D65             byte  key.enter, id.dialog.unsaved
0212 7F72 7D76             data  dialog.save
0213                       ;-------------------------------------------------------
0214                       ; Dialog: Save DV80 file
0215                       ;-------------------------------------------------------
0216 7F74 0D0B             byte  key.enter, id.dialog.save
0217 7F76 69AA             data  edkey.action.cmdb.save
0218               
0219 7F78 0D0C             byte  key.enter, id.dialog.saveblock
0220 7F7A 69AA             data  edkey.action.cmdb.save
0221                       ;-------------------------------------------------------
0222                       ; Dialog: Basic
0223                       ;-------------------------------------------------------
0224 7F7C 4269             byte  key.uc.b, id.dialog.basic
0225 7F7E 7DBA             data  tibasic
0226                       ;-------------------------------------------------------
0227                       ; Dialog: Help
0228                       ;-------------------------------------------------------
0229 7F80 0F67             byte  key.fctn.9, id.dialog.help
0230 7F82 6A50             data  edkey.action.cmdb.close.about
0231                       ;-------------------------------------------------------
0232                       ; Movement keys
0233                       ;-------------------------------------------------------
0234 7F84 0801             byte  key.fctn.s, pane.focus.cmdb
0235 7F86 681A             data  edkey.action.cmdb.left
0236               
0237 7F88 0901             byte  key.fctn.d, pane.focus.cmdb
0238 7F8A 682C             data  edkey.action.cmdb.right
0239               
0240 7F8C BF01             byte  key.fctn.h, pane.focus.cmdb
0241 7F8E 6844             data  edkey.action.cmdb.home
0242               
0243 7F90 C201             byte  key.fctn.l, pane.focus.cmdb
0244 7F92 6858             data  edkey.action.cmdb.end
0245                       ;-------------------------------------------------------
0246                       ; Modifier keys
0247                       ;-------------------------------------------------------
0248 7F94 0701             byte  key.fctn.3, pane.focus.cmdb
0249 7F96 6870             data  edkey.action.cmdb.clear
0250                       ;-------------------------------------------------------
0251                       ; Other action keys
0252                       ;-------------------------------------------------------
0253 7F98 0F01             byte  key.fctn.9, pane.focus.cmdb
0254 7F9A 6A5C             data  edkey.action.cmdb.close.dialog
0255               
0256 7F9C 0501             byte  key.fctn.plus, pane.focus.cmdb
0257 7F9E 66F2             data  edkey.action.quit
0258               
0259 7FA0 9A01             byte  key.ctrl.z, pane.focus.cmdb
0260 7FA2 7708             data  pane.action.colorscheme.cycle
0261                       ;------------------------------------------------------
0262                       ; End of list
0263                       ;-------------------------------------------------------
0264 7FA4 FFFF             data  EOL                           ; EOL
                   < stevie_b1.asm.30692
0174                       ;-----------------------------------------------------------------------
0175                       ; Bank full check
0176                       ;-----------------------------------------------------------------------
0180                       ;-----------------------------------------------------------------------
0181                       ; Vector table
0182                       ;-----------------------------------------------------------------------
0183                       aorg  >7fc0
0184                       copy  "rom.vectors.bank1.asm"
     **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 6E76     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0008 7FC2 6D26     vec.2   data  idx.entry.update      ;    for index functions.
0009 7FC4 6DD4     vec.3   data  idx.entry.delete      ;
0010 7FC6 6D78     vec.4   data  idx.pointer.get       ;
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 6F5E     vec.10  data  edb.line.pack.fb      ;
0017 7FD4 7056     vec.11  data  edb.line.unpack.fb    ;
0018 7FD6 7562     vec.12  data  edb.clear.sams        ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 68BA     vec.15  data  edkey.action.cmdb.show
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 2026     vec.18  data  cpu.crash             ;
0025 7FE4 7DFE     vec.19  data  cmdb.cmd.clear        ;
0026 7FE6 6C7A     vec.20  data  fb.refresh            ;
0027 7FE8 7E5C     vec.21  data  fb.vdpdump            ;
0028 7FEA 6A70     vec.22  data  fb.row2line           ;
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 2026     vec.24  data  cpu.crash             ;
0031 7FF0 2026     vec.25  data  cpu.crash             ;
0032 7FF2 2026     vec.26  data  cpu.crash             ;
0033 7FF4 7AC2     vec.27  data  pane.errline.hide     ;
0034 7FF6 7954     vec.28  data  pane.cursor.blink     ;
0035 7FF8 7936     vec.29  data  pane.cursor.hide      ;
0036 7FFA 7A5A     vec.30  data  pane.errline.show     ;
0037 7FFC 7766     vec.31  data  pane.action.colorscheme.load
0038 7FFE 791C     vec.32  data  pane.action.colorscheme.statlines
                   < stevie_b1.asm.30692
0185                                                   ; Vector table bank 1
0186               *--------------------------------------------------------------
0187               * Video mode configuration
0188               *--------------------------------------------------------------
0189      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0190      0004     spfbck  equ   >04                   ; Screen background color.
0191      3458     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0192      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0193      0050     colrow  equ   80                    ; Columns per row
0194      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0195      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0196      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0197      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

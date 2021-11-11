XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b3.asm.58356
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b3.asm               ; Version 211111-2049270
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
                   < stevie_b3.asm.58356
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
                   < stevie_b3.asm.58356
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
0153      A02E     trmpvector        equ  core1.top + 46  ; Vector trampoline (if p1|tmp1 = >ffff)
0154      A030     core1.free        equ  core1.top + 48  ; End of structure
0155               *--------------------------------------------------------------
0156               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0157               *--------------------------------------------------------------
0158      A100     core2.top         equ  >a100           ; Structure begin
0159      A100     timers            equ  core2.top       ; Timer table
0160      A140     rambuf            equ  core2.top + 64  ; RAM workbuffer (160 bytes)
0161      A1E0     ramsat            equ  core2.top + 224 ; Sprite Attr. Table in RAM (14 bytes)
0162      A1EE     core2.free        equ  core2.top + 238 ; End of structure
0163               *--------------------------------------------------------------
0164               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0165               *--------------------------------------------------------------
0166      A200     tv.top            equ  >a200           ; Structure begin
0167      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0168      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0169      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0170      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0171      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0172      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0173      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0174      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0175      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0176      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0177      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0178      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0179      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0180      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0181      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0182      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0183      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0184      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0185      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0186      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0187      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0188      A22A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0189      A2CA     tv.free           equ  tv.top + 202    ; End of structure
0190               *--------------------------------------------------------------
0191               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0192               *--------------------------------------------------------------
0193      A300     fb.struct         equ  >a300           ; Structure begin
0194      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0195      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0196      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0197                                                      ; line X in editor buffer).
0198      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0199                                                      ; (offset 0 .. @fb.scrrows)
0200      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0201      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0202      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0203      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0204      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0205      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0206      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0207      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0208      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0209      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0210      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0211      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0212      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0213      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0214               *--------------------------------------------------------------
0215               * File handle structure               @>a400-a4ff   (256 bytes)
0216               *--------------------------------------------------------------
0217      A400     fh.struct         equ  >a400           ; stevie file handling structures
0218               ;***********************************************************************
0219               ; ATTENTION
0220               ; The dsrlnk variables must form a continuous memory block and keep
0221               ; their order!
0222               ;***********************************************************************
0223      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0224      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0225      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0226      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0227      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0228      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0229      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0230      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0231      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0232      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0233      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0234      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0235      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0236      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0237      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0238      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0239      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0240      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0241      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0242      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0243      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0244      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0245      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0246      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0247      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0248      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0249      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0250      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0251      A45C     fh.line           equ  fh.struct + 92  ; Editor buffer line currently processing
0252      A45E     fh.temp1          equ  fh.struct + 94  ; Temporary variable 1
0253      A460     fh.temp2          equ  fh.struct + 96  ; Temporary variable 2
0254      A462     fh.temp3          equ  fh.struct + 98  ; Temporary variable 3
0255      A464     fh.membuffer      equ  fh.struct +100  ; 80 bytes file memory buffer
0256      A4B4     fh.free           equ  fh.struct +180  ; End of structure
0257      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0258      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0259               *--------------------------------------------------------------
0260               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0261               *--------------------------------------------------------------
0262      A500     edb.struct        equ  >a500           ; Begin structure
0263      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0264      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0265      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0266      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0267      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0268      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0269      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0270      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0271      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0272      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0273                                                      ; with current filename.
0274      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0275                                                      ; with current file type.
0276      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0277      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0278      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0279                                                      ; for filename, but not always used.
0280      A569     edb.free          equ  edb.struct + 105; End of structure
0281               *--------------------------------------------------------------
0282               * Index structure                     @>a600-a6ff   (256 bytes)
0283               *--------------------------------------------------------------
0284      A600     idx.struct        equ  >a600           ; stevie index structure
0285      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0286      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0287      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0288      A606     idx.free          equ  idx.struct + 6  ; End of structure
0289               *--------------------------------------------------------------
0290               * Command buffer structure            @>a700-a7ff   (256 bytes)
0291               *--------------------------------------------------------------
0292      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0293      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0294      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0295      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0296      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0297      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0298      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0299      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0300      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0301      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0302      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0303      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0304      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0305      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0306      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0307      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0308      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0309      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0310      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0311      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0312      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0313      A728     cmdb.cmdall       equ  cmdb.struct + 40; Current command including length-byte
0314      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0315      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0316      A77A     cmdb.panhead.buf  equ  cmdb.struct +122; String buffer for pane header
0317      A7C8     cmdb.free         equ  cmdb.struct +200; End of structure
0318               *--------------------------------------------------------------
0319               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0320               *--------------------------------------------------------------
0321      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0322               *--------------------------------------------------------------
0323               * Farjump return stack                @>af00-afff   (256 bytes)
0324               *--------------------------------------------------------------
0325      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0326                                                      ; Grows downwards from high to low.
0327               *--------------------------------------------------------------
0328               * Index                               @>b000-bfff  (4096 bytes)
0329               *--------------------------------------------------------------
0330      B000     idx.top           equ  >b000           ; Top of index
0331      1000     idx.size          equ  4096            ; Index size
0332               *--------------------------------------------------------------
0333               * Editor buffer                       @>c000-cfff  (4096 bytes)
0334               *--------------------------------------------------------------
0335      C000     edb.top           equ  >c000           ; Editor buffer high memory
0336      1000     edb.size          equ  4096            ; Editor buffer size
0337               *--------------------------------------------------------------
0338               * Frame buffer                        @>d000-dfff  (4096 bytes)
0339               *--------------------------------------------------------------
0340      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0341      0960     fb.size           equ  80*30           ; Frame buffer size
0342               *--------------------------------------------------------------
0343               * Command buffer history              @>e000-efff  (4096 bytes)
0344               *--------------------------------------------------------------
0345      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0346      1000     cmdb.size         equ  4096            ; Command buffer size
0347               *--------------------------------------------------------------
0348               * Heap                                @>f000-ffff  (4096 bytes)
0349               *--------------------------------------------------------------
0350      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b3.asm.58356
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
                   < stevie_b3.asm.58356
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
0045 6011   53             text  'STEVIE 1.2E'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3245     
0046                       even
0047               
0049               
                   < stevie_b3.asm.58356
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
0230 61D2 0460  28         b     @cpu.crash.showbank   ; Expected to be included in
     61D4 7FB0     
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
0265 6215   53             text  'Source    stevie_b3.lst.asm'
     6216 6F75     
     6218 7263     
     621A 6520     
     621C 2020     
     621E 2073     
     6220 7465     
     6222 7669     
     6224 655F     
     6226 6233     
     6228 2E6C     
     622A 7374     
     622C 2E61     
     622E 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 6230 18               byte  24
0270 6231   42             text  'Build-ID  211111-2049270'
     6232 7569     
     6234 6C64     
     6236 2D49     
     6238 4420     
     623A 2032     
     623C 3131     
     623E 3131     
     6240 312D     
     6242 3230     
     6244 3439     
     6246 3237     
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
                   < stevie_b3.asm.58356
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
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 7120 0285  22         ci    tmp1,>ffff
     7122 FFFF     
0075 7124 1602  14         jne   !
0076 7126 C160  34         mov   @trmpvector,tmp1
     7128 A02E     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 712A C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 712C 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 712E 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 7130 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7132 FFCE     
0091 7134 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7136 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 7138 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 713A C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     713C A226     
0102 713E C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 7140 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 7142 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 7144 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 7146 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 7148 028B  22         ci    r11,>6000
     714A 6000     
0115 714C 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 714E 028B  22         ci    r11,>7fff
     7150 7FFF     
0117 7152 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 7154 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     7156 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 7158 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 715A 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 715C 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 715E 0225  22         ai    tmp1,>0800
     7160 0800     
0137 7162 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 7164 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 7166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7168 FFCE     
0144 716A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     716C 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 716E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 7170 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 7172 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 7174 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 7176 045B  20         b     *r11                  ; Return to caller
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
                   < stevie_b3.asm.58356
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
0058 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0059                       ;-----------------------------------------------------------------------
0060                       ; Include files - Shared code
0061                       ;-----------------------------------------------------------------------
0062               
0063                       ;-----------------------------------------------------------------------
0064                       ; Include files - Dialogs
0065                       ;-----------------------------------------------------------------------
0066                       copy  "dialog.menu.asm"     ; Dialog "Stevie Menu"
     **** ****     > dialog.menu.asm
0001               * FILE......: dialog.menu.asm
0002               * Purpose...: Dialog "Stevie Menu"
0003               
0004               ***************************************************************
0005               * dialog.menu
0006               * Open Dialog "Stevie Menu"
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
     605C 6FF0     
0033 605E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6060 A71C     
0034               
0035 6062 0204  20         li    tmp0,txt.info.menu
     6064 6FFF     
0036 6066 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6068 A71E     
0037               
0038 606A 0204  20         li    tmp0,pos.info.menu
     606C 701A     
0039 606E C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     6070 A722     
0040               
0041 6072 0204  20         li    tmp0,txt.hint.menu
     6074 701F     
0042 6076 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6078 A720     
0043               
0044 607A 0204  20         li    tmp0,txt.keys.menu
     607C 7022     
0045 607E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6080 A724     
0046               
0047 6082 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6084 6B5A     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.menu.exit:
0052 6086 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6088 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 608A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0067                       copy  "dialog.help.asm"     ; Dialog "Help"
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
     6096 0067     
0016 6098 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     609A A71A     
0017               
0018 609C 06A0  32         bl    @dialog.help.content  ; display content in modal dialog
     609E 60CC     
0019               
0020 60A0 0204  20         li    tmp0,txt.head.about
     60A2 6F5C     
0021 60A4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     60A6 A71C     
0022               
0023 60A8 0204  20         li    tmp0,txt.about.build
     60AA 6FA2     
0024 60AC C804  38         mov   tmp0,@cmdb.paninfo    ; Info line
     60AE A71E     
0025 60B0 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     60B2 A722     
0026               
0027 60B4 0204  20         li    tmp0,txt.hint.about
     60B6 6F68     
0028 60B8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     60BA A720     
0029               
0030 60BC 0204  20         li    tmp0,txt.keys.about
     60BE 6F86     
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
0067                       ; Show About dialog
0068                       ;------------------------------------------------------
0069 60E2 06A0  32         bl    @filv
     60E4 22A2     
0070 60E6 0050                   data vdp.fb.toprow.sit,32,vdp.sit.size - 160
     60E8 0020     
     60EA 08C0     
0071                                                   ; Clear screen
0072               
0073 60EC 06A0  32         bl    @filv
     60EE 22A2     
0074 60F0 2180                   data sprsat,0,32      ; Turn off sprites
     60F2 0000     
     60F4 0020     
0075               
0076                       ;------------------------------------------------------
0077                       ; Display keyboard shortcuts (part 1)
0078                       ;------------------------------------------------------
0079 60F6 0204  20         li    tmp0,>0100            ; Y=1, X=0
     60F8 0100     
0080 60FA C804  38         mov   tmp0,@wyx             ; Set cursor position
     60FC 832A     
0081 60FE 0205  20         li    tmp1,dialog.help.help.part1
     6100 612C     
0082                                                   ; Pointer to string
0083 6102 0206  20         li    tmp2,23               ; Set loop counter
     6104 0017     
0084               
0085 6106 06A0  32         bl    @putlst               ; Loop over string list and display
     6108 245E     
0086                                                   ; \ i  @wyx = Cursor position
0087                                                   ; | i  tmp1 = Pointer to first length-
0088                                                   ; |           prefixed string in list
0089                                                   ; / i  tmp2 = Number of strings to display
0090               
0091                       ;------------------------------------------------------
0092                       ; Display keyboard shortcuts (part 2)
0093                       ;------------------------------------------------------
0094 610A 0204  20         li    tmp0,>012a            ; Y=1, X=42
     610C 012A     
0095 610E C804  38         mov   tmp0,@wyx             ; Set cursor position
     6110 832A     
0096 6112 0205  20         li    tmp1,dialog.help.help.part2
     6114 6354     
0097                                                   ; Pointer to string
0098 6116 0206  20         li    tmp2,23               ; Set loop counter
     6118 0017     
0099               
0100 611A 06A0  32         bl    @putlst               ; Loop over string list and display
     611C 245E     
0101                                                   ; \ i  @wyx = Cursor position
0102                                                   ; | i  tmp1 = Pointer to first length-
0103                                                   ; |           prefixed string in list
0104                                                   ; / i  tmp2 = Number of strings to display
0105               
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               dialog.help.content.exit:
0110 611E C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6120 832A     
0111 6122 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0112 6124 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0113 6126 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0114 6128 C2F9  30         mov   *stack+,r11           ; Pop r11
0115 612A 045B  20         b     *r11                  ; Return
0116               
0117               
0118               
0119               dialog.help.help.part1:
0120               
0121 612C 23               byte  35
0122 612D   2D             text  '------------- Cursor --------------'
     612E 2D2D     
     6130 2D2D     
     6132 2D2D     
     6134 2D2D     
     6136 2D2D     
     6138 2D2D     
     613A 2043     
     613C 7572     
     613E 736F     
     6140 7220     
     6142 2D2D     
     6144 2D2D     
     6146 2D2D     
     6148 2D2D     
     614A 2D2D     
     614C 2D2D     
     614E 2D2D     
0123                       even
0124               
0125               
0126 6150 12               byte  18
0127 6151   46             text  'Fctn s        Left'
     6152 6374     
     6154 6E20     
     6156 7320     
     6158 2020     
     615A 2020     
     615C 2020     
     615E 204C     
     6160 6566     
     6162 74       
0128                       even
0129               
0130               
0131 6164 13               byte  19
0132 6165   46             text  'Fctn d        Right'
     6166 6374     
     6168 6E20     
     616A 6420     
     616C 2020     
     616E 2020     
     6170 2020     
     6172 2052     
     6174 6967     
     6176 6874     
0133                       even
0134               
0135               
0136 6178 10               byte  16
0137 6179   46             text  'Fctn e        Up'
     617A 6374     
     617C 6E20     
     617E 6520     
     6180 2020     
     6182 2020     
     6184 2020     
     6186 2055     
     6188 70       
0138                       even
0139               
0140               
0141 618A 12               byte  18
0142 618B   46             text  'Fctn x        Down'
     618C 6374     
     618E 6E20     
     6190 7820     
     6192 2020     
     6194 2020     
     6196 2020     
     6198 2044     
     619A 6F77     
     619C 6E       
0143                       even
0144               
0145               
0146 619E 12               byte  18
0147 619F   46             text  'Fctn h        Home'
     61A0 6374     
     61A2 6E20     
     61A4 6820     
     61A6 2020     
     61A8 2020     
     61AA 2020     
     61AC 2048     
     61AE 6F6D     
     61B0 65       
0148                       even
0149               
0150               
0151 61B2 11               byte  17
0152 61B3   46             text  'Fctn l        End'
     61B4 6374     
     61B6 6E20     
     61B8 6C20     
     61BA 2020     
     61BC 2020     
     61BE 2020     
     61C0 2045     
     61C2 6E64     
0153                       even
0154               
0155               
0156 61C4 1B               byte  27
0157 61C5   46             text  'Fctn j        Previous word'
     61C6 6374     
     61C8 6E20     
     61CA 6A20     
     61CC 2020     
     61CE 2020     
     61D0 2020     
     61D2 2050     
     61D4 7265     
     61D6 7669     
     61D8 6F75     
     61DA 7320     
     61DC 776F     
     61DE 7264     
0158                       even
0159               
0160               
0161 61E0 17               byte  23
0162 61E1   46             text  'Fctn k        Next word'
     61E2 6374     
     61E4 6E20     
     61E6 6B20     
     61E8 2020     
     61EA 2020     
     61EC 2020     
     61EE 204E     
     61F0 6578     
     61F2 7420     
     61F4 776F     
     61F6 7264     
0163                       even
0164               
0165               
0166 61F8 16               byte  22
0167 61F9   46             text  'Fctn 7   ^t   Next tab'
     61FA 6374     
     61FC 6E20     
     61FE 3720     
     6200 2020     
     6202 5E74     
     6204 2020     
     6206 204E     
     6208 6578     
     620A 7420     
     620C 7461     
     620E 62       
0168                       even
0169               
0170               
0171 6210 15               byte  21
0172 6211   46             text  'Fctn 6   ^e   Page up'
     6212 6374     
     6214 6E20     
     6216 3620     
     6218 2020     
     621A 5E65     
     621C 2020     
     621E 2050     
     6220 6167     
     6222 6520     
     6224 7570     
0173                       even
0174               
0175               
0176 6226 17               byte  23
0177 6227   46             text  'Fctn 4   ^x   Page down'
     6228 6374     
     622A 6E20     
     622C 3420     
     622E 2020     
     6230 5E78     
     6232 2020     
     6234 2050     
     6236 6167     
     6238 6520     
     623A 646F     
     623C 776E     
0178                       even
0179               
0180               
0181 623E 18               byte  24
0182 623F   46             text  'Fctn v        Screen top'
     6240 6374     
     6242 6E20     
     6244 7620     
     6246 2020     
     6248 2020     
     624A 2020     
     624C 2053     
     624E 6372     
     6250 6565     
     6252 6E20     
     6254 746F     
     6256 70       
0183                       even
0184               
0185               
0186 6258 1B               byte  27
0187 6259   46             text  'Fctn b        Screen bottom'
     625A 6374     
     625C 6E20     
     625E 6220     
     6260 2020     
     6262 2020     
     6264 2020     
     6266 2053     
     6268 6372     
     626A 6565     
     626C 6E20     
     626E 626F     
     6270 7474     
     6272 6F6D     
0188                       even
0189               
0190               
0191 6274 16               byte  22
0192 6275   43             text  'Ctrl v   ^v   File top'
     6276 7472     
     6278 6C20     
     627A 7620     
     627C 2020     
     627E 5E76     
     6280 2020     
     6282 2046     
     6284 696C     
     6286 6520     
     6288 746F     
     628A 70       
0193                       even
0194               
0195               
0196 628C 19               byte  25
0197 628D   43             text  'Ctrl b   ^b   File bottom'
     628E 7472     
     6290 6C20     
     6292 6220     
     6294 2020     
     6296 5E62     
     6298 2020     
     629A 2046     
     629C 696C     
     629E 6520     
     62A0 626F     
     62A2 7474     
     62A4 6F6D     
0198                       even
0199               
0200               
0201               
0202 62A6 01               byte  1
0203 62A7   20             text  ' '
0204                       even
0205               
0206               
0207 62A8 23               byte  35
0208 62A9   2D             text  '------------- Others --------------'
     62AA 2D2D     
     62AC 2D2D     
     62AE 2D2D     
     62B0 2D2D     
     62B2 2D2D     
     62B4 2D2D     
     62B6 204F     
     62B8 7468     
     62BA 6572     
     62BC 7320     
     62BE 2D2D     
     62C0 2D2D     
     62C2 2D2D     
     62C4 2D2D     
     62C6 2D2D     
     62C8 2D2D     
     62CA 2D2D     
0209                       even
0210               
0211               
0212 62CC 12               byte  18
0213 62CD   46             text  'Fctn +   ^q   Quit'
     62CE 6374     
     62D0 6E20     
     62D2 2B20     
     62D4 2020     
     62D6 5E71     
     62D8 2020     
     62DA 2051     
     62DC 7569     
     62DE 74       
0214                       even
0215               
0216               
0217 62E0 12               byte  18
0218 62E1   43             text  'Ctrl h   ^h   Help'
     62E2 7472     
     62E4 6C20     
     62E6 6820     
     62E8 2020     
     62EA 5E68     
     62EC 2020     
     62EE 2048     
     62F0 656C     
     62F2 70       
0219                       even
0220               
0221               
0222 62F4 1A               byte  26
0223 62F5   63             text  'ctrl u   ^u   Toggle ruler'
     62F6 7472     
     62F8 6C20     
     62FA 7520     
     62FC 2020     
     62FE 5E75     
     6300 2020     
     6302 2054     
     6304 6F67     
     6306 676C     
     6308 6520     
     630A 7275     
     630C 6C65     
     630E 72       
0224                       even
0225               
0226               
0227 6310 21               byte  33
0228 6311   43             text  'Ctrl z   ^z   Cycle color schemes'
     6312 7472     
     6314 6C20     
     6316 7A20     
     6318 2020     
     631A 5E7A     
     631C 2020     
     631E 2043     
     6320 7963     
     6322 6C65     
     6324 2063     
     6326 6F6C     
     6328 6F72     
     632A 2073     
     632C 6368     
     632E 656D     
     6330 6573     
0229                       even
0230               
0231               
0232 6332 20               byte  32
0233 6333   63             text  'ctrl /   ^/   TI Basic (F9=exit)'
     6334 7472     
     6336 6C20     
     6338 2F20     
     633A 2020     
     633C 5E2F     
     633E 2020     
     6340 2054     
     6342 4920     
     6344 4261     
     6346 7369     
     6348 6320     
     634A 2846     
     634C 393D     
     634E 6578     
     6350 6974     
     6352 29       
0234                       even
0235               
0236               
0237               dialog.help.help.part2:
0238               
0239 6354 23               byte  35
0240 6355   2D             text  '------------- File ----------------'
     6356 2D2D     
     6358 2D2D     
     635A 2D2D     
     635C 2D2D     
     635E 2D2D     
     6360 2D2D     
     6362 2046     
     6364 696C     
     6366 6520     
     6368 2D2D     
     636A 2D2D     
     636C 2D2D     
     636E 2D2D     
     6370 2D2D     
     6372 2D2D     
     6374 2D2D     
     6376 2D2D     
0241                       even
0242               
0243               
0244 6378 23               byte  35
0245 6379   43             text  'Ctrl i   ^i   Insert file at cursor'
     637A 7472     
     637C 6C20     
     637E 6920     
     6380 2020     
     6382 5E69     
     6384 2020     
     6386 2049     
     6388 6E73     
     638A 6572     
     638C 7420     
     638E 6669     
     6390 6C65     
     6392 2061     
     6394 7420     
     6396 6375     
     6398 7273     
     639A 6F72     
0246                       even
0247               
0248               
0249 639C 17               byte  23
0250 639D   43             text  'Ctrl o   ^o   Open file'
     639E 7472     
     63A0 6C20     
     63A2 6F20     
     63A4 2020     
     63A6 5E6F     
     63A8 2020     
     63AA 204F     
     63AC 7065     
     63AE 6E20     
     63B0 6669     
     63B2 6C65     
0251                       even
0252               
0253               
0254 63B4 18               byte  24
0255 63B5   43             text  'Ctrl p   ^p   Print file'
     63B6 7472     
     63B8 6C20     
     63BA 7020     
     63BC 2020     
     63BE 5E70     
     63C0 2020     
     63C2 2050     
     63C4 7269     
     63C6 6E74     
     63C8 2066     
     63CA 696C     
     63CC 65       
0256                       even
0257               
0258               
0259 63CE 17               byte  23
0260 63CF   43             text  'Ctrl s   ^s   Save file'
     63D0 7472     
     63D2 6C20     
     63D4 7320     
     63D6 2020     
     63D8 5E73     
     63DA 2020     
     63DC 2053     
     63DE 6176     
     63E0 6520     
     63E2 6669     
     63E4 6C65     
0261                       even
0262               
0263               
0264 63E6 20               byte  32
0265 63E7   43             text  'Ctrl ,   ^,   Load previous file'
     63E8 7472     
     63EA 6C20     
     63EC 2C20     
     63EE 2020     
     63F0 5E2C     
     63F2 2020     
     63F4 204C     
     63F6 6F61     
     63F8 6420     
     63FA 7072     
     63FC 6576     
     63FE 696F     
     6400 7573     
     6402 2066     
     6404 696C     
     6406 65       
0266                       even
0267               
0268               
0269 6408 1C               byte  28
0270 6409   43             text  'Ctrl .   ^.   Load next file'
     640A 7472     
     640C 6C20     
     640E 2E20     
     6410 2020     
     6412 5E2E     
     6414 2020     
     6416 204C     
     6418 6F61     
     641A 6420     
     641C 6E65     
     641E 7874     
     6420 2066     
     6422 696C     
     6424 65       
0271                       even
0272               
0273               
0274 6426 01               byte  1
0275 6427   20             text  ' '
0276                       even
0277               
0278               
0279 6428 23               byte  35
0280 6429   2D             text  '------------- Block mode ----------'
     642A 2D2D     
     642C 2D2D     
     642E 2D2D     
     6430 2D2D     
     6432 2D2D     
     6434 2D2D     
     6436 2042     
     6438 6C6F     
     643A 636B     
     643C 206D     
     643E 6F64     
     6440 6520     
     6442 2D2D     
     6444 2D2D     
     6446 2D2D     
     6448 2D2D     
     644A 2D2D     
0281                       even
0282               
0283               
0284 644C 1E               byte  30
0285 644D   43             text  'Ctrl a   ^a   Set M1/M2 marker'
     644E 7472     
     6450 6C20     
     6452 6120     
     6454 2020     
     6456 5E61     
     6458 2020     
     645A 2053     
     645C 6574     
     645E 204D     
     6460 312F     
     6462 4D32     
     6464 206D     
     6466 6172     
     6468 6B65     
     646A 72       
0286                       even
0287               
0288               
0289 646C 1A               byte  26
0290 646D   43             text  'Ctrl d   ^d   Delete block'
     646E 7472     
     6470 6C20     
     6472 6420     
     6474 2020     
     6476 5E64     
     6478 2020     
     647A 2044     
     647C 656C     
     647E 6574     
     6480 6520     
     6482 626C     
     6484 6F63     
     6486 6B       
0291                       even
0292               
0293               
0294 6488 18               byte  24
0295 6489   43             text  'Ctrl c   ^c   Copy block'
     648A 7472     
     648C 6C20     
     648E 6320     
     6490 2020     
     6492 5E63     
     6494 2020     
     6496 2043     
     6498 6F70     
     649A 7920     
     649C 626C     
     649E 6F63     
     64A0 6B       
0296                       even
0297               
0298               
0299 64A2 1C               byte  28
0300 64A3   43             text  'Ctrl g   ^g   Goto marker M1'
     64A4 7472     
     64A6 6C20     
     64A8 6720     
     64AA 2020     
     64AC 5E67     
     64AE 2020     
     64B0 2047     
     64B2 6F74     
     64B4 6F20     
     64B6 6D61     
     64B8 726B     
     64BA 6572     
     64BC 204D     
     64BE 31       
0301                       even
0302               
0303               
0304 64C0 18               byte  24
0305 64C1   43             text  'Ctrl m   ^m   Move block'
     64C2 7472     
     64C4 6C20     
     64C6 6D20     
     64C8 2020     
     64CA 5E6D     
     64CC 2020     
     64CE 204D     
     64D0 6F76     
     64D2 6520     
     64D4 626C     
     64D6 6F63     
     64D8 6B       
0306                       even
0307               
0308               
0309 64DA 20               byte  32
0310 64DB   43             text  'Ctrl s   ^s   Save block to file'
     64DC 7472     
     64DE 6C20     
     64E0 7320     
     64E2 2020     
     64E4 5E73     
     64E6 2020     
     64E8 2053     
     64EA 6176     
     64EC 6520     
     64EE 626C     
     64F0 6F63     
     64F2 6B20     
     64F4 746F     
     64F6 2066     
     64F8 696C     
     64FA 65       
0311                       even
0312               
0313               
0314 64FC 01               byte  1
0315 64FD   20             text  ' '
0316                       even
0317               
0318               
0319 64FE 23               byte  35
0320 64FF   2D             text  '------------- Modifiers -----------'
     6500 2D2D     
     6502 2D2D     
     6504 2D2D     
     6506 2D2D     
     6508 2D2D     
     650A 2D2D     
     650C 204D     
     650E 6F64     
     6510 6966     
     6512 6965     
     6514 7273     
     6516 202D     
     6518 2D2D     
     651A 2D2D     
     651C 2D2D     
     651E 2D2D     
     6520 2D2D     
0321                       even
0322               
0323               
0324 6522 1E               byte  30
0325 6523   46             text  'Fctn 1        Delete character'
     6524 6374     
     6526 6E20     
     6528 3120     
     652A 2020     
     652C 2020     
     652E 2020     
     6530 2044     
     6532 656C     
     6534 6574     
     6536 6520     
     6538 6368     
     653A 6172     
     653C 6163     
     653E 7465     
     6540 72       
0326                       even
0327               
0328               
0329 6542 1E               byte  30
0330 6543   46             text  'Fctn 2        Insert character'
     6544 6374     
     6546 6E20     
     6548 3220     
     654A 2020     
     654C 2020     
     654E 2020     
     6550 2049     
     6552 6E73     
     6554 6572     
     6556 7420     
     6558 6368     
     655A 6172     
     655C 6163     
     655E 7465     
     6560 72       
0331                       even
0332               
0333               
0334 6562 19               byte  25
0335 6563   46             text  'Fctn 3        Delete line'
     6564 6374     
     6566 6E20     
     6568 3320     
     656A 2020     
     656C 2020     
     656E 2020     
     6570 2044     
     6572 656C     
     6574 6574     
     6576 6520     
     6578 6C69     
     657A 6E65     
0336                       even
0337               
0338               
0339 657C 20               byte  32
0340 657D   43             text  'Ctrl 4   ^4   Delete end of line'
     657E 7472     
     6580 6C20     
     6582 3420     
     6584 2020     
     6586 5E34     
     6588 2020     
     658A 2044     
     658C 656C     
     658E 6574     
     6590 6520     
     6592 656E     
     6594 6420     
     6596 6F66     
     6598 206C     
     659A 696E     
     659C 65       
0341                       even
0342               
0343               
0344 659E 19               byte  25
0345 659F   46             text  'Fctn 8        Insert line'
     65A0 6374     
     65A2 6E20     
     65A4 3820     
     65A6 2020     
     65A8 2020     
     65AA 2020     
     65AC 2049     
     65AE 6E73     
     65B0 6572     
     65B2 7420     
     65B4 6C69     
     65B6 6E65     
0346                       even
0347               
0348               
0349 65B8 1E               byte  30
0350 65B9   46             text  'Fctn .        Insert/Overwrite'
     65BA 6374     
     65BC 6E20     
     65BE 2E20     
     65C0 2020     
     65C2 2020     
     65C4 2020     
     65C6 2049     
     65C8 6E73     
     65CA 6572     
     65CC 742F     
     65CE 4F76     
     65D0 6572     
     65D2 7772     
     65D4 6974     
     65D6 65       
0351                       even
0352               
                   < stevie_b3.asm.58356
0068                       copy  "dialog.file.asm"     ; Dialog "File"
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
0022 65D8 0649  14         dect  stack
0023 65DA C64B  30         mov   r11,*stack            ; Save return address
0024 65DC 0649  14         dect  stack
0025 65DE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 65E0 0204  20         li    tmp0,id.dialog.file
     65E2 0068     
0030 65E4 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     65E6 A71A     
0031               
0032 65E8 0204  20         li    tmp0,txt.head.file
     65EA 702A     
0033 65EC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     65EE A71C     
0034               
0035 65F0 0204  20         li    tmp0,txt.info.file
     65F2 7058     
0036 65F4 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     65F6 A71E     
0037               
0038 65F8 0204  20         li    tmp0,pos.info.file
     65FA 707C     
0039 65FC C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     65FE A722     
0040               
0041 6600 0204  20         li    tmp0,txt.hint.file
     6602 7082     
0042 6604 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6606 A720     
0043               
0044 6608 0204  20         li    tmp0,txt.keys.file
     660A 7084     
0045 660C C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     660E A724     
0046               
0047 6610 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6612 6B5A     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.file.exit:
0052 6614 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6616 C2F9  30         mov   *stack+,r11           ; Pop R11
0054 6618 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0069                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
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
0022 661A 0649  14         dect  stack
0023 661C C64B  30         mov   r11,*stack            ; Save return address
0024 661E 0649  14         dect  stack
0025 6620 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Show dialog "Unsaved changes" if editor buffer dirty
0028                       ;-------------------------------------------------------
0029 6622 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6624 A506     
0030 6626 1303  14         jeq   dialog.load.setup     ; No, skip "Unsaved changes"
0031               
0032 6628 06A0  32         bl    @dialog.unsaved       ; Show dialog
     662A 6760     
0033 662C 101F  14         jmp   dialog.load.exit      ; Exit early
0034                       ;-------------------------------------------------------
0035                       ; Setup dialog
0036                       ;-------------------------------------------------------
0037               dialog.load.setup:
0038 662E 0204  20         li    tmp0,id.dialog.load
     6630 000A     
0039 6632 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6634 A71A     
0040               
0041 6636 0204  20         li    tmp0,txt.head.load
     6638 6D14     
0042 663A C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     663C A71C     
0043               
0044 663E 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     6640 A71E     
0045 6642 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6644 A722     
0046               
0047 6646 0204  20         li    tmp0,txt.hint.load
     6648 6D28     
0048 664A C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     664C A720     
0049               
0050 664E 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6650 A44E     
0051 6652 1303  14         jeq   !
0052                       ;-------------------------------------------------------
0053                       ; Show that FastMode is on
0054                       ;-------------------------------------------------------
0055 6654 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     6656 6D96     
0056 6658 1002  14         jmp   dialog.load.keylist
0057                       ;-------------------------------------------------------
0058                       ; Show that FastMode is off
0059                       ;-------------------------------------------------------
0060 665A 0204  20 !       li    tmp0,txt.keys.load
     665C 6D66     
0061                       ;-------------------------------------------------------
0062                       ; Show dialog
0063                       ;-------------------------------------------------------
0064               dialog.load.keylist:
0065 665E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6660 A724     
0066                       ;-------------------------------------------------------
0067                       ; Set cursor shape
0068                       ;-------------------------------------------------------
0069 6662 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6664 6B48     
0070 6666 C820  54         mov   @tv.curshape,@ramsat+2
     6668 A214     
     666A A1E2     
0071                                                   ; Get cursor shape and color
0072                       ;-------------------------------------------------------
0073                       ; Exit
0074                       ;-------------------------------------------------------
0075               dialog.load.exit:
0076 666C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 666E C2F9  30         mov   *stack+,r11           ; Pop R11
0078 6670 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0070                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
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
0022 6672 0649  14         dect  stack
0023 6674 C64B  30         mov   r11,*stack            ; Save return address
0024 6676 0649  14         dect  stack
0025 6678 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 667A 8820  54         c     @fb.row.dirty,@w$ffff
     667C A30A     
     667E 2022     
0030 6680 1604  14         jne   !                     ; Skip crunching if clean
0031 6682 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6684 6AEE     
0032 6686 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6688 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 668A 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     668C A50E     
     668E 2022     
0037 6690 1309  14         jeq   dialog.save.default   ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 6692 06A0  32         bl    @cmdb.cmd.clear       ; Clear current CMDB command
     6694 6A5C     
0042               
0043 6696 0204  20         li    tmp0,id.dialog.saveblock
     6698 000C     
0044 669A C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     669C A71A     
0045 669E 0204  20         li    tmp0,txt.head.save2   ; Title "Save code block to DV80 file"
     66A0 6DDC     
0046               
0047 66A2 1006  14         jmp   dialog.save.header
0048                       ;-------------------------------------------------------
0049                       ; Default dialog
0050                       ;-------------------------------------------------------
0051               dialog.save.default:
0052 66A4 0204  20         li    tmp0,id.dialog.save
     66A6 000B     
0053 66A8 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     66AA A71A     
0054 66AC 0204  20         li    tmp0,txt.head.save    ; Title "Save DV80 file"
     66AE 6DC8     
0055                       ;-------------------------------------------------------
0056                       ; Setup header
0057                       ;-------------------------------------------------------
0058               dialog.save.header:
0059 66B0 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     66B2 A71C     
0060               
0061 66B4 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     66B6 A71E     
0062 66B8 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     66BA A722     
0063               
0064 66BC 0204  20         li    tmp0,txt.hint.save
     66BE 6E00     
0065 66C0 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     66C2 A720     
0066               
0067 66C4 0204  20         li    tmp0,txt.keys.save
     66C6 6E02     
0068 66C8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     66CA A724     
0069               
0070 66CC 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     66CE A44E     
0071                       ;-------------------------------------------------------
0072                       ; Set cursor shape
0073                       ;-------------------------------------------------------
0074 66D0 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     66D2 6B48     
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               dialog.save.exit:
0079 66D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 66D6 C2F9  30         mov   *stack+,r11           ; Pop R11
0081 66D8 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0071                       copy  "dialog.insert.asm"   ; Dialog "Insert DV80 file"
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
0022 66DA 0649  14         dect  stack
0023 66DC C64B  30         mov   r11,*stack            ; Save return address
0024 66DE 0649  14         dect  stack
0025 66E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029               dialog.insert.setup:
0030 66E2 0204  20         li    tmp0,id.dialog.insert
     66E4 000D     
0031 66E6 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     66E8 A71A     
0032                       ;------------------------------------------------------
0033                       ; Include line number in pane header
0034                       ;------------------------------------------------------
0035 66EA 06A0  32         bl    @cpym2m
     66EC 24EE     
0036 66EE 6E26                   data txt.head.insert,cmdb.panhead.buf,30
     66F0 A77A     
     66F2 001E     
0037               
0038 66F4 C820  54         mov   @fb.row,@parm1
     66F6 A306     
     66F8 A000     
0039 66FA 06A0  32         bl    @fb.row2line          ; Row to editor line
     66FC 6B24     
0040                                                   ; \ i @fb.topline = Top line in frame buffer
0041                                                   ; | i @parm1      = Row in frame buffer
0042                                                   ; / o @outparm1   = Matching line in EB
0043               
0044 66FE 05A0  34         inc   @outparm1             ; Add base 1
     6700 A010     
0045               
0046 6702 06A0  32         bl    @mknum                ; Convert integer to string
     6704 2AAA     
0047 6706 A010                   data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
0048 6708 A140                   data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
0049 670A 30                     byte  48              ; | i  p2 = MSB offset for ASCII digit
0050 670B   30                   byte  48              ; / i  p2 = LSB char for replacing leading 0
0051               
0052 670C 06A0  32         bl    @cpym2m
     670E 24EE     
0053 6710 A140                   data rambuf,cmdb.panhead.buf + 29,5
     6712 A797     
     6714 0005     
0054                                                   ;
0055                                                   ; Add line number to buffer
0056               
0057 6716 0204  20         li    tmp0,34
     6718 0022     
0058 671A 0A84  56         sla   tmp0,8
0059 671C D804  38         movb  tmp0,@cmdb.panhead.buf ; Set length byte
     671E A77A     
0060               
0061 6720 0204  20         li    tmp0,cmdb.panhead.buf
     6722 A77A     
0062 6724 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6726 A71C     
0063                       ;------------------------------------------------------
0064                       ; Other panel strings
0065                       ;------------------------------------------------------
0066 6728 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     672A A71E     
0067 672C 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     672E A722     
0068               
0069 6730 0204  20         li    tmp0,txt.hint.insert
     6732 6E44     
0070 6734 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6736 A720     
0071               
0072 6738 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     673A 6A5C     
0073               
0074 673C 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     673E A44E     
0075 6740 1303  14         jeq   !
0076                       ;-------------------------------------------------------
0077                       ; Show that FastMode is on
0078                       ;-------------------------------------------------------
0079 6742 0204  20         li    tmp0,txt.keys.insert  ; Highlight FastMode
     6744 6E82     
0080 6746 1002  14         jmp   dialog.insert.keylist
0081                       ;-------------------------------------------------------
0082                       ; Show that FastMode is off
0083                       ;-------------------------------------------------------
0084 6748 0204  20 !       li    tmp0,txt.keys.insert
     674A 6E82     
0085                       ;-------------------------------------------------------
0086                       ; Show dialog
0087                       ;-------------------------------------------------------
0088               dialog.insert.keylist:
0089 674C C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     674E A724     
0090                       ;-------------------------------------------------------
0091                       ; Set cursor shape
0092                       ;-------------------------------------------------------
0093 6750 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6752 6B48     
0094 6754 C820  54         mov   @tv.curshape,@ramsat+2
     6756 A214     
     6758 A1E2     
0095                                                   ; Get cursor shape and color
0096                       ;-------------------------------------------------------
0097                       ; Exit
0098                       ;-------------------------------------------------------
0099               dialog.insert.exit:
0100 675A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0101 675C C2F9  30         mov   *stack+,r11           ; Pop R11
0102 675E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0072                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
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
0022 6760 0649  14         dect  stack
0023 6762 C64B  30         mov   r11,*stack            ; Save return address
0024 6764 0649  14         dect  stack
0025 6766 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 6768 0204  20         li    tmp0,id.dialog.unsaved
     676A 0065     
0030 676C C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     676E A71A     
0031               
0032 6770 0204  20         li    tmp0,txt.head.unsaved
     6772 6EE4     
0033 6774 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6776 A71C     
0034               
0035 6778 0204  20         li    tmp0,txt.info.unsaved
     677A 6EF9     
0036 677C C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     677E A71E     
0037 6780 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     6782 A722     
0038               
0039 6784 0204  20         li    tmp0,txt.hint.unsaved
     6786 6F1C     
0040 6788 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     678A A720     
0041               
0042 678C 0204  20         li    tmp0,txt.keys.unsaved
     678E 6F48     
0043 6790 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6792 A724     
0044               
0045 6794 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6796 6B5A     
0046                       ;-------------------------------------------------------
0047                       ; Exit
0048                       ;-------------------------------------------------------
0049               dialog.unsaved.exit:
0050 6798 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 679A C2F9  30         mov   *stack+,r11           ; Pop R11
0052 679C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0073                       copy  "dialog.basic.asm"    ; Dialog "Basic"
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
0022 679E 0649  14         dect  stack
0023 67A0 C64B  30         mov   r11,*stack            ; Save return address
0024 67A2 0649  14         dect  stack
0025 67A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 67A6 0204  20         li    tmp0,id.dialog.basic
     67A8 0069     
0030 67AA C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     67AC A71A     
0031               
0032 67AE 0204  20         li    tmp0,txt.head.basic
     67B0 708C     
0033 67B2 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     67B4 A71C     
0034               
0035 67B6 0204  20         li    tmp0,txt.info.basic
     67B8 709B     
0036 67BA C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     67BC A71E     
0037               
0038 67BE 0204  20         li    tmp0,pos.info.basic
     67C0 70B8     
0039 67C2 C804  38         mov   tmp0,@cmdb.panmarkers ; Show letter markers
     67C4 A722     
0040               
0041 67C6 0204  20         li    tmp0,txt.hint.basic
     67C8 70BB     
0042 67CA C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     67CC A720     
0043               
0044 67CE 0204  20         li    tmp0,txt.keys.basic
     67D0 70BE     
0045 67D2 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     67D4 A724     
0046               
0047 67D6 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     67D8 6B5A     
0048                       ;-------------------------------------------------------
0049                       ; Exit
0050                       ;-------------------------------------------------------
0051               dialog.basic.exit:
0052 67DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 67DC C2F9  30         mov   *stack+,r11           ; Pop R11
0054 67DE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0074                       ;-----------------------------------------------------------------------
0075                       ; Command buffer handling
0076                       ;-----------------------------------------------------------------------
0077                       copy  "pane.utils.hint.asm" ; Show hint in pane
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
0021 67E0 0649  14         dect  stack
0022 67E2 C64B  30         mov   r11,*stack            ; Save return address
0023 67E4 0649  14         dect  stack
0024 67E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 67E8 0649  14         dect  stack
0026 67EA C645  30         mov   tmp1,*stack           ; Push tmp1
0027 67EC 0649  14         dect  stack
0028 67EE C646  30         mov   tmp2,*stack           ; Push tmp2
0029 67F0 0649  14         dect  stack
0030 67F2 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 67F4 C820  54         mov   @parm1,@wyx           ; Set cursor
     67F6 A000     
     67F8 832A     
0035 67FA C160  34         mov   @parm2,tmp1           ; Get string to display
     67FC A002     
0036 67FE 06A0  32         bl    @xutst0               ; Display string
     6800 2434     
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 6802 C120  34         mov   @parm2,tmp0
     6804 A002     
0041 6806 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 6808 0984  56         srl   tmp0,8                ; Right justify
0043 680A C184  18         mov   tmp0,tmp2
0044 680C C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 680E 0506  16         neg   tmp2
0046 6810 0226  22         ai    tmp2,80               ; Number of bytes to fill
     6812 0050     
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 6814 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     6816 A000     
0051 6818 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 681A C804  38         mov   tmp0,@wyx             ; / Set cursor
     681C 832A     
0053               
0054 681E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6820 240E     
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 6822 0205  20         li    tmp1,32               ; Byte to fill
     6824 0020     
0059               
0060 6826 06A0  32         bl    @xfilv                ; Clear line
     6828 22A8     
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 682A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 682C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 682E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6830 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6832 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 6834 045B  20         b     *r11                  ; Return to caller
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
0095 6836 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     6838 A000     
0096 683A C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     683C A002     
0097 683E 0649  14         dect  stack
0098 6840 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 6842 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     6844 67E0     
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 6846 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 6848 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0078                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
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
0022 684A 0649  14         dect  stack
0023 684C C64B  30         mov   r11,*stack            ; Save return address
0024 684E 0649  14         dect  stack
0025 6850 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 6852 C820  54         mov   @wyx,@cmdb.fb.yxsave
     6854 832A     
     6856 A704     
0030                                                   ; Save YX position in frame buffer
0031               
0032 6858 0204  20         li    tmp0,pane.botrow
     685A 001D     
0033 685C 6120  34         s     @cmdb.scrrows,tmp0
     685E A706     
0034 6860 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6862 A31A     
0035               
0036 6864 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 6866 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     6868 A70E     
0038               
0039 686A 0224  22         ai    tmp0,>0100
     686C 0100     
0040 686E C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     6870 A710     
0041 6872 0584  14         inc   tmp0
0042 6874 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6876 A70A     
0043               
0044 6878 0720  34         seto  @cmdb.visible         ; Show pane
     687A A702     
0045 687C 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     687E A718     
0046               
0047 6880 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6882 0001     
0048 6884 C804  38         mov   tmp0,@tv.pane.focus   ; /
     6886 A222     
0049               
0050 6888 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     688A 6B36     
0051               
0052 688C 0720  34         seto  @parm1                ; Do not turn screen off while
     688E A000     
0053                                                   ; reloading color scheme
0054               
0055 6890 06A0  32         bl    @pane.action.colorscheme.load
     6892 6B6C     
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 6894 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6896 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6898 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0079                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
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
0023 689A 0649  14         dect  stack
0024 689C C64B  30         mov   r11,*stack            ; Save return address
0025 689E 0649  14         dect  stack
0026 68A0 C660  46         mov   @parm1,*stack         ; Push @parm1
     68A2 A000     
0027                       ;------------------------------------------------------
0028                       ; Hide command buffer pane
0029                       ;------------------------------------------------------
0030 68A4 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     68A6 A31C     
     68A8 A31A     
0031                       ;------------------------------------------------------
0032                       ; Adjust frame buffer size if error pane visible
0033                       ;------------------------------------------------------
0034 68AA C820  54         mov   @tv.error.visible,@tv.error.visible
     68AC A228     
     68AE A228     
0035 68B0 1302  14         jeq   !
0036 68B2 0620  34         dec   @fb.scrrows
     68B4 A31A     
0037                       ;------------------------------------------------------
0038                       ; Clear error/hint & status line
0039                       ;------------------------------------------------------
0040 68B6 06A0  32 !       bl    @hchar
     68B8 27DC     
0041 68BA 1900                   byte pane.botrow-4,0,32,80*3
     68BC 20F0     
0042 68BE 1C00                   byte pane.botrow-1,0,32,80*2
     68C0 20A0     
0043 68C2 FFFF                   data EOL
0044                       ;------------------------------------------------------
0045                       ; Adjust frame buffer size if ruler visible
0046                       ;------------------------------------------------------
0047 68C4 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     68C6 A210     
     68C8 A210     
0048 68CA 1302  14         jeq   pane.cmdb.hide.rest
0049 68CC 0620  34         dec   @fb.scrrows
     68CE A31A     
0050                       ;------------------------------------------------------
0051                       ; Hide command buffer pane (rest)
0052                       ;------------------------------------------------------
0053               pane.cmdb.hide.rest:
0054 68D0 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     68D2 A704     
     68D4 832A     
0055 68D6 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     68D8 A702     
0056 68DA 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     68DC A316     
0057 68DE 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     68E0 A222     
0058                       ;------------------------------------------------------
0059                       ; Reload current color scheme
0060                       ;------------------------------------------------------
0061 68E2 0720  34         seto  @parm1                ; Do not turn screen off while
     68E4 A000     
0062                                                   ; reloading color scheme
0063               
0064 68E6 06A0  32         bl    @pane.action.colorscheme.load
     68E8 6B6C     
0065                                                   ; Reload color scheme
0066                                                   ; i  parm1 = Skip screen off if >FFFF
0067                       ;------------------------------------------------------
0068                       ; Show cursor again
0069                       ;------------------------------------------------------
0070 68EA 06A0  32         bl    @pane.cursor.blink
     68EC 6B48     
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               pane.cmdb.hide.exit:
0075 68EE C839  50         mov   *stack+,@parm1        ; Pop @parm1
     68F0 A000     
0076 68F2 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 68F4 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0080                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
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
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0, tmp1, tmp2
0015               ********|*****|*********************|**************************
0016               pane.cmdb.draw:
0017 68F6 0649  14         dect  stack
0018 68F8 C64B  30         mov   r11,*stack            ; Save return address
0019 68FA 0649  14         dect  stack
0020 68FC C644  30         mov   tmp0,*stack           ; Push tmp0
0021 68FE 0649  14         dect  stack
0022 6900 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Command buffer header line
0025                       ;------------------------------------------------------
0026 6902 C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     6904 A71C     
     6906 A000     
0027 6908 0204  20         li    tmp0,67
     690A 0043     
0028 690C C804  38         mov   tmp0,@parm2           ; Set requested length
     690E A002     
0029 6910 0204  20         li    tmp0,1
     6912 0001     
0030 6914 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6916 A004     
0031 6918 0204  20         li    tmp0,rambuf
     691A A140     
0032 691C C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     691E A006     
0033               
0034 6920 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     6922 33B4     
0035                                                   ; \ i  @parm1 = Pointer to string
0036                                                   ; | i  @parm2 = Requested length
0037                                                   ; | i  @parm3 = Fill character
0038                                                   ; | i  @parm4 = Pointer to buffer with
0039                                                   ; /             output string
0040               
0041 6924 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     6926 A70E     
     6928 832A     
0042 692A C160  34         mov   @outparm1,tmp1        ; | Display left part of pane header
     692C A010     
0043 692E 06A0  32         bl    @xutst0               ; /
     6930 2434     
0044               
0045 6932 C120  34         mov   @cmdb.yxtop,tmp0      ; \
     6934 A70E     
0046 6936 0224  22         ai    tmp0,68               ; |
     6938 0044     
0047 693A C804  38         mov   tmp0,@wyx             ; |
     693C 832A     
0048 693E 0205  20         li    tmp1,txt.stevie       ; | Display right part of pane header
     6940 6D08     
0049 6942 06A0  32         bl    @xutst0               ; /
     6944 2434     
0050                       ;------------------------------------------------------
0051                       ; Check dialog id
0052                       ;------------------------------------------------------
0053 6946 04E0  34         clr   @waux1                ; Default is show prompt
     6948 833C     
0054               
0055 694A C120  34         mov   @cmdb.dialog,tmp0
     694C A71A     
0056 694E 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     6950 0063     
0057 6952 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0058 6954 0720  34         seto  @waux1                ; /
     6956 833C     
0059                       ;------------------------------------------------------
0060                       ; Show info message instead of prompt
0061                       ;------------------------------------------------------
0062 6958 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     695A A71E     
0063 695C 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0064               
0065 695E C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     6960 A71E     
     6962 A000     
0066 6964 0204  20         li    tmp0,80
     6966 0050     
0067 6968 C804  38         mov   tmp0,@parm2           ; Set requested length
     696A A002     
0068 696C 0204  20         li    tmp0,32
     696E 0020     
0069 6970 C804  38         mov   tmp0,@parm3           ; Set character to fill
     6972 A004     
0070 6974 0204  20         li    tmp0,rambuf
     6976 A140     
0071 6978 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     697A A006     
0072               
0073 697C 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     697E 33B4     
0074                                                   ; \ i  @parm1 = Pointer to string
0075                                                   ; | i  @parm2 = Requested length
0076                                                   ; | i  @parm3 = Fill character
0077                                                   ; | i  @parm4 = Pointer to buffer with
0078                                                   ; /             output string
0079               
0080 6980 06A0  32         bl    @at
     6982 26E2     
0081 6984 1A00                   byte pane.botrow-3,0  ; Position cursor
0082               
0083 6986 C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     6988 A010     
0084 698A 06A0  32         bl    @xutst0               ; /
     698C 2434     
0085                       ;------------------------------------------------------
0086                       ; Clear lines after prompt in command buffer
0087                       ;------------------------------------------------------
0088               pane.cmdb.draw.clear:
0089 698E 06A0  32         bl    @hchar
     6990 27DC     
0090 6992 1B00                   byte pane.botrow-2,0,32,80
     6994 2050     
0091 6996 FFFF                   data EOL              ; Remove key markers
0092                       ;------------------------------------------------------
0093                       ; Show key markers ?
0094                       ;------------------------------------------------------
0095 6998 C120  34         mov   @cmdb.panmarkers,tmp0
     699A A722     
0096 699C 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0097                       ;------------------------------------------------------
0098                       ; Loop over key marker list
0099                       ;------------------------------------------------------
0100               pane.cmdb.draw.marker.loop:
0101 699E D174  28         movb  *tmp0+,tmp1           ; Get X position
0102 69A0 0985  56         srl   tmp1,8                ; Right align
0103 69A2 0285  22         ci    tmp1,>00ff            ; End of list reached?
     69A4 00FF     
0104 69A6 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0105               
0106 69A8 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     69AA 1B00     
0107                                                   ; y=bottom row - 3, x=(key marker position)
0108 69AC C805  38         mov   tmp1,@wyx             ; Set cursor position
     69AE 832A     
0109               
0110 69B0 0649  14         dect  stack
0111 69B2 C644  30         mov   tmp0,*stack           ; Push tmp0
0112               
0113 69B4 06A0  32         bl    @putstr
     69B6 2432     
0114 69B8 3696                   data txt.keymarker    ; Show key marker
0115               
0116 69BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0117                       ;------------------------------------------------------
0118                       ; Show marker
0119                       ;------------------------------------------------------
0120 69BC 10F0  14         jmp   pane.cmdb.draw.marker.loop
0121                                                   ; Next iteration
0122                       ;------------------------------------------------------
0123                       ; Display pane hint in command buffer
0124                       ;------------------------------------------------------
0125               pane.cmdb.draw.hint:
0126 69BE 0204  20         li    tmp0,pane.botrow - 1  ; \
     69C0 001C     
0127 69C2 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0128 69C4 C804  38         mov   tmp0,@parm1           ; Set parameter
     69C6 A000     
0129 69C8 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     69CA A720     
     69CC A002     
0130               
0131 69CE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     69D0 67E0     
0132                                                   ; \ i  parm1 = Pointer to string with hint
0133                                                   ; / i  parm2 = YX position
0134                       ;------------------------------------------------------
0135                       ; Display keys in status line
0136                       ;------------------------------------------------------
0137 69D2 0204  20         li    tmp0,pane.botrow      ; \
     69D4 001D     
0138 69D6 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0139 69D8 C804  38         mov   tmp0,@parm1           ; Set parameter
     69DA A000     
0140 69DC C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     69DE A724     
     69E0 A002     
0141               
0142 69E2 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     69E4 67E0     
0143                                                   ; \ i  parm1 = Pointer to string with hint
0144                                                   ; / i  parm2 = YX position
0145                       ;------------------------------------------------------
0146                       ; ALPHA-Lock key down?
0147                       ;------------------------------------------------------
0148 69E6 20A0  38         coc   @wbit10,config
     69E8 200C     
0149 69EA 1306  14         jeq   pane.cmdb.draw.alpha.down
0150                       ;------------------------------------------------------
0151                       ; AlPHA-Lock is up
0152                       ;------------------------------------------------------
0153 69EC 06A0  32         bl    @hchar
     69EE 27DC     
0154 69F0 1D4E                   byte pane.botrow,78,32,2
     69F2 2002     
0155 69F4 FFFF                   data eol
0156               
0157 69F6 1004  14         jmp   pane.cmdb.draw.promptcmd
0158                       ;------------------------------------------------------
0159                       ; AlPHA-Lock is down
0160                       ;------------------------------------------------------
0161               pane.cmdb.draw.alpha.down:
0162 69F8 06A0  32         bl    @putat
     69FA 2456     
0163 69FC 1D4E                   byte   pane.botrow,78
0164 69FE 3690                   data   txt.alpha.down
0165                       ;------------------------------------------------------
0166                       ; Command buffer content
0167                       ;------------------------------------------------------
0168               pane.cmdb.draw.promptcmd:
0169 6A00 C120  34         mov   @waux1,tmp0           ; Flag set?
     6A02 833C     
0170 6A04 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0171 6A06 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     6A08 6A12     
0172                       ;------------------------------------------------------
0173                       ; Exit
0174                       ;------------------------------------------------------
0175               pane.cmdb.draw.exit:
0176 6A0A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0177 6A0C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0178 6A0E C2F9  30         mov   *stack+,r11           ; Pop r11
0179 6A10 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.58356
0081                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 6A12 0649  14         dect  stack
0023 6A14 C64B  30         mov   r11,*stack            ; Save return address
0024 6A16 0649  14         dect  stack
0025 6A18 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6A1A 0649  14         dect  stack
0027 6A1C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6A1E 0649  14         dect  stack
0029 6A20 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6A22 0649  14         dect  stack
0031 6A24 C660  46         mov   @wyx,*stack           ; Push cursor position
     6A26 832A     
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 6A28 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6A2A A710     
     6A2C 832A     
0036               
0037 6A2E 05A0  34         inc   @wyx                  ; X +1 for prompt
     6A30 832A     
0038               
0039 6A32 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6A34 240E     
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 6A36 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6A38 A729     
0044 6A3A 0206  20         li    tmp2,1*79             ; Command length
     6A3C 004F     
0045               
0046 6A3E 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6A40 24A0     
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 6A42 C820  54         mov   @cmdb.yxprompt,@wyx
     6A44 A710     
     6A46 832A     
0054 6A48 06A0  32         bl    @putstr
     6A4A 2432     
0055 6A4C 378C                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 6A4E C839  50         mov   *stack+,@wyx          ; Pop cursor position
     6A50 832A     
0061 6A52 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 6A54 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 6A56 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 6A58 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6A5A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0082                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 6A5C 0649  14         dect  stack
0023 6A5E C64B  30         mov   r11,*stack            ; Save return address
0024 6A60 0649  14         dect  stack
0025 6A62 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6A64 0649  14         dect  stack
0027 6A66 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6A68 0649  14         dect  stack
0029 6A6A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6A6C 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6A6E A728     
0034 6A70 06A0  32         bl    @film                 ; Clear command
     6A72 224A     
0035 6A74 A729                   data  cmdb.cmd,>00,80
     6A76 0000     
     6A78 0050     
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 6A7A C120  34         mov   @cmdb.yxprompt,tmp0
     6A7C A710     
0040 6A7E 0584  14         inc   tmp0
0041 6A80 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6A82 A70A     
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 6A84 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6A86 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6A88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6A8A C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6A8C 045B  20         b     *r11                  ; Return to caller
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
0075 6A8E 0649  14         dect  stack
0076 6A90 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 6A92 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6A94 2B9E     
0081 6A96 A729                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6A98 0000     
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 6A9A C820  54         mov   @waux1,@outparm1     ; Save length of string
     6A9C 833C     
     6A9E A010     
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 6AA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6AA2 045B  20         b     *r11                  ; Return to caller
0091               
0092               
0093               
0094               
0095               
0096               ***************************************************************
0097               * cmdb.cmd.history.add
0098               * Add command to history
0099               ***************************************************************
0100               * bl @cmdb.cmd.addhist
0101               *--------------------------------------------------------------
0102               * INPUT
0103               *
0104               * @cmdb.cmd
0105               *--------------------------------------------------------------
0106               * OUTPUT
0107               * @outparm1     (Length in LSB)
0108               *--------------------------------------------------------------
0109               * Register usage
0110               * tmp0
0111               *--------------------------------------------------------------
0112               * Notes
0113               ********|*****|*********************|**************************
0114               cmdb.cmd.history.add:
0115 6AA4 0649  14         dect  stack
0116 6AA6 C64B  30         mov   r11,*stack            ; Save return address
0117 6AA8 0649  14         dect  stack
0118 6AAA C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 6AAC 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6AAE 6A8E     
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Assert
0125                       ;------------------------------------------------------
0126 6AB0 C120  34         mov   @outparm1,tmp0        ; Check length
     6AB2 A010     
0127 6AB4 1300  14         jeq   cmdb.cmd.history.add.exit
0128                                                   ; Exit early if length = 0
0129                       ;------------------------------------------------------
0130                       ; Add command to history
0131                       ;------------------------------------------------------
0132               
0133               
0134               
0135                       ;------------------------------------------------------
0136                       ; Exit
0137                       ;------------------------------------------------------
0138               cmdb.cmd.history.add.exit:
0139 6AB6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 6AB8 C2F9  30         mov   *stack+,r11           ; Pop r11
0141 6ABA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0083                       ;-----------------------------------------------------------------------
0084                       ; Toggle fastmode in Load/Save DV80 dialogs
0085                       ;-----------------------------------------------------------------------
0086                       copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation
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
0017               * tmp0, tmp1
0018               ********|*****|*********************|**************************
0019               fm.fastmode:
0020 6ABC 0649  14         dect  stack
0021 6ABE C64B  30         mov   r11,*stack            ; Save return address
0022 6AC0 0649  14         dect  stack
0023 6AC2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024               
0025 6AC4 C120  34         mov   @fh.offsetopcode,tmp0
     6AC6 A44E     
0026 6AC8 1307  14         jeq   !
0027                       ;------------------------------------------------------
0028                       ; Turn fast mode off
0029                       ;------------------------------------------------------
0030 6ACA 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     6ACC A44E     
0031 6ACE 0204  20         li    tmp0,txt.keys.load
     6AD0 6D66     
0032 6AD2 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6AD4 A724     
0033 6AD6 1008  14         jmp   fm.fastmode.exit
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode on
0036                       ;------------------------------------------------------
0037 6AD8 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     6ADA 0040     
0038 6ADC C804  38         mov   tmp0,@fh.offsetopcode
     6ADE A44E     
0039 6AE0 0204  20         li    tmp0,txt.keys.load2
     6AE2 6D96     
0040 6AE4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6AE6 A724     
0041               *--------------------------------------------------------------
0042               * Exit
0043               *--------------------------------------------------------------
0044               fm.fastmode.exit:
0045 6AE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 6AEA C2F9  30         mov   *stack+,r11           ; Pop R11
0047 6AEC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b3.asm.58356
0087                       ;-----------------------------------------------------------------------
0088                       ; Stubs
0089                       ;-----------------------------------------------------------------------
0090                       copy  "rom.stubs.bank3.asm" ; Stubs for functions in other banks
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
0010 6AEE 0649  14         dect  stack
0011 6AF0 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Call function in bank 1
0014                       ;------------------------------------------------------
0015 6AF2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6AF4 30A4     
0016 6AF6 6002                   data bank1.rom        ; | i  p0 = bank address
0017 6AF8 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0018 6AFA 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 6AFC C2F9  30         mov   *stack+,r11           ; Pop r11
0023 6AFE 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "edkey.action.cmdb.show"
0028               * bank1 vec.15
0029               ********|*****|*********************|**************************
0030               edkey.action.cmdb.show:
0031 6B00 0649  14         dect  stack
0032 6B02 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Call function in bank 1
0035                       ;------------------------------------------------------
0036 6B04 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B06 30A4     
0037 6B08 6002                   data bank1.rom        ; | i  p0 = bank address
0038 6B0A 7FDC                   data vec.15           ; | i  p1 = Vector with target address
0039 6B0C 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0040                       ;------------------------------------------------------
0041                       ; Exit
0042                       ;------------------------------------------------------
0043 6B0E C2F9  30         mov   *stack+,r11           ; Pop r11
0044 6B10 045B  20         b     *r11                  ; Return to caller
0045               
0046               
0047               ***************************************************************
0048               * Stub for "fb.refresh"
0049               * bank1 vec.20
0050               ********|*****|*********************|**************************
0051               fb.refresh:
0052 6B12 0649  14         dect  stack
0053 6B14 C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 6B16 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B18 30A4     
0058 6B1A 6002                   data bank1.rom        ; | i  p0 = bank address
0059 6B1C 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0060 6B1E 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 6B20 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 6B22 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fb.row2line"
0070               * bank1 vec.22
0071               ********|*****|*********************|**************************
0072               fb.row2line:
0073 6B24 0649  14         dect  stack
0074 6B26 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 1
0077                       ;------------------------------------------------------
0078 6B28 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B2A 30A4     
0079 6B2C 6002                   data bank1.rom        ; | i  p0 = bank address
0080 6B2E 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0081 6B30 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 6B32 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6B34 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               ***************************************************************
0090               * Stub for "pane.errline.hide"
0091               * bank1 vec.27
0092               ********|*****|*********************|**************************
0093               pane.errline.hide:
0094 6B36 0649  14         dect  stack
0095 6B38 C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Call function in bank 1
0098                       ;------------------------------------------------------
0099 6B3A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B3C 30A4     
0100 6B3E 6002                   data bank1.rom        ; | i  p0 = bank address
0101 6B40 7FF4                   data vec.27           ; | i  p1 = Vector with target address
0102 6B42 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0103                       ;------------------------------------------------------
0104                       ; Exit
0105                       ;------------------------------------------------------
0106 6B44 C2F9  30         mov   *stack+,r11           ; Pop r11
0107 6B46 045B  20         b     *r11                  ; Return to caller
0108               
0109               
0110               
0111               ***************************************************************
0112               * Stub for "pane.cursor.blink"
0113               * bank1 vec.28
0114               ********|*****|*********************|**************************
0115               pane.cursor.blink:
0116 6B48 0649  14         dect  stack
0117 6B4A C64B  30         mov   r11,*stack            ; Save return address
0118                       ;------------------------------------------------------
0119                       ; Call function in bank 1
0120                       ;------------------------------------------------------
0121 6B4C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B4E 30A4     
0122 6B50 6002                   data bank1.rom        ; | i  p0 = bank address
0123 6B52 7FF6                   data vec.28           ; | i  p1 = Vector with target address
0124 6B54 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0125                       ;------------------------------------------------------
0126                       ; Exit
0127                       ;------------------------------------------------------
0128 6B56 C2F9  30         mov   *stack+,r11           ; Pop r11
0129 6B58 045B  20         b     *r11                  ; Return to caller
0130               
0131               
0132               ***************************************************************
0133               * Stub for "pane.cursor.hide"
0134               * bank1 vec.29
0135               ********|*****|*********************|**************************
0136               pane.cursor.hide:
0137 6B5A 0649  14         dect  stack
0138 6B5C C64B  30         mov   r11,*stack            ; Save return address
0139                       ;------------------------------------------------------
0140                       ; Call function in bank 1
0141                       ;------------------------------------------------------
0142 6B5E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B60 30A4     
0143 6B62 6002                   data bank1.rom        ; | i  p0 = bank address
0144 6B64 7FF8                   data vec.29           ; | i  p1 = Vector with target address
0145 6B66 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0146                       ;------------------------------------------------------
0147                       ; Exit
0148                       ;------------------------------------------------------
0149 6B68 C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6B6A 045B  20         b     *r11                  ; Return to caller
0151               
0152               
0153               ***************************************************************
0154               * Stub for "pane.action.colorscheme.load"
0155               * bank1 vec.31
0156               ********|*****|*********************|**************************
0157               pane.action.colorscheme.load:
0158 6B6C 0649  14         dect  stack
0159 6B6E C64B  30         mov   r11,*stack            ; Save return address
0160                       ;------------------------------------------------------
0161                       ; Call function in bank 1
0162                       ;------------------------------------------------------
0163 6B70 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B72 30A4     
0164 6B74 6002                   data bank1.rom        ; | i  p0 = bank address
0165 6B76 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0166 6B78 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0167                       ;------------------------------------------------------
0168                       ; Exit
0169                       ;------------------------------------------------------
0170 6B7A C2F9  30         mov   *stack+,r11           ; Pop r11
0171 6B7C 045B  20         b     *r11                  ; Return to caller
0172               
0173               
0174               ***************************************************************
0175               
0176               ; TODO Include _trampoline.bank1.ret
0177               ; TODO Refactor stubs for using _trampoline.bank1.ret
                   < stevie_b3.asm.58356
0091                       ;-----------------------------------------------------------------------
0092                       ; Basic interpreter
0093                       ;-----------------------------------------------------------------------
0094                       copy  "tibasic.asm"         ; Run TI Basic session
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
0020 6B7E 0649  14         dect  stack
0021 6B80 C64B  30         mov   r11,*stack            ; Save return address
0022 6B82 0649  14         dect  stack
0023 6B84 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B86 0649  14         dect  stack
0025 6B88 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;-------------------------------------------------------
0027                       ; Setup SAMS memory
0028                       ;-------------------------------------------------------
0029 6B8A 06A0  32         bl    @sams.layout.copy     ; Backup Stevie SAMS page layout
     6B8C 265A     
0030 6B8E A200                   data tv.sams.2000     ; \ @i = target address of 8 words table
0031                                                   ; /      that contains SAMS layout
0032               
0033               
0034 6B90 06A0  32         bl    @scroff               ; Turn off screen
     6B92 26A2     
0035               
0036 6B94 06A0  32         bl    @sams.layout
     6B96 25F6     
0037 6B98 34A4                   data mem.sams.external
0038                                                   ; Load SAMS page layout for calling an
0039                                                   ; external program.
0040               
0041 6B9A 06A0  32         bl    @cpyv2m
     6B9C 24CC     
0042 6B9E 0000                   data >0000,>b000,16384
     6BA0 B000     
     6BA2 4000     
0043                                                   ; Copy Stevie 16K VDP memory to RAM buffer
0044                                                   ; buffer >b000->efff
0045               
0046 6BA4 06A0  32         bl    @sams.layout
     6BA6 25F6     
0047 6BA8 34C4                   data mem.sams.tibasic ; Load SAMS page layout for TI Basic
0048                       ;-------------------------------------------------------
0049                       ; Put VDP in TI Basic compatible mode (32x24)
0050                       ;-------------------------------------------------------
0051 6BAA 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6BAC 27B0     
0052               
0053 6BAE 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6BB0 230C     
0054 6BB2 3462                   data tibasic.32x24    ; Equate selected video mode table
0055                       ;-------------------------------------------------------
0056                       ; Resume existing TI Basic session?
0057                       ;-------------------------------------------------------
0058 6BB4 C820  54         mov   @tibasic.status,@tibasic.status
     6BB6 A02C     
     6BB8 A02C     
0059                                                   ; New TI-Basic session?
0060 6BBA 152E  14         jgt   tibasic.resume        ; No, resume existing session
0061                       ;-------------------------------------------------------
0062                       ; New TI Basic session
0063                       ;-------------------------------------------------------
0064               tibasic.init:
0065 6BBC 06A0  32         bl    @cpym2m
     6BBE 24EE     
0066 6BC0 7E00                   data cpu.scrpad.src,cpu.scrpad.tgt,256
     6BC2 F960     
     6BC4 0100     
0067                                                   ; Initialize TI Basic scrpad memory in
0068                                                   ; @cpu.scrpad.tgt (SAMS bank #08) with dump
0069                                                   ; of OS Monitor scrpad stored at
0070                                                   ; @cpu.scrpad.src (bank 3).
0071               
0072 6BC6 06A0  32         bl    @ldfnt
     6BC8 2374     
0073 6BCA 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     6BCC 000C     
0074               
0075 6BCE 06A0  32         bl    @filv
     6BD0 22A2     
0076 6BD2 0300                   data >0300,>D0,2      ; No sprites
     6BD4 00D0     
     6BD6 0002     
0077               
0078 6BD8 06A0  32         bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to
     6BDA 2C56     
0079 6BDC AD00                   data scrpad.copy      ; | >ad00 and then load TI Basic scrpad from
0080                                                   ; / predefined address @cpu.scrpad.target
0081               
0082 6BDE 04CB  14         clr   r11
0083 6BE0 C820  54         mov   @tibasic.scrpad.83d4,@>83d4
     6BE2 6C2C     
     6BE4 83D4     
0084 6BE6 C820  54         mov   @tibasic.scrpad.83fa,@>83fa
     6BE8 6C2E     
     6BEA 83FA     
0085 6BEC C820  54         mov   @tibasic.scrpad.83fc,@>83fc
     6BEE 6C30     
     6BF0 83FC     
0086 6BF2 C820  54         mov   @tibasic.scrpad.83fe,@>83fe
     6BF4 6C32     
     6BF6 83FE     
0087                       ;-------------------------------------------------------
0088                       ; Register ISR hook
0089                       ;-------------------------------------------------------
0090 6BF8 0201  20         li    r1,isr                ; \
     6BFA 6C34     
0091 6BFC C801  38         mov   r1,@>83c4             ; | >83c4 = Pointer to start address of ISR
     6BFE 83C4     
0092                                                   ; /
0093                       ;-------------------------------------------------------
0094                       ; Run TI Basic session in GPL Interpreter
0095                       ;-------------------------------------------------------
0096 6C00 02E0  18         lwpi  >83e0
     6C02 83E0     
0097 6C04 0201  20         li    r1,>216f              ; Entrypoint for GPL TI Basic interpreter
     6C06 216F     
0098 6C08 D801  38         movb  r1,@grmwa             ; \
     6C0A 9C02     
0099 6C0C 06C1  14         swpb  r1                    ; | Set GPL address
0100 6C0E D801  38         movb  r1,@grmwa             ; /
     6C10 9C02     
0101 6C12 1000  14         nop
0102 6C14 0460  28         b     @>70                  ; Start GPL interpreter
     6C16 0070     
0103                       ;-------------------------------------------------------
0104                       ; Resume existing TI-Basic session
0105                       ;-------------------------------------------------------
0106               tibasic.resume:
0107 6C18 06A0  32         bl    @cpym2v
     6C1A 249A     
0108 6C1C 0000                   data >0000,>b000,16384
     6C1E B000     
     6C20 4000     
0109                                                   ; Restore TI Basic 16K VDP memory from
0110                                                   ; RAM buffer >b000->efff (SAMS pages #04-07)
0111               
0112 6C22 06A0  32         bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to
     6C24 2C56     
0113 6C26 AD00                   data scrpad.copy      ; | >ad00 and then load TI Basic scrpad from
0114                                                   ; / predefined address @cpu.scrpad.target
0115               
0116 6C28 0460  28         b     @>0ab8                ; Return from interrupt routine.
     6C2A 0AB8     
0117                                                   ; See TI Intern page 32 (german)
0118                       ;-------------------------------------------------------
0119                       ; Required values for scratchpad
0120                       ;-------------------------------------------------------
0121               tibasic.scrpad.83d4:
0122 6C2C E0D5             data  >e0d5
0123               tibasic.scrpad.83fa:
0124 6C2E 9800             data  >9800
0125               tibasic.scrpad.83fc:
0126 6C30 0108             data  >0108
0127               tibasic.scrpad.83fe:
0128 6C32 8C02             data  >8c02
0129               
0130               
0131               
0132               ***************************************************************
0133               * isr
0134               * Interrupt Service Routine in TI Basic
0135               ***************************************************************
0136               * Called from console rom at >0ab6
0137               * See TI Intern page 32 (german) for details
0138               *--------------------------------------------------------------
0139               * OUTPUT
0140               * none
0141               *--------------------------------------------------------------
0142               * Register usage
0143               * r7, 12
0144               ********|*****|*********************|**************************
0145               isr:
0146 6C34 0300  24         limi  0                     ; \ Turn off interrupts
     6C36 0000     
0147                                                   ; / Prevent ISR reentry
0148               
0149 6C38 C807  38         mov   r7,@rambuf            ; Backup R7
     6C3A A140     
0150 6C3C C80C  38         mov   r12,@rambuf+2         ; Backup R12
     6C3E A142     
0151                       ;-------------------------------------------------------
0152                       ; Hotkey pressed?
0153                       ;-------------------------------------------------------
0154 6C40 C1E0  34         mov   @>8374,r7             ; Get keyboard scancode
     6C42 8374     
0155 6C44 0247  22         andi  r7,>00ff              ; LSB only
     6C46 00FF     
0156 6C48 0287  22         ci    r7,>0f                ; Hotkey fctn + '9' pressed?
     6C4A 000F     
0157 6C4C 1305  14         jeq   tibasic.return        ; Yes, return to Stevie
0158                       ;-------------------------------------------------------
0159                       ; Return from ISR
0160                       ;-------------------------------------------------------
0161               isr.exit:
0162 6C4E C320  34         mov   @rambuf+2,r12         ; Restore R12
     6C50 A142     
0163 6C52 C1E0  34         mov   @rambuf,r7            ; Restore R7
     6C54 A140     
0164 6C56 045B  20         b     *r11                  ; Return from ISR
0165               
0166               
0167               
0168               ***************************************************************
0169               * tibasic.return
0170               * Return from TI Basic to Stevie
0171               ***************************************************************
0172               * bl   @tibasic.return
0173               *--------------------------------------------------------------
0174               * OUTPUT
0175               * none
0176               *--------------------------------------------------------------
0177               * Register usage
0178               * r1 in GPL WS, tmp0, tmp1
0179               *--------------------------------------------------------------
0180               * REMARKS
0181               * Called from ISR code
0182               ********|*****|*********************|**************************
0183               tibasic.return:
0184 6C58 02E0  18         lwpi  >ad00                 ; Activate Stevie workspace in core RAM 2
     6C5A AD00     
0185               
0186               
0187 6C5C D820  54         movb  @w$ffff,@>8375        ; Reset keycode
     6C5E 2022     
     6C60 8375     
0188               
0189 6C62 06A0  32         bl    @cpym2m
     6C64 24EE     
0190 6C66 8300                   data >8300,cpu.scrpad.tgt,256
     6C68 F960     
     6C6A 0100     
0191                                                   ; Backup TI Basic scratchpad to
0192                                                   ; @cpu.scrpad.tgt (SAMS bank #08)
0193               
0194 6C6C 06A0  32         bl    @cpu.scrpad.pgin      ; Page in copy of Stevie scratch pad memory
     6C6E 2C94     
0195 6C70 AD00                   data scrpad.copy      ; and activate workspace at >8300
0196               
0197 6C72 06A0  32         bl    @mute                 ; Mute sound generators
     6C74 2804     
0198                       ;-------------------------------------------------------
0199                       ; Cleanup after return from TI Basic
0200                       ;-------------------------------------------------------
0201 6C76 06A0  32         bl    @scroff               ; Turn screen off
     6C78 26A2     
0202 6C7A 06A0  32         bl    @cpyv2m
     6C7C 24CC     
0203 6C7E 0000                   data >0000,>b000,16384
     6C80 B000     
     6C82 4000     
0204                                                   ; Dump TI Basic 16K VDP memory to ram buffer
0205                                                   ; >b000->efff
0206               
0207 6C84 C160  34         mov   @tibasic.status,tmp1  ; \
     6C86 A02C     
0208 6C88 0265  22         ori   tmp1,1                ; | Set TI Basic reentry flag
     6C8A 0001     
0209 6C8C C805  38         mov   tmp1,@tibasic.status  ; /
     6C8E A02C     
0210               
0211               
0212 6C90 06A0  32         bl    @sams.layout
     6C92 25F6     
0213 6C94 34A4                   data mem.sams.external
0214                                                   ; Load SAMS page layout for returning from
0215                                                   ; external program.
0216               
0217 6C96 06A0  32         bl    @cpym2v
     6C98 249A     
0218 6C9A 0000                   data >0000,>b000,16384
     6C9C B000     
     6C9E 4000     
0219                                                   ; Restore Stevie 16K to VDP from RAM buffer
0220                                                   ; >b000->efff
0221                       ;-------------------------------------------------------
0222                       ; Restore SAMS memory layout for Stevie
0223                       ;-------------------------------------------------------
0224 6CA0 C120  34         mov   @tv.sams.b000,tmp0
     6CA2 A206     
0225 6CA4 0205  20         li    tmp1,>b000
     6CA6 B000     
0226 6CA8 06A0  32         bl    @xsams.page.set       ; Set sams page for address >b000
     6CAA 258A     
0227               
0228 6CAC C120  34         mov   @tv.sams.c000,tmp0
     6CAE A208     
0229 6CB0 0205  20         li    tmp1,>c000
     6CB2 C000     
0230 6CB4 06A0  32         bl    @xsams.page.set       ; Set sams page for address >c000
     6CB6 258A     
0231               
0232 6CB8 C120  34         mov   @tv.sams.d000,tmp0
     6CBA A20A     
0233 6CBC 0205  20         li    tmp1,>d000
     6CBE D000     
0234 6CC0 06A0  32         bl    @xsams.page.set       ; Set sams page for address >d000
     6CC2 258A     
0235               
0236 6CC4 C120  34         mov   @tv.sams.e000,tmp0
     6CC6 A20C     
0237 6CC8 0205  20         li    tmp1,>e000
     6CCA E000     
0238 6CCC 06A0  32         bl    @xsams.page.set       ; Set sams page for address >e000
     6CCE 258A     
0239               
0240 6CD0 C120  34         mov   @tv.sams.f000,tmp0
     6CD2 A20E     
0241 6CD4 0205  20         li    tmp1,>f000
     6CD6 F000     
0242 6CD8 06A0  32         bl    @xsams.page.set       ; Set sams page for address >f000
     6CDA 258A     
0243                       ;-------------------------------------------------------
0244                       ; Setup F18a 80x30 mode again
0245                       ;-------------------------------------------------------
0246 6CDC 06A0  32         bl    @f18unl               ; Unlock the F18a
     6CDE 2746     
0248               
0249 6CE0 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6CE2 2346     
0250 6CE4 3140                   data >3140            ; F18a VR49 (>31), bit 40
0251               
0253               
0254 6CE6 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6CE8 230C     
0255 6CEA 3458                   data stevie.80x30     ; Equate selected video mode table
0256               
0257 6CEC 06A0  32         bl    @putvr                ; Turn on position based attributes
     6CEE 2346     
0258 6CF0 3202                   data >3202            ; F18a VR50 (>32), bit 2
0259               
0260 6CF2 06A0  32         bl    @putvr                ; Set VDP TAT base address for position
     6CF4 2346     
0261 6CF6 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0262               
0263 6CF8 04E0  34         clr   @parm1                ; Screen off while reloading color scheme
     6CFA A000     
0264 6CFC 06A0  32         bl    @pane.action.colorscheme.load
     6CFE 6B6C     
0265                                                   ; Reload color scheme
0266                                                   ; i  parm1 = Skip screen off if >FFFF
0267                       ;------------------------------------------------------
0268                       ; Exit
0269                       ;------------------------------------------------------
0270               tibasic.return.exit:
0271 6D00 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 6D02 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6D04 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6D06 045B  20         b     *r11                  ; Return
                   < stevie_b3.asm.58356
0095                       ;-----------------------------------------------------------------------
0096                       ; Data
0097                       ;-----------------------------------------------------------------------
0098                       copy  "data.strings.bank3.asm" ; Strings used in bank 3
     **** ****     > data.strings.bank3.asm
0001               * FILE......: data.strings.bank3.asm
0002               * Purpose...: Strings used in Stevie bank 3
0003               
0004               
0005               ***************************************************************
0006               *                       Strings
0007               ***************************************************************
0008               
0009               txt.stevie
0010 6D08 0B               byte  11
0011 6D09   53             text  'Stevie 1.2E'
     6D0A 7465     
     6D0C 7669     
     6D0E 6520     
     6D10 312E     
     6D12 3245     
0012                       even
0013               
0014               
0015               ;--------------------------------------------------------------
0016               ; Dialog Load DV 80 file
0017               ;--------------------------------------------------------------
0018 6D14 1301     txt.head.load      byte 19,1,1
     6D16 01       
0019 6D17   20                        text ' Open DV80 file '
     6D18 4F70     
     6D1A 656E     
     6D1C 2044     
     6D1E 5638     
     6D20 3020     
     6D22 6669     
     6D24 6C65     
     6D26 20       
0020 6D27   01                        byte 1
0021               txt.hint.load
0022 6D28 3D               byte  61
0023 6D29   53             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
     6D2A 656C     
     6D2C 6563     
     6D2E 7420     
     6D30 4661     
     6D32 7374     
     6D34 6D6F     
     6D36 6465     
     6D38 2066     
     6D3A 6F72     
     6D3C 2066     
     6D3E 696C     
     6D40 6520     
     6D42 6275     
     6D44 6666     
     6D46 6572     
     6D48 2069     
     6D4A 6E20     
     6D4C 4350     
     6D4E 5520     
     6D50 5241     
     6D52 4D20     
     6D54 2848     
     6D56 5244     
     6D58 2F48     
     6D5A 4458     
     6D5C 2F49     
     6D5E 4445     
     6D60 206F     
     6D62 6E6C     
     6D64 7929     
0024                       even
0025               
0026               
0027               txt.keys.load
0028 6D66 2F               byte  47
0029 6D67   46             text  'F9-Back  F3-Clear  F5-Fastmode  FH-Home  FL-End'
     6D68 392D     
     6D6A 4261     
     6D6C 636B     
     6D6E 2020     
     6D70 4633     
     6D72 2D43     
     6D74 6C65     
     6D76 6172     
     6D78 2020     
     6D7A 4635     
     6D7C 2D46     
     6D7E 6173     
     6D80 746D     
     6D82 6F64     
     6D84 6520     
     6D86 2046     
     6D88 482D     
     6D8A 486F     
     6D8C 6D65     
     6D8E 2020     
     6D90 464C     
     6D92 2D45     
     6D94 6E64     
0030                       even
0031               
0032               txt.keys.load2
0033 6D96 30               byte  48
0034 6D97   46             text  'F9-Back  F3-Clear  *F5-Fastmode  FH-Home  FL-End'
     6D98 392D     
     6D9A 4261     
     6D9C 636B     
     6D9E 2020     
     6DA0 4633     
     6DA2 2D43     
     6DA4 6C65     
     6DA6 6172     
     6DA8 2020     
     6DAA 2A46     
     6DAC 352D     
     6DAE 4661     
     6DB0 7374     
     6DB2 6D6F     
     6DB4 6465     
     6DB6 2020     
     6DB8 4648     
     6DBA 2D48     
     6DBC 6F6D     
     6DBE 6520     
     6DC0 2046     
     6DC2 4C2D     
     6DC4 456E     
     6DC6 64       
0035                       even
0036               
0037               
0038               ;--------------------------------------------------------------
0039               ; Dialog Save DV 80 file
0040               ;--------------------------------------------------------------
0041 6DC8 1301     txt.head.save      byte 19,1,1
     6DCA 01       
0042 6DCB   20                        text ' Save DV80 file '
     6DCC 5361     
     6DCE 7665     
     6DD0 2044     
     6DD2 5638     
     6DD4 3020     
     6DD6 6669     
     6DD8 6C65     
     6DDA 20       
0043 6DDB   01                        byte 1
0044 6DDC 2301     txt.head.save2     byte 35,1,3,32
     6DDE 0320     
0045 6DE0 5361                        text 'Save marked block to DV80 file '
     6DE2 7665     
     6DE4 206D     
     6DE6 6172     
     6DE8 6B65     
     6DEA 6420     
     6DEC 626C     
     6DEE 6F63     
     6DF0 6B20     
     6DF2 746F     
     6DF4 2044     
     6DF6 5638     
     6DF8 3020     
     6DFA 6669     
     6DFC 6C65     
     6DFE 20       
0046 6DFF   02                        byte 2
0047               txt.hint.save
0048 6E00 01               byte  1
0049 6E01   20             text  ' '
0050                       even
0051               
0052               txt.keys.save
0053 6E02 22               byte  34
0054 6E03   46             text  'F9-Back  F3-Clear  FH-Home  FL-End'
     6E04 392D     
     6E06 4261     
     6E08 636B     
     6E0A 2020     
     6E0C 4633     
     6E0E 2D43     
     6E10 6C65     
     6E12 6172     
     6E14 2020     
     6E16 4648     
     6E18 2D48     
     6E1A 6F6D     
     6E1C 6520     
     6E1E 2046     
     6E20 4C2D     
     6E22 456E     
     6E24 64       
0055                       even
0056               
0057               
0058               
0059               ;--------------------------------------------------------------
0060               ; Insert DV 80 file
0061               ;--------------------------------------------------------------
0062 6E26 1D01     txt.head.insert    byte 29,1,1
     6E28 01       
0063 6E29   20                        text ' Insert DV80 file at line '
     6E2A 496E     
     6E2C 7365     
     6E2E 7274     
     6E30 2044     
     6E32 5638     
     6E34 3020     
     6E36 6669     
     6E38 6C65     
     6E3A 2061     
     6E3C 7420     
     6E3E 6C69     
     6E40 6E65     
     6E42 20       
0064 6E43   01                        byte 1
0065               txt.hint.insert
0066 6E44 3D               byte  61
0067 6E45   53             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
     6E46 656C     
     6E48 6563     
     6E4A 7420     
     6E4C 4661     
     6E4E 7374     
     6E50 6D6F     
     6E52 6465     
     6E54 2066     
     6E56 6F72     
     6E58 2066     
     6E5A 696C     
     6E5C 6520     
     6E5E 6275     
     6E60 6666     
     6E62 6572     
     6E64 2069     
     6E66 6E20     
     6E68 4350     
     6E6A 5520     
     6E6C 5241     
     6E6E 4D20     
     6E70 2848     
     6E72 5244     
     6E74 2F48     
     6E76 4458     
     6E78 2F49     
     6E7A 4445     
     6E7C 206F     
     6E7E 6E6C     
     6E80 7929     
0068                       even
0069               
0070               
0071               txt.keys.insert
0072 6E82 2F               byte  47
0073 6E83   46             text  'F9-Back  F3-Clear  F5-Fastmode  FH-Home  FL-End'
     6E84 392D     
     6E86 4261     
     6E88 636B     
     6E8A 2020     
     6E8C 4633     
     6E8E 2D43     
     6E90 6C65     
     6E92 6172     
     6E94 2020     
     6E96 4635     
     6E98 2D46     
     6E9A 6173     
     6E9C 746D     
     6E9E 6F64     
     6EA0 6520     
     6EA2 2046     
     6EA4 482D     
     6EA6 486F     
     6EA8 6D65     
     6EAA 2020     
     6EAC 464C     
     6EAE 2D45     
     6EB0 6E64     
0074                       even
0075               
0076               txt.keys.insert2
0077 6EB2 30               byte  48
0078 6EB3   46             text  'F9-Back  F3-Clear  *F5-Fastmode  FH-Home  FL-End'
     6EB4 392D     
     6EB6 4261     
     6EB8 636B     
     6EBA 2020     
     6EBC 4633     
     6EBE 2D43     
     6EC0 6C65     
     6EC2 6172     
     6EC4 2020     
     6EC6 2A46     
     6EC8 352D     
     6ECA 4661     
     6ECC 7374     
     6ECE 6D6F     
     6ED0 6465     
     6ED2 2020     
     6ED4 4648     
     6ED6 2D48     
     6ED8 6F6D     
     6EDA 6520     
     6EDC 2046     
     6EDE 4C2D     
     6EE0 456E     
     6EE2 64       
0079                       even
0080               
0081               
0082               
0083               ;--------------------------------------------------------------
0084               ; Dialog "Unsaved changes"
0085               ;--------------------------------------------------------------
0086 6EE4 1401     txt.head.unsaved   byte 20,1,1
     6EE6 01       
0087 6EE7   20                        text ' Unsaved changes '
     6EE8 556E     
     6EEA 7361     
     6EEC 7665     
     6EEE 6420     
     6EF0 6368     
     6EF2 616E     
     6EF4 6765     
     6EF6 7320     
0088 6EF8 01                          byte 1
0089               txt.info.unsaved
0090 6EF9   21             byte  33
0091 6EFA 5761             text  'Warning! Unsaved changes in file.'
     6EFC 726E     
     6EFE 696E     
     6F00 6721     
     6F02 2055     
     6F04 6E73     
     6F06 6176     
     6F08 6564     
     6F0A 2063     
     6F0C 6861     
     6F0E 6E67     
     6F10 6573     
     6F12 2069     
     6F14 6E20     
     6F16 6669     
     6F18 6C65     
     6F1A 2E       
0092                       even
0093               
0094               txt.hint.unsaved
0095 6F1C 2A               byte  42
0096 6F1D   50             text  'Press F6 to proceed or ENTER to save file.'
     6F1E 7265     
     6F20 7373     
     6F22 2046     
     6F24 3620     
     6F26 746F     
     6F28 2070     
     6F2A 726F     
     6F2C 6365     
     6F2E 6564     
     6F30 206F     
     6F32 7220     
     6F34 454E     
     6F36 5445     
     6F38 5220     
     6F3A 746F     
     6F3C 2073     
     6F3E 6176     
     6F40 6520     
     6F42 6669     
     6F44 6C65     
     6F46 2E       
0097                       even
0098               
0099               txt.keys.unsaved
0100 6F48 13               byte  19
0101 6F49   46             text  'F9-Back  F6-Proceed'
     6F4A 392D     
     6F4C 4261     
     6F4E 636B     
     6F50 2020     
     6F52 4636     
     6F54 2D50     
     6F56 726F     
     6F58 6365     
     6F5A 6564     
0102                       even
0103               
0104               
0105               ;--------------------------------------------------------------
0106               ; Dialog "Help"
0107               ;--------------------------------------------------------------
0108 6F5C 0901     txt.head.about     byte 9,1,1
     6F5E 01       
0109 6F5F   20                        text ' Help '
     6F60 4865     
     6F62 6C70     
     6F64 20       
0110 6F65   01                        byte 1
0111               
0112               txt.info.about
0113 6F66 02               byte  2
0114 6F67   00             text  ''
0115                       even
0116               
0117               txt.hint.about
0118 6F68 1D               byte  29
0119 6F69   50             text  'Press F9 to return to editor.'
     6F6A 7265     
     6F6C 7373     
     6F6E 2046     
     6F70 3920     
     6F72 746F     
     6F74 2072     
     6F76 6574     
     6F78 7572     
     6F7A 6E20     
     6F7C 746F     
     6F7E 2065     
     6F80 6469     
     6F82 746F     
     6F84 722E     
0120                       even
0121               
0122 6F86 1B       txt.keys.about     byte 27
0123 6F87   46                        text 'F9-Back  '
     6F88 392D     
     6F8A 4261     
     6F8C 636B     
     6F8E 2020     
0124 6F90 0E0F                        byte 14,15
0125 6F92 2D41                        text '-Alpha Lock down'
     6F94 6C70     
     6F96 6861     
     6F98 204C     
     6F9A 6F63     
     6F9C 6B20     
     6F9E 646F     
     6FA0 776E     
0126               
0127               txt.about.build
0128 6FA2 4C               byte  76
0129 6FA3   42             text  'Build: 211111-2049270 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
     6FA4 7569     
     6FA6 6C64     
     6FA8 3A20     
     6FAA 3231     
     6FAC 3131     
     6FAE 3131     
     6FB0 2D32     
     6FB2 3034     
     6FB4 3932     
     6FB6 3730     
     6FB8 202F     
     6FBA 2032     
     6FBC 3031     
     6FBE 382D     
     6FC0 3230     
     6FC2 3231     
     6FC4 2046     
     6FC6 696C     
     6FC8 6970     
     6FCA 2056     
     6FCC 616E     
     6FCE 2056     
     6FD0 6F6F     
     6FD2 7265     
     6FD4 6E20     
     6FD6 2F20     
     6FD8 7265     
     6FDA 7472     
     6FDC 6F63     
     6FDE 6C6F     
     6FE0 7564     
     6FE2 7320     
     6FE4 6F6E     
     6FE6 2041     
     6FE8 7461     
     6FEA 7269     
     6FEC 6167     
     6FEE 65       
0130                       even
0131               
0132               
0133               
0134               ;--------------------------------------------------------------
0135               ; Dialog "Menu"
0136               ;--------------------------------------------------------------
0137 6FF0 0E01     txt.head.menu      byte 14,1,1
     6FF2 01       
0138 6FF3   20                        text ' Main Menu '
     6FF4 4D61     
     6FF6 696E     
     6FF8 204D     
     6FFA 656E     
     6FFC 7520     
0139 6FFE 01                          byte 1
0140               
0141               txt.info.menu
0142 6FFF   1A             byte  26
0143 7000 4669             text  'File   Basic   Help   Quit'
     7002 6C65     
     7004 2020     
     7006 2042     
     7008 6173     
     700A 6963     
     700C 2020     
     700E 2048     
     7010 656C     
     7012 7020     
     7014 2020     
     7016 5175     
     7018 6974     
0144                       even
0145               
0146 701A 0007     pos.info.menu      byte 0,7,15,22,>ff
     701C 0F16     
     701E FF       
0147               txt.hint.menu
0148 701F   01             byte  1
0149 7020 20               text  ' '
0150                       even
0151               
0152               txt.keys.menu
0153 7022 07               byte  7
0154 7023   46             text  'F9-Back'
     7024 392D     
     7026 4261     
     7028 636B     
0155                       even
0156               
0157               
0158               
0159               ;--------------------------------------------------------------
0160               ; Dialog "File"
0161               ;--------------------------------------------------------------
0162 702A 0901     txt.head.file      byte 9,1,1
     702C 01       
0163 702D   20                        text ' File '
     702E 4669     
     7030 6C65     
     7032 20       
0164 7033   01                        byte 1
0165               
0166               ;txt.info.file
0167 7034 22               byte  34
0168 7035   4E             text  'New   Open   Save   Print   Insert'
     7036 6577     
     7038 2020     
     703A 204F     
     703C 7065     
     703E 6E20     
     7040 2020     
     7042 5361     
     7044 7665     
     7046 2020     
     7048 2050     
     704A 7269     
     704C 6E74     
     704E 2020     
     7050 2049     
     7052 6E73     
     7054 6572     
     7056 74       
0169                       even
0170               
0171               ;pos.info.file      byte 0,6,13,20,28,>ff
0172               
0173               txt.info.file
0174 7058 22               byte  34
0175 7059   4E             text  'New   Open / Insert   Save   Print'
     705A 6577     
     705C 2020     
     705E 204F     
     7060 7065     
     7062 6E20     
     7064 2F20     
     7066 496E     
     7068 7365     
     706A 7274     
     706C 2020     
     706E 2053     
     7070 6176     
     7072 6520     
     7074 2020     
     7076 5072     
     7078 696E     
     707A 74       
0176                       even
0177               
0178 707C 0006     pos.info.file      byte 0,6,13,22,29,>ff
     707E 0D16     
     7080 1DFF     
0179               txt.hint.file
0180 7082 01               byte  1
0181 7083   20             text  ' '
0182                       even
0183               
0184               txt.keys.file
0185 7084 07               byte  7
0186 7085   46             text  'F9-Back'
     7086 392D     
     7088 4261     
     708A 636B     
0187                       even
0188               
0189               
0190               ;--------------------------------------------------------------
0191               ; Dialog "Basic"
0192               ;--------------------------------------------------------------
0193 708C 0E01     txt.head.basic     byte 14,1,1
     708E 01       
0194 708F   20                        text ' Run basic '
     7090 5275     
     7092 6E20     
     7094 6261     
     7096 7369     
     7098 6320     
0195 709A 01                          byte 1
0196               
0197               txt.info.basic
0198 709B   1C             byte  28
0199 709C 5449             text  'TI Basic   TI Extended Basic'
     709E 2042     
     70A0 6173     
     70A2 6963     
     70A4 2020     
     70A6 2054     
     70A8 4920     
     70AA 4578     
     70AC 7465     
     70AE 6E64     
     70B0 6564     
     70B2 2042     
     70B4 6173     
     70B6 6963     
0200                       even
0201               
0202 70B8 030E     pos.info.basic     byte 3,14,>ff
     70BA FF       
0203               txt.hint.basic
0204 70BB   01             byte  1
0205 70BC 20               text  ' '
0206                       even
0207               
0208               txt.keys.basic
0209 70BE 07               byte  7
0210 70BF   46             text  'F9-Back'
     70C0 392D     
     70C2 4261     
     70C4 636B     
0211                       even
0212               
                   < stevie_b3.asm.58356
0099                       ;-----------------------------------------------------------------------
0100                       ; Bank full check
0101                       ;-----------------------------------------------------------------------
0105                       ;-----------------------------------------------------------------------
0106                       ; Show ROM bank in CPU crash screen
0107                       ;-----------------------------------------------------------------------
0108               cpu.crash.showbank:
0109                       aorg >7fb0
0110 7FB0 06A0  32         bl    @putat
     7FB2 2456     
0111 7FB4 0314                   byte 3,20
0112 7FB6 7FBA                   data cpu.crash.showbank.bankstr
0113 7FB8 10FF  14         jmp   $
0114               cpu.crash.showbank.bankstr:
0115               
0116 7FBA 0D               byte  13
0117 7FBB   52             text  'ROM#3'
     7FBC 4F4D     
     7FBE 2333     
0118                       even
0119               
0120                       ;-----------------------------------------------------------------------
0121                       ; Scratchpad memory dump
0122                       ;-----------------------------------------------------------------------
0123                       aorg >7e00
0124                       copy  "data.scrpad.asm"     ; Required for TI Basic
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
                   < stevie_b3.asm.58356
0125                       ;-----------------------------------------------------------------------
0126                       ; Vector table
0127                       ;-----------------------------------------------------------------------
0128                       aorg  >7fc0
0129                       copy  "rom.vectors.bank3.asm"
     **** ****     > rom.vectors.bank3.asm
0001               * FILE......: rom.vectors.bank3.asm
0002               * Purpose...: Bank 3 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 608C     vec.1   data  dialog.help           ; Dialog "About"
0008 7FC2 661A     vec.2   data  dialog.load           ; Dialog "Load DV80 file"
0009 7FC4 6672     vec.3   data  dialog.save           ; Dialog "Save DV80 file"
0010 7FC6 66DA     vec.4   data  dialog.insert         ; Dialog "Insert DV80 file"
0011 7FC8 65D8     vec.5   data  dialog.file           ; Dialog "File"
0012 7FCA 6760     vec.6   data  dialog.unsaved        ; Dialog "Unsaved changes"
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 6B7E     vec.10  data  tibasic               ; Run TI Basic interpreter
0017 7FD4 2026     vec.11  data  cpu.crash             ;
0018 7FD6 2026     vec.12  data  cpu.crash             ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 2026     vec.15  data  cpu.crash             ;
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 6836     vec.18  data  pane.show_hint        ; Show or hide hint
0025 7FE4 67E0     vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
0026 7FE6 684A     vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
0027 7FE8 689A     vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
0028 7FEA 68F6     vec.22  data  pane.cmdb.draw        ; Draw content in command
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 6A12     vec.24  data  cmdb.refresh          ;
0031 7FF0 6A5C     vec.25  data  cmdb.cmd.clear        ;
0032 7FF2 6A8E     vec.26  data  cmdb.cmd.getlength    ;
0033 7FF4 6AA4     vec.27  data  cmdb.cmd.history.add  ;
0034 7FF6 2026     vec.28  data  cpu.crash             ;
0035 7FF8 2026     vec.29  data  cpu.crash             ;
0036 7FFA 604A     vec.30  data  dialog.menu           ; Dialog "Main Menu"
0037 7FFC 2026     vec.31  data  cpu.crash             ;
0038 7FFE 6ABC     vec.32  data  fm.fastmode           ; Toggle fastmode on/off in Load dialog
                   < stevie_b3.asm.58356
0130                                                   ; Vector table bank 3
0131               
0132               
0133               *--------------------------------------------------------------
0134               * Video mode configuration
0135               *--------------------------------------------------------------
0136      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0137      0004     spfbck  equ   >04                   ; Screen background color.
0138      3458     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0139      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0140      0050     colrow  equ   80                    ; Columns per row
0141      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0142      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0143      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0144      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

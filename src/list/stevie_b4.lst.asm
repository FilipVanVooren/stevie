XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b4.asm.9883
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b4.asm               ; Version 211012-9883
0010               *
0011               * Bank 4 "Janine"
0012               * Framebuffer handling
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
                   < stevie_b4.asm.9883
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
                   < stevie_b4.asm.9883
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
0087      0064     id.dialog.menu            equ  100     ; "Stevie Menu"
0088      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0089      0066     id.dialog.block           equ  102     ; "Block move/copy/delete"
0090      0067     id.dialog.help           equ  103     ; "About"
0091      0068     id.dialog.file            equ  104     ; "File"
0092      0069     id.dialog.basic           equ  105     ; "Basic"
0093               *--------------------------------------------------------------
0094               * Stevie specific equates
0095               *--------------------------------------------------------------
0096      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0097      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0098      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0099      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0100      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0101      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0102                                                      ; VDP TAT address of 1st CMDB row
0103      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0104      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0105                                                      ; VDP SIT size 80 columns, 24/30 rows
0106      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0107      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0108               *--------------------------------------------------------------
0109               * SPECTRA2 / Stevie startup options
0110               *--------------------------------------------------------------
0111      0001     debug                     equ  1       ; Turn on spectra2 debugging
0112      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0113      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0114      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0115               
0116      7E00     cpu.scrpad.src            equ  >7e00   ; \ Dump of OS monitor scratchpad
0117                                                      ; | stored in cartridge ROM
0118                                                      ; / bank3.asm
0119               
0120      F960     cpu.scrpad.tgt            equ  >f960   ; \ Destination for copy of TI Basic
0121                                                      ; | scratchpad RAM (SAMS bank #08)
0122                                                      ; /
0123               
0124               
0125               *--------------------------------------------------------------
0126               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0127               *--------------------------------------------------------------
0128      A000     core1.top         equ  >a000           ; Structure begin
0129      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0130      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0131      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0132      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0133      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0134      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0135      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0136      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0137      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0138      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0139      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0140      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0141      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0142      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0143      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0144      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0145      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0146      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0147      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0148      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0149      A02C     tibasic.status    equ  core1.top + 44  ; TI Basic status flags
0150                                                      ; 0000 = Initialize TI-Basic
0151                                                      ; 0001 = TI-Basic reentry
0152      A02E     core1.free        equ  core1.top + 46  ; End of structure
0153               *--------------------------------------------------------------
0154               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0155               *--------------------------------------------------------------
0156      A100     core2.top         equ  >a100           ; Structure begin
0157      A100     timers            equ  core2.top       ; Timer table
0158      A140     rambuf            equ  core2.top + 64  ; RAM workbuffer
0159      A180     ramsat            equ  core2.top + 128 ; Sprite Attribute Table in RAM
0160      A1A0     core2.free        equ  core2.top + 160 ; End of structure
0161               *--------------------------------------------------------------
0162               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0163               *--------------------------------------------------------------
0164      A200     tv.top            equ  >a200           ; Structure begin
0165      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0166      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0167      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0168      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0169      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0170      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0171      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0172      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0173      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0174      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0175      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0176      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0177      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0178      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0179      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0180      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0181      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0182      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0183      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0184      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0185      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0186      A22A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0187      A2CA     tv.free           equ  tv.top + 202    ; End of structure
0188               *--------------------------------------------------------------
0189               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0190               *--------------------------------------------------------------
0191      A300     fb.struct         equ  >a300           ; Structure begin
0192      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0193      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0194      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0195                                                      ; line X in editor buffer).
0196      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0197                                                      ; (offset 0 .. @fb.scrrows)
0198      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0199      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0200      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0201      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0202      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0203      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0204      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0205      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0206      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0207      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0208      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0209      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0210      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0211      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0212               *--------------------------------------------------------------
0213               * File handle structure               @>a400-a4ff   (256 bytes)
0214               *--------------------------------------------------------------
0215      A400     fh.struct         equ  >a400           ; stevie file handling structures
0216               ;***********************************************************************
0217               ; ATTENTION
0218               ; The dsrlnk variables must form a continuous memory block and keep
0219               ; their order!
0220               ;***********************************************************************
0221      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0222      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0223      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0224      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0225      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0226      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0227      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0228      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0229      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0230      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0231      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0232      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0233      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0234      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0235      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0236      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0237      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0238      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0239      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0240      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0241      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0242      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0243      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0244      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0245      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0246      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0247      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0248      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0249      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0250      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0251      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0252      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0253               *--------------------------------------------------------------
0254               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0255               *--------------------------------------------------------------
0256      A500     edb.struct        equ  >a500           ; Begin structure
0257      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0258      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0259      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0260      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0261      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0262      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0263      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0264      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0265      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0266      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0267                                                      ; with current filename.
0268      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0269                                                      ; with current file type.
0270      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0271      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0272      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0273                                                      ; for filename, but not always used.
0274      A569     edb.free          equ  edb.struct + 105; End of structure
0275               *--------------------------------------------------------------
0276               * Index structure                     @>a600-a6ff   (256 bytes)
0277               *--------------------------------------------------------------
0278      A600     idx.struct        equ  >a600           ; stevie index structure
0279      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0280      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0281      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0282      A606     idx.free          equ  idx.struct + 6  ; End of structure
0283               *--------------------------------------------------------------
0284               * Command buffer structure            @>a700-a7ff   (256 bytes)
0285               *--------------------------------------------------------------
0286      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0287      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0288      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0289      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0290      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0291      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0292      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0293      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0294      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0295      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0296      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0297      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0298      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0299      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0300      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0301      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0302      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0303      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0304      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0305      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0306      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0307      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0308      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0309      A779     cmdb.free         equ  cmdb.struct +121; End of structure
0310               *--------------------------------------------------------------
0311               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0312               *--------------------------------------------------------------
0313      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0314               *--------------------------------------------------------------
0315               * Farjump return stack                @>af00-afff   (256 bytes)
0316               *--------------------------------------------------------------
0317      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0318                                                      ; Grows downwards from high to low.
0319               *--------------------------------------------------------------
0320               * Index                               @>b000-bfff  (4096 bytes)
0321               *--------------------------------------------------------------
0322      B000     idx.top           equ  >b000           ; Top of index
0323      1000     idx.size          equ  4096            ; Index size
0324               *--------------------------------------------------------------
0325               * Editor buffer                       @>c000-cfff  (4096 bytes)
0326               *--------------------------------------------------------------
0327      C000     edb.top           equ  >c000           ; Editor buffer high memory
0328      1000     edb.size          equ  4096            ; Editor buffer size
0329               *--------------------------------------------------------------
0330               * Frame buffer                        @>d000-dfff  (4096 bytes)
0331               *--------------------------------------------------------------
0332      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0333      0960     fb.size           equ  80*30           ; Frame buffer size
0334               *--------------------------------------------------------------
0335               * Command buffer history              @>e000-efff  (4096 bytes)
0336               *--------------------------------------------------------------
0337      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0338      1000     cmdb.size         equ  4096            ; Command buffer size
0339               *--------------------------------------------------------------
0340               * Heap                                @>f000-ffff  (4096 bytes)
0341               *--------------------------------------------------------------
0342      F000     heap.top          equ  >f000           ; Top of heap
                   < stevie_b4.asm.9883
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
0012      004E     key.uc.n      equ >4e               ; N
0013      0053     key.uc.s      equ >53               ; S
0014      004F     key.uc.o      equ >4f               ; O
0015      0051     key.uc.q      equ >51               ; Q
0016      00A2     key.lc.b      equ >a2               ; b
0017      00A5     key.lc.e      equ >a5               ; e
0018      00A6     key.lc.f      equ >a6               ; f
0019      00A8     key.lc.h      equ >a8               ; h
0020      006E     key.lc.n      equ >6e               ; n
0021      0073     key.lc.s      equ >73               ; s
0022      006F     key.lc.o      equ >6f               ; o
0023      0071     key.lc.q      equ >71               ; q
0024               
0025               
0026               *---------------------------------------------------------------
0027               * Keyboard scancodes - Function keys
0028               *-------------|---------------------|---------------------------
0029      00BC     key.fctn.0    equ >bc               ; fctn + 0
0030      0003     key.fctn.1    equ >03               ; fctn + 1
0031      0004     key.fctn.2    equ >04               ; fctn + 2
0032      0007     key.fctn.3    equ >07               ; fctn + 3
0033      0002     key.fctn.4    equ >02               ; fctn + 4
0034      000E     key.fctn.5    equ >0e               ; fctn + 5
0035      000C     key.fctn.6    equ >0c               ; fctn + 6
0036      0001     key.fctn.7    equ >01               ; fctn + 7
0037      0006     key.fctn.8    equ >06               ; fctn + 8
0038      000F     key.fctn.9    equ >0f               ; fctn + 9
0039      0000     key.fctn.a    equ >00               ; fctn + a
0040      00BE     key.fctn.b    equ >be               ; fctn + b
0041      0000     key.fctn.c    equ >00               ; fctn + c
0042      0009     key.fctn.d    equ >09               ; fctn + d
0043      000B     key.fctn.e    equ >0b               ; fctn + e
0044      0000     key.fctn.f    equ >00               ; fctn + f
0045      0000     key.fctn.g    equ >00               ; fctn + g
0046      00BF     key.fctn.h    equ >bf               ; fctn + h
0047      0000     key.fctn.i    equ >00               ; fctn + i
0048      00C0     key.fctn.j    equ >c0               ; fctn + j
0049      00C1     key.fctn.k    equ >c1               ; fctn + k
0050      00C2     key.fctn.l    equ >c2               ; fctn + l
0051      00C3     key.fctn.m    equ >c3               ; fctn + m
0052      00C4     key.fctn.n    equ >c4               ; fctn + n
0053      0000     key.fctn.o    equ >00               ; fctn + o
0054      0000     key.fctn.p    equ >00               ; fctn + p
0055      00C5     key.fctn.q    equ >c5               ; fctn + q
0056      0000     key.fctn.r    equ >00               ; fctn + r
0057      0008     key.fctn.s    equ >08               ; fctn + s
0058      0000     key.fctn.t    equ >00               ; fctn + t
0059      0000     key.fctn.u    equ >00               ; fctn + u
0060      007F     key.fctn.v    equ >7f               ; fctn + v
0061      007E     key.fctn.w    equ >7e               ; fctn + w
0062      000A     key.fctn.x    equ >0a               ; fctn + x
0063      00C6     key.fctn.y    equ >c6               ; fctn + y
0064      0000     key.fctn.z    equ >00               ; fctn + z
0065               *---------------------------------------------------------------
0066               * Keyboard scancodes - Function keys extra
0067               *---------------------------------------------------------------
0068      00B9     key.fctn.dot    equ >b9             ; fctn + .
0069      00B8     key.fctn.comma  equ >b8             ; fctn + ,
0070      0005     key.fctn.plus   equ >05             ; fctn + +
0071               *---------------------------------------------------------------
0072               * Keyboard scancodes - control keys
0073               *-------------|---------------------|---------------------------
0074      00B0     key.ctrl.0    equ >b0               ; ctrl + 0
0075      00B1     key.ctrl.1    equ >b1               ; ctrl + 1
0076      00B2     key.ctrl.2    equ >b2               ; ctrl + 2
0077      00B3     key.ctrl.3    equ >b3               ; ctrl + 3
0078      00B4     key.ctrl.4    equ >b4               ; ctrl + 4
0079      00B5     key.ctrl.5    equ >b5               ; ctrl + 5
0080      00B6     key.ctrl.6    equ >b6               ; ctrl + 6
0081      00B7     key.ctrl.7    equ >b7               ; ctrl + 7
0082      009E     key.ctrl.8    equ >9e               ; ctrl + 8
0083      009F     key.ctrl.9    equ >9f               ; ctrl + 9
0084      0081     key.ctrl.a    equ >81               ; ctrl + a
0085      0082     key.ctrl.b    equ >82               ; ctrl + b
0086      0083     key.ctrl.c    equ >83               ; ctrl + c
0087      0084     key.ctrl.d    equ >84               ; ctrl + d
0088      0085     key.ctrl.e    equ >85               ; ctrl + e
0089      0086     key.ctrl.f    equ >86               ; ctrl + f
0090      0087     key.ctrl.g    equ >87               ; ctrl + g
0091      0088     key.ctrl.h    equ >88               ; ctrl + h
0092      0089     key.ctrl.i    equ >89               ; ctrl + i
0093      008A     key.ctrl.j    equ >8a               ; ctrl + j
0094      008B     key.ctrl.k    equ >8b               ; ctrl + k
0095      008C     key.ctrl.l    equ >8c               ; ctrl + l
0096      008D     key.ctrl.m    equ >8d               ; ctrl + m
0097      008E     key.ctrl.n    equ >8e               ; ctrl + n
0098      008F     key.ctrl.o    equ >8f               ; ctrl + o
0099      0090     key.ctrl.p    equ >90               ; ctrl + p
0100      0091     key.ctrl.q    equ >91               ; ctrl + q
0101      0092     key.ctrl.r    equ >92               ; ctrl + r
0102      0093     key.ctrl.s    equ >93               ; ctrl + s
0103      0094     key.ctrl.t    equ >94               ; ctrl + t
0104      0095     key.ctrl.u    equ >95               ; ctrl + u
0105      0096     key.ctrl.v    equ >96               ; ctrl + v
0106      0097     key.ctrl.w    equ >97               ; ctrl + w
0107      0098     key.ctrl.x    equ >98               ; ctrl + x
0108      0099     key.ctrl.y    equ >99               ; ctrl + y
0109      009A     key.ctrl.z    equ >9a               ; ctrl + z
0110               *---------------------------------------------------------------
0111               * Keyboard scancodes - control keys extra
0112               *---------------------------------------------------------------
0113      009B     key.ctrl.dot    equ >9b             ; ctrl + .
0114      0080     key.ctrl.comma  equ >80             ; ctrl + ,
0115      009D     key.ctrl.plus   equ >9d             ; ctrl + +
0116      00BB     key.ctrl.slash  equ >bb             ; ctrl + /
0117               *---------------------------------------------------------------
0118               * Special keys
0119               *---------------------------------------------------------------
0120      000D     key.enter     equ >0d               ; enter
                   < stevie_b4.asm.9883
0018               
0019               ***************************************************************
0020               * Spectra2 core configuration
0021               ********|*****|*********************|**************************
0022      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0023                                                   ; grows from high to low.
0024               ***************************************************************
0025               * BANK 4
0026               ********|*****|*********************|**************************
0027      6008     bankid  equ   bank4.rom             ; Set bank identifier to current bank
0028                       aorg  >6000
0029                       save  >6000,>7fff           ; Save bank
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
0045 6011   53             text  'STEVIE 1.1X'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3158     
0046                       even
0047               
0049               
                   < stevie_b4.asm.9883
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
     60C8 2FCC     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 60CA 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     60CC 22EE     
0078 60CE 21E8                   data graph1           ; Equate selected video mode table
0079               
0080 60D0 06A0  32         bl    @ldfnt
     60D2 2356     
0081 60D4 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     60D6 000C     
0082               
0083 60D8 06A0  32         bl    @filv
     60DA 2284     
0084 60DC 0380                   data >0380,>f0,32*24  ; Load color table
     60DE 00F0     
     60E0 0300     
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 60E2 06A0  32         bl    @putat                ; Show crash message
     60E4 2438     
0089 60E6 0000                   data >0000,cpu.crash.msg.crashed
     60E8 2178     
0090               
0091 60EA 06A0  32         bl    @puthex               ; Put hex value on screen
     60EC 2A82     
0092 60EE 0015                   byte 0,21             ; \ i  p0 = YX position
0093 60F0 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 60F2 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 60F4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 60F6 06A0  32         bl    @putat                ; Show caller message
     60F8 2438     
0101 60FA 0100                   data >0100,cpu.crash.msg.caller
     60FC 218E     
0102               
0103 60FE 06A0  32         bl    @puthex               ; Put hex value on screen
     6100 2A82     
0104 6102 0115                   byte 1,21             ; \ i  p0 = YX position
0105 6104 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6106 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 6108 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 610A 06A0  32         bl    @putat
     610C 2438     
0113 610E 0300                   byte 3,0
0114 6110 21AA                   data cpu.crash.msg.wp
0115 6112 06A0  32         bl    @putat
     6114 2438     
0116 6116 0400                   byte 4,0
0117 6118 21B0                   data cpu.crash.msg.st
0118 611A 06A0  32         bl    @putat
     611C 2438     
0119 611E 1600                   byte 22,0
0120 6120 21B6                   data cpu.crash.msg.source
0121 6122 06A0  32         bl    @putat
     6124 2438     
0122 6126 1700                   byte 23,0
0123 6128 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 612A 06A0  32         bl    @at                   ; Put cursor at YX
     612C 26C4     
0128 612E 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6130 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6132 FFDC     
0132 6134 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 6136 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 6138 0649  14         dect  stack
0138 613A C644  30         mov   tmp0,*stack           ; Push tmp0
0139 613C 0649  14         dect  stack
0140 613E C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6140 0649  14         dect  stack
0142 6142 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 6144 C046  18         mov   tmp2,r1               ; Save register number
0148 6146 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6148 0001     
0149 614A 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 614C 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 614E 06A0  32         bl    @mknum
     6150 2A8C     
0154 6152 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 6154 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 6156 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 6158 06A0  32         bl    @setx                 ; Set cursor X position
     615A 26DA     
0160 615C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 615E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6160 2414     
0164 6162 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 6164 06A0  32         bl    @setx                 ; Set cursor X position
     6166 26DA     
0168 6168 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 616A 0281  22         ci    r1,10
     616C 000A     
0172 616E 1102  14         jlt   !
0173 6170 0620  34         dec   @wyx                  ; x=x-1
     6172 832A     
0174               
0175 6174 06A0  32 !       bl    @putstr
     6176 2414     
0176 6178 21A4                   data cpu.crash.msg.r
0177               
0178 617A 06A0  32         bl    @mknum
     617C 2A8C     
0179 617E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 6180 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 6182 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 6184 06A0  32         bl    @mkhex                ; Convert hex word to string
     6186 29FE     
0188 6188 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 618A A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 618C 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 618E 06A0  32         bl    @setx                 ; Set cursor X position
     6190 26DA     
0194 6192 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 6194 06A0  32         bl    @putstr               ; Put '  >'
     6196 2414     
0198 6198 21A6                   data cpu.crash.msg.marker
0199               
0200 619A 06A0  32         bl    @setx                 ; Set cursor X position
     619C 26DA     
0201 619E 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61A0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A2 2414     
0205 61A4 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61AC 06A0  32         bl    @down                 ; y=y+1
     61AE 26CA     
0213               
0214 61B0 0586  14         inc   tmp2
0215 61B2 0286  22         ci    tmp2,17
     61B4 0011     
0216 61B6 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61B8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61BA 2EC0     
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61BC 15               byte  21
0225 61BD   53             text  'System crashed near >'
     61BE 7973     
     61C0 7465     
     61C2 6D20     
     61C4 6372     
     61C6 6173     
     61C8 6865     
     61CA 6420     
     61CC 6E65     
     61CE 6172     
     61D0 203E     
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 61D2 15               byte  21
0230 61D3   43             text  'Caller address near >'
     61D4 616C     
     61D6 6C65     
     61D8 7220     
     61DA 6164     
     61DC 6472     
     61DE 6573     
     61E0 7320     
     61E2 6E65     
     61E4 6172     
     61E6 203E     
0231                       even
0232               
0233               cpu.crash.msg.r
0234 61E8 01               byte  1
0235 61E9   52             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 61EA 03               byte  3
0240 61EB   20             text  '  >'
     61EC 203E     
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 61EE 04               byte  4
0245 61EF   2A             text  '**WP'
     61F0 2A57     
     61F2 50       
0246                       even
0247               
0248               cpu.crash.msg.st
0249 61F4 04               byte  4
0250 61F5   2A             text  '**ST'
     61F6 2A53     
     61F8 54       
0251                       even
0252               
0253               cpu.crash.msg.source
0254 61FA 1B               byte  27
0255 61FB   53             text  'Source    stevie_b4.lst.asm'
     61FC 6F75     
     61FE 7263     
     6200 6520     
     6202 2020     
     6204 2073     
     6206 7465     
     6208 7669     
     620A 655F     
     620C 6234     
     620E 2E6C     
     6210 7374     
     6212 2E61     
     6214 736D     
0256                       even
0257               
0258               cpu.crash.msg.id
0259 6216 15               byte  21
0260 6217   42             text  'Build-ID  211012-9883'
     6218 7569     
     621A 6C64     
     621C 2D49     
     621E 4420     
     6220 2032     
     6222 3131     
     6224 3031     
     6226 322D     
     6228 3938     
     622A 3833     
0261                       even
0262               
                   < runlib.asm
0090                       copy  "vdp_tables.asm"           ; Data used by runtime library
     **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 622C 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     622E 000E     
     6230 0106     
     6232 0204     
     6234 0020     
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
0032 6236 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6238 000E     
     623A 0106     
     623C 00F4     
     623E 0028     
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
0058 6240 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6242 003F     
     6244 0240     
     6246 03F4     
     6248 0050     
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
0013 624A 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 624C 16FD             data  >16fd                 ; |         jne   mcloop
0015 624E 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6250 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6252 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 6254 0201  20         li    r1,mccode             ; Machinecode to patch
     6256 2206     
0037 6258 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     625A 8322     
0038 625C CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 625E CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 6260 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 6262 045B  20         b     *r11                  ; Return to caller
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
0056 6264 C0F9  30 popr3   mov   *stack+,r3
0057 6266 C0B9  30 popr2   mov   *stack+,r2
0058 6268 C079  30 popr1   mov   *stack+,r1
0059 626A C039  30 popr0   mov   *stack+,r0
0060 626C C2F9  30 poprt   mov   *stack+,r11
0061 626E 045B  20         b     *r11
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
0085 6270 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 6272 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 6274 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 6276 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 6278 1604  14         jne   filchk                ; No, continue checking
0093               
0094 627A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     627C FFCE     
0095 627E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6280 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 6282 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     6284 830B     
     6286 830A     
0100               
0101 6288 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     628A 0001     
0102 628C 1602  14         jne   filchk2
0103 628E DD05  32         movb  tmp1,*tmp0+
0104 6290 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 6292 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6294 0002     
0109 6296 1603  14         jne   filchk3
0110 6298 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 629A DD05  32         movb  tmp1,*tmp0+
0112 629C 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 629E C1C4  18 filchk3 mov   tmp0,tmp3
0117 62A0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62A2 0001     
0118 62A4 1305  14         jeq   fil16b
0119 62A6 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62A8 0606  14         dec   tmp2
0121 62AA 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62AC 0002     
0122 62AE 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62B0 C1C6  18 fil16b  mov   tmp2,tmp3
0127 62B2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62B4 0001     
0128 62B6 1301  14         jeq   dofill
0129 62B8 0606  14         dec   tmp2                  ; Make TMP2 even
0130 62BA CD05  34 dofill  mov   tmp1,*tmp0+
0131 62BC 0646  14         dect  tmp2
0132 62BE 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 62C0 C1C7  18         mov   tmp3,tmp3
0137 62C2 1301  14         jeq   fil.exit
0138 62C4 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 62C6 045B  20         b     *r11
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
0159 62C8 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 62CA C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 62CC C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 62CE 0264  22 xfilv   ori   tmp0,>4000
     62D0 4000     
0166 62D2 06C4  14         swpb  tmp0
0167 62D4 D804  38         movb  tmp0,@vdpa
     62D6 8C02     
0168 62D8 06C4  14         swpb  tmp0
0169 62DA D804  38         movb  tmp0,@vdpa
     62DC 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 62DE 020F  20         li    r15,vdpw              ; Set VDP write address
     62E0 8C00     
0174 62E2 06C5  14         swpb  tmp1
0175 62E4 C820  54         mov   @filzz,@mcloop        ; Setup move command
     62E6 22AA     
     62E8 8320     
0176 62EA 0460  28         b     @mcloop               ; Write data to VDP
     62EC 8320     
0177               *--------------------------------------------------------------
0181 62EE D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 62F0 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     62F2 4000     
0202 62F4 06C4  14 vdra    swpb  tmp0
0203 62F6 D804  38         movb  tmp0,@vdpa
     62F8 8C02     
0204 62FA 06C4  14         swpb  tmp0
0205 62FC D804  38         movb  tmp0,@vdpa            ; Set VDP address
     62FE 8C02     
0206 6300 045B  20         b     *r11                  ; Exit
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
0217 6302 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6304 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 6306 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6308 4000     
0223 630A 06C4  14         swpb  tmp0                  ; \
0224 630C D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     630E 8C02     
0225 6310 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6312 D804  38         movb  tmp0,@vdpa            ; /
     6314 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 6316 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6318 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 631A 045B  20         b     *r11                  ; Exit
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
0251 631C C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 631E 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6320 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6322 8C02     
0257 6324 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 6326 D804  38         movb  tmp0,@vdpa            ; /
     6328 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 632A D120  34         movb  @vdpr,tmp0            ; Read byte
     632C 8800     
0263 632E 0984  56         srl   tmp0,8                ; Right align
0264 6330 045B  20         b     *r11                  ; Exit
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
0283 6332 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6334 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 6336 C144  18         mov   tmp0,tmp1
0289 6338 05C5  14         inct  tmp1
0290 633A D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 633C 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     633E FF00     
0292 6340 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 6342 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6344 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 6346 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6348 8000     
0298 634A 0206  20         li    tmp2,8
     634C 0008     
0299 634E D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6350 830B     
0300 6352 06C5  14         swpb  tmp1
0301 6354 D805  38         movb  tmp1,@vdpa
     6356 8C02     
0302 6358 06C5  14         swpb  tmp1
0303 635A D805  38         movb  tmp1,@vdpa
     635C 8C02     
0304 635E 0225  22         ai    tmp1,>0100
     6360 0100     
0305 6362 0606  14         dec   tmp2
0306 6364 16F4  14         jne   vidta1                ; Next register
0307 6366 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6368 833A     
0308 636A 045B  20         b     *r11
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
0325 636C C13B  30 putvr   mov   *r11+,tmp0
0326 636E 0264  22 putvrx  ori   tmp0,>8000
     6370 8000     
0327 6372 06C4  14         swpb  tmp0
0328 6374 D804  38         movb  tmp0,@vdpa
     6376 8C02     
0329 6378 06C4  14         swpb  tmp0
0330 637A D804  38         movb  tmp0,@vdpa
     637C 8C02     
0331 637E 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 6380 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 6382 C10E  18         mov   r14,tmp0
0341 6384 0984  56         srl   tmp0,8
0342 6386 06A0  32         bl    @putvrx               ; Write VR#0
     6388 232A     
0343 638A 0204  20         li    tmp0,>0100
     638C 0100     
0344 638E D820  54         movb  @r14lb,@tmp0lb
     6390 831D     
     6392 8309     
0345 6394 06A0  32         bl    @putvrx               ; Write VR#1
     6396 232A     
0346 6398 0458  20         b     *tmp4                 ; Exit
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
0360 639A C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 639C 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 639E C11B  26         mov   *r11,tmp0             ; Get P0
0363 63A0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63A2 7FFF     
0364 63A4 2120  38         coc   @wbit0,tmp0
     63A6 2020     
0365 63A8 1604  14         jne   ldfnt1
0366 63AA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63AC 8000     
0367 63AE 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63B0 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63B2 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63B4 23D8     
0372 63B6 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63B8 9C02     
0373 63BA 06C4  14         swpb  tmp0
0374 63BC D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     63BE 9C02     
0375 63C0 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     63C2 9800     
0376 63C4 06C5  14         swpb  tmp1
0377 63C6 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     63C8 9800     
0378 63CA 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 63CC D805  38         movb  tmp1,@grmwa
     63CE 9C02     
0383 63D0 06C5  14         swpb  tmp1
0384 63D2 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     63D4 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 63D6 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 63D8 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     63DA 22AC     
0390 63DC 05C8  14         inct  tmp4                  ; R11=R11+2
0391 63DE C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 63E0 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63E2 7FFF     
0393 63E4 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63E6 23DA     
0394 63E8 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     63EA 23DC     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 63EC 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 63EE 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 63F0 D120  34         movb  @grmrd,tmp0
     63F2 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 63F4 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     63F6 2020     
0405 63F8 1603  14         jne   ldfnt3                ; No, so skip
0406 63FA D1C4  18         movb  tmp0,tmp3
0407 63FC 0917  56         srl   tmp3,1
0408 63FE E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6400 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6402 8C00     
0413 6404 0606  14         dec   tmp2
0414 6406 16F2  14         jne   ldfnt2
0415 6408 05C8  14         inct  tmp4                  ; R11=R11+2
0416 640A 020F  20         li    r15,vdpw              ; Set VDP write address
     640C 8C00     
0417 640E 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6410 7FFF     
0418 6412 0458  20         b     *tmp4                 ; Exit
0419 6414 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6416 2000     
     6418 8C00     
0420 641A 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 641C 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     641E 0200     
     6420 0000     
0425 6422 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6424 01C0     
     6426 0101     
0426 6428 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     642A 02A0     
     642C 0101     
0427 642E 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6430 00E0     
     6432 0101     
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
0445 6434 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 6436 C3A0  34         mov   @wyx,r14              ; Get YX
     6438 832A     
0447 643A 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 643C 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     643E 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6440 C3A0  34         mov   @wyx,r14              ; Get YX
     6442 832A     
0454 6444 024E  22         andi  r14,>00ff             ; Remove Y
     6446 00FF     
0455 6448 A3CE  18         a     r14,r15               ; pos = pos + X
0456 644A A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     644C 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 644E C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 6450 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 6452 020F  20         li    r15,vdpw              ; VDP write address
     6454 8C00     
0463 6456 045B  20         b     *r11
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
0481 6458 C17B  30 putstr  mov   *r11+,tmp1
0482 645A D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 645C C1CB  18 xutstr  mov   r11,tmp3
0484 645E 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6460 23F0     
0485 6462 C2C7  18         mov   tmp3,r11
0486 6464 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 6466 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 6468 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 646A 0286  22         ci    tmp2,255              ; Length > 255 ?
     646C 00FF     
0494 646E 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 6470 0460  28         b     @xpym2v               ; Display string
     6472 2482     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 6474 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6476 FFCE     
0501 6478 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     647A 2026     
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
0517 647C C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     647E 832A     
0518 6480 0460  28         b     @putstr
     6482 2414     
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
0539 6484 0649  14         dect  stack
0540 6486 C64B  30         mov   r11,*stack            ; Save return address
0541 6488 0649  14         dect  stack
0542 648A C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 648C D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 648E 0987  56         srl   tmp3,8                ; Right align
0549               
0550 6490 0649  14         dect  stack
0551 6492 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 6494 0649  14         dect  stack
0553 6496 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 6498 0649  14         dect  stack
0555 649A C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 649C 06A0  32         bl    @xutst0               ; Display string
     649E 2416     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64A0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64A2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64A4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64A6 06A0  32         bl    @down                 ; Move cursor down
     64A8 26CA     
0566               
0567 64AA A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 64AC 0585  14         inc   tmp1                  ; Consider length byte
0569 64AE 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     64B0 2002     
0570 64B2 1301  14         jeq   !                     ; Yes, skip adjustment
0571 64B4 0585  14         inc   tmp1                  ; Make address even
0572 64B6 0606  14 !       dec   tmp2
0573 64B8 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 64BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 64BC C2F9  30         mov   *stack+,r11           ; Pop r11
0580 64BE 045B  20         b     *r11                  ; Return
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
0020 64C0 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64C2 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64C4 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 64C6 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64C8 1604  14         jne   !                     ; No, continue
0028               
0029 64CA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64CC FFCE     
0030 64CE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64D0 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64D2 0264  22 !       ori   tmp0,>4000
     64D4 4000     
0035 64D6 06C4  14         swpb  tmp0
0036 64D8 D804  38         movb  tmp0,@vdpa
     64DA 8C02     
0037 64DC 06C4  14         swpb  tmp0
0038 64DE D804  38         movb  tmp0,@vdpa
     64E0 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 64E2 020F  20         li    r15,vdpw              ; Set VDP write address
     64E4 8C00     
0043 64E6 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     64E8 24AC     
     64EA 8320     
0044 64EC 0460  28         b     @mcloop               ; Write data to VDP and return
     64EE 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 64F0 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 64F2 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 64F4 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 64F6 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 64F8 06C4  14 xpyv2m  swpb  tmp0
0027 64FA D804  38         movb  tmp0,@vdpa
     64FC 8C02     
0028 64FE 06C4  14         swpb  tmp0
0029 6500 D804  38         movb  tmp0,@vdpa
     6502 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6504 020F  20         li    r15,vdpr              ; Set VDP read address
     6506 8800     
0034 6508 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     650A 24CE     
     650C 8320     
0035 650E 0460  28         b     @mcloop               ; Read data from VDP
     6510 8320     
0036 6512 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6514 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6516 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6518 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 651A C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 651C 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 651E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6520 FFCE     
0034 6522 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6524 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6526 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6528 0001     
0039 652A 1603  14         jne   cpym0                 ; No, continue checking
0040 652C DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 652E 04C6  14         clr   tmp2                  ; Reset counter
0042 6530 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6532 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6534 7FFF     
0047 6536 C1C4  18         mov   tmp0,tmp3
0048 6538 0247  22         andi  tmp3,1
     653A 0001     
0049 653C 1618  14         jne   cpyodd                ; Odd source address handling
0050 653E C1C5  18 cpym1   mov   tmp1,tmp3
0051 6540 0247  22         andi  tmp3,1
     6542 0001     
0052 6544 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 6546 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6548 2020     
0057 654A 1605  14         jne   cpym3
0058 654C C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     654E 2530     
     6550 8320     
0059 6552 0460  28         b     @mcloop               ; Copy memory and exit
     6554 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 6556 C1C6  18 cpym3   mov   tmp2,tmp3
0064 6558 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     655A 0001     
0065 655C 1301  14         jeq   cpym4
0066 655E 0606  14         dec   tmp2                  ; Make TMP2 even
0067 6560 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 6562 0646  14         dect  tmp2
0069 6564 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 6566 C1C7  18         mov   tmp3,tmp3
0074 6568 1301  14         jeq   cpymz
0075 656A D554  38         movb  *tmp0,*tmp1
0076 656C 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 656E 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     6570 8000     
0081 6572 10E9  14         jmp   cpym2
0082 6574 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 6576 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6578 0649  14         dect  stack
0065 657A C64B  30         mov   r11,*stack            ; Push return address
0066 657C 0649  14         dect  stack
0067 657E C640  30         mov   r0,*stack             ; Push r0
0068 6580 0649  14         dect  stack
0069 6582 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 6584 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 6586 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 6588 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     658A 4000     
0077 658C C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     658E 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 6590 020C  20         li    r12,>1e00             ; SAMS CRU address
     6592 1E00     
0082 6594 04C0  14         clr   r0
0083 6596 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 6598 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 659A D100  18         movb  r0,tmp0
0086 659C 0984  56         srl   tmp0,8                ; Right align
0087 659E C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65A0 833C     
0088 65A2 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65A4 C339  30         mov   *stack+,r12           ; Pop r12
0094 65A6 C039  30         mov   *stack+,r0            ; Pop r0
0095 65A8 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65AA 045B  20         b     *r11                  ; Return to caller
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
0131 65AC C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65AE C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65B0 0649  14         dect  stack
0135 65B2 C64B  30         mov   r11,*stack            ; Push return address
0136 65B4 0649  14         dect  stack
0137 65B6 C640  30         mov   r0,*stack             ; Push r0
0138 65B8 0649  14         dect  stack
0139 65BA C64C  30         mov   r12,*stack            ; Push r12
0140 65BC 0649  14         dect  stack
0141 65BE C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65C0 0649  14         dect  stack
0143 65C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65C4 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65C6 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 65C8 0284  22         ci    tmp0,255              ; Crash if page > 255
     65CA 00FF     
0153 65CC 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 65CE 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65D0 001E     
0158 65D2 150A  14         jgt   !
0159 65D4 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65D6 0004     
0160 65D8 1107  14         jlt   !
0161 65DA 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65DC 0012     
0162 65DE 1508  14         jgt   sams.page.set.switch_page
0163 65E0 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65E2 0006     
0164 65E4 1501  14         jgt   !
0165 65E6 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 65E8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     65EA FFCE     
0170 65EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65EE 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 65F0 020C  20         li    r12,>1e00             ; SAMS CRU address
     65F2 1E00     
0176 65F4 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 65F6 06C0  14         swpb  r0                    ; LSB to MSB
0178 65F8 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 65FA D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     65FC 4000     
0180 65FE 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6600 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6602 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6604 C339  30         mov   *stack+,r12           ; Pop r12
0188 6606 C039  30         mov   *stack+,r0            ; Pop r0
0189 6608 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 660A 045B  20         b     *r11                  ; Return to caller
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
0204 660C 020C  20         li    r12,>1e00             ; SAMS CRU address
     660E 1E00     
0205 6610 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6612 045B  20         b     *r11                  ; Return to caller
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
0227 6614 020C  20         li    r12,>1e00             ; SAMS CRU address
     6616 1E00     
0228 6618 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 661A 045B  20         b     *r11                  ; Return to caller
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
0260 661C C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 661E 0649  14         dect  stack
0263 6620 C64B  30         mov   r11,*stack            ; Save return address
0264 6622 0649  14         dect  stack
0265 6624 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 6626 0649  14         dect  stack
0267 6628 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 662A 0649  14         dect  stack
0269 662C C646  30         mov   tmp2,*stack           ; Save tmp2
0270 662E 0649  14         dect  stack
0271 6630 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6632 0206  20         li    tmp2,8                ; Set loop counter
     6634 0008     
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 6636 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6638 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 663A 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     663C 256C     
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 663E 0606  14         dec   tmp2                  ; Next iteration
0288 6640 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6642 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6644 25C8     
0294                                                   ; / activating changes.
0295               
0296 6646 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 6648 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 664A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 664C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 664E C2F9  30         mov   *stack+,r11           ; Pop r11
0301 6650 045B  20         b     *r11                  ; Return to caller
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
0318 6652 0649  14         dect  stack
0319 6654 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 6656 06A0  32         bl    @sams.layout
     6658 25D8     
0324 665A 261C                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 665C C2F9  30         mov   *stack+,r11           ; Pop r11
0330 665E 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 6660 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6662 0002     
0336 6664 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6666 0003     
0337 6668 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     666A 000A     
0338 666C B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     666E 000B     
0339 6670 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6672 000C     
0340 6674 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     6676 000D     
0341 6678 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     667A 000E     
0342 667C F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     667E 000F     
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
0363 6680 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 6682 0649  14         dect  stack
0366 6684 C64B  30         mov   r11,*stack            ; Push return address
0367 6686 0649  14         dect  stack
0368 6688 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 668A 0649  14         dect  stack
0370 668C C645  30         mov   tmp1,*stack           ; Push tmp1
0371 668E 0649  14         dect  stack
0372 6690 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 6692 0649  14         dect  stack
0374 6694 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 6696 0205  20         li    tmp1,sams.layout.copy.data
     6698 2674     
0379 669A 0206  20         li    tmp2,8                ; Set loop counter
     669C 0008     
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 669E C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66A0 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66A2 2534     
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66A4 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66A6 833C     
0390               
0391 66A8 0606  14         dec   tmp2                  ; Next iteration
0392 66AA 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66AC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66AE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66B6 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66B8 2000             data  >2000                 ; >2000-2fff
0408 66BA 3000             data  >3000                 ; >3000-3fff
0409 66BC A000             data  >a000                 ; >a000-afff
0410 66BE B000             data  >b000                 ; >b000-bfff
0411 66C0 C000             data  >c000                 ; >c000-cfff
0412 66C2 D000             data  >d000                 ; >d000-dfff
0413 66C4 E000             data  >e000                 ; >e000-efff
0414 66C6 F000             data  >f000                 ; >f000-ffff
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
0009 66C8 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66CA FFBF     
0010 66CC 0460  28         b     @putv01
     66CE 233C     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66D0 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66D2 0040     
0018 66D4 0460  28         b     @putv01
     66D6 233C     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66D8 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66DA FFDF     
0026 66DC 0460  28         b     @putv01
     66DE 233C     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66E0 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66E2 0020     
0034 66E4 0460  28         b     @putv01
     66E6 233C     
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
0010 66E8 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     66EA FFFE     
0011 66EC 0460  28         b     @putv01
     66EE 233C     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 66F0 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     66F2 0001     
0019 66F4 0460  28         b     @putv01
     66F6 233C     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 66F8 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     66FA FFFD     
0027 66FC 0460  28         b     @putv01
     66FE 233C     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6700 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6702 0002     
0035 6704 0460  28         b     @putv01
     6706 233C     
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
0018 6708 C83B  50 at      mov   *r11+,@wyx
     670A 832A     
0019 670C 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 670E B820  54 down    ab    @hb$01,@wyx
     6710 2012     
     6712 832A     
0028 6714 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6716 7820  54 up      sb    @hb$01,@wyx
     6718 2012     
     671A 832A     
0037 671C 045B  20         b     *r11
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
0049 671E C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6720 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6722 832A     
0051 6724 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6726 832A     
0052 6728 045B  20         b     *r11
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
0021 672A C120  34 yx2px   mov   @wyx,tmp0
     672C 832A     
0022 672E C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6730 06C4  14         swpb  tmp0                  ; Y<->X
0024 6732 04C5  14         clr   tmp1                  ; Clear before copy
0025 6734 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6736 20A0  38         coc   @wbit1,config         ; f18a present ?
     6738 201E     
0030 673A 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 673C 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     673E 833A     
     6740 2726     
0032 6742 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6744 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6746 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6748 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     674A 0500     
0037 674C 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 674E D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6750 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6752 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6754 D105  18         movb  tmp1,tmp0
0051 6756 06C4  14         swpb  tmp0                  ; X<->Y
0052 6758 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     675A 2020     
0053 675C 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 675E 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6760 2012     
0059 6762 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6764 2024     
0060 6766 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6768 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 676A 0050            data   80
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
0013 676C C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 676E 06A0  32         bl    @putvr                ; Write once
     6770 2328     
0015 6772 391C             data  >391c                 ; VR1/57, value 00011100
0016 6774 06A0  32         bl    @putvr                ; Write twice
     6776 2328     
0017 6778 391C             data  >391c                 ; VR1/57, value 00011100
0018 677A 06A0  32         bl    @putvr
     677C 2328     
0019 677E 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 6780 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 6782 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 6784 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     6786 2328     
0030 6788 3900             data  >3900
0031 678A 0458  20         b     *tmp4                 ; Exit
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
0043 678C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 678E 06A0  32         bl    @cpym2v
     6790 247C     
0045 6792 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6794 278C     
     6796 0006     
0046 6798 06A0  32         bl    @putvr
     679A 2328     
0047 679C 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 679E 06A0  32         bl    @putvr
     67A0 2328     
0049 67A2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67A4 0204  20         li    tmp0,>3f00
     67A6 3F00     
0055 67A8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67AA 22B0     
0056 67AC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67AE 8800     
0057 67B0 0984  56         srl   tmp0,8
0058 67B2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67B4 8800     
0059 67B6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 67B8 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 67BA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67BC BFFF     
0063 67BE 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 67C0 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67C2 4000     
0066               f18chk_exit:
0067 67C4 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     67C6 2284     
0068 67C8 3F00             data  >3f00,>00,6
     67CA 0000     
     67CC 0006     
0069 67CE 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 67D0 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 67D2 3F00             data  >3f00                 ; 3f02 / 3f00
0076 67D4 0340             data  >0340                 ; 3f04   0340  idle
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
0097 67D6 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 67D8 06A0  32         bl    @putvr
     67DA 2328     
0102 67DC 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 67DE 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67E0 2328     
0105 67E2 3900             data  >3900                 ; Lock the F18a
0106 67E4 0458  20         b     *tmp4                 ; Exit
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
0125 67E6 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 67E8 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     67EA 201E     
0127 67EC 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 67EE C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     67F0 8802     
0132 67F2 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     67F4 2328     
0133 67F6 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 67F8 04C4  14         clr   tmp0
0135 67FA D120  34         movb  @vdps,tmp0
     67FC 8802     
0136 67FE 0984  56         srl   tmp0,8
0137 6800 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6802 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6804 832A     
0018 6806 D17B  28         movb  *r11+,tmp1
0019 6808 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 680A D1BB  28         movb  *r11+,tmp2
0021 680C 0986  56         srl   tmp2,8                ; Repeat count
0022 680E C1CB  18         mov   r11,tmp3
0023 6810 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6812 23F0     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6814 020B  20         li    r11,hchar1
     6816 27D8     
0028 6818 0460  28         b     @xfilv                ; Draw
     681A 228A     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 681C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     681E 2022     
0033 6820 1302  14         jeq   hchar2                ; Yes, exit
0034 6822 C2C7  18         mov   tmp3,r11
0035 6824 10EE  14         jmp   hchar                 ; Next one
0036 6826 05C7  14 hchar2  inct  tmp3
0037 6828 0457  20         b     *tmp3                 ; Exit
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
0014 682A 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     682C 8334     
0015 682E 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     6830 2006     
0016 6832 0204  20         li    tmp0,muttab
     6834 2800     
0017 6836 0205  20         li    tmp1,sound            ; Sound generator port >8400
     6838 8400     
0018 683A D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 683C D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 683E D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 6840 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 6842 045B  20         b     *r11
0023 6844 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     6846 DFFF     
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
0043 6848 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     684A 8334     
0044 684C C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     684E 8336     
0045 6850 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     6852 FFF8     
0046 6854 E0BB  30         soc   *r11+,config          ; Set options
0047 6856 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     6858 2012     
     685A 831B     
0048 685C 045B  20         b     *r11
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
0059 685E 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     6860 2006     
0060 6862 1301  14         jeq   sdpla1                ; Yes, play
0061 6864 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 6866 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 6868 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     686A 831B     
     686C 2000     
0067 686E 1301  14         jeq   sdpla3                ; Play next note
0068 6870 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6872 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6874 2002     
0070 6876 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 6878 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     687A 8336     
0075 687C 06C4  14         swpb  tmp0
0076 687E D804  38         movb  tmp0,@vdpa
     6880 8C02     
0077 6882 06C4  14         swpb  tmp0
0078 6884 D804  38         movb  tmp0,@vdpa
     6886 8C02     
0079 6888 04C4  14         clr   tmp0
0080 688A D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     688C 8800     
0081 688E 131E  14         jeq   sdexit                ; Yes. exit
0082 6890 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 6892 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     6894 8336     
0084 6896 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     6898 8800     
     689A 8400     
0085 689C 0604  14         dec   tmp0
0086 689E 16FB  14         jne   vdpla2
0087 68A0 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     68A2 8800     
     68A4 831B     
0088 68A6 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68A8 8336     
0089 68AA 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 68AC C120  34 mmplay  mov   @wsdtmp,tmp0
     68AE 8336     
0094 68B0 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 68B2 130C  14         jeq   sdexit                ; Yes, exit
0096 68B4 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 68B6 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     68B8 8336     
0098 68BA D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     68BC 8400     
0099 68BE 0605  14         dec   tmp1
0100 68C0 16FC  14         jne   mmpla2
0101 68C2 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     68C4 831B     
0102 68C6 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68C8 8336     
0103 68CA 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 68CC 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     68CE 2004     
0108 68D0 1607  14         jne   sdexi2                ; No, exit
0109 68D2 C820  54         mov   @wsdlst,@wsdtmp
     68D4 8334     
     68D6 8336     
0110 68D8 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     68DA 2012     
     68DC 831B     
0111 68DE 045B  20 sdexi1  b     *r11                  ; Exit
0112 68E0 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     68E2 FFF8     
0113 68E4 045B  20         b     *r11                  ; Exit
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
0016 68E6 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     68E8 2020     
0017 68EA 020C  20         li    r12,>0024
     68EC 0024     
0018 68EE 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     68F0 293E     
0019 68F2 04C6  14         clr   tmp2
0020 68F4 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 68F6 04CC  14         clr   r12
0025 68F8 1F08  20         tb    >0008                 ; Shift-key ?
0026 68FA 1302  14         jeq   realk1                ; No
0027 68FC 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     68FE 296E     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6900 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6902 1302  14         jeq   realk2                ; No
0033 6904 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6906 299E     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6908 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 690A 1302  14         jeq   realk3                ; No
0039 690C 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     690E 29CE     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6910 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     6912 200C     
0044 6914 1E15  20         sbz   >0015                 ; Set P5
0045 6916 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 6918 1302  14         jeq   realk4                ; No
0047 691A E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     691C 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 691E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 6920 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6922 0006     
0053 6924 0606  14 realk5  dec   tmp2
0054 6926 020C  20         li    r12,>24               ; CRU address for P2-P4
     6928 0024     
0055 692A 06C6  14         swpb  tmp2
0056 692C 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 692E 06C6  14         swpb  tmp2
0058 6930 020C  20         li    r12,6                 ; CRU read address
     6932 0006     
0059 6934 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 6936 0547  14         inv   tmp3                  ;
0061 6938 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     693A FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 693C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 693E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 6940 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 6942 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 6944 0285  22         ci    tmp1,8
     6946 0008     
0070 6948 1AFA  14         jl    realk6
0071 694A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 694C 1BEB  14         jh    realk5                ; No, next column
0073 694E 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 6950 C206  18 realk8  mov   tmp2,tmp4
0078 6952 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 6954 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 6956 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 6958 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 695A 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 695C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 695E 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     6960 200C     
0089 6962 1608  14         jne   realka                ; No, continue saving key
0090 6964 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6966 2968     
0091 6968 1A05  14         jl    realka
0092 696A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     696C 2966     
0093 696E 1B02  14         jh    realka                ; No, continue
0094 6970 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     6972 E000     
0095 6974 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6976 833C     
0096 6978 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     697A 200A     
0097 697C 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     697E 8C00     
0098                                                   ; / using R15 as temp storage
0099 6980 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 6982 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6984 0000     
     6986 FF0D     
     6988 203D     
0102 698A 7877             text  'xws29ol.'
     698C 7332     
     698E 396F     
     6990 6C2E     
0103 6992 6365             text  'ced38ik,'
     6994 6433     
     6996 3869     
     6998 6B2C     
0104 699A 7672             text  'vrf47ujm'
     699C 6634     
     699E 3775     
     69A0 6A6D     
0105 69A2 6274             text  'btg56yhn'
     69A4 6735     
     69A6 3679     
     69A8 686E     
0106 69AA 7A71             text  'zqa10p;/'
     69AC 6131     
     69AE 3070     
     69B0 3B2F     
0107 69B2 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     69B4 0000     
     69B6 FF0D     
     69B8 202B     
0108 69BA 5857             text  'XWS@(OL>'
     69BC 5340     
     69BE 284F     
     69C0 4C3E     
0109 69C2 4345             text  'CED#*IK<'
     69C4 4423     
     69C6 2A49     
     69C8 4B3C     
0110 69CA 5652             text  'VRF$&UJM'
     69CC 4624     
     69CE 2655     
     69D0 4A4D     
0111 69D2 4254             text  'BTG%^YHN'
     69D4 4725     
     69D6 5E59     
     69D8 484E     
0112 69DA 5A51             text  'ZQA!)P:-'
     69DC 4121     
     69DE 2950     
     69E0 3A2D     
0113 69E2 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     69E4 0000     
     69E6 FF0D     
     69E8 2005     
0114 69EA 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     69EC 0804     
     69EE 0F27     
     69F0 C2B9     
0115 69F2 600B             data  >600b,>0907,>063f,>c1B8
     69F4 0907     
     69F6 063F     
     69F8 C1B8     
0116 69FA 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     69FC 7B02     
     69FE 015F     
     6A00 C0C3     
0117 6A02 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6A04 7D0E     
     6A06 0CC6     
     6A08 BFC4     
0118 6A0A 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6A0C 7C03     
     6A0E BC22     
     6A10 BDBA     
0119 6A12 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6A14 0000     
     6A16 FF0D     
     6A18 209D     
0120 6A1A 9897             data  >9897,>93b2,>9f8f,>8c9B
     6A1C 93B2     
     6A1E 9F8F     
     6A20 8C9B     
0121 6A22 8385             data  >8385,>84b3,>9e89,>8b80
     6A24 84B3     
     6A26 9E89     
     6A28 8B80     
0122 6A2A 9692             data  >9692,>86b4,>b795,>8a8D
     6A2C 86B4     
     6A2E B795     
     6A30 8A8D     
0123 6A32 8294             data  >8294,>87b5,>b698,>888E
     6A34 87B5     
     6A36 B698     
     6A38 888E     
0124 6A3A 9A91             data  >9a91,>81b1,>b090,>9cBB
     6A3C 81B1     
     6A3E B090     
     6A40 9CBB     
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
0023 6A42 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6A44 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6A46 8340     
0025 6A48 04E0  34         clr   @waux1
     6A4A 833C     
0026 6A4C 04E0  34         clr   @waux2
     6A4E 833E     
0027 6A50 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6A52 833C     
0028 6A54 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6A56 0205  20         li    tmp1,4                ; 4 nibbles
     6A58 0004     
0033 6A5A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6A5C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6A5E 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A60 0286  22         ci    tmp2,>000a
     6A62 000A     
0039 6A64 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A66 C21B  26         mov   *r11,tmp4
0045 6A68 0988  56         srl   tmp4,8                ; Right justify
0046 6A6A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A6C FFF6     
0047 6A6E 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A70 C21B  26         mov   *r11,tmp4
0054 6A72 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A74 00FF     
0055               
0056 6A76 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A78 06C6  14         swpb  tmp2
0058 6A7A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A7C 0944  56         srl   tmp0,4                ; Next nibble
0060 6A7E 0605  14         dec   tmp1
0061 6A80 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A82 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A84 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A86 C160  34         mov   @waux3,tmp1           ; Get pointer
     6A88 8340     
0067 6A8A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6A8C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6A8E C120  34         mov   @waux2,tmp0
     6A90 833E     
0070 6A92 06C4  14         swpb  tmp0
0071 6A94 DD44  32         movb  tmp0,*tmp1+
0072 6A96 06C4  14         swpb  tmp0
0073 6A98 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6A9A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6A9C 8340     
0078 6A9E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6AA0 2016     
0079 6AA2 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6AA4 C120  34         mov   @waux1,tmp0
     6AA6 833C     
0084 6AA8 06C4  14         swpb  tmp0
0085 6AAA DD44  32         movb  tmp0,*tmp1+
0086 6AAC 06C4  14         swpb  tmp0
0087 6AAE DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6AB0 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6AB2 2020     
0092 6AB4 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6AB6 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6AB8 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6ABA 7FFF     
0098 6ABC C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6ABE 8340     
0099 6AC0 0460  28         b     @xutst0               ; Display string
     6AC2 2416     
0100 6AC4 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6AC6 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6AC8 832A     
0122 6ACA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6ACC 8000     
0123 6ACE 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6AD0 0207  20 mknum   li    tmp3,5                ; Digit counter
     6AD2 0005     
0020 6AD4 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6AD6 C155  26         mov   *tmp1,tmp1            ; /
0022 6AD8 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6ADA 0228  22         ai    tmp4,4                ; Get end of buffer
     6ADC 0004     
0024 6ADE 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6AE0 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6AE2 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6AE4 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6AE6 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6AE8 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6AEA D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6AEC C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6AEE 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6AF0 0607  14         dec   tmp3                  ; Decrease counter
0036 6AF2 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6AF4 0207  20         li    tmp3,4                ; Check first 4 digits
     6AF6 0004     
0041 6AF8 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6AFA C11B  26         mov   *r11,tmp0
0043 6AFC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6AFE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6B00 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6B02 05CB  14 mknum3  inct  r11
0047 6B04 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B06 2020     
0048 6B08 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6B0A 045B  20         b     *r11                  ; Exit
0050 6B0C DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6B0E 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6B10 13F8  14         jeq   mknum3                ; Yes, exit
0053 6B12 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6B14 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6B16 7FFF     
0058 6B18 C10B  18         mov   r11,tmp0
0059 6B1A 0224  22         ai    tmp0,-4
     6B1C FFFC     
0060 6B1E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6B20 0206  20         li    tmp2,>0500            ; String length = 5
     6B22 0500     
0062 6B24 0460  28         b     @xutstr               ; Display string
     6B26 2418     
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
0093 6B28 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6B2A C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6B2C C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6B2E 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6B30 0207  20         li    tmp3,5                ; Set counter
     6B32 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6B34 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6B36 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6B38 0584  14         inc   tmp0                  ; Next character
0105 6B3A 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6B3C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6B3E 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6B40 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6B42 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6B44 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6B46 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6B48 0607  14         dec   tmp3                  ; Last character ?
0121 6B4A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6B4C 045B  20         b     *r11                  ; Return
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
0139 6B4E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6B50 832A     
0140 6B52 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B54 8000     
0141 6B56 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6B58 0649  14         dect  stack
0023 6B5A C64B  30         mov   r11,*stack            ; Save return address
0024 6B5C 0649  14         dect  stack
0025 6B5E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B60 0649  14         dect  stack
0027 6B62 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B64 0649  14         dect  stack
0029 6B66 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B68 0649  14         dect  stack
0031 6B6A C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B6C C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B6E C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B70 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B72 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B74 0649  14         dect  stack
0044 6B76 C64B  30         mov   r11,*stack            ; Save return address
0045 6B78 0649  14         dect  stack
0046 6B7A C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B7C 0649  14         dect  stack
0048 6B7E C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B80 0649  14         dect  stack
0050 6B82 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B84 0649  14         dect  stack
0052 6B86 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6B88 C1D4  26 !       mov   *tmp0,tmp3
0057 6B8A 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6B8C 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6B8E 00FF     
0059 6B90 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6B92 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6B94 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6B96 0584  14         inc   tmp0                  ; Next byte
0067 6B98 0607  14         dec   tmp3                  ; Shorten string length
0068 6B9A 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6B9C 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6B9E 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6BA0 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6BA2 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6BA4 C187  18         mov   tmp3,tmp2
0078 6BA6 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6BA8 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6BAA 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6BAC 24D6     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6BAE 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6BB0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BB2 FFCE     
0090 6BB4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BB6 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6BB8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6BBA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6BBC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6BBE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6BC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6BC2 045B  20         b     *r11                  ; Return to caller
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
0123 6BC4 0649  14         dect  stack
0124 6BC6 C64B  30         mov   r11,*stack            ; Save return address
0125 6BC8 05D9  26         inct  *stack                ; Skip "data P0"
0126 6BCA 05D9  26         inct  *stack                ; Skip "data P1"
0127 6BCC 0649  14         dect  stack
0128 6BCE C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6BD0 0649  14         dect  stack
0130 6BD2 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6BD4 0649  14         dect  stack
0132 6BD6 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6BD8 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6BDA C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6BDC 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6BDE 0649  14         dect  stack
0144 6BE0 C64B  30         mov   r11,*stack            ; Save return address
0145 6BE2 0649  14         dect  stack
0146 6BE4 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6BE6 0649  14         dect  stack
0148 6BE8 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6BEA 0649  14         dect  stack
0150 6BEC C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6BEE 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6BF0 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6BF2 0586  14         inc   tmp2
0161 6BF4 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6BF6 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6BF8 0286  22         ci    tmp2,255
     6BFA 00FF     
0167 6BFC 1505  14         jgt   string.getlenc.panic
0168 6BFE 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6C00 0606  14         dec   tmp2                  ; One time adjustment
0174 6C02 C806  38         mov   tmp2,@waux1           ; Store length
     6C04 833C     
0175 6C06 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6C08 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C0A FFCE     
0181 6C0C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C0E 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6C10 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6C12 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6C14 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6C16 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6C18 045B  20         b     *r11                  ; Return to caller
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
0023 6C1A C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6C1C F960     
0024 6C1E C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6C20 F962     
0025 6C22 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6C24 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6C26 0200  20         li    r0,>8306              ; Scratchpad source address
     6C28 8306     
0030 6C2A 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6C2C F966     
0031 6C2E 0202  20         li    r2,62                 ; Loop counter
     6C30 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 6C32 CC70  46         mov   *r0+,*r1+
0037 6C34 CC70  46         mov   *r0+,*r1+
0038 6C36 0642  14         dect  r2
0039 6C38 16FC  14         jne   cpu.scrpad.backup.copy
0040 6C3A C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6C3C 83FE     
     6C3E FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6C40 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6C42 F960     
0046 6C44 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6C46 F962     
0047 6C48 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6C4A F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 6C4C 045B  20         b     *r11                  ; Return to caller
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
0069 6C4E 0649  14         dect  stack
0070 6C50 C64B  30         mov   r11,*stack            ; Save return address
0071 6C52 0649  14         dect  stack
0072 6C54 C640  30         mov   r0,*stack             ; Push r0
0073 6C56 0649  14         dect  stack
0074 6C58 C641  30         mov   r1,*stack             ; Push r1
0075 6C5A 0649  14         dect  stack
0076 6C5C C642  30         mov   r2,*stack             ; Push r2
0077                       ;------------------------------------------------------
0078                       ; Prepare for copy loop, WS
0079                       ;------------------------------------------------------
0080 6C5E 0200  20         li    r0,cpu.scrpad.tgt
     6C60 F960     
0081 6C62 0201  20         li    r1,>8300
     6C64 8300     
0082 6C66 0202  20         li    r2,64
     6C68 0040     
0083                       ;------------------------------------------------------
0084                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0085                       ;------------------------------------------------------
0086               cpu.scrpad.restore.copy:
0087 6C6A CC70  46         mov   *r0+,*r1+
0088 6C6C CC70  46         mov   *r0+,*r1+
0089 6C6E 0602  14         dec   r2
0090 6C70 16FC  14         jne   cpu.scrpad.restore.copy
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               cpu.scrpad.restore.exit:
0095 6C72 C0B9  30         mov   *stack+,r2            ; Pop r2
0096 6C74 C079  30         mov   *stack+,r1            ; Pop r1
0097 6C76 C039  30         mov   *stack+,r0            ; Pop r0
0098 6C78 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 6C7A 045B  20         b     *r11                  ; Return to caller
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
0038 6C7C C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 6C7E CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 6C80 CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 6C82 CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 6C84 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 6C86 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 6C88 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 6C8A CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 6C8C CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 6C8E 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     6C90 8310     
0055                                                   ;        as of register r8
0056 6C92 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     6C94 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 6C96 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 6C98 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 6C9A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 6C9C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 6C9E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 6CA0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 6CA2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 6CA4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 6CA6 0606  14         dec   tmp2
0069 6CA8 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 6CAA C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 6CAC 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6CAE 2C70     
0075                                                   ; R14=PC
0076 6CB0 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 6CB2 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 6CB4 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6CB6 2C0A     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 6CB8 045B  20         b     *r11                  ; Return to caller
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
0119 6CBA C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0120                       ;------------------------------------------------------
0121                       ; Copy scratchpad memory to destination
0122                       ;------------------------------------------------------
0123               xcpu.scrpad.pgin:
0124 6CBC 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6CBE 8300     
0125 6CC0 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6CC2 0010     
0126                       ;------------------------------------------------------
0127                       ; Copy memory
0128                       ;------------------------------------------------------
0129 6CC4 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0130 6CC6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0131 6CC8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0132 6CCA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0133 6CCC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0134 6CCE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0135 6CD0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0136 6CD2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0137 6CD4 0606  14         dec   tmp2
0138 6CD6 16F6  14         jne   -!                    ; Loop until done
0139                       ;------------------------------------------------------
0140                       ; Switch workspace to scratchpad memory
0141                       ;------------------------------------------------------
0142 6CD8 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6CDA 8300     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               cpu.scrpad.pgin.exit:
0147 6CDC 045B  20         b     *r11                  ; Return to caller
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
0056 6CDE A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6CE0 2C9E             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6CE2 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6CE4 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6CE6 A428     
0064 6CE8 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6CEA 201C     
0065 6CEC C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6CEE 8356     
0066 6CF0 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6CF2 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6CF4 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6CF6 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6CF8 A434     
0073                       ;---------------------------; Inline VSBR start
0074 6CFA 06C0  14         swpb  r0                    ;
0075 6CFC D800  38         movb  r0,@vdpa              ; Send low byte
     6CFE 8C02     
0076 6D00 06C0  14         swpb  r0                    ;
0077 6D02 D800  38         movb  r0,@vdpa              ; Send high byte
     6D04 8C02     
0078 6D06 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6D08 8800     
0079                       ;---------------------------; Inline VSBR end
0080 6D0A 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6D0C 0704  14         seto  r4                    ; Init counter
0086 6D0E 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D10 A420     
0087 6D12 0580  14 !       inc   r0                    ; Point to next char of name
0088 6D14 0584  14         inc   r4                    ; Increment char counter
0089 6D16 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6D18 0007     
0090 6D1A 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6D1C 80C4  18         c     r4,r3                 ; End of name?
0093 6D1E 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6D20 06C0  14         swpb  r0                    ;
0098 6D22 D800  38         movb  r0,@vdpa              ; Send low byte
     6D24 8C02     
0099 6D26 06C0  14         swpb  r0                    ;
0100 6D28 D800  38         movb  r0,@vdpa              ; Send high byte
     6D2A 8C02     
0101 6D2C D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6D2E 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6D30 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6D32 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6D34 2E06     
0109 6D36 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6D38 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6D3A 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6D3C 04E0  34         clr   @>83d0
     6D3E 83D0     
0118 6D40 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6D42 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6D44 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6D46 A432     
0121               
0122 6D48 0584  14         inc   r4                    ; Adjust for dot
0123 6D4A A804  38         a     r4,@>8356             ; Point to position after name
     6D4C 8356     
0124 6D4E C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6D50 8356     
     6D52 A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6D54 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D56 83E0     
0130 6D58 04C1  14         clr   r1                    ; Version found of dsr
0131 6D5A 020C  20         li    r12,>0f00             ; Init cru address
     6D5C 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6D5E C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6D60 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6D62 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6D64 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6D66 0100     
0145 6D68 04E0  34         clr   @>83d0                ; Clear in case we are done
     6D6A 83D0     
0146 6D6C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D6E 2000     
0147 6D70 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6D72 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6D74 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6D76 1D00  20         sbo   0                     ; Turn on ROM
0154 6D78 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6D7A 4000     
0155 6D7C 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6D7E 2E02     
0156 6D80 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6D82 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6D84 A40A     
0166 6D86 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6D88 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6D8A 83D2     
0172                                                   ; subprogram
0173               
0174 6D8C 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6D8E C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6D90 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6D92 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6D94 83D2     
0183                                                   ; subprogram
0184               
0185 6D96 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6D98 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6D9A 04C5  14         clr   r5                    ; Remove any old stuff
0194 6D9C D160  34         movb  @>8355,r5             ; Get length as counter
     6D9E 8355     
0195 6DA0 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6DA2 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6DA4 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6DA6 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6DA8 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6DAA A420     
0206 6DAC 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6DAE 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6DB0 0605  14         dec   r5                    ; Update loop counter
0211 6DB2 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6DB4 0581  14         inc   r1                    ; Next version found
0217 6DB6 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6DB8 A42A     
0218 6DBA C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6DBC A42C     
0219 6DBE C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6DC0 A430     
0220               
0221 6DC2 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6DC4 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6DC6 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6DC8 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6DCA 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6DCC 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6DCE A400     
0233 6DD0 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6DD2 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6DD4 A428     
0239                                                   ; (8 or >a)
0240 6DD6 0281  22         ci    r1,8                  ; was it 8?
     6DD8 0008     
0241 6DDA 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6DDC D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6DDE 8350     
0243                                                   ; Get error byte from @>8350
0244 6DE0 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6DE2 06C0  14         swpb  r0                    ;
0252 6DE4 D800  38         movb  r0,@vdpa              ; send low byte
     6DE6 8C02     
0253 6DE8 06C0  14         swpb  r0                    ;
0254 6DEA D800  38         movb  r0,@vdpa              ; send high byte
     6DEC 8C02     
0255 6DEE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6DF0 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6DF2 09D1  56         srl   r1,13                 ; just keep error bits
0263 6DF4 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6DF6 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6DF8 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6DFA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6DFC A400     
0275               dsrlnk.error.devicename_invalid:
0276 6DFE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6E00 06C1  14         swpb  r1                    ; put error in hi byte
0279 6E02 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6E04 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6E06 201C     
0281                                                   ; / to indicate error
0282 6E08 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6E0A A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6E0C 2DCA             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6E0E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E10 83E0     
0316               
0317 6E12 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6E14 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6E16 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6E18 A42A     
0322 6E1A C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6E1C C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6E1E C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6E20 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6E22 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6E24 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6E26 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6E28 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E2A 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6E2C 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6E2E 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6E30 4000     
     6E32 2E02     
0337 6E34 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6E36 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6E38 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6E3A 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6E3C 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6E3E A400     
0355 6E40 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6E42 A434     
0356               
0357 6E44 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6E46 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6E48 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6E4A 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6E4C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6E4E C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6E50 0649  14         dect  stack
0052 6E52 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6E54 0204  20         li    tmp0,dsrlnk.savcru
     6E56 A42A     
0057 6E58 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6E5A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6E5C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6E5E 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6E60 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6E62 37D7     
0065 6E64 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6E66 8370     
0066                                                   ; / location
0067 6E68 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6E6A A44C     
0068 6E6C 04C5  14         clr   tmp1                  ; io.op.open
0069 6E6E 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6E70 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6E72 0649  14         dect  stack
0097 6E74 C64B  30         mov   r11,*stack            ; Save return address
0098 6E76 0205  20         li    tmp1,io.op.close      ; io.op.close
     6E78 0001     
0099 6E7A 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6E7C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6E7E 0649  14         dect  stack
0125 6E80 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6E82 0205  20         li    tmp1,io.op.read       ; io.op.read
     6E84 0002     
0128 6E86 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6E88 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6E8A 0649  14         dect  stack
0155 6E8C C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6E8E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6E90 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6E92 0005     
0159               
0160 6E94 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6E96 A43E     
0161               
0162 6E98 06A0  32         bl    @xvputb               ; Write character count to PAB
     6E9A 22C2     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6E9C 0205  20         li    tmp1,io.op.write      ; io.op.write
     6E9E 0003     
0167 6EA0 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6EA2 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6EA4 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6EA6 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6EA8 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6EAA 1000  14         nop
0189               
0190               
0191               file.status:
0192 6EAC 1000  14         nop
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
0227 6EAE C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6EB0 A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6EB2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6EB4 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6EB6 A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6EB8 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6EBA 22C2     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6EBC C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6EBE 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6EC0 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6EC2 A44C     
0246               
0247 6EC4 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6EC6 22C2     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6EC8 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6ECA 0009     
0254 6ECC C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6ECE 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6ED0 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6ED2 8322     
     6ED4 833C     
0259               
0260 6ED6 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6ED8 A42A     
0261 6EDA 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6EDC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EDE 2C9A     
0268 6EE0 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6EE2 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6EE4 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6EE6 2DC6     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6EE8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6EEA C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6EEC 833C     
     6EEE 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6EF0 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6EF2 A436     
0292 6EF4 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6EF6 0005     
0293 6EF8 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6EFA 22DA     
0294 6EFC C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6EFE C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6F00 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6F02 045B  20         b     *r11                  ; Return to caller
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
0020 6F04 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F06 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F08 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F0A 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F0C 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F0E 201C     
0029 6F10 1602  14         jne   tmgr1a                ; No, so move on
0030 6F12 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F14 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F16 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F18 2020     
0035 6F1A 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F1C 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F1E 2010     
0048 6F20 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F22 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F24 200E     
0050 6F26 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F28 0460  28         b     @kthread              ; Run kernel thread
     6F2A 2F5E     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F2C 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F2E 2014     
0056 6F30 13EB  14         jeq   tmgr1
0057 6F32 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F34 2012     
0058 6F36 16E8  14         jne   tmgr1
0059 6F38 C120  34         mov   @wtiusr,tmp0
     6F3A 832E     
0060 6F3C 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F3E 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F40 2F5C     
0065 6F42 C10A  18         mov   r10,tmp0
0066 6F44 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F46 00FF     
0067 6F48 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F4A 201C     
0068 6F4C 1303  14         jeq   tmgr5
0069 6F4E 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F50 003C     
0070 6F52 1002  14         jmp   tmgr6
0071 6F54 0284  22 tmgr5   ci    tmp0,50
     6F56 0032     
0072 6F58 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F5A 1001  14         jmp   tmgr8
0074 6F5C 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F5E C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F60 832C     
0079 6F62 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F64 FF00     
0080 6F66 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F68 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F6A 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F6C 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F6E C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F70 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F72 830C     
     6F74 830D     
0089 6F76 1608  14         jne   tmgr10                ; No, get next slot
0090 6F78 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F7A FF00     
0091 6F7C C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F7E C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F80 8330     
0096 6F82 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6F84 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6F86 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6F88 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6F8A 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6F8C 8315     
     6F8E 8314     
0103 6F90 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6F92 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6F94 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6F96 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6F98 10F7  14         jmp   tmgr10                ; Process next slot
0108 6F9A 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6F9C FF00     
0109 6F9E 10B4  14         jmp   tmgr1
0110 6FA0 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6FA2 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FA4 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6FA6 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6FA8 2006     
0023 6FAA 1602  14         jne   kthread_kb
0024 6FAC 06A0  32         bl    @sdpla1               ; Run sound player
     6FAE 2822     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FB0 06A0  32         bl    @realkb               ; Scan full keyboard
     6FB2 28A2     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FB4 0460  28         b     @tmgr3                ; Exit
     6FB6 2EE8     
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
0017 6FB8 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FBA 832E     
0018 6FBC E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FBE 2012     
0019 6FC0 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EC4     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6FC2 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FC4 832E     
0029 6FC6 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FC8 FEFF     
0030 6FCA 045B  20         b     *r11                  ; Return
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
0017 6FCC C13B  30 mkslot  mov   *r11+,tmp0
0018 6FCE C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6FD0 C184  18         mov   tmp0,tmp2
0023 6FD2 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6FD4 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6FD6 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6FD8 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6FDA 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6FDC C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6FDE 881B  46         c     *r11,@w$ffff          ; End of list ?
     6FE0 2022     
0035 6FE2 1301  14         jeq   mkslo1                ; Yes, exit
0036 6FE4 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6FE6 05CB  14 mkslo1  inct  r11
0041 6FE8 045B  20         b     *r11                  ; Exit
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
0052 6FEA C13B  30 clslot  mov   *r11+,tmp0
0053 6FEC 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6FEE A120  34         a     @wtitab,tmp0          ; Add table base
     6FF0 832C     
0055 6FF2 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6FF4 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6FF6 045B  20         b     *r11                  ; Exit
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
0068 6FF8 C13B  30 rsslot  mov   *r11+,tmp0
0069 6FFA 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6FFC A120  34         a     @wtitab,tmp0          ; Add table base
     6FFE 832C     
0071 7000 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 7002 C154  26         mov   *tmp0,tmp1
0073 7004 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     7006 FF00     
0074 7008 C505  30         mov   tmp1,*tmp0
0075 700A 045B  20         b     *r11                  ; Exit
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
0261 700C 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     700E 8302     
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 7010 0300  24 runli1  limi  0                     ; Turn off interrupts
     7012 0000     
0267 7014 02E0  18         lwpi  ws1                   ; Activate workspace 1
     7016 8300     
0268 7018 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     701A 83C0     
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 701C 0202  20 runli2  li    r2,>8308
     701E 8308     
0273 7020 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 7022 0282  22         ci    r2,>8400
     7024 8400     
0275 7026 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 7028 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     702A FFFF     
0280 702C 1602  14         jne   runli4                ; No, continue
0281 702E 0420  54         blwp  @0                    ; Yes, bye bye
     7030 0000     
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 7032 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7034 833C     
0286 7036 04C1  14         clr   r1                    ; Reset counter
0287 7038 0202  20         li    r2,10                 ; We test 10 times
     703A 000A     
0288 703C C0E0  34 runli5  mov   @vdps,r3
     703E 8802     
0289 7040 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7042 2020     
0290 7044 1302  14         jeq   runli6
0291 7046 0581  14         inc   r1                    ; Increase counter
0292 7048 10F9  14         jmp   runli5
0293 704A 0602  14 runli6  dec   r2                    ; Next test
0294 704C 16F7  14         jne   runli5
0295 704E 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7050 1250     
0296 7052 1202  14         jle   runli7                ; No, so it must be NTSC
0297 7054 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     7056 201C     
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 7058 06A0  32 runli7  bl    @loadmc
     705A 2210     
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 705C 04C1  14 runli9  clr   r1
0306 705E 04C2  14         clr   r2
0307 7060 04C3  14         clr   r3
0308 7062 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     7064 AF00     
0309 7066 020F  20         li    r15,vdpw              ; Set VDP write address
     7068 8C00     
0311 706A 06A0  32         bl    @mute                 ; Mute sound generators
     706C 27E6     
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 706E 0280  22         ci    r0,>4a4a              ; Crash flag set?
     7070 4A4A     
0318 7072 1605  14         jne   runlia
0319 7074 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7076 2284     
0320 7078 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     707A 0000     
     707C 3000     
0325 707E 06A0  32 runlia  bl    @filv
     7080 2284     
0326 7082 0FC0             data  pctadr,spfclr,16      ; Load color table
     7084 00F4     
     7086 0010     
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 7088 06A0  32         bl    @f18unl               ; Unlock the F18A
     708A 2728     
0334 708C 06A0  32         bl    @f18chk               ; Check if F18A is there \
     708E 2748     
0335 7090 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     7092 2748     
0336 7094 06A0  32         bl    @f18chk               ; Check if F18A is there /
     7096 2748     
0337 7098 06A0  32         bl    @f18lck               ; Lock the F18A again
     709A 273E     
0338               
0339 709C 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     709E 2328     
0340 70A0 3201                   data >3201            ; F18a VR50 (>32), bit 1
0342               *--------------------------------------------------------------
0343               * Check if there is a speech synthesizer attached
0344               *--------------------------------------------------------------
0346               *       <<skipped>>
0350               *--------------------------------------------------------------
0351               * Load video mode table & font
0352               *--------------------------------------------------------------
0353 70A2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70A4 22EE     
0354 70A6 342E             data  spvmod                ; Equate selected video mode table
0355 70A8 0204  20         li    tmp0,spfont           ; Get font option
     70AA 000C     
0356 70AC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0357 70AE 1304  14         jeq   runlid                ; Yes, skip it
0358 70B0 06A0  32         bl    @ldfnt
     70B2 2356     
0359 70B4 1100             data  fntadr,spfont         ; Load specified font
     70B6 000C     
0360               *--------------------------------------------------------------
0361               * Did a system crash occur before runlib was called?
0362               *--------------------------------------------------------------
0363 70B8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70BA 4A4A     
0364 70BC 1602  14         jne   runlie                ; No, continue
0365 70BE 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     70C0 2086     
0366               *--------------------------------------------------------------
0367               * Branch to main program
0368               *--------------------------------------------------------------
0369 70C2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70C4 0040     
0370 70C6 0460  28         b     @main                 ; Give control to main program
     70C8 6046     
                   < stevie_b4.asm.9883
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
0021 70CA C13B  30         mov   *r11+,tmp0            ; P0
0022 70CC C17B  30         mov   *r11+,tmp1            ; P1
0023 70CE C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 70D0 0649  14         dect  stack
0029 70D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 70D4 0649  14         dect  stack
0031 70D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 70D8 0649  14         dect  stack
0033 70DA C646  30         mov   tmp2,*stack           ; Push tmp2
0034 70DC 0649  14         dect  stack
0035 70DE C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 70E0 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     70E2 6000     
0040 70E4 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 70E6 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     70E8 A226     
0044 70EA 0647  14         dect  tmp3
0045 70EC C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 70EE 0647  14         dect  tmp3
0047 70F0 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 70F2 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     70F4 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 70F6 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 70F8 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 70FA 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 70FC 0224  22         ai    tmp0,>0800
     70FE 0800     
0066 7100 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 7102 0285  22         ci    tmp1,>ffff
     7104 FFFF     
0075 7106 1602  14         jne   !
0076 7108 C160  34         mov   @parm1,tmp1
     710A A000     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 710C C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 710E 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 7110 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 7112 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7114 FFCE     
0092 7116 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7118 2026     
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 711A 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 711C C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     711E A226     
0103 7120 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 7122 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 7124 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 7126 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 7128 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 712A 028B  22         ci    r11,>6000
     712C 6000     
0116 712E 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 7130 028B  22         ci    r11,>7fff
     7132 7FFF     
0118 7134 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 7136 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     7138 A226     
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 713A 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 713C 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 713E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 7140 0225  22         ai    tmp1,>0800
     7142 0800     
0138 7144 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 7146 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 7148 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     714A FFCE     
0145 714C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     714E 2026     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 7150 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 7152 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 7154 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 7156 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 7158 045B  20         b     *r11                  ; Return to caller
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
0020 715A 0649  14         dect  stack
0021 715C C64B  30         mov   r11,*stack            ; Save return address
0022 715E 0649  14         dect  stack
0023 7160 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 7162 0649  14         dect  stack
0025 7164 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7166 0204  20         li    tmp0,fb.top
     7168 D000     
0030 716A C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     716C A300     
0031 716E 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     7170 A304     
0032 7172 04E0  34         clr   @fb.row               ; Current row=0
     7174 A306     
0033 7176 04E0  34         clr   @fb.column            ; Current column=0
     7178 A30C     
0034               
0035 717A 0204  20         li    tmp0,colrow
     717C 0050     
0036 717E C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7180 A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 7182 C160  34         mov   @tv.ruler.visible,tmp1
     7184 A210     
0041 7186 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 7188 0204  20         li    tmp0,pane.botrow-2
     718A 001B     
0043 718C 1002  14         jmp   fb.init.cont
0044 718E 0204  20 !       li    tmp0,pane.botrow-1
     7190 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 7192 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     7194 A31A     
0050 7196 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     7198 A31C     
0051               
0052 719A 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     719C A222     
0053 719E 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     71A0 A310     
0054 71A2 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     71A4 A316     
0055 71A6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     71A8 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 71AA 06A0  32         bl    @film
     71AC 222C     
0060 71AE D000             data  fb.top,>00,fb.size    ; Clear it all the way
     71B0 0000     
     71B2 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 71B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 71B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 71B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 71BA 045B  20         b     *r11                  ; Return to caller
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
0051 71BC 0649  14         dect  stack
0052 71BE C64B  30         mov   r11,*stack            ; Save return address
0053 71C0 0649  14         dect  stack
0054 71C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 71C4 0204  20         li    tmp0,idx.top
     71C6 B000     
0059 71C8 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     71CA A502     
0060               
0061 71CC C120  34         mov   @tv.sams.b000,tmp0
     71CE A206     
0062 71D0 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     71D2 A600     
0063 71D4 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     71D6 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 71D8 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     71DA 0004     
0068 71DC C804  38         mov   tmp0,@idx.sams.hipage ; /
     71DE A604     
0069               
0070 71E0 06A0  32         bl    @_idx.sams.mapcolumn.on
     71E2 31BA     
0071                                                   ; Index in continuous memory region
0072               
0073 71E4 06A0  32         bl    @film
     71E6 222C     
0074 71E8 B000                   data idx.top,>00,idx.size * 5
     71EA 0000     
     71EC 5000     
0075                                                   ; Clear index
0076               
0077 71EE 06A0  32         bl    @_idx.sams.mapcolumn.off
     71F0 31EE     
0078                                                   ; Restore memory window layout
0079               
0080 71F2 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     71F4 A602     
     71F6 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 71F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 71FA C2F9  30         mov   *stack+,r11           ; Pop r11
0088 71FC 045B  20         b     *r11                  ; Return to caller
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
0101 71FE 0649  14         dect  stack
0102 7200 C64B  30         mov   r11,*stack            ; Push return address
0103 7202 0649  14         dect  stack
0104 7204 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 7206 0649  14         dect  stack
0106 7208 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 720A 0649  14         dect  stack
0108 720C C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 720E C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     7210 A602     
0113 7212 0205  20         li    tmp1,idx.top
     7214 B000     
0114 7216 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     7218 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 721A 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     721C 256C     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 721E 0584  14         inc   tmp0                  ; Next SAMS index page
0123 7220 0225  22         ai    tmp1,>1000            ; Next memory region
     7222 1000     
0124 7224 0606  14         dec   tmp2                  ; Update loop counter
0125 7226 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 7228 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 722A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 722C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 722E C2F9  30         mov   *stack+,r11           ; Pop return address
0134 7230 045B  20         b     *r11                  ; Return to caller
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
0150 7232 0649  14         dect  stack
0151 7234 C64B  30         mov   r11,*stack            ; Push return address
0152 7236 0649  14         dect  stack
0153 7238 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 723A 0649  14         dect  stack
0155 723C C645  30         mov   tmp1,*stack           ; Push tmp1
0156 723E 0649  14         dect  stack
0157 7240 C646  30         mov   tmp2,*stack           ; Push tmp2
0158 7242 0649  14         dect  stack
0159 7244 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 7246 0205  20         li    tmp1,idx.top
     7248 B000     
0164 724A 0206  20         li    tmp2,5                ; Always 5 pages
     724C 0005     
0165 724E 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     7250 A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 7252 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 7254 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7256 256C     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 7258 0225  22         ai    tmp1,>1000            ; Next memory region
     725A 1000     
0176 725C 0606  14         dec   tmp2                  ; Update loop counter
0177 725E 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 7260 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 7262 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 7264 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 7266 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 7268 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 726A 045B  20         b     *r11                  ; Return to caller
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
0211 726C 0649  14         dect  stack
0212 726E C64B  30         mov   r11,*stack            ; Save return address
0213 7270 0649  14         dect  stack
0214 7272 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 7274 0649  14         dect  stack
0216 7276 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 7278 0649  14         dect  stack
0218 727A C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 727C C184  18         mov   tmp0,tmp2             ; Line number
0223 727E 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 7280 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     7282 0800     
0225               
0226 7284 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 7286 0A16  56         sla   tmp2,1                ; line number * 2
0231 7288 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     728A A010     
0232               
0233 728C A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     728E A602     
0234 7290 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     7292 A600     
0235               
0236 7294 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 7296 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     7298 A600     
0242 729A C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     729C A206     
0243               
0244 729E C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0245 72A0 0205  20         li    tmp1,>b000            ; Memory window for index page
     72A2 B000     
0246               
0247 72A4 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     72A6 256C     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 72A8 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     72AA A604     
0254 72AC 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 72AE C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     72B0 A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 72B2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 72B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 72B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 72B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 72BA 045B  20         b     *r11                  ; Return to caller
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
0022 72BC 0649  14         dect  stack
0023 72BE C64B  30         mov   r11,*stack            ; Save return address
0024 72C0 0649  14         dect  stack
0025 72C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72C4 0204  20         li    tmp0,edb.top          ; \
     72C6 C000     
0030 72C8 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     72CA A500     
0031 72CC C804  38         mov   tmp0,@edb.next_free.ptr
     72CE A508     
0032                                                   ; Set pointer to next free line
0033               
0034 72D0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     72D2 A50A     
0035               
0036 72D4 0204  20         li    tmp0,1
     72D6 0001     
0037 72D8 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     72DA A504     
0038               
0039 72DC 0720  34         seto  @edb.block.m1         ; Reset block start line
     72DE A50C     
0040 72E0 0720  34         seto  @edb.block.m2         ; Reset block end line
     72E2 A50E     
0041               
0042 72E4 0204  20         li    tmp0,txt.newfile      ; "New file"
     72E6 35B2     
0043 72E8 C804  38         mov   tmp0,@edb.filename.ptr
     72EA A512     
0044               
0045 72EC 0204  20         li    tmp0,txt.filetype.none
     72EE 3664     
0046 72F0 C804  38         mov   tmp0,@edb.filetype.ptr
     72F2 A514     
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 72F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 72F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 72F8 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
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
0022 72FA 0649  14         dect  stack
0023 72FC C64B  30         mov   r11,*stack            ; Save return address
0024 72FE 0649  14         dect  stack
0025 7300 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7302 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     7304 E000     
0030 7306 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     7308 A700     
0031               
0032 730A 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     730C A702     
0033 730E 0204  20         li    tmp0,4
     7310 0004     
0034 7312 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     7314 A706     
0035 7316 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     7318 A708     
0036               
0037 731A 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     731C A716     
0038 731E 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     7320 A718     
0039 7322 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     7324 A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7326 06A0  32         bl    @film
     7328 222C     
0044 732A E000             data  cmdb.top,>00,cmdb.size
     732C 0000     
     732E 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7330 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 7332 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 7334 045B  20         b     *r11                  ; Return to caller
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
0022 7336 0649  14         dect  stack
0023 7338 C64B  30         mov   r11,*stack            ; Save return address
0024 733A 0649  14         dect  stack
0025 733C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 733E 04E0  34         clr   @tv.error.visible     ; Set to hidden
     7340 A228     
0030               
0031 7342 06A0  32         bl    @film
     7344 222C     
0032 7346 A22A                   data tv.error.msg,0,160
     7348 0000     
     734A 00A0     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 734C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 734E C2F9  30         mov   *stack+,r11           ; Pop R11
0039 7350 045B  20         b     *r11                  ; Return to caller
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
0022 7352 0649  14         dect  stack
0023 7354 C64B  30         mov   r11,*stack            ; Save return address
0024 7356 0649  14         dect  stack
0025 7358 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 735A 0204  20         li    tmp0,1                ; \ Set default color scheme
     735C 0001     
0030 735E C804  38         mov   tmp0,@tv.colorscheme  ; /
     7360 A212     
0031               
0032 7362 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     7364 A224     
0033 7366 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     7368 200C     
0034               
0035 736A 0204  20         li    tmp0,fj.bottom
     736C B000     
0036 736E C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     7370 A226     
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 7372 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 7374 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 7376 045B  20         b     *r11                  ; Return to caller
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
0065 7378 0649  14         dect  stack
0066 737A C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 737C 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     737E 32B6     
0071 7380 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7382 3278     
0072 7384 06A0  32         bl    @idx.init             ; Initialize index
     7386 3178     
0073 7388 06A0  32         bl    @fb.init              ; Initialize framebuffer
     738A 3116     
0074 738C 06A0  32         bl    @errline.init         ; Initialize error line
     738E 32F2     
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 7390 06A0  32         bl    @hchar
     7392 27BE     
0079 7394 0034                   byte 0,52,32,18           ; Remove markers
     7396 2012     
0080 7398 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     739A 2033     
0081 739C FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 739E C2F9  30         mov   *stack+,r11           ; Pop R11
0087 73A0 045B  20         b     *r11                  ; Return to caller
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
0020 73A2 0649  14         dect  stack
0021 73A4 C64B  30         mov   r11,*stack            ; Save return address
0022 73A6 0649  14         dect  stack
0023 73A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 73AA 06A0  32         bl    @mknum                ; Convert unsigned number to string
     73AC 2A8C     
0028 73AE A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 73B0 A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 73B2 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 73B3   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 73B4 0204  20         li    tmp0,unpacked.string
     73B6 A026     
0034 73B8 04F4  30         clr   *tmp0+                ; Clear string 01
0035 73BA 04F4  30         clr   *tmp0+                ; Clear string 23
0036 73BC 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 73BE 06A0  32         bl    @trimnum              ; Trim unsigned number string
     73C0 2AE4     
0039 73C2 A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 73C4 A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 73C6 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73C8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73CA C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73CC 045B  20         b     *r11                  ; Return to caller
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
0073 73CE 0649  14         dect  stack
0074 73D0 C64B  30         mov   r11,*stack            ; Push return address
0075 73D2 0649  14         dect  stack
0076 73D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73D6 0649  14         dect  stack
0078 73D8 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73DA 0649  14         dect  stack
0080 73DC C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73DE 0649  14         dect  stack
0082 73E0 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 73E2 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     73E4 A000     
0087 73E6 D194  26         movb  *tmp0,tmp2            ; /
0088 73E8 0986  56         srl   tmp2,8                ; Right align
0089 73EA C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 73EC 8806  38         c     tmp2,@parm2           ; String length > requested length?
     73EE A002     
0092 73F0 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 73F2 C120  34         mov   @parm1,tmp0           ; Get source address
     73F4 A000     
0097 73F6 C160  34         mov   @parm4,tmp1           ; Get destination address
     73F8 A006     
0098 73FA 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 73FC 0649  14         dect  stack
0101 73FE C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 7400 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     7402 24D6     
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 7404 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 7406 C120  34         mov   @parm2,tmp0           ; Get requested length
     7408 A002     
0113 740A 0A84  56         sla   tmp0,8                ; Left align
0114 740C C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     740E A006     
0115 7410 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 7412 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 7414 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7416 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     7418 A002     
0122 741A 6187  18         s     tmp3,tmp2             ; |
0123 741C 0586  14         inc   tmp2                  ; /
0124               
0125 741E C120  34         mov   @parm3,tmp0           ; Get byte to padd
     7420 A004     
0126 7422 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 7424 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 7426 0606  14         dec   tmp2                  ; Update loop counter
0133 7428 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 742A C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     742C A006     
     742E A010     
0136 7430 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 7432 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7434 FFCE     
0142 7436 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7438 2026     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 743A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 743C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 743E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 7440 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 7442 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 7444 045B  20         b     *r11                  ; Return to caller
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
0174 7446 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7448 2792     
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 744A 04E0  34         clr   @bank0.rom            ; Activate bank 0
     744C 6000     
0179 744E 0420  54         blwp  @0                    ; Reset to monitor
     7450 0000     
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
0017 7452 0649  14         dect  stack
0018 7454 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 7456 06A0  32         bl    @sams.layout
     7458 25D8     
0023 745A 345A                   data mem.sams.layout.data
0024               
0025 745C 06A0  32         bl    @sams.layout.copy
     745E 263C     
0026 7460 A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 7462 C820  54         mov   @tv.sams.c000,@edb.sams.page
     7464 A208     
     7466 A516     
0029 7468 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     746A A516     
     746C A518     
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 746E C2F9  30         mov   *stack+,r11           ; Pop r11
0036 7470 045B  20         b     *r11                  ; Return to caller
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
0033 7472 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     7474 003F     
     7476 0243     
     7478 05F4     
     747A 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 747C 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     747E 000C     
     7480 0006     
     7482 0007     
     7484 0020     
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
0067 7486 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     7488 000C     
     748A 0006     
     748C 0007     
     748E 0020     
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
0088               
0089               
0090               
0091               romsat:
0092 7490 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     7492 0201     
0093 7494 0000             data  >0000,>0301             ; Current line indicator
     7496 0301     
0094 7498 0820             data  >0820,>0401             ; Current line indicator
     749A 0401     
0095               nosprite:
0096 749C D000             data  >d000                   ; End-of-Sprites list
0097               
0098               
0099               ***************************************************************
0100               * SAMS page layout table for Stevie (16 words)
0101               *--------------------------------------------------------------
0102               mem.sams.layout.data:
0103 749E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74A0 0002     
0104 74A2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74A4 0003     
0105 74A6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74A8 000A     
0106 74AA B000             data  >b000,>0020           ; >b000-bfff, SAMS page >20
     74AC 0020     
0107                                                   ;   Index can allocate
0108                                                   ;   pages >20 to >3f.
0109 74AE C000             data  >c000,>0040           ; >c000-cfff, SAMS page >40
     74B0 0040     
0110                                                   ;   Editor buffer can allocate
0111                                                   ;   pages >40 to >ff.
0112 74B2 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     74B4 000D     
0113 74B6 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     74B8 000E     
0114 74BA F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     74BC 000F     
0115               
0116               
0117               ***************************************************************
0118               * SAMS page layout table for calling external progam (16 words)
0119               *--------------------------------------------------------------
0120               mem.sams.external:
0121 74BE 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74C0 0002     
0122 74C2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74C4 0003     
0123 74C6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74C8 000A     
0124 74CA B000             data  >b000,>0030           ; >b000-bfff, SAMS page >30
     74CC 0030     
0125 74CE C000             data  >c000,>0031           ; >c000-cfff, SAMS page >31
     74D0 0031     
0126 74D2 D000             data  >d000,>0032           ; >d000-dfff, SAMS page >32
     74D4 0032     
0127 74D6 E000             data  >e000,>0033           ; >e000-efff, SAMS page >33
     74D8 0033     
0128 74DA F000             data  >f000,>0034           ; >f000-ffff, SAMS page >34
     74DC 0034     
0129               
0130               
0131               ***************************************************************
0132               * SAMS page layout table for TI Basic (16 words)
0133               *--------------------------------------------------------------
0134               mem.sams.tibasic:
0135 74DE 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74E0 0002     
0136 74E2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74E4 0003     
0137 74E6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74E8 000A     
0138 74EA B000             data  >b000,>0004           ; >b000-bfff, SAMS page >04
     74EC 0004     
0139 74EE C000             data  >c000,>0005           ; >c000-cfff, SAMS page >05
     74F0 0005     
0140 74F2 D000             data  >d000,>0006           ; >d000-dfff, SAMS page >06
     74F4 0006     
0141 74F6 E000             data  >e000,>0007           ; >e000-efff, SAMS page >07
     74F8 0007     
0142 74FA F000             data  >f000,>0008           ; >f000-ffff, SAMS page >08
     74FC 0008     
0143               
0144               
0145               
0146               ***************************************************************
0147               * Stevie color schemes table
0148               *--------------------------------------------------------------
0149               * Word 1
0150               * A  MSB  high-nibble    Foreground color text line in frame buffer
0151               * B  MSB  low-nibble     Background color text line in frame buffer
0152               * C  LSB  high-nibble    Foreground color top/bottom line
0153               * D  LSB  low-nibble     Background color top/bottom line
0154               *
0155               * Word 2
0156               * E  MSB  high-nibble    Foreground color cmdb pane
0157               * F  MSB  low-nibble     Background color cmdb pane
0158               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0159               * H  LSB  low-nibble     Cursor foreground color frame buffer
0160               *
0161               * Word 3
0162               * I  MSB  high-nibble    Foreground color busy top/bottom line
0163               * J  MSB  low-nibble     Background color busy top/bottom line
0164               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0165               * L  LSB  low-nibble     Background color marked line in frame buffer
0166               *
0167               * Word 4
0168               * M  MSB  high-nibble    Foreground color command buffer header line
0169               * N  MSB  low-nibble     Background color command buffer header line
0170               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0171               * P  LSB  low-nibble     Foreground color ruler frame buffer
0172               *
0173               * Colors
0174               * 0  Transparant
0175               * 1  black
0176               * 2  Green
0177               * 3  Light Green
0178               * 4  Blue
0179               * 5  Light Blue
0180               * 6  Dark Red
0181               * 7  Cyan
0182               * 8  Red
0183               * 9  Light Red
0184               * A  Yellow
0185               * B  Light Yellow
0186               * C  Dark Green
0187               * D  Magenta
0188               * E  Grey
0189               * F  White
0190               *--------------------------------------------------------------
0191      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0192               
0193               tv.colorscheme.table:
0194                       ;                             ; #
0195                       ;      ABCD  EFGH  IJKL  MNOP ; -
0196 74FE F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     7500 F171     
     7502 1B1F     
     7504 71B1     
0197 7506 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     7508 F0FF     
     750A 1F1A     
     750C F1FF     
0198 750E 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     7510 F0FF     
     7512 1F12     
     7514 F1F6     
0199 7516 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     7518 1E11     
     751A 1A17     
     751C 1E11     
0200 751E E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     7520 E1FF     
     7522 1F1E     
     7524 E1FF     
0201 7526 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     7528 1016     
     752A 1B71     
     752C 1711     
0202 752E 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     7530 1011     
     7532 F1F1     
     7534 1F11     
0203 7536 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     7538 A1FF     
     753A 1F1F     
     753C F11F     
0204 753E 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     7540 12FF     
     7542 1B12     
     7544 12FF     
0205 7546 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     7548 E1FF     
     754A 1B1F     
     754C F131     
0206                       even
0207               
0208               tv.tabs.table:
0209 754E 0007             byte  0,7,12,25               ; \   Default tab positions as used
     7550 0C19     
0210 7552 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     7554 3B4F     
0211 7556 FF00             byte  >ff,0,0,0               ; |
     7558 0000     
0212 755A 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     755C 0000     
0213 755E 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     7560 0000     
0214                       even
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
0009 7562 01               byte  1
0010 7563   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 7564 05               byte  5
0015 7565   20             text  '  BOT'
     7566 2042     
     7568 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 756A 03               byte  3
0020 756B   4F             text  'OVR'
     756C 5652     
0021                       even
0022               
0023               txt.insert
0024 756E 03               byte  3
0025 756F   49             text  'INS'
     7570 4E53     
0026                       even
0027               
0028               txt.star
0029 7572 01               byte  1
0030 7573   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 7574 0A               byte  10
0035 7575   4C             text  'Loading...'
     7576 6F61     
     7578 6469     
     757A 6E67     
     757C 2E2E     
     757E 2E       
0036                       even
0037               
0038               txt.saving
0039 7580 0A               byte  10
0040 7581   53             text  'Saving....'
     7582 6176     
     7584 696E     
     7586 672E     
     7588 2E2E     
     758A 2E       
0041                       even
0042               
0043               txt.block.del
0044 758C 12               byte  18
0045 758D   44             text  'Deleting block....'
     758E 656C     
     7590 6574     
     7592 696E     
     7594 6720     
     7596 626C     
     7598 6F63     
     759A 6B2E     
     759C 2E2E     
     759E 2E       
0046                       even
0047               
0048               txt.block.copy
0049 75A0 11               byte  17
0050 75A1   43             text  'Copying block....'
     75A2 6F70     
     75A4 7969     
     75A6 6E67     
     75A8 2062     
     75AA 6C6F     
     75AC 636B     
     75AE 2E2E     
     75B0 2E2E     
0051                       even
0052               
0053               txt.block.move
0054 75B2 10               byte  16
0055 75B3   4D             text  'Moving block....'
     75B4 6F76     
     75B6 696E     
     75B8 6720     
     75BA 626C     
     75BC 6F63     
     75BE 6B2E     
     75C0 2E2E     
     75C2 2E       
0056                       even
0057               
0058               txt.block.save
0059 75C4 1D               byte  29
0060 75C5   53             text  'Saving block to DV80 file....'
     75C6 6176     
     75C8 696E     
     75CA 6720     
     75CC 626C     
     75CE 6F63     
     75D0 6B20     
     75D2 746F     
     75D4 2044     
     75D6 5638     
     75D8 3020     
     75DA 6669     
     75DC 6C65     
     75DE 2E2E     
     75E0 2E2E     
0061                       even
0062               
0063               txt.fastmode
0064 75E2 08               byte  8
0065 75E3   46             text  'Fastmode'
     75E4 6173     
     75E6 746D     
     75E8 6F64     
     75EA 65       
0066                       even
0067               
0068               txt.kb
0069 75EC 02               byte  2
0070 75ED   6B             text  'kb'
     75EE 62       
0071                       even
0072               
0073               txt.lines
0074 75F0 05               byte  5
0075 75F1   4C             text  'Lines'
     75F2 696E     
     75F4 6573     
0076                       even
0077               
0078               txt.newfile
0079 75F6 0A               byte  10
0080 75F7   5B             text  '[New file]'
     75F8 4E65     
     75FA 7720     
     75FC 6669     
     75FE 6C65     
     7600 5D       
0081                       even
0082               
0083               txt.filetype.dv80
0084 7602 04               byte  4
0085 7603   44             text  'DV80'
     7604 5638     
     7606 30       
0086                       even
0087               
0088               txt.m1
0089 7608 03               byte  3
0090 7609   4D             text  'M1='
     760A 313D     
0091                       even
0092               
0093               txt.m2
0094 760C 03               byte  3
0095 760D   4D             text  'M2='
     760E 323D     
0096                       even
0097               
0098               txt.keys.default
0099 7610 07               byte  7
0100 7611   46             text  'F9-Menu'
     7612 392D     
     7614 4D65     
     7616 6E75     
0101                       even
0102               
0103               txt.keys.block
0104 7618 2C               byte  44
0105 7619   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Goto-M1'
     761A 392D     
     761C 4261     
     761E 636B     
     7620 2020     
     7622 5E43     
     7624 6F70     
     7626 7920     
     7628 205E     
     762A 4D6F     
     762C 7665     
     762E 2020     
     7630 5E44     
     7632 656C     
     7634 2020     
     7636 5E53     
     7638 6176     
     763A 6520     
     763C 205E     
     763E 476F     
     7640 746F     
     7642 2D4D     
     7644 31       
0106                       even
0107               
0108 7646 2E2E     txt.ruler          text    '.........'
     7648 2E2E     
     764A 2E2E     
     764C 2E2E     
     764E 2E       
0109 764F   12                        byte    18
0110 7650 2E2E                        text    '.........'
     7652 2E2E     
     7654 2E2E     
     7656 2E2E     
     7658 2E       
0111 7659   13                        byte    19
0112 765A 2E2E                        text    '.........'
     765C 2E2E     
     765E 2E2E     
     7660 2E2E     
     7662 2E       
0113 7663   14                        byte    20
0114 7664 2E2E                        text    '.........'
     7666 2E2E     
     7668 2E2E     
     766A 2E2E     
     766C 2E       
0115 766D   15                        byte    21
0116 766E 2E2E                        text    '.........'
     7670 2E2E     
     7672 2E2E     
     7674 2E2E     
     7676 2E       
0117 7677   16                        byte    22
0118 7678 2E2E                        text    '.........'
     767A 2E2E     
     767C 2E2E     
     767E 2E2E     
     7680 2E       
0119 7681   17                        byte    23
0120 7682 2E2E                        text    '.........'
     7684 2E2E     
     7686 2E2E     
     7688 2E2E     
     768A 2E       
0121 768B   18                        byte    24
0122 768C 2E2E                        text    '.........'
     768E 2E2E     
     7690 2E2E     
     7692 2E2E     
     7694 2E       
0123 7695   19                        byte    25
0124                                  even
0125 7696 020E     txt.alpha.down     data >020e,>0f00
     7698 0F00     
0126 769A 0110     txt.vertline       data >0110
0127 769C 011C     txt.keymarker      byte 1,28
0128               
0129               txt.ws1
0130 769E 01               byte  1
0131 769F   20             text  ' '
0132                       even
0133               
0134               txt.ws2
0135 76A0 02               byte  2
0136 76A1   20             text  '  '
     76A2 20       
0137                       even
0138               
0139               txt.ws3
0140 76A4 03               byte  3
0141 76A5   20             text  '   '
     76A6 2020     
0142                       even
0143               
0144               txt.ws4
0145 76A8 04               byte  4
0146 76A9   20             text  '    '
     76AA 2020     
     76AC 20       
0147                       even
0148               
0149               txt.ws5
0150 76AE 05               byte  5
0151 76AF   20             text  '     '
     76B0 2020     
     76B2 2020     
0152                       even
0153               
0154      3664     txt.filetype.none  equ txt.ws4
0155               
0156               
0157               ;--------------------------------------------------------------
0158               ; Strings for error line pane
0159               ;--------------------------------------------------------------
0160               txt.ioerr.load
0161 76B4 20               byte  32
0162 76B5   49             text  'I/O error. Failed loading file: '
     76B6 2F4F     
     76B8 2065     
     76BA 7272     
     76BC 6F72     
     76BE 2E20     
     76C0 4661     
     76C2 696C     
     76C4 6564     
     76C6 206C     
     76C8 6F61     
     76CA 6469     
     76CC 6E67     
     76CE 2066     
     76D0 696C     
     76D2 653A     
     76D4 20       
0163                       even
0164               
0165               txt.ioerr.save
0166 76D6 20               byte  32
0167 76D7   49             text  'I/O error. Failed saving file:  '
     76D8 2F4F     
     76DA 2065     
     76DC 7272     
     76DE 6F72     
     76E0 2E20     
     76E2 4661     
     76E4 696C     
     76E6 6564     
     76E8 2073     
     76EA 6176     
     76EC 696E     
     76EE 6720     
     76F0 6669     
     76F2 6C65     
     76F4 3A20     
     76F6 20       
0168                       even
0169               
0170               txt.memfull.load
0171 76F8 40               byte  64
0172 76F9   49             text  'Index memory full. Could not fully load file into editor buffer.'
     76FA 6E64     
     76FC 6578     
     76FE 206D     
     7700 656D     
     7702 6F72     
     7704 7920     
     7706 6675     
     7708 6C6C     
     770A 2E20     
     770C 436F     
     770E 756C     
     7710 6420     
     7712 6E6F     
     7714 7420     
     7716 6675     
     7718 6C6C     
     771A 7920     
     771C 6C6F     
     771E 6164     
     7720 2066     
     7722 696C     
     7724 6520     
     7726 696E     
     7728 746F     
     772A 2065     
     772C 6469     
     772E 746F     
     7730 7220     
     7732 6275     
     7734 6666     
     7736 6572     
     7738 2E       
0173                       even
0174               
0175               txt.io.nofile
0176 773A 21               byte  33
0177 773B   49             text  'I/O error. No filename specified.'
     773C 2F4F     
     773E 2065     
     7740 7272     
     7742 6F72     
     7744 2E20     
     7746 4E6F     
     7748 2066     
     774A 696C     
     774C 656E     
     774E 616D     
     7750 6520     
     7752 7370     
     7754 6563     
     7756 6966     
     7758 6965     
     775A 642E     
0178                       even
0179               
0180               txt.block.inside
0181 775C 34               byte  52
0182 775D   45             text  'Error. Copy/Move target must be outside block M1-M2.'
     775E 7272     
     7760 6F72     
     7762 2E20     
     7764 436F     
     7766 7079     
     7768 2F4D     
     776A 6F76     
     776C 6520     
     776E 7461     
     7770 7267     
     7772 6574     
     7774 206D     
     7776 7573     
     7778 7420     
     777A 6265     
     777C 206F     
     777E 7574     
     7780 7369     
     7782 6465     
     7784 2062     
     7786 6C6F     
     7788 636B     
     778A 204D     
     778C 312D     
     778E 4D32     
     7790 2E       
0183                       even
0184               
0185               
0186               ;--------------------------------------------------------------
0187               ; Strings for command buffer
0188               ;--------------------------------------------------------------
0189               txt.cmdb.prompt
0190 7792 01               byte  1
0191 7793   3E             text  '>'
0192                       even
0193               
0194               txt.colorscheme
0195 7794 0D               byte  13
0196 7795   43             text  'Color scheme:'
     7796 6F6C     
     7798 6F72     
     779A 2073     
     779C 6368     
     779E 656D     
     77A0 653A     
0197                       even
0198               
                   < ram.resident.asm
                   < stevie_b4.asm.9883
0043                       ;------------------------------------------------------
0044                       ; Activate bank 1 and branch to  >6036
0045                       ;------------------------------------------------------
0046 77A2 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     77A4 6002     
0047               
0051               
0052 77A6 0460  28         b     @kickstart.code2      ; Jump to entry routine
     77A8 6046     
0053               ***************************************************************
0054               * Step 3: Include main editor modules
0055               ********|*****|*********************|**************************
0056               main:
0057                       aorg  kickstart.code2       ; >6046
0058 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0059                       ;-----------------------------------------------------------------------
0060                       ; Logic for Framebuffer (2)
0061                       ;-----------------------------------------------------------------------
0062                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 604A 0649  14         dect  stack
0025 604C C64B  30         mov   r11,*stack            ; Save return address
0026 604E 0649  14         dect  stack
0027 6050 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6052 C120  34         mov   @parm1,tmp0
     6054 A000     
0032 6056 A120  34         a     @fb.topline,tmp0
     6058 A304     
0033 605A C804  38         mov   tmp0,@outparm1
     605C A010     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 605E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6060 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6062 045B  20         b     *r11                  ; Return to caller
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
0068 6064 0649  14         dect  stack
0069 6066 C64B  30         mov   r11,*stack            ; Save return address
0070 6068 0649  14         dect  stack
0071 606A C644  30         mov   tmp0,*stack           ; Push tmp0
0072 606C 0649  14         dect  stack
0073 606E C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6070 C120  34         mov   @fb.row,tmp0
     6072 A306     
0078 6074 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6076 A30E     
0079 6078 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     607A A30C     
0080 607C A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     607E A300     
0081 6080 C805  38         mov   tmp1,@fb.current
     6082 A302     
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6084 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6086 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6088 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 608A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b4.asm.9883
0063                       copy  "fb.null2char.asm"    ; Replace null characters in framebuffer row
     **** ****     > fb.null2char.asm
0001               * FILE......: fb.null2char.asm
0002               * Purpose...: Replace all null characters with specified character
0003               
0004               ***************************************************************
0005               * fb.null2char
0006               * Replace all null characters with specified character
0007               ***************************************************************
0008               *  bl   @fb.null2char
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * tmp1 = Replacement character
0012               * tmp2 = Length of row
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2,tmp3
0019               ********|*****|*********************|**************************
0020               fb.null2char:
0021 608C 0649  14         dect  stack
0022 608E C64B  30         mov   r11,*stack            ; Save return address
0023 6090 0649  14         dect  stack
0024 6092 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6094 0649  14         dect  stack
0026 6096 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6098 0649  14         dect  stack
0028 609A C646  30         mov   tmp2,*stack           ; Push tmp2
0029 609C 0649  14         dect  stack
0030 609E C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Sanity checks
0033                       ;-------------------------------------------------------
0034 60A0 C186  18         mov   tmp2,tmp2             ; Minimum 1 character
0035 60A2 1303  14         jeq   fb.null2char.crash
0036 60A4 0286  22         ci    tmp2,80               ; Maximum 80 characters
     60A6 0050     
0037 60A8 1204  14         jle   fb.null2char.init
0038                       ;------------------------------------------------------
0039                       ; Asserts failed
0040                       ;------------------------------------------------------
0041               fb.null2char.crash:
0042 60AA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     60AC FFCE     
0043 60AE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     60B0 2026     
0044                       ;-------------------------------------------------------
0045                       ; Initialize
0046                       ;-------------------------------------------------------
0047               fb.null2char.init:
0048 60B2 C1C5  18         mov   tmp1,tmp3             ; Get character to write
0049 60B4 0A87  56         sla   tmp3,8                ; LSB to MSB
0050               
0051 60B6 04E0  34         clr   @fb.column
     60B8 A30C     
0052 60BA 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     60BC 6064     
0053 60BE C120  34         mov   @fb.current,tmp0      ; Get position
     60C0 A302     
0054                       ;-------------------------------------------------------
0055                       ; Loop over characters in line
0056                       ;-------------------------------------------------------
0057               fb.null2char.loop:
0058 60C2 04C5  14         clr   tmp1
0059 60C4 D154  26         movb  *tmp0,tmp1            ; Get character
0060 60C6 1603  14         jne   !                     ; Not a null character, skip it
0061 60C8 0205  20         li    tmp1,>2a00            ; ASCII 32 in MSB
     60CA 2A00     
0062 60CC D507  30         movb  tmp3,*tmp0            ; Replace null character
0063                       ;-------------------------------------------------------
0064                       ; Prepare for next iteration
0065                       ;-------------------------------------------------------
0066 60CE 0584  14 !       inc   tmp0                  ; Move to next character
0067 60D0 0606  14         dec   tmp2
0068 60D2 15F7  14         jgt   fb.null2char.loop     ; Repeat until done
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               fb.null2char.exit:
0073 60D4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 60D6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 60D8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 60DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 60DC C2F9  30         mov   *stack+,r11           ; Pop R11
0078 60DE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b4.asm.9883
0064                       copy  "fb.tab.next.asm"     ; Move cursor to next tab position
     **** ****     > fb.tab.next.asm
0001               * FILE......: fb.tab.next.asm
0002               * Purpose...: Tabbing functionality in frame buffer
0003               
0004               
0005               ***************************************************************
0006               * fb.tab.next
0007               * Move cursor to next tab position
0008               ***************************************************************
0009               *  bl   @fb.tab.next
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Remarks
0021               * For simplicity reasons we're assuming base 1 during copy
0022               * (first line starts at 1 instead of 0).
0023               * Makes it easier when comparing values.
0024               ********|*****|*********************|**************************
0025               fb.tab.next:
0026 60E0 0649  14         dect  stack
0027 60E2 C64B  30         mov   r11,*stack            ; Save return address
0028 60E4 0649  14         dect  stack
0029 60E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 60E8 0649  14         dect  stack
0031 60EA C645  30         mov   tmp1,*stack           ; Push tmp1
0032 60EC 0649  14         dect  stack
0033 60EE C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;-------------------------------------------------------
0035                       ; Initialize
0036                       ;-------------------------------------------------------
0037 60F0 0204  20         li    tmp0,tv.tabs.table    ; Get pointer to tabs table
     60F2 350A     
0038                       ;-------------------------------------------------------
0039                       ; Find next tab position
0040                       ;-------------------------------------------------------
0041               fb.tab.next.loop:
0042 60F4 D174  28         movb  *tmp0+,tmp1           ; \ Get tab position
0043 60F6 0985  56         srl   tmp1,8                ; / Right align
0044               
0045 60F8 0285  22         ci    tmp1,>00ff            ; End-of-list reached?
     60FA 00FF     
0046 60FC 1325  14         jeq   fb.tab.next.eol       ; Yes, home cursor and exit
0047                       ;-------------------------------------------------------
0048                       ; Compare position
0049                       ;-------------------------------------------------------
0050 60FE 8160  34         c     @fb.column,tmp1       ; Cursor > tab position?
     6100 A30C     
0051 6102 142C  14         jhe   !                     ; Yes, next loop iteration
0052                       ;-------------------------------------------------------
0053                       ; Set cursor
0054                       ;-------------------------------------------------------
0055 6104 C185  18         mov   tmp1,tmp2             ; Set length of row
0056 6106 0205  20         li    tmp1,32               ; Replacement character = ASCII 32
     6108 0020     
0057 610A 06A0  32         bl    @fb.null2char         ; \ Replace any null characters with space
     610C 608C     
0058                                                   ; | i  tmp1 = Replacement character
0059                                                   ; / i  tmp2 = Length of row
0060               
0061 610E C146  18         mov   tmp2,tmp1             ; Restore tmp1
0062 6110 C805  38         mov   tmp1,@fb.column       ; Set cursor on tab position
     6112 A30C     
0063               
0064 6114 0649  14         dect  stack
0065 6116 C644  30         mov   tmp0,*stack           ; Push tmp0
0066               
0067 6118 C105  18         mov   tmp1,tmp0             ; \ Set VDP cursor column position
0068 611A 06A0  32         bl    @xsetx                ; / i  tmp0 = new X value
     611C 26DC     
0069               
0070 611E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0071               
0072 6120 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6122 6064     
0073               
0074 6124 0720  34         seto  @fb.row.dirty         ; Current row dirty in frame buffer
     6126 A30A     
0075 6128 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     612A A316     
0076 612C 0720  34         seto  @fb.status.dirty      ; Refresh status line
     612E A318     
0077 6130 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed)
     6132 A506     
0078                       ;-------------------------------------------------------
0079                       ; Set row length
0080                       ;-------------------------------------------------------
0081 6134 C120  34         mov   @fb.column,tmp0
     6136 A30C     
0082 6138 0584  14         inc   tmp0                  ; Base 1
0083 613A 8820  54         c     @fb.column,@fb.row.length
     613C A30C     
     613E A308     
0084 6140 110F  14         jlt   fb.tab.next.exit      ; No need to set row length, exit
0085 6142 C804  38         mov   tmp0,@fb.row.length   : Set new length
     6144 A308     
0086 6146 100C  14         jmp   fb.tab.next.exit      ; Exit
0087                       ;-------------------------------------------------------
0088                       ; End-of-list reached, special treatment home cursor
0089                       ;-------------------------------------------------------
0090               fb.tab.next.eol:
0091 6148 04E0  34         clr   @fb.column            ; Home cursor
     614A A30C     
0092 614C 04C4  14         clr   tmp0                  ; Home cursor
0093               
0094 614E 06A0  32         bl    @xsetx                ; \ Set VDP cursor column position
     6150 26DC     
0095                                                   ; / i  tmp0 = new X value
0096               
0097 6152 0720  34         seto  @fb.status.dirty      ; Refresh status line
     6154 A318     
0098               
0099 6156 04E0  34         clr   @edb.insmode          ; Turn on overwrite mode
     6158 A50A     
0100                                                   ; This is a hack really. Because of the
0101                                                   ; whitespace that is dragged by tabbing, we
0102                                                   ; have a full 80 characters line so insert
0103                                                   ; does not work.
0104               
0105               
0106 615A 1002  14         jmp   fb.tab.next.exit      ; Exit
0107                       ;-------------------------------------------------------
0108                       ; Prepare for next iteration
0109                       ;-------------------------------------------------------
0110 615C 0606  14 !       dec   tmp2
0111 615E 15CA  14         jgt   fb.tab.next.loop
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               fb.tab.next.exit:
0116 6160 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0117 6162 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0118 6164 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0119 6166 C2F9  30         mov   *stack+,r11           ; Pop R11
0120 6168 045B  20         b     *r11                  ; Return to caller
                   < stevie_b4.asm.9883
0065                       copy  "fb.ruler.asm"        ; Setup ruler with tab positions in memory
     **** ****     > fb.ruler.asm
0001               * FILE......: fb.ruler.asm
0002               * Purpose...: Setup ruler with tab-positions
0003               
0004               ***************************************************************
0005               * fb.ruler.init
0006               * Setup ruler line
0007               ***************************************************************
0008               * bl  @ruler.init
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0,tmp1,tmp2
0015               ********|*****|*********************|**************************
0016               fb.ruler.init:
0017 616A 0649  14         dect  stack
0018 616C C64B  30         mov   r11,*stack            ; Save return address
0019 616E 0649  14         dect  stack
0020 6170 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 6172 0649  14         dect  stack
0022 6174 C645  30         mov   tmp1,*stack           ; Push tmp1
0023 6176 0649  14         dect  stack
0024 6178 C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;-------------------------------------------------------
0026                       ; Initialize
0027                       ;-------------------------------------------------------
0028 617A 06A0  32         bl    @cpym2m
     617C 24D0     
0029 617E 3602                   data txt.ruler,fb.ruler.sit,80
     6180 A31E     
     6182 0050     
0030                                                   ; Copy ruler from ROM to RAM
0031               
0032 6184 0204  20         li    tmp0,fb.ruler.tat
     6186 A36E     
0033 6188 C160  34         mov   @tv.rulercolor,tmp1
     618A A21E     
0034 618C 0206  20         li    tmp2,80
     618E 0050     
0035               
0036 6190 06A0  32         bl    @xfilm                ; Setup FG/BG color for ruler in RAM
     6192 2232     
0037                                                   ; \ i  tmp0 = Target address in RAM
0038                                                   ; | i  tmp1 = Byte to fill
0039                                                   ; / i  tmp2 = Number of bytes to fill
0040               
0041 6194 0204  20         li    tmp0,tv.tabs.table    ; Get pointer to tabs table
     6196 350A     
0042                       ;------------------------------------------------------
0043                       ; Setup ruler with current tab positions
0044                       ;------------------------------------------------------
0045               fb.ruler.init.loop:
0046 6198 D174  28         movb  *tmp0+,tmp1           ; \ Get tab position
0047 619A 0985  56         srl   tmp1,8                ; / Right align
0048               
0049 619C 0285  22         ci    tmp1,>00ff            ; End-of-list reached?
     619E 00FF     
0050 61A0 130B  14         jeq   fb.ruler.init.exit
0051                       ;------------------------------------------------------
0052                       ; Add tab-marker to ruler SIT in RAM
0053                       ;------------------------------------------------------
0054 61A2 0225  22         ai    tmp1,fb.ruler.sit     ; Add base address
     61A4 A31E     
0055 61A6 0206  20         li    tmp2,>1100            ; Tab indicator (ASCII 16)
     61A8 1100     
0056 61AA D546  30         movb  tmp2,*tmp1            ; Add tab-marker
0057                       ;------------------------------------------------------
0058                       ; Add tab-marker color to ruler TAT in RAM
0059                       ;------------------------------------------------------
0060 61AC 0225  22         ai    tmp1,80
     61AE 0050     
0061 61B0 C1A0  34         mov   @tv.color,tmp2        ; AB is in MSB (see color scheme table)
     61B2 A218     
0062 61B4 D546  30         movb  tmp2,*tmp1            ; Tab indicator FG/BG color
0063 61B6 10F0  14         jmp   fb.ruler.init.loop    ; Next iteration
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               fb.ruler.init.exit:
0068 61B8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0069 61BA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0070 61BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0071 61BE C2F9  30         mov   *stack+,r11           ; Pop r11
0072 61C0 045B  20         b     *r11                  ; Return
                   < stevie_b4.asm.9883
0066                       copy  "fb.colorlines.asm"   ; Colorize lines in framebuffer
     **** ****     > fb.colorlines.asm
0001               * FILE......: fb.colorlines.asm
0002               * Purpose...: Colorize frame buffer content
0003               
0004               ***************************************************************
0005               * fb.colorlines
0006               * Colorize frame buffer content
0007               ***************************************************************
0008               * bl @fb.colorlines
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Force refresh if >ffff
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2,tmp3,tmp4
0018               ********|*****|*********************|**************************
0019               fb.colorlines:
0020 61C2 0649  14         dect  stack
0021 61C4 C64B  30         mov   r11,*stack            ; Save return address
0022 61C6 0649  14         dect  stack
0023 61C8 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 61CA 0649  14         dect  stack
0025 61CC C645  30         mov   tmp1,*stack           ; Push tmp1
0026 61CE 0649  14         dect  stack
0027 61D0 C646  30         mov   tmp2,*stack           ; Push tmp2
0028 61D2 0649  14         dect  stack
0029 61D4 C647  30         mov   tmp3,*stack           ; Push tmp3
0030 61D6 0649  14         dect  stack
0031 61D8 C648  30         mov   tmp4,*stack           ; Push tmp4
0032                       ;------------------------------------------------------
0033                       ; Force refresh flag set
0034                       ;------------------------------------------------------
0035 61DA C120  34         mov   @parm1,tmp0           ; \ Force refresh flag set?
     61DC A000     
0036 61DE 0284  22         ci    tmp0,>ffff            ; /
     61E0 FFFF     
0037 61E2 1309  14         jeq   !                     ; Yes, so skip Asserts
0038                       ;------------------------------------------------------
0039                       ; Assert
0040                       ;------------------------------------------------------
0041 61E4 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     61E6 A310     
0042 61E8 132A  14         jeq   fb.colorlines.exit    ; Exit if nothing to do.
0043                       ;------------------------------------------------------
0044                       ; Speedup screen refresh dramatically
0045                       ;------------------------------------------------------
0046 61EA C120  34         mov   @edb.block.m1,tmp0
     61EC A50C     
0047 61EE 1327  14         jeq   fb.colorlines.exit    ; Exit if marker M1 unset
0048 61F0 C120  34         mov   @edb.block.m2,tmp0
     61F2 A50E     
0049 61F4 1324  14         jeq   fb.colorlines.exit    ; Exit if marker M2 unset
0050                       ;------------------------------------------------------
0051                       ; Color the lines in the framebuffer (TAT)
0052                       ;------------------------------------------------------
0053 61F6 0204  20 !       li    tmp0,vdp.fb.toprow.tat
     61F8 1850     
0054                                                   ; VDP start address
0055 61FA C1E0  34         mov   @fb.scrrows,tmp3      ; Set loop counter
     61FC A31A     
0056               
0057 61FE C220  34         mov   @tv.ruler.visible,tmp4
     6200 A210     
0058 6202 1303  14         jeq   fb.colorlines.noruler ; Skip row adjustment if no ruler visible
0059               
0060 6204 0224  22         ai    tmp0,80               ; Skip ruler line
     6206 0050     
0061 6208 0607  14         dec   tmp3                  ; Skip ruler line
0062               fb.colorlines.noruler:
0063 620A C220  34         mov   @fb.topline,tmp4      ; Position in editor buffer
     620C A304     
0064 620E 0588  14         inc   tmp4                  ; M1/M2 use base 1 offset
0065                       ;------------------------------------------------------
0066                       ; 1. Set color for each line in framebuffer
0067                       ;------------------------------------------------------
0068               fb.colorlines.loop:
0069 6210 C1A0  34         mov   @edb.block.m1,tmp2
     6212 A50C     
0070 6214 8206  18         c     tmp2,tmp4             ; M1 > current line
0071 6216 1507  14         jgt   fb.colorlines.normal  ; Yes, skip marking color
0072               
0073 6218 C1A0  34         mov   @edb.block.m2,tmp2
     621A A50E     
0074 621C 8206  18         c     tmp2,tmp4             ; M2 < current line
0075 621E 1103  14         jlt   fb.colorlines.normal  ; Yes, skip marking color
0076                       ;------------------------------------------------------
0077                       ; 1a. Set marking color
0078                       ;------------------------------------------------------
0079 6220 C160  34         mov   @tv.markcolor,tmp1
     6222 A21A     
0080 6224 1003  14         jmp   fb.colorlines.fill
0081                       ;------------------------------------------------------
0082                       ; 1b. Set normal text color
0083                       ;------------------------------------------------------
0084               fb.colorlines.normal:
0085 6226 C160  34         mov   @tv.color,tmp1
     6228 A218     
0086 622A 0985  56         srl   tmp1,8
0087                       ;------------------------------------------------------
0088                       ; 1c. Fill line with selected color
0089                       ;------------------------------------------------------
0090               fb.colorlines.fill:
0091 622C 0206  20         li    tmp2,80               ; 80 characters to fill
     622E 0050     
0092               
0093 6230 06A0  32         bl    @xfilv                ; Fill VDP VRAM
     6232 228A     
0094                                                   ; \ i  tmp0 = VDP start address
0095                                                   ; | i  tmp1 = Byte to fill
0096                                                   ; / i  tmp2 = count
0097               
0098 6234 0224  22         ai    tmp0,80               ; Next line
     6236 0050     
0099 6238 0588  14         inc   tmp4
0100 623A 0607  14         dec   tmp3                  ; Update loop counter
0101 623C 15E9  14         jgt   fb.colorlines.loop    ; Back to (1)
0102                       ;------------------------------------------------------
0103                       ; Exit
0104                       ;------------------------------------------------------
0105               fb.colorlines.exit
0106 623E 04E0  34         clr   @fb.colorize          ; Reset colorize flag
     6240 A310     
0107 6242 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0108 6244 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109 6246 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0110 6248 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0111 624A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 624C C2F9  30         mov   *stack+,r11           ; Pop r11
0113 624E 045B  20         b     *r11                  ; Return
                   < stevie_b4.asm.9883
0067                       copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT
     **** ****     > fb.vdpdump.asm
0001               * FILE......: fb.vdpdump.asm
0002               * Purpose...: Dump framebuffer to VDP
0003               
0004               
0005               ***************************************************************
0006               * fb.vdpdump
0007               * Dump framebuffer to VDP SIT
0008               ***************************************************************
0009               * bl @fb.vdpdump
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = Number of lines to dump
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               fb.vdpdump:
0021 6250 0649  14         dect  stack
0022 6252 C64B  30         mov   r11,*stack            ; Save return address
0023 6254 0649  14         dect  stack
0024 6256 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6258 0649  14         dect  stack
0026 625A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 625C 0649  14         dect  stack
0028 625E C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Assert
0031                       ;------------------------------------------------------
0032 6260 C160  34         mov   @parm1,tmp1
     6262 A000     
0033 6264 0285  22         ci    tmp1,80*30
     6266 0960     
0034 6268 1204  14         jle   !
0035                       ;------------------------------------------------------
0036                       ; Crash the system
0037                       ;------------------------------------------------------
0038 626A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     626C FFCE     
0039 626E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6270 2026     
0040                       ;------------------------------------------------------
0041                       ; Setup start position in VDP memory
0042                       ;------------------------------------------------------
0043 6272 0204  20 !       li    tmp0,vdp.fb.toprow.sit
     6274 0050     
0044                                                   ; VDP target address (Xth line on screen!)
0045 6276 C1A0  34         mov   @tv.ruler.visible,tmp2
     6278 A210     
0046                                                   ; Is ruler visible on screen?
0047 627A 1302  14         jeq   fb.vdpdump.calc       ; No, continue with calculation
0048 627C A120  34         a     @fb.colsline,tmp0     ; Yes, add 2nd line offset
     627E A30E     
0049                       ;------------------------------------------------------
0050                       ; Refresh VDP content with framebuffer
0051                       ;------------------------------------------------------
0052               fb.vdpdump.calc:
0053 6280 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * number of rows in parm1
     6282 A30E     
0054                                                   ; 16 bit part is in tmp2!
0055 6284 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     6286 A300     
0056               
0057 6288 0286  22         ci    tmp2,0                ; \ Exit early if nothing to copy
     628A 0000     
0058 628C 1304  14         jeq   fb.vdpdump.exit       ; /
0059               
0060 628E 06A0  32         bl    @xpym2v               ; Copy to VDP
     6290 2482     
0061                                                   ; \ i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = RAM source address
0063                                                   ; / i  tmp2 = Bytes to copy
0064               
0065 6292 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     6294 A316     
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               fb.vdpdump.exit:
0070 6296 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0071 6298 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0072 629A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0073 629C C2F9  30         mov   *stack+,r11           ; Pop r11
0074 629E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b4.asm.9883
0068                       ;-----------------------------------------------------------------------
0069                       ; Stubs
0070                       ;-----------------------------------------------------------------------
0071                       copy  "rom.stubs.bank4.asm" ; Stubs for functions in other banks
     **** ****     > rom.stubs.bank4.asm
0001               * FILE......: rom.stubs.bank4.asm
0002               * Purpose...: Bank 4 stubs for functions in other banks
                   < stevie_b4.asm.9883
0072                       ;-----------------------------------------------------------------------
0073                       ; Bank full check
0074                       ;-----------------------------------------------------------------------
0078                       ;-----------------------------------------------------------------------
0079                       ; Vector table
0080                       ;-----------------------------------------------------------------------
0081                       aorg  >7fc0
0082                       copy  "rom.vectors.bank4.asm"
     **** ****     > rom.vectors.bank4.asm
0001               * FILE......: rom.vectors.bank4.asm
0002               * Purpose...: Bank 4 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 60E0     vec.1   data  fb.tab.next           ; Move cursor to next tab position
0008 7FC2 616A     vec.2   data  fb.ruler.init         ; Setup ruler with tab positions in memory
0009 7FC4 61C2     vec.3   data  fb.colorlines         ; Colorize frame buffer content
0010 7FC6 6250     vec.4   data  fb.vdpdump            ; Dump framebuffer to VDP SIT
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
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
                   < stevie_b4.asm.9883
0083                                                   ; Vector table bank 4
0084               
0085               *--------------------------------------------------------------
0086               * Video mode configuration
0087               *--------------------------------------------------------------
0088      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0089      0004     spfbck  equ   >04                   ; Screen background color.
0090      342E     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0091      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0092      0050     colrow  equ   80                    ; Columns per row
0093      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0094      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0095      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0096      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

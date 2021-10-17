XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b1.asm.37021
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 211017-1829010
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
                   < stevie_b1.asm.37021
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
                   < stevie_b1.asm.37021
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
                   < stevie_b1.asm.37021
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
                   < stevie_b1.asm.37021
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
0045 6011   53             text  'STEVIE 1.2A'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3241     
0046                       even
0047               
0049               
                   < stevie_b1.asm.37021
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
     60C8 2FD0     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 60CA 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     60CC 22F2     
0078 60CE 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 60D0 06A0  32         bl    @ldfnt
     60D2 235A     
0081 60D4 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     60D6 000C     
0082               
0083 60D8 06A0  32         bl    @filv
     60DA 2288     
0084 60DC 0380                   data >0380,>f0,32*24  ; Load color table
     60DE 00F0     
     60E0 0300     
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 60E2 06A0  32         bl    @putat                ; Show crash message
     60E4 243C     
0089 60E6 0000                   data >0000,cpu.crash.msg.crashed
     60E8 2178     
0090               
0091 60EA 06A0  32         bl    @puthex               ; Put hex value on screen
     60EC 2A86     
0092 60EE 0015                   byte 0,21             ; \ i  p0 = YX position
0093 60F0 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 60F2 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 60F4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 60F6 06A0  32         bl    @putat                ; Show caller message
     60F8 243C     
0101 60FA 0100                   data >0100,cpu.crash.msg.caller
     60FC 218E     
0102               
0103 60FE 06A0  32         bl    @puthex               ; Put hex value on screen
     6100 2A86     
0104 6102 0115                   byte 1,21             ; \ i  p0 = YX position
0105 6104 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6106 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 6108 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 610A 06A0  32         bl    @putat
     610C 243C     
0113 610E 0300                   byte 3,0
0114 6110 21AA                   data cpu.crash.msg.wp
0115 6112 06A0  32         bl    @putat
     6114 243C     
0116 6116 0400                   byte 4,0
0117 6118 21B0                   data cpu.crash.msg.st
0118 611A 06A0  32         bl    @putat
     611C 243C     
0119 611E 1600                   byte 22,0
0120 6120 21B6                   data cpu.crash.msg.source
0121 6122 06A0  32         bl    @putat
     6124 243C     
0122 6126 1700                   byte 23,0
0123 6128 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 612A 06A0  32         bl    @at                   ; Put cursor at YX
     612C 26C8     
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
     6150 2A90     
0154 6152 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 6154 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 6156 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 6158 06A0  32         bl    @setx                 ; Set cursor X position
     615A 26DE     
0160 615C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 615E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6160 2418     
0164 6162 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 6164 06A0  32         bl    @setx                 ; Set cursor X position
     6166 26DE     
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
     6176 2418     
0176 6178 21A4                   data cpu.crash.msg.r
0177               
0178 617A 06A0  32         bl    @mknum
     617C 2A90     
0179 617E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 6180 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 6182 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 6184 06A0  32         bl    @mkhex                ; Convert hex word to string
     6186 2A02     
0188 6188 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 618A A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 618C 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 618E 06A0  32         bl    @setx                 ; Set cursor X position
     6190 26DE     
0194 6192 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 6194 06A0  32         bl    @putstr               ; Put '  >'
     6196 2418     
0198 6198 21A6                   data cpu.crash.msg.marker
0199               
0200 619A 06A0  32         bl    @setx                 ; Set cursor X position
     619C 26DE     
0201 619E 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61A0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A2 2418     
0205 61A4 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61AC 06A0  32         bl    @down                 ; y=y+1
     61AE 26CE     
0213               
0214 61B0 0586  14         inc   tmp2
0215 61B2 0286  22         ci    tmp2,17
     61B4 0011     
0216 61B6 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61B8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61BA 2EC4     
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
0255 61FB   53             text  'Source    stevie_b1.lst.asm'
     61FC 6F75     
     61FE 7263     
     6200 6520     
     6202 2020     
     6204 2073     
     6206 7465     
     6208 7669     
     620A 655F     
     620C 6231     
     620E 2E6C     
     6210 7374     
     6212 2E61     
     6214 736D     
0256                       even
0257               
0258               cpu.crash.msg.id
0259 6216 18               byte  24
0260 6217   42             text  'Build-ID  211017-1829010'
     6218 7569     
     621A 6C64     
     621C 2D49     
     621E 4420     
     6220 2032     
     6222 3131     
     6224 3031     
     6226 372D     
     6228 3138     
     622A 3239     
     622C 3031     
     622E 30       
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
0007 6230 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6232 000E     
     6234 0106     
     6236 0204     
     6238 0020     
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
0032 623A 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     623C 000E     
     623E 0106     
     6240 00F4     
     6242 0028     
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
0058 6244 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6246 003F     
     6248 0240     
     624A 03F4     
     624C 0050     
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
0013 624E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6250 16FD             data  >16fd                 ; |         jne   mcloop
0015 6252 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6254 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6256 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 6258 0201  20         li    r1,mccode             ; Machinecode to patch
     625A 220A     
0037 625C 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     625E 8322     
0038 6260 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 6262 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 6264 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 6266 045B  20         b     *r11                  ; Return to caller
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
0056 6268 C0F9  30 popr3   mov   *stack+,r3
0057 626A C0B9  30 popr2   mov   *stack+,r2
0058 626C C079  30 popr1   mov   *stack+,r1
0059 626E C039  30 popr0   mov   *stack+,r0
0060 6270 C2F9  30 poprt   mov   *stack+,r11
0061 6272 045B  20         b     *r11
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
0085 6274 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 6276 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 6278 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 627A C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 627C 1604  14         jne   filchk                ; No, continue checking
0093               
0094 627E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6280 FFCE     
0095 6282 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6284 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 6286 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     6288 830B     
     628A 830A     
0100               
0101 628C 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     628E 0001     
0102 6290 1602  14         jne   filchk2
0103 6292 DD05  32         movb  tmp1,*tmp0+
0104 6294 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 6296 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6298 0002     
0109 629A 1603  14         jne   filchk3
0110 629C DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 629E DD05  32         movb  tmp1,*tmp0+
0112 62A0 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62A2 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62A4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62A6 0001     
0118 62A8 1305  14         jeq   fil16b
0119 62AA DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62AC 0606  14         dec   tmp2
0121 62AE 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62B0 0002     
0122 62B2 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62B4 C1C6  18 fil16b  mov   tmp2,tmp3
0127 62B6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62B8 0001     
0128 62BA 1301  14         jeq   dofill
0129 62BC 0606  14         dec   tmp2                  ; Make TMP2 even
0130 62BE CD05  34 dofill  mov   tmp1,*tmp0+
0131 62C0 0646  14         dect  tmp2
0132 62C2 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 62C4 C1C7  18         mov   tmp3,tmp3
0137 62C6 1301  14         jeq   fil.exit
0138 62C8 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 62CA 045B  20         b     *r11
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
0159 62CC C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 62CE C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 62D0 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 62D2 0264  22 xfilv   ori   tmp0,>4000
     62D4 4000     
0166 62D6 06C4  14         swpb  tmp0
0167 62D8 D804  38         movb  tmp0,@vdpa
     62DA 8C02     
0168 62DC 06C4  14         swpb  tmp0
0169 62DE D804  38         movb  tmp0,@vdpa
     62E0 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 62E2 020F  20         li    r15,vdpw              ; Set VDP write address
     62E4 8C00     
0174 62E6 06C5  14         swpb  tmp1
0175 62E8 C820  54         mov   @filzz,@mcloop        ; Setup move command
     62EA 22AE     
     62EC 8320     
0176 62EE 0460  28         b     @mcloop               ; Write data to VDP
     62F0 8320     
0177               *--------------------------------------------------------------
0181 62F2 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 62F4 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     62F6 4000     
0202 62F8 06C4  14 vdra    swpb  tmp0
0203 62FA D804  38         movb  tmp0,@vdpa
     62FC 8C02     
0204 62FE 06C4  14         swpb  tmp0
0205 6300 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6302 8C02     
0206 6304 045B  20         b     *r11                  ; Exit
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
0217 6306 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6308 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 630A 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     630C 4000     
0223 630E 06C4  14         swpb  tmp0                  ; \
0224 6310 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6312 8C02     
0225 6314 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6316 D804  38         movb  tmp0,@vdpa            ; /
     6318 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 631A 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 631C D7C5  30         movb  tmp1,*r15             ; Write byte
0232 631E 045B  20         b     *r11                  ; Exit
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
0251 6320 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6322 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6324 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6326 8C02     
0257 6328 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 632A D804  38         movb  tmp0,@vdpa            ; /
     632C 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 632E D120  34         movb  @vdpr,tmp0            ; Read byte
     6330 8800     
0263 6332 0984  56         srl   tmp0,8                ; Right align
0264 6334 045B  20         b     *r11                  ; Exit
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
0283 6336 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6338 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 633A C144  18         mov   tmp0,tmp1
0289 633C 05C5  14         inct  tmp1
0290 633E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 6340 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6342 FF00     
0292 6344 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 6346 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6348 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 634A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     634C 8000     
0298 634E 0206  20         li    tmp2,8
     6350 0008     
0299 6352 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6354 830B     
0300 6356 06C5  14         swpb  tmp1
0301 6358 D805  38         movb  tmp1,@vdpa
     635A 8C02     
0302 635C 06C5  14         swpb  tmp1
0303 635E D805  38         movb  tmp1,@vdpa
     6360 8C02     
0304 6362 0225  22         ai    tmp1,>0100
     6364 0100     
0305 6366 0606  14         dec   tmp2
0306 6368 16F4  14         jne   vidta1                ; Next register
0307 636A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     636C 833A     
0308 636E 045B  20         b     *r11
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
0325 6370 C13B  30 putvr   mov   *r11+,tmp0
0326 6372 0264  22 putvrx  ori   tmp0,>8000
     6374 8000     
0327 6376 06C4  14         swpb  tmp0
0328 6378 D804  38         movb  tmp0,@vdpa
     637A 8C02     
0329 637C 06C4  14         swpb  tmp0
0330 637E D804  38         movb  tmp0,@vdpa
     6380 8C02     
0331 6382 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 6384 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 6386 C10E  18         mov   r14,tmp0
0341 6388 0984  56         srl   tmp0,8
0342 638A 06A0  32         bl    @putvrx               ; Write VR#0
     638C 232E     
0343 638E 0204  20         li    tmp0,>0100
     6390 0100     
0344 6392 D820  54         movb  @r14lb,@tmp0lb
     6394 831D     
     6396 8309     
0345 6398 06A0  32         bl    @putvrx               ; Write VR#1
     639A 232E     
0346 639C 0458  20         b     *tmp4                 ; Exit
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
0360 639E C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63A0 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63A2 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63A4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63A6 7FFF     
0364 63A8 2120  38         coc   @wbit0,tmp0
     63AA 2020     
0365 63AC 1604  14         jne   ldfnt1
0366 63AE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63B0 8000     
0367 63B2 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63B4 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63B6 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63B8 23DC     
0372 63BA D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63BC 9C02     
0373 63BE 06C4  14         swpb  tmp0
0374 63C0 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     63C2 9C02     
0375 63C4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     63C6 9800     
0376 63C8 06C5  14         swpb  tmp1
0377 63CA D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     63CC 9800     
0378 63CE 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 63D0 D805  38         movb  tmp1,@grmwa
     63D2 9C02     
0383 63D4 06C5  14         swpb  tmp1
0384 63D6 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     63D8 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 63DA C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 63DC 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     63DE 22B0     
0390 63E0 05C8  14         inct  tmp4                  ; R11=R11+2
0391 63E2 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 63E4 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63E6 7FFF     
0393 63E8 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63EA 23DE     
0394 63EC C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     63EE 23E0     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 63F0 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 63F2 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 63F4 D120  34         movb  @grmrd,tmp0
     63F6 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 63F8 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     63FA 2020     
0405 63FC 1603  14         jne   ldfnt3                ; No, so skip
0406 63FE D1C4  18         movb  tmp0,tmp3
0407 6400 0917  56         srl   tmp3,1
0408 6402 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6404 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6406 8C00     
0413 6408 0606  14         dec   tmp2
0414 640A 16F2  14         jne   ldfnt2
0415 640C 05C8  14         inct  tmp4                  ; R11=R11+2
0416 640E 020F  20         li    r15,vdpw              ; Set VDP write address
     6410 8C00     
0417 6412 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6414 7FFF     
0418 6416 0458  20         b     *tmp4                 ; Exit
0419 6418 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     641A 2000     
     641C 8C00     
0420 641E 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 6420 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6422 0200     
     6424 0000     
0425 6426 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6428 01C0     
     642A 0101     
0426 642C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     642E 02A0     
     6430 0101     
0427 6432 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6434 00E0     
     6436 0101     
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
0445 6438 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 643A C3A0  34         mov   @wyx,r14              ; Get YX
     643C 832A     
0447 643E 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 6440 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6442 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6444 C3A0  34         mov   @wyx,r14              ; Get YX
     6446 832A     
0454 6448 024E  22         andi  r14,>00ff             ; Remove Y
     644A 00FF     
0455 644C A3CE  18         a     r14,r15               ; pos = pos + X
0456 644E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6450 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 6452 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 6454 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 6456 020F  20         li    r15,vdpw              ; VDP write address
     6458 8C00     
0463 645A 045B  20         b     *r11
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
0481 645C C17B  30 putstr  mov   *r11+,tmp1
0482 645E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 6460 C1CB  18 xutstr  mov   r11,tmp3
0484 6462 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6464 23F4     
0485 6466 C2C7  18         mov   tmp3,r11
0486 6468 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 646A C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 646C 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 646E 0286  22         ci    tmp2,255              ; Length > 255 ?
     6470 00FF     
0494 6472 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 6474 0460  28         b     @xpym2v               ; Display string
     6476 2486     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 6478 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     647A FFCE     
0501 647C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     647E 2026     
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
0517 6480 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6482 832A     
0518 6484 0460  28         b     @putstr
     6486 2418     
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
0539 6488 0649  14         dect  stack
0540 648A C64B  30         mov   r11,*stack            ; Save return address
0541 648C 0649  14         dect  stack
0542 648E C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 6490 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 6492 0987  56         srl   tmp3,8                ; Right align
0549               
0550 6494 0649  14         dect  stack
0551 6496 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 6498 0649  14         dect  stack
0553 649A C646  30         mov   tmp2,*stack           ; Push tmp2
0554 649C 0649  14         dect  stack
0555 649E C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64A0 06A0  32         bl    @xutst0               ; Display string
     64A2 241A     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64A4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64AA 06A0  32         bl    @down                 ; Move cursor down
     64AC 26CE     
0566               
0567 64AE A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 64B0 0585  14         inc   tmp1                  ; Consider length byte
0569 64B2 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     64B4 2002     
0570 64B6 1301  14         jeq   !                     ; Yes, skip adjustment
0571 64B8 0585  14         inc   tmp1                  ; Make address even
0572 64BA 0606  14 !       dec   tmp2
0573 64BC 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 64BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 64C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 64C2 045B  20         b     *r11                  ; Return
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
0020 64C4 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64C6 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64C8 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 64CA C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64CC 1604  14         jne   !                     ; No, continue
0028               
0029 64CE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64D0 FFCE     
0030 64D2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64D4 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64D6 0264  22 !       ori   tmp0,>4000
     64D8 4000     
0035 64DA 06C4  14         swpb  tmp0
0036 64DC D804  38         movb  tmp0,@vdpa
     64DE 8C02     
0037 64E0 06C4  14         swpb  tmp0
0038 64E2 D804  38         movb  tmp0,@vdpa
     64E4 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 64E6 020F  20         li    r15,vdpw              ; Set VDP write address
     64E8 8C00     
0043 64EA C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     64EC 24B0     
     64EE 8320     
0044 64F0 0460  28         b     @mcloop               ; Write data to VDP and return
     64F2 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 64F4 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 64F6 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 64F8 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 64FA C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 64FC 06C4  14 xpyv2m  swpb  tmp0
0027 64FE D804  38         movb  tmp0,@vdpa
     6500 8C02     
0028 6502 06C4  14         swpb  tmp0
0029 6504 D804  38         movb  tmp0,@vdpa
     6506 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6508 020F  20         li    r15,vdpr              ; Set VDP read address
     650A 8800     
0034 650C C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     650E 24D2     
     6510 8320     
0035 6512 0460  28         b     @mcloop               ; Read data from VDP
     6514 8320     
0036 6516 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6518 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 651A C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 651C C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 651E C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6520 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6522 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6524 FFCE     
0034 6526 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6528 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 652A 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     652C 0001     
0039 652E 1603  14         jne   cpym0                 ; No, continue checking
0040 6530 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6532 04C6  14         clr   tmp2                  ; Reset counter
0042 6534 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6536 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6538 7FFF     
0047 653A C1C4  18         mov   tmp0,tmp3
0048 653C 0247  22         andi  tmp3,1
     653E 0001     
0049 6540 1618  14         jne   cpyodd                ; Odd source address handling
0050 6542 C1C5  18 cpym1   mov   tmp1,tmp3
0051 6544 0247  22         andi  tmp3,1
     6546 0001     
0052 6548 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 654A 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     654C 2020     
0057 654E 1605  14         jne   cpym3
0058 6550 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     6552 2534     
     6554 8320     
0059 6556 0460  28         b     @mcloop               ; Copy memory and exit
     6558 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 655A C1C6  18 cpym3   mov   tmp2,tmp3
0064 655C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     655E 0001     
0065 6560 1301  14         jeq   cpym4
0066 6562 0606  14         dec   tmp2                  ; Make TMP2 even
0067 6564 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 6566 0646  14         dect  tmp2
0069 6568 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 656A C1C7  18         mov   tmp3,tmp3
0074 656C 1301  14         jeq   cpymz
0075 656E D554  38         movb  *tmp0,*tmp1
0076 6570 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 6572 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     6574 8000     
0081 6576 10E9  14         jmp   cpym2
0082 6578 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 657A C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 657C 0649  14         dect  stack
0065 657E C64B  30         mov   r11,*stack            ; Push return address
0066 6580 0649  14         dect  stack
0067 6582 C640  30         mov   r0,*stack             ; Push r0
0068 6584 0649  14         dect  stack
0069 6586 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 6588 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 658A 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 658C 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     658E 4000     
0077 6590 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     6592 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 6594 020C  20         li    r12,>1e00             ; SAMS CRU address
     6596 1E00     
0082 6598 04C0  14         clr   r0
0083 659A 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 659C D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 659E D100  18         movb  r0,tmp0
0086 65A0 0984  56         srl   tmp0,8                ; Right align
0087 65A2 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65A4 833C     
0088 65A6 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65A8 C339  30         mov   *stack+,r12           ; Pop r12
0094 65AA C039  30         mov   *stack+,r0            ; Pop r0
0095 65AC C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65AE 045B  20         b     *r11                  ; Return to caller
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
0131 65B0 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65B2 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65B4 0649  14         dect  stack
0135 65B6 C64B  30         mov   r11,*stack            ; Push return address
0136 65B8 0649  14         dect  stack
0137 65BA C640  30         mov   r0,*stack             ; Push r0
0138 65BC 0649  14         dect  stack
0139 65BE C64C  30         mov   r12,*stack            ; Push r12
0140 65C0 0649  14         dect  stack
0141 65C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65C4 0649  14         dect  stack
0143 65C6 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65C8 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65CA 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 65CC 0284  22         ci    tmp0,255              ; Crash if page > 255
     65CE 00FF     
0153 65D0 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 65D2 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65D4 001E     
0158 65D6 150A  14         jgt   !
0159 65D8 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65DA 0004     
0160 65DC 1107  14         jlt   !
0161 65DE 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65E0 0012     
0162 65E2 1508  14         jgt   sams.page.set.switch_page
0163 65E4 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65E6 0006     
0164 65E8 1501  14         jgt   !
0165 65EA 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 65EC C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     65EE FFCE     
0170 65F0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65F2 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 65F4 020C  20         li    r12,>1e00             ; SAMS CRU address
     65F6 1E00     
0176 65F8 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 65FA 06C0  14         swpb  r0                    ; LSB to MSB
0178 65FC 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 65FE D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6600 4000     
0180 6602 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6604 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6606 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6608 C339  30         mov   *stack+,r12           ; Pop r12
0188 660A C039  30         mov   *stack+,r0            ; Pop r0
0189 660C C2F9  30         mov   *stack+,r11           ; Pop return address
0190 660E 045B  20         b     *r11                  ; Return to caller
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
0204 6610 020C  20         li    r12,>1e00             ; SAMS CRU address
     6612 1E00     
0205 6614 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6616 045B  20         b     *r11                  ; Return to caller
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
0227 6618 020C  20         li    r12,>1e00             ; SAMS CRU address
     661A 1E00     
0228 661C 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 661E 045B  20         b     *r11                  ; Return to caller
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
0260 6620 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 6622 0649  14         dect  stack
0263 6624 C64B  30         mov   r11,*stack            ; Save return address
0264 6626 0649  14         dect  stack
0265 6628 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 662A 0649  14         dect  stack
0267 662C C645  30         mov   tmp1,*stack           ; Save tmp1
0268 662E 0649  14         dect  stack
0269 6630 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 6632 0649  14         dect  stack
0271 6634 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6636 0206  20         li    tmp2,8                ; Set loop counter
     6638 0008     
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 663A C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 663C C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 663E 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6640 2570     
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 6642 0606  14         dec   tmp2                  ; Next iteration
0288 6644 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6646 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6648 25CC     
0294                                                   ; / activating changes.
0295               
0296 664A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 664C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 664E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 6650 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 6652 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 6654 045B  20         b     *r11                  ; Return to caller
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
0318 6656 0649  14         dect  stack
0319 6658 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 665A 06A0  32         bl    @sams.layout
     665C 25DC     
0324 665E 2620                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 6660 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 6662 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 6664 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6666 0002     
0336 6668 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     666A 0003     
0337 666C A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     666E 000A     
0338 6670 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     6672 000B     
0339 6674 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6676 000C     
0340 6678 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     667A 000D     
0341 667C E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     667E 000E     
0342 6680 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     6682 000F     
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
0363 6684 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 6686 0649  14         dect  stack
0366 6688 C64B  30         mov   r11,*stack            ; Push return address
0367 668A 0649  14         dect  stack
0368 668C C644  30         mov   tmp0,*stack           ; Push tmp0
0369 668E 0649  14         dect  stack
0370 6690 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 6692 0649  14         dect  stack
0372 6694 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 6696 0649  14         dect  stack
0374 6698 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 669A 0205  20         li    tmp1,sams.layout.copy.data
     669C 2678     
0379 669E 0206  20         li    tmp2,8                ; Set loop counter
     66A0 0008     
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66A2 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66A4 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66A6 2538     
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66A8 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66AA 833C     
0390               
0391 66AC 0606  14         dec   tmp2                  ; Next iteration
0392 66AE 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66B0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66B2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66BA 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66BC 2000             data  >2000                 ; >2000-2fff
0408 66BE 3000             data  >3000                 ; >3000-3fff
0409 66C0 A000             data  >a000                 ; >a000-afff
0410 66C2 B000             data  >b000                 ; >b000-bfff
0411 66C4 C000             data  >c000                 ; >c000-cfff
0412 66C6 D000             data  >d000                 ; >d000-dfff
0413 66C8 E000             data  >e000                 ; >e000-efff
0414 66CA F000             data  >f000                 ; >f000-ffff
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
0009 66CC 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66CE FFBF     
0010 66D0 0460  28         b     @putv01
     66D2 2340     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66D4 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66D6 0040     
0018 66D8 0460  28         b     @putv01
     66DA 2340     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66DC 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66DE FFDF     
0026 66E0 0460  28         b     @putv01
     66E2 2340     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66E4 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66E6 0020     
0034 66E8 0460  28         b     @putv01
     66EA 2340     
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
0010 66EC 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     66EE FFFE     
0011 66F0 0460  28         b     @putv01
     66F2 2340     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 66F4 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     66F6 0001     
0019 66F8 0460  28         b     @putv01
     66FA 2340     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 66FC 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     66FE FFFD     
0027 6700 0460  28         b     @putv01
     6702 2340     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6704 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6706 0002     
0035 6708 0460  28         b     @putv01
     670A 2340     
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
0018 670C C83B  50 at      mov   *r11+,@wyx
     670E 832A     
0019 6710 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6712 B820  54 down    ab    @hb$01,@wyx
     6714 2012     
     6716 832A     
0028 6718 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 671A 7820  54 up      sb    @hb$01,@wyx
     671C 2012     
     671E 832A     
0037 6720 045B  20         b     *r11
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
0049 6722 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6724 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6726 832A     
0051 6728 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     672A 832A     
0052 672C 045B  20         b     *r11
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
0021 672E C120  34 yx2px   mov   @wyx,tmp0
     6730 832A     
0022 6732 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6734 06C4  14         swpb  tmp0                  ; Y<->X
0024 6736 04C5  14         clr   tmp1                  ; Clear before copy
0025 6738 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 673A 20A0  38         coc   @wbit1,config         ; f18a present ?
     673C 201E     
0030 673E 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6740 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6742 833A     
     6744 272A     
0032 6746 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6748 0A15  56         sla   tmp1,1                ; X = X * 2
0035 674A B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 674C 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     674E 0500     
0037 6750 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6752 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6754 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6756 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6758 D105  18         movb  tmp1,tmp0
0051 675A 06C4  14         swpb  tmp0                  ; X<->Y
0052 675C 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     675E 2020     
0053 6760 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6762 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6764 2012     
0059 6766 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6768 2024     
0060 676A 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 676C 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 676E 0050            data   80
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
0013 6770 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6772 06A0  32         bl    @putvr                ; Write once
     6774 232C     
0015 6776 391C             data  >391c                 ; VR1/57, value 00011100
0016 6778 06A0  32         bl    @putvr                ; Write twice
     677A 232C     
0017 677C 391C             data  >391c                 ; VR1/57, value 00011100
0018 677E 06A0  32         bl    @putvr
     6780 232C     
0019 6782 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 6784 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 6786 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 6788 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     678A 232C     
0030 678C 3900             data  >3900
0031 678E 0458  20         b     *tmp4                 ; Exit
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
0043 6790 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 6792 06A0  32         bl    @cpym2v
     6794 2480     
0045 6796 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6798 2790     
     679A 0006     
0046 679C 06A0  32         bl    @putvr
     679E 232C     
0047 67A0 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 67A2 06A0  32         bl    @putvr
     67A4 232C     
0049 67A6 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67A8 0204  20         li    tmp0,>3f00
     67AA 3F00     
0055 67AC 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67AE 22B4     
0056 67B0 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67B2 8800     
0057 67B4 0984  56         srl   tmp0,8
0058 67B6 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67B8 8800     
0059 67BA C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 67BC 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 67BE 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67C0 BFFF     
0063 67C2 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 67C4 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67C6 4000     
0066               f18chk_exit:
0067 67C8 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     67CA 2288     
0068 67CC 3F00             data  >3f00,>00,6
     67CE 0000     
     67D0 0006     
0069 67D2 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 67D4 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 67D6 3F00             data  >3f00                 ; 3f02 / 3f00
0076 67D8 0340             data  >0340                 ; 3f04   0340  idle
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
0097 67DA C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 67DC 06A0  32         bl    @putvr
     67DE 232C     
0102 67E0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 67E2 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67E4 232C     
0105 67E6 3900             data  >3900                 ; Lock the F18a
0106 67E8 0458  20         b     *tmp4                 ; Exit
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
0125 67EA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 67EC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     67EE 201E     
0127 67F0 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 67F2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     67F4 8802     
0132 67F6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     67F8 232C     
0133 67FA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 67FC 04C4  14         clr   tmp0
0135 67FE D120  34         movb  @vdps,tmp0
     6800 8802     
0136 6802 0984  56         srl   tmp0,8
0137 6804 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6806 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6808 832A     
0018 680A D17B  28         movb  *r11+,tmp1
0019 680C 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 680E D1BB  28         movb  *r11+,tmp2
0021 6810 0986  56         srl   tmp2,8                ; Repeat count
0022 6812 C1CB  18         mov   r11,tmp3
0023 6814 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6816 23F4     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6818 020B  20         li    r11,hchar1
     681A 27DC     
0028 681C 0460  28         b     @xfilv                ; Draw
     681E 228E     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6820 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6822 2022     
0033 6824 1302  14         jeq   hchar2                ; Yes, exit
0034 6826 C2C7  18         mov   tmp3,r11
0035 6828 10EE  14         jmp   hchar                 ; Next one
0036 682A 05C7  14 hchar2  inct  tmp3
0037 682C 0457  20         b     *tmp3                 ; Exit
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
0014 682E 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     6830 8334     
0015 6832 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     6834 2006     
0016 6836 0204  20         li    tmp0,muttab
     6838 2804     
0017 683A 0205  20         li    tmp1,sound            ; Sound generator port >8400
     683C 8400     
0018 683E D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 6840 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 6842 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 6844 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 6846 045B  20         b     *r11
0023 6848 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     684A DFFF     
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
0043 684C C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     684E 8334     
0044 6850 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     6852 8336     
0045 6854 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     6856 FFF8     
0046 6858 E0BB  30         soc   *r11+,config          ; Set options
0047 685A D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     685C 2012     
     685E 831B     
0048 6860 045B  20         b     *r11
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
0059 6862 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     6864 2006     
0060 6866 1301  14         jeq   sdpla1                ; Yes, play
0061 6868 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 686A 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 686C 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     686E 831B     
     6870 2000     
0067 6872 1301  14         jeq   sdpla3                ; Play next note
0068 6874 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6876 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6878 2002     
0070 687A 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 687C C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     687E 8336     
0075 6880 06C4  14         swpb  tmp0
0076 6882 D804  38         movb  tmp0,@vdpa
     6884 8C02     
0077 6886 06C4  14         swpb  tmp0
0078 6888 D804  38         movb  tmp0,@vdpa
     688A 8C02     
0079 688C 04C4  14         clr   tmp0
0080 688E D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     6890 8800     
0081 6892 131E  14         jeq   sdexit                ; Yes. exit
0082 6894 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 6896 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     6898 8336     
0084 689A D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     689C 8800     
     689E 8400     
0085 68A0 0604  14         dec   tmp0
0086 68A2 16FB  14         jne   vdpla2
0087 68A4 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     68A6 8800     
     68A8 831B     
0088 68AA 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68AC 8336     
0089 68AE 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 68B0 C120  34 mmplay  mov   @wsdtmp,tmp0
     68B2 8336     
0094 68B4 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 68B6 130C  14         jeq   sdexit                ; Yes, exit
0096 68B8 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 68BA A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     68BC 8336     
0098 68BE D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     68C0 8400     
0099 68C2 0605  14         dec   tmp1
0100 68C4 16FC  14         jne   mmpla2
0101 68C6 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     68C8 831B     
0102 68CA 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     68CC 8336     
0103 68CE 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 68D0 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     68D2 2004     
0108 68D4 1607  14         jne   sdexi2                ; No, exit
0109 68D6 C820  54         mov   @wsdlst,@wsdtmp
     68D8 8334     
     68DA 8336     
0110 68DC D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     68DE 2012     
     68E0 831B     
0111 68E2 045B  20 sdexi1  b     *r11                  ; Exit
0112 68E4 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     68E6 FFF8     
0113 68E8 045B  20         b     *r11                  ; Exit
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
0016 68EA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     68EC 2020     
0017 68EE 020C  20         li    r12,>0024
     68F0 0024     
0018 68F2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     68F4 2942     
0019 68F6 04C6  14         clr   tmp2
0020 68F8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 68FA 04CC  14         clr   r12
0025 68FC 1F08  20         tb    >0008                 ; Shift-key ?
0026 68FE 1302  14         jeq   realk1                ; No
0027 6900 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6902 2972     
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6904 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6906 1302  14         jeq   realk2                ; No
0033 6908 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     690A 29A2     
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 690C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 690E 1302  14         jeq   realk3                ; No
0039 6910 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6912 29D2     
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6914 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     6916 200C     
0044 6918 1E15  20         sbz   >0015                 ; Set P5
0045 691A 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 691C 1302  14         jeq   realk4                ; No
0047 691E E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     6920 200C     
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 6922 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 6924 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6926 0006     
0053 6928 0606  14 realk5  dec   tmp2
0054 692A 020C  20         li    r12,>24               ; CRU address for P2-P4
     692C 0024     
0055 692E 06C6  14         swpb  tmp2
0056 6930 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 6932 06C6  14         swpb  tmp2
0058 6934 020C  20         li    r12,6                 ; CRU read address
     6936 0006     
0059 6938 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 693A 0547  14         inv   tmp3                  ;
0061 693C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     693E FF00     
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 6940 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 6942 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 6944 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 6946 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 6948 0285  22         ci    tmp1,8
     694A 0008     
0070 694C 1AFA  14         jl    realk6
0071 694E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 6950 1BEB  14         jh    realk5                ; No, next column
0073 6952 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 6954 C206  18 realk8  mov   tmp2,tmp4
0078 6956 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 6958 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 695A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 695C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 695E 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 6960 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 6962 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     6964 200C     
0089 6966 1608  14         jne   realka                ; No, continue saving key
0090 6968 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     696A 296C     
0091 696C 1A05  14         jl    realka
0092 696E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6970 296A     
0093 6972 1B02  14         jh    realka                ; No, continue
0094 6974 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     6976 E000     
0095 6978 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     697A 833C     
0096 697C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     697E 200A     
0097 6980 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     6982 8C00     
0098                                                   ; / using R15 as temp storage
0099 6984 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 6986 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6988 0000     
     698A FF0D     
     698C 203D     
0102 698E 7877             text  'xws29ol.'
     6990 7332     
     6992 396F     
     6994 6C2E     
0103 6996 6365             text  'ced38ik,'
     6998 6433     
     699A 3869     
     699C 6B2C     
0104 699E 7672             text  'vrf47ujm'
     69A0 6634     
     69A2 3775     
     69A4 6A6D     
0105 69A6 6274             text  'btg56yhn'
     69A8 6735     
     69AA 3679     
     69AC 686E     
0106 69AE 7A71             text  'zqa10p;/'
     69B0 6131     
     69B2 3070     
     69B4 3B2F     
0107 69B6 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     69B8 0000     
     69BA FF0D     
     69BC 202B     
0108 69BE 5857             text  'XWS@(OL>'
     69C0 5340     
     69C2 284F     
     69C4 4C3E     
0109 69C6 4345             text  'CED#*IK<'
     69C8 4423     
     69CA 2A49     
     69CC 4B3C     
0110 69CE 5652             text  'VRF$&UJM'
     69D0 4624     
     69D2 2655     
     69D4 4A4D     
0111 69D6 4254             text  'BTG%^YHN'
     69D8 4725     
     69DA 5E59     
     69DC 484E     
0112 69DE 5A51             text  'ZQA!)P:-'
     69E0 4121     
     69E2 2950     
     69E4 3A2D     
0113 69E6 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     69E8 0000     
     69EA FF0D     
     69EC 2005     
0114 69EE 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     69F0 0804     
     69F2 0F27     
     69F4 C2B9     
0115 69F6 600B             data  >600b,>0907,>063f,>c1B8
     69F8 0907     
     69FA 063F     
     69FC C1B8     
0116 69FE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6A00 7B02     
     6A02 015F     
     6A04 C0C3     
0117 6A06 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6A08 7D0E     
     6A0A 0CC6     
     6A0C BFC4     
0118 6A0E 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6A10 7C03     
     6A12 BC22     
     6A14 BDBA     
0119 6A16 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6A18 0000     
     6A1A FF0D     
     6A1C 209D     
0120 6A1E 9897             data  >9897,>93b2,>9f8f,>8c9B
     6A20 93B2     
     6A22 9F8F     
     6A24 8C9B     
0121 6A26 8385             data  >8385,>84b3,>9e89,>8b80
     6A28 84B3     
     6A2A 9E89     
     6A2C 8B80     
0122 6A2E 9692             data  >9692,>86b4,>b795,>8a8D
     6A30 86B4     
     6A32 B795     
     6A34 8A8D     
0123 6A36 8294             data  >8294,>87b5,>b698,>888E
     6A38 87B5     
     6A3A B698     
     6A3C 888E     
0124 6A3E 9A91             data  >9a91,>81b1,>b090,>9cBB
     6A40 81B1     
     6A42 B090     
     6A44 9CBB     
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
0023 6A46 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6A48 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6A4A 8340     
0025 6A4C 04E0  34         clr   @waux1
     6A4E 833C     
0026 6A50 04E0  34         clr   @waux2
     6A52 833E     
0027 6A54 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6A56 833C     
0028 6A58 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6A5A 0205  20         li    tmp1,4                ; 4 nibbles
     6A5C 0004     
0033 6A5E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6A60 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6A62 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A64 0286  22         ci    tmp2,>000a
     6A66 000A     
0039 6A68 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A6A C21B  26         mov   *r11,tmp4
0045 6A6C 0988  56         srl   tmp4,8                ; Right justify
0046 6A6E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A70 FFF6     
0047 6A72 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A74 C21B  26         mov   *r11,tmp4
0054 6A76 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A78 00FF     
0055               
0056 6A7A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A7C 06C6  14         swpb  tmp2
0058 6A7E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A80 0944  56         srl   tmp0,4                ; Next nibble
0060 6A82 0605  14         dec   tmp1
0061 6A84 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A86 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A88 BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A8A C160  34         mov   @waux3,tmp1           ; Get pointer
     6A8C 8340     
0067 6A8E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6A90 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6A92 C120  34         mov   @waux2,tmp0
     6A94 833E     
0070 6A96 06C4  14         swpb  tmp0
0071 6A98 DD44  32         movb  tmp0,*tmp1+
0072 6A9A 06C4  14         swpb  tmp0
0073 6A9C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6A9E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6AA0 8340     
0078 6AA2 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6AA4 2016     
0079 6AA6 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6AA8 C120  34         mov   @waux1,tmp0
     6AAA 833C     
0084 6AAC 06C4  14         swpb  tmp0
0085 6AAE DD44  32         movb  tmp0,*tmp1+
0086 6AB0 06C4  14         swpb  tmp0
0087 6AB2 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6AB4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6AB6 2020     
0092 6AB8 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6ABA 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6ABC 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6ABE 7FFF     
0098 6AC0 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6AC2 8340     
0099 6AC4 0460  28         b     @xutst0               ; Display string
     6AC6 241A     
0100 6AC8 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6ACA C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6ACC 832A     
0122 6ACE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AD0 8000     
0123 6AD2 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6AD4 0207  20 mknum   li    tmp3,5                ; Digit counter
     6AD6 0005     
0020 6AD8 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6ADA C155  26         mov   *tmp1,tmp1            ; /
0022 6ADC C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6ADE 0228  22         ai    tmp4,4                ; Get end of buffer
     6AE0 0004     
0024 6AE2 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6AE4 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6AE6 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6AE8 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6AEA 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6AEC B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6AEE D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6AF0 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6AF2 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6AF4 0607  14         dec   tmp3                  ; Decrease counter
0036 6AF6 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6AF8 0207  20         li    tmp3,4                ; Check first 4 digits
     6AFA 0004     
0041 6AFC 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6AFE C11B  26         mov   *r11,tmp0
0043 6B00 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6B02 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6B04 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6B06 05CB  14 mknum3  inct  r11
0047 6B08 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B0A 2020     
0048 6B0C 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6B0E 045B  20         b     *r11                  ; Exit
0050 6B10 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6B12 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6B14 13F8  14         jeq   mknum3                ; Yes, exit
0053 6B16 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6B18 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6B1A 7FFF     
0058 6B1C C10B  18         mov   r11,tmp0
0059 6B1E 0224  22         ai    tmp0,-4
     6B20 FFFC     
0060 6B22 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6B24 0206  20         li    tmp2,>0500            ; String length = 5
     6B26 0500     
0062 6B28 0460  28         b     @xutstr               ; Display string
     6B2A 241C     
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
0093 6B2C C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6B2E C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6B30 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6B32 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6B34 0207  20         li    tmp3,5                ; Set counter
     6B36 0005     
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6B38 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6B3A 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6B3C 0584  14         inc   tmp0                  ; Next character
0105 6B3E 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6B40 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6B42 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6B44 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6B46 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6B48 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6B4A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6B4C 0607  14         dec   tmp3                  ; Last character ?
0121 6B4E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6B50 045B  20         b     *r11                  ; Return
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
0139 6B52 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6B54 832A     
0140 6B56 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B58 8000     
0141 6B5A 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6B5C 0649  14         dect  stack
0023 6B5E C64B  30         mov   r11,*stack            ; Save return address
0024 6B60 0649  14         dect  stack
0025 6B62 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B64 0649  14         dect  stack
0027 6B66 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B68 0649  14         dect  stack
0029 6B6A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B6C 0649  14         dect  stack
0031 6B6E C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B70 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B72 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B74 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B76 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B78 0649  14         dect  stack
0044 6B7A C64B  30         mov   r11,*stack            ; Save return address
0045 6B7C 0649  14         dect  stack
0046 6B7E C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B80 0649  14         dect  stack
0048 6B82 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B84 0649  14         dect  stack
0050 6B86 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B88 0649  14         dect  stack
0052 6B8A C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6B8C C1D4  26 !       mov   *tmp0,tmp3
0057 6B8E 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6B90 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6B92 00FF     
0059 6B94 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6B96 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6B98 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6B9A 0584  14         inc   tmp0                  ; Next byte
0067 6B9C 0607  14         dec   tmp3                  ; Shorten string length
0068 6B9E 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6BA0 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6BA2 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6BA4 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6BA6 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6BA8 C187  18         mov   tmp3,tmp2
0078 6BAA 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6BAC DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6BAE 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6BB0 24DA     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6BB2 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6BB4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BB6 FFCE     
0090 6BB8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BBA 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6BBC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6BBE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6BC0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6BC2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6BC4 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6BC6 045B  20         b     *r11                  ; Return to caller
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
0123 6BC8 0649  14         dect  stack
0124 6BCA C64B  30         mov   r11,*stack            ; Save return address
0125 6BCC 05D9  26         inct  *stack                ; Skip "data P0"
0126 6BCE 05D9  26         inct  *stack                ; Skip "data P1"
0127 6BD0 0649  14         dect  stack
0128 6BD2 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6BD4 0649  14         dect  stack
0130 6BD6 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6BD8 0649  14         dect  stack
0132 6BDA C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6BDC C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6BDE C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6BE0 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6BE2 0649  14         dect  stack
0144 6BE4 C64B  30         mov   r11,*stack            ; Save return address
0145 6BE6 0649  14         dect  stack
0146 6BE8 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6BEA 0649  14         dect  stack
0148 6BEC C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6BEE 0649  14         dect  stack
0150 6BF0 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6BF2 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6BF4 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6BF6 0586  14         inc   tmp2
0161 6BF8 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6BFA 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6BFC 0286  22         ci    tmp2,255
     6BFE 00FF     
0167 6C00 1505  14         jgt   string.getlenc.panic
0168 6C02 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6C04 0606  14         dec   tmp2                  ; One time adjustment
0174 6C06 C806  38         mov   tmp2,@waux1           ; Store length
     6C08 833C     
0175 6C0A 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6C0C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C0E FFCE     
0181 6C10 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C12 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6C14 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6C16 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6C18 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6C1A C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6C1C 045B  20         b     *r11                  ; Return to caller
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
0023 6C1E C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     6C20 F960     
0024 6C22 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6C24 F962     
0025 6C26 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6C28 F964     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6C2A 0200  20         li    r0,>8306              ; Scratchpad source address
     6C2C 8306     
0030 6C2E 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6C30 F966     
0031 6C32 0202  20         li    r2,62                 ; Loop counter
     6C34 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 6C36 CC70  46         mov   *r0+,*r1+
0037 6C38 CC70  46         mov   *r0+,*r1+
0038 6C3A 0642  14         dect  r2
0039 6C3C 16FC  14         jne   cpu.scrpad.backup.copy
0040 6C3E C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     6C40 83FE     
     6C42 FA5E     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6C44 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6C46 F960     
0046 6C48 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6C4A F962     
0047 6C4C C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6C4E F964     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 6C50 045B  20         b     *r11                  ; Return to caller
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
0069 6C52 0649  14         dect  stack
0070 6C54 C64B  30         mov   r11,*stack            ; Save return address
0071 6C56 0649  14         dect  stack
0072 6C58 C640  30         mov   r0,*stack             ; Push r0
0073 6C5A 0649  14         dect  stack
0074 6C5C C641  30         mov   r1,*stack             ; Push r1
0075 6C5E 0649  14         dect  stack
0076 6C60 C642  30         mov   r2,*stack             ; Push r2
0077                       ;------------------------------------------------------
0078                       ; Prepare for copy loop, WS
0079                       ;------------------------------------------------------
0080 6C62 0200  20         li    r0,cpu.scrpad.tgt
     6C64 F960     
0081 6C66 0201  20         li    r1,>8300
     6C68 8300     
0082 6C6A 0202  20         li    r2,64
     6C6C 0040     
0083                       ;------------------------------------------------------
0084                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0085                       ;------------------------------------------------------
0086               cpu.scrpad.restore.copy:
0087 6C6E CC70  46         mov   *r0+,*r1+
0088 6C70 CC70  46         mov   *r0+,*r1+
0089 6C72 0602  14         dec   r2
0090 6C74 16FC  14         jne   cpu.scrpad.restore.copy
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               cpu.scrpad.restore.exit:
0095 6C76 C0B9  30         mov   *stack+,r2            ; Pop r2
0096 6C78 C079  30         mov   *stack+,r1            ; Pop r1
0097 6C7A C039  30         mov   *stack+,r0            ; Pop r0
0098 6C7C C2F9  30         mov   *stack+,r11           ; Pop r11
0099 6C7E 045B  20         b     *r11                  ; Return to caller
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
0038 6C80 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 6C82 CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 6C84 CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 6C86 CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 6C88 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 6C8A CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 6C8C CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 6C8E CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 6C90 CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 6C92 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     6C94 8310     
0055                                                   ;        as of register r8
0056 6C96 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     6C98 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 6C9A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 6C9C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 6C9E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 6CA0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 6CA2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 6CA4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 6CA6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 6CA8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 6CAA 0606  14         dec   tmp2
0069 6CAC 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 6CAE C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 6CB0 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6CB2 2C74     
0075                                                   ; R14=PC
0076 6CB4 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 6CB6 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 6CB8 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6CBA 2C0E     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 6CBC 045B  20         b     *r11                  ; Return to caller
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
0119 6CBE C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0120                       ;------------------------------------------------------
0121                       ; Copy scratchpad memory to destination
0122                       ;------------------------------------------------------
0123               xcpu.scrpad.pgin:
0124 6CC0 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6CC2 8300     
0125 6CC4 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6CC6 0010     
0126                       ;------------------------------------------------------
0127                       ; Copy memory
0128                       ;------------------------------------------------------
0129 6CC8 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0130 6CCA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0131 6CCC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0132 6CCE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0133 6CD0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0134 6CD2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0135 6CD4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0136 6CD6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0137 6CD8 0606  14         dec   tmp2
0138 6CDA 16F6  14         jne   -!                    ; Loop until done
0139                       ;------------------------------------------------------
0140                       ; Switch workspace to scratchpad memory
0141                       ;------------------------------------------------------
0142 6CDC 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6CDE 8300     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               cpu.scrpad.pgin.exit:
0147 6CE0 045B  20         b     *r11                  ; Return to caller
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
0056 6CE2 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6CE4 2CA2             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6CE6 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6CE8 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6CEA A428     
0064 6CEC 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6CEE 201C     
0065 6CF0 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6CF2 8356     
0066 6CF4 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6CF6 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6CF8 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6CFA C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6CFC A434     
0073                       ;---------------------------; Inline VSBR start
0074 6CFE 06C0  14         swpb  r0                    ;
0075 6D00 D800  38         movb  r0,@vdpa              ; Send low byte
     6D02 8C02     
0076 6D04 06C0  14         swpb  r0                    ;
0077 6D06 D800  38         movb  r0,@vdpa              ; Send high byte
     6D08 8C02     
0078 6D0A D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6D0C 8800     
0079                       ;---------------------------; Inline VSBR end
0080 6D0E 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6D10 0704  14         seto  r4                    ; Init counter
0086 6D12 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D14 A420     
0087 6D16 0580  14 !       inc   r0                    ; Point to next char of name
0088 6D18 0584  14         inc   r4                    ; Increment char counter
0089 6D1A 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6D1C 0007     
0090 6D1E 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6D20 80C4  18         c     r4,r3                 ; End of name?
0093 6D22 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6D24 06C0  14         swpb  r0                    ;
0098 6D26 D800  38         movb  r0,@vdpa              ; Send low byte
     6D28 8C02     
0099 6D2A 06C0  14         swpb  r0                    ;
0100 6D2C D800  38         movb  r0,@vdpa              ; Send high byte
     6D2E 8C02     
0101 6D30 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6D32 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6D34 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6D36 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6D38 2E0A     
0109 6D3A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6D3C C104  18         mov   r4,r4                 ; Check if length = 0
0115 6D3E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6D40 04E0  34         clr   @>83d0
     6D42 83D0     
0118 6D44 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6D46 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6D48 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6D4A A432     
0121               
0122 6D4C 0584  14         inc   r4                    ; Adjust for dot
0123 6D4E A804  38         a     r4,@>8356             ; Point to position after name
     6D50 8356     
0124 6D52 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6D54 8356     
     6D56 A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6D58 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D5A 83E0     
0130 6D5C 04C1  14         clr   r1                    ; Version found of dsr
0131 6D5E 020C  20         li    r12,>0f00             ; Init cru address
     6D60 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6D62 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6D64 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6D66 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6D68 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6D6A 0100     
0145 6D6C 04E0  34         clr   @>83d0                ; Clear in case we are done
     6D6E 83D0     
0146 6D70 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D72 2000     
0147 6D74 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6D76 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6D78 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6D7A 1D00  20         sbo   0                     ; Turn on ROM
0154 6D7C 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6D7E 4000     
0155 6D80 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6D82 2E06     
0156 6D84 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6D86 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6D88 A40A     
0166 6D8A 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6D8C C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6D8E 83D2     
0172                                                   ; subprogram
0173               
0174 6D90 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6D92 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6D94 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6D96 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6D98 83D2     
0183                                                   ; subprogram
0184               
0185 6D9A 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6D9C C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6D9E 04C5  14         clr   r5                    ; Remove any old stuff
0194 6DA0 D160  34         movb  @>8355,r5             ; Get length as counter
     6DA2 8355     
0195 6DA4 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6DA6 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6DA8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6DAA 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6DAC 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6DAE A420     
0206 6DB0 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6DB2 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6DB4 0605  14         dec   r5                    ; Update loop counter
0211 6DB6 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6DB8 0581  14         inc   r1                    ; Next version found
0217 6DBA C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6DBC A42A     
0218 6DBE C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6DC0 A42C     
0219 6DC2 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6DC4 A430     
0220               
0221 6DC6 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6DC8 8C02     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6DCA 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6DCC 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6DCE 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6DD0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6DD2 A400     
0233 6DD4 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6DD6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6DD8 A428     
0239                                                   ; (8 or >a)
0240 6DDA 0281  22         ci    r1,8                  ; was it 8?
     6DDC 0008     
0241 6DDE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6DE0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6DE2 8350     
0243                                                   ; Get error byte from @>8350
0244 6DE4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6DE6 06C0  14         swpb  r0                    ;
0252 6DE8 D800  38         movb  r0,@vdpa              ; send low byte
     6DEA 8C02     
0253 6DEC 06C0  14         swpb  r0                    ;
0254 6DEE D800  38         movb  r0,@vdpa              ; send high byte
     6DF0 8C02     
0255 6DF2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6DF4 8800     
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6DF6 09D1  56         srl   r1,13                 ; just keep error bits
0263 6DF8 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6DFA 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6DFC 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6DFE 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E00 A400     
0275               dsrlnk.error.devicename_invalid:
0276 6E02 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6E04 06C1  14         swpb  r1                    ; put error in hi byte
0279 6E06 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6E08 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6E0A 201C     
0281                                                   ; / to indicate error
0282 6E0C 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6E0E A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6E10 2DCE             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6E12 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E14 83E0     
0316               
0317 6E16 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6E18 201C     
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6E1A 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6E1C A42A     
0322 6E1E C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6E20 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6E22 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6E24 8356     
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6E26 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6E28 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6E2A 8354     
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6E2C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E2E 8C02     
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6E30 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6E32 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6E34 4000     
     6E36 2E06     
0337 6E38 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6E3A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6E3C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6E3E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6E40 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6E42 A400     
0355 6E44 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6E46 A434     
0356               
0357 6E48 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6E4A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6E4C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6E4E 2E       dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6E50 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6E52 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6E54 0649  14         dect  stack
0052 6E56 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6E58 0204  20         li    tmp0,dsrlnk.savcru
     6E5A A42A     
0057 6E5C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6E5E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6E60 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6E62 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6E64 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6E66 37D7     
0065 6E68 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6E6A 8370     
0066                                                   ; / location
0067 6E6C C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6E6E A44C     
0068 6E70 04C5  14         clr   tmp1                  ; io.op.open
0069 6E72 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6E74 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6E76 0649  14         dect  stack
0097 6E78 C64B  30         mov   r11,*stack            ; Save return address
0098 6E7A 0205  20         li    tmp1,io.op.close      ; io.op.close
     6E7C 0001     
0099 6E7E 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6E80 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6E82 0649  14         dect  stack
0125 6E84 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6E86 0205  20         li    tmp1,io.op.read       ; io.op.read
     6E88 0002     
0128 6E8A 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6E8C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6E8E 0649  14         dect  stack
0155 6E90 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6E92 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6E94 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6E96 0005     
0159               
0160 6E98 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6E9A A43E     
0161               
0162 6E9C 06A0  32         bl    @xvputb               ; Write character count to PAB
     6E9E 22C6     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6EA0 0205  20         li    tmp1,io.op.write      ; io.op.write
     6EA2 0003     
0167 6EA4 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6EA6 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6EA8 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6EAA 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6EAC 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6EAE 1000  14         nop
0189               
0190               
0191               file.status:
0192 6EB0 1000  14         nop
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
0227 6EB2 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6EB4 A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6EB6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6EB8 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6EBA A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6EBC 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6EBE 22C6     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6EC0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6EC2 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6EC4 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6EC6 A44C     
0246               
0247 6EC8 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6ECA 22C6     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6ECC 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6ECE 0009     
0254 6ED0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6ED2 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6ED4 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6ED6 8322     
     6ED8 833C     
0259               
0260 6EDA C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6EDC A42A     
0261 6EDE 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6EE0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EE2 2C9E     
0268 6EE4 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6EE6 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6EE8 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6EEA 2DCA     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6EEC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6EEE C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6EF0 833C     
     6EF2 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6EF4 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6EF6 A436     
0292 6EF8 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6EFA 0005     
0293 6EFC 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6EFE 22DE     
0294 6F00 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6F02 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6F04 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6F06 045B  20         b     *r11                  ; Return to caller
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
0020 6F08 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F0A 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F0C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F0E 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F10 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F12 201C     
0029 6F14 1602  14         jne   tmgr1a                ; No, so move on
0030 6F16 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F18 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F1A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F1C 2020     
0035 6F1E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F20 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F22 2010     
0048 6F24 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F26 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F28 200E     
0050 6F2A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F2C 0460  28         b     @kthread              ; Run kernel thread
     6F2E 2F62     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F30 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F32 2014     
0056 6F34 13EB  14         jeq   tmgr1
0057 6F36 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F38 2012     
0058 6F3A 16E8  14         jne   tmgr1
0059 6F3C C120  34         mov   @wtiusr,tmp0
     6F3E 832E     
0060 6F40 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F42 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F44 2F60     
0065 6F46 C10A  18         mov   r10,tmp0
0066 6F48 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F4A 00FF     
0067 6F4C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F4E 201C     
0068 6F50 1303  14         jeq   tmgr5
0069 6F52 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F54 003C     
0070 6F56 1002  14         jmp   tmgr6
0071 6F58 0284  22 tmgr5   ci    tmp0,50
     6F5A 0032     
0072 6F5C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F5E 1001  14         jmp   tmgr8
0074 6F60 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F62 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F64 832C     
0079 6F66 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F68 FF00     
0080 6F6A C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F6C 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F6E 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F70 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F72 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F74 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F76 830C     
     6F78 830D     
0089 6F7A 1608  14         jne   tmgr10                ; No, get next slot
0090 6F7C 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F7E FF00     
0091 6F80 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F82 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F84 8330     
0096 6F86 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6F88 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6F8A 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6F8C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6F8E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6F90 8315     
     6F92 8314     
0103 6F94 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6F96 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6F98 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6F9A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6F9C 10F7  14         jmp   tmgr10                ; Process next slot
0108 6F9E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FA0 FF00     
0109 6FA2 10B4  14         jmp   tmgr1
0110 6FA4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6FA6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FA8 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6FAA 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6FAC 2006     
0023 6FAE 1602  14         jne   kthread_kb
0024 6FB0 06A0  32         bl    @sdpla1               ; Run sound player
     6FB2 2826     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FB4 06A0  32         bl    @realkb               ; Scan full keyboard
     6FB6 28A6     
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FB8 0460  28         b     @tmgr3                ; Exit
     6FBA 2EEC     
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
0017 6FBC C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FBE 832E     
0018 6FC0 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FC2 2012     
0019 6FC4 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EC8     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6FC6 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FC8 832E     
0029 6FCA 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FCC FEFF     
0030 6FCE 045B  20         b     *r11                  ; Return
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
0017 6FD0 C13B  30 mkslot  mov   *r11+,tmp0
0018 6FD2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6FD4 C184  18         mov   tmp0,tmp2
0023 6FD6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6FD8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6FDA 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6FDC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6FDE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6FE0 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6FE2 881B  46         c     *r11,@w$ffff          ; End of list ?
     6FE4 2022     
0035 6FE6 1301  14         jeq   mkslo1                ; Yes, exit
0036 6FE8 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6FEA 05CB  14 mkslo1  inct  r11
0041 6FEC 045B  20         b     *r11                  ; Exit
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
0052 6FEE C13B  30 clslot  mov   *r11+,tmp0
0053 6FF0 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6FF2 A120  34         a     @wtitab,tmp0          ; Add table base
     6FF4 832C     
0055 6FF6 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6FF8 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6FFA 045B  20         b     *r11                  ; Exit
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
0068 6FFC C13B  30 rsslot  mov   *r11+,tmp0
0069 6FFE 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 7000 A120  34         a     @wtitab,tmp0          ; Add table base
     7002 832C     
0071 7004 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 7006 C154  26         mov   *tmp0,tmp1
0073 7008 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     700A FF00     
0074 700C C505  30         mov   tmp1,*tmp0
0075 700E 045B  20         b     *r11                  ; Exit
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
0261 7010 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7012 8302     
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 7014 0300  24 runli1  limi  0                     ; Turn off interrupts
     7016 0000     
0267 7018 02E0  18         lwpi  ws1                   ; Activate workspace 1
     701A 8300     
0268 701C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     701E 83C0     
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 7020 0202  20 runli2  li    r2,>8308
     7022 8308     
0273 7024 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 7026 0282  22         ci    r2,>8400
     7028 8400     
0275 702A 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 702C 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     702E FFFF     
0280 7030 1602  14         jne   runli4                ; No, continue
0281 7032 0420  54         blwp  @0                    ; Yes, bye bye
     7034 0000     
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 7036 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7038 833C     
0286 703A 04C1  14         clr   r1                    ; Reset counter
0287 703C 0202  20         li    r2,10                 ; We test 10 times
     703E 000A     
0288 7040 C0E0  34 runli5  mov   @vdps,r3
     7042 8802     
0289 7044 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7046 2020     
0290 7048 1302  14         jeq   runli6
0291 704A 0581  14         inc   r1                    ; Increase counter
0292 704C 10F9  14         jmp   runli5
0293 704E 0602  14 runli6  dec   r2                    ; Next test
0294 7050 16F7  14         jne   runli5
0295 7052 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7054 1250     
0296 7056 1202  14         jle   runli7                ; No, so it must be NTSC
0297 7058 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     705A 201C     
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 705C 06A0  32 runli7  bl    @loadmc
     705E 2214     
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 7060 04C1  14 runli9  clr   r1
0306 7062 04C2  14         clr   r2
0307 7064 04C3  14         clr   r3
0308 7066 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     7068 AF00     
0309 706A 020F  20         li    r15,vdpw              ; Set VDP write address
     706C 8C00     
0311 706E 06A0  32         bl    @mute                 ; Mute sound generators
     7070 27EA     
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 7072 0280  22         ci    r0,>4a4a              ; Crash flag set?
     7074 4A4A     
0318 7076 1605  14         jne   runlia
0319 7078 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     707A 2288     
0320 707C 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     707E 0000     
     7080 3000     
0325 7082 06A0  32 runlia  bl    @filv
     7084 2288     
0326 7086 0FC0             data  pctadr,spfclr,16      ; Load color table
     7088 00F4     
     708A 0010     
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 708C 06A0  32         bl    @f18unl               ; Unlock the F18A
     708E 272C     
0334 7090 06A0  32         bl    @f18chk               ; Check if F18A is there \
     7092 274C     
0335 7094 06A0  32         bl    @f18chk               ; Check if F18A is there | js99er bug?
     7096 274C     
0336 7098 06A0  32         bl    @f18chk               ; Check if F18A is there /
     709A 274C     
0337 709C 06A0  32         bl    @f18lck               ; Lock the F18A again
     709E 2742     
0338               
0339 70A0 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     70A2 232C     
0340 70A4 3201                   data >3201            ; F18a VR50 (>32), bit 1
0342               *--------------------------------------------------------------
0343               * Check if there is a speech synthesizer attached
0344               *--------------------------------------------------------------
0346               *       <<skipped>>
0350               *--------------------------------------------------------------
0351               * Load video mode table & font
0352               *--------------------------------------------------------------
0353 70A6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70A8 22F2     
0354 70AA 3432             data  spvmod                ; Equate selected video mode table
0355 70AC 0204  20         li    tmp0,spfont           ; Get font option
     70AE 000C     
0356 70B0 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0357 70B2 1304  14         jeq   runlid                ; Yes, skip it
0358 70B4 06A0  32         bl    @ldfnt
     70B6 235A     
0359 70B8 1100             data  fntadr,spfont         ; Load specified font
     70BA 000C     
0360               *--------------------------------------------------------------
0361               * Did a system crash occur before runlib was called?
0362               *--------------------------------------------------------------
0363 70BC 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70BE 4A4A     
0364 70C0 1602  14         jne   runlie                ; No, continue
0365 70C2 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     70C4 2086     
0366               *--------------------------------------------------------------
0367               * Branch to main program
0368               *--------------------------------------------------------------
0369 70C6 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70C8 0040     
0370 70CA 0460  28         b     @main                 ; Give control to main program
     70CC 6046     
                   < stevie_b1.asm.37021
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
0021 70CE C13B  30         mov   *r11+,tmp0            ; P0
0022 70D0 C17B  30         mov   *r11+,tmp1            ; P1
0023 70D2 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 70D4 0649  14         dect  stack
0029 70D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 70D8 0649  14         dect  stack
0031 70DA C645  30         mov   tmp1,*stack           ; Push tmp1
0032 70DC 0649  14         dect  stack
0033 70DE C646  30         mov   tmp2,*stack           ; Push tmp2
0034 70E0 0649  14         dect  stack
0035 70E2 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 70E4 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     70E6 6000     
0040 70E8 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 70EA C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     70EC A226     
0044 70EE 0647  14         dect  tmp3
0045 70F0 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 70F2 0647  14         dect  tmp3
0047 70F4 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 70F6 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     70F8 A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 70FA 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 70FC 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 70FE 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 7100 0224  22         ai    tmp0,>0800
     7102 0800     
0066 7104 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 7106 0285  22         ci    tmp1,>ffff
     7108 FFFF     
0075 710A 1602  14         jne   !
0076 710C C160  34         mov   @parm1,tmp1
     710E A000     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 7110 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 7112 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 7114 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 7116 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7118 FFCE     
0092 711A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     711C 2026     
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 711E 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 7120 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     7122 A226     
0103 7124 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 7126 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 7128 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 712A C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 712C 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 712E 028B  22         ci    r11,>6000
     7130 6000     
0116 7132 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 7134 028B  22         ci    r11,>7fff
     7136 7FFF     
0118 7138 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 713A C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     713C A226     
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 713E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 7140 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 7142 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 7144 0225  22         ai    tmp1,>0800
     7146 0800     
0138 7148 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 714A 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 714C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     714E FFCE     
0145 7150 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7152 2026     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 7154 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 7156 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 7158 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 715A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 715C 045B  20         b     *r11                  ; Return to caller
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
0020 715E 0649  14         dect  stack
0021 7160 C64B  30         mov   r11,*stack            ; Save return address
0022 7162 0649  14         dect  stack
0023 7164 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 7166 0649  14         dect  stack
0025 7168 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 716A 0204  20         li    tmp0,fb.top
     716C D000     
0030 716E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     7170 A300     
0031 7172 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     7174 A304     
0032 7176 04E0  34         clr   @fb.row               ; Current row=0
     7178 A306     
0033 717A 04E0  34         clr   @fb.column            ; Current column=0
     717C A30C     
0034               
0035 717E 0204  20         li    tmp0,colrow
     7180 0050     
0036 7182 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7184 A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 7186 C160  34         mov   @tv.ruler.visible,tmp1
     7188 A210     
0041 718A 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 718C 0204  20         li    tmp0,pane.botrow-2
     718E 001B     
0043 7190 1002  14         jmp   fb.init.cont
0044 7192 0204  20 !       li    tmp0,pane.botrow-1
     7194 001C     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 7196 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     7198 A31A     
0050 719A C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     719C A31C     
0051               
0052 719E 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     71A0 A222     
0053 71A2 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     71A4 A310     
0054 71A6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     71A8 A316     
0055 71AA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     71AC A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 71AE 06A0  32         bl    @film
     71B0 2230     
0060 71B2 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     71B4 0000     
     71B6 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 71B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 71BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 71BC C2F9  30         mov   *stack+,r11           ; Pop r11
0068 71BE 045B  20         b     *r11                  ; Return to caller
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
0051 71C0 0649  14         dect  stack
0052 71C2 C64B  30         mov   r11,*stack            ; Save return address
0053 71C4 0649  14         dect  stack
0054 71C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 71C8 0204  20         li    tmp0,idx.top
     71CA B000     
0059 71CC C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     71CE A502     
0060               
0061 71D0 C120  34         mov   @tv.sams.b000,tmp0
     71D2 A206     
0062 71D4 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     71D6 A600     
0063 71D8 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     71DA A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 71DC 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     71DE 0004     
0068 71E0 C804  38         mov   tmp0,@idx.sams.hipage ; /
     71E2 A604     
0069               
0070 71E4 06A0  32         bl    @_idx.sams.mapcolumn.on
     71E6 31BE     
0071                                                   ; Index in continuous memory region
0072               
0073 71E8 06A0  32         bl    @film
     71EA 2230     
0074 71EC B000                   data idx.top,>00,idx.size * 5
     71EE 0000     
     71F0 5000     
0075                                                   ; Clear index
0076               
0077 71F2 06A0  32         bl    @_idx.sams.mapcolumn.off
     71F4 31F2     
0078                                                   ; Restore memory window layout
0079               
0080 71F6 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     71F8 A602     
     71FA A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 71FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 71FE C2F9  30         mov   *stack+,r11           ; Pop r11
0088 7200 045B  20         b     *r11                  ; Return to caller
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
0101 7202 0649  14         dect  stack
0102 7204 C64B  30         mov   r11,*stack            ; Push return address
0103 7206 0649  14         dect  stack
0104 7208 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 720A 0649  14         dect  stack
0106 720C C645  30         mov   tmp1,*stack           ; Push tmp1
0107 720E 0649  14         dect  stack
0108 7210 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 7212 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     7214 A602     
0113 7216 0205  20         li    tmp1,idx.top
     7218 B000     
0114 721A 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     721C 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 721E 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     7220 2570     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 7222 0584  14         inc   tmp0                  ; Next SAMS index page
0123 7224 0225  22         ai    tmp1,>1000            ; Next memory region
     7226 1000     
0124 7228 0606  14         dec   tmp2                  ; Update loop counter
0125 722A 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 722C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 722E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 7230 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 7232 C2F9  30         mov   *stack+,r11           ; Pop return address
0134 7234 045B  20         b     *r11                  ; Return to caller
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
0150 7236 0649  14         dect  stack
0151 7238 C64B  30         mov   r11,*stack            ; Push return address
0152 723A 0649  14         dect  stack
0153 723C C644  30         mov   tmp0,*stack           ; Push tmp0
0154 723E 0649  14         dect  stack
0155 7240 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 7242 0649  14         dect  stack
0157 7244 C646  30         mov   tmp2,*stack           ; Push tmp2
0158 7246 0649  14         dect  stack
0159 7248 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 724A 0205  20         li    tmp1,idx.top
     724C B000     
0164 724E 0206  20         li    tmp2,5                ; Always 5 pages
     7250 0005     
0165 7252 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     7254 A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 7256 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 7258 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     725A 2570     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 725C 0225  22         ai    tmp1,>1000            ; Next memory region
     725E 1000     
0176 7260 0606  14         dec   tmp2                  ; Update loop counter
0177 7262 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 7264 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 7266 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 7268 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 726A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 726C C2F9  30         mov   *stack+,r11           ; Pop return address
0187 726E 045B  20         b     *r11                  ; Return to caller
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
0211 7270 0649  14         dect  stack
0212 7272 C64B  30         mov   r11,*stack            ; Save return address
0213 7274 0649  14         dect  stack
0214 7276 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 7278 0649  14         dect  stack
0216 727A C645  30         mov   tmp1,*stack           ; Push tmp1
0217 727C 0649  14         dect  stack
0218 727E C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 7280 C184  18         mov   tmp0,tmp2             ; Line number
0223 7282 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 7284 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     7286 0800     
0225               
0226 7288 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 728A 0A16  56         sla   tmp2,1                ; line number * 2
0231 728C C806  38         mov   tmp2,@outparm1        ; Offset index entry
     728E A010     
0232               
0233 7290 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     7292 A602     
0234 7294 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     7296 A600     
0235               
0236 7298 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 729A C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     729C A600     
0242 729E C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     72A0 A206     
0243               
0244 72A2 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0245 72A4 0205  20         li    tmp1,>b000            ; Memory window for index page
     72A6 B000     
0246               
0247 72A8 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     72AA 2570     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 72AC 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     72AE A604     
0254 72B0 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 72B2 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     72B4 A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 72B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 72B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 72BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 72BC C2F9  30         mov   *stack+,r11           ; Pop r11
0265 72BE 045B  20         b     *r11                  ; Return to caller
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
0022 72C0 0649  14         dect  stack
0023 72C2 C64B  30         mov   r11,*stack            ; Save return address
0024 72C4 0649  14         dect  stack
0025 72C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72C8 0204  20         li    tmp0,edb.top          ; \
     72CA C000     
0030 72CC C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     72CE A500     
0031 72D0 C804  38         mov   tmp0,@edb.next_free.ptr
     72D2 A508     
0032                                                   ; Set pointer to next free line
0033               
0034 72D4 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     72D6 A50A     
0035               
0036 72D8 0204  20         li    tmp0,1
     72DA 0001     
0037 72DC C804  38         mov   tmp0,@edb.lines       ; Lines=1
     72DE A504     
0038               
0039 72E0 0720  34         seto  @edb.block.m1         ; Reset block start line
     72E2 A50C     
0040 72E4 0720  34         seto  @edb.block.m2         ; Reset block end line
     72E6 A50E     
0041               
0042 72E8 0204  20         li    tmp0,txt.newfile      ; "New file"
     72EA 35B6     
0043 72EC C804  38         mov   tmp0,@edb.filename.ptr
     72EE A512     
0044               
0045 72F0 0204  20         li    tmp0,txt.filetype.none
     72F2 3668     
0046 72F4 C804  38         mov   tmp0,@edb.filetype.ptr
     72F6 A514     
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 72F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 72FA C2F9  30         mov   *stack+,r11           ; Pop r11
0054 72FC 045B  20         b     *r11                  ; Return to caller
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
0022 72FE 0649  14         dect  stack
0023 7300 C64B  30         mov   r11,*stack            ; Save return address
0024 7302 0649  14         dect  stack
0025 7304 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7306 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     7308 E000     
0030 730A C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     730C A700     
0031               
0032 730E 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     7310 A702     
0033 7312 0204  20         li    tmp0,4
     7314 0004     
0034 7316 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     7318 A706     
0035 731A C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     731C A708     
0036               
0037 731E 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     7320 A716     
0038 7322 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     7324 A718     
0039 7326 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     7328 A726     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 732A 06A0  32         bl    @film
     732C 2230     
0044 732E E000             data  cmdb.top,>00,cmdb.size
     7330 0000     
     7332 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7334 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 7336 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 7338 045B  20         b     *r11                  ; Return to caller
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
0022 733A 0649  14         dect  stack
0023 733C C64B  30         mov   r11,*stack            ; Save return address
0024 733E 0649  14         dect  stack
0025 7340 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7342 04E0  34         clr   @tv.error.visible     ; Set to hidden
     7344 A228     
0030               
0031 7346 06A0  32         bl    @film
     7348 2230     
0032 734A A22A                   data tv.error.msg,0,160
     734C 0000     
     734E 00A0     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 7350 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 7352 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 7354 045B  20         b     *r11                  ; Return to caller
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
0022 7356 0649  14         dect  stack
0023 7358 C64B  30         mov   r11,*stack            ; Save return address
0024 735A 0649  14         dect  stack
0025 735C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 735E 0204  20         li    tmp0,1                ; \ Set default color scheme
     7360 0001     
0030 7362 C804  38         mov   tmp0,@tv.colorscheme  ; /
     7364 A212     
0031               
0032 7366 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     7368 A224     
0033 736A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     736C 200C     
0034               
0035 736E 0204  20         li    tmp0,fj.bottom
     7370 B000     
0036 7372 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     7374 A226     
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 7376 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 7378 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 737A 045B  20         b     *r11                  ; Return to caller
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
0065 737C 0649  14         dect  stack
0066 737E C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 7380 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     7382 32BA     
0071 7384 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7386 327C     
0072 7388 06A0  32         bl    @idx.init             ; Initialize index
     738A 317C     
0073 738C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     738E 311A     
0074 7390 06A0  32         bl    @errline.init         ; Initialize error line
     7392 32F6     
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 7394 06A0  32         bl    @hchar
     7396 27C2     
0079 7398 0034                   byte 0,52,32,18           ; Remove markers
     739A 2012     
0080 739C 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     739E 2033     
0081 73A0 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 73A2 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 73A4 045B  20         b     *r11                  ; Return to caller
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
0020 73A6 0649  14         dect  stack
0021 73A8 C64B  30         mov   r11,*stack            ; Save return address
0022 73AA 0649  14         dect  stack
0023 73AC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 73AE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     73B0 2A90     
0028 73B2 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 73B4 A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 73B6 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 73B7   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 73B8 0204  20         li    tmp0,unpacked.string
     73BA A026     
0034 73BC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 73BE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 73C0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 73C2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     73C4 2AE8     
0039 73C6 A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 73C8 A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 73CA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73CE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73D0 045B  20         b     *r11                  ; Return to caller
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
0073 73D2 0649  14         dect  stack
0074 73D4 C64B  30         mov   r11,*stack            ; Push return address
0075 73D6 0649  14         dect  stack
0076 73D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73DA 0649  14         dect  stack
0078 73DC C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73DE 0649  14         dect  stack
0080 73E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73E2 0649  14         dect  stack
0082 73E4 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 73E6 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     73E8 A000     
0087 73EA D194  26         movb  *tmp0,tmp2            ; /
0088 73EC 0986  56         srl   tmp2,8                ; Right align
0089 73EE C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 73F0 8806  38         c     tmp2,@parm2           ; String length > requested length?
     73F2 A002     
0092 73F4 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 73F6 C120  34         mov   @parm1,tmp0           ; Get source address
     73F8 A000     
0097 73FA C160  34         mov   @parm4,tmp1           ; Get destination address
     73FC A006     
0098 73FE 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 7400 0649  14         dect  stack
0101 7402 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 7404 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     7406 24DA     
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 7408 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 740A C120  34         mov   @parm2,tmp0           ; Get requested length
     740C A002     
0113 740E 0A84  56         sla   tmp0,8                ; Left align
0114 7410 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     7412 A006     
0115 7414 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 7416 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 7418 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 741A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     741C A002     
0122 741E 6187  18         s     tmp3,tmp2             ; |
0123 7420 0586  14         inc   tmp2                  ; /
0124               
0125 7422 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     7424 A004     
0126 7426 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 7428 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 742A 0606  14         dec   tmp2                  ; Update loop counter
0133 742C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 742E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     7430 A006     
     7432 A010     
0136 7434 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 7436 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7438 FFCE     
0142 743A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     743C 2026     
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 743E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 7440 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 7442 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 7444 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 7446 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 7448 045B  20         b     *r11                  ; Return to caller
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
0174 744A 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     744C 2796     
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 744E 04E0  34         clr   @bank0.rom            ; Activate bank 0
     7450 6000     
0179 7452 0420  54         blwp  @0                    ; Reset to monitor
     7454 0000     
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
0017 7456 0649  14         dect  stack
0018 7458 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 745A 06A0  32         bl    @sams.layout
     745C 25DC     
0023 745E 345E                   data mem.sams.layout.data
0024               
0025 7460 06A0  32         bl    @sams.layout.copy
     7462 2640     
0026 7464 A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 7466 C820  54         mov   @tv.sams.c000,@edb.sams.page
     7468 A208     
     746A A516     
0029 746C C820  54         mov   @edb.sams.page,@edb.sams.hipage
     746E A516     
     7470 A518     
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 7472 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 7474 045B  20         b     *r11                  ; Return to caller
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
0033 7476 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     7478 003F     
     747A 0243     
     747C 05F4     
     747E 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 7480 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     7482 000C     
     7484 0006     
     7486 0007     
     7488 0020     
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
0067 748A 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     748C 000C     
     748E 0006     
     7490 0007     
     7492 0020     
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
0092 7494 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     7496 0201     
0093 7498 0000             data  >0000,>0301             ; Current line indicator
     749A 0301     
0094 749C 0820             data  >0820,>0401             ; Current line indicator
     749E 0401     
0095               nosprite:
0096 74A0 D000             data  >d000                   ; End-of-Sprites list
0097               
0098               
0099               ***************************************************************
0100               * SAMS page layout table for Stevie (16 words)
0101               *--------------------------------------------------------------
0102               mem.sams.layout.data:
0103 74A2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74A4 0002     
0104 74A6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74A8 0003     
0105 74AA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74AC 000A     
0106 74AE B000             data  >b000,>0020           ; >b000-bfff, SAMS page >20
     74B0 0020     
0107                                                   ;   Index can allocate
0108                                                   ;   pages >20 to >3f.
0109 74B2 C000             data  >c000,>0040           ; >c000-cfff, SAMS page >40
     74B4 0040     
0110                                                   ;   Editor buffer can allocate
0111                                                   ;   pages >40 to >ff.
0112 74B6 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     74B8 000D     
0113 74BA E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     74BC 000E     
0114 74BE F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     74C0 000F     
0115               
0116               
0117               ***************************************************************
0118               * SAMS page layout table for calling external progam (16 words)
0119               *--------------------------------------------------------------
0120               mem.sams.external:
0121 74C2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74C4 0002     
0122 74C6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74C8 0003     
0123 74CA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74CC 000A     
0124 74CE B000             data  >b000,>0030           ; >b000-bfff, SAMS page >30
     74D0 0030     
0125 74D2 C000             data  >c000,>0031           ; >c000-cfff, SAMS page >31
     74D4 0031     
0126 74D6 D000             data  >d000,>0032           ; >d000-dfff, SAMS page >32
     74D8 0032     
0127 74DA E000             data  >e000,>0033           ; >e000-efff, SAMS page >33
     74DC 0033     
0128 74DE F000             data  >f000,>0034           ; >f000-ffff, SAMS page >34
     74E0 0034     
0129               
0130               
0131               ***************************************************************
0132               * SAMS page layout table for TI Basic (16 words)
0133               *--------------------------------------------------------------
0134               mem.sams.tibasic:
0135 74E2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74E4 0002     
0136 74E6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74E8 0003     
0137 74EA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74EC 000A     
0138 74EE B000             data  >b000,>0004           ; >b000-bfff, SAMS page >04
     74F0 0004     
0139 74F2 C000             data  >c000,>0005           ; >c000-cfff, SAMS page >05
     74F4 0005     
0140 74F6 D000             data  >d000,>0006           ; >d000-dfff, SAMS page >06
     74F8 0006     
0141 74FA E000             data  >e000,>0007           ; >e000-efff, SAMS page >07
     74FC 0007     
0142 74FE F000             data  >f000,>0008           ; >f000-ffff, SAMS page >08
     7500 0008     
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
0196 7502 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     7504 F171     
     7506 1B1F     
     7508 71B1     
0197 750A A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     750C F0FF     
     750E 1F1A     
     7510 F1FF     
0198 7512 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     7514 F0FF     
     7516 1F12     
     7518 F1F6     
0199 751A F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     751C 1E11     
     751E 1A17     
     7520 1E11     
0200 7522 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     7524 E1FF     
     7526 1F1E     
     7528 E1FF     
0201 752A 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     752C 1016     
     752E 1B71     
     7530 1711     
0202 7532 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     7534 1011     
     7536 F1F1     
     7538 1F11     
0203 753A 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     753C A1FF     
     753E 1F1F     
     7540 F11F     
0204 7542 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     7544 12FF     
     7546 1B12     
     7548 12FF     
0205 754A F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     754C E1FF     
     754E 1B1F     
     7550 F131     
0206                       even
0207               
0208               tv.tabs.table:
0209 7552 0007             byte  0,7,12,25               ; \   Default tab positions as used
     7554 0C19     
0210 7556 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     7558 3B4F     
0211 755A FF00             byte  >ff,0,0,0               ; |
     755C 0000     
0212 755E 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     7560 0000     
0213 7562 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     7564 0000     
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
0009 7566 01               byte  1
0010 7567   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 7568 05               byte  5
0015 7569   20             text  '  BOT'
     756A 2042     
     756C 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 756E 03               byte  3
0020 756F   4F             text  'OVR'
     7570 5652     
0021                       even
0022               
0023               txt.insert
0024 7572 03               byte  3
0025 7573   49             text  'INS'
     7574 4E53     
0026                       even
0027               
0028               txt.star
0029 7576 01               byte  1
0030 7577   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 7578 0A               byte  10
0035 7579   4C             text  'Loading...'
     757A 6F61     
     757C 6469     
     757E 6E67     
     7580 2E2E     
     7582 2E       
0036                       even
0037               
0038               txt.saving
0039 7584 0A               byte  10
0040 7585   53             text  'Saving....'
     7586 6176     
     7588 696E     
     758A 672E     
     758C 2E2E     
     758E 2E       
0041                       even
0042               
0043               txt.block.del
0044 7590 12               byte  18
0045 7591   44             text  'Deleting block....'
     7592 656C     
     7594 6574     
     7596 696E     
     7598 6720     
     759A 626C     
     759C 6F63     
     759E 6B2E     
     75A0 2E2E     
     75A2 2E       
0046                       even
0047               
0048               txt.block.copy
0049 75A4 11               byte  17
0050 75A5   43             text  'Copying block....'
     75A6 6F70     
     75A8 7969     
     75AA 6E67     
     75AC 2062     
     75AE 6C6F     
     75B0 636B     
     75B2 2E2E     
     75B4 2E2E     
0051                       even
0052               
0053               txt.block.move
0054 75B6 10               byte  16
0055 75B7   4D             text  'Moving block....'
     75B8 6F76     
     75BA 696E     
     75BC 6720     
     75BE 626C     
     75C0 6F63     
     75C2 6B2E     
     75C4 2E2E     
     75C6 2E       
0056                       even
0057               
0058               txt.block.save
0059 75C8 1D               byte  29
0060 75C9   53             text  'Saving block to DV80 file....'
     75CA 6176     
     75CC 696E     
     75CE 6720     
     75D0 626C     
     75D2 6F63     
     75D4 6B20     
     75D6 746F     
     75D8 2044     
     75DA 5638     
     75DC 3020     
     75DE 6669     
     75E0 6C65     
     75E2 2E2E     
     75E4 2E2E     
0061                       even
0062               
0063               txt.fastmode
0064 75E6 08               byte  8
0065 75E7   46             text  'Fastmode'
     75E8 6173     
     75EA 746D     
     75EC 6F64     
     75EE 65       
0066                       even
0067               
0068               txt.kb
0069 75F0 02               byte  2
0070 75F1   6B             text  'kb'
     75F2 62       
0071                       even
0072               
0073               txt.lines
0074 75F4 05               byte  5
0075 75F5   4C             text  'Lines'
     75F6 696E     
     75F8 6573     
0076                       even
0077               
0078               txt.newfile
0079 75FA 0A               byte  10
0080 75FB   5B             text  '[New file]'
     75FC 4E65     
     75FE 7720     
     7600 6669     
     7602 6C65     
     7604 5D       
0081                       even
0082               
0083               txt.filetype.dv80
0084 7606 04               byte  4
0085 7607   44             text  'DV80'
     7608 5638     
     760A 30       
0086                       even
0087               
0088               txt.m1
0089 760C 03               byte  3
0090 760D   4D             text  'M1='
     760E 313D     
0091                       even
0092               
0093               txt.m2
0094 7610 03               byte  3
0095 7611   4D             text  'M2='
     7612 323D     
0096                       even
0097               
0098               txt.keys.default
0099 7614 07               byte  7
0100 7615   46             text  'F9-Menu'
     7616 392D     
     7618 4D65     
     761A 6E75     
0101                       even
0102               
0103               txt.keys.block
0104 761C 2C               byte  44
0105 761D   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Goto-M1'
     761E 392D     
     7620 4261     
     7622 636B     
     7624 2020     
     7626 5E43     
     7628 6F70     
     762A 7920     
     762C 205E     
     762E 4D6F     
     7630 7665     
     7632 2020     
     7634 5E44     
     7636 656C     
     7638 2020     
     763A 5E53     
     763C 6176     
     763E 6520     
     7640 205E     
     7642 476F     
     7644 746F     
     7646 2D4D     
     7648 31       
0106                       even
0107               
0108 764A 2E2E     txt.ruler          text    '.........'
     764C 2E2E     
     764E 2E2E     
     7650 2E2E     
     7652 2E       
0109 7653   12                        byte    18
0110 7654 2E2E                        text    '.........'
     7656 2E2E     
     7658 2E2E     
     765A 2E2E     
     765C 2E       
0111 765D   13                        byte    19
0112 765E 2E2E                        text    '.........'
     7660 2E2E     
     7662 2E2E     
     7664 2E2E     
     7666 2E       
0113 7667   14                        byte    20
0114 7668 2E2E                        text    '.........'
     766A 2E2E     
     766C 2E2E     
     766E 2E2E     
     7670 2E       
0115 7671   15                        byte    21
0116 7672 2E2E                        text    '.........'
     7674 2E2E     
     7676 2E2E     
     7678 2E2E     
     767A 2E       
0117 767B   16                        byte    22
0118 767C 2E2E                        text    '.........'
     767E 2E2E     
     7680 2E2E     
     7682 2E2E     
     7684 2E       
0119 7685   17                        byte    23
0120 7686 2E2E                        text    '.........'
     7688 2E2E     
     768A 2E2E     
     768C 2E2E     
     768E 2E       
0121 768F   18                        byte    24
0122 7690 2E2E                        text    '.........'
     7692 2E2E     
     7694 2E2E     
     7696 2E2E     
     7698 2E       
0123 7699   19                        byte    25
0124                                  even
0125 769A 020E     txt.alpha.down     data >020e,>0f00
     769C 0F00     
0126 769E 0110     txt.vertline       data >0110
0127 76A0 011C     txt.keymarker      byte 1,28
0128               
0129               txt.ws1
0130 76A2 01               byte  1
0131 76A3   20             text  ' '
0132                       even
0133               
0134               txt.ws2
0135 76A4 02               byte  2
0136 76A5   20             text  '  '
     76A6 20       
0137                       even
0138               
0139               txt.ws3
0140 76A8 03               byte  3
0141 76A9   20             text  '   '
     76AA 2020     
0142                       even
0143               
0144               txt.ws4
0145 76AC 04               byte  4
0146 76AD   20             text  '    '
     76AE 2020     
     76B0 20       
0147                       even
0148               
0149               txt.ws5
0150 76B2 05               byte  5
0151 76B3   20             text  '     '
     76B4 2020     
     76B6 2020     
0152                       even
0153               
0154      3668     txt.filetype.none  equ txt.ws4
0155               
0156               
0157               ;--------------------------------------------------------------
0158               ; Strings for error line pane
0159               ;--------------------------------------------------------------
0160               txt.ioerr.load
0161 76B8 20               byte  32
0162 76B9   49             text  'I/O error. Failed loading file: '
     76BA 2F4F     
     76BC 2065     
     76BE 7272     
     76C0 6F72     
     76C2 2E20     
     76C4 4661     
     76C6 696C     
     76C8 6564     
     76CA 206C     
     76CC 6F61     
     76CE 6469     
     76D0 6E67     
     76D2 2066     
     76D4 696C     
     76D6 653A     
     76D8 20       
0163                       even
0164               
0165               txt.ioerr.save
0166 76DA 20               byte  32
0167 76DB   49             text  'I/O error. Failed saving file:  '
     76DC 2F4F     
     76DE 2065     
     76E0 7272     
     76E2 6F72     
     76E4 2E20     
     76E6 4661     
     76E8 696C     
     76EA 6564     
     76EC 2073     
     76EE 6176     
     76F0 696E     
     76F2 6720     
     76F4 6669     
     76F6 6C65     
     76F8 3A20     
     76FA 20       
0168                       even
0169               
0170               txt.memfull.load
0171 76FC 40               byte  64
0172 76FD   49             text  'Index memory full. Could not fully load file into editor buffer.'
     76FE 6E64     
     7700 6578     
     7702 206D     
     7704 656D     
     7706 6F72     
     7708 7920     
     770A 6675     
     770C 6C6C     
     770E 2E20     
     7710 436F     
     7712 756C     
     7714 6420     
     7716 6E6F     
     7718 7420     
     771A 6675     
     771C 6C6C     
     771E 7920     
     7720 6C6F     
     7722 6164     
     7724 2066     
     7726 696C     
     7728 6520     
     772A 696E     
     772C 746F     
     772E 2065     
     7730 6469     
     7732 746F     
     7734 7220     
     7736 6275     
     7738 6666     
     773A 6572     
     773C 2E       
0173                       even
0174               
0175               txt.io.nofile
0176 773E 21               byte  33
0177 773F   49             text  'I/O error. No filename specified.'
     7740 2F4F     
     7742 2065     
     7744 7272     
     7746 6F72     
     7748 2E20     
     774A 4E6F     
     774C 2066     
     774E 696C     
     7750 656E     
     7752 616D     
     7754 6520     
     7756 7370     
     7758 6563     
     775A 6966     
     775C 6965     
     775E 642E     
0178                       even
0179               
0180               txt.block.inside
0181 7760 34               byte  52
0182 7761   45             text  'Error. Copy/Move target must be outside block M1-M2.'
     7762 7272     
     7764 6F72     
     7766 2E20     
     7768 436F     
     776A 7079     
     776C 2F4D     
     776E 6F76     
     7770 6520     
     7772 7461     
     7774 7267     
     7776 6574     
     7778 206D     
     777A 7573     
     777C 7420     
     777E 6265     
     7780 206F     
     7782 7574     
     7784 7369     
     7786 6465     
     7788 2062     
     778A 6C6F     
     778C 636B     
     778E 204D     
     7790 312D     
     7792 4D32     
     7794 2E       
0183                       even
0184               
0185               
0186               ;--------------------------------------------------------------
0187               ; Strings for command buffer
0188               ;--------------------------------------------------------------
0189               txt.cmdb.prompt
0190 7796 01               byte  1
0191 7797   3E             text  '>'
0192                       even
0193               
0194               txt.colorscheme
0195 7798 0D               byte  13
0196 7799   43             text  'Color scheme:'
     779A 6F6C     
     779C 6F72     
     779E 2073     
     77A0 6368     
     77A2 656D     
     77A4 653A     
0197                       even
0198               
                   < ram.resident.asm
                   < stevie_b1.asm.37021
0043                       ;------------------------------------------------------
0044                       ; Activate bank 1 and branch to  >6036
0045                       ;------------------------------------------------------
0046 77A6 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     77A8 6002     
0047               
0051               
0052 77AA 0460  28         b     @kickstart.code2      ; Jump to entry routine
     77AC 6046     
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
     6054 27EA     
0037 6056 06A0  32         bl    @scroff               ; Turn screen off
     6058 2688     
0038               
0039 605A 06A0  32         bl    @f18unl               ; Unlock the F18a
     605C 272C     
0040               
0042               
0043 605E 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6060 232C     
0044 6062 3140                   data >3140            ; F18a VR49 (>31), bit 40
0045               
0047               
0048 6064 06A0  32         bl    @putvr                ; Turn on position based attributes
     6066 232C     
0049 6068 3202                   data >3202            ; F18a VR50 (>32), bit 2
0050               
0051 606A 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     606C 232C     
0052 606E 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0053                       ;------------------------------------------------------
0054                       ; Clear screen (VDP SIT)
0055                       ;------------------------------------------------------
0056 6070 06A0  32         bl    @filv
     6072 2288     
0057 6074 0000                   data >0000,32,vdp.sit.size
     6076 0020     
     6078 0960     
0058                                                   ; Clear screen
0059                       ;------------------------------------------------------
0060                       ; Initialize high memory expansion
0061                       ;------------------------------------------------------
0062 607A 06A0  32         bl    @film
     607C 2230     
0063 607E A000                   data >a000,00,20000   ; Clear a000-eedf
     6080 0000     
     6082 4E20     
0064                       ;------------------------------------------------------
0065                       ; Setup SAMS windows
0066                       ;------------------------------------------------------
0067 6084 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6086 3412     
0068                       ;------------------------------------------------------
0069                       ; Setup cursor, screen, etc.
0070                       ;------------------------------------------------------
0071 6088 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608A 26A8     
0072 608C 06A0  32         bl    @s8x8                 ; Small sprite
     608E 26B8     
0073               
0074 6090 06A0  32         bl    @cpym2m
     6092 24D4     
0075 6094 3450                   data romsat,ramsat,14 ; Load sprite SAT
     6096 A180     
     6098 000E     
0076               
0077 609A C820  54         mov   @romsat+2,@tv.curshape
     609C 3452     
     609E A214     
0078                                                   ; Save cursor shape & color
0079               
0080 60A0 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     60A2 7B4C     
0081               *--------------------------------------------------------------
0082               * Initialize
0083               *--------------------------------------------------------------
0084 60A4 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A6 3312     
0085 60A8 06A0  32         bl    @tv.reset             ; Reset editor
     60AA 3338     
0086                       ;------------------------------------------------------
0087                       ; Load colorscheme amd turn on screen
0088                       ;------------------------------------------------------
0089 60AC 06A0  32         bl    @pane.action.colorscheme.Load
     60AE 7696     
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
     60BA 26C8     
0098 60BC 0000                   data  >0000           ; Cursor YX position = >0000
0099               
0100 60BE 0204  20         li    tmp0,timers
     60C0 A100     
0101 60C2 C804  38         mov   tmp0,@wtitab
     60C4 832C     
0102               
0104               
0105 60C6 06A0  32         bl    @mkslot
     60C8 2F8C     
0106 60CA 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CC 74B6     
0107 60CE 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60D0 7542     
0108 60D2 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D4 75DE     
0109 60D6 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D8 760C     
0110 60DA FFFF                   data eol
0111               
0121               
0122               
0123 60DC 06A0  32         bl    @mkhook
     60DE 2F78     
0124 60E0 7460                   data hook.keyscan     ; Setup user hook
0125               
0126 60E2 0460  28         b     @tmgr                 ; Start timers and kthread
     60E4 2EC4     
                   < stevie_b1.asm.37021
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
     610E 7CDC     
0033 6110 1002  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6112 0206  20         li    tmp2,keymap_actions.cmdb
     6114 7D7A     
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
     6170 65F4     
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
     6184 680C     
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
     6190 74AA     
                   < stevie_b1.asm.37021
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
     61AA 74AA     
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
     61C6 74AA     
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61C8 06A0  32         bl    @fb.cursor.home       ; Move cursor to beginning of line
     61CA 6A92     
0047                       ;-------------------------------------------------------
0048                       ; Exit
0049                       ;-------------------------------------------------------
0050 61CC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61CE 74AA     
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
     61E8 26E0     
0067 61EA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61EC 6994     
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071 61EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61F0 74AA     
                   < stevie_b1.asm.37021
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
     623A 26E0     
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 623C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     623E 6994     
0068 6240 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6242 74AA     
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
     629A 26E0     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 629C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     629E 6994     
0151 62A0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62A2 74AA     
0152               
0153               
                   < stevie_b1.asm.37021
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
     62A6 69BC     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.up.exit:
0013 62A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62AA 74AA     
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Cursor down
0019               *---------------------------------------------------------------
0020               edkey.action.down:
0021 62AC 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     62AE 6A1A     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.down.exit:
0026 62B0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62B2 74AA     
                   < stevie_b1.asm.37021
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
     62C2 6E60     
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
0041 62EA 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 62EC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62EE 74AA     
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
     62FE 6E60     
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
0085 6324 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 6326 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6328 74AA     
                   < stevie_b1.asm.37021
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
     6334 6E60     
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
0022 6342 0460  28         b     @ _edkey.goto.fb.toprow
     6344 6376     
0023                                                   ; \ Position cursor and exit
0024                                                   ; / i  @parm1 = Line in editor buffer
0025               
0026               
0027               
0028               *---------------------------------------------------------------
0029               * Goto bottom of file
0030               *---------------------------------------------------------------
0031               edkey.action.bot:
0032                       ;-------------------------------------------------------
0033                       ; Crunch current row if dirty
0034                       ;-------------------------------------------------------
0035 6346 8820  54         c     @fb.row.dirty,@w$ffff
     6348 A30A     
     634A 2022     
0036 634C 1604  14         jne   edkey.action.bot.refresh
0037 634E 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6350 6E60     
0038 6352 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6354 A30A     
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 6356 8820  54         c     @edb.lines,@fb.scrrows
     6358 A504     
     635A A31A     
0044 635C 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 635E C120  34         mov   @edb.lines,tmp0
     6360 A504     
0047 6362 6120  34         s     @fb.scrrows,tmp0
     6364 A31A     
0048 6366 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6368 A000     
0049 636A 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     636C A310     
0050               
0051 636E 0460  28         b     @ _edkey.goto.fb.toprow
     6370 6376     
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 6372 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6374 74AA     
                   < stevie_b1.asm.37021
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
0013               * b    _edkey.goto.fb.toprow
0014               * jmp  _edkey.goto.fb.toprow
0015               *--------------------------------------------------------------
0016               * INPUT
0017               * @parm1  = Line in editor buffer to display as top row (goto)
0018               *
0019               * Register usage
0020               * none
0021               *--------------------------------------------------------------
0022               *  Remarks
0023               *  Private, only to be called from inside edkey submodules
0024               ********|*****|*********************|**************************
0025               _edkey.goto.fb.toprow:
0026 6376 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6378 A318     
0027               
0028 637A 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     637C 6B84     
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 637E 04E0  34         clr   @fb.row               ; Frame buffer line 0
     6380 A306     
0033 6382 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6384 A30C     
0034 6386 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     6388 832A     
0035               
0036 638A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     638C 6994     
0037               
0038 638E 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6390 7056     
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6392 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6394 74AA     
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 6396 8820  54         c     @fb.row.dirty,@w$ffff
     6398 A30A     
     639A 2022     
0053 639C 1609  14         jne   edkey.action.goto.refresh
0054               
0055 639E 0649  14         dect  stack
0056 63A0 C660  46         mov   @parm1,*stack         ; Push parm1
     63A2 A000     
0057 63A4 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63A6 6E60     
0058 63A8 C839  50         mov   *stack+,@parm1        ; Pop parm1
     63AA A000     
0059               
0060 63AC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63AE A30A     
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 63B0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63B2 A310     
0066               
0067 63B4 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     63B6 6376     
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
                   < stevie_b1.asm.37021
0078                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
     **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 63B8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     63BA A506     
0009 63BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63BE 6994     
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 63C0 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     63C2 A308     
0015 63C4 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 63C6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     63C8 A302     
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 63CA C1C6  18         mov   tmp2,tmp3             ; \
0024 63CC 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 63CE 81E0  34         c     @fb.column,tmp3
     63D0 A30C     
0026 63D2 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 63D4 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 63D6 D505  30         movb  tmp1,*tmp0            ; /
0033 63D8 C820  54         mov   @fb.column,@fb.row.length
     63DA A30C     
     63DC A308     
0034                                                   ; Row length - 1
0035 63DE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     63E0 A30A     
0036 63E2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     63E4 A316     
0037 63E6 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 63E8 0286  22         ci    tmp2,colrow
     63EA 0050     
0043 63EC 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 63EE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     63F0 FFCE     
0049 63F2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     63F4 2026     
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 63F6 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 63F8 61E0  34         s     @fb.column,tmp3
     63FA A30C     
0056 63FC 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 63FE A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 6400 C144  18         mov   tmp0,tmp1
0059 6402 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 6404 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6406 A30C     
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 6408 C120  34         mov   @fb.current,tmp0      ; Get pointer
     640A A302     
0065 640C C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 640E 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 6410 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 6412 0606  14         dec   tmp2
0073 6414 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 6416 0206  20         li    tmp2,colrow
     6418 0050     
0078 641A 81A0  34         c     @fb.row.length,tmp2
     641C A308     
0079 641E 1603  14         jne   edkey.action.del_char.save
0080 6420 0604  14         dec   tmp0                  ; One time adjustment
0081 6422 04C5  14         clr   tmp1
0082 6424 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 6426 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6428 A30A     
0088 642A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     642C A316     
0089 642E 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6430 A308     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 6432 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6434 74AA     
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 6436 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6438 A506     
0102 643A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     643C 6994     
0103 643E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6440 A308     
0104 6442 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 6444 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6446 A302     
0110 6448 C1A0  34         mov   @fb.colsline,tmp2
     644A A30E     
0111 644C 61A0  34         s     @fb.column,tmp2
     644E A30C     
0112 6450 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 6452 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 6454 0606  14         dec   tmp2
0119 6456 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 6458 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     645A A30A     
0124 645C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     645E A316     
0125               
0126 6460 C820  54         mov   @fb.column,@fb.row.length
     6462 A30C     
     6464 A308     
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 6466 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6468 74AA     
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 646A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     646C 6994     
0143 646E 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6470 A30A     
0144               
0145 6472 C820  54         mov   @fb.topline,@parm1    ; \
     6474 A304     
     6476 A000     
0146 6478 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     647A A306     
     647C A000     
0147 647E 05A0  34         inc   @parm1                ; /
     6480 A000     
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6482 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     6484 A000     
     6486 A504     
0153 6488 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 648A C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     648C A304     
     648E A000     
0157 6490 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6492 6B84     
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 6494 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6496 62A4     
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 6498 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     649A 715C     
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 649C 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     649E A000     
     64A0 A504     
0170 64A2 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 64A4 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     64A6 7056     
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 64A8 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     64AA A304     
     64AC A000     
0183               
0184 64AE 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     64B0 6B84     
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 64B2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64B4 A506     
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 64B6 C120  34         mov   @fb.topline,tmp0
     64B8 A304     
0193 64BA A120  34         a     @fb.row,tmp0
     64BC A306     
0194               
0195 64BE 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64C0 A504     
0196 64C2 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 64C4 0460  28         b     @edkey.action.up      ; Move cursor one line up
     64C6 62A4     
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 64C8 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64CA 61C8     
                   < stevie_b1.asm.37021
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
0010 64CC 0204  20         li    tmp0,>2000            ; White space
     64CE 2000     
0011 64D0 C804  38         mov   tmp0,@parm1
     64D2 A000     
0012               edkey.action.ins_char:
0013 64D4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64D6 A506     
0014 64D8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64DA 6994     
0015                       ;-------------------------------------------------------
0016                       ; Check 1 - Empty line
0017                       ;-------------------------------------------------------
0018               edkey.actions.ins.char.empty_line:
0019 64DC C120  34         mov   @fb.current,tmp0      ; Get pointer
     64DE A302     
0020 64E0 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64E2 A308     
0021 64E4 133A  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Check 2 - line-wrap if at character 80
0025                       ;-------------------------------------------------------
0026 64E6 C160  34         mov   @fb.column,tmp1
     64E8 A30C     
0027 64EA 0285  22         ci    tmp1,colrow-1         ; At 80th character?
     64EC 004F     
0028 64EE 1110  14         jlt   !
0029 64F0 C160  34         mov   @fb.row.length,tmp1
     64F2 A308     
0030 64F4 0285  22         ci    tmp1,colrow
     64F6 0050     
0031 64F8 160B  14         jne   !
0032                       ;-------------------------------------------------------
0033                       ; Wrap to new line
0034                       ;-------------------------------------------------------
0035 64FA 0649  14         dect  Stack
0036 64FC C660  46         mov   @parm1,*stack         ; Save character to add
     64FE A000     
0037 6500 06A0  32         bl    @fb.cursor.down       ; Move cursor down 1 line
     6502 6A1A     
0038 6504 06A0  32         bl    @fb.insert.line       ; Insert empty line
     6506 6ABC     
0039 6508 C839  50         mov   *stack+,@parm1        ; Restore character to add
     650A A000     
0040 650C 04C6  14         clr   tmp2                  ; Clear line length
0041 650E 1025  14         jmp   edkey.action.ins_char.append
0042                       ;-------------------------------------------------------
0043                       ; Check 3 - EOL
0044                       ;-------------------------------------------------------
0045 6510 8820  54 !       c     @fb.column,@fb.row.length
     6512 A30C     
     6514 A308     
0046 6516 1321  14         jeq   edkey.action.ins_char.append
0047                                                   ; Add character in append mode
0048                       ;-------------------------------------------------------
0049                       ; Check 4 - Insert only until line length reaches 80th column
0050                       ;-------------------------------------------------------
0051 6518 C160  34         mov   @fb.row.length,tmp1
     651A A308     
0052 651C 0285  22         ci    tmp1,colrow
     651E 0050     
0053 6520 1101  14         jlt   edkey.action.ins_char.prep
0054 6522 101D  14         jmp   edkey.action.ins_char.exit
0055                       ;-------------------------------------------------------
0056                       ; Calculate number of characters to move
0057                       ;-------------------------------------------------------
0058               edkey.action.ins_char.prep:
0059 6524 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0060 6526 61E0  34         s     @fb.column,tmp3
     6528 A30C     
0061 652A 0607  14         dec   tmp3                  ; Remove base 1 offset
0062 652C A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0063 652E C144  18         mov   tmp0,tmp1
0064 6530 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0065 6532 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6534 A30C     
0066                       ;-------------------------------------------------------
0067                       ; Loop from end of line until current character
0068                       ;-------------------------------------------------------
0069               edkey.action.ins_char.loop:
0070 6536 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0071 6538 0604  14         dec   tmp0
0072 653A 0605  14         dec   tmp1
0073 653C 0606  14         dec   tmp2
0074 653E 16FB  14         jne   edkey.action.ins_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Insert specified character at current position
0077                       ;-------------------------------------------------------
0078 6540 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     6542 A000     
0079                       ;-------------------------------------------------------
0080                       ; Save variables and exit
0081                       ;-------------------------------------------------------
0082 6544 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6546 A30A     
0083 6548 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     654A A316     
0084 654C 05A0  34         inc   @fb.column
     654E A30C     
0085 6550 05A0  34         inc   @wyx
     6552 832A     
0086 6554 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6556 A308     
0087 6558 1002  14         jmp   edkey.action.ins_char.exit
0088                       ;-------------------------------------------------------
0089                       ; Add character in append mode
0090                       ;-------------------------------------------------------
0091               edkey.action.ins_char.append:
0092 655A 0460  28         b     @edkey.action.char.overwrite
     655C 661A     
0093                       ;-------------------------------------------------------
0094                       ; Exit
0095                       ;-------------------------------------------------------
0096               edkey.action.ins_char.exit:
0097 655E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6560 74AA     
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
0108 6562 06A0  32         bl    @fb.insert.line       ; Insert new line
     6564 6ABC     
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.ins_line.exit:
0113 6566 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6568 74AA     
                   < stevie_b1.asm.37021
0080                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
     **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 656A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     656C A318     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 656E 8820  54         c     @fb.row.dirty,@w$ffff
     6570 A30A     
     6572 2022     
0013 6574 1606  14         jne   edkey.action.enter.upd_counter
0014 6576 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6578 A506     
0015 657A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     657C 6E60     
0016 657E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6580 A30A     
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6582 C120  34         mov   @fb.topline,tmp0
     6584 A304     
0022 6586 A120  34         a     @fb.row,tmp0
     6588 A306     
0023 658A 0584  14         inc   tmp0
0024 658C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     658E A504     
0025 6590 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6592 05A0  34         inc   @edb.lines            ; Total lines++
     6594 A504     
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6596 C120  34         mov   @fb.scrrows,tmp0
     6598 A31A     
0035 659A 0604  14         dec   tmp0
0036 659C 8120  34         c     @fb.row,tmp0
     659E A306     
0037 65A0 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 65A2 C120  34         mov   @fb.scrrows,tmp0
     65A4 A31A     
0042 65A6 C820  54         mov   @fb.topline,@parm1
     65A8 A304     
     65AA A000     
0043 65AC 05A0  34         inc   @parm1
     65AE A000     
0044 65B0 06A0  32         bl    @fb.refresh
     65B2 6B84     
0045 65B4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     65B6 A310     
0046 65B8 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 65BA 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65BC A306     
0052 65BE 06A0  32         bl    @down                 ; Row++ VDP cursor
     65C0 26CE     
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 65C2 06A0  32         bl    @fb.get.firstnonblank
     65C4 6B3C     
0058 65C6 C120  34         mov   @outparm1,tmp0
     65C8 A010     
0059 65CA C804  38         mov   tmp0,@fb.column
     65CC A30C     
0060 65CE 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65D0 26E0     
0061 65D2 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65D4 7056     
0062 65D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65D8 6994     
0063 65DA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65DC A316     
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 65DE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65E0 74AA     
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 65E2 0649  14         dect  stack
0078 65E4 C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 65E6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65E8 A318     
0081 65EA 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65EC A50A     
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 65EE C2F9  30         mov   *stack+,r11           ; Pop r11
0087 65F0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65F2 74AA     
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 65F4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65F6 A318     
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 65F8 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 65FA 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 65FC 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     65FE 0020     
0103 6600 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 6602 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6604 007E     
0107 6606 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 6608 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     660A A506     
0113 660C D805  38         movb  tmp1,@parm1           ; Store character for insert
     660E A000     
0114 6610 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6612 A50A     
0115 6614 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 6616 0460  28         b     @edkey.action.ins_char
     6618 64D4     
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 661A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     661C 6994     
0126 661E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6620 A302     
0127               
0128 6622 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6624 A000     
0129 6626 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6628 A30A     
0130 662A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     662C A316     
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 662E C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6630 A30C     
0135 6632 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     6634 004F     
0136 6636 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 6638 0205  20         li    tmp1,colrow           ; \
     663A 0050     
0140 663C C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     663E A308     
0141 6640 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 6642 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6644 A30C     
0147 6646 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6648 832A     
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 664A 8820  54         c     @fb.column,@fb.row.length
     664C A30C     
     664E A308     
0152                                                   ; column < line length ?
0153 6650 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 6652 C820  54         mov   @fb.column,@fb.row.length
     6654 A30C     
     6656 A308     
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 6658 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     665A 74AA     
                   < stevie_b1.asm.37021
0081                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 665C C120  34         mov   @edb.dirty,tmp0
     665E A506     
0012 6660 1302  14         jeq   !
0013 6662 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6664 7BCC     
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 6666 0460  28 !       b     @tv.quit
     6668 3406     
0018               
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Toggle ruler on/off
0023               ********|*****|*********************|**************************
0024               edkey.action.toggle.ruler:
0025 666A 0649  14         dect  stack
0026 666C C644  30         mov   tmp0,*stack           ; Push tmp0
0027 666E 0649  14         dect  stack
0028 6670 C660  46         mov   @wyx,*stack           ; Push cursor YX
     6672 832A     
0029                       ;-------------------------------------------------------
0030                       ; Toggle ruler visibility
0031                       ;-------------------------------------------------------
0032 6674 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6676 A316     
0033 6678 0560  34         inv   @tv.ruler.visible     ; Toggle ruler visibility
     667A A210     
0034 667C 1302  14         jeq   edkey.action.toggle.ruler.fb
0035 667E 06A0  32         bl    @fb.ruler.init        ; Setup ruler in ram
     6680 7C82     
0036                       ;-------------------------------------------------------
0037                       ; Update framebuffer pane
0038                       ;-------------------------------------------------------
0039               edkey.action.toggle.ruler.fb:
0040 6682 06A0  32         bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
     6684 7C2A     
0041 6686 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     6688 832A     
0042 668A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.toggle.ruler.exit:
0047 668C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     668E 74AA     
                   < stevie_b1.asm.37021
0082                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 6690 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6692 A444     
     6694 A000     
0018 6696 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6698 A002     
0019 669A 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 669C C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     669E A444     
     66A0 A000     
0023 66A2 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     66A4 A002     
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 66A6 C120  34         mov   @parm1,tmp0
     66A8 A000     
0030 66AA 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 66AC C120  34         mov   @edb.dirty,tmp0
     66AE A506     
0036 66B0 1302  14         jeq   !
0037 66B2 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66B4 7BCC     
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 66B6 06A0  32 !       bl    @fm.browse.fname.suffix
     66B8 7B96     
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 66BA 0204  20         li    tmp0,heap.top         ; 1st line in heap
     66BC F000     
0047 66BE 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     66C0 7B5E     
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 66C2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66C4 632A     
                   < stevie_b1.asm.37021
0083                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
     **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 66C6 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     66C8 71EC     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 66CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66CC 74AA     
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 66CE 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     66D0 7214     
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 66D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D4 74AA     
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 66D6 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     66D8 723C     
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 66DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66DC 74AA     
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 66DE 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     66E0 79CC     
0043 66E2 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     66E4 7282     
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 66E6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66E8 74AA     
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 66EA 0649  14         dect  stack
0055 66EC C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 66EE 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     66F0 A50E     
     66F2 2022     
0060 66F4 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 66F6 C120  34         mov   @wyx,tmp0             ; Get cursor position
     66F8 832A     
0066 66FA 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     66FC FF00     
0067 66FE C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     6700 A314     
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 6702 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     6704 79CC     
0072               
0073 6706 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     6708 A000     
0074 670A 06A0  32         bl    @edb.block.copy       ; Copy code block
     670C 72C8     
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 670E 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     6710 A010     
     6712 2000     
0079 6714 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6716 C820  54         mov   @fb.yxsave,@parm1
     6718 A314     
     671A A000     
0083 671C 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     671E 6BF4     
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 6720 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6722 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6724 74AA     
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
0103 6726 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6728 A50E     
     672A 2022     
0104 672C 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 672E 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6730 79CC     
0110               
0111 6732 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     6734 A000     
0112 6736 06A0  32         bl    @edb.block.delete     ; Delete code block
     6738 73BE     
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 673A 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     673C A010     
     673E 2000     
0119 6740 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 6742 C820  54         mov   @fb.topline,@parm1
     6744 A304     
     6746 A000     
0123 6748 0460  28         b     @_edkey.goto.fb.toprow
     674A 6376     
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 674C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     674E 74AA     
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 6750 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6752 A50E     
     6754 2022     
0142 6756 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 6758 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     675A 79CC     
0148               
0149 675C 0720  34         seto  @parm1                ; Set message to "Moving block..."
     675E A000     
0150 6760 06A0  32         bl    @edb.block.copy       ; Copy code block
     6762 72C8     
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6764 0720  34         seto  @parm1                ; Don't display delete message
     6766 A000     
0155 6768 06A0  32         bl    @edb.block.delete     ; Delete code block
     676A 73BE     
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 676C 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     676E A010     
     6770 2000     
0162 6772 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6774 C820  54         mov   @fb.topline,@parm1
     6776 A304     
     6778 A000     
0166 677A 0460  28         b     @_edkey.goto.fb.toprow
     677C 6376     
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 677E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6780 74AA     
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 6782 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6784 A50C     
     6786 2022     
0182 6788 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 678A C820  54         mov   @edb.block.m1,@parm1
     678C A50C     
     678E A000     
0188 6790 0620  34         dec   @parm1                ; Base 0 offset
     6792 A000     
0189               
0190 6794 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6796 6396     
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 6798 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     679A 74AA     
                   < stevie_b1.asm.37021
0084                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
     **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 679C 0649  14         dect  stack
0009 679E C64B  30         mov   r11,*stack            ; Save return address
0010 67A0 06A0  32         bl    @fb.tab.next          ; Jump to next tab position on line
     67A2 7C70     
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 67A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 67A6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67A8 74AA     
                   < stevie_b1.asm.37021
0085                       ;-----------------------------------------------------------------------
0086                       ; Keyboard actions - Command Buffer
0087                       ;-----------------------------------------------------------------------
0088                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
     **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 67AA C120  34         mov   @cmdb.column,tmp0
     67AC A712     
0009 67AE 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 67B0 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     67B2 A712     
0014 67B4 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     67B6 A70A     
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 67B8 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     67BA 74AA     
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 67BC 06A0  32         bl    @cmdb.cmd.getlength
     67BE 7C52     
0026 67C0 8820  54         c     @cmdb.column,@outparm1
     67C2 A712     
     67C4 A010     
0027 67C6 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 67C8 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     67CA A712     
0032 67CC 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     67CE A70A     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 67D0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     67D2 74AA     
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 67D4 04C4  14         clr   tmp0
0045 67D6 C804  38         mov   tmp0,@cmdb.column      ; First column
     67D8 A712     
0046 67DA 0584  14         inc   tmp0
0047 67DC D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     67DE A70A     
0048 67E0 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     67E2 A70A     
0049               
0050 67E4 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     67E6 74AA     
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 67E8 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     67EA A728     
0057 67EC 0984  56         srl   tmp0,8                 ; Right justify
0058 67EE C804  38         mov   tmp0,@cmdb.column      ; Save column position
     67F0 A712     
0059 67F2 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 67F4 0224  22         ai    tmp0,>1a00             ; Y=26
     67F6 1A00     
0061 67F8 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     67FA A70A     
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 67FC 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     67FE 74AA     
                   < stevie_b1.asm.37021
0089                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 6800 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6802 7C48     
0026 6804 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6806 A718     
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 6808 0460  28         b     @edkey.action.cmdb.home
     680A 67D4     
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
0060 680C D105  18         movb  tmp1,tmp0             ; Get keycode
0061 680E 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6810 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6812 0020     
0064 6814 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6816 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6818 007E     
0068 681A 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 681C 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     681E A718     
0074               
0075 6820 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6822 A729     
0076 6824 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6826 A712     
0077 6828 D505  30         movb  tmp1,*tmp0            ; Add character
0078 682A 05A0  34         inc   @cmdb.column          ; Next column
     682C A712     
0079 682E 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6830 A70A     
0080               
0081 6832 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6834 7C52     
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 6836 C120  34         mov   @outparm1,tmp0
     6838 A010     
0088 683A 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 683C D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     683E A728     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 6840 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6842 74AA     
                   < stevie_b1.asm.37021
0090                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
     **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6844 C120  34         mov   @cmdb.visible,tmp0
     6846 A702     
0009 6848 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 684A 04E0  34         clr   @cmdb.column          ; Column = 0
     684C A712     
0015 684E 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6850 7C20     
0016 6852 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6854 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6856 7C2A     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6858 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     685A 74AA     
                   < stevie_b1.asm.37021
0091                       copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
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
0011 685C 0649  14         dect  stack
0012 685E C64B  30         mov   r11,*stack            ; Save return address
0013 6860 0649  14         dect  stack
0014 6862 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 6864 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6866 A506     
0019 6868 1303  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 686A 06A0  32         bl    @dialog.unsaved       ; Show dialog
     686C 7BCC     
0022 686E 1004  14         jmp   edkey.action.cmdb.file.new.exit
0023                       ;-------------------------------------------------------
0024                       ; Reset editor
0025                       ;-------------------------------------------------------
0026 6870 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     6872 7C2A     
0027 6874 06A0  32         bl    @tv.reset             ; Reset editor
     6876 3338     
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.file.new.exit:
0032 6878 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0033 687A C2F9  30         mov   *stack+,r11           ; Pop R11
0034 687C 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     687E 632A     
                   < stevie_b1.asm.37021
0092                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
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
0011 6880 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6882 7C2A     
0012               
0013 6884 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6886 7C52     
0014 6888 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     688A A010     
0015 688C 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 688E 06A0  32         bl    @pane.errline.show    ; Show error line
     6890 7964     
0020               
0021 6892 06A0  32         bl    @pane.show_hint
     6894 7C16     
0022 6896 1C00                   byte pane.botrow-1,0
0023 6898 36FA                   data txt.io.nofile
0024               
0025 689A 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 689C 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 689E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68A0 A728     
0031               
0032 68A2 06A0  32         bl    @cpym2m
     68A4 24D4     
0033 68A6 A728                   data cmdb.cmdlen,heap.top,80
     68A8 F000     
     68AA 0050     
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68AC 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68AE F000     
0039 68B0 C804  38         mov   tmp0,@parm1
     68B2 A000     
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 68B4 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68B6 F000     
0045 68B8 C804  38         mov   tmp0,@parm1
     68BA A000     
0046               
0047 68BC 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     68BE 7B5E     
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 68C0 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     68C2 632A     
                   < stevie_b1.asm.37021
0093                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
     **** ****     > edkey.cmdb.file.save.asm
0001               * FILE......: edkey.cmdb.fíle.save.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.save:
0008                       ;-------------------------------------------------------
0009                       ; Save file
0010                       ;-------------------------------------------------------
0011 68C4 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     68C6 7C2A     
0012               
0013 68C8 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68CA 7C52     
0014 68CC C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     68CE A010     
0015 68D0 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 68D2 06A0  32         bl    @pane.errline.show    ; Show error line
     68D4 7964     
0020               
0021 68D6 06A0  32         bl    @pane.show_hint
     68D8 7C16     
0022 68DA 1C00                   byte pane.botrow-1,0
0023 68DC 36FA                   data txt.io.nofile
0024               
0025 68DE 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 68E0 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 68E2 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68E4 A728     
0031               
0032 68E6 06A0  32         bl    @cpym2m
     68E8 24D4     
0033 68EA A728                   data cmdb.cmdlen,heap.top,80
     68EC F000     
     68EE 0050     
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68F0 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68F2 F000     
0039 68F4 C804  38         mov   tmp0,@parm1
     68F6 A000     
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 68F8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     68FA A50E     
     68FC 2022     
0044 68FE 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 6900 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6902 A50C     
     6904 A002     
0050 6906 0620  34         dec   @parm2                ; /
     6908 A002     
0051               
0052 690A C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     690C A50E     
     690E A004     
0053               
0054 6910 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 6912 04E0  34         clr   @parm2                ; First line to save
     6914 A002     
0060 6916 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6918 A504     
     691A A004     
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 691C 06A0  32         bl    @fm.savefile          ; Save DV80 file
     691E 7B84     
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 6920 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6922 632A     
                   < stevie_b1.asm.37021
0094                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0020 6924 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6926 A506     
0021 6928 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     692A 785E     
0022 692C 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     692E 7C48     
0023 6930 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6932 A726     
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6934 0284  22         ci    tmp0,>2000
     6936 2000     
0028 6938 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 693A 0284  22         ci    tmp0,>7fff
     693C 7FFF     
0031 693E 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6940 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6942 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6944 FFCE     
0040 6946 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6948 2026     
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 694A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     694C 74AA     
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
0063 694E 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6950 7C66     
0064 6952 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6954 A718     
0065 6956 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6958 74AA     
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
0086 695A 06A0  32         bl    @hchar
     695C 27C2     
0087 695E 0000                   byte 0,0,32,80*2
     6960 20A0     
0088 6962 FFFF                   data EOL
0089 6964 1000  14         jmp   edkey.action.cmdb.close.dialog
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
0108 6966 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6968 A71A     
0109 696A 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     696C 785E     
0110 696E 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6970 7C2A     
0111 6972 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6974 A318     
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6976 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6978 74AA     
                   < stevie_b1.asm.37021
0095                       ;-----------------------------------------------------------------------
0096                       ; Logic for Framebuffer (1)
0097                       ;-----------------------------------------------------------------------
0098                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 697A 0649  14         dect  stack
0025 697C C64B  30         mov   r11,*stack            ; Save return address
0026 697E 0649  14         dect  stack
0027 6980 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6982 C120  34         mov   @parm1,tmp0
     6984 A000     
0032 6986 A120  34         a     @fb.topline,tmp0
     6988 A304     
0033 698A C804  38         mov   tmp0,@outparm1
     698C A010     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 698E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6990 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6992 045B  20         b     *r11                  ; Return to caller
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
0068 6994 0649  14         dect  stack
0069 6996 C64B  30         mov   r11,*stack            ; Save return address
0070 6998 0649  14         dect  stack
0071 699A C644  30         mov   tmp0,*stack           ; Push tmp0
0072 699C 0649  14         dect  stack
0073 699E C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 69A0 C120  34         mov   @fb.row,tmp0
     69A2 A306     
0078 69A4 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     69A6 A30E     
0079 69A8 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     69AA A30C     
0080 69AC A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     69AE A300     
0081 69B0 C805  38         mov   tmp1,@fb.current
     69B2 A302     
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 69B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 69B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 69B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 69BA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0099                       copy  "fb.cursor.up.asm"    ; Cursor up
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
0021 69BC 0649  14         dect  stack
0022 69BE C64B  30         mov   r11,*stack            ; Save return address
0023                       ;-------------------------------------------------------
0024                       ; Crunch current line if dirty
0025                       ;-------------------------------------------------------
0026 69C0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     69C2 A318     
0027 69C4 8820  54         c     @fb.row.dirty,@w$ffff
     69C6 A30A     
     69C8 2022     
0028 69CA 1604  14         jne   fb.cursor.up.cursor
0029 69CC 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     69CE 6E60     
0030 69D0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     69D2 A30A     
0031                       ;-------------------------------------------------------
0032                       ; Move cursor
0033                       ;-------------------------------------------------------
0034               fb.cursor.up.cursor:
0035 69D4 C120  34         mov   @fb.row,tmp0
     69D6 A306     
0036 69D8 150B  14         jgt   fb.cursor.up.cursor_up
0037                                                   ; Move cursor up if fb.row > 0
0038 69DA C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     69DC A304     
0039 69DE 130C  14         jeq   fb.cursor.up.set_cursorx
0040                                                   ; At top, only position cursor X
0041                       ;-------------------------------------------------------
0042                       ; Scroll 1 line
0043                       ;-------------------------------------------------------
0044 69E0 0604  14         dec   tmp0                  ; fb.topline--
0045 69E2 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     69E4 A000     
0046               
0047 69E6 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     69E8 6B84     
0048                                                   ; | i  @parm1 = Line to start with
0049                                                   ; /             (becomes @fb.topline)
0050               
0051 69EA 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     69EC A310     
0052 69EE 1004  14         jmp   fb.cursor.up.set_cursorx
0053                       ;-------------------------------------------------------
0054                       ; Move cursor up
0055                       ;-------------------------------------------------------
0056               fb.cursor.up.cursor_up:
0057 69F0 0620  34         dec   @fb.row               ; Row-- in screen buffer
     69F2 A306     
0058 69F4 06A0  32         bl    @up                   ; Row-- VDP cursor
     69F6 26D6     
0059                       ;-------------------------------------------------------
0060                       ; Check line length and position cursor
0061                       ;-------------------------------------------------------
0062               fb.cursor.up.set_cursorx:
0063 69F8 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     69FA 7056     
0064                                                   ; | i  @fb.row        = Row in frame buffer
0065                                                   ; / o  @fb.row.length = Length of row
0066               
0067 69FC 8820  54         c     @fb.column,@fb.row.length
     69FE A30C     
     6A00 A308     
0068 6A02 1207  14         jle   fb.cursor.up.exit
0069                       ;-------------------------------------------------------
0070                       ; Adjust cursor column position
0071                       ;-------------------------------------------------------
0072 6A04 C820  54         mov   @fb.row.length,@fb.column
     6A06 A308     
     6A08 A30C     
0073 6A0A C120  34         mov   @fb.column,tmp0
     6A0C A30C     
0074 6A0E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6A10 26E0     
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               fb.cursor.up.exit:
0079 6A12 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6A14 6994     
0080 6A16 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6A18 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0100                       copy  "fb.cursor.down.asm"  ; Cursor down
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
0021 6A1A 0649  14         dect  stack
0022 6A1C C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6A1E 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6A20 A306     
     6A22 A504     
0027 6A24 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6A26 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A28 A318     
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6A2A 8820  54         c     @fb.row.dirty,@w$ffff
     6A2C A30A     
     6A2E 2022     
0034 6A30 1604  14         jne   fb.cursor.down.move
0035 6A32 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6A34 6E60     
0036 6A36 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6A38 A30A     
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6A3A C120  34         mov   @fb.topline,tmp0
     6A3C A304     
0045 6A3E A120  34         a     @fb.row,tmp0
     6A40 A306     
0046 6A42 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6A44 A504     
0047 6A46 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6A48 C120  34         mov   @fb.scrrows,tmp0
     6A4A A31A     
0053 6A4C 0604  14         dec   tmp0
0054 6A4E 8120  34         c     @fb.row,tmp0
     6A50 A306     
0055 6A52 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6A54 C820  54         mov   @fb.topline,@parm1
     6A56 A304     
     6A58 A000     
0060 6A5A 05A0  34         inc   @parm1
     6A5C A000     
0061               
0062 6A5E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6A60 6B84     
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6A62 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6A64 A310     
0067 6A66 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6A68 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6A6A A306     
0073 6A6C 06A0  32         bl    @down                 ; Row++ VDP cursor
     6A6E 26CE     
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6A70 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6A72 7056     
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6A74 8820  54         c     @fb.column,@fb.row.length
     6A76 A30C     
     6A78 A308     
0083 6A7A 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6A7C C820  54         mov   @fb.row.length,@fb.column
     6A7E A308     
     6A80 A30C     
0089 6A82 C120  34         mov   @fb.column,tmp0
     6A84 A30C     
0090 6A86 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6A88 26E0     
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6A8A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6A8C 6994     
0096 6A8E C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6A90 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0101                       copy  "fb.cursor.home.asm"  ; Cursor home
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
0021 6A92 0649  14         dect  stack
0022 6A94 C64B  30         mov   r11,*stack            ; Save return address
0023 6A96 0649  14         dect  stack
0024 6A98 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;------------------------------------------------------
0026                       ; Cursor home
0027                       ;------------------------------------------------------
0028 6A9A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A9C A318     
0029 6A9E C120  34         mov   @wyx,tmp0
     6AA0 832A     
0030 6AA2 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6AA4 FF00     
0031 6AA6 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6AA8 832A     
0032 6AAA 04E0  34         clr   @fb.column
     6AAC A30C     
0033 6AAE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AB0 6994     
0034 6AB2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6AB4 A318     
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               fb.cursor.home.exit:
0039 6AB6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6AB8 C2F9  30         mov   *stack+,r11           ; Pop r11
0041 6ABA 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0102                       copy  "fb.insert.line.asm"  ; Insert new line
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
0020 6ABC 0649  14         dect  stack
0021 6ABE C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Initialisation
0024                       ;-------------------------------------------------------
0025 6AC0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6AC2 A506     
0026                       ;-------------------------------------------------------
0027                       ; Crunch current line if dirty
0028                       ;-------------------------------------------------------
0029 6AC4 8820  54         c     @fb.row.dirty,@w$ffff
     6AC6 A30A     
     6AC8 2022     
0030 6ACA 1604  14         jne   fb.insert.line.insert
0031 6ACC 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6ACE 6E60     
0032 6AD0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6AD2 A30A     
0033                       ;-------------------------------------------------------
0034                       ; Insert entry in index
0035                       ;-------------------------------------------------------
0036               fb.insert.line.insert:
0037 6AD4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AD6 6994     
0038 6AD8 C820  54         mov   @fb.topline,@parm1
     6ADA A304     
     6ADC A000     
0039 6ADE A820  54         a     @fb.row,@parm1        ; Line number to insert
     6AE0 A306     
     6AE2 A000     
0040 6AE4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6AE6 A504     
     6AE8 A002     
0041               
0042 6AEA 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6AEC 6D78     
0043                                                   ; \ i  parm1 = Line for insert
0044                                                   ; / i  parm2 = Last line to reorg
0045               
0046 6AEE 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6AF0 A504     
0047 6AF2 04E0  34         clr   @fb.row.length        ; Current row length = 0
     6AF4 A308     
0048                       ;-------------------------------------------------------
0049                       ; Check/Adjust marker M1
0050                       ;-------------------------------------------------------
0051               fb.insert.line.m1:
0052 6AF6 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6AF8 A50C     
     6AFA 2022     
0053 6AFC 1308  14         jeq   fb.insert.line.m2
0054                                                   ; Yes, skip to M2 check
0055               
0056 6AFE 8820  54         c     @parm1,@edb.block.m1
     6B00 A000     
     6B02 A50C     
0057 6B04 1504  14         jgt   fb.insert.line.m2
0058 6B06 05A0  34         inc   @edb.block.m1         ; M1++
     6B08 A50C     
0059 6B0A 0720  34         seto  @fb.colorize          ; Set colorize flag
     6B0C A310     
0060                       ;-------------------------------------------------------
0061                       ; Check/Adjust marker M2
0062                       ;-------------------------------------------------------
0063               fb.insert.line.m2:
0064 6B0E 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6B10 A50E     
     6B12 2022     
0065 6B14 1308  14         jeq   fb.insert.line.refresh
0066                                                   ; Yes, skip to refresh frame buffer
0067               
0068 6B16 8820  54         c     @parm1,@edb.block.m2
     6B18 A000     
     6B1A A50E     
0069 6B1C 1504  14         jgt   fb.insert.line.refresh
0070 6B1E 05A0  34         inc   @edb.block.m2         ; M2++
     6B20 A50E     
0071 6B22 0720  34         seto  @fb.colorize          ; Set colorize flag
     6B24 A310     
0072                       ;-------------------------------------------------------
0073                       ; Refresh frame buffer and physical screen
0074                       ;-------------------------------------------------------
0075               fb.insert.line.refresh:
0076 6B26 C820  54         mov   @fb.topline,@parm1
     6B28 A304     
     6B2A A000     
0077               
0078 6B2C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6B2E 6B84     
0079                                                   ; | i  @parm1 = Line to start with
0080                                                   ; /             (becomes @fb.topline)
0081               
0082 6B30 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6B32 A316     
0083 6B34 06A0  32         bl    @fb.cursor.home       ; Move cursor home
     6B36 6A92     
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               fb.insert.line.exit:
0088 6B38 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6B3A 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0103                       copy  "fb.get.firstnonblank.asm"
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
0015 6B3C 0649  14         dect  stack
0016 6B3E C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6B40 04E0  34         clr   @fb.column
     6B42 A30C     
0021 6B44 06A0  32         bl    @fb.calc_pointer
     6B46 6994     
0022 6B48 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6B4A 7056     
0023 6B4C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6B4E A308     
0024 6B50 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6B52 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6B54 A302     
0027 6B56 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6B58 D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6B5A 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6B5C 0285  22         ci    tmp1,>2000            ; Whitespace?
     6B5E 2000     
0036 6B60 1503  14         jgt   fb.get.firstnonblank.match
0037 6B62 0606  14         dec   tmp2                  ; Counter--
0038 6B64 16F9  14         jne   fb.get.firstnonblank.loop
0039 6B66 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6B68 6120  34         s     @fb.current,tmp0      ; Calculate column
     6B6A A302     
0045 6B6C 0604  14         dec   tmp0
0046 6B6E C804  38         mov   tmp0,@outparm1        ; Save column
     6B70 A010     
0047 6B72 D805  38         movb  tmp1,@outparm2        ; Save character
     6B74 A012     
0048 6B76 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6B78 04E0  34         clr   @outparm1             ; X=0
     6B7A A010     
0054 6B7C 04E0  34         clr   @outparm2             ; Null
     6B7E A012     
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6B80 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6B82 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0104                                                   ; Get column of first non-blank character
0105                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6B84 0649  14         dect  stack
0021 6B86 C64B  30         mov   r11,*stack            ; Push return address
0022 6B88 0649  14         dect  stack
0023 6B8A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B8C 0649  14         dect  stack
0025 6B8E C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6B90 0649  14         dect  stack
0027 6B92 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6B94 C820  54         mov   @parm1,@fb.topline
     6B96 A000     
     6B98 A304     
0032 6B9A 04E0  34         clr   @parm2                ; Target row in frame buffer
     6B9C A002     
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6B9E 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6BA0 A000     
     6BA2 A504     
0037 6BA4 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6BA6 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6BA8 6F58     
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6BAA 05A0  34         inc   @parm1                ; Next line in editor buffer
     6BAC A000     
0048 6BAE 05A0  34         inc   @parm2                ; Next row in frame buffer
     6BB0 A002     
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6BB2 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6BB4 A000     
     6BB6 A504     
0053 6BB8 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6BBA 8820  54         c     @parm2,@fb.scrrows
     6BBC A002     
     6BBE A31A     
0056 6BC0 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6BC2 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6BC4 C120  34         mov   @parm2,tmp0           ; Current row
     6BC6 A002     
0064 6BC8 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6BCA A31A     
0065 6BCC 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6BCE 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6BD0 A30E     
0067               
0068 6BD2 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6BD4 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6BD6 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6BD8 A30E     
0072 6BDA A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6BDC A300     
0073               
0074 6BDE C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6BE0 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6BE2 06A0  32         bl    @xfilm                ; \ Fill memory
     6BE4 2236     
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6BE6 0720  34         seto  @fb.dirty             ; Refresh screen
     6BE8 A316     
0086 6BEA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6BEC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6BEE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6BF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6BF2 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0106                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6BF4 0649  14         dect  stack
0022 6BF6 C64B  30         mov   r11,*stack            ; Save return address
0023 6BF8 0649  14         dect  stack
0024 6BFA C660  46         mov   @parm1,*stack         ; Push @parm1
     6BFC A000     
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6BFE C820  54         mov   @fb.topline,@parm1
     6C00 A304     
     6C02 A000     
0029 6C04 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6C06 6B84     
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6C08 0720  34         seto  @parm1                ; Skip Asserts
     6C0A A000     
0035 6C0C 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6C0E 7C94     
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6C10 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6C12 A218     
     6C14 A000     
0042 6C16 06A0  32         bl    @pane.action.colorscheme.statlines
     6C18 7826     
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6C1A 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6C1C A318     
0050               
0051 6C1E 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6C20 785E     
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6C22 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6C24 A000     
0057 6C26 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6C28 A000     
     6C2A 832A     
0058 6C2C C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6C2E 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0107                       ;-----------------------------------------------------------------------
0108                       ; Logic for Index management
0109                       ;-----------------------------------------------------------------------
0110                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6C30 0649  14         dect  stack
0023 6C32 C64B  30         mov   r11,*stack            ; Save return address
0024 6C34 0649  14         dect  stack
0025 6C36 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6C38 0649  14         dect  stack
0027 6C3A C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6C3C C120  34         mov   @parm1,tmp0           ; Get line number
     6C3E A000     
0032 6C40 C160  34         mov   @parm2,tmp1           ; Get pointer
     6C42 A002     
0033 6C44 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6C46 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6C48 0FFF     
0039 6C4A 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6C4C 06E0  34         swpb  @parm3
     6C4E A004     
0044 6C50 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6C52 A004     
0045 6C54 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6C56 A004     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6C58 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C5A 322C     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6C5C C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6C5E A010     
0056 6C60 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6C62 B000     
0057 6C64 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C66 A010     
0058 6C68 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6C6A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C6C 322C     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6C6E C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C70 A010     
0068 6C72 04E4  34         clr   @idx.top(tmp0)        ; /
     6C74 B000     
0069 6C76 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C78 A010     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C7A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C7C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C7E C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C80 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0111                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6C82 0649  14         dect  stack
0022 6C84 C64B  30         mov   r11,*stack            ; Save return address
0023 6C86 0649  14         dect  stack
0024 6C88 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C8A 0649  14         dect  stack
0026 6C8C C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C8E 0649  14         dect  stack
0028 6C90 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C92 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C94 A000     
0033               
0034 6C96 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C98 322C     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C9A C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C9C A010     
0039 6C9E C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6CA0 B000     
0040               
0041 6CA2 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6CA4 C185  18         mov   tmp1,tmp2             ; \
0047 6CA6 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6CA8 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6CAA 00FF     
0052 6CAC 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6CAE 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6CB0 C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6CB2 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6CB4 A010     
0059 6CB6 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6CB8 A012     
0060 6CBA 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6CBC 04E0  34         clr   @outparm1
     6CBE A010     
0066 6CC0 04E0  34         clr   @outparm2
     6CC2 A012     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6CC4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6CC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6CC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6CCA C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6CCC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0112                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6CCE 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6CD0 B000     
0018 6CD2 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6CD4 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6CD6 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6CD8 0606  14         dec   tmp2                  ; tmp2--
0026 6CDA 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6CDC 045B  20         b     *r11                  ; Return to caller
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
0046 6CDE 0649  14         dect  stack
0047 6CE0 C64B  30         mov   r11,*stack            ; Save return address
0048 6CE2 0649  14         dect  stack
0049 6CE4 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6CE6 0649  14         dect  stack
0051 6CE8 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6CEA 0649  14         dect  stack
0053 6CEC C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6CEE 0649  14         dect  stack
0055 6CF0 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6CF2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6CF4 A000     
0060               
0061 6CF6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6CF8 322C     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6CFA C120  34         mov   @outparm1,tmp0        ; Index offset
     6CFC A010     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6CFE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D00 A002     
0070 6D02 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6D04 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D06 A000     
0074 6D08 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6D0A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6D0C B000     
0081 6D0E 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6D10 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6D12 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6D14 A002     
0088 6D16 0287  22         ci    tmp3,2048
     6D18 0800     
0089 6D1A 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6D1C 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D1E 31BE     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6D20 C120  34         mov   @parm1,tmp0           ; Restore line number
     6D22 A000     
0103 6D24 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6D26 06A0  32         bl    @_idx.entry.delete.reorg
     6D28 6CCE     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6D2A 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D2C 31F2     
0111                                                   ; Restore memory window layout
0112               
0113 6D2E 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6D30 06A0  32         bl    @_idx.entry.delete.reorg
     6D32 6CCE     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6D34 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6D36 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6D38 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6D3A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6D3C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6D3E C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6D40 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0113                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 6D42 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6D44 2800     
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6D46 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6D48 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D4A FFCE     
0026 6D4C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D4E 2026     
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6D50 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6D52 B000     
0031 6D54 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6D56 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6D58 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6D5A C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6D5C 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6D5E 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6D60 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6D62 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6D64 AFFE     
0042 6D66 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6D68 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6D6A 0644  14         dect  tmp0                  ; Move pointer up
0050 6D6C 0645  14         dect  tmp1                  ; Move pointer up
0051 6D6E 0606  14         dec   tmp2                  ; Next index entry
0052 6D70 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D72 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D74 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D76 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               
0064               
0065               ***************************************************************
0066               * idx.entry.insert
0067               * Insert index entry
0068               ***************************************************************
0069               * bl @idx.entry.insert
0070               *--------------------------------------------------------------
0071               * INPUT
0072               * @parm1    = Line number in editor buffer to insert
0073               * @parm2    = Line number of last line to check for reorg
0074               *--------------------------------------------------------------
0075               * OUTPUT
0076               * NONE
0077               *--------------------------------------------------------------
0078               * Register usage
0079               * tmp0,tmp2
0080               ********|*****|*********************|**************************
0081               idx.entry.insert:
0082 6D78 0649  14         dect  stack
0083 6D7A C64B  30         mov   r11,*stack            ; Save return address
0084 6D7C 0649  14         dect  stack
0085 6D7E C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D80 0649  14         dect  stack
0087 6D82 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D84 0649  14         dect  stack
0089 6D86 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D88 0649  14         dect  stack
0091 6D8A C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D8C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D8E A002     
0096 6D90 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D92 A000     
0097 6D94 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D96 C1E0  34         mov   @parm2,tmp3
     6D98 A002     
0104 6D9A 0287  22         ci    tmp3,2048
     6D9C 0800     
0105 6D9E 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6DA0 06A0  32         bl    @_idx.sams.mapcolumn.on
     6DA2 31BE     
0113                                                   ; Index in continuous memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6DA4 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DA6 A002     
0117 6DA8 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6DAA 06A0  32         bl    @_idx.entry.insert.reorg
     6DAC 6D42     
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6DAE 06A0  32         bl    @_idx.sams.mapcolumn.off
     6DB0 31F2     
0125                                                   ; Restore memory window layout
0126               
0127 6DB2 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6DB4 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DB6 A002     
0133               
0134 6DB8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6DBA 322C     
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6DBC C120  34         mov   @outparm1,tmp0        ; Index offset
     6DBE A010     
0139               
0140 6DC0 06A0  32         bl    @_idx.entry.insert.reorg
     6DC2 6D42     
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6DC4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6DC6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6DC8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6DCA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6DCC C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6DCE 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0114                       ;-----------------------------------------------------------------------
0115                       ; Logic for Editor Buffer
0116                       ;-----------------------------------------------------------------------
0117                       copy  "edb.utils.asm"          ; Editor buffer utilities
     **** ****     > edb.utils.asm
0001               * FILE......: edb.utils.asm
0002               * Purpose...: Editor buffer utilities
0003               
0004               
0005               ***************************************************************
0006               * edb.adjust.hipage
0007               * Check and increase highest SAMS page of editor buffer
0008               ***************************************************************
0009               *  bl   @edb.adjust.hipage
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @edb.next_free.ptr = Pointer to next free line
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               ********|*****|*********************|**************************
0019               edb.adjust.hipage:
0020 6DD0 0649  14         dect  stack
0021 6DD2 C64B  30         mov   r11,*stack            ; Save return address
0022 6DD4 0649  14         dect  stack
0023 6DD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6DD8 0649  14         dect  stack
0025 6DDA C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6DDC C120  34         mov   @edb.next_free.ptr,tmp0
     6DDE A508     
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6DE0 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6DE2 0FFF     
0035 6DE4 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6DE6 0052     
0036 6DE8 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6DEA 0FF0     
0037 6DEC 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6DEE 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6DF0 A518     
0043 6DF2 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6DF4 A500     
     6DF6 A508     
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6DF8 C120  34         mov   @edb.sams.hipage,tmp0
     6DFA A518     
0050 6DFC C160  34         mov   @edb.top.ptr,tmp1
     6DFE A500     
0051 6E00 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6E02 2570     
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6E04 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6E06 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E08 FFCE     
0061 6E0A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E0C 2026     
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6E0E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6E10 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6E12 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6E14 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0118                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6E16 0649  14         dect  stack
0022 6E18 C64B  30         mov   r11,*stack            ; Push return address
0023 6E1A 0649  14         dect  stack
0024 6E1C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6E1E 0649  14         dect  stack
0026 6E20 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6E22 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6E24 A504     
0031 6E26 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6E28 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E2A FFCE     
0037 6E2C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E2E 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6E30 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6E32 A000     
0043               
0044 6E34 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6E36 6C82     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6E38 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6E3A A012     
0050 6E3C C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6E3E A010     
0051 6E40 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6E42 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6E44 A208     
0057 6E46 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6E48 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6E4A 2570     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6E4C C820  54         mov   @outparm2,@tv.sams.c000
     6E4E A012     
     6E50 A208     
0066                                                   ; Set page in shadow registers
0067               
0068 6E52 C820  54         mov   @outparm2,@edb.sams.page
     6E54 A012     
     6E56 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6E58 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6E5A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6E5C C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6E5E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0119                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6E60 0649  14         dect  stack
0028 6E62 C64B  30         mov   r11,*stack            ; Save return address
0029 6E64 0649  14         dect  stack
0030 6E66 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6E68 0649  14         dect  stack
0032 6E6A C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6E6C 0649  14         dect  stack
0034 6E6E C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6E70 0649  14         dect  stack
0036 6E72 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6E74 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E76 A30C     
     6E78 A140     
0041 6E7A 04E0  34         clr   @fb.column
     6E7C A30C     
0042 6E7E 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E80 6994     
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6E82 04C4  14         clr   tmp0                  ; Counter
0047 6E84 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6E86 C160  34         mov   @fb.current,tmp1      ; Get position
     6E88 A302     
0049 6E8A C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E8C A142     
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6E8E D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6E90 0986  56         srl   tmp2,8                ; Right justify
0056 6E92 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6E94 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6E96 0286  22         ci    tmp2,32               ; Was it a space character?
     6E98 0020     
0063 6E9A 1301  14         jeq   edb.line.pack.fb.check80
0064 6E9C C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6E9E 0284  22         ci    tmp0,colrow
     6EA0 0050     
0070 6EA2 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6EA4 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6EA6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6EA8 FFCE     
0078 6EAA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6EAC 2026     
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6EAE 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6EB0 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6EB2 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6EB4 A144     
0086 6EB6 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6EB8 C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6EBA A144     
0092               
0093 6EBC 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6EBE C184  18         mov   tmp0,tmp2             ; \
0096 6EC0 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6EC2 0586  14         inc   tmp2                  ; /
0098               
0099 6EC4 C107  18         mov   tmp3,tmp0             ; \
0100 6EC6 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6EC8 A142     
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6ECA DD05  32         movb  tmp1,*tmp0+
0104 6ECC 0606  14         dec   tmp2
0105 6ECE 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6ED0 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6ED2 6DD0     
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6ED4 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6ED6 A304     
     6ED8 A000     
0117 6EDA A820  54         a     @fb.row,@parm1        ; /
     6EDC A306     
     6EDE A000     
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6EE0 C820  54         mov   @edb.next_free.ptr,@parm2
     6EE2 A508     
     6EE4 A002     
0123                                                   ; Pointer to new line
0124 6EE6 C820  54         mov   @edb.sams.hipage,@parm3
     6EE8 A518     
     6EEA A004     
0125                                                   ; SAMS page to use
0126               
0127 6EEC 06A0  32         bl    @idx.entry.update     ; Update index
     6EEE 6C30     
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6EF0 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6EF2 A142     
0136 6EF4 C160  34         mov   @edb.next_free.ptr,tmp1
     6EF6 A508     
0137                                                   ; Address of line in editor buffer
0138               
0139 6EF8 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6EFA A508     
0140               
0141 6EFC C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6EFE A144     
0142 6F00 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6F02 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6F04 0286  22         ci    tmp2,2
     6F06 0002     
0150 6F08 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6F0A DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6F0C DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6F0E 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6F10 0286  22         ci    tmp2,1
     6F12 0001     
0157 6F14 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6F16 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6F18 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6F1A 06A0  32         bl    @xpym2m               ; Copy memory block
     6F1C 24DA     
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6F1E A820  54         a     @rambuf+4,@edb.next_free.ptr
     6F20 A144     
     6F22 A508     
0171                                                      ; Add length of line
0172               
0173 6F24 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6F26 A508     
0174 6F28 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6F2A 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6F2C 000F     
0176 6F2E A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6F30 A508     
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6F32 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6F34 A140     
     6F36 A30C     
0182               
0183 6F38 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6F3A A518     
     6F3C A516     
0184 6F3E 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6F40 C120  34         mov   @edb.sams.page,tmp0
     6F42 A516     
0187 6F44 C160  34         mov   @edb.top.ptr,tmp1
     6F46 A500     
0188 6F48 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6F4A 2570     
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6F4C C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6F4E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6F50 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6F52 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6F54 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6F56 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0120                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0028 6F58 0649  14         dect  stack
0029 6F5A C64B  30         mov   r11,*stack            ; Save return address
0030 6F5C 0649  14         dect  stack
0031 6F5E C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6F60 0649  14         dect  stack
0033 6F62 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6F64 0649  14         dect  stack
0035 6F66 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6F68 C820  54         mov   @parm1,@rambuf
     6F6A A000     
     6F6C A140     
0040 6F6E C820  54         mov   @parm2,@rambuf+2
     6F70 A002     
     6F72 A142     
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6F74 C120  34         mov   @fb.colsline,tmp0
     6F76 A30E     
0045 6F78 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6F7A A002     
0046 6F7C C1A0  34         mov   @fb.top.ptr,tmp2
     6F7E A300     
0047 6F80 A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6F82 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F84 A146     
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6F86 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6F88 A000     
     6F8A A504     
0053 6F8C 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6F8E 04E0  34         clr   @rambuf+8             ; Set length=0
     6F90 A148     
0056 6F92 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6F94 C120  34 !       mov   @parm1,tmp0
     6F96 A000     
0061 6F98 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F9A 6E16     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6F9C C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F9E A010     
0069 6FA0 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6FA2 04E0  34         clr   @rambuf+8             ; Set length=0
     6FA4 A148     
0073 6FA6 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6FA8 C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6FAA C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6FAC A144     
0080 6FAE C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6FB0 A148     
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6FB2 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6FB4 0050     
0085                                                   ; /
0086 6FB6 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6FB8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FBA FFCE     
0091 6FBC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FBE 2026     
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6FC0 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6FC2 A146     
0097 6FC4 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6FC6 A148     
0098               
0099 6FC8 04C5  14         clr   tmp1                  ; Fill with >00
0100 6FCA C1A0  34         mov   @fb.colsline,tmp2
     6FCC A30E     
0101 6FCE 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6FD0 A148     
0102 6FD2 0586  14         inc   tmp2
0103               
0104 6FD4 06A0  32         bl    @xfilm                ; Fill CPU memory
     6FD6 2236     
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6FD8 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6FDA A148     
0113 6FDC 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6FDE C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6FE0 A144     
0116 6FE2 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6FE4 A146     
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6FE6 0286  22         ci    tmp2,80               ; Check line length
     6FE8 0050     
0122 6FEA 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6FEC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FEE FFCE     
0127 6FF0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FF2 2026     
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6FF4 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6FF6 A010     
0133               
0134 6FF8 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6FFA 24DA     
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6FFC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6FFE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 7000 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 7002 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 7004 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0121                       copy  "edb.line.getlen.asm"    ; Get line length
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
0021 7006 0649  14         dect  stack
0022 7008 C64B  30         mov   r11,*stack            ; Push return address
0023 700A 0649  14         dect  stack
0024 700C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 700E 0649  14         dect  stack
0026 7010 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 7012 04E0  34         clr   @outparm1             ; Reset length
     7014 A010     
0031 7016 04E0  34         clr   @outparm2             ; Reset SAMS bank
     7018 A012     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 701A C120  34         mov   @parm1,tmp0           ; \
     701C A000     
0036 701E 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 7020 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     7022 A504     
0039 7024 1101  14         jlt   !                     ; No, continue processing
0040 7026 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 7028 C120  34 !       mov   @parm1,tmp0           ; Get line
     702A A000     
0046               
0047 702C 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     702E 6E16     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 7030 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     7032 A010     
0053 7034 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 7036 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 7038 C805  38         mov   tmp1,@outparm1        ; Save length
     703A A010     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 703C 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     703E 0050     
0064 7040 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 7042 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7044 FFCE     
0070 7046 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7048 2026     
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 704A 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     704C A010     
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 704E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 7050 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 7052 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 7054 045B  20         b     *r11                  ; Return to caller
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
0103 7056 0649  14         dect  stack
0104 7058 C64B  30         mov   r11,*stack            ; Save return address
0105 705A 0649  14         dect  stack
0106 705C C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 705E C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7060 A304     
0111 7062 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7064 A306     
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 7066 C804  38         mov   tmp0,@parm1
     7068 A000     
0116 706A 06A0  32         bl    @edb.line.getlength
     706C 7006     
0117 706E C820  54         mov   @outparm1,@fb.row.length
     7070 A010     
     7072 A308     
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 7074 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 7076 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 7078 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0122                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 707A 0649  14         dect  stack
0032 707C C64B  30         mov   r11,*stack            ; Save return address
0033 707E 0649  14         dect  stack
0034 7080 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 7082 0649  14         dect  stack
0036 7084 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 7086 0649  14         dect  stack
0038 7088 C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 708A 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     708C A000     
     708E A504     
0043 7090 1204  14         jle   !
0044 7092 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7094 FFCE     
0045 7096 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7098 2026     
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 709A C120  34 !       mov   @parm2,tmp0           ; Get target line number
     709C A002     
0050 709E 0604  14         dec   tmp0                  ; Base 0
0051 70A0 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     70A2 A142     
0052 70A4 04E0  34         clr   @rambuf               ; Set source line length=0
     70A6 A140     
0053 70A8 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     70AA A144     
0054 70AC 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     70AE A146     
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 70B0 C120  34         mov   @parm1,tmp0           ; Get source line number
     70B2 A000     
0059 70B4 0604  14         dec   tmp0                  ; Base 0
0060               
0061 70B6 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     70B8 6E16     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 70BA C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     70BC A010     
0069 70BE 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 70C0 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 70C2 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 70C4 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     70C6 A140     
0077 70C8 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     70CA A140     
0078 70CC C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     70CE A144     
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 70D0 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     70D2 0050     
0083 70D4 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 70D6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70D8 FFCE     
0088 70DA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70DC 2026     
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 70DE A820  54         a     @w$1000,@edb.top.ptr
     70E0 201A     
     70E2 A500     
0094 70E4 A820  54         a     @w$1000,@edb.next_free.ptr
     70E6 201A     
     70E8 A508     
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 70EA 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     70EC 6DD0     
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 70EE C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     70F0 A144     
0111 70F2 C160  34         mov   @edb.next_free.ptr,tmp1
     70F4 A508     
0112                                                   ; Pointer to space for new target line
0113               
0114 70F6 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     70F8 A140     
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 70FA 06A0  32         bl    @xpym2m               ; Copy memory block
     70FC 24DA     
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 70FE 6820  54         s     @w$1000,@edb.top.ptr
     7100 201A     
     7102 A500     
0127 7104 6820  54         s     @w$1000,@edb.next_free.ptr
     7106 201A     
     7108 A508     
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 710A C820  54         mov   @edb.next_free.ptr,@rambuf+6
     710C A508     
     710E A146     
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 7110 C120  34         mov   @edb.sams.page,tmp0
     7112 A516     
0138 7114 C160  34         mov   @edb.top.ptr,tmp1
     7116 A500     
0139 7118 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     711A 2570     
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 711C C120  34         mov   @tv.sams.d000,tmp0
     711E A20A     
0146 7120 0205  20         li    tmp1,>d000
     7122 D000     
0147 7124 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7126 2570     
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 7128 A820  54         a     @rambuf,@edb.next_free.ptr
     712A A140     
     712C A508     
0154                                                      ; Add length of line
0155               
0156 712E C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7130 A508     
0157 7132 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7134 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7136 000F     
0159 7138 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     713A A508     
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 713C C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     713E A142     
     7140 A000     
0165 7142 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     7144 A146     
     7146 A002     
0166 7148 C820  54         mov   @edb.sams.hipage,@parm3
     714A A518     
     714C A004     
0167                                                   ; SAMS page to use
0168               
0169 714E 06A0  32         bl    @idx.entry.update     ; Update index
     7150 6C30     
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 7152 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7154 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7156 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 7158 C2F9  30         mov   *stack+,r11           ; Pop r11
0182 715A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0123                       copy  "edb.line.del.asm"       ; Delete line
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
0024 715C 0649  14         dect  stack
0025 715E C64B  30         mov   r11,*stack            ; Save return address
0026 7160 0649  14         dect  stack
0027 7162 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 7164 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     7166 A000     
     7168 A504     
0032 716A 1204  14         jle   !
0033 716C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     716E FFCE     
0034 7170 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7172 2026     
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 7174 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7176 A506     
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 7178 C120  34          mov   @edb.lines,tmp0      ; \
     717A A504     
0043 717C 0284  22          ci    tmp0,1               ; | Only single line?
     717E 0001     
0044 7180 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 7182 0620  34         dec   @parm1                ; Base 0
     7184 A000     
0049 7186 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7188 A504     
     718A A002     
0050               
0051 718C 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     718E 6CDE     
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 7190 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7192 A504     
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 7194 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7196 A50C     
     7198 2022     
0061 719A 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 719C 8820  54         c     @parm1,@edb.block.m1  ; \
     719E A000     
     71A0 A50C     
0064 71A2 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 71A4 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 71A6 8820  54         c     @edb.block.m1,@w$0001 ; \
     71A8 A50C     
     71AA 2002     
0068 71AC 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 71AE 0620  34         dec   @edb.block.m1         ; M1--
     71B0 A50C     
0071 71B2 0720  34         seto  @fb.colorize          ; Set colorize flag
     71B4 A310     
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 71B6 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     71B8 A50E     
     71BA 2022     
0077 71BC 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 71BE 8820  54         c     @parm1,@edb.block.m2  ; \
     71C0 A000     
     71C2 A50E     
0080 71C4 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 71C6 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 71C8 8820  54         c     @edb.block.m2,@w$0001 ; \
     71CA A50E     
     71CC 2002     
0084 71CE 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 71D0 0620  34         dec   @edb.block.m2         ; M2--
     71D2 A50E     
0087 71D4 0720  34         seto  @fb.colorize          ; Set colorize flag
     71D6 A310     
0088 71D8 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 71DA 04E0  34         clr   @parm1                ; 1st line
     71DC A000     
0094 71DE 04E0  34         clr   @parm2                ; 1st line
     71E0 A002     
0095               
0096 71E2 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     71E4 6CDE     
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 71E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 71E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 71EA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0124                       copy  "edb.block.mark.asm"     ; Mark code block
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
0020 71EC 0649  14         dect  stack
0021 71EE C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 71F0 C820  54         mov   @fb.row,@parm1
     71F2 A306     
     71F4 A000     
0026 71F6 06A0  32         bl    @fb.row2line          ; Row to editor line
     71F8 697A     
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 71FA 05A0  34         inc   @outparm1             ; Add base 1
     71FC A010     
0032               
0033 71FE C820  54         mov   @outparm1,@edb.block.m1
     7200 A010     
     7202 A50C     
0034                                                   ; Set block marker M1
0035 7204 0720  34         seto  @fb.colorize          ; Set colorize flag
     7206 A310     
0036 7208 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     720A A316     
0037 720C 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     720E A318     
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 7210 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 7212 045B  20         b     *r11                  ; Return to caller
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
0062 7214 0649  14         dect  stack
0063 7216 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 7218 C820  54         mov   @fb.row,@parm1
     721A A306     
     721C A000     
0068 721E 06A0  32         bl    @fb.row2line          ; Row to editor line
     7220 697A     
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7222 05A0  34         inc   @outparm1             ; Add base 1
     7224 A010     
0074               
0075 7226 C820  54         mov   @outparm1,@edb.block.m2
     7228 A010     
     722A A50E     
0076                                                   ; Set block marker M2
0077               
0078 722C 0720  34         seto  @fb.colorize          ; Set colorize flag
     722E A310     
0079 7230 0720  34         seto  @fb.dirty             ; Trigger refresh
     7232 A316     
0080 7234 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7236 A318     
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 7238 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 723A 045B  20         b     *r11                  ; Return to caller
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
0106 723C 0649  14         dect  stack
0107 723E C64B  30         mov   r11,*stack            ; Push return address
0108 7240 0649  14         dect  stack
0109 7242 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 7244 0649  14         dect  stack
0111 7246 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 7248 C820  54         mov   @fb.row,@parm1
     724A A306     
     724C A000     
0116 724E 06A0  32         bl    @fb.row2line          ; Row to editor line
     7250 697A     
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 7252 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     7254 A010     
0122 7256 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 and M2 must be set
0125                       ;------------------------------------------------------
0126 7258 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     725A A50C     
0127 725C 0584  14         inc   tmp0                  ; /
0128 725E 1608  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and M2 and exit
0132                       ;------------------------------------------------------
0133 7260 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     7262 71EC     
0134 7264 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     7266 7214     
0135 7268 1008  14         jmp   edb.block.mark.exit
0136                       ;------------------------------------------------------
0137                       ; Set M1 and exit
0138                       ;------------------------------------------------------
0139               _edb.block.mark.m1.set:
0140 726A 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     726C 71EC     
0141 726E 1005  14         jmp   edb.block.mark.exit
0142                       ;------------------------------------------------------
0143                       ; Update M1 if current line < M1
0144                       ;------------------------------------------------------
0145               edb.block.mark.is_line_m1:
0146 7270 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     7272 A50C     
0147 7274 15FA  14         jgt   _edb.block.mark.m1.set
0148                                                   ; Set M1 to current line and exit
0149                       ;------------------------------------------------------
0150                       ; Set M2 and exit
0151                       ;------------------------------------------------------
0152 7276 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     7278 7214     
0153                       ;------------------------------------------------------
0154                       ; Exit
0155                       ;------------------------------------------------------
0156               edb.block.mark.exit:
0157 727A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 727C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 727E C2F9  30         mov   *stack+,r11           ; Pop r11
0160 7280 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0125                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 7282 0649  14         dect  stack
0018 7284 C64B  30         mov   r11,*stack            ; Push return address
0019 7286 0649  14         dect  stack
0020 7288 C660  46         mov   @wyx,*stack           ; Push cursor position
     728A 832A     
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 728C 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     728E A50C     
0025 7290 0720  34         seto  @edb.block.m2         ; /
     7292 A50E     
0026               
0027 7294 0720  34         seto  @fb.colorize          ; Set colorize flag
     7296 A310     
0028 7298 0720  34         seto  @fb.dirty             ; Trigger refresh
     729A A316     
0029 729C 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     729E A318     
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 72A0 0720  34         seto  @parm1
     72A2 A000     
0034 72A4 06A0  32         bl    @pane.action.colorscheme.load
     72A6 7696     
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 72A8 C820  54         mov   @tv.color,@parm1      ; Set normal color
     72AA A218     
     72AC A000     
0042 72AE 06A0  32         bl    @pane.action.colorscheme.statlines
     72B0 7826     
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 72B2 06A0  32         bl    @hchar
     72B4 27C2     
0048 72B6 0034                   byte 0,52,32,18           ; Remove markers
     72B8 2012     
0049 72BA 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     72BC 2037     
0050 72BE FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 72C0 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     72C2 832A     
0056 72C4 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 72C6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0126                       copy  "edb.block.copy.asm"     ; Copy code block
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
0027 72C8 0649  14         dect  stack
0028 72CA C64B  30         mov   r11,*stack            ; Save return address
0029 72CC 0649  14         dect  stack
0030 72CE C644  30         mov   tmp0,*stack           ; Push tmp0
0031 72D0 0649  14         dect  stack
0032 72D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 72D4 0649  14         dect  stack
0034 72D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 72D8 0649  14         dect  stack
0036 72DA C660  46         mov   @parm1,*stack         ; Push parm1
     72DC A000     
0037 72DE 04E0  34         clr   @outparm1             ; No action (>0000)
     72E0 A010     
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 72E2 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     72E4 A50C     
     72E6 2022     
0042 72E8 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 72EA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     72EC A50E     
     72EE 2022     
0045 72F0 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 72F2 8820  54         c     @edb.block.m1,@edb.block.m2
     72F4 A50C     
     72F6 A50E     
0048                                                   ; M1 > M2 ?
0049 72F8 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 72FA C820  54         mov   @fb.row,@parm1
     72FC A306     
     72FE A000     
0054 7300 06A0  32         bl    @fb.row2line          ; Row to editor line
     7302 697A     
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 7304 C120  34         mov   @outparm1,tmp0        ; \
     7306 A010     
0060 7308 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 730A C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     730C A510     
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 730E 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7310 A010     
0066 7312 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 7314 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     7316 A010     
0069 7318 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 731A 06A0  32         bl    @cpym2m
     731C 24D4     
0072 731E 371C                   data txt.block.inside,tv.error.msg,53
     7320 A22A     
     7322 0035     
0073               
0074 7324 06A0  32         bl    @pane.errline.show    ; Show error line
     7326 7964     
0075               
0076 7328 04E0  34         clr   @outparm1             ; No action (>0000)
     732A A010     
0077 732C 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 732E C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7330 A21C     
     7332 A000     
0082 7334 06A0  32         bl    @pane.action.colorscheme.statlines
     7336 7826     
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 7338 06A0  32         bl    @hchar
     733A 27C2     
0088 733C 1D00                   byte pane.botrow,0,32,55
     733E 2037     
0089 7340 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 7342 C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 7344 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 7346 06A0  32         bl    @putat
     7348 243C     
0098 734A 1D00                   byte pane.botrow,0
0099 734C 3560                   data txt.block.copy   ; Display "Copying block...."
0100 734E 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 7350 06A0  32         bl    @putat
     7352 243C     
0104 7354 1D00                   byte pane.botrow,0
0105 7356 3572                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 7358 C120  34         mov   @edb.block.m1,tmp0    ; M1
     735A A50C     
0111 735C C1A0  34         mov   @edb.block.m2,tmp2    ; \
     735E A50E     
0112 7360 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 7362 0586  14         inc   tmp2                  ; /
0114               
0115 7364 C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     7366 A510     
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 7368 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     736A A000     
0121 736C 0620  34         dec   @parm1                ; Base 0 offset for index required
     736E A000     
0122 7370 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7372 A504     
     7374 A002     
0123               
0124 7376 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     7378 6D78     
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 737A 8805  38         c     tmp1,@edb.block.m1
     737C A50C     
0131 737E 1506  14         jgt   edb.block.copy.loop.docopy
0132 7380 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 7382 05A0  34         inc   @edb.block.m1         ; M1++
     7384 A50C     
0135 7386 05A0  34         inc   @edb.block.m2         ; M2++
     7388 A50E     
0136 738A 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 738C C804  38         mov   tmp0,@parm1           ; Source line for copy
     738E A000     
0142 7390 C805  38         mov   tmp1,@parm2           ; Target line for copy
     7392 A002     
0143               
0144 7394 06A0  32         bl    @edb.line.copy        ; Copy line
     7396 707A     
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 7398 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     739A A504     
0151 739C 0584  14         inc   tmp0                  ; Next source line
0152 739E 0585  14         inc   tmp1                  ; Next target line
0153 73A0 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 73A2 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 73A4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     73A6 A506     
0159 73A8 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     73AA A316     
0160 73AC 0720  34         seto  @outparm1             ; Copy completed
     73AE A010     
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 73B0 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     73B2 A000     
0166 73B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 73B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 73B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 73BA C2F9  30         mov   *stack+,r11           ; Pop R11
0170 73BC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0127                       copy  "edb.block.del.asm"      ; Delete code block
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
0027 73BE 0649  14         dect  stack
0028 73C0 C64B  30         mov   r11,*stack            ; Save return address
0029 73C2 0649  14         dect  stack
0030 73C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 73C6 0649  14         dect  stack
0032 73C8 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 73CA 0649  14         dect  stack
0034 73CC C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 73CE 04E0  34         clr   @outparm1             ; No action (>0000)
     73D0 A010     
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 73D2 C120  34         mov   @edb.block.m1,tmp0    ; \
     73D4 A50C     
0041 73D6 0584  14         inc   tmp0                  ; | M1 unset?
0042 73D8 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 73DA C160  34         mov   @edb.block.m2,tmp1    ; \
     73DC A50E     
0045 73DE 0584  14         inc   tmp0                  ; | M2 unset?
0046 73E0 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 73E2 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     73E4 A000     
0051 73E6 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 73E8 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     73EA A21C     
     73EC A000     
0056               
0057 73EE 06A0  32         bl    @pane.action.colorscheme.statlines
     73F0 7826     
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 73F2 06A0  32         bl    @hchar
     73F4 27C2     
0063 73F6 1D00                   byte pane.botrow,0,32,55
     73F8 2037     
0064 73FA FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 73FC 06A0  32         bl    @putat
     73FE 243C     
0067 7400 1D00                   byte pane.botrow,0
0068 7402 354C                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 7404 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     7406 A50C     
0074 7408 0604  14         dec   tmp0                  ; Base 0
0075               
0076 740A C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     740C A50E     
0077 740E 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7410 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     7412 A000     
0080 7414 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7416 A504     
     7418 A002     
0081 741A 0620  34         dec   @parm2                ; Base 0
     741C A002     
0082               
0083 741E C185  18         mov   tmp1,tmp2             ; \
0084 7420 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 7422 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 7424 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7426 6CDE     
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 7428 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     742A A504     
0095 742C 0620  34         dec   @parm2                ; /
     742E A002     
0096               
0097 7430 0606  14         dec   tmp2
0098 7432 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 7434 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7436 A506     
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 7438 8820  54         c     @fb.topline,@edb.lines
     743A A304     
     743C A504     
0104                                                   ; Beyond editor buffer?
0105 743E 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7440 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     7442 A304     
     7444 A000     
0108 7446 1002  14         jmp   edb.block.delete.fb.refresh
0109 7448 04E0  34 !       clr   @parm1                ; Set line to start with
     744A A000     
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 744C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     744E 6B84     
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 7450 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     7452 7282     
0119               
0120 7454 0720  34         seto  @outparm1             ; Delete completed
     7456 A010     
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 7458 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 745A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 745C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 745E C2F9  30         mov   *stack+,r11           ; Pop R11
                   < stevie_b1.asm.37021
0128                       ;-----------------------------------------------------------------------
0129                       ; User hook, background tasks
0130                       ;-----------------------------------------------------------------------
0131                       copy  "hook.keyscan.asm"       ; spectra2 user hook: keyboard scan
     **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 7460 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7462 200A     
0009 7464 161C  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 7466 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7468 833C     
     746A A022     
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 746C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     746E 200A     
0016 7470 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     7472 A022     
     7474 A024     
0017 7476 1608  14         jne   hook.keyscan.new      ; New key pressed
0018               *---------------------------------------------------------------
0019               * Activate auto-repeat ?
0020               *---------------------------------------------------------------
0021 7478 05A0  34         inc   @keyrptcnt
     747A A020     
0022 747C C120  34         mov   @keyrptcnt,tmp0
     747E A020     
0023 7480 0284  22         ci    tmp0,30
     7482 001E     
0024 7484 1112  14         jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
0025 7486 1002  14         jmp   hook.keyscan.autorepeat
0026               *--------------------------------------------------------------
0027               * New key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.new:
0030 7488 04E0  34         clr   @keyrptcnt            ; Reset key-repeat counter
     748A A020     
0031               hook.keyscan.autorepeat:
0032 748C 0204  20         li    tmp0,250              ; \
     748E 00FA     
0033 7490 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0034 7492 16FE  14         jne   -!                    ; /
0035 7494 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     7496 A022     
     7498 A024     
0036 749A 0460  28         b     @edkey.key.process    ; Process key
     749C 60E6     
0037               *--------------------------------------------------------------
0038               * Clear keyboard buffer if no key pressed
0039               *--------------------------------------------------------------
0040               hook.keyscan.clear_kbbuffer:
0041 749E 04E0  34         clr   @keycode1
     74A0 A022     
0042 74A2 04E0  34         clr   @keycode2
     74A4 A024     
0043 74A6 04E0  34         clr   @keyrptcnt
     74A8 A020     
0044               *--------------------------------------------------------------
0045               * Delay to avoid key bouncing
0046               *--------------------------------------------------------------
0047               hook.keyscan.bounce:
0048 74AA 0204  20         li    tmp0,2000             ; Avoid key bouncing
     74AC 07D0     
0049                       ;------------------------------------------------------
0050                       ; Delay loop
0051                       ;------------------------------------------------------
0052               hook.keyscan.bounce.loop:
0053 74AE 0604  14         dec   tmp0
0054 74B0 16FE  14         jne   hook.keyscan.bounce.loop
0055 74B2 0460  28         b     @hookok               ; Return
     74B4 2EC8     
0056               
                   < stevie_b1.asm.37021
0132                       copy  "task.vdp.panes.asm"     ; Draw editor panes in VDP
     **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 74B6 0649  14         dect  stack
0009 74B8 C64B  30         mov   r11,*stack            ; Save return address
0010 74BA 0649  14         dect  stack
0011 74BC C644  30         mov   tmp0,*stack           ; Push tmp0
0012 74BE 0649  14         dect  stack
0013 74C0 C660  46         mov   @wyx,*stack           ; Push cursor position
     74C2 832A     
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 74C4 20A0  38         coc   @wbit10,config
     74C6 200C     
0019 74C8 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 74CA 06A0  32         bl    @putat
     74CC 243C     
0024 74CE 1D4E                   byte pane.botrow,78
0025 74D0 3668                   data txt.ws4
0026 74D2 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 74D4 06A0  32         bl    @putat
     74D6 243C     
0032 74D8 1D4E                   byte pane.botrow,78
0033 74DA 3656                   data txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 74DC C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74DE A702     
0039 74E0 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 74E2 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74E4 A718     
0045 74E6 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 74E8 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     74EA 7C34     
0048 74EC 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     74EE A718     
0049 74F0 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 74F2 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     74F4 A316     
0054 74F6 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056 74F8 C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     74FA A31A     
     74FC A000     
0057               
0058               task.vdp.panes.dump:
0059 74FE 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7500 7CA6     
0060                                                   ; \ i  @parm1 = number of lines to dump
0061                                                   ; /
0062                       ;------------------------------------------------------
0063                       ; Color the lines in the framebuffer (TAT)
0064                       ;------------------------------------------------------
0065 7502 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     7504 A310     
0066 7506 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0067               
0068 7508 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     750A 7C94     
0069                       ;-------------------------------------------------------
0070                       ; Finished with frame buffer
0071                       ;-------------------------------------------------------
0072               task.vdp.panes.dumped:
0073 750C 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     750E A316     
0074 7510 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     7512 A318     
0075                       ;-------------------------------------------------------
0076                       ; Refresh top and bottom line
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.statlines:
0079 7514 C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     7516 A318     
0080 7518 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0081               
0082 751A 06A0  32         bl    @pane.topline         ; Draw top line
     751C 78C8     
0083 751E 06A0  32         bl    @pane.botline         ; Draw bottom line
     7520 79FE     
0084 7522 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     7524 A318     
0085                       ;------------------------------------------------------
0086                       ; Show ruler with tab positions
0087                       ;------------------------------------------------------
0088 7526 C120  34         mov   @tv.ruler.visible,tmp0
     7528 A210     
0089                                                   ; Should ruler be visible?
0090 752A 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0091               
0092 752C 06A0  32         bl    @cpym2v
     752E 2480     
0093 7530 0050                   data vdp.fb.toprow.sit
0094 7532 A31E                   data fb.ruler.sit
0095 7534 0050                   data 80               ; Show ruler
0096                       ;------------------------------------------------------
0097                       ; Exit task
0098                       ;------------------------------------------------------
0099               task.vdp.panes.exit:
0100 7536 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7538 832A     
0101 753A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 753C C2F9  30         mov   *stack+,r11           ; Pop r11
0103 753E 0460  28         b     @slotok
     7540 2F44     
                   < stevie_b1.asm.37021
0133               
0135               
0136                       copy  "task.vdp.cursor.sat.asm"
     **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 7542 0649  14         dect  stack
0009 7544 C64B  30         mov   r11,*stack            ; Save return address
0010 7546 0649  14         dect  stack
0011 7548 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 754A 0649  14         dect  stack
0013 754C C645  30         mov   tmp1,*stack           ; Push tmp1
0014 754E 0649  14         dect  stack
0015 7550 C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 7552 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7554 A222     
0020               
0021 7556 0284  22         ci    tmp0,pane.focus.fb
     7558 0000     
0022 755A 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 755C 0284  22         ci    tmp0,pane.focus.cmdb
     755E 0001     
0025 7560 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 7562 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7564 FFCE     
0031 7566 06A0  32         bl    @cpu.crash            ; / Halt system.
     7568 2026     
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 756A C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     756C A70A     
     756E 832A     
0037 7570 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7572 2020     
0038 7574 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7576 26EA     
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 7578 100D  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 757A E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     757C 2020     
0048 757E 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7580 26EA     
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 7582 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     7584 A210     
     7586 A210     
0053 7588 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0054 758A 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     758C 1000     
0055 758E 1002  14         jmp   task.vdp.copy.sat.write
0056               task.vdp.copy.sat.fb.noruler:
0057 7590 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     7592 0800     
0058                       ;------------------------------------------------------
0059                       ; Dump sprite attribute table
0060                       ;------------------------------------------------------
0061               task.vdp.copy.sat.write:
0062 7594 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7596 A180     
0063                       ;------------------------------------------------------
0064                       ; Handle column and row indicators
0065                       ;------------------------------------------------------
0066 7598 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     759A A210     
     759C A210     
0067                                                   ; Is ruler visible?
0068 759E 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0069               
0070 75A0 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     75A2 FF00     
0071 75A4 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     75A6 00F0     
0072 75A8 C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     75AA A184     
0073               
0074 75AC C120  34         mov   @ramsat,tmp0
     75AE A180     
0075 75B0 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     75B2 00FF     
0076 75B4 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     75B6 0800     
0077 75B8 C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     75BA A188     
0078               
0079 75BC 1005  14         jmp   task.vdp.copy.sat.write2
0080                       ;------------------------------------------------------
0081                       ; Do not show column and row indicators
0082                       ;------------------------------------------------------
0083               task.vdp.copy.sat.hide.indicators:
0084 75BE 04C5  14         clr   tmp1
0085 75C0 D805  38         movb  tmp1,@ramsat+7        ; Hide line indicator    <
     75C2 A187     
0086 75C4 D805  38         movb  tmp1,@ramsat+11       ; Hide column indicator  v
     75C6 A18B     
0087                       ;------------------------------------------------------
0088                       ; Dump to VDP
0089                       ;------------------------------------------------------
0090               task.vdp.copy.sat.write2:
0091 75C8 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75CA 2480     
0092 75CC 2180                   data sprsat,ramsat,14 ; \ i  tmp0 = VDP destination
     75CE A180     
     75D0 000E     
0093                                                   ; | i  tmp1 = ROM/RAM source
0094                                                   ; / i  tmp2 = Number of bytes to write
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               task.vdp.copy.sat.exit:
0099 75D2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 75D4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 75D6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 75D8 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 75DA 0460  28         b     @slotok               ; Exit task
     75DC 2F44     
                   < stevie_b1.asm.37021
0137                                                      ; Copy cursor SAT to VDP
0138                       copy  "task.vdp.cursor.f18a.asm"
     **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 75DE 0649  14         dect  stack
0009 75E0 C64B  30         mov   r11,*stack            ; Save return address
0010 75E2 0649  14         dect  stack
0011 75E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 75E6 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     75E8 A312     
0016 75EA 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 75EC 04C4  14         clr   tmp0
0021 75EE D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     75F0 A183     
0022 75F2 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 75F4 C820  54         mov   @tv.curshape,@ramsat+2
     75F6 A214     
     75F8 A182     
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 75FA 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75FC 2480     
0035 75FE 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     7600 A180     
     7602 0004     
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 7604 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 7606 C2F9  30         mov   *stack+,r11           ; Pop r11
0044 7608 0460  28         b     @slotok               ; Exit task
     760A 2F44     
                   < stevie_b1.asm.37021
0139                                                      ; Set cursor shape in VDP (blink)
0146               
0147                       copy  "task.oneshot.asm"       ; Run "one shot" task
     **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 760C C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     760E A224     
0010 7610 1301  14         jeq   task.oneshot.exit
0011               
0012 7612 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 7614 0460  28         b     @slotok                ; Exit task
     7616 2F44     
                   < stevie_b1.asm.37021
0148                       ;-----------------------------------------------------------------------
0149                       ; Screen pane utilities
0150                       ;-----------------------------------------------------------------------
0151                       copy  "pane.utils.asm"         ; Pane utility functions
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
0020 7618 0649  14         dect  stack
0021 761A C64B  30         mov   r11,*stack            ; Push return address
0022 761C 0649  14         dect  stack
0023 761E C660  46         mov   @wyx,*stack           ; Push cursor position
     7620 832A     
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 7622 06A0  32         bl    @hchar
     7624 27C2     
0028 7626 0034                   byte 0,52,32,18
     7628 2012     
0029 762A FFFF                   data EOL              ; Clear message
0030               
0031 762C 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     762E A224     
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 7630 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7632 832A     
0037 7634 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 7636 045B  20         b     *r11                  ; Return to task
                   < stevie_b1.asm.37021
0152                       copy  "pane.utils.colorscheme.asm"
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
0017 7638 0649  14         dect  stack
0018 763A C64B  30         mov   r11,*stack            ; Push return address
0019 763C 0649  14         dect  stack
0020 763E C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 7640 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7642 A212     
0023 7644 0284  22         ci    tmp0,tv.colorscheme.entries
     7646 000A     
0024                                                   ; Last entry reached?
0025 7648 1103  14         jlt   !
0026 764A 0204  20         li    tmp0,1                ; Reset color scheme index
     764C 0001     
0027 764E 1001  14         jmp   pane.action.colorscheme.switch
0028 7650 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 7652 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7654 A212     
0034               
0035 7656 06A0  32         bl    @pane.action.colorscheme.load
     7658 7696     
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 765A C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     765C 832A     
     765E 833C     
0041               
0042 7660 06A0  32         bl    @putnum
     7662 2B0E     
0043 7664 003E                   byte 0,62
0044 7666 A212                   data tv.colorscheme,rambuf,>3020
     7668 A140     
     766A 3020     
0045               
0046 766C 06A0  32         bl    @putat
     766E 243C     
0047 7670 0034                   byte 0,52
0048 7672 3754                   data txt.colorscheme  ; Show color palette message
0049               
0050 7674 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     7676 833C     
     7678 832A     
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 767A 0204  20         li    tmp0,12000
     767C 2EE0     
0055 767E 0604  14 !       dec   tmp0
0056 7680 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 7682 0204  20         li    tmp0,pane.clearmsg.task.callback
     7684 7618     
0061 7686 C804  38         mov   tmp0,@tv.task.oneshot
     7688 A224     
0062               
0063 768A 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     768C 2FB8     
0064 768E 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 7690 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7692 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 7694 045B  20         b     *r11                  ; Return to caller
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
0093 7696 0649  14         dect  stack
0094 7698 C64B  30         mov   r11,*stack            ; Save return address
0095 769A 0649  14         dect  stack
0096 769C C644  30         mov   tmp0,*stack           ; Push tmp0
0097 769E 0649  14         dect  stack
0098 76A0 C645  30         mov   tmp1,*stack           ; Push tmp1
0099 76A2 0649  14         dect  stack
0100 76A4 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 76A6 0649  14         dect  stack
0102 76A8 C647  30         mov   tmp3,*stack           ; Push tmp3
0103 76AA 0649  14         dect  stack
0104 76AC C648  30         mov   tmp4,*stack           ; Push tmp4
0105 76AE 0649  14         dect  stack
0106 76B0 C660  46         mov   @parm1,*stack         ; Push parm1
     76B2 A000     
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 76B4 C120  34         mov   @parm1,tmp0
     76B6 A000     
0111 76B8 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     76BA FFFF     
0112 76BC 1302  14         jeq   !                     ; Yes, so skip screen off
0113 76BE 06A0  32         bl    @scroff               ; Turn screen off
     76C0 2688     
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 76C2 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     76C4 A212     
0118 76C6 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 76C8 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 76CA 0224  22         ai    tmp0,tv.colorscheme.table
     76CC 34BE     
0122                                                   ; Add base for color scheme data table
0123 76CE C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 76D0 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     76D2 A218     
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 76D4 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 76D6 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     76D8 00FF     
0130 76DA C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     76DC A216     
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 76DE C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 76E0 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     76E2 FF00     
0136 76E4 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 76E6 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 76E8 C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 76EA 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 76EC C806  38         mov   tmp2,@tv.busycolor    ; /
     76EE A21C     
0142               
0143 76F0 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     76F2 00FF     
0144 76F4 C805  38         mov   tmp1,@tv.markcolor    ; /
     76F6 A21A     
0145               
0146 76F8 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 76FA 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 76FC C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     76FE A220     
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 7700 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 7702 0245  22         andi  tmp1,>000f            ; Only keep P
     7704 000F     
0154 7706 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 7708 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     770A A21E     
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 770C C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 770E 0245  22         andi  tmp1,>00f0            ; Only keep O
     7710 00F0     
0161 7712 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 7714 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     7716 A187     
0163 7718 D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     771A A18B     
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 771C C147  18         mov   tmp3,tmp1             ; Get work copy
0168 771E 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 7720 0265  22         ori   tmp1,>0700
     7722 0700     
0170 7724 C105  18         mov   tmp1,tmp0
0171 7726 06A0  32         bl    @putvrx               ; Write VDP register
     7728 232E     
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 772A C120  34         mov   @tv.ruler.visible,tmp0
     772C A210     
0176 772E 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177 7730 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     7732 18A0     
0178                                                   ; VDP start address (frame buffer area)
0179 7734 0206  20         li    tmp2,(pane.botrow-2)*80
     7736 0870     
0180                                                   ; Number of bytes to fill
0181 7738 1004  14         jmp   pane.action.colorscheme.fbdump
0182               pane.action.colorscheme.fbdump.noruler:
0183 773A 0204  20         li    tmp0,vdp.fb.toprow.tat
     773C 1850     
0184                                                   ; VDP start address (frame buffer area)
0185 773E 0206  20         li    tmp2,(pane.botrow-1)*80
     7740 08C0     
0186                                                   ; Number of bytes to fill
0187               pane.action.colorscheme.fbdump:
0188 7742 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0189 7744 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0190               
0191 7746 06A0  32         bl    @xfilv                ; Fill colors
     7748 228E     
0192                                                   ; i \  tmp0 = start address
0193                                                   ; i |  tmp1 = byte to fill
0194                                                   ; i /  tmp2 = number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Colorize marked lines
0197                       ;-------------------------------------------------------
0198 774A C120  34         mov   @parm2,tmp0
     774C A002     
0199 774E 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     7750 FFFF     
0200 7752 1304  14         jeq   pane.action.colorscheme.cmdbpane
0201               
0202 7754 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     7756 A310     
0203 7758 06A0  32         bl    @fb.colorlines
     775A 7C94     
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for CMDB pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.cmdbpane:
0208 775C C120  34         mov   @cmdb.visible,tmp0
     775E A702     
0209 7760 131E  14         jeq   pane.action.colorscheme.errpane
0210                                                   ; Skip if CMDB pane is hidden
0211               
0212 7762 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     7764 1FD0     
0213                                                   ; VDP start address (CMDB top line)
0214               
0215 7766 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     7768 A220     
0216 776A 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     776C 0050     
0217 776E 06A0  32         bl    @xfilv                ; Fill colors
     7770 228E     
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for CMDB pane content (TAT)
0223                       ;-------------------------------------------------------
0224 7772 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     7774 2020     
0225                                                   ; VDP start address (CMDB top line + 1)
0226 7776 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0227 7778 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     777A 0050     
0228 777C 06A0  32         bl    @xfilv                ; Fill colors
     777E 228E     
0229                                                   ; i \  tmp0 = start address
0230                                                   ; i |  tmp1 = byte to fill
0231                                                   ; i /  tmp2 = number of bytes to fill
0232               
0233 7780 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 160
     7782 2070     
0234                                                   ; VDP start address (CMDB top line + 2)
0235 7784 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; Same color as header line
     7786 A220     
0236 7788 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     778A 0050     
0237 778C 06A0  32         bl    @xfilv                ; Fill colors
     778E 228E     
0238                                                   ; i \  tmp0 = start address
0239                                                   ; i |  tmp1 = byte to fill
0240                                                   ; i /  tmp2 = number of bytes to fill
0241               
0242 7790 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 240
     7792 20C0     
0243                                                   ; VDP start address (CMDB top line + 3)
0244 7794 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0245 7796 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7798 0050     
0246 779A 06A0  32         bl    @xfilv                ; Fill colors
     779C 228E     
0247                                                   ; i \  tmp0 = start address
0248                                                   ; i |  tmp1 = byte to fill
0249                                                   ; i /  tmp2 = number of bytes to fill
0250                       ;-------------------------------------------------------
0251                       ; Dump colors for error line (TAT)
0252                       ;-------------------------------------------------------
0253               pane.action.colorscheme.errpane:
0254 779E C120  34         mov   @tv.error.visible,tmp0
     77A0 A228     
0255 77A2 130A  14         jeq   pane.action.colorscheme.statline
0256                                                   ; Skip if error line pane is hidden
0257               
0258 77A4 0205  20         li    tmp1,>00f6            ; White on dark red
     77A6 00F6     
0259 77A8 C805  38         mov   tmp1,@parm1           ; Pass color combination
     77AA A000     
0260               
0261 77AC 0205  20         li    tmp1,pane.botrow-1    ;
     77AE 001C     
0262 77B0 C805  38         mov   tmp1,@parm2           ; Error line on screen
     77B2 A002     
0263               
0264 77B4 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77B6 787E     
0265                                                   ; \ i  @parm1 = Color combination
0266                                                   ; / i  @parm2 = Row on physical screen
0267                       ;-------------------------------------------------------
0268                       ; Dump colors for top line and bottom line (TAT)
0269                       ;-------------------------------------------------------
0270               pane.action.colorscheme.statline:
0271 77B8 C160  34         mov   @tv.color,tmp1
     77BA A218     
0272 77BC 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     77BE 00FF     
0273 77C0 C805  38         mov   tmp1,@parm1           ; Set color combination
     77C2 A000     
0274               
0275               
0276 77C4 04E0  34         clr   @parm2                ; Top row on screen
     77C6 A002     
0277 77C8 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77CA 787E     
0278                                                   ; \ i  @parm1 = Color combination
0279                                                   ; / i  @parm2 = Row on physical screen
0280               
0281 77CC 0205  20         li    tmp1,pane.botrow
     77CE 001D     
0282 77D0 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     77D2 A002     
0283 77D4 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77D6 787E     
0284                                                   ; \ i  @parm1 = Color combination
0285                                                   ; / i  @parm2 = Row on physical screen
0286                       ;-------------------------------------------------------
0287                       ; Dump colors for ruler if visible (TAT)
0288                       ;-------------------------------------------------------
0289 77D8 C160  34         mov   @tv.ruler.visible,tmp1
     77DA A210     
0290 77DC 1307  14         jeq   pane.action.colorscheme.cursorcolor
0291               
0292 77DE 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     77E0 7C82     
0293 77E2 06A0  32         bl    @cpym2v
     77E4 2480     
0294 77E6 1850                   data vdp.fb.toprow.tat
0295 77E8 A36E                   data fb.ruler.tat
0296 77EA 0050                   data 80               ; Show ruler colors
0297                       ;-------------------------------------------------------
0298                       ; Dump cursor FG color to sprite table (SAT)
0299                       ;-------------------------------------------------------
0300               pane.action.colorscheme.cursorcolor:
0301 77EC C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     77EE A216     
0302               
0303 77F0 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     77F2 A222     
0304 77F4 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     77F6 0000     
0305 77F8 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0306                                                   ; Yes, set cursor color
0307               
0308               pane.action.colorscheme.cursorcolor.cmdb:
0309 77FA 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     77FC 00F0     
0310 77FE 0A48  56         sla   tmp4,4                ; Move to MSB
0311 7800 1003  14         jmp   !
0312               
0313               pane.action.colorscheme.cursorcolor.fb:
0314 7802 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     7804 000F     
0315 7806 0A88  56         sla   tmp4,8                ; Move to MSB
0316               
0317 7808 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     780A A183     
0318 780C D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     780E A215     
0319                       ;-------------------------------------------------------
0320                       ; Exit
0321                       ;-------------------------------------------------------
0322               pane.action.colorscheme.load.exit:
0323 7810 06A0  32         bl    @scron                ; Turn screen on
     7812 2690     
0324 7814 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7816 A000     
0325 7818 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0326 781A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0327 781C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0328 781E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0329 7820 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0330 7822 C2F9  30         mov   *stack+,r11           ; Pop R11
0331 7824 045B  20         b     *r11                  ; Return to caller
0332               
0333               
0334               
0335               ***************************************************************
0336               * pane.action.colorscheme.statline
0337               * Set color combination for bottom status line
0338               ***************************************************************
0339               * bl @pane.action.colorscheme.statlines
0340               *--------------------------------------------------------------
0341               * INPUT
0342               * @parm1 = Color combination to set
0343               *--------------------------------------------------------------
0344               * OUTPUT
0345               * none
0346               *--------------------------------------------------------------
0347               * Register usage
0348               * tmp0, tmp1, tmp2
0349               ********|*****|*********************|**************************
0350               pane.action.colorscheme.statlines:
0351 7826 0649  14         dect  stack
0352 7828 C64B  30         mov   r11,*stack            ; Save return address
0353 782A 0649  14         dect  stack
0354 782C C644  30         mov   tmp0,*stack           ; Push tmp0
0355                       ;------------------------------------------------------
0356                       ; Bottom line
0357                       ;------------------------------------------------------
0358 782E 0204  20         li    tmp0,pane.botrow
     7830 001D     
0359 7832 C804  38         mov   tmp0,@parm2           ; Last row on screen
     7834 A002     
0360 7836 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7838 787E     
0361                                                   ; \ i  @parm1 = Color combination
0362                                                   ; / i  @parm2 = Row on physical screen
0363                       ;------------------------------------------------------
0364                       ; Exit
0365                       ;------------------------------------------------------
0366               pane.action.colorscheme.statlines.exit:
0367 783A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0368 783C C2F9  30         mov   *stack+,r11           ; Pop R11
0369 783E 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0153                                                      ; Colorscheme handling in panes
0154                       copy  "pane.cursor.asm"        ; Cursor utility functions
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
0020 7840 0649  14         dect  stack
0021 7842 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 7844 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7846 2288     
0026 7848 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     784A 0000     
     784C 0008     
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 784E 06A0  32         bl    @clslot
     7850 2FAA     
0031 7852 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 7854 06A0  32         bl    @clslot
     7856 2FAA     
0034 7858 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 785A C2F9  30         mov   *stack+,r11           ; Pop R11
0040 785C 045B  20         b     *r11                  ; Return to caller
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
0060 785E 0649  14         dect  stack
0061 7860 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 7862 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7864 2288     
0066 7866 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7868 0000     
     786A 0004     
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 786C 06A0  32         bl    @mkslot
     786E 2F8C     
0073 7870 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     7872 7542     
0074 7874 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     7876 75DE     
0075 7878 FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 787A C2F9  30         mov   *stack+,r11           ; Pop R11
0090 787C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0155                       ;-----------------------------------------------------------------------
0156                       ; Screen panes
0157                       ;-----------------------------------------------------------------------
0158                       copy  "colors.line.set.asm"    ; Set color combination for line
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
0021 787E 0649  14         dect  stack
0022 7880 C64B  30         mov   r11,*stack            ; Save return address
0023 7882 0649  14         dect  stack
0024 7884 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7886 0649  14         dect  stack
0026 7888 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 788A 0649  14         dect  stack
0028 788C C646  30         mov   tmp2,*stack           ; Push tmp2
0029 788E 0649  14         dect  stack
0030 7890 C660  46         mov   @parm1,*stack         ; Push parm1
     7892 A000     
0031 7894 0649  14         dect  stack
0032 7896 C660  46         mov   @parm2,*stack         ; Push parm2
     7898 A002     
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 789A C120  34         mov   @parm2,tmp0           ; Get target line
     789C A002     
0037 789E 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     78A0 0050     
0038 78A2 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 78A4 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 78A6 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     78A8 1800     
0042 78AA C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     78AC A000     
0043 78AE 0206  20         li    tmp2,80               ; Number of bytes to fill
     78B0 0050     
0044               
0045 78B2 06A0  32         bl    @xfilv                ; Fill colors
     78B4 228E     
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 78B6 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     78B8 A002     
0054 78BA C839  50         mov   *stack+,@parm1        ; Pop @parm1
     78BC A000     
0055 78BE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 78C0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 78C2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 78C4 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 78C6 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0159                       copy  "pane.topline.asm"       ; Top line
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
0017 78C8 0649  14         dect  stack
0018 78CA C64B  30         mov   r11,*stack            ; Save return address
0019 78CC 0649  14         dect  stack
0020 78CE C644  30         mov   tmp0,*stack           ; Push tmp0
0021 78D0 0649  14         dect  stack
0022 78D2 C660  46         mov   @wyx,*stack           ; Push cursor position
     78D4 832A     
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 78D6 06A0  32         bl    @at
     78D8 26C8     
0028 78DA 0000                   byte 0,0              ; y=0, x=0
0029               
0030 78DC C820  54         mov   @edb.filename.ptr,@parm1
     78DE A512     
     78E0 A000     
0031                                                   ; Get string to display
0032 78E2 0204  20         li    tmp0,47
     78E4 002F     
0033 78E6 C804  38         mov   tmp0,@parm2           ; Set requested length
     78E8 A002     
0034 78EA 0204  20         li    tmp0,32
     78EC 0020     
0035 78EE C804  38         mov   tmp0,@parm3           ; Set character to fill
     78F0 A004     
0036 78F2 0204  20         li    tmp0,rambuf
     78F4 A140     
0037 78F6 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     78F8 A006     
0038               
0039               
0040 78FA 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     78FC 338E     
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 78FE C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7900 A010     
0048 7902 06A0  32         bl    @xutst0               ; /
     7904 241A     
0049                       ;------------------------------------------------------
0050                       ; Show M1 marker
0051                       ;------------------------------------------------------
0052 7906 C120  34         mov   @edb.block.m1,tmp0    ; \
     7908 A50C     
0053 790A 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0054 790C 1326  14         jeq   pane.topline.exit     ; /
0055               
0056 790E 06A0  32         bl    @putat
     7910 243C     
0057 7912 0034                   byte 0,52
0058 7914 35C8                   data txt.m1           ; Show M1 marker message
0059               
0060 7916 C820  54         mov   @edb.block.m1,@parm1
     7918 A50C     
     791A A000     
0061 791C 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     791E 3362     
0062                                                   ; \ i @parm1           = uint16
0063                                                   ; / o @unpacked.string = Output string
0064               
0065 7920 0204  20         li    tmp0,>0500
     7922 0500     
0066 7924 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7926 A026     
0067               
0068 7928 06A0  32         bl    @putat
     792A 243C     
0069 792C 0037                   byte 0,55
0070 792E A026                   data unpacked.string  ; Show M1 value
0071                       ;------------------------------------------------------
0072                       ; Show M2 marker
0073                       ;------------------------------------------------------
0074 7930 C120  34         mov   @edb.block.m2,tmp0    ; \
     7932 A50E     
0075 7934 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0076 7936 1311  14         jeq   pane.topline.exit     ; /
0077               
0078 7938 06A0  32         bl    @putat
     793A 243C     
0079 793C 003E                   byte 0,62
0080 793E 35CC                   data txt.m2           ; Show M2 marker message
0081               
0082 7940 C820  54         mov   @edb.block.m2,@parm1
     7942 A50E     
     7944 A000     
0083 7946 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7948 3362     
0084                                                   ; \ i @parm1           = uint16
0085                                                   ; / o @unpacked.string = Output string
0086               
0087 794A 0204  20         li    tmp0,>0500
     794C 0500     
0088 794E D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7950 A026     
0089               
0090 7952 06A0  32         bl    @putat
     7954 243C     
0091 7956 0041                   byte 0,65
0092 7958 A026                   data unpacked.string  ; Show M2 value
0093                       ;------------------------------------------------------
0094                       ; Exit
0095                       ;------------------------------------------------------
0096               pane.topline.exit:
0097 795A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     795C 832A     
0098 795E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 7960 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 7962 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0160                       copy  "pane.errline.asm"       ; Error line
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
0022 7964 0649  14         dect  stack
0023 7966 C64B  30         mov   r11,*stack            ; Save return address
0024 7968 0649  14         dect  stack
0025 796A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 796C 0649  14         dect  stack
0027 796E C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7970 0205  20         li    tmp1,>00f6            ; White on dark red
     7972 00F6     
0030 7974 C805  38         mov   tmp1,@parm1
     7976 A000     
0031               
0032 7978 0205  20         li    tmp1,pane.botrow-1    ;
     797A 001C     
0033 797C C805  38         mov   tmp1,@parm2           ; Error line on screen
     797E A002     
0034               
0035 7980 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7982 787E     
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7984 0204  20         li    tmp0,tv.error.msg
     7986 A22A     
0043 7988 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     798A A000     
0044               
0045 798C 0204  20         li    tmp0,80
     798E 0050     
0046 7990 C804  38         mov   tmp0,@parm2           ; Set requested length
     7992 A002     
0047               
0048 7994 0204  20         li    tmp0,32
     7996 0020     
0049 7998 C804  38         mov   tmp0,@parm3           ; Set character to fill
     799A A004     
0050               
0051 799C 0204  20         li    tmp0,rambuf
     799E A140     
0052 79A0 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     79A2 A006     
0053               
0054 79A4 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     79A6 338E     
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 79A8 06A0  32         bl    @at
     79AA 26C8     
0064 79AC 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 79AE C160  34         mov   @outparm1,tmp1        ; \ Display error message
     79B0 A010     
0067 79B2 06A0  32         bl    @xutst0               ; /
     79B4 241A     
0068               
0069 79B6 C120  34         mov   @fb.scrrows.max,tmp0
     79B8 A31C     
0070 79BA 0604  14         dec   tmp0
0071 79BC C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     79BE A31A     
0072               
0073 79C0 0720  34         seto  @tv.error.visible     ; Error line is visible
     79C2 A228     
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 79C4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 79C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 79C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 79CA 045B  20         b     *r11                  ; Return to caller
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
0103 79CC 0649  14         dect  stack
0104 79CE C64B  30         mov   r11,*stack            ; Save return address
0105 79D0 0649  14         dect  stack
0106 79D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 79D4 06A0  32         bl    @errline.init         ; Clear error line
     79D6 32F6     
0111               
0112 79D8 C120  34         mov   @tv.color,tmp0        ; Get colors
     79DA A218     
0113 79DC 0984  56         srl   tmp0,8                ; Right aligns
0114 79DE C804  38         mov   tmp0,@parm1           ; set foreground/background color
     79E0 A000     
0115               
0116               
0117 79E2 0205  20         li    tmp1,pane.botrow-1    ;
     79E4 001C     
0118 79E6 C805  38         mov   tmp1,@parm2           ; Error line on screen
     79E8 A002     
0119               
0120 79EA 06A0  32         bl    @colors.line.set      ; Load color combination for line
     79EC 787E     
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 79EE 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     79F0 A228     
0125 79F2 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     79F4 A31C     
     79F6 A31A     
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 79F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 79FA C2F9  30         mov   *stack+,r11           ; Pop r11
0133 79FC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0161                       copy  "pane.botline.asm"       ; Bottom line
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
0017 79FE 0649  14         dect  stack
0018 7A00 C64B  30         mov   r11,*stack            ; Save return address
0019 7A02 0649  14         dect  stack
0020 7A04 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7A06 0649  14         dect  stack
0022 7A08 C660  46         mov   @wyx,*stack           ; Push cursor position
     7A0A 832A     
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 7A0C C120  34         mov   @edb.block.m2,tmp0    ; \
     7A0E A50E     
0027 7A10 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 7A12 1305  14         jeq   pane.botline.show_keys
0030               
0031 7A14 06A0  32         bl    @putat
     7A16 243C     
0032 7A18 1D00                   byte pane.botrow,0
0033 7A1A 35D8                   data txt.keys.block   ; Show block shortcuts
0034               
0035 7A1C 1004  14         jmp   pane.botline.show_dirty
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 7A1E 06A0  32         bl    @putat
     7A20 243C     
0041 7A22 1D00                   byte pane.botrow,0
0042 7A24 35D0                   data txt.keys.default ; Show default shortcuts
0043                       ;------------------------------------------------------
0044                       ; Show if text was changed in editor buffer
0045                       ;------------------------------------------------------
0046               pane.botline.show_dirty:
0047 7A26 C120  34         mov   @edb.dirty,tmp0
     7A28 A506     
0048 7A2A 1305  14         jeq   pane.botline.nochange
0049                       ;------------------------------------------------------
0050                       ; Show "*"
0051                       ;------------------------------------------------------
0052 7A2C 06A0  32         bl    @putat
     7A2E 243C     
0053 7A30 1D35                   byte pane.botrow,53   ; x=53
0054 7A32 3532                   data txt.star
0055 7A34 1004  14         jmp   pane.botline.show_mode
0056                       ;------------------------------------------------------
0057                       ; Show " "
0058                       ;------------------------------------------------------
0059               pane.botline.nochange:
0060 7A36 06A0  32         bl    @putat
     7A38 243C     
0061 7A3A 1D35                   byte pane.botrow,53   ; x=53
0062 7A3C 365E                   data txt.ws1          ; Single white space
0063                       ;------------------------------------------------------
0064                       ; Show text editing mode
0065                       ;------------------------------------------------------
0066               pane.botline.show_mode:
0067 7A3E C120  34         mov   @edb.insmode,tmp0
     7A40 A50A     
0068 7A42 1605  14         jne   pane.botline.show_mode.insert
0069                       ;------------------------------------------------------
0070                       ; Overwrite mode
0071                       ;------------------------------------------------------
0072 7A44 06A0  32         bl    @putat
     7A46 243C     
0073 7A48 1D37                   byte  pane.botrow,55
0074 7A4A 352A                   data  txt.ovrwrite
0075 7A4C 1004  14         jmp   pane.botline.show_linecol
0076                       ;------------------------------------------------------
0077                       ; Insert mode
0078                       ;------------------------------------------------------
0079               pane.botline.show_mode.insert:
0080 7A4E 06A0  32         bl    @putat
     7A50 243C     
0081 7A52 1D37                   byte  pane.botrow,55
0082 7A54 352E                   data  txt.insert
0083                       ;------------------------------------------------------
0084                       ; Show "line,column"
0085                       ;------------------------------------------------------
0086               pane.botline.show_linecol:
0087 7A56 C820  54         mov   @fb.row,@parm1
     7A58 A306     
     7A5A A000     
0088 7A5C 06A0  32         bl    @fb.row2line          ; Row to editor line
     7A5E 697A     
0089                                                   ; \ i @fb.topline = Top line in frame buffer
0090                                                   ; | i @parm1      = Row in frame buffer
0091                                                   ; / o @outparm1   = Matching line in EB
0092               
0093 7A60 05A0  34         inc   @outparm1             ; Add base 1
     7A62 A010     
0094                       ;------------------------------------------------------
0095                       ; Show line
0096                       ;------------------------------------------------------
0097 7A64 06A0  32         bl    @putnum
     7A66 2B0E     
0098 7A68 1D3B                   byte  pane.botrow,59  ; YX
0099 7A6A A010                   data  outparm1,rambuf
     7A6C A140     
0100 7A6E 30                     byte  48              ; ASCII offset
0101 7A6F   20                   byte  32              ; Padding character
0102                       ;------------------------------------------------------
0103                       ; Show comma
0104                       ;------------------------------------------------------
0105 7A70 06A0  32         bl    @putat
     7A72 243C     
0106 7A74 1D40                   byte  pane.botrow,64
0107 7A76 3522                   data  txt.delim
0108                       ;------------------------------------------------------
0109                       ; Show column
0110                       ;------------------------------------------------------
0111 7A78 06A0  32         bl    @film
     7A7A 2230     
0112 7A7C A145                   data rambuf+5,32,12   ; Clear work buffer with space character
     7A7E 0020     
     7A80 000C     
0113               
0114 7A82 C820  54         mov   @fb.column,@waux1
     7A84 A30C     
     7A86 833C     
0115 7A88 05A0  34         inc   @waux1                ; Offset 1
     7A8A 833C     
0116               
0117 7A8C 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7A8E 2A90     
0118 7A90 833C                   data  waux1,rambuf
     7A92 A140     
0119 7A94 30                     byte  48              ; ASCII offset
0120 7A95   20                   byte  32              ; Fill character
0121               
0122 7A96 06A0  32         bl    @trimnum              ; Trim number to the left
     7A98 2AE8     
0123 7A9A A140                   data  rambuf,rambuf+5,32
     7A9C A145     
     7A9E 0020     
0124               
0125 7AA0 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7AA2 0600     
0126 7AA4 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7AA6 A145     
0127               
0128                       ;------------------------------------------------------
0129                       ; Decide if row length is to be shown
0130                       ;------------------------------------------------------
0131 7AA8 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7AAA A30C     
0132 7AAC 0584  14         inc   tmp0                  ; /
0133 7AAE 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7AB0 A308     
0134 7AB2 1101  14         jlt   pane.botline.show_linecol.linelen
0135 7AB4 102B  14         jmp   pane.botline.show_linecol.colstring
0136                                                   ; Yes, skip showing row length
0137                       ;------------------------------------------------------
0138                       ; Add ',' delimiter and length of line to string
0139                       ;------------------------------------------------------
0140               pane.botline.show_linecol.linelen:
0141 7AB6 C120  34         mov   @fb.column,tmp0       ; \
     7AB8 A30C     
0142 7ABA 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7ABC A147     
0143 7ABE 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7AC0 0009     
0144 7AC2 1101  14         jlt   !                     ; | column.
0145 7AC4 0585  14         inc   tmp1                  ; /
0146               
0147 7AC6 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7AC8 2D00     
0148 7ACA DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0149               
0150 7ACC C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7ACE 833C     
0151               
0152 7AD0 06A0  32         bl    @mknum
     7AD2 2A90     
0153 7AD4 A308                   data  fb.row.length,rambuf
     7AD6 A140     
0154 7AD8 30                     byte  48              ; ASCII offset
0155 7AD9   20                   byte  32              ; Padding character
0156               
0157 7ADA C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7ADC 833C     
0158               
0159 7ADE C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7AE0 A308     
0160 7AE2 0284  22         ci    tmp0,10               ; /
     7AE4 000A     
0161 7AE6 110B  14         jlt   pane.botline.show_line.1digit
0162                       ;------------------------------------------------------
0163                       ; Assert
0164                       ;------------------------------------------------------
0165 7AE8 0284  22         ci    tmp0,80
     7AEA 0050     
0166 7AEC 1204  14         jle   pane.botline.show_line.2digits
0167                       ;------------------------------------------------------
0168                       ; Asserts failed
0169                       ;------------------------------------------------------
0170 7AEE C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7AF0 FFCE     
0171 7AF2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7AF4 2026     
0172                       ;------------------------------------------------------
0173                       ; Show length of line (2 digits)
0174                       ;------------------------------------------------------
0175               pane.botline.show_line.2digits:
0176 7AF6 0204  20         li    tmp0,rambuf+3
     7AF8 A143     
0177 7AFA DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0178 7AFC 1002  14         jmp   pane.botline.show_line.rest
0179                       ;------------------------------------------------------
0180                       ; Show length of line (1 digits)
0181                       ;------------------------------------------------------
0182               pane.botline.show_line.1digit:
0183 7AFE 0204  20         li    tmp0,rambuf+4
     7B00 A144     
0184               pane.botline.show_line.rest:
0185 7B02 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0186 7B04 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7B06 A140     
0187 7B08 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7B0A A140     
0188                       ;------------------------------------------------------
0189                       ; Show column string
0190                       ;------------------------------------------------------
0191               pane.botline.show_linecol.colstring:
0192 7B0C 06A0  32         bl    @putat
     7B0E 243C     
0193 7B10 1D41                   byte pane.botrow,65
0194 7B12 A145                   data rambuf+5         ; Show string
0195                       ;------------------------------------------------------
0196                       ; Show lines in buffer unless on last line in file
0197                       ;------------------------------------------------------
0198 7B14 C820  54         mov   @fb.row,@parm1
     7B16 A306     
     7B18 A000     
0199 7B1A 06A0  32         bl    @fb.row2line
     7B1C 697A     
0200 7B1E 8820  54         c     @edb.lines,@outparm1
     7B20 A504     
     7B22 A010     
0201 7B24 1605  14         jne   pane.botline.show_lines_in_buffer
0202               
0203 7B26 06A0  32         bl    @putat
     7B28 243C     
0204 7B2A 1D48                   byte pane.botrow,72
0205 7B2C 3524                   data txt.bottom
0206               
0207 7B2E 1009  14         jmp   pane.botline.exit
0208                       ;------------------------------------------------------
0209                       ; Show lines in buffer
0210                       ;------------------------------------------------------
0211               pane.botline.show_lines_in_buffer:
0212 7B30 C820  54         mov   @edb.lines,@waux1
     7B32 A504     
     7B34 833C     
0213               
0214 7B36 06A0  32         bl    @putnum
     7B38 2B0E     
0215 7B3A 1D48                   byte pane.botrow,72   ; YX
0216 7B3C 833C                   data waux1,rambuf
     7B3E A140     
0217 7B40 30                     byte 48
0218 7B41   20                   byte 32
0219                       ;------------------------------------------------------
0220                       ; Exit
0221                       ;------------------------------------------------------
0222               pane.botline.exit:
0223 7B42 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7B44 832A     
0224 7B46 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0225 7B48 C2F9  30         mov   *stack+,r11           ; Pop r11
0226 7B4A 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.37021
0162                       ;-----------------------------------------------------------------------
0163                       ; Stubs
0164                       ;-----------------------------------------------------------------------
0165                       copy  "rom.stubs.bank1.asm"    ; Stubs for functions in other banks
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
0010 7B4C 0649  14         dect  stack
0011 7B4E C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7B50 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B52 308A     
0016 7B54 600A                   data bank5.rom        ; | i  p0 = bank address
0017 7B56 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0018 7B58 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7B5A C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7B5C 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7B5E 0649  14         dect  stack
0032 7B60 C64B  30         mov   r11,*stack            ; Save return address
0033 7B62 0649  14         dect  stack
0034 7B64 C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7B66 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B68 308A     
0039 7B6A 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7B6C 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0041 7B6E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7B70 C120  34         mov   @outparm1,tmp0
     7B72 A010     
0046 7B74 1304  14         jeq   fm.loadfile.exit
0047               
0048 7B76 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7B78 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7B7A 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7B7C 7BCC     
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7B7E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7B80 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7B82 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.savefile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.savefile:
0065 7B84 0649  14         dect  stack
0066 7B86 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Call function in bank 2
0069                       ;------------------------------------------------------
0070 7B88 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B8A 308A     
0071 7B8C 6004                   data bank2.rom        ; | i  p0 = bank address
0072 7B8E 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0073 7B90 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077 7B92 C2F9  30         mov   *stack+,r11           ; Pop r11
0078 7B94 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               **************************************************************
0082               * Stub for "fm.browse.fname.suffix"
0083               * bank2 vec.3
0084               ********|*****|*********************|**************************
0085               fm.browse.fname.suffix:
0086 7B96 0649  14         dect  stack
0087 7B98 C64B  30         mov   r11,*stack            ; Save return address
0088                       ;------------------------------------------------------
0089                       ; Call function in bank 2
0090                       ;------------------------------------------------------
0091 7B9A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B9C 308A     
0092 7B9E 6004                   data bank2.rom        ; | i  p0 = bank address
0093 7BA0 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0094 7BA2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098 7BA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7BA6 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * Stub for dialog "About"
0107               * bank3 vec.1
0108               ********|*****|*********************|**************************
0109               edkey.action.about:
0110 7BA8 C820  54         mov   @edkey.action.about.vector,@parm1
     7BAA 7BB2     
     7BAC A000     
0111 7BAE 0460  28         b     @_trampoline.bank3    ; Show dialog
     7BB0 7CB8     
0112               edkey.action.about.vector:
0113 7BB2 7FC0             data  vec.1
0114               
0115               
0116               ***************************************************************
0117               * Stub for dialog "Load DV80 file"
0118               * bank3 vec.2
0119               ********|*****|*********************|**************************
0120               dialog.load:
0121 7BB4 C820  54         mov   @dialog.load.vector,@parm1
     7BB6 7BBE     
     7BB8 A000     
0122 7BBA 0460  28         b     @_trampoline.bank3    ; Show dialog
     7BBC 7CB8     
0123               dialog.load.vector:
0124 7BBE 7FC2             data  vec.2
0125               
0126               
0127               ***************************************************************
0128               * Stub for dialog "Save DV80 file"
0129               * bank3 vec.3
0130               ********|*****|*********************|**************************
0131               dialog.save:
0132 7BC0 C820  54         mov   @dialog.save.vector,@parm1
     7BC2 7BCA     
     7BC4 A000     
0133 7BC6 0460  28         b     @_trampoline.bank3    ; Show dialog
     7BC8 7CB8     
0134               dialog.save.vector:
0135 7BCA 7FC4             data  vec.3
0136               
0137               
0138               ***************************************************************
0139               * Stub for dialog "Unsaved Changes"
0140               * bank3 vec.4
0141               ********|*****|*********************|**************************
0142               dialog.unsaved:
0143 7BCC 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7BCE A722     
0144 7BD0 C820  54         mov   @dialog.unsaved.vector,@parm1
     7BD2 7BD8     
     7BD4 A000     
0145 7BD6 1070  14         jmp   _trampoline.bank3     ; Show dialog
0146               dialog.unsaved.vector:
0147 7BD8 7FC6             data  vec.4
0148               
0149               
0150               ***************************************************************
0151               * Stub for dialog "File"
0152               * bank3 vec.5
0153               ********|*****|*********************|**************************
0154               dialog.file:
0155 7BDA C820  54         mov   @dialog.file.vector,@parm1
     7BDC 7BE2     
     7BDE A000     
0156 7BE0 106B  14         jmp   _trampoline.bank3     ; Show dialog
0157               dialog.file.vector:
0158 7BE2 7FC8             data  vec.5
0159               
0160               
0161               ***************************************************************
0162               * Stub for dialog "Stevie Menu"
0163               * bank3 vec.6
0164               ********|*****|*********************|**************************
0165               dialog.menu:
0166                       ;------------------------------------------------------
0167                       ; Check if block mode is active
0168                       ;------------------------------------------------------
0169 7BE4 C120  34         mov   @edb.block.m2,tmp0    ; \
     7BE6 A50E     
0170 7BE8 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0171                                                   ; /
0172 7BEA 1302  14         jeq   !                     : Block mode inactive, show dialog
0173                       ;------------------------------------------------------
0174                       ; Special treatment for block mode
0175                       ;------------------------------------------------------
0176 7BEC 0460  28         b     @edkey.action.block.reset
     7BEE 66DE     
0177                                                   ; Reset block mode
0178                       ;------------------------------------------------------
0179                       ; Show dialog
0180                       ;------------------------------------------------------
0181 7BF0 C820  54 !       mov   @dialog.menu.vector,@parm1
     7BF2 7BF8     
     7BF4 A000     
0182 7BF6 1060  14         jmp   _trampoline.bank3     ; Show dialog
0183               dialog.menu.vector:
0184 7BF8 7FCA             data  vec.6
0185               
0186               
0187               ***************************************************************
0188               * Stub for dialog "Basic"
0189               * bank3 vec.7
0190               ********|*****|*********************|**************************
0191               dialog.basic:
0192 7BFA C820  54         mov   @dialog.basic.vector,@parm1
     7BFC 7C02     
     7BFE A000     
0193 7C00 105B  14         jmp   _trampoline.bank3     ; Show dialog
0194               dialog.basic.vector:
0195 7C02 7FCC             data  vec.7
0196               
0197               
0198               
0199               ***************************************************************
0200               * Stub for "tibasic"
0201               * bank3 vec.10
0202               ********|*****|*********************|**************************
0203               tibasic:
0204 7C04 0649  14         dect  stack
0205 7C06 C64B  30         mov   r11,*stack            ; Save return address
0206                       ;------------------------------------------------------
0207                       ; Call function in bank 3
0208                       ;------------------------------------------------------
0209 7C08 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C0A 308A     
0210 7C0C 6006                   data bank3.rom        ; | i  p0 = bank address
0211 7C0E 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0212 7C10 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0213                       ;------------------------------------------------------
0214                       ; Exit
0215                       ;------------------------------------------------------
0216 7C12 C2F9  30         mov   *stack+,r11           ; Pop r11
0217 7C14 045B  20         b     *r11                  ; Return to caller
0218               
0219               
0220               
0221               ***************************************************************
0222               * Stub for "pane.show_hint"
0223               * bank3 vec.18
0224               ********|*****|*********************|**************************
0225               pane.show_hint:
0226 7C16 C820  54         mov   @pane.show_hint,@parm1
     7C18 7C16     
     7C1A A000     
0227 7C1C 1056  14         jmp   _trampoline.bank3.ret ; Longjump
0228               pane.show_hint.vector:
0229 7C1E 7FE2             data  vec.18
0230               
0231               
0232               ***************************************************************
0233               * Stub for "pane.cmdb.show"
0234               * bank3 vec.20
0235               ********|*****|*********************|**************************
0236               pane.cmdb.show:
0237 7C20 C820  54         mov   @pane.cmdb.show.vector,@parm1
     7C22 7C28     
     7C24 A000     
0238 7C26 1051  14         jmp   _trampoline.bank3.ret ; Longjump
0239               pane.cmdb.show.vector:
0240 7C28 7FE6             data  vec.20
0241               
0242               
0243               ***************************************************************
0244               * Stub for "pane.cmdb.hide"
0245               * bank3 vec.21
0246               ********|*****|*********************|**************************
0247               pane.cmdb.hide:
0248 7C2A C820  54         mov   @pane.cmdb.hide.vector,@parm1
     7C2C 7C32     
     7C2E A000     
0249 7C30 104C  14         jmp   _trampoline.bank3.ret ; Longjump
0250               pane.cmdb.hide.vector:
0251 7C32 7FE8             data  vec.21
0252               
0253               
0254               ***************************************************************
0255               * Stub for "pane.cmdb.draw"
0256               * bank3 vec.22
0257               ********|*****|*********************|**************************
0258               pane.cmdb.draw:
0259 7C34 C820  54         mov   @pane.cmdb.draw.vector,@parm1
     7C36 7C3C     
     7C38 A000     
0260 7C3A 1047  14         jmp   _trampoline.bank3.ret ; Longjump
0261               pane.cmdb.draw.vector:
0262 7C3C 7FEA             data  vec.22
0263               
0264               
0265               ***************************************************************
0266               * Stub for "cmdb.refresh"
0267               * bank3 vec.24
0268               ********|*****|*********************|**************************
0269               cmdb.refresh:
0270 7C3E C820  54         mov   @cmdb.refresh.vector,@parm1
     7C40 7C46     
     7C42 A000     
0271 7C44 1042  14         jmp   _trampoline.bank3.ret ; Longjump
0272               cmdb.refresh.vector:
0273 7C46 7FEE             data  vec.24
0274               
0275               
0276               ***************************************************************
0277               * Stub for "cmdb.cmd.clear"
0278               * bank3 vec.25
0279               ********|*****|*********************|**************************
0280               cmdb.cmd.clear:
0281 7C48 C820  54         mov   @cmdb.cmd.clear.vector,@parm1
     7C4A 7C50     
     7C4C A000     
0282 7C4E 103D  14         jmp   _trampoline.bank3.ret ; Longjump
0283               cmdb.cmd.clear.vector:
0284 7C50 7FF0             data  vec.25
0285               
0286               
0287               ***************************************************************
0288               * Stub for "cmdb.cmdb.getlength"
0289               * bank3 vec.26
0290               ********|*****|*********************|**************************
0291               cmdb.cmd.getlength:
0292 7C52 C820  54         mov   @cmdb.cmd.getlength.vector,@parm1
     7C54 7C5A     
     7C56 A000     
0293 7C58 1038  14         jmp   _trampoline.bank3.ret ; Longjump
0294               cmdb.cmd.getlength.vector:
0295 7C5A 7FF2             data  vec.26
0296               
0297               
0298               ***************************************************************
0299               * Stub for "cmdb.cmdb.addhist"
0300               * bank3 vec.27
0301               ********|*****|*********************|**************************
0302               cmdb.cmd.addhist:
0303 7C5C C820  54         mov   @cmdb.cmd.addhist.vector,@parm1
     7C5E 7C64     
     7C60 A000     
0304 7C62 1033  14         jmp   _trampoline.bank3.ret ; Longjump
0305               cmdb.cmd.addhist.vector:
0306 7C64 7FF4             data  vec.27
0307               
0308               
0309               **************************************************************
0310               * Stub for "fm.fastmode"
0311               * bank3 vec.32
0312               ********|*****|*********************|**************************
0313               fm.fastmode:
0314 7C66 C820  54         mov   @fm.fastmode.vector,@parm1
     7C68 7C6E     
     7C6A A000     
0315 7C6C 102E  14         jmp   _trampoline.bank3.ret ; Longjump
0316               fm.fastmode.vector:
0317 7C6E 7FFE             data  vec.32
0318               
0319               
0320               ***************************************************************
0321               * Stub for "fb.tab.next"
0322               * bank4 vec.1
0323               ********|*****|*********************|**************************
0324               fb.tab.next:
0325 7C70 0649  14         dect  stack
0326 7C72 C64B  30         mov   r11,*stack            ; Save return address
0327                       ;------------------------------------------------------
0328                       ; Put cursor on next tab position
0329                       ;------------------------------------------------------
0330 7C74 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C76 308A     
0331 7C78 6008                   data bank4.rom        ; | i  p0 = bank address
0332 7C7A 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0333 7C7C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337 7C7E C2F9  30         mov   *stack+,r11           ; Pop r11
0338 7C80 045B  20         b     *r11                  ; Return to caller
0339               
0340               
0341               ***************************************************************
0342               * Stub for "fb.ruler.init"
0343               * bank4 vec.2
0344               ********|*****|*********************|**************************
0345               fb.ruler.init:
0346 7C82 0649  14         dect  stack
0347 7C84 C64B  30         mov   r11,*stack            ; Save return address
0348                       ;------------------------------------------------------
0349                       ; Setup ruler in memory
0350                       ;------------------------------------------------------
0351 7C86 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C88 308A     
0352 7C8A 6008                   data bank4.rom        ; | i  p0 = bank address
0353 7C8C 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0354 7C8E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0355                       ;------------------------------------------------------
0356                       ; Exit
0357                       ;------------------------------------------------------
0358 7C90 C2F9  30         mov   *stack+,r11           ; Pop r11
0359 7C92 045B  20         b     *r11                  ; Return to caller
0360               
0361               
0362               ***************************************************************
0363               * Stub for "fb.colorlines"
0364               * bank4 vec.3
0365               ********|*****|*********************|**************************
0366               fb.colorlines:
0367 7C94 0649  14         dect  stack
0368 7C96 C64B  30         mov   r11,*stack            ; Save return address
0369                       ;------------------------------------------------------
0370                       ; Colorize frame buffer content
0371                       ;------------------------------------------------------
0372 7C98 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C9A 308A     
0373 7C9C 6008                   data bank4.rom        ; | i  p0 = bank address
0374 7C9E 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0375 7CA0 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0376                       ;------------------------------------------------------
0377                       ; Exit
0378                       ;------------------------------------------------------
0379 7CA2 C2F9  30         mov   *stack+,r11           ; Pop r11
0380 7CA4 045B  20         b     *r11                  ; Return to caller
0381               
0382               
0383               ***************************************************************
0384               * Stub for "fb.vdpdump"
0385               * bank4 vec.4
0386               ********|*****|*********************|**************************
0387               fb.vdpdump:
0388 7CA6 0649  14         dect  stack
0389 7CA8 C64B  30         mov   r11,*stack            ; Save return address
0390                       ;------------------------------------------------------
0391                       ; Colorize frame buffer content
0392                       ;------------------------------------------------------
0393 7CAA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CAC 308A     
0394 7CAE 6008                   data bank4.rom        ; | i  p0 = bank address
0395 7CB0 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0396 7CB2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0397                       ;------------------------------------------------------
0398                       ; Exit
0399                       ;------------------------------------------------------
0400 7CB4 C2F9  30         mov   *stack+,r11           ; Pop r11
0401 7CB6 045B  20         b     *r11                  ; Return to caller
0402               
0403               
0404               ***************************************************************
0405               * Trampoline 1 (bank 3, dialog)
0406               ********|*****|*********************|**************************
0407               _trampoline.bank3:
0408 7CB8 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7CBA 7840     
0409                       ;------------------------------------------------------
0410                       ; Call routine in specified bank
0411                       ;------------------------------------------------------
0412 7CBC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CBE 308A     
0413 7CC0 6006                   data bank3.rom        ; | i  p0 = bank address
0414 7CC2 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0415                                                   ; |         (deref @parm1)
0416 7CC4 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0417                       ;------------------------------------------------------
0418                       ; Exit
0419                       ;------------------------------------------------------
0420 7CC6 0460  28         b     @edkey.action.cmdb.show
     7CC8 684A     
0421                                                   ; Show dialog in CMDB pane
0422               
0423               
0424               ***************************************************************
0425               * Trampoline 2 (bank 3 with return)
0426               ********|*****|*********************|**************************
0427               _trampoline.bank3.ret:
0428 7CCA 0649  14         dect  stack
0429 7CCC C64B  30         mov   r11,*stack            ; Save return address
0430                       ;------------------------------------------------------
0431                       ; Call routine in specified bank
0432                       ;------------------------------------------------------
0433 7CCE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7CD0 308A     
0434 7CD2 6006                   data bank3.rom        ; | i  p0 = bank address
0435 7CD4 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0436                                                   ; |         (deref @parm1)
0437 7CD6 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0438                       ;------------------------------------------------------
0439                       ; Exit
0440                       ;------------------------------------------------------
0441 7CD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0442 7CDA 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.37021
0166                       ;-----------------------------------------------------------------------
0167                       ; Program data
0168                       ;-----------------------------------------------------------------------
0169                       copy  "data.keymap.actions.asm"; Data segment - Keyboard actions
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
0011 7CDC 0D00             byte  key.enter, pane.focus.fb
0012 7CDE 656A             data  edkey.action.enter
0013               
0014 7CE0 0800             byte  key.fctn.s, pane.focus.fb
0015 7CE2 6192             data  edkey.action.left
0016               
0017 7CE4 0900             byte  key.fctn.d, pane.focus.fb
0018 7CE6 61AC             data  edkey.action.right
0019               
0020 7CE8 0B00             byte  key.fctn.e, pane.focus.fb
0021 7CEA 62A4             data  edkey.action.up
0022               
0023 7CEC 0A00             byte  key.fctn.x, pane.focus.fb
0024 7CEE 62AC             data  edkey.action.down
0025               
0026 7CF0 BF00             byte  key.fctn.h, pane.focus.fb
0027 7CF2 61C8             data  edkey.action.home
0028               
0029 7CF4 C000             byte  key.fctn.j, pane.focus.fb
0030 7CF6 61F2             data  edkey.action.pword
0031               
0032 7CF8 C100             byte  key.fctn.k, pane.focus.fb
0033 7CFA 6244             data  edkey.action.nword
0034               
0035 7CFC C200             byte  key.fctn.l, pane.focus.fb
0036 7CFE 61D0             data  edkey.action.end
0037               
0038 7D00 0C00             byte  key.fctn.6, pane.focus.fb
0039 7D02 62B4             data  edkey.action.ppage
0040               
0041 7D04 0200             byte  key.fctn.4, pane.focus.fb
0042 7D06 62F0             data  edkey.action.npage
0043               
0044 7D08 8500             byte  key.ctrl.e, pane.focus.fb
0045 7D0A 62B4             data  edkey.action.ppage
0046               
0047 7D0C 9800             byte  key.ctrl.x, pane.focus.fb
0048 7D0E 62F0             data  edkey.action.npage
0049               
0050 7D10 9400             byte  key.ctrl.t, pane.focus.fb
0051 7D12 632A             data  edkey.action.top
0052               
0053 7D14 8200             byte  key.ctrl.b, pane.focus.fb
0054 7D16 6346             data  edkey.action.bot
0055                       ;-------------------------------------------------------
0056                       ; Modifier keys - Delete
0057                       ;-------------------------------------------------------
0058 7D18 0300             byte  key.fctn.1, pane.focus.fb
0059 7D1A 63B8             data  edkey.action.del_char
0060               
0061 7D1C 0700             byte  key.fctn.3, pane.focus.fb
0062 7D1E 646A             data  edkey.action.del_line
0063               
0064 7D20 0200             byte  key.fctn.4, pane.focus.fb
0065 7D22 6436             data  edkey.action.del_eol
0066                       ;-------------------------------------------------------
0067                       ; Modifier keys - Insert
0068                       ;-------------------------------------------------------
0069 7D24 0400             byte  key.fctn.2, pane.focus.fb
0070 7D26 64CC             data  edkey.action.ins_char.ws
0071               
0072 7D28 B900             byte  key.fctn.dot, pane.focus.fb
0073 7D2A 65E2             data  edkey.action.ins_onoff
0074               
0075 7D2C 0100             byte  key.fctn.7, pane.focus.fb
0076 7D2E 679C             data  edkey.action.fb.tab.next
0077               
0078 7D30 0600             byte  key.fctn.8, pane.focus.fb
0079 7D32 6562             data  edkey.action.ins_line
0080                       ;-------------------------------------------------------
0081                       ; Block marking/modifier
0082                       ;-------------------------------------------------------
0083 7D34 9600             byte  key.ctrl.v, pane.focus.fb
0084 7D36 66D6             data  edkey.action.block.mark
0085               
0086 7D38 8300             byte  key.ctrl.c, pane.focus.fb
0087 7D3A 66EA             data  edkey.action.block.copy
0088               
0089 7D3C 8400             byte  key.ctrl.d, pane.focus.fb
0090 7D3E 6726             data  edkey.action.block.delete
0091               
0092 7D40 8D00             byte  key.ctrl.m, pane.focus.fb
0093 7D42 6750             data  edkey.action.block.move
0094               
0095 7D44 8700             byte  key.ctrl.g, pane.focus.fb
0096 7D46 6782             data  edkey.action.block.goto.m1
0097                       ;-------------------------------------------------------
0098                       ; Other action keys
0099                       ;-------------------------------------------------------
0100 7D48 0500             byte  key.fctn.plus, pane.focus.fb
0101 7D4A 665C             data  edkey.action.quit
0102               
0103 7D4C 9100             byte  key.ctrl.q, pane.focus.fb
0104 7D4E 665C             data  edkey.action.quit
0105               
0106 7D50 9500             byte  key.ctrl.u, pane.focus.fb
0107 7D52 666A             data  edkey.action.toggle.ruler
0108               
0109 7D54 9A00             byte  key.ctrl.z, pane.focus.fb
0110 7D56 7638             data  pane.action.colorscheme.cycle
0111               
0112 7D58 8000             byte  key.ctrl.comma, pane.focus.fb
0113 7D5A 6690             data  edkey.action.fb.fname.dec.load
0114               
0115 7D5C 9B00             byte  key.ctrl.dot, pane.focus.fb
0116 7D5E 669C             data  edkey.action.fb.fname.inc.load
0117               
0118 7D60 BB00             byte  key.ctrl.slash, pane.focus.fb
0119 7D62 7C04             data  tibasic
0120                       ;-------------------------------------------------------
0121                       ; Dialog keys
0122                       ;-------------------------------------------------------
0123 7D64 8800             byte  key.ctrl.h, pane.focus.fb
0124 7D66 7BA8             data  edkey.action.about
0125               
0126 7D68 8600             byte  key.ctrl.f, pane.focus.fb
0127 7D6A 7BDA             data  dialog.file
0128               
0129 7D6C 9300             byte  key.ctrl.s, pane.focus.fb
0130 7D6E 7BC0             data  dialog.save
0131               
0132 7D70 8F00             byte  key.ctrl.o, pane.focus.fb
0133 7D72 7BB4             data  dialog.load
0134               
0135                       ;
0136                       ; FCTN-9 has multipe purposes, if block mode is on it
0137                       ; resets the block, otherwise show Stevie menu dialog.
0138                       ;
0139 7D74 0F00             byte  key.fctn.9, pane.focus.fb
0140 7D76 7BE4             data  dialog.menu
0141                       ;-------------------------------------------------------
0142                       ; End of list
0143                       ;-------------------------------------------------------
0144 7D78 FFFF             data  EOL                           ; EOL
0145               
0146               
0147               
0148               *---------------------------------------------------------------
0149               * Action keys mapping table: Command Buffer (CMDB)
0150               *---------------------------------------------------------------
0151               keymap_actions.cmdb:
0152                       ;-------------------------------------------------------
0153                       ; Dialog: Stevie Menu
0154                       ;-------------------------------------------------------
0155 7D7A 4664             byte  key.uc.f, id.dialog.menu
0156 7D7C 7BDA             data  dialog.file
0157               
0158 7D7E 4264             byte  key.uc.b, id.dialog.menu
0159 7D80 7C04             data  tibasic
0160               
0161 7D82 4864             byte  key.uc.h, id.dialog.menu
0162 7D84 7BA8             data  edkey.action.about
0163               
0164 7D86 5164             byte  key.uc.q, id.dialog.menu
0165 7D88 665C             data  edkey.action.quit
0166                       ;-------------------------------------------------------
0167                       ; Dialog: File
0168                       ;-------------------------------------------------------
0169 7D8A 4E68             byte  key.uc.n, id.dialog.file
0170 7D8C 685C             data  edkey.action.cmdb.file.new
0171               
0172 7D8E 5368             byte  key.uc.s, id.dialog.file
0173 7D90 7BC0             data  dialog.save
0174               
0175 7D92 4F68             byte  key.uc.o, id.dialog.file
0176 7D94 7BB4             data  dialog.load
0177                       ;-------------------------------------------------------
0178                       ; Dialog: Open DV80 file
0179                       ;-------------------------------------------------------
0180 7D96 0E0A             byte  key.fctn.5, id.dialog.load
0181 7D98 694E             data  edkey.action.cmdb.fastmode.toggle
0182               
0183 7D9A 0D0A             byte  key.enter, id.dialog.load
0184 7D9C 6880             data  edkey.action.cmdb.load
0185                       ;-------------------------------------------------------
0186                       ; Dialog: Unsaved changes
0187                       ;-------------------------------------------------------
0188 7D9E 0C65             byte  key.fctn.6, id.dialog.unsaved
0189 7DA0 6924             data  edkey.action.cmdb.proceed
0190               
0191 7DA2 0D65             byte  key.enter, id.dialog.unsaved
0192 7DA4 7BC0             data  dialog.save
0193                       ;-------------------------------------------------------
0194                       ; Dialog: Save DV80 file
0195                       ;-------------------------------------------------------
0196 7DA6 0D0B             byte  key.enter, id.dialog.save
0197 7DA8 68C4             data  edkey.action.cmdb.save
0198               
0199 7DAA 0D0C             byte  key.enter, id.dialog.saveblock
0200 7DAC 68C4             data  edkey.action.cmdb.save
0201                       ;-------------------------------------------------------
0202                       ; Dialog: Basic
0203                       ;-------------------------------------------------------
0204 7DAE 4269             byte  key.uc.b, id.dialog.basic
0205 7DB0 7C04             data  tibasic
0206               
0207                       ;-------------------------------------------------------
0208                       ; Dialog: About
0209                       ;-------------------------------------------------------
0210 7DB2 0F67             byte  key.fctn.9, id.dialog.help
0211 7DB4 695A             data  edkey.action.cmdb.close.about
0212                       ;-------------------------------------------------------
0213                       ; Movement keys
0214                       ;-------------------------------------------------------
0215 7DB6 0801             byte  key.fctn.s, pane.focus.cmdb
0216 7DB8 67AA             data  edkey.action.cmdb.left
0217               
0218 7DBA 0901             byte  key.fctn.d, pane.focus.cmdb
0219 7DBC 67BC             data  edkey.action.cmdb.right
0220               
0221 7DBE BF01             byte  key.fctn.h, pane.focus.cmdb
0222 7DC0 67D4             data  edkey.action.cmdb.home
0223               
0224 7DC2 C201             byte  key.fctn.l, pane.focus.cmdb
0225 7DC4 67E8             data  edkey.action.cmdb.end
0226                       ;-------------------------------------------------------
0227                       ; Modifier keys
0228                       ;-------------------------------------------------------
0229 7DC6 0701             byte  key.fctn.3, pane.focus.cmdb
0230 7DC8 6800             data  edkey.action.cmdb.clear
0231                       ;-------------------------------------------------------
0232                       ; Other action keys
0233                       ;-------------------------------------------------------
0234 7DCA 0F01             byte  key.fctn.9, pane.focus.cmdb
0235 7DCC 6966             data  edkey.action.cmdb.close.dialog
0236               
0237 7DCE 0501             byte  key.fctn.plus, pane.focus.cmdb
0238 7DD0 665C             data  edkey.action.quit
0239               
0240 7DD2 9A01             byte  key.ctrl.z, pane.focus.cmdb
0241 7DD4 7638             data  pane.action.colorscheme.cycle
0242                       ;------------------------------------------------------
0243                       ; End of list
0244                       ;-------------------------------------------------------
0245 7DD6 FFFF             data  EOL                           ; EOL
                   < stevie_b1.asm.37021
0170                       ;-----------------------------------------------------------------------
0171                       ; Bank full check
0172                       ;-----------------------------------------------------------------------
0176                       ;-----------------------------------------------------------------------
0177                       ; Vector table
0178                       ;-----------------------------------------------------------------------
0179                       aorg  >7fc0
0180                       copy  "rom.vectors.bank1.asm"
     **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 6D78     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0008 7FC2 6C30     vec.2   data  idx.entry.update      ;    for index functions.
0009 7FC4 6CDE     vec.3   data  idx.entry.delete      ;
0010 7FC6 6C82     vec.4   data  idx.pointer.get       ;
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 6E60     vec.10  data  edb.line.pack.fb      ;
0017 7FD4 6F58     vec.11  data  edb.line.unpack.fb    ;
0018 7FD6 2026     vec.12  data  cpu.crash             ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 684A     vec.15  data  edkey.action.cmdb.show
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 2026     vec.18  data  cpu.crash             ;
0025 7FE4 7C48     vec.19  data  cmdb.cmd.clear        ;
0026 7FE6 6B84     vec.20  data  fb.refresh            ;
0027 7FE8 7CA6     vec.21  data  fb.vdpdump            ;
0028 7FEA 2026     vec.22  data  cpu.crash             ;
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 2026     vec.24  data  cpu.crash             ;
0031 7FF0 2026     vec.25  data  cpu.crash             ;
0032 7FF2 2026     vec.26  data  cpu.crash             ;
0033 7FF4 79CC     vec.27  data  pane.errline.hide     ;
0034 7FF6 785E     vec.28  data  pane.cursor.blink     ;
0035 7FF8 7840     vec.29  data  pane.cursor.hide      ;
0036 7FFA 7964     vec.30  data  pane.errline.show     ;
0037 7FFC 7696     vec.31  data  pane.action.colorscheme.load
0038 7FFE 7826     vec.32  data  pane.action.colorscheme.statlines
                   < stevie_b1.asm.37021
0181                                                   ; Vector table bank 1
0182               *--------------------------------------------------------------
0183               * Video mode configuration
0184               *--------------------------------------------------------------
0185      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0186      0004     spfbck  equ   >04                   ; Screen background color.
0187      3432     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0188      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0189      0050     colrow  equ   80                    ; Columns per row
0190      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0191      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0192      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0193      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

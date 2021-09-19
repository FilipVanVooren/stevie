XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b7.asm.3439690
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b7.asm               ; Version 210919-3439690
0010               *
0011               * Bank 7 "Jonas"
0012               * Empty
0013               ***************************************************************
0014                       copy  "rom.build.asm"       ; Cartridge build options
**** **** ****     > rom.build.asm
0001               * FILE......: rom.build.asm
0002               * Purpose...: Equates with cartridge build options
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
0023               *--------------------------------------------------------------
0024               * Classic99 F18a 24x80, no FG99 advanced mode
0025               *--------------------------------------------------------------
0026      0001     device.f18a               equ  1       ; F18a GPU
0027      0000     device.9938               equ  0       ; 9938 GPU
0028      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
0029               
0030               
0031               *--------------------------------------------------------------
0032               * JS99er F18a 30x80, FG99 advanced mode
0033               *--------------------------------------------------------------
0034               ; device.f18a             equ  0       ; F18a GPU
0035               ; device.9938             equ  1       ; 9938 GPU
0036               ; device.fg99.mode.adv    equ  1       ; FG99 advanced mode on
**** **** ****     > stevie_b7.asm.3439690
0015                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
**** **** ****     > rom.order.asm
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
**** **** ****     > stevie_b7.asm.3439690
0016                       copy  "equates.asm"         ; Equates Stevie configuration
**** **** ****     > equates.asm
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
0090      0067     id.dialog.about           equ  103     ; "About"
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
0103      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0104                                                      ; VDP SIT size 80 columns, 24/30 rows
0105      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0106      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0107               *--------------------------------------------------------------
0108               * SPECTRA2 / Stevie startup options
0109               *--------------------------------------------------------------
0110      0001     debug                     equ  1       ; Turn on spectra2 debugging
0111      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0112      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0113      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0114      7E00     cpu.scrpad.tgt            equ  >7e00   ; \ Dump of OS monitor scratchpad
0115                                                      ; | memory stored in cartridge ROM
0116                                                      ; / bank3.asm
0117               *--------------------------------------------------------------
0118               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0119               *--------------------------------------------------------------
0120      A000     core1.top         equ  >a000           ; Structure begin
0121      A000     parm1             equ  core1.top + 0   ; Function parameter 1
0122      A002     parm2             equ  core1.top + 2   ; Function parameter 2
0123      A004     parm3             equ  core1.top + 4   ; Function parameter 3
0124      A006     parm4             equ  core1.top + 6   ; Function parameter 4
0125      A008     parm5             equ  core1.top + 8   ; Function parameter 5
0126      A00A     parm6             equ  core1.top + 10  ; Function parameter 6
0127      A00C     parm7             equ  core1.top + 12  ; Function parameter 7
0128      A00E     parm8             equ  core1.top + 14  ; Function parameter 8
0129      A010     outparm1          equ  core1.top + 16  ; Function output parameter 1
0130      A012     outparm2          equ  core1.top + 18  ; Function output parameter 2
0131      A014     outparm3          equ  core1.top + 20  ; Function output parameter 3
0132      A016     outparm4          equ  core1.top + 22  ; Function output parameter 4
0133      A018     outparm5          equ  core1.top + 24  ; Function output parameter 5
0134      A01A     outparm6          equ  core1.top + 26  ; Function output parameter 6
0135      A01C     outparm7          equ  core1.top + 28  ; Function output parameter 7
0136      A01E     outparm8          equ  core1.top + 30  ; Function output parameter 8
0137      A020     keyrptcnt         equ  core1.top + 32  ; Key repeat-count (auto-repeat function)
0138      A022     keycode1          equ  core1.top + 34  ; Current key scanned
0139      A024     keycode2          equ  core1.top + 36  ; Previous key scanned
0140      A026     unpacked.string   equ  core1.top + 38  ; 6 char string with unpacked uin16
0141      A02C     core1.free        equ  core1.top + 44  ; End of structure
0142               *--------------------------------------------------------------
0143               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0144               *--------------------------------------------------------------
0145      A100     core2.top         equ  >a100           ; Structure begin
0146      A100     timers            equ  core2.top       ; Timer table
0147      A140     rambuf            equ  core2.top + 64  ; RAM workbuffer
0148      A180     ramsat            equ  core2.top + 128 ; Sprite Attribute Table in RAM
0149      A1A0     core2.free        equ  core2.top + 160 ; End of structure
0150               *--------------------------------------------------------------
0151               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0152               *--------------------------------------------------------------
0153      A200     tv.top            equ  >a200           ; Structure begin
0154      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0155      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0156      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0157      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0158      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0159      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0160      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0161      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0162      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0163      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0164      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0165      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0166      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0167      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0168      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0169      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0170      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0171      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0172      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0173      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0174      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0175      A22A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0176      A2CA     tv.free           equ  tv.top + 202    ; End of structure
0177               *--------------------------------------------------------------
0178               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0179               *--------------------------------------------------------------
0180      A300     fb.struct         equ  >a300           ; Structure begin
0181      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0182      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0183      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0184                                                      ; line X in editor buffer).
0185      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0186                                                      ; (offset 0 .. @fb.scrrows)
0187      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0188      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0189      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0190      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0191      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0192      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0193      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0194      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0195      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0196      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0197      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0198      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0199      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0200      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0201               *--------------------------------------------------------------
0202               * File handle structure               @>a400-a4ff   (256 bytes)
0203               *--------------------------------------------------------------
0204      A400     fh.struct         equ  >a400           ; stevie file handling structures
0205               ;***********************************************************************
0206               ; ATTENTION
0207               ; The dsrlnk variables must form a continuous memory block and keep
0208               ; their order!
0209               ;***********************************************************************
0210      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0211      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0212      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0213      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0214      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0215      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0216      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0217      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0218      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0219      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0220      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0221      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0222      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0223      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0224      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0225      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0226      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0227      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0228      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0229      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0230      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0231      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0232      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0233      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0234      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0235      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0236      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0237      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0238      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0239      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0240      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0241      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0242               *--------------------------------------------------------------
0243               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0244               *--------------------------------------------------------------
0245      A500     edb.struct        equ  >a500           ; Begin structure
0246      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0247      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0248      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0249      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0250      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0251      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0252      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0253      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0254      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0255      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0256                                                      ; with current filename.
0257      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0258                                                      ; with current file type.
0259      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0260      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0261      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0262                                                      ; for filename, but not always used.
0263      A569     edb.free          equ  edb.struct + 105; End of structure
0264               *--------------------------------------------------------------
0265               * Index structure                     @>a600-a6ff   (256 bytes)
0266               *--------------------------------------------------------------
0267      A600     idx.struct        equ  >a600           ; stevie index structure
0268      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0269      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0270      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0271      A606     idx.free          equ  idx.struct + 6  ; End of structure
0272               *--------------------------------------------------------------
0273               * Command buffer structure            @>a700-a7ff   (256 bytes)
0274               *--------------------------------------------------------------
0275      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0276      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0277      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0278      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0279      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0280      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0281      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0282      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0283      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0284      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0285      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0286      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0287      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0288      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0289      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0290      A71C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0291      A71E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0292      A720     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0293      A722     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0294      A724     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0295      A726     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0296      A728     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0297      A729     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0298      A779     cmdb.free         equ  cmdb.struct +121; End of structure
0299               *--------------------------------------------------------------
0300               * Paged-out scratchpad memory         @>ad00-aeff   (256 bytes)
0301               *--------------------------------------------------------------
0302      AD00     scrpad.copy       equ  >ad00           ; Copy of Stevie scratchpad memory
0303               *--------------------------------------------------------------
0304               * Farjump return stack                @>af00-afff   (256 bytes)
0305               *--------------------------------------------------------------
0306      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0307                                                      ; Grows downwards from high to low.
0308               *--------------------------------------------------------------
0309               * Index                               @>b000-bfff  (4096 bytes)
0310               *--------------------------------------------------------------
0311      B000     idx.top           equ  >b000           ; Top of index
0312      1000     idx.size          equ  4096            ; Index size
0313               *--------------------------------------------------------------
0314               * Editor buffer                       @>c000-cfff  (4096 bytes)
0315               *--------------------------------------------------------------
0316      C000     edb.top           equ  >c000           ; Editor buffer high memory
0317      1000     edb.size          equ  4096            ; Editor buffer size
0318               *--------------------------------------------------------------
0319               * Frame buffer                        @>d000-dfff  (4096 bytes)
0320               *--------------------------------------------------------------
0321      D000     fb.top            equ  >d000           ; Frame buffer (80x30)
0322      0960     fb.size           equ  80*30           ; Frame buffer size
0323               *--------------------------------------------------------------
0324               * Command buffer history              @>e000-efff  (4096 bytes)
0325               *--------------------------------------------------------------
0326      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0327      1000     cmdb.size         equ  4096            ; Command buffer size
0328               *--------------------------------------------------------------
0329               * Heap                                @>f000-ffff  (4096 bytes)
0330               *--------------------------------------------------------------
0331      F000     heap.top          equ  >f000           ; Top of heap
**** **** ****     > stevie_b7.asm.3439690
0017                       copy  "data.keymap.keys.asm"; Equates for keyboard mapping
**** **** ****     > data.keymap.keys.asm
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
0116               *---------------------------------------------------------------
0117               * Special keys
0118               *---------------------------------------------------------------
0119      000D     key.enter     equ >0d               ; enter
**** **** ****     > stevie_b7.asm.3439690
0018               
0019               ***************************************************************
0020               * Spectra2 core configuration
0021               ********|*****|*********************|**************************
0022      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0023                                                   ; grows from high to low.
0024               ***************************************************************
0025               * BANK 7
0026               ********|*****|*********************|**************************
0027      600E     bankid  equ   bank7.rom             ; Set bank identifier to current bank
0028                       aorg  >6000
0029                       save  >6000,>7fff           ; Save bank
0030                       copy  "rom.header.asm"      ; Include cartridge header
**** **** ****     > rom.header.asm
0001               * FILE......: rom.header.asm
0002               * Purpose...: Cartridge header
0003               
0004               *--------------------------------------------------------------
0005               * Cartridge header
0006               ********|*****|*********************|**************************
0007 6000 AA01             byte  >aa                   ; 0  Standard header                   >6000
0008                       byte  >01                   ; 1  Version number
0009 6002 0100             byte  >01                   ; 2  Number of programs (optional)     >6002
0010                       byte  0                     ; 3  Reserved ('R' = adv. mode FG99)
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
0044 6010 0B53             byte  11
0045 6011 ....             text  'STEVIE 1.1U'
0046                       even
0047               
0049               
**** **** ****     > stevie_b7.asm.3439690
0031               
0032               ***************************************************************
0033               * Step 1: Switch to bank 0 (uniform code accross all banks)
0034               ********|*****|*********************|**************************
0035                       aorg  kickstart.code1       ; >6040
0036 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0037               ***************************************************************
0038               * Step 2: Copy spectra2 library into cartridge space
0039               ********|*****|*********************|**************************
0040               main:
0041                       aorg  kickstart.code2       ; >6046
0042 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 6070 
0043               
0044                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
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
**** **** ****     > memsetup.equ
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
**** **** ****     > runlib.asm
0079                       copy  "registers.equ"            ; Equates runlib registers
**** **** ****     > registers.equ
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
**** **** ****     > runlib.asm
0080                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
**** **** ****     > portaddr.equ
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
**** **** ****     > runlib.asm
0081                       copy  "param.equ"                ; Equates runlib parameters
**** **** ****     > param.equ
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
**** **** ****     > runlib.asm
0082               
0086               
0087                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
**** **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               ---------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 604A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 604C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 604E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 6050 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 6052 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6054 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6056 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6058 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 605A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 605C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 605E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 6060 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 6062 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 6064 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 6066 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 6068 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 606A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 606C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 606E D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      604A     hb$00   equ   w$0000                ; >0000
0035      605C     hb$01   equ   w$0100                ; >0100
0036      605E     hb$02   equ   w$0200                ; >0200
0037      6060     hb$04   equ   w$0400                ; >0400
0038      6062     hb$08   equ   w$0800                ; >0800
0039      6064     hb$10   equ   w$1000                ; >1000
0040      6066     hb$20   equ   w$2000                ; >2000
0041      6068     hb$40   equ   w$4000                ; >4000
0042      606A     hb$80   equ   w$8000                ; >8000
0043      606E     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      604A     lb$00   equ   w$0000                ; >0000
0048      604C     lb$01   equ   w$0001                ; >0001
0049      604E     lb$02   equ   w$0002                ; >0002
0050      6050     lb$04   equ   w$0004                ; >0004
0051      6052     lb$08   equ   w$0008                ; >0008
0052      6054     lb$10   equ   w$0010                ; >0010
0053      6056     lb$20   equ   w$0020                ; >0020
0054      6058     lb$40   equ   w$0040                ; >0040
0055      605A     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      604C     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      604E     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      6050     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      6052     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      6054     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      6056     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      6058     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      605A     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      605C     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      605E     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      6060     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      6062     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      6064     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      6066     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      6068     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      606A     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0088                       copy  "config.equ"               ; Equates for bits in config register
**** **** ****     > config.equ
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
0027      6066     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      605C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6058     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6054     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
**** **** ****     > runlib.asm
0089                       copy  "cpu_crash.asm"            ; CPU crash handler
**** **** ****     > cpu_crash.asm
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
0038 6070 022B  22         ai    r11,-4                ; Remove opcode offset
     6072 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 6074 C800  38         mov   r0,@>ffe0
     6076 FFE0 
0043 6078 C801  38         mov   r1,@>ffe2
     607A FFE2 
0044 607C C802  38         mov   r2,@>ffe4
     607E FFE4 
0045 6080 C803  38         mov   r3,@>ffe6
     6082 FFE6 
0046 6084 C804  38         mov   r4,@>ffe8
     6086 FFE8 
0047 6088 C805  38         mov   r5,@>ffea
     608A FFEA 
0048 608C C806  38         mov   r6,@>ffec
     608E FFEC 
0049 6090 C807  38         mov   r7,@>ffee
     6092 FFEE 
0050 6094 C808  38         mov   r8,@>fff0
     6096 FFF0 
0051 6098 C809  38         mov   r9,@>fff2
     609A FFF2 
0052 609C C80A  38         mov   r10,@>fff4
     609E FFF4 
0053 60A0 C80B  38         mov   r11,@>fff6
     60A2 FFF6 
0054 60A4 C80C  38         mov   r12,@>fff8
     60A6 FFF8 
0055 60A8 C80D  38         mov   r13,@>fffa
     60AA FFFA 
0056 60AC C80E  38         mov   r14,@>fffc
     60AE FFFC 
0057 60B0 C80F  38         mov   r15,@>ffff
     60B2 FFFF 
0058 60B4 02A0  12         stwp  r0
0059 60B6 C800  38         mov   r0,@>ffdc
     60B8 FFDC 
0060 60BA 02C0  12         stst  r0
0061 60BC C800  38         mov   r0,@>ffde
     60BE FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60C0 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60C2 8300 
0067 60C4 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60C6 8302 
0068 60C8 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60CA 4A4A 
0069 60CC 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60CE 7036 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 60D0 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     60D2 6350 
0078 60D4 6236                   data graph1           ; Equate selected video mode table
0079               
0080 60D6 06A0  32         bl    @ldfnt
     60D8 63B8 
0081 60DA 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     60DC 000C 
0082               
0083 60DE 06A0  32         bl    @filv
     60E0 62E6 
0084 60E2 0380                   data >0380,>f0,32*24  ; Load color table
     60E4 00F0 
     60E6 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 60E8 06A0  32         bl    @putat                ; Show crash message
     60EA 649A 
0089 60EC 0000                   data >0000,cpu.crash.msg.crashed
     60EE 61C2 
0090               
0091 60F0 06A0  32         bl    @puthex               ; Put hex value on screen
     60F2 6AE4 
0092 60F4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 60F6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 60F8 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 60FA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 60FC 06A0  32         bl    @putat                ; Show caller message
     60FE 649A 
0101 6100 0100                   data >0100,cpu.crash.msg.caller
     6102 61D8 
0102               
0103 6104 06A0  32         bl    @puthex               ; Put hex value on screen
     6106 6AE4 
0104 6108 0115                   byte 1,21             ; \ i  p0 = YX position
0105 610A FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 610C A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 610E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 6110 06A0  32         bl    @putat
     6112 649A 
0113 6114 0300                   byte 3,0
0114 6116 61F4                   data cpu.crash.msg.wp
0115 6118 06A0  32         bl    @putat
     611A 649A 
0116 611C 0400                   byte 4,0
0117 611E 61FA                   data cpu.crash.msg.st
0118 6120 06A0  32         bl    @putat
     6122 649A 
0119 6124 1600                   byte 22,0
0120 6126 6200                   data cpu.crash.msg.source
0121 6128 06A0  32         bl    @putat
     612A 649A 
0122 612C 1700                   byte 23,0
0123 612E 621C                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 6130 06A0  32         bl    @at                   ; Put cursor at YX
     6132 6726 
0128 6134 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6136 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6138 FFDC 
0132 613A 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 613C C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 613E 0649  14         dect  stack
0138 6140 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 6142 0649  14         dect  stack
0140 6144 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6146 0649  14         dect  stack
0142 6148 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 614A C046  18         mov   tmp2,r1               ; Save register number
0148 614C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     614E 0001 
0149 6150 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 6152 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 6154 06A0  32         bl    @mknum
     6156 6AEE 
0154 6158 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 615A A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 615C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 615E 06A0  32         bl    @setx                 ; Set cursor X position
     6160 673C 
0160 6162 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 6164 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6166 6476 
0164 6168 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 616A 06A0  32         bl    @setx                 ; Set cursor X position
     616C 673C 
0168 616E 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 6170 0281  22         ci    r1,10
     6172 000A 
0172 6174 1102  14         jlt   !
0173 6176 0620  34         dec   @wyx                  ; x=x-1
     6178 832A 
0174               
0175 617A 06A0  32 !       bl    @putstr
     617C 6476 
0176 617E 61EE                   data cpu.crash.msg.r
0177               
0178 6180 06A0  32         bl    @mknum
     6182 6AEE 
0179 6184 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 6186 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 6188 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 618A 06A0  32         bl    @mkhex                ; Convert hex word to string
     618C 6A60 
0188 618E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 6190 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 6192 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 6194 06A0  32         bl    @setx                 ; Set cursor X position
     6196 673C 
0194 6198 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 619A 06A0  32         bl    @putstr               ; Put '  >'
     619C 6476 
0198 619E 61F0                   data cpu.crash.msg.marker
0199               
0200 61A0 06A0  32         bl    @setx                 ; Set cursor X position
     61A2 673C 
0201 61A4 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61A6 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A8 6476 
0205 61AA A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61AC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61AE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61B2 06A0  32         bl    @down                 ; y=y+1
     61B4 672C 
0213               
0214 61B6 0586  14         inc   tmp2
0215 61B8 0286  22         ci    tmp2,17
     61BA 0011 
0216 61BC 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61BE 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61C0 6F2A 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61C2 1553             byte  21
0225 61C3 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 61D8 1543             byte  21
0230 61D9 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 61EE 0152             byte  1
0235 61EF ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 61F0 0320             byte  3
0240 61F1 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 61F4 042A             byte  4
0245 61F5 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 61FA 042A             byte  4
0250 61FB ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 6200 1B53             byte  27
0255 6201 ....             text  'Source    stevie_b7.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 621C 1842             byte  24
0260 621D ....             text  'Build-ID  210919-3439690'
0261                       even
0262               
**** **** ****     > runlib.asm
0090                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6236 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6238 000E 
     623A 0106 
     623C 0204 
     623E 0020 
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
0029               
0030               ***************************************************************
0031               * TI Basic mode 1 (32 columns/24 rows)
0032               *--------------------------------------------------------------
0033 6240 00E2     tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
     6242 000C 
     6244 0006 
     6246 0004 
     6248 0020 
0034               *
0035               * ; VDP#0 Control bits
0036               * ;      bit 6=0: M3 | Graphics 1 mode
0037               * ;      bit 7=0: Disable external VDP input
0038               * ; VDP#1 Control bits
0039               * ;      bit 0=1: 16K selection
0040               * ;      bit 1=1: Enable display
0041               * ;      bit 2=1: Enable VDP interrupt
0042               * ;      bit 3=0: M1 \ Graphics 1 mode
0043               * ;      bit 4=0: M2 /
0044               * ;      bit 5=0: reserved
0045               * ;      bit 6=1: 16x16 sprites
0046               * ;      bit 7=0: Sprite magnification (1x)
0047               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0048               * ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
0049               * ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
0050               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0051               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0052               * ; VDP#7 Set screen background color
0053               
0054               
0055               
0056               
0057               ***************************************************************
0058               * Textmode (40 columns/24 rows)
0059               *--------------------------------------------------------------
0060 624A 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     624C 000E 
     624E 0106 
     6250 00F4 
     6252 0028 
0061               *
0062               * ; VDP#0 Control bits
0063               * ;      bit 6=0: M3 | Graphics 1 mode
0064               * ;      bit 7=0: Disable external VDP input
0065               * ; VDP#1 Control bits
0066               * ;      bit 0=1: 16K selection
0067               * ;      bit 1=1: Enable display
0068               * ;      bit 2=1: Enable VDP interrupt
0069               * ;      bit 3=1: M1 \ TEXT MODE
0070               * ;      bit 4=0: M2 /
0071               * ;      bit 5=0: reserved
0072               * ;      bit 6=1: 16x16 sprites
0073               * ;      bit 7=0: Sprite magnification (1x)
0074               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0075               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0076               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0077               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0078               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0079               * ; VDP#7 Set foreground/background color
0080               ***************************************************************
0081               
0082               
0083               ***************************************************************
0084               * Textmode (80 columns, 24 rows) - F18A
0085               *--------------------------------------------------------------
0086 6254 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6256 003F 
     6258 0240 
     625A 03F4 
     625C 0050 
0087               *
0088               * ; VDP#0 Control bits
0089               * ;      bit 6=0: M3 | Graphics 1 mode
0090               * ;      bit 7=0: Disable external VDP input
0091               * ; VDP#1 Control bits
0092               * ;      bit 0=1: 16K selection
0093               * ;      bit 1=1: Enable display
0094               * ;      bit 2=1: Enable VDP interrupt
0095               * ;      bit 3=1: M1 \ TEXT MODE
0096               * ;      bit 4=0: M2 /
0097               * ;      bit 5=0: reserved
0098               * ;      bit 6=0: 8x8 sprites
0099               * ;      bit 7=0: Sprite magnification (1x)
0100               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0101               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0102               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0103               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0104               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0105               * ; VDP#7 Set foreground/background color
0106               ***************************************************************
0107               
0108               
0109               ***************************************************************
0110               * Textmode (80 columns, 30 rows) - F18A
0111               *--------------------------------------------------------------
0112 625E 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6260 003F 
     6262 0240 
     6264 03F4 
     6266 0050 
0113               *
0114               * ; VDP#0 Control bits
0115               * ;      bit 6=0: M3 | Graphics 1 mode
0116               * ;      bit 7=0: Disable external VDP input
0117               * ; VDP#1 Control bits
0118               * ;      bit 0=1: 16K selection
0119               * ;      bit 1=1: Enable display
0120               * ;      bit 2=1: Enable VDP interrupt
0121               * ;      bit 3=1: M1 \ TEXT MODE
0122               * ;      bit 4=0: M2 /
0123               * ;      bit 5=0: reserved
0124               * ;      bit 6=0: 8x8 sprites
0125               * ;      bit 7=0: Sprite magnification (1x)
0126               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0127               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0128               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0129               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0130               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0131               * ; VDP#7 Set foreground/background color
0132               ***************************************************************
**** **** ****     > runlib.asm
0091                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
**** **** ****     > basic_cpu_vdp.asm
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
     6274 6268 
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
     629E 6070 
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
     6304 630C 
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
     63A6 638C 
0343 63A8 0204  20         li    tmp0,>0100
     63AA 0100 
0344 63AC D820  54         movb  @r14lb,@tmp0lb
     63AE 831D 
     63B0 8309 
0345 63B2 06A0  32         bl    @putvrx               ; Write VR#1
     63B4 638C 
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
     63C4 606A 
0365 63C6 1604  14         jne   ldfnt1
0366 63C8 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63CA 8000 
0367 63CC 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63CE 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63D0 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63D2 643A 
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
     63F8 630E 
0390 63FA 05C8  14         inct  tmp4                  ; R11=R11+2
0391 63FC C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 63FE 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6400 7FFF 
0393 6402 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6404 643C 
0394 6406 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6408 643E 
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
     6414 606A 
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
     6434 604A 
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
     647E 6452 
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
     6490 64E4 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 6492 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6494 FFCE 
0501 6496 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6498 6070 
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
     64A0 6476 
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
     64BC 6478 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64BE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64C0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64C2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64C4 06A0  32         bl    @down                 ; Move cursor down
     64C6 672C 
0566               
0567 64C8 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 64CA 0585  14         inc   tmp1                  ; Consider length byte
0569 64CC 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     64CE 604C 
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
**** **** ****     > runlib.asm
0092               
0094                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
**** **** ****     > copy_cpu_vram.asm
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
     64EE 6070 
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
     6506 650E 
     6508 8320 
0044 650A 0460  28         b     @mcloop               ; Write data to VDP and return
     650C 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 650E D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0096               
0098                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
**** **** ****     > copy_vram_cpu.asm
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
     6528 6530 
     652A 8320 
0035 652C 0460  28         b     @mcloop               ; Read data from VDP
     652E 8320 
0036 6530 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0100               
0102                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
**** **** ****     > copy_cpu_cpu.asm
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
     6542 6070 
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
     6566 606A 
0057 6568 1605  14         jne   cpym3
0058 656A C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     656C 6592 
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
**** **** ****     > runlib.asm
0104               
0108               
0112               
0114                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
**** **** ****     > cpu_sams_support.asm
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
     660C 6070 
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
     665A 65CE 
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
     6662 662A 
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
     6676 663A 
0324 6678 667E                   data sams.layout.standard
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
     66B6 66D6 
0379 66B8 0206  20         li    tmp2,8                ; Set loop counter
     66BA 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66BC C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66BE 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66C0 6596 
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
**** **** ****     > runlib.asm
0116               
0118                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
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
     66EC 639E 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66EE 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66F0 0040 
0018 66F2 0460  28         b     @putv01
     66F4 639E 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66F6 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66F8 FFDF 
0026 66FA 0460  28         b     @putv01
     66FC 639E 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66FE 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6700 0020 
0034 6702 0460  28         b     @putv01
     6704 639E 
**** **** ****     > runlib.asm
0120               
0122                       copy  "vdp_sprites.asm"          ; VDP sprites
**** **** ****     > vdp_sprites.asm
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
     670C 639E 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 670E 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6710 0001 
0019 6712 0460  28         b     @putv01
     6714 639E 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6716 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6718 FFFD 
0027 671A 0460  28         b     @putv01
     671C 639E 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 671E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6720 0002 
0035 6722 0460  28         b     @putv01
     6724 639E 
**** **** ****     > runlib.asm
0124               
0126                       copy  "vdp_cursor.asm"           ; VDP cursor handling
**** **** ****     > vdp_cursor.asm
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
     672E 605C 
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
     6736 605C 
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
**** **** ****     > runlib.asm
0128               
0130                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
**** **** ****     > vdp_yx2px_calc.asm
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
     6756 6068 
0030 6758 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 675A 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     675C 833A 
     675E 6788 
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
     6778 606A 
0053 677A 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 677C 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     677E 605C 
0059 6780 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6782 606E 
0060 6784 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6786 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6788 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0132               
0136               
0140               
0142                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
**** **** ****     > vdp_f18a.asm
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
     678E 638A 
0015 6790 391C             data  >391c                 ; VR1/57, value 00011100
0016 6792 06A0  32         bl    @putvr                ; Write twice
     6794 638A 
0017 6796 391C             data  >391c                 ; VR1/57, value 00011100
0018 6798 06A0  32         bl    @putvr
     679A 638A 
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
     67A4 638A 
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
     67AE 64DE 
0045 67B0 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     67B2 67EE 
     67B4 0006 
0046 67B6 06A0  32         bl    @putvr
     67B8 638A 
0047 67BA 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 67BC 06A0  32         bl    @putvr
     67BE 638A 
0049 67C0 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67C2 0204  20         li    tmp0,>3f00
     67C4 3F00 
0055 67C6 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67C8 6312 
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
     67E4 62E6 
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
     67F8 638A 
0102 67FA 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 67FC 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67FE 638A 
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
     6808 6068 
0127 680A 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 680C C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     680E 8802 
0132 6810 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6812 638A 
0133 6814 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 6816 04C4  14         clr   tmp0
0135 6818 D120  34         movb  @vdps,tmp0
     681A 8802 
0136 681C 0984  56         srl   tmp0,8
0137 681E 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0144               
0146                       copy  "vdp_hchar.asm"            ; VDP hchar functions
**** **** ****     > vdp_hchar.asm
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
     6830 6452 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6832 020B  20         li    r11,hchar1
     6834 683A 
0028 6836 0460  28         b     @xfilv                ; Draw
     6838 62EC 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 683A 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     683C 606C 
0033 683E 1302  14         jeq   hchar2                ; Yes, exit
0034 6840 C2C7  18         mov   tmp3,r11
0035 6842 10EE  14         jmp   hchar                 ; Next one
0036 6844 05C7  14 hchar2  inct  tmp3
0037 6846 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0148               
0152               
0156               
0160               
0162                       copy  "snd_player.asm"           ; Sound player
**** **** ****     > snd_player.asm
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
     684E 6050 
0016 6850 0204  20         li    tmp0,muttab
     6852 6862 
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
     6876 605C 
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
     687E 6050 
0060 6880 1301  14         jeq   sdpla1                ; Yes, play
0061 6882 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 6884 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 6886 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     6888 831B 
     688A 604A 
0067 688C 1301  14         jeq   sdpla3                ; Play next note
0068 688E 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6890 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6892 604C 
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
     68EC 604E 
0108 68EE 1607  14         jne   sdexi2                ; No, exit
0109 68F0 C820  54         mov   @wsdlst,@wsdtmp
     68F2 8334 
     68F4 8336 
0110 68F6 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     68F8 605C 
     68FA 831B 
0111 68FC 045B  20 sdexi1  b     *r11                  ; Exit
0112 68FE 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     6900 FFF8 
0113 6902 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > runlib.asm
0164               
0168               
0172               
0176               
0178                       copy  "keyb_real.asm"            ; Real Keyboard support
**** **** ****     > keyb_real.asm
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
     6906 606A 
0017 6908 020C  20         li    r12,>0024
     690A 0024 
0018 690C 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     690E 69A0 
0019 6910 04C6  14         clr   tmp2
0020 6912 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6914 04CC  14         clr   r12
0025 6916 1F08  20         tb    >0008                 ; Shift-key ?
0026 6918 1302  14         jeq   realk1                ; No
0027 691A 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     691C 69D0 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 691E 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6920 1302  14         jeq   realk2                ; No
0033 6922 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6924 6A00 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6926 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6928 1302  14         jeq   realk3                ; No
0039 692A 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     692C 6A30 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 692E 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     6930 6056 
0044 6932 1E15  20         sbz   >0015                 ; Set P5
0045 6934 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 6936 1302  14         jeq   realk4                ; No
0047 6938 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     693A 6056 
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
     697E 6056 
0089 6980 1608  14         jne   realka                ; No, continue saving key
0090 6982 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6984 69CA 
0091 6986 1A05  14         jl    realka
0092 6988 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     698A 69C8 
0093 698C 1B02  14         jh    realka                ; No, continue
0094 698E 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     6990 E000 
0095 6992 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6994 833C 
0096 6996 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6998 6054 
0097 699A 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     699C 8C00 
0098                                                   ; / using R15 as temp storage
0099 699E 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 69A0 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     69A2 0000 
     69A4 FF0D 
     69A6 203D 
0102 69A8 ....             text  'xws29ol.'
0103 69B0 ....             text  'ced38ik,'
0104 69B8 ....             text  'vrf47ujm'
0105 69C0 ....             text  'btg56yhn'
0106 69C8 ....             text  'zqa10p;/'
0107 69D0 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     69D2 0000 
     69D4 FF0D 
     69D6 202B 
0108 69D8 ....             text  'XWS@(OL>'
0109 69E0 ....             text  'CED#*IK<'
0110 69E8 ....             text  'VRF$&UJM'
0111 69F0 ....             text  'BTG%^YHN'
0112 69F8 ....             text  'ZQA!)P:-'
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
**** **** ****     > runlib.asm
0180               
0182                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
**** **** ****     > cpu_hexsupport.asm
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
     6ABE 6060 
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
     6AD0 606A 
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
     6AE0 6478 
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
**** **** ****     > runlib.asm
0184               
0186                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
**** **** ****     > cpu_numsupport.asm
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
0029 6B02 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
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
     6B24 606A 
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
     6B44 647A 
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
**** **** ****     > runlib.asm
0188               
0192               
0196               
0200               
0204               
0206                       copy  "cpu_strings.asm"          ; String utilities support
**** **** ****     > cpu_strings.asm
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
     6BCA 6538 
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
     6BD4 6070 
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
     6C2C 6070 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6C2E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6C30 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6C32 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6C34 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6C36 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0208               
0212               
0214                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > cpu_scrpad_backrest.asm
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
     6C3A 7E00 
0024 6C3C C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     6C3E 7E02 
0025 6C40 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     6C42 7E04 
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 6C44 0200  20         li    r0,>8306              ; Scratchpad source address
     6C46 8306 
0030 6C48 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     6C4A 7E06 
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
     6C5C 7EFE 
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 6C5E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     6C60 7E00 
0046 6C62 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     6C64 7E02 
0047 6C66 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     6C68 7E04 
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
0066               *  Current workspace can be outside scratchpad when called.
0067               ********|*****|*********************|**************************
0068               cpu.scrpad.restore:
0069 6C6C C80B  38         mov   r11,@rambuf           ; Backup return address
     6C6E A140 
0070                       ;------------------------------------------------------
0071                       ; Prepare for copy loop, WS
0072                       ;------------------------------------------------------
0073 6C70 0200  20         li    r0,cpu.scrpad.tgt + 6
     6C72 7E06 
0074 6C74 0201  20         li    r1,>8306
     6C76 8306 
0075 6C78 0202  20         li    r2,62
     6C7A 003E 
0076                       ;------------------------------------------------------
0077                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 6C7C CC70  46         mov   *r0+,*r1+
0081 6C7E CC70  46         mov   *r0+,*r1+
0082 6C80 0642  14         dect  r2
0083 6C82 16FC  14         jne   cpu.scrpad.restore.copy
0084 6C84 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     6C86 7EFE 
     6C88 83FE 
0085                                                   ; Copy last word
0086                       ;------------------------------------------------------
0087                       ; Restore scratchpad >8300 - >8304
0088                       ;------------------------------------------------------
0089 6C8A C820  54         mov   @cpu.scrpad.tgt,@>8300       ; r0
     6C8C 7E00 
     6C8E 8300 
0090 6C90 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302   ; r1
     6C92 7E02 
     6C94 8302 
0091 6C96 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304   ; r2
     6C98 7E04 
     6C9A 8304 
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095               cpu.scrpad.restore.exit:
0096 6C9C C2E0  34         mov   @rambuf,r11           ; Restore return address
     6C9E A140 
0097 6CA0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0215                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > cpu_scrpad_paging.asm
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
0030               *  specified in P0 (TMP1).
0031               *
0032               *  Then copies 256 bytes from @cpu.scrpad.tgt to scratchpad
0033               *  >8300 and activates workspace in >8300
0034               ********|*****|*********************|**************************
0035               cpu.scrpad.pgout:
0036 6CA2 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0037                       ;------------------------------------------------------
0038                       ; Copy registers r0-r7
0039                       ;------------------------------------------------------
0040 6CA4 CD40  34         mov   r0,*tmp1+             ; Backup r0
0041 6CA6 CD41  34         mov   r1,*tmp1+             ; Backup r1
0042 6CA8 CD42  34         mov   r2,*tmp1+             ; Backup r2
0043 6CAA CD43  34         mov   r3,*tmp1+             ; Backup r3
0044 6CAC CD44  34         mov   r4,*tmp1+             ; Backup r4
0045 6CAE CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0046 6CB0 CD46  34         mov   r6,*tmp1+             ; Backup r6
0047 6CB2 CD47  34         mov   r7,*tmp1+             ; Backup r7
0048                       ;------------------------------------------------------
0049                       ; Copy scratchpad memory to destination
0050                       ;------------------------------------------------------
0051               xcpu.scrpad.pgout:
0052 6CB4 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     6CB6 8310 
0053                                                   ;        as of register r8
0054 6CB8 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     6CBA 000F 
0055                       ;------------------------------------------------------
0056                       ; Copy memory
0057                       ;------------------------------------------------------
0058 6CBC CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0059 6CBE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0060 6CC0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0061 6CC2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0062 6CC4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0063 6CC6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0064 6CC8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0065 6CCA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0066 6CCC 0606  14         dec   tmp2
0067 6CCE 16F6  14         jne   -!                    ; Loop until done
0068                       ;------------------------------------------------------
0069                       ; Switch to new workspace
0070                       ;------------------------------------------------------
0071 6CD0 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0072 6CD2 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6CD4 6CDA 
0073                                                   ; R14=PC
0074 6CD6 04CF  14         clr   r15                   ; R15=STATUS
0075                       ;------------------------------------------------------
0076                       ; If we get here, WS was copied to specified
0077                       ; destination.  Also contents of r13,r14,r15
0078                       ; are about to be overwritten by rtwp instruction.
0079                       ;------------------------------------------------------
0080 6CD8 0380  18         rtwp                        ; Activate copied workspace
0081                                                   ; in non-scratchpad memory!
0082               
0083               cpu.scrpad.pgout.after.rtwp:
0084 6CDA 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     6CDC 6C6C 
0085                                                   ; from @cpu.scrpad.tgt to @>8300
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               cpu.scrpad.pgout.exit:
0090 6CDE 045B  20         b     *r11                  ; Return to caller
0091               
0092               
0093               ***************************************************************
0094               * cpu.scrpad.pgin - Page in 256 bytes of scratchpad memory
0095               *                   at >8300 from CPU memory specified in
0096               *                   p0 (tmp0)
0097               ***************************************************************
0098               *  bl   @cpu.scrpad.pgin
0099               *  DATA p0
0100               *  P0 = CPU memory source
0101               *--------------------------------------------------------------
0102               *  bl   @memx.scrpad.pgin
0103               *  TMP0 = CPU memory source
0104               *--------------------------------------------------------------
0105               *  Register usage
0106               *  tmp0-tmp2 = Used as temporary registers
0107               *--------------------------------------------------------------
0108               *  Remarks
0109               *  Copies 256 bytes from CPU memory source to scratchpad >8300
0110               *  and activates workspace in scratchpad >8300
0111               ********|*****|*********************|**************************
0112               cpu.scrpad.pgin:
0113 6CE0 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0114                       ;------------------------------------------------------
0115                       ; Copy scratchpad memory to destination
0116                       ;------------------------------------------------------
0117               xcpu.scrpad.pgin:
0118 6CE2 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6CE4 8300 
0119 6CE6 0206  20         li    tmp2,16               ; tmp2 = 256/16
     6CE8 0010 
0120                       ;------------------------------------------------------
0121                       ; Copy memory
0122                       ;------------------------------------------------------
0123 6CEA CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0124 6CEC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0125 6CEE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0126 6CF0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0127 6CF2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0128 6CF4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0129 6CF6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0130 6CF8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0131 6CFA 0606  14         dec   tmp2
0132 6CFC 16F6  14         jne   -!                    ; Loop until done
0133                       ;------------------------------------------------------
0134                       ; Switch workspace to scratchpad memory
0135                       ;------------------------------------------------------
0136 6CFE 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6D00 8300 
0137                       ;------------------------------------------------------
0138                       ; Exit
0139                       ;------------------------------------------------------
0140               cpu.scrpad.pgin.exit:
0141 6D02 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0217               
0219                       copy  "fio.equ"                  ; File I/O equates
**** **** ****     > fio.equ
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
**** **** ****     > runlib.asm
0220                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
**** **** ****     > fio_dsrlnk.asm
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
0056 6D04 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6D06 6D08             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6D08 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6D0A C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6D0C A428 
0064 6D0E 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6D10 6066 
0065 6D12 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6D14 8356 
0066 6D16 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6D18 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6D1A FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6D1C C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6D1E A434 
0073                       ;---------------------------; Inline VSBR start
0074 6D20 06C0  14         swpb  r0                    ;
0075 6D22 D800  38         movb  r0,@vdpa              ; Send low byte
     6D24 8C02 
0076 6D26 06C0  14         swpb  r0                    ;
0077 6D28 D800  38         movb  r0,@vdpa              ; Send high byte
     6D2A 8C02 
0078 6D2C D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6D2E 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6D30 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6D32 0704  14         seto  r4                    ; Init counter
0086 6D34 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D36 A420 
0087 6D38 0580  14 !       inc   r0                    ; Point to next char of name
0088 6D3A 0584  14         inc   r4                    ; Increment char counter
0089 6D3C 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6D3E 0007 
0090 6D40 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6D42 80C4  18         c     r4,r3                 ; End of name?
0093 6D44 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6D46 06C0  14         swpb  r0                    ;
0098 6D48 D800  38         movb  r0,@vdpa              ; Send low byte
     6D4A 8C02 
0099 6D4C 06C0  14         swpb  r0                    ;
0100 6D4E D800  38         movb  r0,@vdpa              ; Send high byte
     6D50 8C02 
0101 6D52 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6D54 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6D56 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6D58 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6D5A 6E70 
0109 6D5C 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6D5E C104  18         mov   r4,r4                 ; Check if length = 0
0115 6D60 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6D62 04E0  34         clr   @>83d0
     6D64 83D0 
0118 6D66 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6D68 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6D6A C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6D6C A432 
0121               
0122 6D6E 0584  14         inc   r4                    ; Adjust for dot
0123 6D70 A804  38         a     r4,@>8356             ; Point to position after name
     6D72 8356 
0124 6D74 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6D76 8356 
     6D78 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6D7A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D7C 83E0 
0130 6D7E 04C1  14         clr   r1                    ; Version found of dsr
0131 6D80 020C  20         li    r12,>0f00             ; Init cru address
     6D82 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6D84 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6D86 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6D88 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6D8A 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6D8C 0100 
0145 6D8E 04E0  34         clr   @>83d0                ; Clear in case we are done
     6D90 83D0 
0146 6D92 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D94 2000 
0147 6D96 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6D98 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6D9A 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6D9C 1D00  20         sbo   0                     ; Turn on ROM
0154 6D9E 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6DA0 4000 
0155 6DA2 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6DA4 6E6C 
0156 6DA6 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6DA8 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6DAA A40A 
0166 6DAC 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6DAE C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6DB0 83D2 
0172                                                   ; subprogram
0173               
0174 6DB2 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6DB4 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6DB6 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6DB8 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6DBA 83D2 
0183                                                   ; subprogram
0184               
0185 6DBC 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6DBE C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6DC0 04C5  14         clr   r5                    ; Remove any old stuff
0194 6DC2 D160  34         movb  @>8355,r5             ; Get length as counter
     6DC4 8355 
0195 6DC6 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6DC8 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6DCA 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6DCC 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6DCE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6DD0 A420 
0206 6DD2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6DD4 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6DD6 0605  14         dec   r5                    ; Update loop counter
0211 6DD8 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6DDA 0581  14         inc   r1                    ; Next version found
0217 6DDC C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6DDE A42A 
0218 6DE0 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6DE2 A42C 
0219 6DE4 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6DE6 A430 
0220               
0221 6DE8 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6DEA 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6DEC 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6DEE 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6DF0 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6DF2 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6DF4 A400 
0233 6DF6 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6DF8 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6DFA A428 
0239                                                   ; (8 or >a)
0240 6DFC 0281  22         ci    r1,8                  ; was it 8?
     6DFE 0008 
0241 6E00 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6E02 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6E04 8350 
0243                                                   ; Get error byte from @>8350
0244 6E06 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6E08 06C0  14         swpb  r0                    ;
0252 6E0A D800  38         movb  r0,@vdpa              ; send low byte
     6E0C 8C02 
0253 6E0E 06C0  14         swpb  r0                    ;
0254 6E10 D800  38         movb  r0,@vdpa              ; send high byte
     6E12 8C02 
0255 6E14 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E16 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6E18 09D1  56         srl   r1,13                 ; just keep error bits
0263 6E1A 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6E1C 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6E1E 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6E20 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E22 A400 
0275               dsrlnk.error.devicename_invalid:
0276 6E24 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6E26 06C1  14         swpb  r1                    ; put error in hi byte
0279 6E28 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6E2A F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6E2C 6066 
0281                                                   ; / to indicate error
0282 6E2E 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6E30 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6E32 6E34             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6E34 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E36 83E0 
0316               
0317 6E38 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6E3A 6066 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6E3C 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6E3E A42A 
0322 6E40 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6E42 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6E44 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6E46 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6E48 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6E4A C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6E4C 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6E4E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6E50 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6E52 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6E54 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6E56 4000 
     6E58 6E6C 
0337 6E5A 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6E5C 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6E5E 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6E60 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6E62 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6E64 A400 
0355 6E66 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6E68 A434 
0356               
0357 6E6A 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6E6C AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6E6E 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6E70 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
**** **** ****     > runlib.asm
0221                       copy  "fio_level3.asm"           ; File I/O level 3 support
**** **** ****     > fio_level3.asm
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
0045 6E72 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6E74 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6E76 0649  14         dect  stack
0052 6E78 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6E7A 0204  20         li    tmp0,dsrlnk.savcru
     6E7C A42A 
0057 6E7E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6E80 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6E82 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6E84 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6E86 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6E88 37D7 
0065 6E8A C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6E8C 8370 
0066                                                   ; / location
0067 6E8E C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6E90 A44C 
0068 6E92 04C5  14         clr   tmp1                  ; io.op.open
0069 6E94 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6E96 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6E98 0649  14         dect  stack
0097 6E9A C64B  30         mov   r11,*stack            ; Save return address
0098 6E9C 0205  20         li    tmp1,io.op.close      ; io.op.close
     6E9E 0001 
0099 6EA0 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6EA2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6EA4 0649  14         dect  stack
0125 6EA6 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6EA8 0205  20         li    tmp1,io.op.read       ; io.op.read
     6EAA 0002 
0128 6EAC 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6EAE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6EB0 0649  14         dect  stack
0155 6EB2 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6EB4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6EB6 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6EB8 0005 
0159               
0160 6EBA C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6EBC A43E 
0161               
0162 6EBE 06A0  32         bl    @xvputb               ; Write character count to PAB
     6EC0 6324 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6EC2 0205  20         li    tmp1,io.op.write      ; io.op.write
     6EC4 0003 
0167 6EC6 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6EC8 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6ECA 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6ECC 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6ECE 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6ED0 1000  14         nop
0189               
0190               
0191               file.status:
0192 6ED2 1000  14         nop
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
0227 6ED4 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6ED6 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6ED8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6EDA A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6EDC A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6EDE 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6EE0 6324 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6EE2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6EE4 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6EE6 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6EE8 A44C 
0246               
0247 6EEA 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6EEC 6324 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6EEE 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6EF0 0009 
0254 6EF2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EF4 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6EF6 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6EF8 8322 
     6EFA 833C 
0259               
0260 6EFC C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6EFE A42A 
0261 6F00 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6F02 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F04 6D04 
0268 6F06 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6F08 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6F0A 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6F0C 6E30 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6F0E 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6F10 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6F12 833C 
     6F14 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6F16 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6F18 A436 
0292 6F1A 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F1C 0005 
0293 6F1E 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F20 633C 
0294 6F22 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6F24 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6F26 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6F28 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0223               
0224               *//////////////////////////////////////////////////////////////
0225               *                            TIMERS
0226               *//////////////////////////////////////////////////////////////
0227               
0228                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
**** **** ****     > timers_tmgr.asm
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
0020 6F2A 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F2C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F2E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F30 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F32 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F34 6066 
0029 6F36 1602  14         jne   tmgr1a                ; No, so move on
0030 6F38 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F3A 6052 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F3C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F3E 606A 
0035 6F40 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F42 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F44 605A 
0048 6F46 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F48 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F4A 6058 
0050 6F4C 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F4E 0460  28         b     @kthread              ; Run kernel thread
     6F50 6FC8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F52 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F54 605E 
0056 6F56 13EB  14         jeq   tmgr1
0057 6F58 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F5A 605C 
0058 6F5C 16E8  14         jne   tmgr1
0059 6F5E C120  34         mov   @wtiusr,tmp0
     6F60 832E 
0060 6F62 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F64 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F66 6FC6 
0065 6F68 C10A  18         mov   r10,tmp0
0066 6F6A 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F6C 00FF 
0067 6F6E 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F70 6066 
0068 6F72 1303  14         jeq   tmgr5
0069 6F74 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F76 003C 
0070 6F78 1002  14         jmp   tmgr6
0071 6F7A 0284  22 tmgr5   ci    tmp0,50
     6F7C 0032 
0072 6F7E 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F80 1001  14         jmp   tmgr8
0074 6F82 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F84 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F86 832C 
0079 6F88 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F8A FF00 
0080 6F8C C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F8E 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F90 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F92 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F94 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F96 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F98 830C 
     6F9A 830D 
0089 6F9C 1608  14         jne   tmgr10                ; No, get next slot
0090 6F9E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6FA0 FF00 
0091 6FA2 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6FA4 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6FA6 8330 
0096 6FA8 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6FAA C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6FAC 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6FAE 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6FB0 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6FB2 8315 
     6FB4 8314 
0103 6FB6 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6FB8 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6FBA 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6FBC 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6FBE 10F7  14         jmp   tmgr10                ; Process next slot
0108 6FC0 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FC2 FF00 
0109 6FC4 10B4  14         jmp   tmgr1
0110 6FC6 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0229                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
**** **** ****     > timers_kthread.asm
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
0015 6FC8 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FCA 605A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 6FCC 20A0  38         coc   @wbit13,config        ; Sound player on ?
     6FCE 6050 
0023 6FD0 1602  14         jne   kthread_kb
0024 6FD2 06A0  32         bl    @sdpla1               ; Run sound player
     6FD4 6884 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FD6 06A0  32         bl    @realkb               ; Scan full keyboard
     6FD8 6904 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FDA 0460  28         b     @tmgr3                ; Exit
     6FDC 6F52 
**** **** ****     > runlib.asm
0230                       copy  "timers_hooks.asm"         ; Timers / User hooks
**** **** ****     > timers_hooks.asm
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
0017 6FDE C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FE0 832E 
0018 6FE2 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FE4 605C 
0019 6FE6 045B  20 mkhoo1  b     *r11                  ; Return
0020      6F2E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6FE8 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FEA 832E 
0029 6FEC 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FEE FEFF 
0030 6FF0 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0231               
0233                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
**** **** ****     > timers_alloc.asm
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
0017 6FF2 C13B  30 mkslot  mov   *r11+,tmp0
0018 6FF4 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6FF6 C184  18         mov   tmp0,tmp2
0023 6FF8 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6FFA A1A0  34         a     @wtitab,tmp2          ; Add table base
     6FFC 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6FFE CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 7000 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7002 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7004 881B  46         c     *r11,@w$ffff          ; End of list ?
     7006 606C 
0035 7008 1301  14         jeq   mkslo1                ; Yes, exit
0036 700A 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 700C 05CB  14 mkslo1  inct  r11
0041 700E 045B  20         b     *r11                  ; Exit
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
0052 7010 C13B  30 clslot  mov   *r11+,tmp0
0053 7012 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7014 A120  34         a     @wtitab,tmp0          ; Add table base
     7016 832C 
0055 7018 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 701A 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 701C 045B  20         b     *r11                  ; Exit
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
0068 701E C13B  30 rsslot  mov   *r11+,tmp0
0069 7020 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 7022 A120  34         a     @wtitab,tmp0          ; Add table base
     7024 832C 
0071 7026 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 7028 C154  26         mov   *tmp0,tmp1
0073 702A 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     702C FF00 
0074 702E C505  30         mov   tmp1,*tmp0
0075 7030 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
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
0261 7032 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7034 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 7036 0300  24 runli1  limi  0                     ; Turn off interrupts
     7038 0000 
0267 703A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     703C 8300 
0268 703E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     7040 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 7042 0202  20 runli2  li    r2,>8308
     7044 8308 
0273 7046 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 7048 0282  22         ci    r2,>8400
     704A 8400 
0275 704C 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 704E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     7050 FFFF 
0280 7052 1602  14         jne   runli4                ; No, continue
0281 7054 0420  54         blwp  @0                    ; Yes, bye bye
     7056 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 7058 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     705A 833C 
0286 705C 04C1  14         clr   r1                    ; Reset counter
0287 705E 0202  20         li    r2,10                 ; We test 10 times
     7060 000A 
0288 7062 C0E0  34 runli5  mov   @vdps,r3
     7064 8802 
0289 7066 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7068 606A 
0290 706A 1302  14         jeq   runli6
0291 706C 0581  14         inc   r1                    ; Increase counter
0292 706E 10F9  14         jmp   runli5
0293 7070 0602  14 runli6  dec   r2                    ; Next test
0294 7072 16F7  14         jne   runli5
0295 7074 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7076 1250 
0296 7078 1202  14         jle   runli7                ; No, so it must be NTSC
0297 707A 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     707C 6066 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 707E 06A0  32 runli7  bl    @loadmc
     7080 6272 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 7082 04C1  14 runli9  clr   r1
0306 7084 04C2  14         clr   r2
0307 7086 04C3  14         clr   r3
0308 7088 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     708A AF00 
0309 708C 020F  20         li    r15,vdpw              ; Set VDP write address
     708E 8C00 
0311 7090 06A0  32         bl    @mute                 ; Mute sound generators
     7092 6848 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 7094 0280  22         ci    r0,>4a4a              ; Crash flag set?
     7096 4A4A 
0318 7098 1605  14         jne   runlia
0319 709A 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     709C 62E6 
0320 709E 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     70A0 0000 
     70A2 3000 
0325 70A4 06A0  32 runlia  bl    @filv
     70A6 62E6 
0326 70A8 0FC0             data  pctadr,spfclr,16      ; Load color table
     70AA 00F4 
     70AC 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 70AE 06A0  32         bl    @f18unl               ; Unlock the F18A
     70B0 678A 
0334 70B2 06A0  32         bl    @f18chk               ; Check if F18A is there
     70B4 67AA 
0335 70B6 06A0  32         bl    @f18lck               ; Lock the F18A again
     70B8 67A0 
0336               
0337 70BA 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     70BC 638A 
0338 70BE 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 70C0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70C2 6350 
0352 70C4 70E8             data  spvmod                ; Equate selected video mode table
0353 70C6 0204  20         li    tmp0,spfont           ; Get font option
     70C8 000C 
0354 70CA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 70CC 1304  14         jeq   runlid                ; Yes, skip it
0356 70CE 06A0  32         bl    @ldfnt
     70D0 63B8 
0357 70D2 1100             data  fntadr,spfont         ; Load specified font
     70D4 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 70D6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70D8 4A4A 
0362 70DA 1602  14         jne   runlie                ; No, continue
0363 70DC 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     70DE 60D0 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 70E0 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70E2 0040 
0368 70E4 0460  28         b     @main                 ; Give control to main program
     70E6 6046 
**** **** ****     > stevie_b7.asm.3439690
0045                       copy  "data.constants.asm"  ; Need some constants for SAMS layout
**** **** ****     > data.constants.asm
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
0032               stevie.tx8030:
0033 70E8 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     70EA 003F 
     70EC 0243 
     70EE 05F4 
     70F0 0050 
0034               
0035               romsat:
0036 70F2 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     70F4 0201 
0037 70F6 0000             data  >0000,>0301             ; Current line indicator
     70F8 0301 
0038 70FA 0820             data  >0820,>0401             ; Current line indicator
     70FC 0401 
0039               nosprite:
0040 70FE D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 7100 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7102 0002 
0048 7104 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7106 0003 
0049 7108 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     710A 000A 
0050               
0051 710C B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     710E 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 7110 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     7112 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 7114 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7116 000D 
0060 7118 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     711A 000E 
0061 711C F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     711E 000F 
0062               
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * Stevie color schemes table
0069               *--------------------------------------------------------------
0070               * Word 1
0071               * A  MSB  high-nibble    Foreground color text line in frame buffer
0072               * B  MSB  low-nibble     Background color text line in frame buffer
0073               * C  LSB  high-nibble    Foreground color top/bottom line
0074               * D  LSB  low-nibble     Background color top/bottom line
0075               *
0076               * Word 2
0077               * E  MSB  high-nibble    Foreground color cmdb pane
0078               * F  MSB  low-nibble     Background color cmdb pane
0079               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0080               * H  LSB  low-nibble     Cursor foreground color frame buffer
0081               *
0082               * Word 3
0083               * I  MSB  high-nibble    Foreground color busy top/bottom line
0084               * J  MSB  low-nibble     Background color busy top/bottom line
0085               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0086               * L  LSB  low-nibble     Background color marked line in frame buffer
0087               *
0088               * Word 4
0089               * M  MSB  high-nibble    Foreground color command buffer header line
0090               * N  MSB  low-nibble     Background color command buffer header line
0091               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0092               * P  LSB  low-nibble     Foreground color ruler frame buffer
0093               *
0094               * Colors
0095               * 0  Transparant
0096               * 1  black
0097               * 2  Green
0098               * 3  Light Green
0099               * 4  Blue
0100               * 5  Light Blue
0101               * 6  Dark Red
0102               * 7  Cyan
0103               * 8  Red
0104               * 9  Light Red
0105               * A  Yellow
0106               * B  Light Yellow
0107               * C  Dark Green
0108               * D  Magenta
0109               * E  Grey
0110               * F  White
0111               *--------------------------------------------------------------
0112      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0113               
0114               tv.colorscheme.table:
0115                       ;                             ; #
0116                       ;      ABCD  EFGH  IJKL  MNOP ; -
0117 7120 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     7122 F171 
     7124 1B1F 
     7126 71B1 
0118 7128 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     712A F0FF 
     712C 1F1A 
     712E F1FF 
0119 7130 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     7132 F0FF 
     7134 1F12 
     7136 F1F6 
0120 7138 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     713A 1E11 
     713C 1A17 
     713E 1E11 
0121 7140 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     7142 E1FF 
     7144 1F1E 
     7146 E1FF 
0122 7148 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     714A 1016 
     714C 1B71 
     714E 1711 
0123 7150 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     7152 1011 
     7154 F1F1 
     7156 1F11 
0124 7158 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     715A A1FF 
     715C 1F1F 
     715E F11F 
0125 7160 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     7162 12FF 
     7164 1B12 
     7166 12FF 
0126 7168 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     716A E1FF 
     716C 1B1F 
     716E F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 7170 0007             byte  0,7,12,25               ; \   Default tab positions as used
     7172 0C19 
0131 7174 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     7176 3B4F 
0132 7178 FF00             byte  >ff,0,0,0               ; |
     717A 0000 
0133 717C 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     717E 0000 
0134 7180 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     7182 0000 
0135                       even
**** **** ****     > stevie_b7.asm.3439690
0046                       ;-----------------------------------------------------------------------
0047                       ; Stubs
0048                       ;-----------------------------------------------------------------------
0049                       copy  "rom.stubs.bank7.asm" ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank7.asm
0001               * FILE......: rom.stubs.bank7.asm
0002               * Purpose...: Bank 7 stubs for functions in other banks
**** **** ****     > stevie_b7.asm.3439690
0050                       ;-----------------------------------------------------------------------
0051                       ; Bank full check
0052                       ;-----------------------------------------------------------------------
0056                       ;-----------------------------------------------------------------------
0057                       ; Vector table
0058                       ;-----------------------------------------------------------------------
0059                       aorg  >7fc0
0060                       copy  "rom.vectors.bank7.asm"
**** **** ****     > rom.vectors.bank7.asm
0001               * FILE......: rom.vectors.bank7.asm
0002               * Purpose...: Bank 7 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 6670     vec.1   data  sams.layout.reset     ;
0008 7FC2 669E     vec.2   data  sams.layout.copy      ;
0009 7FC4 6070     vec.3   data  cpu.crash             ;
0010 7FC6 6070     vec.4   data  cpu.crash             ;
0011 7FC8 6070     vec.5   data  cpu.crash             ;
0012 7FCA 6070     vec.6   data  cpu.crash             ;
0013 7FCC 6070     vec.7   data  cpu.crash             ;
0014 7FCE 6070     vec.8   data  cpu.crash             ;
0015 7FD0 6070     vec.9   data  cpu.crash             ;
0016 7FD2 6070     vec.10  data  cpu.crash             ;
0017 7FD4 6070     vec.11  data  cpu.crash             ;
0018 7FD6 6070     vec.12  data  cpu.crash             ;
0019 7FD8 6070     vec.13  data  cpu.crash             ;
0020 7FDA 6070     vec.14  data  cpu.crash             ;
0021 7FDC 6070     vec.15  data  cpu.crash             ;
0022 7FDE 6070     vec.16  data  cpu.crash             ;
0023 7FE0 6070     vec.17  data  cpu.crash             ;
0024 7FE2 6070     vec.18  data  cpu.crash             ;
0025 7FE4 6070     vec.19  data  cpu.crash             ;
0026 7FE6 6070     vec.20  data  cpu.crash             ;
0027 7FE8 6070     vec.21  data  cpu.crash             ;
0028 7FEA 6070     vec.22  data  cpu.crash             ;
0029 7FEC 6070     vec.23  data  cpu.crash             ;
0030 7FEE 6070     vec.24  data  cpu.crash             ;
0031 7FF0 6070     vec.25  data  cpu.crash             ;
0032 7FF2 6070     vec.26  data  cpu.crash             ;
0033 7FF4 6070     vec.27  data  cpu.crash             ;
0034 7FF6 6070     vec.28  data  cpu.crash             ;
0035 7FF8 6070     vec.29  data  cpu.crash             ;
0036 7FFA 6070     vec.30  data  cpu.crash             ;
0037 7FFC 6070     vec.31  data  cpu.crash             ;
0038 7FFE 6070     vec.32  data  cpu.crash             ;
**** **** ****     > stevie_b7.asm.3439690
0061                                                   ; Vector table bank 7
0062               
0063               *--------------------------------------------------------------
0064               * Video mode configuration
0065               *--------------------------------------------------------------
0066      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0067      0004     spfbck  equ   >04                   ; Screen background color.
0068      70E8     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0069      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0070      0050     colrow  equ   80                    ; Columns per row
0071      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0072      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0073      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0074      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

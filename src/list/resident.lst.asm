XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > resident.asm.3440585
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: reident.asm                 ; Version 210919-3440585
0010               *
0011               * Only for debugging
0012               * Generate list file with contents of resident modules in
0013               * LOW MEMEXP >2000 - >3fff
0014               ***************************************************************
0015                       copy  "rom.build.asm"       ; Cartridge build options
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
**** **** ****     > resident.asm.3440585
0016                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
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
**** **** ****     > resident.asm.3440585
0017                       copy  "equates.asm"         ; Equates Stevie configuration
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
**** **** ****     > resident.asm.3440585
0018                       copy  "data.keymap.keys.asm"; Equates for keyboard mapping
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
**** **** ****     > resident.asm.3440585
0019               
0020               ***************************************************************
0021               * Spectra2 core configuration
0022               ********|*****|*********************|**************************
0023      AF00     sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
0024                                                   ; grows from high to low.
0025               ***************************************************************
0026               * BANK 0
0027               ********|*****|*********************|**************************
0028      6000     bankid  equ   bank0.rom             ; Set bank identifier to current bank
0029                       aorg  >6000
0030                       save  >6000,>7fff           ; Save bank
0031                       copy  "rom.header.asm"      ; Include cartridge header
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
**** **** ****     > resident.asm.3440585
0032               
0033               ***************************************************************
0034               * Code data: Relocated code
0035               ********|*****|*********************|**************************
0036               reloc.resident:
0037                       ;------------------------------------------------------
0038                       ; Resident libraries
0039                       ;------------------------------------------------------
0040                       aorg  >2000                 ; Relocate to >2000
0041                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0027      201C     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      2012     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      200E     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      200A     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
     2084 2FEC 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 2306 
0078 208A 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 236E 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 229C 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2450 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 2A9A 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2450 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 2A9A 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 A140                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2450 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2450 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2450 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2450 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 26DC 
0128 20EA 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20EC 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20EE FFDC 
0132 20F0 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 20F2 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 20F4 0649  14         dect  stack
0138 20F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 20F8 0649  14         dect  stack
0140 20FA C645  30         mov   tmp1,*stack           ; Push tmp1
0141 20FC 0649  14         dect  stack
0142 20FE C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 2100 C046  18         mov   tmp2,r1               ; Save register number
0148 2102 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     2104 0001 
0149 2106 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2108 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 210A 06A0  32         bl    @mknum
     210C 2AA4 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26F2 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 242C 
0164 211E A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26F2 
0168 2124 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2126 0281  22         ci    r1,10
     2128 000A 
0172 212A 1102  14         jlt   !
0173 212C 0620  34         dec   @wyx                  ; x=x-1
     212E 832A 
0174               
0175 2130 06A0  32 !       bl    @putstr
     2132 242C 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 2AA4 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 2A16 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 A140                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26F2 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 242C 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26F2 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 242C 
0205 2160 A140                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 26E2 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2EE0 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2178 1553             byte  21
0225 2179 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 218E 1543             byte  21
0230 218F ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21A4 0152             byte  1
0235 21A5 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21A6 0320             byte  3
0240 21A7 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21AA 042A             byte  4
0245 21AB ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21B0 042A             byte  4
0250 21B1 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21B6 1A53             byte  26
0255 21B7 ....             text  'Source    resident.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1842             byte  24
0260 21D3 ....             text  'Build-ID  210919-3440585'
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
0007 21EC 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21EE 000E 
     21F0 0106 
     21F2 0204 
     21F4 0020 
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
0033 21F6 00E2     tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
     21F8 000C 
     21FA 0006 
     21FC 0004 
     21FE 0020 
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
0060 2200 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2202 000E 
     2204 0106 
     2206 00F4 
     2208 0028 
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
0086 220A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220C 003F 
     220E 0240 
     2210 03F4 
     2212 0050 
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
0112 2214 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2216 003F 
     2218 0240 
     221A 03F4 
     221C 0050 
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
0013 221E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2220 16FD             data  >16fd                 ; |         jne   mcloop
0015 2222 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2224 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2226 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 2228 0201  20         li    r1,mccode             ; Machinecode to patch
     222A 221E 
0037 222C 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     222E 8322 
0038 2230 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2232 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2234 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2236 045B  20         b     *r11                  ; Return to caller
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
0056 2238 C0F9  30 popr3   mov   *stack+,r3
0057 223A C0B9  30 popr2   mov   *stack+,r2
0058 223C C079  30 popr1   mov   *stack+,r1
0059 223E C039  30 popr0   mov   *stack+,r0
0060 2240 C2F9  30 poprt   mov   *stack+,r11
0061 2242 045B  20         b     *r11
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
0085 2244 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2246 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 2248 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 224A C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 224C 1604  14         jne   filchk                ; No, continue checking
0093               
0094 224E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2250 FFCE 
0095 2252 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2254 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2256 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2258 830B 
     225A 830A 
0100               
0101 225C 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     225E 0001 
0102 2260 1602  14         jne   filchk2
0103 2262 DD05  32         movb  tmp1,*tmp0+
0104 2264 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2266 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2268 0002 
0109 226A 1603  14         jne   filchk3
0110 226C DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 226E DD05  32         movb  tmp1,*tmp0+
0112 2270 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2272 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2274 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2276 0001 
0118 2278 1305  14         jeq   fil16b
0119 227A DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 227C 0606  14         dec   tmp2
0121 227E 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2280 0002 
0122 2282 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2284 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2286 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2288 0001 
0128 228A 1301  14         jeq   dofill
0129 228C 0606  14         dec   tmp2                  ; Make TMP2 even
0130 228E CD05  34 dofill  mov   tmp1,*tmp0+
0131 2290 0646  14         dect  tmp2
0132 2292 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2294 C1C7  18         mov   tmp3,tmp3
0137 2296 1301  14         jeq   fil.exit
0138 2298 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 229A 045B  20         b     *r11
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
0159 229C C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 229E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 22A0 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A2 0264  22 xfilv   ori   tmp0,>4000
     22A4 4000 
0166 22A6 06C4  14         swpb  tmp0
0167 22A8 D804  38         movb  tmp0,@vdpa
     22AA 8C02 
0168 22AC 06C4  14         swpb  tmp0
0169 22AE D804  38         movb  tmp0,@vdpa
     22B0 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B2 020F  20         li    r15,vdpw              ; Set VDP write address
     22B4 8C00 
0174 22B6 06C5  14         swpb  tmp1
0175 22B8 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22BA 22C2 
     22BC 8320 
0176 22BE 0460  28         b     @mcloop               ; Write data to VDP
     22C0 8320 
0177               *--------------------------------------------------------------
0181 22C2 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22C4 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C6 4000 
0202 22C8 06C4  14 vdra    swpb  tmp0
0203 22CA D804  38         movb  tmp0,@vdpa
     22CC 8C02 
0204 22CE 06C4  14         swpb  tmp0
0205 22D0 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D2 8C02 
0206 22D4 045B  20         b     *r11                  ; Exit
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
0217 22D6 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22D8 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22DA 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22DC 4000 
0223 22DE 06C4  14         swpb  tmp0                  ; \
0224 22E0 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E2 8C02 
0225 22E4 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E6 D804  38         movb  tmp0,@vdpa            ; /
     22E8 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22EA 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22EC D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22EE 045B  20         b     *r11                  ; Exit
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
0251 22F0 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F2 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F4 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F6 8C02 
0257 22F8 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22FA D804  38         movb  tmp0,@vdpa            ; /
     22FC 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22FE D120  34         movb  @vdpr,tmp0            ; Read byte
     2300 8800 
0263 2302 0984  56         srl   tmp0,8                ; Right align
0264 2304 045B  20         b     *r11                  ; Exit
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
0283 2306 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 2308 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 230A C144  18         mov   tmp0,tmp1
0289 230C 05C5  14         inct  tmp1
0290 230E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2310 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2312 FF00 
0292 2314 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2316 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2318 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 231A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     231C 8000 
0298 231E 0206  20         li    tmp2,8
     2320 0008 
0299 2322 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2324 830B 
0300 2326 06C5  14         swpb  tmp1
0301 2328 D805  38         movb  tmp1,@vdpa
     232A 8C02 
0302 232C 06C5  14         swpb  tmp1
0303 232E D805  38         movb  tmp1,@vdpa
     2330 8C02 
0304 2332 0225  22         ai    tmp1,>0100
     2334 0100 
0305 2336 0606  14         dec   tmp2
0306 2338 16F4  14         jne   vidta1                ; Next register
0307 233A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     233C 833A 
0308 233E 045B  20         b     *r11
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
0325 2340 C13B  30 putvr   mov   *r11+,tmp0
0326 2342 0264  22 putvrx  ori   tmp0,>8000
     2344 8000 
0327 2346 06C4  14         swpb  tmp0
0328 2348 D804  38         movb  tmp0,@vdpa
     234A 8C02 
0329 234C 06C4  14         swpb  tmp0
0330 234E D804  38         movb  tmp0,@vdpa
     2350 8C02 
0331 2352 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2354 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2356 C10E  18         mov   r14,tmp0
0341 2358 0984  56         srl   tmp0,8
0342 235A 06A0  32         bl    @putvrx               ; Write VR#0
     235C 2342 
0343 235E 0204  20         li    tmp0,>0100
     2360 0100 
0344 2362 D820  54         movb  @r14lb,@tmp0lb
     2364 831D 
     2366 8309 
0345 2368 06A0  32         bl    @putvrx               ; Write VR#1
     236A 2342 
0346 236C 0458  20         b     *tmp4                 ; Exit
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
0360 236E C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2370 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2372 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2374 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2376 7FFF 
0364 2378 2120  38         coc   @wbit0,tmp0
     237A 2020 
0365 237C 1604  14         jne   ldfnt1
0366 237E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2380 8000 
0367 2382 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2384 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2386 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2388 23F0 
0372 238A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     238C 9C02 
0373 238E 06C4  14         swpb  tmp0
0374 2390 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2392 9C02 
0375 2394 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2396 9800 
0376 2398 06C5  14         swpb  tmp1
0377 239A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     239C 9800 
0378 239E 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 23A0 D805  38         movb  tmp1,@grmwa
     23A2 9C02 
0383 23A4 06C5  14         swpb  tmp1
0384 23A6 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23A8 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23AA C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23AC 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23AE 22C4 
0390 23B0 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B2 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B4 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B6 7FFF 
0393 23B8 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23BA 23F2 
0394 23BC C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23BE 23F4 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23C0 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C2 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C4 D120  34         movb  @grmrd,tmp0
     23C6 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23C8 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23CA 2020 
0405 23CC 1603  14         jne   ldfnt3                ; No, so skip
0406 23CE D1C4  18         movb  tmp0,tmp3
0407 23D0 0917  56         srl   tmp3,1
0408 23D2 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D4 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D6 8C00 
0413 23D8 0606  14         dec   tmp2
0414 23DA 16F2  14         jne   ldfnt2
0415 23DC 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23DE 020F  20         li    r15,vdpw              ; Set VDP write address
     23E0 8C00 
0417 23E2 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E4 7FFF 
0418 23E6 0458  20         b     *tmp4                 ; Exit
0419 23E8 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23EA 2000 
     23EC 8C00 
0420 23EE 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23F0 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F2 0200 
     23F4 0000 
0425 23F6 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23F8 01C0 
     23FA 0101 
0426 23FC 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23FE 02A0 
     2400 0101 
0427 2402 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2404 00E0 
     2406 0101 
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
0445 2408 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 240A C3A0  34         mov   @wyx,r14              ; Get YX
     240C 832A 
0447 240E 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2410 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2412 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2414 C3A0  34         mov   @wyx,r14              ; Get YX
     2416 832A 
0454 2418 024E  22         andi  r14,>00ff             ; Remove Y
     241A 00FF 
0455 241C A3CE  18         a     r14,r15               ; pos = pos + X
0456 241E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2420 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2422 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2424 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2426 020F  20         li    r15,vdpw              ; VDP write address
     2428 8C00 
0463 242A 045B  20         b     *r11
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
0481 242C C17B  30 putstr  mov   *r11+,tmp1
0482 242E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2430 C1CB  18 xutstr  mov   r11,tmp3
0484 2432 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2434 2408 
0485 2436 C2C7  18         mov   tmp3,r11
0486 2438 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 243A C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 243C 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 243E 0286  22         ci    tmp2,255              ; Length > 255 ?
     2440 00FF 
0494 2442 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 2444 0460  28         b     @xpym2v               ; Display string
     2446 249A 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 2448 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     244A FFCE 
0501 244C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     244E 2026 
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
0517 2450 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2452 832A 
0518 2454 0460  28         b     @putstr
     2456 242C 
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
0539 2458 0649  14         dect  stack
0540 245A C64B  30         mov   r11,*stack            ; Save return address
0541 245C 0649  14         dect  stack
0542 245E C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2460 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2462 0987  56         srl   tmp3,8                ; Right align
0549               
0550 2464 0649  14         dect  stack
0551 2466 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 2468 0649  14         dect  stack
0553 246A C646  30         mov   tmp2,*stack           ; Push tmp2
0554 246C 0649  14         dect  stack
0555 246E C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2470 06A0  32         bl    @xutst0               ; Display string
     2472 242E 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 2474 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 2476 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 2478 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 247A 06A0  32         bl    @down                 ; Move cursor down
     247C 26E2 
0566               
0567 247E A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2480 0585  14         inc   tmp1                  ; Consider length byte
0569 2482 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     2484 2002 
0570 2486 1301  14         jeq   !                     ; Yes, skip adjustment
0571 2488 0585  14         inc   tmp1                  ; Make address even
0572 248A 0606  14 !       dec   tmp2
0573 248C 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 248E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2490 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2492 045B  20         b     *r11                  ; Return
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
0020 2494 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2496 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2498 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 249A C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 249C 1604  14         jne   !                     ; No, continue
0028               
0029 249E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24A0 FFCE 
0030 24A2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24A4 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 24A6 0264  22 !       ori   tmp0,>4000
     24A8 4000 
0035 24AA 06C4  14         swpb  tmp0
0036 24AC D804  38         movb  tmp0,@vdpa
     24AE 8C02 
0037 24B0 06C4  14         swpb  tmp0
0038 24B2 D804  38         movb  tmp0,@vdpa
     24B4 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24B6 020F  20         li    r15,vdpw              ; Set VDP write address
     24B8 8C00 
0043 24BA C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24BC 24C4 
     24BE 8320 
0044 24C0 0460  28         b     @mcloop               ; Write data to VDP and return
     24C2 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24C4 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 24C6 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24C8 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24CA C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24CC 06C4  14 xpyv2m  swpb  tmp0
0027 24CE D804  38         movb  tmp0,@vdpa
     24D0 8C02 
0028 24D2 06C4  14         swpb  tmp0
0029 24D4 D804  38         movb  tmp0,@vdpa
     24D6 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24D8 020F  20         li    r15,vdpr              ; Set VDP read address
     24DA 8800 
0034 24DC C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24DE 24E6 
     24E0 8320 
0035 24E2 0460  28         b     @mcloop               ; Read data from VDP
     24E4 8320 
0036 24E6 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24E8 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24EA C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24EC C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24EE C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24F0 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24F2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24F4 FFCE 
0034 24F6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24F8 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24FA 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24FC 0001 
0039 24FE 1603  14         jne   cpym0                 ; No, continue checking
0040 2500 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 2502 04C6  14         clr   tmp2                  ; Reset counter
0042 2504 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 2506 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     2508 7FFF 
0047 250A C1C4  18         mov   tmp0,tmp3
0048 250C 0247  22         andi  tmp3,1
     250E 0001 
0049 2510 1618  14         jne   cpyodd                ; Odd source address handling
0050 2512 C1C5  18 cpym1   mov   tmp1,tmp3
0051 2514 0247  22         andi  tmp3,1
     2516 0001 
0052 2518 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 251A 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     251C 2020 
0057 251E 1605  14         jne   cpym3
0058 2520 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2522 2548 
     2524 8320 
0059 2526 0460  28         b     @mcloop               ; Copy memory and exit
     2528 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 252A C1C6  18 cpym3   mov   tmp2,tmp3
0064 252C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     252E 0001 
0065 2530 1301  14         jeq   cpym4
0066 2532 0606  14         dec   tmp2                  ; Make TMP2 even
0067 2534 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 2536 0646  14         dect  tmp2
0069 2538 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 253A C1C7  18         mov   tmp3,tmp3
0074 253C 1301  14         jeq   cpymz
0075 253E D554  38         movb  *tmp0,*tmp1
0076 2540 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2542 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     2544 8000 
0081 2546 10E9  14         jmp   cpym2
0082 2548 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 254A C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 254C 0649  14         dect  stack
0065 254E C64B  30         mov   r11,*stack            ; Push return address
0066 2550 0649  14         dect  stack
0067 2552 C640  30         mov   r0,*stack             ; Push r0
0068 2554 0649  14         dect  stack
0069 2556 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 2558 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 255A 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 255C 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     255E 4000 
0077 2560 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2562 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2564 020C  20         li    r12,>1e00             ; SAMS CRU address
     2566 1E00 
0082 2568 04C0  14         clr   r0
0083 256A 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 256C D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 256E D100  18         movb  r0,tmp0
0086 2570 0984  56         srl   tmp0,8                ; Right align
0087 2572 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2574 833C 
0088 2576 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 2578 C339  30         mov   *stack+,r12           ; Pop r12
0094 257A C039  30         mov   *stack+,r0            ; Pop r0
0095 257C C2F9  30         mov   *stack+,r11           ; Pop return address
0096 257E 045B  20         b     *r11                  ; Return to caller
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
0131 2580 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2582 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2584 0649  14         dect  stack
0135 2586 C64B  30         mov   r11,*stack            ; Push return address
0136 2588 0649  14         dect  stack
0137 258A C640  30         mov   r0,*stack             ; Push r0
0138 258C 0649  14         dect  stack
0139 258E C64C  30         mov   r12,*stack            ; Push r12
0140 2590 0649  14         dect  stack
0141 2592 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2594 0649  14         dect  stack
0143 2596 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2598 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 259A 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 259C 0284  22         ci    tmp0,255              ; Crash if page > 255
     259E 00FF 
0153 25A0 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 25A2 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     25A4 001E 
0158 25A6 150A  14         jgt   !
0159 25A8 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25AA 0004 
0160 25AC 1107  14         jlt   !
0161 25AE 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25B0 0012 
0162 25B2 1508  14         jgt   sams.page.set.switch_page
0163 25B4 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25B6 0006 
0164 25B8 1501  14         jgt   !
0165 25BA 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25BC C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25BE FFCE 
0170 25C0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25C2 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25C4 020C  20         li    r12,>1e00             ; SAMS CRU address
     25C6 1E00 
0176 25C8 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25CA 06C0  14         swpb  r0                    ; LSB to MSB
0178 25CC 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25CE D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25D0 4000 
0180 25D2 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25D4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25D6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25D8 C339  30         mov   *stack+,r12           ; Pop r12
0188 25DA C039  30         mov   *stack+,r0            ; Pop r0
0189 25DC C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25DE 045B  20         b     *r11                  ; Return to caller
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
0204 25E0 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E2 1E00 
0205 25E4 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25E6 045B  20         b     *r11                  ; Return to caller
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
0227 25E8 020C  20         li    r12,>1e00             ; SAMS CRU address
     25EA 1E00 
0228 25EC 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25EE 045B  20         b     *r11                  ; Return to caller
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
0260 25F0 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25F2 0649  14         dect  stack
0263 25F4 C64B  30         mov   r11,*stack            ; Save return address
0264 25F6 0649  14         dect  stack
0265 25F8 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25FA 0649  14         dect  stack
0267 25FC C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25FE 0649  14         dect  stack
0269 2600 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 2602 0649  14         dect  stack
0271 2604 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 2606 0206  20         li    tmp2,8                ; Set loop counter
     2608 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 260A C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 260C C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 260E 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2610 2584 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2612 0606  14         dec   tmp2                  ; Next iteration
0288 2614 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 2616 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     2618 25E0 
0294                                                   ; / activating changes.
0295               
0296 261A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 261C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 261E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 2620 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2622 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 2624 045B  20         b     *r11                  ; Return to caller
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
0318 2626 0649  14         dect  stack
0319 2628 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 262A 06A0  32         bl    @sams.layout
     262C 25F0 
0324 262E 2634                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 2630 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2632 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 2634 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     2636 0002 
0336 2638 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     263A 0003 
0337 263C A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     263E 000A 
0338 2640 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2642 000B 
0339 2644 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     2646 000C 
0340 2648 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     264A 000D 
0341 264C E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     264E 000E 
0342 2650 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2652 000F 
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
0363 2654 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 2656 0649  14         dect  stack
0366 2658 C64B  30         mov   r11,*stack            ; Push return address
0367 265A 0649  14         dect  stack
0368 265C C644  30         mov   tmp0,*stack           ; Push tmp0
0369 265E 0649  14         dect  stack
0370 2660 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2662 0649  14         dect  stack
0372 2664 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 2666 0649  14         dect  stack
0374 2668 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 266A 0205  20         li    tmp1,sams.layout.copy.data
     266C 268C 
0379 266E 0206  20         li    tmp2,8                ; Set loop counter
     2670 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2672 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2674 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2676 254C 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 2678 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     267A 833C 
0390               
0391 267C 0606  14         dec   tmp2                  ; Next iteration
0392 267E 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2680 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2682 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2684 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 2686 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 2688 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 268A 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 268C 2000             data  >2000                 ; >2000-2fff
0408 268E 3000             data  >3000                 ; >3000-3fff
0409 2690 A000             data  >a000                 ; >a000-afff
0410 2692 B000             data  >b000                 ; >b000-bfff
0411 2694 C000             data  >c000                 ; >c000-cfff
0412 2696 D000             data  >d000                 ; >d000-dfff
0413 2698 E000             data  >e000                 ; >e000-efff
0414 269A F000             data  >f000                 ; >f000-ffff
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
0009 269C 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     269E FFBF 
0010 26A0 0460  28         b     @putv01
     26A2 2354 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 26A4 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     26A6 0040 
0018 26A8 0460  28         b     @putv01
     26AA 2354 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26AC 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26AE FFDF 
0026 26B0 0460  28         b     @putv01
     26B2 2354 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26B4 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26B6 0020 
0034 26B8 0460  28         b     @putv01
     26BA 2354 
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
0010 26BC 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26BE FFFE 
0011 26C0 0460  28         b     @putv01
     26C2 2354 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26C4 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26C6 0001 
0019 26C8 0460  28         b     @putv01
     26CA 2354 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26CC 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26CE FFFD 
0027 26D0 0460  28         b     @putv01
     26D2 2354 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26D4 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26D6 0002 
0035 26D8 0460  28         b     @putv01
     26DA 2354 
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
0018 26DC C83B  50 at      mov   *r11+,@wyx
     26DE 832A 
0019 26E0 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26E2 B820  54 down    ab    @hb$01,@wyx
     26E4 2012 
     26E6 832A 
0028 26E8 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26EA 7820  54 up      sb    @hb$01,@wyx
     26EC 2012 
     26EE 832A 
0037 26F0 045B  20         b     *r11
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
0049 26F2 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26F4 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26F6 832A 
0051 26F8 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26FA 832A 
0052 26FC 045B  20         b     *r11
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
0021 26FE C120  34 yx2px   mov   @wyx,tmp0
     2700 832A 
0022 2702 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2704 06C4  14         swpb  tmp0                  ; Y<->X
0024 2706 04C5  14         clr   tmp1                  ; Clear before copy
0025 2708 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 270A 20A0  38         coc   @wbit1,config         ; f18a present ?
     270C 201E 
0030 270E 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2710 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2712 833A 
     2714 273E 
0032 2716 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 2718 0A15  56         sla   tmp1,1                ; X = X * 2
0035 271A B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 271C 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     271E 0500 
0037 2720 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2722 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2724 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2726 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 2728 D105  18         movb  tmp1,tmp0
0051 272A 06C4  14         swpb  tmp0                  ; X<->Y
0052 272C 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     272E 2020 
0053 2730 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2732 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     2734 2012 
0059 2736 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     2738 2024 
0060 273A 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 273C 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 273E 0050            data   80
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
0013 2740 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2742 06A0  32         bl    @putvr                ; Write once
     2744 2340 
0015 2746 391C             data  >391c                 ; VR1/57, value 00011100
0016 2748 06A0  32         bl    @putvr                ; Write twice
     274A 2340 
0017 274C 391C             data  >391c                 ; VR1/57, value 00011100
0018 274E 06A0  32         bl    @putvr
     2750 2340 
0019 2752 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 2754 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 2756 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 2758 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     275A 2340 
0030 275C 3900             data  >3900
0031 275E 0458  20         b     *tmp4                 ; Exit
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
0043 2760 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 2762 06A0  32         bl    @cpym2v
     2764 2494 
0045 2766 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2768 27A4 
     276A 0006 
0046 276C 06A0  32         bl    @putvr
     276E 2340 
0047 2770 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 2772 06A0  32         bl    @putvr
     2774 2340 
0049 2776 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 2778 0204  20         li    tmp0,>3f00
     277A 3F00 
0055 277C 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     277E 22C8 
0056 2780 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2782 8800 
0057 2784 0984  56         srl   tmp0,8
0058 2786 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2788 8800 
0059 278A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 278C 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 278E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2790 BFFF 
0063 2792 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 2794 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2796 4000 
0066               f18chk_exit:
0067 2798 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     279A 229C 
0068 279C 3F00             data  >3f00,>00,6
     279E 0000 
     27A0 0006 
0069 27A2 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 27A4 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 27A6 3F00             data  >3f00                 ; 3f02 / 3f00
0076 27A8 0340             data  >0340                 ; 3f04   0340  idle
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
0097 27AA C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 27AC 06A0  32         bl    @putvr
     27AE 2340 
0102 27B0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 27B2 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27B4 2340 
0105 27B6 3900             data  >3900                 ; Lock the F18a
0106 27B8 0458  20         b     *tmp4                 ; Exit
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
0125 27BA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 27BC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27BE 201E 
0127 27C0 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 27C2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27C4 8802 
0132 27C6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27C8 2340 
0133 27CA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 27CC 04C4  14         clr   tmp0
0135 27CE D120  34         movb  @vdps,tmp0
     27D0 8802 
0136 27D2 0984  56         srl   tmp0,8
0137 27D4 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27D6 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27D8 832A 
0018 27DA D17B  28         movb  *r11+,tmp1
0019 27DC 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27DE D1BB  28         movb  *r11+,tmp2
0021 27E0 0986  56         srl   tmp2,8                ; Repeat count
0022 27E2 C1CB  18         mov   r11,tmp3
0023 27E4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27E6 2408 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27E8 020B  20         li    r11,hchar1
     27EA 27F0 
0028 27EC 0460  28         b     @xfilv                ; Draw
     27EE 22A2 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27F0 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27F2 2022 
0033 27F4 1302  14         jeq   hchar2                ; Yes, exit
0034 27F6 C2C7  18         mov   tmp3,r11
0035 27F8 10EE  14         jmp   hchar                 ; Next one
0036 27FA 05C7  14 hchar2  inct  tmp3
0037 27FC 0457  20         b     *tmp3                 ; Exit
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
0014 27FE 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     2800 8334 
0015 2802 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     2804 2006 
0016 2806 0204  20         li    tmp0,muttab
     2808 2818 
0017 280A 0205  20         li    tmp1,sound            ; Sound generator port >8400
     280C 8400 
0018 280E D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 2810 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 2812 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 2814 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 2816 045B  20         b     *r11
0023 2818 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     281A DFFF 
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
0043 281C C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     281E 8334 
0044 2820 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     2822 8336 
0045 2824 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     2826 FFF8 
0046 2828 E0BB  30         soc   *r11+,config          ; Set options
0047 282A D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     282C 2012 
     282E 831B 
0048 2830 045B  20         b     *r11
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
0059 2832 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     2834 2006 
0060 2836 1301  14         jeq   sdpla1                ; Yes, play
0061 2838 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 283A 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 283C 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     283E 831B 
     2840 2000 
0067 2842 1301  14         jeq   sdpla3                ; Play next note
0068 2844 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 2846 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     2848 2002 
0070 284A 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 284C C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     284E 8336 
0075 2850 06C4  14         swpb  tmp0
0076 2852 D804  38         movb  tmp0,@vdpa
     2854 8C02 
0077 2856 06C4  14         swpb  tmp0
0078 2858 D804  38         movb  tmp0,@vdpa
     285A 8C02 
0079 285C 04C4  14         clr   tmp0
0080 285E D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     2860 8800 
0081 2862 131E  14         jeq   sdexit                ; Yes. exit
0082 2864 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 2866 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     2868 8336 
0084 286A D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     286C 8800 
     286E 8400 
0085 2870 0604  14         dec   tmp0
0086 2872 16FB  14         jne   vdpla2
0087 2874 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     2876 8800 
     2878 831B 
0088 287A 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     287C 8336 
0089 287E 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 2880 C120  34 mmplay  mov   @wsdtmp,tmp0
     2882 8336 
0094 2884 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 2886 130C  14         jeq   sdexit                ; Yes, exit
0096 2888 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 288A A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     288C 8336 
0098 288E D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     2890 8400 
0099 2892 0605  14         dec   tmp1
0100 2894 16FC  14         jne   mmpla2
0101 2896 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     2898 831B 
0102 289A 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     289C 8336 
0103 289E 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 28A0 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     28A2 2004 
0108 28A4 1607  14         jne   sdexi2                ; No, exit
0109 28A6 C820  54         mov   @wsdlst,@wsdtmp
     28A8 8334 
     28AA 8336 
0110 28AC D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     28AE 2012 
     28B0 831B 
0111 28B2 045B  20 sdexi1  b     *r11                  ; Exit
0112 28B4 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     28B6 FFF8 
0113 28B8 045B  20         b     *r11                  ; Exit
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
0016 28BA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     28BC 2020 
0017 28BE 020C  20         li    r12,>0024
     28C0 0024 
0018 28C2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     28C4 2956 
0019 28C6 04C6  14         clr   tmp2
0020 28C8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 28CA 04CC  14         clr   r12
0025 28CC 1F08  20         tb    >0008                 ; Shift-key ?
0026 28CE 1302  14         jeq   realk1                ; No
0027 28D0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     28D2 2986 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 28D4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 28D6 1302  14         jeq   realk2                ; No
0033 28D8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     28DA 29B6 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 28DC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 28DE 1302  14         jeq   realk3                ; No
0039 28E0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     28E2 29E6 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 28E4 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     28E6 200C 
0044 28E8 1E15  20         sbz   >0015                 ; Set P5
0045 28EA 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 28EC 1302  14         jeq   realk4                ; No
0047 28EE E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     28F0 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 28F2 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 28F4 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     28F6 0006 
0053 28F8 0606  14 realk5  dec   tmp2
0054 28FA 020C  20         li    r12,>24               ; CRU address for P2-P4
     28FC 0024 
0055 28FE 06C6  14         swpb  tmp2
0056 2900 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2902 06C6  14         swpb  tmp2
0058 2904 020C  20         li    r12,6                 ; CRU read address
     2906 0006 
0059 2908 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 290A 0547  14         inv   tmp3                  ;
0061 290C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     290E FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2910 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2912 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2914 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2916 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2918 0285  22         ci    tmp1,8
     291A 0008 
0070 291C 1AFA  14         jl    realk6
0071 291E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2920 1BEB  14         jh    realk5                ; No, next column
0073 2922 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2924 C206  18 realk8  mov   tmp2,tmp4
0078 2926 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2928 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 292A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 292C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 292E 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2930 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2932 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2934 200C 
0089 2936 1608  14         jne   realka                ; No, continue saving key
0090 2938 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     293A 2980 
0091 293C 1A05  14         jl    realka
0092 293E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2940 297E 
0093 2942 1B02  14         jh    realka                ; No, continue
0094 2944 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2946 E000 
0095 2948 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     294A 833C 
0096 294C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     294E 200A 
0097 2950 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2952 8C00 
0098                                                   ; / using R15 as temp storage
0099 2954 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2956 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2958 0000 
     295A FF0D 
     295C 203D 
0102 295E ....             text  'xws29ol.'
0103 2966 ....             text  'ced38ik,'
0104 296E ....             text  'vrf47ujm'
0105 2976 ....             text  'btg56yhn'
0106 297E ....             text  'zqa10p;/'
0107 2986 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2988 0000 
     298A FF0D 
     298C 202B 
0108 298E ....             text  'XWS@(OL>'
0109 2996 ....             text  'CED#*IK<'
0110 299E ....             text  'VRF$&UJM'
0111 29A6 ....             text  'BTG%^YHN'
0112 29AE ....             text  'ZQA!)P:-'
0113 29B6 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     29B8 0000 
     29BA FF0D 
     29BC 2005 
0114 29BE 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     29C0 0804 
     29C2 0F27 
     29C4 C2B9 
0115 29C6 600B             data  >600b,>0907,>063f,>c1B8
     29C8 0907 
     29CA 063F 
     29CC C1B8 
0116 29CE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     29D0 7B02 
     29D2 015F 
     29D4 C0C3 
0117 29D6 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     29D8 7D0E 
     29DA 0CC6 
     29DC BFC4 
0118 29DE 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     29E0 7C03 
     29E2 BC22 
     29E4 BDBA 
0119 29E6 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     29E8 0000 
     29EA FF0D 
     29EC 209D 
0120 29EE 9897             data  >9897,>93b2,>9f8f,>8c9B
     29F0 93B2 
     29F2 9F8F 
     29F4 8C9B 
0121 29F6 8385             data  >8385,>84b3,>9e89,>8b80
     29F8 84B3 
     29FA 9E89 
     29FC 8B80 
0122 29FE 9692             data  >9692,>86b4,>b795,>8a8D
     2A00 86B4 
     2A02 B795 
     2A04 8A8D 
0123 2A06 8294             data  >8294,>87b5,>b698,>888E
     2A08 87B5 
     2A0A B698 
     2A0C 888E 
0124 2A0E 9A91             data  >9a91,>81b1,>b090,>9cBB
     2A10 81B1 
     2A12 B090 
     2A14 9CBB 
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
0023 2A16 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2A18 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2A1A 8340 
0025 2A1C 04E0  34         clr   @waux1
     2A1E 833C 
0026 2A20 04E0  34         clr   @waux2
     2A22 833E 
0027 2A24 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2A26 833C 
0028 2A28 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2A2A 0205  20         li    tmp1,4                ; 4 nibbles
     2A2C 0004 
0033 2A2E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2A30 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2A32 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2A34 0286  22         ci    tmp2,>000a
     2A36 000A 
0039 2A38 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2A3A C21B  26         mov   *r11,tmp4
0045 2A3C 0988  56         srl   tmp4,8                ; Right justify
0046 2A3E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2A40 FFF6 
0047 2A42 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2A44 C21B  26         mov   *r11,tmp4
0054 2A46 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2A48 00FF 
0055               
0056 2A4A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2A4C 06C6  14         swpb  tmp2
0058 2A4E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2A50 0944  56         srl   tmp0,4                ; Next nibble
0060 2A52 0605  14         dec   tmp1
0061 2A54 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2A56 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2A58 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2A5A C160  34         mov   @waux3,tmp1           ; Get pointer
     2A5C 8340 
0067 2A5E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2A60 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2A62 C120  34         mov   @waux2,tmp0
     2A64 833E 
0070 2A66 06C4  14         swpb  tmp0
0071 2A68 DD44  32         movb  tmp0,*tmp1+
0072 2A6A 06C4  14         swpb  tmp0
0073 2A6C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2A6E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2A70 8340 
0078 2A72 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2A74 2016 
0079 2A76 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2A78 C120  34         mov   @waux1,tmp0
     2A7A 833C 
0084 2A7C 06C4  14         swpb  tmp0
0085 2A7E DD44  32         movb  tmp0,*tmp1+
0086 2A80 06C4  14         swpb  tmp0
0087 2A82 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2A84 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A86 2020 
0092 2A88 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2A8A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2A8C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2A8E 7FFF 
0098 2A90 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2A92 8340 
0099 2A94 0460  28         b     @xutst0               ; Display string
     2A96 242E 
0100 2A98 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2A9A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2A9C 832A 
0122 2A9E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2AA0 8000 
0123 2AA2 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 2AA4 0207  20 mknum   li    tmp3,5                ; Digit counter
     2AA6 0005 
0020 2AA8 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2AAA C155  26         mov   *tmp1,tmp1            ; /
0022 2AAC C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 2AAE 0228  22         ai    tmp4,4                ; Get end of buffer
     2AB0 0004 
0024 2AB2 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2AB4 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2AB6 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2AB8 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2ABA 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2ABC B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 2ABE D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 2AC0 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 2AC2 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2AC4 0607  14         dec   tmp3                  ; Decrease counter
0036 2AC6 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2AC8 0207  20         li    tmp3,4                ; Check first 4 digits
     2ACA 0004 
0041 2ACC 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2ACE C11B  26         mov   *r11,tmp0
0043 2AD0 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2AD2 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2AD4 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2AD6 05CB  14 mknum3  inct  r11
0047 2AD8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2ADA 2020 
0048 2ADC 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2ADE 045B  20         b     *r11                  ; Exit
0050 2AE0 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2AE2 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2AE4 13F8  14         jeq   mknum3                ; Yes, exit
0053 2AE6 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2AE8 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2AEA 7FFF 
0058 2AEC C10B  18         mov   r11,tmp0
0059 2AEE 0224  22         ai    tmp0,-4
     2AF0 FFFC 
0060 2AF2 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2AF4 0206  20         li    tmp2,>0500            ; String length = 5
     2AF6 0500 
0062 2AF8 0460  28         b     @xutstr               ; Display string
     2AFA 2430 
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
0093 2AFC C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2AFE C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2B00 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2B02 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2B04 0207  20         li    tmp3,5                ; Set counter
     2B06 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2B08 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2B0A 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2B0C 0584  14         inc   tmp0                  ; Next character
0105 2B0E 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2B10 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2B12 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2B14 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2B16 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2B18 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2B1A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2B1C 0607  14         dec   tmp3                  ; Last character ?
0121 2B1E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2B20 045B  20         b     *r11                  ; Return
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
0139 2B22 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2B24 832A 
0140 2B26 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2B28 8000 
0141 2B2A 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2B2C 0649  14         dect  stack
0023 2B2E C64B  30         mov   r11,*stack            ; Save return address
0024 2B30 0649  14         dect  stack
0025 2B32 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2B34 0649  14         dect  stack
0027 2B36 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2B38 0649  14         dect  stack
0029 2B3A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2B3C 0649  14         dect  stack
0031 2B3E C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2B40 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2B42 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2B44 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2B46 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2B48 0649  14         dect  stack
0044 2B4A C64B  30         mov   r11,*stack            ; Save return address
0045 2B4C 0649  14         dect  stack
0046 2B4E C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2B50 0649  14         dect  stack
0048 2B52 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2B54 0649  14         dect  stack
0050 2B56 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2B58 0649  14         dect  stack
0052 2B5A C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2B5C C1D4  26 !       mov   *tmp0,tmp3
0057 2B5E 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2B60 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2B62 00FF 
0059 2B64 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2B66 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2B68 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2B6A 0584  14         inc   tmp0                  ; Next byte
0067 2B6C 0607  14         dec   tmp3                  ; Shorten string length
0068 2B6E 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2B70 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2B72 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2B74 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2B76 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2B78 C187  18         mov   tmp3,tmp2
0078 2B7A 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2B7C DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2B7E 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2B80 24EE 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2B82 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2B84 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B86 FFCE 
0090 2B88 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B8A 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2B8C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2B8E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2B90 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2B92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2B94 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2B96 045B  20         b     *r11                  ; Return to caller
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
0123 2B98 0649  14         dect  stack
0124 2B9A C64B  30         mov   r11,*stack            ; Save return address
0125 2B9C 05D9  26         inct  *stack                ; Skip "data P0"
0126 2B9E 05D9  26         inct  *stack                ; Skip "data P1"
0127 2BA0 0649  14         dect  stack
0128 2BA2 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2BA4 0649  14         dect  stack
0130 2BA6 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2BA8 0649  14         dect  stack
0132 2BAA C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2BAC C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2BAE C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2BB0 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2BB2 0649  14         dect  stack
0144 2BB4 C64B  30         mov   r11,*stack            ; Save return address
0145 2BB6 0649  14         dect  stack
0146 2BB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2BBA 0649  14         dect  stack
0148 2BBC C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2BBE 0649  14         dect  stack
0150 2BC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2BC2 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2BC4 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2BC6 0586  14         inc   tmp2
0161 2BC8 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2BCA 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2BCC 0286  22         ci    tmp2,255
     2BCE 00FF 
0167 2BD0 1505  14         jgt   string.getlenc.panic
0168 2BD2 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2BD4 0606  14         dec   tmp2                  ; One time adjustment
0174 2BD6 C806  38         mov   tmp2,@waux1           ; Store length
     2BD8 833C 
0175 2BDA 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2BDC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2BDE FFCE 
0181 2BE0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2BE2 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2BE4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2BE6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2BE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2BEA C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2BEC 045B  20         b     *r11                  ; Return to caller
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
0023 2BEE C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2BF0 7E00 
0024 2BF2 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2BF4 7E02 
0025 2BF6 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2BF8 7E04 
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2BFA 0200  20         li    r0,>8306              ; Scratchpad source address
     2BFC 8306 
0030 2BFE 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2C00 7E06 
0031 2C02 0202  20         li    r2,62                 ; Loop counter
     2C04 003E 
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2C06 CC70  46         mov   *r0+,*r1+
0037 2C08 CC70  46         mov   *r0+,*r1+
0038 2C0A 0642  14         dect  r2
0039 2C0C 16FC  14         jne   cpu.scrpad.backup.copy
0040 2C0E C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2C10 83FE 
     2C12 7EFE 
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2C14 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2C16 7E00 
0046 2C18 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2C1A 7E02 
0047 2C1C C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2C1E 7E04 
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2C20 045B  20         b     *r11                  ; Return to caller
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
0069 2C22 C80B  38         mov   r11,@rambuf           ; Backup return address
     2C24 A140 
0070                       ;------------------------------------------------------
0071                       ; Prepare for copy loop, WS
0072                       ;------------------------------------------------------
0073 2C26 0200  20         li    r0,cpu.scrpad.tgt + 6
     2C28 7E06 
0074 2C2A 0201  20         li    r1,>8306
     2C2C 8306 
0075 2C2E 0202  20         li    r2,62
     2C30 003E 
0076                       ;------------------------------------------------------
0077                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 2C32 CC70  46         mov   *r0+,*r1+
0081 2C34 CC70  46         mov   *r0+,*r1+
0082 2C36 0642  14         dect  r2
0083 2C38 16FC  14         jne   cpu.scrpad.restore.copy
0084 2C3A C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2C3C 7EFE 
     2C3E 83FE 
0085                                                   ; Copy last word
0086                       ;------------------------------------------------------
0087                       ; Restore scratchpad >8300 - >8304
0088                       ;------------------------------------------------------
0089 2C40 C820  54         mov   @cpu.scrpad.tgt,@>8300       ; r0
     2C42 7E00 
     2C44 8300 
0090 2C46 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302   ; r1
     2C48 7E02 
     2C4A 8302 
0091 2C4C C820  54         mov   @cpu.scrpad.tgt + 4,@>8304   ; r2
     2C4E 7E04 
     2C50 8304 
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095               cpu.scrpad.restore.exit:
0096 2C52 C2E0  34         mov   @rambuf,r11           ; Restore return address
     2C54 A140 
0097 2C56 045B  20         b     *r11                  ; Return to caller
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
0036 2C58 C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0037                       ;------------------------------------------------------
0038                       ; Copy registers r0-r7
0039                       ;------------------------------------------------------
0040 2C5A CD40  34         mov   r0,*tmp1+             ; Backup r0
0041 2C5C CD41  34         mov   r1,*tmp1+             ; Backup r1
0042 2C5E CD42  34         mov   r2,*tmp1+             ; Backup r2
0043 2C60 CD43  34         mov   r3,*tmp1+             ; Backup r3
0044 2C62 CD44  34         mov   r4,*tmp1+             ; Backup r4
0045 2C64 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0046 2C66 CD46  34         mov   r6,*tmp1+             ; Backup r6
0047 2C68 CD47  34         mov   r7,*tmp1+             ; Backup r7
0048                       ;------------------------------------------------------
0049                       ; Copy scratchpad memory to destination
0050                       ;------------------------------------------------------
0051               xcpu.scrpad.pgout:
0052 2C6A 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2C6C 8310 
0053                                                   ;        as of register r8
0054 2C6E 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2C70 000F 
0055                       ;------------------------------------------------------
0056                       ; Copy memory
0057                       ;------------------------------------------------------
0058 2C72 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0059 2C74 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0060 2C76 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0061 2C78 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0062 2C7A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0063 2C7C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0064 2C7E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0065 2C80 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0066 2C82 0606  14         dec   tmp2
0067 2C84 16F6  14         jne   -!                    ; Loop until done
0068                       ;------------------------------------------------------
0069                       ; Switch to new workspace
0070                       ;------------------------------------------------------
0071 2C86 C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0072 2C88 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2C8A 2C90 
0073                                                   ; R14=PC
0074 2C8C 04CF  14         clr   r15                   ; R15=STATUS
0075                       ;------------------------------------------------------
0076                       ; If we get here, WS was copied to specified
0077                       ; destination.  Also contents of r13,r14,r15
0078                       ; are about to be overwritten by rtwp instruction.
0079                       ;------------------------------------------------------
0080 2C8E 0380  18         rtwp                        ; Activate copied workspace
0081                                                   ; in non-scratchpad memory!
0082               
0083               cpu.scrpad.pgout.after.rtwp:
0084 2C90 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2C92 2C22 
0085                                                   ; from @cpu.scrpad.tgt to @>8300
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               cpu.scrpad.pgout.exit:
0090 2C94 045B  20         b     *r11                  ; Return to caller
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
0113 2C96 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0114                       ;------------------------------------------------------
0115                       ; Copy scratchpad memory to destination
0116                       ;------------------------------------------------------
0117               xcpu.scrpad.pgin:
0118 2C98 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2C9A 8300 
0119 2C9C 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2C9E 0010 
0120                       ;------------------------------------------------------
0121                       ; Copy memory
0122                       ;------------------------------------------------------
0123 2CA0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0124 2CA2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0125 2CA4 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0126 2CA6 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0127 2CA8 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0128 2CAA CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0129 2CAC CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0130 2CAE CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0131 2CB0 0606  14         dec   tmp2
0132 2CB2 16F6  14         jne   -!                    ; Loop until done
0133                       ;------------------------------------------------------
0134                       ; Switch workspace to scratchpad memory
0135                       ;------------------------------------------------------
0136 2CB4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2CB6 8300 
0137                       ;------------------------------------------------------
0138                       ; Exit
0139                       ;------------------------------------------------------
0140               cpu.scrpad.pgin.exit:
0141 2CB8 045B  20         b     *r11                  ; Return to caller
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
0056 2CBA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2CBC 2CBE             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2CBE C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2CC0 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2CC2 A428 
0064 2CC4 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2CC6 201C 
0065 2CC8 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2CCA 8356 
0066 2CCC C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2CCE 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2CD0 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2CD2 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2CD4 A434 
0073                       ;---------------------------; Inline VSBR start
0074 2CD6 06C0  14         swpb  r0                    ;
0075 2CD8 D800  38         movb  r0,@vdpa              ; Send low byte
     2CDA 8C02 
0076 2CDC 06C0  14         swpb  r0                    ;
0077 2CDE D800  38         movb  r0,@vdpa              ; Send high byte
     2CE0 8C02 
0078 2CE2 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2CE4 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2CE6 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2CE8 0704  14         seto  r4                    ; Init counter
0086 2CEA 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2CEC A420 
0087 2CEE 0580  14 !       inc   r0                    ; Point to next char of name
0088 2CF0 0584  14         inc   r4                    ; Increment char counter
0089 2CF2 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2CF4 0007 
0090 2CF6 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2CF8 80C4  18         c     r4,r3                 ; End of name?
0093 2CFA 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2CFC 06C0  14         swpb  r0                    ;
0098 2CFE D800  38         movb  r0,@vdpa              ; Send low byte
     2D00 8C02 
0099 2D02 06C0  14         swpb  r0                    ;
0100 2D04 D800  38         movb  r0,@vdpa              ; Send high byte
     2D06 8C02 
0101 2D08 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2D0A 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2D0C DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2D0E 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2D10 2E26 
0109 2D12 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2D14 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2D16 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2D18 04E0  34         clr   @>83d0
     2D1A 83D0 
0118 2D1C C804  38         mov   r4,@>8354             ; Save name length for search (length
     2D1E 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2D20 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2D22 A432 
0121               
0122 2D24 0584  14         inc   r4                    ; Adjust for dot
0123 2D26 A804  38         a     r4,@>8356             ; Point to position after name
     2D28 8356 
0124 2D2A C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2D2C 8356 
     2D2E A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2D30 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2D32 83E0 
0130 2D34 04C1  14         clr   r1                    ; Version found of dsr
0131 2D36 020C  20         li    r12,>0f00             ; Init cru address
     2D38 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2D3A C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2D3C 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2D3E 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2D40 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2D42 0100 
0145 2D44 04E0  34         clr   @>83d0                ; Clear in case we are done
     2D46 83D0 
0146 2D48 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2D4A 2000 
0147 2D4C 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2D4E C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2D50 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2D52 1D00  20         sbo   0                     ; Turn on ROM
0154 2D54 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2D56 4000 
0155 2D58 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2D5A 2E22 
0156 2D5C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2D5E A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2D60 A40A 
0166 2D62 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2D64 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2D66 83D2 
0172                                                   ; subprogram
0173               
0174 2D68 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2D6A C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2D6C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2D6E C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2D70 83D2 
0183                                                   ; subprogram
0184               
0185 2D72 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2D74 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2D76 04C5  14         clr   r5                    ; Remove any old stuff
0194 2D78 D160  34         movb  @>8355,r5             ; Get length as counter
     2D7A 8355 
0195 2D7C 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2D7E 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2D80 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2D82 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2D84 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2D86 A420 
0206 2D88 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2D8A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2D8C 0605  14         dec   r5                    ; Update loop counter
0211 2D8E 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2D90 0581  14         inc   r1                    ; Next version found
0217 2D92 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2D94 A42A 
0218 2D96 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2D98 A42C 
0219 2D9A C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2D9C A430 
0220               
0221 2D9E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2DA0 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2DA2 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2DA4 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2DA6 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2DA8 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2DAA A400 
0233 2DAC C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2DAE C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2DB0 A428 
0239                                                   ; (8 or >a)
0240 2DB2 0281  22         ci    r1,8                  ; was it 8?
     2DB4 0008 
0241 2DB6 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2DB8 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2DBA 8350 
0243                                                   ; Get error byte from @>8350
0244 2DBC 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2DBE 06C0  14         swpb  r0                    ;
0252 2DC0 D800  38         movb  r0,@vdpa              ; send low byte
     2DC2 8C02 
0253 2DC4 06C0  14         swpb  r0                    ;
0254 2DC6 D800  38         movb  r0,@vdpa              ; send high byte
     2DC8 8C02 
0255 2DCA D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2DCC 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2DCE 09D1  56         srl   r1,13                 ; just keep error bits
0263 2DD0 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2DD2 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2DD4 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2DD6 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2DD8 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2DDA 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2DDC 06C1  14         swpb  r1                    ; put error in hi byte
0279 2DDE D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2DE0 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2DE2 201C 
0281                                                   ; / to indicate error
0282 2DE4 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2DE6 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2DE8 2DEA             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2DEA 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2DEC 83E0 
0316               
0317 2DEE 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2DF0 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2DF2 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2DF4 A42A 
0322 2DF6 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2DF8 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2DFA C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2DFC 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2DFE C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2E00 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2E02 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2E04 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2E06 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2E08 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2E0A 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2E0C 4000 
     2E0E 2E22 
0337 2E10 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2E12 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2E14 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2E16 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2E18 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2E1A A400 
0355 2E1C C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2E1E A434 
0356               
0357 2E20 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2E22 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2E24 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2E26 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2E28 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2E2A C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2E2C 0649  14         dect  stack
0052 2E2E C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2E30 0204  20         li    tmp0,dsrlnk.savcru
     2E32 A42A 
0057 2E34 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2E36 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2E38 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2E3A 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2E3C 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2E3E 37D7 
0065 2E40 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2E42 8370 
0066                                                   ; / location
0067 2E44 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2E46 A44C 
0068 2E48 04C5  14         clr   tmp1                  ; io.op.open
0069 2E4A 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2E4C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2E4E 0649  14         dect  stack
0097 2E50 C64B  30         mov   r11,*stack            ; Save return address
0098 2E52 0205  20         li    tmp1,io.op.close      ; io.op.close
     2E54 0001 
0099 2E56 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2E58 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2E5A 0649  14         dect  stack
0125 2E5C C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2E5E 0205  20         li    tmp1,io.op.read       ; io.op.read
     2E60 0002 
0128 2E62 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2E64 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2E66 0649  14         dect  stack
0155 2E68 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2E6A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2E6C 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2E6E 0005 
0159               
0160 2E70 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2E72 A43E 
0161               
0162 2E74 06A0  32         bl    @xvputb               ; Write character count to PAB
     2E76 22DA 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2E78 0205  20         li    tmp1,io.op.write      ; io.op.write
     2E7A 0003 
0167 2E7C 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2E7E 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2E80 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2E82 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2E84 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2E86 1000  14         nop
0189               
0190               
0191               file.status:
0192 2E88 1000  14         nop
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
0227 2E8A C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2E8C A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2E8E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2E90 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2E92 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2E94 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2E96 22DA 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2E98 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2E9A 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2E9C C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2E9E A44C 
0246               
0247 2EA0 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2EA2 22DA 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2EA4 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2EA6 0009 
0254 2EA8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2EAA 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2EAC C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2EAE 8322 
     2EB0 833C 
0259               
0260 2EB2 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2EB4 A42A 
0261 2EB6 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2EB8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2EBA 2CBA 
0268 2EBC 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2EBE 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2EC0 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2EC2 2DE6 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2EC4 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2EC6 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2EC8 833C 
     2ECA 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2ECC C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2ECE A436 
0292 2ED0 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2ED2 0005 
0293 2ED4 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2ED6 22F2 
0294 2ED8 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2EDA C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2EDC C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2EDE 045B  20         b     *r11                  ; Return to caller
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
0020 2EE0 0300  24 tmgr    limi  0                     ; No interrupt processing
     2EE2 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2EE4 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2EE6 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2EE8 2360  38         coc   @wbit2,r13            ; C flag on ?
     2EEA 201C 
0029 2EEC 1602  14         jne   tmgr1a                ; No, so move on
0030 2EEE E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2EF0 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2EF2 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2EF4 2020 
0035 2EF6 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2EF8 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2EFA 2010 
0048 2EFC 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2EFE 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2F00 200E 
0050 2F02 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2F04 0460  28         b     @kthread              ; Run kernel thread
     2F06 2F7E 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2F08 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2F0A 2014 
0056 2F0C 13EB  14         jeq   tmgr1
0057 2F0E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2F10 2012 
0058 2F12 16E8  14         jne   tmgr1
0059 2F14 C120  34         mov   @wtiusr,tmp0
     2F16 832E 
0060 2F18 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2F1A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2F1C 2F7C 
0065 2F1E C10A  18         mov   r10,tmp0
0066 2F20 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2F22 00FF 
0067 2F24 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2F26 201C 
0068 2F28 1303  14         jeq   tmgr5
0069 2F2A 0284  22         ci    tmp0,60               ; 1 second reached ?
     2F2C 003C 
0070 2F2E 1002  14         jmp   tmgr6
0071 2F30 0284  22 tmgr5   ci    tmp0,50
     2F32 0032 
0072 2F34 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2F36 1001  14         jmp   tmgr8
0074 2F38 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2F3A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2F3C 832C 
0079 2F3E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2F40 FF00 
0080 2F42 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2F44 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2F46 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2F48 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2F4A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2F4C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2F4E 830C 
     2F50 830D 
0089 2F52 1608  14         jne   tmgr10                ; No, get next slot
0090 2F54 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2F56 FF00 
0091 2F58 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2F5A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2F5C 8330 
0096 2F5E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2F60 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2F62 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2F64 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2F66 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2F68 8315 
     2F6A 8314 
0103 2F6C 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2F6E 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2F70 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2F72 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2F74 10F7  14         jmp   tmgr10                ; Process next slot
0108 2F76 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2F78 FF00 
0109 2F7A 10B4  14         jmp   tmgr1
0110 2F7C 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2F7E E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2F80 2010 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2F82 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2F84 2006 
0023 2F86 1602  14         jne   kthread_kb
0024 2F88 06A0  32         bl    @sdpla1               ; Run sound player
     2F8A 283A 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2F8C 06A0  32         bl    @realkb               ; Scan full keyboard
     2F8E 28BA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2F90 0460  28         b     @tmgr3                ; Exit
     2F92 2F08 
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
0017 2F94 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2F96 832E 
0018 2F98 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2F9A 2012 
0019 2F9C 045B  20 mkhoo1  b     *r11                  ; Return
0020      2EE4     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2F9E 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2FA0 832E 
0029 2FA2 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2FA4 FEFF 
0030 2FA6 045B  20         b     *r11                  ; Return
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
0017 2FA8 C13B  30 mkslot  mov   *r11+,tmp0
0018 2FAA C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2FAC C184  18         mov   tmp0,tmp2
0023 2FAE 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2FB0 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2FB2 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2FB4 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2FB6 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2FB8 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2FBA 881B  46         c     *r11,@w$ffff          ; End of list ?
     2FBC 2022 
0035 2FBE 1301  14         jeq   mkslo1                ; Yes, exit
0036 2FC0 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2FC2 05CB  14 mkslo1  inct  r11
0041 2FC4 045B  20         b     *r11                  ; Exit
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
0052 2FC6 C13B  30 clslot  mov   *r11+,tmp0
0053 2FC8 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2FCA A120  34         a     @wtitab,tmp0          ; Add table base
     2FCC 832C 
0055 2FCE 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2FD0 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2FD2 045B  20         b     *r11                  ; Exit
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
0068 2FD4 C13B  30 rsslot  mov   *r11+,tmp0
0069 2FD6 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2FD8 A120  34         a     @wtitab,tmp0          ; Add table base
     2FDA 832C 
0071 2FDC 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2FDE C154  26         mov   *tmp0,tmp1
0073 2FE0 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2FE2 FF00 
0074 2FE4 C505  30         mov   tmp1,*tmp0
0075 2FE6 045B  20         b     *r11                  ; Exit
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
0261 2FE8 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2FEA 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 2FEC 0300  24 runli1  limi  0                     ; Turn off interrupts
     2FEE 0000 
0267 2FF0 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2FF2 8300 
0268 2FF4 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2FF6 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 2FF8 0202  20 runli2  li    r2,>8308
     2FFA 8308 
0273 2FFC 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 2FFE 0282  22         ci    r2,>8400
     3000 8400 
0275 3002 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 3004 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     3006 FFFF 
0280 3008 1602  14         jne   runli4                ; No, continue
0281 300A 0420  54         blwp  @0                    ; Yes, bye bye
     300C 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 300E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     3010 833C 
0286 3012 04C1  14         clr   r1                    ; Reset counter
0287 3014 0202  20         li    r2,10                 ; We test 10 times
     3016 000A 
0288 3018 C0E0  34 runli5  mov   @vdps,r3
     301A 8802 
0289 301C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     301E 2020 
0290 3020 1302  14         jeq   runli6
0291 3022 0581  14         inc   r1                    ; Increase counter
0292 3024 10F9  14         jmp   runli5
0293 3026 0602  14 runli6  dec   r2                    ; Next test
0294 3028 16F7  14         jne   runli5
0295 302A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     302C 1250 
0296 302E 1202  14         jle   runli7                ; No, so it must be NTSC
0297 3030 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     3032 201C 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 3034 06A0  32 runli7  bl    @loadmc
     3036 2228 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 3038 04C1  14 runli9  clr   r1
0306 303A 04C2  14         clr   r2
0307 303C 04C3  14         clr   r3
0308 303E 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     3040 AF00 
0309 3042 020F  20         li    r15,vdpw              ; Set VDP write address
     3044 8C00 
0311 3046 06A0  32         bl    @mute                 ; Mute sound generators
     3048 27FE 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 304A 0280  22         ci    r0,>4a4a              ; Crash flag set?
     304C 4A4A 
0318 304E 1605  14         jne   runlia
0319 3050 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     3052 229C 
0320 3054 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     3056 0000 
     3058 3000 
0325 305A 06A0  32 runlia  bl    @filv
     305C 229C 
0326 305E 0FC0             data  pctadr,spfclr,16      ; Load color table
     3060 00F4 
     3062 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 3064 06A0  32         bl    @f18unl               ; Unlock the F18A
     3066 2740 
0334 3068 06A0  32         bl    @f18chk               ; Check if F18A is there
     306A 2760 
0335 306C 06A0  32         bl    @f18lck               ; Lock the F18A again
     306E 2756 
0336               
0337 3070 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     3072 2340 
0338 3074 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 3076 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     3078 2306 
0352 307A 3446             data  spvmod                ; Equate selected video mode table
0353 307C 0204  20         li    tmp0,spfont           ; Get font option
     307E 000C 
0354 3080 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 3082 1304  14         jeq   runlid                ; Yes, skip it
0356 3084 06A0  32         bl    @ldfnt
     3086 236E 
0357 3088 1100             data  fntadr,spfont         ; Load specified font
     308A 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 308C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     308E 4A4A 
0362 3090 1602  14         jne   runlie                ; No, continue
0363 3092 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     3094 2086 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 3096 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     3098 0040 
0368 309A 0460  28         b     @main                 ; Give control to main program
     309C 3728 
**** **** ****     > resident.asm.3440585
0042                       copy  "ram.resident.asm"
**** **** ****     > ram.resident.asm
0001               * FILE......: ram.resident.asm
0002               * Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"        ; ROM bankswitch trampoline
**** **** ****     > rom.farjump.asm
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
0021 309E C13B  30         mov   *r11+,tmp0            ; P0
0022 30A0 C17B  30         mov   *r11+,tmp1            ; P1
0023 30A2 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 30A4 0649  14         dect  stack
0029 30A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 30A8 0649  14         dect  stack
0031 30AA C645  30         mov   tmp1,*stack           ; Push tmp1
0032 30AC 0649  14         dect  stack
0033 30AE C646  30         mov   tmp2,*stack           ; Push tmp2
0034 30B0 0649  14         dect  stack
0035 30B2 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 30B4 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     30B6 6000 
0040 30B8 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 30BA C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     30BC A226 
0044 30BE 0647  14         dect  tmp3
0045 30C0 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 30C2 0647  14         dect  tmp3
0047 30C4 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 30C6 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     30C8 A226 
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 30CA 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 30CC 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 30CE 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 30D0 0224  22         ai    tmp0,>0800
     30D2 0800 
0066 30D4 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 30D6 0285  22         ci    tmp1,>ffff
     30D8 FFFF 
0075 30DA 1602  14         jne   !
0076 30DC C160  34         mov   @parm1,tmp1
     30DE A000 
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 30E0 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 30E2 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 30E4 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 30E6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     30E8 FFCE 
0092 30EA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     30EC 2026 
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 30EE 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 30F0 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     30F2 A226 
0103 30F4 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 30F6 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 30F8 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 30FA C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 30FC 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 30FE 028B  22         ci    r11,>6000
     3100 6000 
0116 3102 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 3104 028B  22         ci    r11,>7fff
     3106 7FFF 
0118 3108 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 310A C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     310C A226 
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 310E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 3110 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 3112 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 3114 0225  22         ai    tmp1,>0800
     3116 0800 
0138 3118 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 311A 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 311C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     311E FFCE 
0145 3120 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3122 2026 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 3124 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 3126 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 3128 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 312A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 312C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
0008                       copy  "fb.asm"                 ; Framebuffer
**** **** ****     > fb.asm
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
0020 312E 0649  14         dect  stack
0021 3130 C64B  30         mov   r11,*stack            ; Save return address
0022 3132 0649  14         dect  stack
0023 3134 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3136 0649  14         dect  stack
0025 3138 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 313A 0204  20         li    tmp0,fb.top
     313C D000 
0030 313E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3140 A300 
0031 3142 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3144 A304 
0032 3146 04E0  34         clr   @fb.row               ; Current row=0
     3148 A306 
0033 314A 04E0  34         clr   @fb.column            ; Current column=0
     314C A30C 
0034               
0035 314E 0204  20         li    tmp0,colrow
     3150 0050 
0036 3152 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     3154 A30E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 3156 C160  34         mov   @tv.ruler.visible,tmp1
     3158 A210 
0041 315A 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 315C 0204  20         li    tmp0,pane.botrow-2
     315E 001B 
0043 3160 1002  14         jmp   fb.init.cont
0044 3162 0204  20 !       li    tmp0,pane.botrow-1
     3164 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 3166 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     3168 A31A 
0050 316A C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     316C A31C 
0051               
0052 316E 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3170 A222 
0053 3172 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     3174 A310 
0054 3176 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     3178 A316 
0055 317A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     317C A318 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 317E 06A0  32         bl    @film
     3180 2244 
0060 3182 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     3184 0000 
     3186 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 3188 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 318A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 318C C2F9  30         mov   *stack+,r11           ; Pop r11
0068 318E 045B  20         b     *r11                  ; Return to caller
0069               
**** **** ****     > ram.resident.asm
0009                       copy  "idx.asm"                ; Index management
**** **** ****     > idx.asm
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
0013               *  MSB = SAMS Page 00-ff
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
0027               ***************************************************************
0028               
0029               
0030               ***************************************************************
0031               * idx.init
0032               * Initialize index
0033               ***************************************************************
0034               * bl @idx.init
0035               *--------------------------------------------------------------
0036               * INPUT
0037               * none
0038               *--------------------------------------------------------------
0039               * OUTPUT
0040               * none
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0
0044               ********|*****|*********************|**************************
0045               idx.init:
0046 3190 0649  14         dect  stack
0047 3192 C64B  30         mov   r11,*stack            ; Save return address
0048 3194 0649  14         dect  stack
0049 3196 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 3198 0204  20         li    tmp0,idx.top
     319A B000 
0054 319C C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     319E A502 
0055               
0056 31A0 C120  34         mov   @tv.sams.b000,tmp0
     31A2 A206 
0057 31A4 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     31A6 A600 
0058 31A8 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     31AA A602 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 31AC 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     31AE 0004 
0063 31B0 C804  38         mov   tmp0,@idx.sams.hipage ; /
     31B2 A604 
0064               
0065 31B4 06A0  32         bl    @_idx.sams.mapcolumn.on
     31B6 31D2 
0066                                                   ; Index in continuous memory region
0067               
0068 31B8 06A0  32         bl    @film
     31BA 2244 
0069 31BC B000                   data idx.top,>00,idx.size * 5
     31BE 0000 
     31C0 5000 
0070                                                   ; Clear index
0071               
0072 31C2 06A0  32         bl    @_idx.sams.mapcolumn.off
     31C4 3206 
0073                                                   ; Restore memory window layout
0074               
0075 31C6 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     31C8 A602 
     31CA A604 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 31CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 31CE C2F9  30         mov   *stack+,r11           ; Pop r11
0083 31D0 045B  20         b     *r11                  ; Return to caller
0084               
0085               
0086               ***************************************************************
0087               * bl @_idx.sams.mapcolumn.on
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0, tmp1, tmp2
0091               *--------------------------------------------------------------
0092               *  Remarks
0093               *  Private, only to be called from inside idx module
0094               ********|*****|*********************|**************************
0095               _idx.sams.mapcolumn.on:
0096 31D2 0649  14         dect  stack
0097 31D4 C64B  30         mov   r11,*stack            ; Push return address
0098 31D6 0649  14         dect  stack
0099 31D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 31DA 0649  14         dect  stack
0101 31DC C645  30         mov   tmp1,*stack           ; Push tmp1
0102 31DE 0649  14         dect  stack
0103 31E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 31E2 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     31E4 A602 
0108 31E6 0205  20         li    tmp1,idx.top
     31E8 B000 
0109 31EA 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     31EC 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 31EE 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     31F0 2584 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 31F2 0584  14         inc   tmp0                  ; Next SAMS index page
0118 31F4 0225  22         ai    tmp1,>1000            ; Next memory region
     31F6 1000 
0119 31F8 0606  14         dec   tmp2                  ; Update loop counter
0120 31FA 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 31FC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 31FE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 3200 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 3202 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3204 045B  20         b     *r11                  ; Return to caller
0130               
0131               
0132               ***************************************************************
0133               * _idx.sams.mapcolumn.off
0134               * Restore normal SAMS layout again (single index page)
0135               ***************************************************************
0136               * bl @_idx.sams.mapcolumn.off
0137               *--------------------------------------------------------------
0138               * Register usage
0139               * tmp0, tmp1, tmp2, tmp3
0140               *--------------------------------------------------------------
0141               *  Remarks
0142               *  Private, only to be called from inside idx module
0143               ********|*****|*********************|**************************
0144               _idx.sams.mapcolumn.off:
0145 3206 0649  14         dect  stack
0146 3208 C64B  30         mov   r11,*stack            ; Push return address
0147 320A 0649  14         dect  stack
0148 320C C644  30         mov   tmp0,*stack           ; Push tmp0
0149 320E 0649  14         dect  stack
0150 3210 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 3212 0649  14         dect  stack
0152 3214 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 3216 0649  14         dect  stack
0154 3218 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 321A 0205  20         li    tmp1,idx.top
     321C B000 
0159 321E 0206  20         li    tmp2,5                ; Always 5 pages
     3220 0005 
0160 3222 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3224 A206 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 3226 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 3228 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     322A 2584 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 322C 0225  22         ai    tmp1,>1000            ; Next memory region
     322E 1000 
0171 3230 0606  14         dec   tmp2                  ; Update loop counter
0172 3232 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3234 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 3236 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 3238 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 323A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 323C C2F9  30         mov   *stack+,r11           ; Pop return address
0182 323E 045B  20         b     *r11                  ; Return to caller
0183               
0184               
0185               
0186               ***************************************************************
0187               * _idx.samspage.get
0188               * Get SAMS page for index
0189               ***************************************************************
0190               * bl @_idx.samspage.get
0191               *--------------------------------------------------------------
0192               * INPUT
0193               * tmp0 = Line number
0194               *--------------------------------------------------------------
0195               * OUTPUT
0196               * @outparm1 = Offset for index entry in index SAMS page
0197               *--------------------------------------------------------------
0198               * Register usage
0199               * tmp0, tmp1, tmp2
0200               *--------------------------------------------------------------
0201               *  Remarks
0202               *  Private, only to be called from inside idx module.
0203               *  Activates SAMS page containing required index slot entry.
0204               ********|*****|*********************|**************************
0205               _idx.samspage.get:
0206 3240 0649  14         dect  stack
0207 3242 C64B  30         mov   r11,*stack            ; Save return address
0208 3244 0649  14         dect  stack
0209 3246 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 3248 0649  14         dect  stack
0211 324A C645  30         mov   tmp1,*stack           ; Push tmp1
0212 324C 0649  14         dect  stack
0213 324E C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 3250 C184  18         mov   tmp0,tmp2             ; Line number
0218 3252 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 3254 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     3256 0800 
0220               
0221 3258 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 325A 0A16  56         sla   tmp2,1                ; line number * 2
0226 325C C806  38         mov   tmp2,@outparm1        ; Offset index entry
     325E A010 
0227               
0228 3260 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3262 A602 
0229 3264 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     3266 A600 
0230               
0231 3268 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 326A C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     326C A600 
0237 326E C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3270 A206 
0238               
0239 3272 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 3274 0205  20         li    tmp1,>b000            ; Memory window for index page
     3276 B000 
0241               
0242 3278 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     327A 2584 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 327C 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     327E A604 
0249 3280 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 3282 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     3284 A604 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 3286 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 3288 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 328A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 328C C2F9  30         mov   *stack+,r11           ; Pop r11
0260 328E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
0010                       copy  "edb.asm"                ; Editor Buffer
**** **** ****     > edb.asm
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
0022 3290 0649  14         dect  stack
0023 3292 C64B  30         mov   r11,*stack            ; Save return address
0024 3294 0649  14         dect  stack
0025 3296 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3298 0204  20         li    tmp0,edb.top          ; \
     329A C000 
0030 329C C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     329E A500 
0031 32A0 C804  38         mov   tmp0,@edb.next_free.ptr
     32A2 A508 
0032                                                   ; Set pointer to next free line
0033               
0034 32A4 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     32A6 A50A 
0035               
0036 32A8 0204  20         li    tmp0,1
     32AA 0001 
0037 32AC C804  38         mov   tmp0,@edb.lines       ; Lines=1
     32AE A504 
0038               
0039 32B0 0720  34         seto  @edb.block.m1         ; Reset block start line
     32B2 A50C 
0040 32B4 0720  34         seto  @edb.block.m2         ; Reset block end line
     32B6 A50E 
0041               
0042 32B8 0204  20         li    tmp0,txt.newfile      ; "New file"
     32BA 3576 
0043 32BC C804  38         mov   tmp0,@edb.filename.ptr
     32BE A512 
0044               
0045 32C0 0204  20         li    tmp0,txt.filetype.none
     32C2 362E 
0046 32C4 C804  38         mov   tmp0,@edb.filetype.ptr
     32C6 A514 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 32C8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 32CA C2F9  30         mov   *stack+,r11           ; Pop r11
0054 32CC 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > ram.resident.asm
0011                       copy  "cmdb.asm"               ; Command buffer
**** **** ****     > cmdb.asm
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
0022 32CE 0649  14         dect  stack
0023 32D0 C64B  30         mov   r11,*stack            ; Save return address
0024 32D2 0649  14         dect  stack
0025 32D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 32D6 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     32D8 E000 
0030 32DA C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     32DC A700 
0031               
0032 32DE 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     32E0 A702 
0033 32E2 0204  20         li    tmp0,4
     32E4 0004 
0034 32E6 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     32E8 A706 
0035 32EA C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     32EC A708 
0036               
0037 32EE 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     32F0 A716 
0038 32F2 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     32F4 A718 
0039 32F6 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     32F8 A726 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 32FA 06A0  32         bl    @film
     32FC 2244 
0044 32FE E000             data  cmdb.top,>00,cmdb.size
     3300 0000 
     3302 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3304 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3306 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3308 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
0012                       copy  "errline.asm"            ; Error line
**** **** ****     > errline.asm
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
0022 330A 0649  14         dect  stack
0023 330C C64B  30         mov   r11,*stack            ; Save return address
0024 330E 0649  14         dect  stack
0025 3310 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3312 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3314 A228 
0030               
0031 3316 06A0  32         bl    @film
     3318 2244 
0032 331A A22A                   data tv.error.msg,0,160
     331C 0000 
     331E 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3320 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3322 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3324 045B  20         b     *r11                  ; Return to caller
0040               
**** **** ****     > ram.resident.asm
0013                       copy  "tv.asm"                 ; Main editor configuration
**** **** ****     > tv.asm
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
0022 3326 0649  14         dect  stack
0023 3328 C64B  30         mov   r11,*stack            ; Save return address
0024 332A 0649  14         dect  stack
0025 332C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 332E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3330 0001 
0030 3332 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3334 A212 
0031               
0032 3336 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3338 A224 
0033 333A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     333C 200C 
0034               
0035 333E 0204  20         li    tmp0,fj.bottom
     3340 B000 
0036 3342 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3344 A226 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 3346 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 3348 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 334A 045B  20         b     *r11                  ; Return to caller
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
0065 334C 0649  14         dect  stack
0066 334E C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 3350 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3352 32CE 
0071 3354 06A0  32         bl    @edb.init             ; Initialize editor buffer
     3356 3290 
0072 3358 06A0  32         bl    @idx.init             ; Initialize index
     335A 3190 
0073 335C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     335E 312E 
0074 3360 06A0  32         bl    @errline.init         ; Initialize error line
     3362 330A 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 3364 06A0  32         bl    @hchar
     3366 27D6 
0079 3368 0034                   byte 0,52,32,18           ; Remove markers
     336A 2012 
0080 336C 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     336E 2033 
0081 3370 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 3372 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 3374 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
0014                       copy  "tv.utils.asm"           ; General purpose utility functions
**** **** ****     > tv.utils.asm
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
0020 3376 0649  14         dect  stack
0021 3378 C64B  30         mov   r11,*stack            ; Save return address
0022 337A 0649  14         dect  stack
0023 337C C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 337E 06A0  32         bl    @mknum                ; Convert unsigned number to string
     3380 2AA4 
0028 3382 A000                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 3384 A140                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 3386 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 3388 0204  20         li    tmp0,unpacked.string
     338A A026 
0034 338C 04F4  30         clr   *tmp0+                ; Clear string 01
0035 338E 04F4  30         clr   *tmp0+                ; Clear string 23
0036 3390 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 3392 06A0  32         bl    @trimnum              ; Trim unsigned number string
     3394 2AFC 
0039 3396 A140                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 3398 A026                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 339A 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 339C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 339E C2F9  30         mov   *stack+,r11           ; Pop r11
0048 33A0 045B  20         b     *r11                  ; Return to caller
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
0073 33A2 0649  14         dect  stack
0074 33A4 C64B  30         mov   r11,*stack            ; Push return address
0075 33A6 0649  14         dect  stack
0076 33A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 33AA 0649  14         dect  stack
0078 33AC C645  30         mov   tmp1,*stack           ; Push tmp1
0079 33AE 0649  14         dect  stack
0080 33B0 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 33B2 0649  14         dect  stack
0082 33B4 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 33B6 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     33B8 A000 
0087 33BA D194  26         movb  *tmp0,tmp2            ; /
0088 33BC 0986  56         srl   tmp2,8                ; Right align
0089 33BE C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 33C0 8806  38         c     tmp2,@parm2           ; String length > requested length?
     33C2 A002 
0092 33C4 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 33C6 C120  34         mov   @parm1,tmp0           ; Get source address
     33C8 A000 
0097 33CA C160  34         mov   @parm4,tmp1           ; Get destination address
     33CC A006 
0098 33CE 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 33D0 0649  14         dect  stack
0101 33D2 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 33D4 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     33D6 24EE 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 33D8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 33DA C120  34         mov   @parm2,tmp0           ; Get requested length
     33DC A002 
0113 33DE 0A84  56         sla   tmp0,8                ; Left align
0114 33E0 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     33E2 A006 
0115 33E4 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 33E6 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 33E8 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 33EA C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     33EC A002 
0122 33EE 6187  18         s     tmp3,tmp2             ; |
0123 33F0 0586  14         inc   tmp2                  ; /
0124               
0125 33F2 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     33F4 A004 
0126 33F6 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 33F8 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 33FA 0606  14         dec   tmp2                  ; Update loop counter
0133 33FC 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 33FE C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3400 A006 
     3402 A010 
0136 3404 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 3406 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3408 FFCE 
0142 340A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     340C 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 340E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3410 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3412 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3414 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 3416 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 3418 045B  20         b     *r11                  ; Return to caller
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
0174 341A 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     341C 27AA 
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 341E 04E0  34         clr   @bank0.rom            ; Activate bank 0
     3420 6000 
0179 3422 0420  54         blwp  @0                    ; Reset to monitor
     3424 0000 
**** **** ****     > ram.resident.asm
0015                       copy  "mem.asm"                ; Memory Management (SAMS)
**** **** ****     > mem.asm
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
0017 3426 0649  14         dect  stack
0018 3428 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 342A 06A0  32         bl    @sams.layout
     342C 25F0 
0023 342E 345E                   data mem.sams.layout.data
0024               
0025 3430 06A0  32         bl    @sams.layout.copy
     3432 2654 
0026 3434 A200                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 3436 C820  54         mov   @tv.sams.c000,@edb.sams.page
     3438 A208 
     343A A516 
0029 343C C820  54         mov   @edb.sams.page,@edb.sams.hipage
     343E A516 
     3440 A518 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 3442 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 3444 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.asm
0016                       copy  "data.constants.asm"     ; Data Constants
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
0033 3446 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3448 003F 
     344A 0243 
     344C 05F4 
     344E 0050 
0034               
0035               romsat:
0036 3450 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     3452 0201 
0037 3454 0000             data  >0000,>0301             ; Current line indicator
     3456 0301 
0038 3458 0820             data  >0820,>0401             ; Current line indicator
     345A 0401 
0039               nosprite:
0040 345C D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 345E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     3460 0002 
0048 3462 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     3464 0003 
0049 3466 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     3468 000A 
0050               
0051 346A B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     346C 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 346E C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     3470 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 3472 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     3474 000D 
0060 3476 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     3478 000E 
0061 347A F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     347C 000F 
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
0117 347E F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     3480 F171 
     3482 1B1F 
     3484 71B1 
0118 3486 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     3488 F0FF 
     348A 1F1A 
     348C F1FF 
0119 348E 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     3490 F0FF 
     3492 1F12 
     3494 F1F6 
0120 3496 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3498 1E11 
     349A 1A17 
     349C 1E11 
0121 349E E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     34A0 E1FF 
     34A2 1F1E 
     34A4 E1FF 
0122 34A6 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     34A8 1016 
     34AA 1B71 
     34AC 1711 
0123 34AE 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     34B0 1011 
     34B2 F1F1 
     34B4 1F11 
0124 34B6 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     34B8 A1FF 
     34BA 1F1F 
     34BC F11F 
0125 34BE 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     34C0 12FF 
     34C2 1B12 
     34C4 12FF 
0126 34C6 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     34C8 E1FF 
     34CA 1B1F 
     34CC F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 34CE 0007             byte  0,7,12,25               ; \   Default tab positions as used
     34D0 0C19 
0131 34D2 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     34D4 3B4F 
0132 34D6 FF00             byte  >ff,0,0,0               ; |
     34D8 0000 
0133 34DA 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     34DC 0000 
0134 34DE 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     34E0 0000 
0135                       even
**** **** ****     > ram.resident.asm
0017                       copy  "data.strings.asm"       ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               txt.delim
0009 34E2 012C             byte  1
0010 34E3 ....             text  ','
0011                       even
0012               
0013               txt.bottom
0014 34E4 0520             byte  5
0015 34E5 ....             text  '  BOT'
0016                       even
0017               
0018               txt.ovrwrite
0019 34EA 034F             byte  3
0020 34EB ....             text  'OVR'
0021                       even
0022               
0023               txt.insert
0024 34EE 0349             byte  3
0025 34EF ....             text  'INS'
0026                       even
0027               
0028               txt.star
0029 34F2 012A             byte  1
0030 34F3 ....             text  '*'
0031                       even
0032               
0033               txt.loading
0034 34F4 0A4C             byte  10
0035 34F5 ....             text  'Loading...'
0036                       even
0037               
0038               txt.saving
0039 3500 0A53             byte  10
0040 3501 ....             text  'Saving....'
0041                       even
0042               
0043               txt.block.del
0044 350C 1244             byte  18
0045 350D ....             text  'Deleting block....'
0046                       even
0047               
0048               txt.block.copy
0049 3520 1143             byte  17
0050 3521 ....             text  'Copying block....'
0051                       even
0052               
0053               txt.block.move
0054 3532 104D             byte  16
0055 3533 ....             text  'Moving block....'
0056                       even
0057               
0058               txt.block.save
0059 3544 1D53             byte  29
0060 3545 ....             text  'Saving block to DV80 file....'
0061                       even
0062               
0063               txt.fastmode
0064 3562 0846             byte  8
0065 3563 ....             text  'Fastmode'
0066                       even
0067               
0068               txt.kb
0069 356C 026B             byte  2
0070 356D ....             text  'kb'
0071                       even
0072               
0073               txt.lines
0074 3570 054C             byte  5
0075 3571 ....             text  'Lines'
0076                       even
0077               
0078               txt.newfile
0079 3576 0A5B             byte  10
0080 3577 ....             text  '[New file]'
0081                       even
0082               
0083               txt.filetype.dv80
0084 3582 0444             byte  4
0085 3583 ....             text  'DV80'
0086                       even
0087               
0088               txt.m1
0089 3588 034D             byte  3
0090 3589 ....             text  'M1='
0091                       even
0092               
0093               txt.m2
0094 358C 034D             byte  3
0095 358D ....             text  'M2='
0096                       even
0097               
0098               txt.keys.default
0099 3590 0746             byte  7
0100 3591 ....             text  'F9=Menu'
0101                       even
0102               
0103               txt.keys.block
0104 3598 3342             byte  51
0105 3599 ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0106                       even
0107               
0108 35CC ....     txt.ruler          text    '.........'
0109                                  byte    18
0110 35D6 ....                        text    '.........'
0111                                  byte    19
0112 35E0 ....                        text    '.........'
0113                                  byte    20
0114 35EA ....                        text    '.........'
0115                                  byte    21
0116 35F4 ....                        text    '.........'
0117                                  byte    22
0118 35FE ....                        text    '.........'
0119                                  byte    23
0120 3608 ....                        text    '.........'
0121                                  byte    24
0122 3612 ....                        text    '.........'
0123                                  byte    25
0124                                  even
0125 361C 020E     txt.alpha.down     data >020e,>0f00
     361E 0F00 
0126 3620 0110     txt.vertline       data >0110
0127 3622 011C     txt.keymarker      byte 1,28
0128               
0129               txt.ws1
0130 3624 0120             byte  1
0131 3625 ....             text  ' '
0132                       even
0133               
0134               txt.ws2
0135 3626 0220             byte  2
0136 3627 ....             text  '  '
0137                       even
0138               
0139               txt.ws3
0140 362A 0320             byte  3
0141 362B ....             text  '   '
0142                       even
0143               
0144               txt.ws4
0145 362E 0420             byte  4
0146 362F ....             text  '    '
0147                       even
0148               
0149               txt.ws5
0150 3634 0520             byte  5
0151 3635 ....             text  '     '
0152                       even
0153               
0154      362E     txt.filetype.none  equ txt.ws4
0155               
0156               
0157               ;--------------------------------------------------------------
0158               ; Strings for error line pane
0159               ;--------------------------------------------------------------
0160               txt.ioerr.load
0161 363A 2049             byte  32
0162 363B ....             text  'I/O error. Failed loading file: '
0163                       even
0164               
0165               txt.ioerr.save
0166 365C 2049             byte  32
0167 365D ....             text  'I/O error. Failed saving file:  '
0168                       even
0169               
0170               txt.memfull.load
0171 367E 4049             byte  64
0172 367F ....             text  'Index memory full. Could not fully load file into editor buffer.'
0173                       even
0174               
0175               txt.io.nofile
0176 36C0 2149             byte  33
0177 36C1 ....             text  'I/O error. No filename specified.'
0178                       even
0179               
0180               txt.block.inside
0181 36E2 3445             byte  52
0182 36E3 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0183                       even
0184               
0185               
0186               ;--------------------------------------------------------------
0187               ; Strings for command buffer
0188               ;--------------------------------------------------------------
0189               txt.cmdb.prompt
0190 3718 013E             byte  1
0191 3719 ....             text  '>'
0192                       even
0193               
0194               txt.colorscheme
0195 371A 0D43             byte  13
0196 371B ....             text  'Color scheme:'
0197                       even
0198               
**** **** ****     > resident.asm.3440585
0043                       ;------------------------------------------------------
0044                       ; Activate bank 1 and branch to >6046
0045                       ;------------------------------------------------------
0046               main:
0047 3728 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     372A 6002 
0048               
0052               
0053 372C 0460  28         b     @kickstart.code2      ; Jump to entry routine
     372E 6046 
0054                       ;------------------------------------------------------
0055                       ; Memory full check
0056                       ;------------------------------------------------------
0058               
0062 3730 3730                   data $                ; Bank 0 ROM size OK.
0064               *--------------------------------------------------------------
0065               * Video mode configuration for SP2
0066               *--------------------------------------------------------------
0067      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0068      0004     spfbck  equ   >04                   ; Screen background color.
0069      3446     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0070      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0071      0050     colrow  equ   80                    ; Columns per row
0072      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0073      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0074      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0075      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
0076               

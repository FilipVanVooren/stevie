XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.3765856
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210807-3765856
0010               *
0011               * Bank 1 "James"
0012               *
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
0018      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0019      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0020      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0021      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0022      0001     skip_random_generator     equ  1       ; Skip random functions
0023      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0024      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0025               
0026               *--------------------------------------------------------------
0027               * Classic99 F18a 24x80, no FG99 advanced mode
0028               *--------------------------------------------------------------
0029      0001     device.f18a               equ  1       ; F18a GPU
0030      0000     device.9938               equ  0       ; 9938 GPU
0031      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode on
0032               
0033               
0034               *--------------------------------------------------------------
0035               * JS99er F18a 30x80, FG99 advanced mode
0036               *--------------------------------------------------------------
0037               ; device.f18a             equ  0       ; F18a GPU
0038               ; device.9938             equ  1       ; 9938 GPU
0039               ; device.fg99.mode.adv    equ  1       ; FG99 advanced mode on
**** **** ****     > stevie_b1.asm.3765856
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
0013               *--------------------------------------------------------------
0014               * RAM 4K banks (Only valid in advance mode FG99)
0015               *--------------------------------------------------------------
0016      6800     bank0.ram                 equ  >6800   ; Jill
0017      6802     bank1.ram                 equ  >6802   ; James
0018      6804     bank2.ram                 equ  >6804   ; Jacky
0019      6806     bank3.ram                 equ  >6806   ; John
0020      6808     bank4.ram                 equ  >6808   ; Janine
0021      680A     bank5.ram                 equ  >680a   ; Jumbo
**** **** ****     > stevie_b1.asm.3765856
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
0009               * LOW MEMORY EXPANSION (2000-2fff)
0010               *
0011               *     Mem range   Bytes    SAMS   Purpose
0012               *     =========   =====    ====   ==================================
0013               *     2000-2f1f    3872           SP2 library
0014               *     2f20-2f3f      32           Function input/output parameters
0015               *     2f40-2f43       4           Keyboard
0016               *     2f4a-2f59      16           Timer tasks table
0017               *     2f5a-2f69      16           Sprite attribute table in RAM
0018               *     2f6a-2f9f      54           RAM buffer
0019               *     2fa0-2fff      96           Value/Return stack (grows downwards from 2fff)
0020               *
0021               *
0022               * LOW MEMORY EXPANSION (3000-3fff)
0023               *
0024               *     Mem range   Bytes    SAMS   Purpose
0025               *     =========   =====    ====   ==================================
0026               *     3000-3fff    4096           Resident Stevie Modules
0027               *
0028               *
0029               * HIGH MEMORY EXPANSION (a000-ffff)
0030               *
0031               *     Mem range   Bytes    SAMS   Purpose
0032               *     =========   =====    ====   ==================================
0033               *     a000-a0ff     256           Stevie Editor shared structure
0034               *     a100-a1ff     256           Framebuffer structure
0035               *     a200-a2ff     256           Editor buffer structure
0036               *     a300-a3ff     256           Command buffer structure
0037               *     a400-a4ff     256           File handle structure
0038               *     a500-a5ff     256           Index structure
0039               *     a600-af5f    2400           Frame buffer
0040               *     af60-afff     ???           *FREE*
0041               *
0042               *     b000-bfff    4096           Index buffer page
0043               *     c000-cfff    4096           Editor buffer page
0044               *     d000-dfff    4096           CMDB history / Editor buffer page (temporary)
0045               *     e000-ebff    3072           Heap
0046               *     ec00-efff    1024           Farjump return stack (trampolines)
0047               *     f000-ffff    4096           *FREE*
0048               *
0049               *
0050               * CARTRIDGE SPACE (6000-7fff)
0051               *
0052               *     Mem range   Bytes    BANK   Purpose
0053               *     =========   =====    ====   ==================================
0054               *     6000-7f9b    8128       0   SP2 library, code to RAM, resident modules
0055               *     ..............................................................
0056               *     6000-603f      64       1   Vector table (32 vectors)
0057               *     6040-7fff    8128       1   Stevie program code
0058               *     ..............................................................
0059               *     6000-603f      64       2   Vector table (32 vectors)
0060               *     6040-7fff    8128       2   Stevie program code
0061               *     ..............................................................
0062               *     6000-603f      64       3   Vector table (32 vectors)
0063               *     6040-7fff    8128       3   Stevie program code
0064               *     ..............................................................
0065               *     6000-603f      64       4   Vector table (32 vectors)
0066               *     6040-7fff    8128       4   Stevie program code
0067               *     ..............................................................
0068               *     6000-603f      64       5   Vector table (32 vectors)
0069               *     6040-7fff    8128       5   Stevie program code
0070               *     ..............................................................
0071               *
0072               *
0073               * VDP RAM F18a (0000-47ff)
0074               *
0075               *     Mem range   Bytes    Hex    Purpose
0076               *     =========   =====   =====   =================================
0077               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0078               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0079               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0080               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0081               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0082               *                                      (Position based colors F18a, 80 colums)
0083               *     2180                        SAT: Sprite Attribute Table
0084               *                                      (Cursor in F18a, 80 cols mode)
0085               *     2800                        SPT: Sprite Pattern Table
0086               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0087               *===============================================================================
0088               
0089               *--------------------------------------------------------------
0090               * Graphics mode selection
0091               *--------------------------------------------------------------
0093               
0094      001D     pane.botrow               equ  29      ; Bottom row on screen
0095               
0101               *--------------------------------------------------------------
0102               * Stevie Dialog / Pane specific equates
0103               *--------------------------------------------------------------
0104      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0105      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0106               ;-----------------------------------------------------------------
0107               ;   Dialog ID's >= 100 indicate that command prompt should be
0108               ;   hidden and no characters added to CMDB keyboard buffer
0109               ;-----------------------------------------------------------------
0110      000A     id.dialog.load            equ  10      ; "Load DV80 file"
0111      000B     id.dialog.save            equ  11      ; "Save DV80 file"
0112      000C     id.dialog.saveblock       equ  12      ; "Save codeblock to DV80 file"
0113      0064     id.dialog.menu            equ  100     ; "Stevie Menu"
0114      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0115      0066     id.dialog.block           equ  102     ; "Block move/copy/delete"
0116      0067     id.dialog.about           equ  103     ; "About"
0117      0068     id.dialog.file            equ  104     ; "File"
0118               *--------------------------------------------------------------
0119               * Stevie specific equates
0120               *--------------------------------------------------------------
0121      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0122      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0123      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0124      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0125      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0126      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0127                                                      ; VDP TAT address of 1st CMDB row
0128      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0129                                                      ; VDP SIT size 80 columns, 24/30 rows
0130      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0131      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0132               *--------------------------------------------------------------
0133               * SPECTRA2 / Stevie startup options
0134               *--------------------------------------------------------------
0135      0001     debug                     equ  1       ; Turn on spectra2 debugging
0136      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0137      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0138      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0139               *--------------------------------------------------------------
0140               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0141               *--------------------------------------------------------------
0142      2F20     parm1             equ  >2f20           ; Function parameter 1
0143      2F22     parm2             equ  >2f22           ; Function parameter 2
0144      2F24     parm3             equ  >2f24           ; Function parameter 3
0145      2F26     parm4             equ  >2f26           ; Function parameter 4
0146      2F28     parm5             equ  >2f28           ; Function parameter 5
0147      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0148      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0149      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0150      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0151      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0152      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0153      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0154      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0155      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0156      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0157      2F3E     keyrptcnt         equ  >2f3e           ; Key repeat-count (auto-repeat function)
0158      2F40     keycode1          equ  >2f40           ; Current key scanned
0159      2F42     keycode2          equ  >2f42           ; Previous key scanned
0160      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0161      2F4A     timers            equ  >2f4a           ; Timer table
0162      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0163      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0164               *--------------------------------------------------------------
0165               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0166               *--------------------------------------------------------------
0167      A000     tv.top            equ  >a000           ; Structure begin
0168      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0169      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0170      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0171      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0172      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0173      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0174      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0175      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0176      A010     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0177      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0178      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0179      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0180      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0181      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0182      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0183      A01E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0184      A020     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0185      A022     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0186      A024     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0187      A026     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0188      A028     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0189      A02A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0190      A0CA     tv.free           equ  tv.top + 202    ; End of structure
0191               *--------------------------------------------------------------
0192               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0193               *--------------------------------------------------------------
0194      A100     fb.struct         equ  >a100           ; Structure begin
0195      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0196      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0197      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0198                                                      ; line X in editor buffer).
0199      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0200                                                      ; (offset 0 .. @fb.scrrows)
0201      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0202      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0203      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0204      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0205      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0206      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0207      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0208      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0209      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0210      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0211      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0212      A11E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0213      A16E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0214      A1BE     fb.free           equ  fb.struct + 190 ; End of structure
0215               *--------------------------------------------------------------
0216               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0217               *--------------------------------------------------------------
0218      A200     edb.struct        equ  >a200           ; Begin structure
0219      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0220      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0221      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0222      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0223      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0224      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0225      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0226      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0227      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0228      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0229                                                      ; with current filename.
0230      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0231                                                      ; with current file type.
0232      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0233      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0234      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0235                                                      ; for filename, but not always used.
0236      A269     edb.free          equ  edb.struct + 105; End of structure
0237               *--------------------------------------------------------------
0238               * Command buffer structure            @>a300-a3ff   (256 bytes)
0239               *--------------------------------------------------------------
0240      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0241      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0242      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0243      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0244      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0245      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0246      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0247      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0248      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0249      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0250      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0251      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0252      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0253      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0254      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0255      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0256      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0257      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0258      A322     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0259      A324     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0260      A326     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0261      A328     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0262      A329     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0263      A379     cmdb.free         equ  cmdb.struct +121; End of structure
0264               *--------------------------------------------------------------
0265               * File handle structure               @>a400-a4ff   (256 bytes)
0266               *--------------------------------------------------------------
0267      A400     fh.struct         equ  >a400           ; stevie file handling structures
0268               ;***********************************************************************
0269               ; ATTENTION
0270               ; The dsrlnk variables must form a continuous memory block and keep
0271               ; their order!
0272               ;***********************************************************************
0273      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0274      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0275      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0276      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0277      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0278      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0279      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0280      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0281      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0282      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0283      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0284      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0285      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0286      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0287      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0288      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0289      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0290      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0291      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0292      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0293      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0294      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0295      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0296      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0297      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0298      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0299      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0300      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0301      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0302      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0303      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0304      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0305               *--------------------------------------------------------------
0306               * Index structure                     @>a500-a5ff   (256 bytes)
0307               *--------------------------------------------------------------
0308      A500     idx.struct        equ  >a500           ; stevie index structure
0309      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0310      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0311      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0312               *--------------------------------------------------------------
0313               * Frame buffer                        @>a600-afff  (2560 bytes)
0314               *--------------------------------------------------------------
0315      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0316      0960     fb.size           equ  80*30           ; Frame buffer size
0317               *--------------------------------------------------------------
0318               * Index                               @>b000-bfff  (4096 bytes)
0319               *--------------------------------------------------------------
0320      B000     idx.top           equ  >b000           ; Top of index
0321      1000     idx.size          equ  4096            ; Index size
0322               *--------------------------------------------------------------
0323               * Editor buffer                       @>c000-cfff  (4096 bytes)
0324               *--------------------------------------------------------------
0325      C000     edb.top           equ  >c000           ; Editor buffer high memory
0326      1000     edb.size          equ  4096            ; Editor buffer size
0327               *--------------------------------------------------------------
0328               * Command history buffer              @>d000-dfff  (4096 bytes)
0329               *--------------------------------------------------------------
0330      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0331      1000     cmdb.size         equ  4096            ; Command buffer size
0332               *--------------------------------------------------------------
0333               * Heap                                @>e000-ebff  (3072 bytes)
0334               *--------------------------------------------------------------
0335      E000     heap.top          equ  >e000           ; Top of heap
0336               *--------------------------------------------------------------
0337               * Farjump return stack                @>ec00-efff  (1024 bytes)
0338               *--------------------------------------------------------------
0339      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b1.asm.3765856
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 1
0025               ********|*****|*********************|**************************
0026      6002     bankid  equ   bank1.rom             ; Set bank identifier to current bank
0027                       aorg  >6000
0028                       save  >6000,>7fff           ; Save bank
0029                       ;-------------------------------------------------------
0030                       ; Vector table bank 1: >6000 - >603f
0031                       ;-------------------------------------------------------
0032                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 6000 6D2C     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0008 6002 6BE4     vec.2   data  idx.entry.update      ;    for index functions.
0009 6004 6C92     vec.3   data  idx.entry.delete      ;
0010 6006 6C36     vec.4   data  idx.pointer.get       ;
0011 6008 2026     vec.5   data  cpu.crash             ;
0012 600A 2026     vec.6   data  cpu.crash             ;
0013 600C 2026     vec.7   data  cpu.crash             ;
0014 600E 2026     vec.8   data  cpu.crash             ;
0015 6010 2026     vec.9   data  cpu.crash             ;
0016 6012 6E14     vec.10  data  edb.line.pack.fb      ;
0017 6014 6F0C     vec.11  data  edb.line.unpack.fb    ;
0018 6016 2026     vec.12  data  cpu.crash             ;
0019 6018 2026     vec.13  data  cpu.crash             ;
0020 601A 2026     vec.14  data  cpu.crash             ;
0021 601C 6906     vec.15  data  edkey.action.cmdb.show
0022 601E 2026     vec.16  data  cpu.crash             ;
0023 6020 2026     vec.17  data  cpu.crash             ;
0024 6022 2026     vec.18  data  cpu.crash             ;
0025 6024 7454     vec.19  data  cmdb.cmd.clear        ;
0026 6026 6B38     vec.20  data  fb.refresh            ;
0027 6028 7EB2     vec.21  data  fb.vdpdump            ;
0028 602A 2026     vec.22  data  cpu.crash             ;
0029 602C 2026     vec.23  data  cpu.crash             ;
0030 602E 2026     vec.24  data  cpu.crash             ;
0031 6030 2026     vec.25  data  cpu.crash             ;
0032 6032 2026     vec.26  data  cpu.crash             ;
0033 6034 2026     vec.27  data  cpu.crash             ;
0034 6036 78FE     vec.28  data  pane.cursor.blink     ;
0035 6038 78E0     vec.29  data  pane.cursor.hide      ;
0036 603A 7BAE     vec.30  data  pane.errline.show     ;
0037 603C 7754     vec.31  data  pane.action.colorscheme.load
0038 603E 78C6     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.3765856
0033               
0034               ***************************************************************
0035               * Step 1: Switch to bank 0 (uniform code accross all banks)
0036               ********|*****|*********************|**************************
0037                       aorg  kickstart.code1       ; >6040
0038 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0039               ***************************************************************
0040               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0041               ********|*****|*********************|**************************
0042                       aorg  >2000
0043                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0070               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0071               *******************************************************************************
0072               
0073               *//////////////////////////////////////////////////////////////
0074               *                       RUNLIB SETUP
0075               *//////////////////////////////////////////////////////////////
0076               
0077                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
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
0078                       copy  "registers.equ"            ; Equates runlib registers
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
0079                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
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
0080                       copy  "param.equ"                ; Equates runlib parameters
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
0081               
0085               
0086                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0087                       copy  "config.equ"               ; Equates for bits in config register
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
0088                       copy  "cpu_crash.asm"            ; CPU crash handler
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
     2084 2E50 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 22FC 
0078 208A 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 2364 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 2292 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2446 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 29D4 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2446 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 29D4 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2446 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2446 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2446 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2446 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 26D2 
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
     210C 29DE 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26E8 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2422 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26E8 
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
     2132 2422 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 29DE 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 2950 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26E8 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2422 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26E8 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 2422 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 26D8 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D4E 
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
0254 21B6 1B53             byte  27
0255 21B7 ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1842             byte  24
0260 21D3 ....             text  'Build-ID  210807-3765856'
0261                       even
0262               
**** **** ****     > runlib.asm
0089                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0029               ***************************************************************
0030               * Textmode (40 columns/24 rows)
0031               *--------------------------------------------------------------
0032 21F6 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21F8 000E 
     21FA 0106 
     21FC 00F4 
     21FE 0028 
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
0058 2200 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2202 003F 
     2204 0240 
     2206 03F4 
     2208 0050 
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
0079               
0080               
0081               ***************************************************************
0082               * Textmode (80 columns, 30 rows) - F18A
0083               *--------------------------------------------------------------
0084 220A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220C 003F 
     220E 0240 
     2210 03F4 
     2212 0050 
0085               *
0086               * ; VDP#0 Control bits
0087               * ;      bit 6=0: M3 | Graphics 1 mode
0088               * ;      bit 7=0: Disable external VDP input
0089               * ; VDP#1 Control bits
0090               * ;      bit 0=1: 16K selection
0091               * ;      bit 1=1: Enable display
0092               * ;      bit 2=1: Enable VDP interrupt
0093               * ;      bit 3=1: M1 \ TEXT MODE
0094               * ;      bit 4=0: M2 /
0095               * ;      bit 5=0: reserved
0096               * ;      bit 6=0: 8x8 sprites
0097               * ;      bit 7=0: Sprite magnification (1x)
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0103               * ; VDP#7 Set foreground/background color
0104               ***************************************************************
**** **** ****     > runlib.asm
0090                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 2214 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2216 16FD             data  >16fd                 ; |         jne   mcloop
0015 2218 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 221A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 221C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 221E 0201  20         li    r1,mccode             ; Machinecode to patch
     2220 2214 
0037 2222 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2224 8322 
0038 2226 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2228 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 222A CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 222C 045B  20         b     *r11                  ; Return to caller
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
0056 222E C0F9  30 popr3   mov   *stack+,r3
0057 2230 C0B9  30 popr2   mov   *stack+,r2
0058 2232 C079  30 popr1   mov   *stack+,r1
0059 2234 C039  30 popr0   mov   *stack+,r0
0060 2236 C2F9  30 poprt   mov   *stack+,r11
0061 2238 045B  20         b     *r11
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
0085 223A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 223C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 223E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 2240 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2242 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2244 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2246 FFCE 
0095 2248 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     224A 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 224C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     224E 830B 
     2250 830A 
0100               
0101 2252 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2254 0001 
0102 2256 1602  14         jne   filchk2
0103 2258 DD05  32         movb  tmp1,*tmp0+
0104 225A 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 225C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     225E 0002 
0109 2260 1603  14         jne   filchk3
0110 2262 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2264 DD05  32         movb  tmp1,*tmp0+
0112 2266 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2268 C1C4  18 filchk3 mov   tmp0,tmp3
0117 226A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     226C 0001 
0118 226E 1305  14         jeq   fil16b
0119 2270 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2272 0606  14         dec   tmp2
0121 2274 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2276 0002 
0122 2278 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 227A C1C6  18 fil16b  mov   tmp2,tmp3
0127 227C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227E 0001 
0128 2280 1301  14         jeq   dofill
0129 2282 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2284 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2286 0646  14         dect  tmp2
0132 2288 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 228A C1C7  18         mov   tmp3,tmp3
0137 228C 1301  14         jeq   fil.exit
0138 228E DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2290 045B  20         b     *r11
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
0159 2292 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 2294 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 2296 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 2298 0264  22 xfilv   ori   tmp0,>4000
     229A 4000 
0166 229C 06C4  14         swpb  tmp0
0167 229E D804  38         movb  tmp0,@vdpa
     22A0 8C02 
0168 22A2 06C4  14         swpb  tmp0
0169 22A4 D804  38         movb  tmp0,@vdpa
     22A6 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22A8 020F  20         li    r15,vdpw              ; Set VDP write address
     22AA 8C00 
0174 22AC 06C5  14         swpb  tmp1
0175 22AE C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B0 22B8 
     22B2 8320 
0176 22B4 0460  28         b     @mcloop               ; Write data to VDP
     22B6 8320 
0177               *--------------------------------------------------------------
0181 22B8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22BA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22BC 4000 
0202 22BE 06C4  14 vdra    swpb  tmp0
0203 22C0 D804  38         movb  tmp0,@vdpa
     22C2 8C02 
0204 22C4 06C4  14         swpb  tmp0
0205 22C6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22C8 8C02 
0206 22CA 045B  20         b     *r11                  ; Exit
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
0217 22CC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22CE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D2 4000 
0223 22D4 06C4  14         swpb  tmp0                  ; \
0224 22D6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22D8 8C02 
0225 22DA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22DC D804  38         movb  tmp0,@vdpa            ; /
     22DE 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E0 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E2 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22E4 045B  20         b     *r11                  ; Exit
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
0251 22E6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22E8 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22EA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22EC 8C02 
0257 22EE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F0 D804  38         movb  tmp0,@vdpa            ; /
     22F2 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22F4 D120  34         movb  @vdpr,tmp0            ; Read byte
     22F6 8800 
0263 22F8 0984  56         srl   tmp0,8                ; Right align
0264 22FA 045B  20         b     *r11                  ; Exit
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
0283 22FC C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 22FE C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2300 C144  18         mov   tmp0,tmp1
0289 2302 05C5  14         inct  tmp1
0290 2304 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2306 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2308 FF00 
0292 230A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 230C C805  38         mov   tmp1,@wbase           ; Store calculated base
     230E 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2310 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2312 8000 
0298 2314 0206  20         li    tmp2,8
     2316 0008 
0299 2318 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     231A 830B 
0300 231C 06C5  14         swpb  tmp1
0301 231E D805  38         movb  tmp1,@vdpa
     2320 8C02 
0302 2322 06C5  14         swpb  tmp1
0303 2324 D805  38         movb  tmp1,@vdpa
     2326 8C02 
0304 2328 0225  22         ai    tmp1,>0100
     232A 0100 
0305 232C 0606  14         dec   tmp2
0306 232E 16F4  14         jne   vidta1                ; Next register
0307 2330 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2332 833A 
0308 2334 045B  20         b     *r11
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
0325 2336 C13B  30 putvr   mov   *r11+,tmp0
0326 2338 0264  22 putvrx  ori   tmp0,>8000
     233A 8000 
0327 233C 06C4  14         swpb  tmp0
0328 233E D804  38         movb  tmp0,@vdpa
     2340 8C02 
0329 2342 06C4  14         swpb  tmp0
0330 2344 D804  38         movb  tmp0,@vdpa
     2346 8C02 
0331 2348 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 234A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 234C C10E  18         mov   r14,tmp0
0341 234E 0984  56         srl   tmp0,8
0342 2350 06A0  32         bl    @putvrx               ; Write VR#0
     2352 2338 
0343 2354 0204  20         li    tmp0,>0100
     2356 0100 
0344 2358 D820  54         movb  @r14lb,@tmp0lb
     235A 831D 
     235C 8309 
0345 235E 06A0  32         bl    @putvrx               ; Write VR#1
     2360 2338 
0346 2362 0458  20         b     *tmp4                 ; Exit
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
0360 2364 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2366 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2368 C11B  26         mov   *r11,tmp0             ; Get P0
0363 236A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     236C 7FFF 
0364 236E 2120  38         coc   @wbit0,tmp0
     2370 2020 
0365 2372 1604  14         jne   ldfnt1
0366 2374 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2376 8000 
0367 2378 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     237A 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 237C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     237E 23E6 
0372 2380 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2382 9C02 
0373 2384 06C4  14         swpb  tmp0
0374 2386 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2388 9C02 
0375 238A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     238C 9800 
0376 238E 06C5  14         swpb  tmp1
0377 2390 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2392 9800 
0378 2394 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 2396 D805  38         movb  tmp1,@grmwa
     2398 9C02 
0383 239A 06C5  14         swpb  tmp1
0384 239C D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     239E 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23A4 22BA 
0390 23A6 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23A8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23AA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23AC 7FFF 
0393 23AE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B0 23E8 
0394 23B2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23B4 23EA 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23B6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23B8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23BA D120  34         movb  @grmrd,tmp0
     23BC 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23BE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C0 2020 
0405 23C2 1603  14         jne   ldfnt3                ; No, so skip
0406 23C4 D1C4  18         movb  tmp0,tmp3
0407 23C6 0917  56         srl   tmp3,1
0408 23C8 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23CA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23CC 8C00 
0413 23CE 0606  14         dec   tmp2
0414 23D0 16F2  14         jne   ldfnt2
0415 23D2 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23D4 020F  20         li    r15,vdpw              ; Set VDP write address
     23D6 8C00 
0417 23D8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23DA 7FFF 
0418 23DC 0458  20         b     *tmp4                 ; Exit
0419 23DE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E0 2000 
     23E2 8C00 
0420 23E4 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23E6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23E8 0200 
     23EA 0000 
0425 23EC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23EE 01C0 
     23F0 0101 
0426 23F2 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23F4 02A0 
     23F6 0101 
0427 23F8 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23FA 00E0 
     23FC 0101 
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
0445 23FE C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2400 C3A0  34         mov   @wyx,r14              ; Get YX
     2402 832A 
0447 2404 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2406 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2408 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 240A C3A0  34         mov   @wyx,r14              ; Get YX
     240C 832A 
0454 240E 024E  22         andi  r14,>00ff             ; Remove Y
     2410 00FF 
0455 2412 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2414 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2416 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2418 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 241A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 241C 020F  20         li    r15,vdpw              ; VDP write address
     241E 8C00 
0463 2420 045B  20         b     *r11
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
0481 2422 C17B  30 putstr  mov   *r11+,tmp1
0482 2424 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2426 C1CB  18 xutstr  mov   r11,tmp3
0484 2428 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     242A 23FE 
0485 242C C2C7  18         mov   tmp3,r11
0486 242E 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 2430 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 2432 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 2434 0286  22         ci    tmp2,255              ; Length > 255 ?
     2436 00FF 
0494 2438 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 243A 0460  28         b     @xpym2v               ; Display string
     243C 2490 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 243E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2440 FFCE 
0501 2442 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2444 2026 
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
0517 2446 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2448 832A 
0518 244A 0460  28         b     @putstr
     244C 2422 
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
0539 244E 0649  14         dect  stack
0540 2450 C64B  30         mov   r11,*stack            ; Save return address
0541 2452 0649  14         dect  stack
0542 2454 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2456 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2458 0987  56         srl   tmp3,8                ; Right align
0549               
0550 245A 0649  14         dect  stack
0551 245C C645  30         mov   tmp1,*stack           ; Push tmp1
0552 245E 0649  14         dect  stack
0553 2460 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 2462 0649  14         dect  stack
0555 2464 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2466 06A0  32         bl    @xutst0               ; Display string
     2468 2424 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 246A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 246C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 246E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 2470 06A0  32         bl    @down                 ; Move cursor down
     2472 26D8 
0566               
0567 2474 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2476 0585  14         inc   tmp1                  ; Consider length byte
0569 2478 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     247A 2002 
0570 247C 1301  14         jeq   !                     ; Yes, skip adjustment
0571 247E 0585  14         inc   tmp1                  ; Make address even
0572 2480 0606  14 !       dec   tmp2
0573 2482 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 2484 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2486 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2488 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0091               
0093                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 248A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 248C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 248E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 2490 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2492 1604  14         jne   !                     ; No, continue
0028               
0029 2494 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2496 FFCE 
0030 2498 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     249A 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 249C 0264  22 !       ori   tmp0,>4000
     249E 4000 
0035 24A0 06C4  14         swpb  tmp0
0036 24A2 D804  38         movb  tmp0,@vdpa
     24A4 8C02 
0037 24A6 06C4  14         swpb  tmp0
0038 24A8 D804  38         movb  tmp0,@vdpa
     24AA 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24AC 020F  20         li    r15,vdpw              ; Set VDP write address
     24AE 8C00 
0043 24B0 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24B2 24BA 
     24B4 8320 
0044 24B6 0460  28         b     @mcloop               ; Write data to VDP and return
     24B8 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24BA D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0095               
0097                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 24BC C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24BE C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24C0 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24C2 06C4  14 xpyv2m  swpb  tmp0
0027 24C4 D804  38         movb  tmp0,@vdpa
     24C6 8C02 
0028 24C8 06C4  14         swpb  tmp0
0029 24CA D804  38         movb  tmp0,@vdpa
     24CC 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24CE 020F  20         li    r15,vdpr              ; Set VDP read address
     24D0 8800 
0034 24D2 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24D4 24DC 
     24D6 8320 
0035 24D8 0460  28         b     @mcloop               ; Read data from VDP
     24DA 8320 
0036 24DC DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0099               
0101                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 24DE C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24E0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24E2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24E4 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24E6 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24E8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24EA FFCE 
0034 24EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24EE 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24F0 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24F2 0001 
0039 24F4 1603  14         jne   cpym0                 ; No, continue checking
0040 24F6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24F8 04C6  14         clr   tmp2                  ; Reset counter
0042 24FA 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24FC 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24FE 7FFF 
0047 2500 C1C4  18         mov   tmp0,tmp3
0048 2502 0247  22         andi  tmp3,1
     2504 0001 
0049 2506 1618  14         jne   cpyodd                ; Odd source address handling
0050 2508 C1C5  18 cpym1   mov   tmp1,tmp3
0051 250A 0247  22         andi  tmp3,1
     250C 0001 
0052 250E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2510 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2512 2020 
0057 2514 1605  14         jne   cpym3
0058 2516 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2518 253E 
     251A 8320 
0059 251C 0460  28         b     @mcloop               ; Copy memory and exit
     251E 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 2520 C1C6  18 cpym3   mov   tmp2,tmp3
0064 2522 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2524 0001 
0065 2526 1301  14         jeq   cpym4
0066 2528 0606  14         dec   tmp2                  ; Make TMP2 even
0067 252A CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 252C 0646  14         dect  tmp2
0069 252E 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2530 C1C7  18         mov   tmp3,tmp3
0074 2532 1301  14         jeq   cpymz
0075 2534 D554  38         movb  *tmp0,*tmp1
0076 2536 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2538 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     253A 8000 
0081 253C 10E9  14         jmp   cpym2
0082 253E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0103               
0107               
0111               
0113                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
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
0062 2540 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2542 0649  14         dect  stack
0065 2544 C64B  30         mov   r11,*stack            ; Push return address
0066 2546 0649  14         dect  stack
0067 2548 C640  30         mov   r0,*stack             ; Push r0
0068 254A 0649  14         dect  stack
0069 254C C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 254E 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2550 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2552 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2554 4000 
0077 2556 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2558 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
     255C 1E00 
0082 255E 04C0  14         clr   r0
0083 2560 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2562 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2564 D100  18         movb  r0,tmp0
0086 2566 0984  56         srl   tmp0,8                ; Right align
0087 2568 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     256A 833C 
0088 256C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 256E C339  30         mov   *stack+,r12           ; Pop r12
0094 2570 C039  30         mov   *stack+,r0            ; Pop r0
0095 2572 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2574 045B  20         b     *r11                  ; Return to caller
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
0131 2576 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2578 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 257A 0649  14         dect  stack
0135 257C C64B  30         mov   r11,*stack            ; Push return address
0136 257E 0649  14         dect  stack
0137 2580 C640  30         mov   r0,*stack             ; Push r0
0138 2582 0649  14         dect  stack
0139 2584 C64C  30         mov   r12,*stack            ; Push r12
0140 2586 0649  14         dect  stack
0141 2588 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 258A 0649  14         dect  stack
0143 258C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 258E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2590 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 2592 0284  22         ci    tmp0,255              ; Crash if page > 255
     2594 00FF 
0153 2596 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 2598 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     259A 001E 
0158 259C 150A  14         jgt   !
0159 259E 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25A0 0004 
0160 25A2 1107  14         jlt   !
0161 25A4 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25A6 0012 
0162 25A8 1508  14         jgt   sams.page.set.switch_page
0163 25AA 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25AC 0006 
0164 25AE 1501  14         jgt   !
0165 25B0 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25B2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25B4 FFCE 
0170 25B6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25B8 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25BA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25BC 1E00 
0176 25BE C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25C0 06C0  14         swpb  r0                    ; LSB to MSB
0178 25C2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25C4 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25C6 4000 
0180 25C8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25CE C339  30         mov   *stack+,r12           ; Pop r12
0188 25D0 C039  30         mov   *stack+,r0            ; Pop r0
0189 25D2 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25D4 045B  20         b     *r11                  ; Return to caller
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
0204 25D6 020C  20         li    r12,>1e00             ; SAMS CRU address
     25D8 1E00 
0205 25DA 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25DC 045B  20         b     *r11                  ; Return to caller
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
0227 25DE 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E0 1E00 
0228 25E2 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25E4 045B  20         b     *r11                  ; Return to caller
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
0260 25E6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25E8 0649  14         dect  stack
0263 25EA C64B  30         mov   r11,*stack            ; Save return address
0264 25EC 0649  14         dect  stack
0265 25EE C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25F0 0649  14         dect  stack
0267 25F2 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25F4 0649  14         dect  stack
0269 25F6 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25F8 0649  14         dect  stack
0271 25FA C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25FC 0206  20         li    tmp2,8                ; Set loop counter
     25FE 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 2600 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 2602 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 2604 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2606 257A 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2608 0606  14         dec   tmp2                  ; Next iteration
0288 260A 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 260C 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     260E 25D6 
0294                                                   ; / activating changes.
0295               
0296 2610 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 2612 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 2614 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 2616 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2618 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 261A 045B  20         b     *r11                  ; Return to caller
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
0318 261C 0649  14         dect  stack
0319 261E C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 2620 06A0  32         bl    @sams.layout
     2622 25E6 
0324 2624 262A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 2626 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2628 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 262A 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     262C 0002 
0336 262E 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     2630 0003 
0337 2632 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2634 000A 
0338 2636 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2638 000B 
0339 263A C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     263C 000C 
0340 263E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2640 000D 
0341 2642 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2644 000E 
0342 2646 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2648 000F 
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
0363 264A C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 264C 0649  14         dect  stack
0366 264E C64B  30         mov   r11,*stack            ; Push return address
0367 2650 0649  14         dect  stack
0368 2652 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2654 0649  14         dect  stack
0370 2656 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2658 0649  14         dect  stack
0372 265A C646  30         mov   tmp2,*stack           ; Push tmp2
0373 265C 0649  14         dect  stack
0374 265E C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2660 0205  20         li    tmp1,sams.layout.copy.data
     2662 2682 
0379 2664 0206  20         li    tmp2,8                ; Set loop counter
     2666 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2668 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 266A 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     266C 2542 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 266E CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2670 833C 
0390               
0391 2672 0606  14         dec   tmp2                  ; Next iteration
0392 2674 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2676 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2678 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 267A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 267C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 267E C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2680 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2682 2000             data  >2000                 ; >2000-2fff
0408 2684 3000             data  >3000                 ; >3000-3fff
0409 2686 A000             data  >a000                 ; >a000-afff
0410 2688 B000             data  >b000                 ; >b000-bfff
0411 268A C000             data  >c000                 ; >c000-cfff
0412 268C D000             data  >d000                 ; >d000-dfff
0413 268E E000             data  >e000                 ; >e000-efff
0414 2690 F000             data  >f000                 ; >f000-ffff
0415               
**** **** ****     > runlib.asm
0115               
0117                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 2692 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2694 FFBF 
0010 2696 0460  28         b     @putv01
     2698 234A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 269A 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     269C 0040 
0018 269E 0460  28         b     @putv01
     26A0 234A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26A2 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26A4 FFDF 
0026 26A6 0460  28         b     @putv01
     26A8 234A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26AA 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26AC 0020 
0034 26AE 0460  28         b     @putv01
     26B0 234A 
**** **** ****     > runlib.asm
0119               
0121                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 26B2 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26B4 FFFE 
0011 26B6 0460  28         b     @putv01
     26B8 234A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26BA 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26BC 0001 
0019 26BE 0460  28         b     @putv01
     26C0 234A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26C2 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26C4 FFFD 
0027 26C6 0460  28         b     @putv01
     26C8 234A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26CA 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26CC 0002 
0035 26CE 0460  28         b     @putv01
     26D0 234A 
**** **** ****     > runlib.asm
0123               
0125                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 26D2 C83B  50 at      mov   *r11+,@wyx
     26D4 832A 
0019 26D6 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26D8 B820  54 down    ab    @hb$01,@wyx
     26DA 2012 
     26DC 832A 
0028 26DE 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26E0 7820  54 up      sb    @hb$01,@wyx
     26E2 2012 
     26E4 832A 
0037 26E6 045B  20         b     *r11
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
0049 26E8 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26EA D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26EC 832A 
0051 26EE C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26F0 832A 
0052 26F2 045B  20         b     *r11
**** **** ****     > runlib.asm
0127               
0129                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 26F4 C120  34 yx2px   mov   @wyx,tmp0
     26F6 832A 
0022 26F8 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26FA 06C4  14         swpb  tmp0                  ; Y<->X
0024 26FC 04C5  14         clr   tmp1                  ; Clear before copy
0025 26FE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 2700 20A0  38         coc   @wbit1,config         ; f18a present ?
     2702 201E 
0030 2704 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2706 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2708 833A 
     270A 2734 
0032 270C 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 270E 0A15  56         sla   tmp1,1                ; X = X * 2
0035 2710 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 2712 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2714 0500 
0037 2716 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2718 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 271A 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 271C 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 271E D105  18         movb  tmp1,tmp0
0051 2720 06C4  14         swpb  tmp0                  ; X<->Y
0052 2722 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     2724 2020 
0053 2726 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2728 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     272A 2012 
0059 272C 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     272E 2024 
0060 2730 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2732 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2734 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0131               
0135               
0139               
0141                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
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
0013 2736 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2738 06A0  32         bl    @putvr                ; Write once
     273A 2336 
0015 273C 391C             data  >391c                 ; VR1/57, value 00011100
0016 273E 06A0  32         bl    @putvr                ; Write twice
     2740 2336 
0017 2742 391C             data  >391c                 ; VR1/57, value 00011100
0018 2744 06A0  32         bl    @putvr
     2746 2336 
0019 2748 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 274A 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 274C C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 274E 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     2750 2336 
0030 2752 3900             data  >3900
0031 2754 0458  20         b     *tmp4                 ; Exit
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
0043 2756 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 2758 06A0  32         bl    @cpym2v
     275A 248A 
0045 275C 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     275E 279A 
     2760 0006 
0046 2762 06A0  32         bl    @putvr
     2764 2336 
0047 2766 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 2768 06A0  32         bl    @putvr
     276A 2336 
0049 276C 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 276E 0204  20         li    tmp0,>3f00
     2770 3F00 
0055 2772 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     2774 22BE 
0056 2776 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2778 8800 
0057 277A 0984  56         srl   tmp0,8
0058 277C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     277E 8800 
0059 2780 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 2782 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 2784 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2786 BFFF 
0063 2788 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 278A 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     278C 4000 
0066               f18chk_exit:
0067 278E 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     2790 2292 
0068 2792 3F00             data  >3f00,>00,6
     2794 0000 
     2796 0006 
0069 2798 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 279A 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 279C 3F00             data  >3f00                 ; 3f02 / 3f00
0076 279E 0340             data  >0340                 ; 3f04   0340  idle
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
0097 27A0 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 27A2 06A0  32         bl    @putvr
     27A4 2336 
0102 27A6 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 27A8 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27AA 2336 
0105 27AC 3900             data  >3900                 ; Lock the F18a
0106 27AE 0458  20         b     *tmp4                 ; Exit
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
0125 27B0 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 27B2 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27B4 201E 
0127 27B6 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 27B8 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27BA 8802 
0132 27BC 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27BE 2336 
0133 27C0 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 27C2 04C4  14         clr   tmp0
0135 27C4 D120  34         movb  @vdps,tmp0
     27C6 8802 
0136 27C8 0984  56         srl   tmp0,8
0137 27CA 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0143               
0145                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 27CC C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27CE 832A 
0018 27D0 D17B  28         movb  *r11+,tmp1
0019 27D2 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27D4 D1BB  28         movb  *r11+,tmp2
0021 27D6 0986  56         srl   tmp2,8                ; Repeat count
0022 27D8 C1CB  18         mov   r11,tmp3
0023 27DA 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27DC 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27DE 020B  20         li    r11,hchar1
     27E0 27E6 
0028 27E2 0460  28         b     @xfilv                ; Draw
     27E4 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27E6 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27E8 2022 
0033 27EA 1302  14         jeq   hchar2                ; Yes, exit
0034 27EC C2C7  18         mov   tmp3,r11
0035 27EE 10EE  14         jmp   hchar                 ; Next one
0036 27F0 05C7  14 hchar2  inct  tmp3
0037 27F2 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0147               
0151               
0155               
0159               
0163               
0167               
0171               
0175               
0177                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 27F4 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27F6 2020 
0017 27F8 020C  20         li    r12,>0024
     27FA 0024 
0018 27FC 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27FE 2890 
0019 2800 04C6  14         clr   tmp2
0020 2802 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 2804 04CC  14         clr   r12
0025 2806 1F08  20         tb    >0008                 ; Shift-key ?
0026 2808 1302  14         jeq   realk1                ; No
0027 280A 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     280C 28C0 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 280E 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 2810 1302  14         jeq   realk2                ; No
0033 2812 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     2814 28F0 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 2816 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2818 1302  14         jeq   realk3                ; No
0039 281A 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     281C 2920 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 281E 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     2820 200C 
0044 2822 1E15  20         sbz   >0015                 ; Set P5
0045 2824 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2826 1302  14         jeq   realk4                ; No
0047 2828 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     282A 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 282C 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 282E 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     2830 0006 
0053 2832 0606  14 realk5  dec   tmp2
0054 2834 020C  20         li    r12,>24               ; CRU address for P2-P4
     2836 0024 
0055 2838 06C6  14         swpb  tmp2
0056 283A 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 283C 06C6  14         swpb  tmp2
0058 283E 020C  20         li    r12,6                 ; CRU read address
     2840 0006 
0059 2842 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2844 0547  14         inv   tmp3                  ;
0061 2846 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2848 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 284A 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 284C 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 284E 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2850 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2852 0285  22         ci    tmp1,8
     2854 0008 
0070 2856 1AFA  14         jl    realk6
0071 2858 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 285A 1BEB  14         jh    realk5                ; No, next column
0073 285C 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 285E C206  18 realk8  mov   tmp2,tmp4
0078 2860 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2862 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2864 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2866 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2868 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 286A D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 286C 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     286E 200C 
0089 2870 1608  14         jne   realka                ; No, continue saving key
0090 2872 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2874 28BA 
0091 2876 1A05  14         jl    realka
0092 2878 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     287A 28B8 
0093 287C 1B02  14         jh    realka                ; No, continue
0094 287E 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2880 E000 
0095 2882 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2884 833C 
0096 2886 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2888 200A 
0097 288A 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     288C 8C00 
0098                                                   ; / using R15 as temp storage
0099 288E 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2890 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2892 0000 
     2894 FF0D 
     2896 203D 
0102 2898 ....             text  'xws29ol.'
0103 28A0 ....             text  'ced38ik,'
0104 28A8 ....             text  'vrf47ujm'
0105 28B0 ....             text  'btg56yhn'
0106 28B8 ....             text  'zqa10p;/'
0107 28C0 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28C2 0000 
     28C4 FF0D 
     28C6 202B 
0108 28C8 ....             text  'XWS@(OL>'
0109 28D0 ....             text  'CED#*IK<'
0110 28D8 ....             text  'VRF$&UJM'
0111 28E0 ....             text  'BTG%^YHN'
0112 28E8 ....             text  'ZQA!)P:-'
0113 28F0 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28F2 0000 
     28F4 FF0D 
     28F6 2005 
0114 28F8 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28FA 0804 
     28FC 0F27 
     28FE C2B9 
0115 2900 600B             data  >600b,>0907,>063f,>c1B8
     2902 0907 
     2904 063F 
     2906 C1B8 
0116 2908 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     290A 7B02 
     290C 015F 
     290E C0C3 
0117 2910 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     2912 7D0E 
     2914 0CC6 
     2916 BFC4 
0118 2918 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     291A 7C03 
     291C BC22 
     291E BDBA 
0119 2920 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     2922 0000 
     2924 FF0D 
     2926 209D 
0120 2928 9897             data  >9897,>93b2,>9f8f,>8c9B
     292A 93B2 
     292C 9F8F 
     292E 8C9B 
0121 2930 8385             data  >8385,>84b3,>9e89,>8b80
     2932 84B3 
     2934 9E89 
     2936 8B80 
0122 2938 9692             data  >9692,>86b4,>b795,>8a8D
     293A 86B4 
     293C B795 
     293E 8A8D 
0123 2940 8294             data  >8294,>87b5,>b698,>888E
     2942 87B5 
     2944 B698 
     2946 888E 
0124 2948 9A91             data  >9a91,>81b1,>b090,>9cBB
     294A 81B1 
     294C B090 
     294E 9CBB 
**** **** ****     > runlib.asm
0179               
0181                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 2950 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2952 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2954 8340 
0025 2956 04E0  34         clr   @waux1
     2958 833C 
0026 295A 04E0  34         clr   @waux2
     295C 833E 
0027 295E 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2960 833C 
0028 2962 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2964 0205  20         li    tmp1,4                ; 4 nibbles
     2966 0004 
0033 2968 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 296A 0246  22         andi  tmp2,>000f            ; Only keep LSN
     296C 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 296E 0286  22         ci    tmp2,>000a
     2970 000A 
0039 2972 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2974 C21B  26         mov   *r11,tmp4
0045 2976 0988  56         srl   tmp4,8                ; Right justify
0046 2978 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     297A FFF6 
0047 297C 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 297E C21B  26         mov   *r11,tmp4
0054 2980 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2982 00FF 
0055               
0056 2984 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2986 06C6  14         swpb  tmp2
0058 2988 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 298A 0944  56         srl   tmp0,4                ; Next nibble
0060 298C 0605  14         dec   tmp1
0061 298E 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2990 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2992 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2994 C160  34         mov   @waux3,tmp1           ; Get pointer
     2996 8340 
0067 2998 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 299A 0585  14         inc   tmp1                  ; Next byte, not word!
0069 299C C120  34         mov   @waux2,tmp0
     299E 833E 
0070 29A0 06C4  14         swpb  tmp0
0071 29A2 DD44  32         movb  tmp0,*tmp1+
0072 29A4 06C4  14         swpb  tmp0
0073 29A6 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29A8 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29AA 8340 
0078 29AC D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29AE 2016 
0079 29B0 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29B2 C120  34         mov   @waux1,tmp0
     29B4 833C 
0084 29B6 06C4  14         swpb  tmp0
0085 29B8 DD44  32         movb  tmp0,*tmp1+
0086 29BA 06C4  14         swpb  tmp0
0087 29BC DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29BE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29C0 2020 
0092 29C2 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29C4 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29C6 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29C8 7FFF 
0098 29CA C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29CC 8340 
0099 29CE 0460  28         b     @xutst0               ; Display string
     29D0 2424 
0100 29D2 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29D4 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29D6 832A 
0122 29D8 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29DA 8000 
0123 29DC 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0183               
0185                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 29DE 0207  20 mknum   li    tmp3,5                ; Digit counter
     29E0 0005 
0020 29E2 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29E4 C155  26         mov   *tmp1,tmp1            ; /
0022 29E6 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29E8 0228  22         ai    tmp4,4                ; Get end of buffer
     29EA 0004 
0024 29EC 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29EE 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29F0 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29F2 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29F4 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29F6 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29F8 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29FA C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29FC 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29FE 0607  14         dec   tmp3                  ; Decrease counter
0036 2A00 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2A02 0207  20         li    tmp3,4                ; Check first 4 digits
     2A04 0004 
0041 2A06 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A08 C11B  26         mov   *r11,tmp0
0043 2A0A 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A0C 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A0E 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A10 05CB  14 mknum3  inct  r11
0047 2A12 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A14 2020 
0048 2A16 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A18 045B  20         b     *r11                  ; Exit
0050 2A1A DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A1C 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A1E 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A20 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A22 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A24 7FFF 
0058 2A26 C10B  18         mov   r11,tmp0
0059 2A28 0224  22         ai    tmp0,-4
     2A2A FFFC 
0060 2A2C C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A2E 0206  20         li    tmp2,>0500            ; String length = 5
     2A30 0500 
0062 2A32 0460  28         b     @xutstr               ; Display string
     2A34 2426 
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
0093 2A36 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A38 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A3A C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A3C 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A3E 0207  20         li    tmp3,5                ; Set counter
     2A40 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A42 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A44 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A46 0584  14         inc   tmp0                  ; Next character
0105 2A48 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A4A 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A4C 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A4E 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A50 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A52 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A54 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A56 0607  14         dec   tmp3                  ; Last character ?
0121 2A58 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A5A 045B  20         b     *r11                  ; Return
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
0139 2A5C C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A5E 832A 
0140 2A60 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A62 8000 
0141 2A64 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0187               
0191               
0195               
0199               
0203               
0205                       copy  "cpu_strings.asm"          ; String utilities support
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
0022 2A66 0649  14         dect  stack
0023 2A68 C64B  30         mov   r11,*stack            ; Save return address
0024 2A6A 0649  14         dect  stack
0025 2A6C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A6E 0649  14         dect  stack
0027 2A70 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A72 0649  14         dect  stack
0029 2A74 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A76 0649  14         dect  stack
0031 2A78 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A7A C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A7C C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A7E C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A80 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A82 0649  14         dect  stack
0044 2A84 C64B  30         mov   r11,*stack            ; Save return address
0045 2A86 0649  14         dect  stack
0046 2A88 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A8A 0649  14         dect  stack
0048 2A8C C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A8E 0649  14         dect  stack
0050 2A90 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A92 0649  14         dect  stack
0052 2A94 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A96 C1D4  26 !       mov   *tmp0,tmp3
0057 2A98 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A9A 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A9C 00FF 
0059 2A9E 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2AA0 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2AA2 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2AA4 0584  14         inc   tmp0                  ; Next byte
0067 2AA6 0607  14         dec   tmp3                  ; Shorten string length
0068 2AA8 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AAA 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AAC 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AAE C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2AB0 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2AB2 C187  18         mov   tmp3,tmp2
0078 2AB4 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2AB6 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AB8 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2ABA 24E4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2ABC 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2ABE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AC0 FFCE 
0090 2AC2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AC4 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AC6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AC8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2ACA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2ACC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2ACE C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2AD0 045B  20         b     *r11                  ; Return to caller
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
0123 2AD2 0649  14         dect  stack
0124 2AD4 C64B  30         mov   r11,*stack            ; Save return address
0125 2AD6 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AD8 05D9  26         inct  *stack                ; Skip "data P1"
0127 2ADA 0649  14         dect  stack
0128 2ADC C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2ADE 0649  14         dect  stack
0130 2AE0 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AE2 0649  14         dect  stack
0132 2AE4 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AE6 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AE8 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AEA 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AEC 0649  14         dect  stack
0144 2AEE C64B  30         mov   r11,*stack            ; Save return address
0145 2AF0 0649  14         dect  stack
0146 2AF2 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AF4 0649  14         dect  stack
0148 2AF6 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AF8 0649  14         dect  stack
0150 2AFA C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AFC 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AFE 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2B00 0586  14         inc   tmp2
0161 2B02 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2B04 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B06 0286  22         ci    tmp2,255
     2B08 00FF 
0167 2B0A 1505  14         jgt   string.getlenc.panic
0168 2B0C 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B0E 0606  14         dec   tmp2                  ; One time adjustment
0174 2B10 C806  38         mov   tmp2,@waux1           ; Store length
     2B12 833C 
0175 2B14 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B16 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B18 FFCE 
0181 2B1A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B1C 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B1E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B20 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B22 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B24 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B26 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0207               
0211               
0216               
0218                       copy  "fio.equ"                  ; File I/O equates
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
0219                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0056 2B28 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B2A 2B2C             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B2C C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B2E C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B30 A428 
0064 2B32 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B34 201C 
0065 2B36 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B38 8356 
0066 2B3A C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B3C 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B3E FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B40 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B42 A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B44 06C0  14         swpb  r0                    ;
0075 2B46 D800  38         movb  r0,@vdpa              ; Send low byte
     2B48 8C02 
0076 2B4A 06C0  14         swpb  r0                    ;
0077 2B4C D800  38         movb  r0,@vdpa              ; Send high byte
     2B4E 8C02 
0078 2B50 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B52 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B54 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B56 0704  14         seto  r4                    ; Init counter
0086 2B58 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B5A A420 
0087 2B5C 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B5E 0584  14         inc   r4                    ; Increment char counter
0089 2B60 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B62 0007 
0090 2B64 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B66 80C4  18         c     r4,r3                 ; End of name?
0093 2B68 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B6A 06C0  14         swpb  r0                    ;
0098 2B6C D800  38         movb  r0,@vdpa              ; Send low byte
     2B6E 8C02 
0099 2B70 06C0  14         swpb  r0                    ;
0100 2B72 D800  38         movb  r0,@vdpa              ; Send high byte
     2B74 8C02 
0101 2B76 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B78 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B7A DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B7C 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B7E 2C94 
0109 2B80 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B82 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B84 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B86 04E0  34         clr   @>83d0
     2B88 83D0 
0118 2B8A C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B8C 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B8E C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B90 A432 
0121               
0122 2B92 0584  14         inc   r4                    ; Adjust for dot
0123 2B94 A804  38         a     r4,@>8356             ; Point to position after name
     2B96 8356 
0124 2B98 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B9A 8356 
     2B9C A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B9E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2BA0 83E0 
0130 2BA2 04C1  14         clr   r1                    ; Version found of dsr
0131 2BA4 020C  20         li    r12,>0f00             ; Init cru address
     2BA6 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BA8 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BAA 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BAC 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BAE 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BB0 0100 
0145 2BB2 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BB4 83D0 
0146 2BB6 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BB8 2000 
0147 2BBA 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BBC C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BBE 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BC0 1D00  20         sbo   0                     ; Turn on ROM
0154 2BC2 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BC4 4000 
0155 2BC6 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BC8 2C90 
0156 2BCA 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BCC A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BCE A40A 
0166 2BD0 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BD2 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BD4 83D2 
0172                                                   ; subprogram
0173               
0174 2BD6 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BD8 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BDA 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BDC C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BDE 83D2 
0183                                                   ; subprogram
0184               
0185 2BE0 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BE2 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BE4 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BE6 D160  34         movb  @>8355,r5             ; Get length as counter
     2BE8 8355 
0195 2BEA 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BEC 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BEE 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BF0 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BF2 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BF4 A420 
0206 2BF6 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BF8 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BFA 0605  14         dec   r5                    ; Update loop counter
0211 2BFC 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BFE 0581  14         inc   r1                    ; Next version found
0217 2C00 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2C02 A42A 
0218 2C04 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C06 A42C 
0219 2C08 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C0A A430 
0220               
0221 2C0C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C0E 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C10 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C12 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C14 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C16 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C18 A400 
0233 2C1A C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C1C C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C1E A428 
0239                                                   ; (8 or >a)
0240 2C20 0281  22         ci    r1,8                  ; was it 8?
     2C22 0008 
0241 2C24 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C26 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C28 8350 
0243                                                   ; Get error byte from @>8350
0244 2C2A 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C2C 06C0  14         swpb  r0                    ;
0252 2C2E D800  38         movb  r0,@vdpa              ; send low byte
     2C30 8C02 
0253 2C32 06C0  14         swpb  r0                    ;
0254 2C34 D800  38         movb  r0,@vdpa              ; send high byte
     2C36 8C02 
0255 2C38 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C3A 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C3C 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C3E 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C40 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C42 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C44 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C46 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C48 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C4A 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C4C D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C4E F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C50 201C 
0281                                                   ; / to indicate error
0282 2C52 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C54 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C56 2C58             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C58 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C5A 83E0 
0316               
0317 2C5C 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C5E 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C60 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C62 A42A 
0322 2C64 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C66 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C68 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C6A 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C6C C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C6E C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C70 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C72 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C74 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C76 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C78 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C7A 4000 
     2C7C 2C90 
0337 2C7E 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C80 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C82 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C84 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C86 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C88 A400 
0355 2C8A C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C8C A434 
0356               
0357 2C8E 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C90 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C92 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C94 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
**** **** ****     > runlib.asm
0220                       copy  "fio_level3.asm"           ; File I/O level 3 support
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
0045 2C96 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C98 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C9A 0649  14         dect  stack
0052 2C9C C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C9E 0204  20         li    tmp0,dsrlnk.savcru
     2CA0 A42A 
0057 2CA2 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2CA4 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CA6 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CA8 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CAA 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CAC 37D7 
0065 2CAE C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CB0 8370 
0066                                                   ; / location
0067 2CB2 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CB4 A44C 
0068 2CB6 04C5  14         clr   tmp1                  ; io.op.open
0069 2CB8 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2CBA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CBC 0649  14         dect  stack
0097 2CBE C64B  30         mov   r11,*stack            ; Save return address
0098 2CC0 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CC2 0001 
0099 2CC4 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2CC6 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CC8 0649  14         dect  stack
0125 2CCA C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CCC 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CCE 0002 
0128 2CD0 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2CD2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CD4 0649  14         dect  stack
0155 2CD6 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CD8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CDA 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CDC 0005 
0159               
0160 2CDE C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CE0 A43E 
0161               
0162 2CE2 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CE4 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CE6 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CE8 0003 
0167 2CEA 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CEC 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CEE 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CF0 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CF2 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CF4 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CF6 1000  14         nop
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
0227 2CF8 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CFA A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CFC C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CFE A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2D00 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2D02 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D04 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D06 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D08 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D0A C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D0C A44C 
0246               
0247 2D0E 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D10 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D12 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D14 0009 
0254 2D16 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D18 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D1A C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D1C 8322 
     2D1E 833C 
0259               
0260 2D20 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D22 A42A 
0261 2D24 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D26 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D28 2B28 
0268 2D2A 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D2C 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D2E 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D30 2C54 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D32 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D34 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D36 833C 
     2D38 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D3A C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D3C A436 
0292 2D3E 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D40 0005 
0293 2D42 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D44 22E8 
0294 2D46 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D48 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D4A C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D4C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0222               
0223               *//////////////////////////////////////////////////////////////
0224               *                            TIMERS
0225               *//////////////////////////////////////////////////////////////
0226               
0227                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 2D4E 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D50 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D52 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D54 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D56 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D58 201C 
0029 2D5A 1602  14         jne   tmgr1a                ; No, so move on
0030 2D5C E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D5E 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D60 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D62 2020 
0035 2D64 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D66 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D68 2010 
0048 2D6A 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D6C 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D6E 200E 
0050 2D70 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D72 0460  28         b     @kthread              ; Run kernel thread
     2D74 2DEC 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D76 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D78 2014 
0056 2D7A 13EB  14         jeq   tmgr1
0057 2D7C 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D7E 2012 
0058 2D80 16E8  14         jne   tmgr1
0059 2D82 C120  34         mov   @wtiusr,tmp0
     2D84 832E 
0060 2D86 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D88 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D8A 2DEA 
0065 2D8C C10A  18         mov   r10,tmp0
0066 2D8E 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D90 00FF 
0067 2D92 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D94 201C 
0068 2D96 1303  14         jeq   tmgr5
0069 2D98 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D9A 003C 
0070 2D9C 1002  14         jmp   tmgr6
0071 2D9E 0284  22 tmgr5   ci    tmp0,50
     2DA0 0032 
0072 2DA2 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2DA4 1001  14         jmp   tmgr8
0074 2DA6 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DA8 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DAA 832C 
0079 2DAC 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DAE FF00 
0080 2DB0 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DB2 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DB4 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DB6 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DB8 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DBA 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DBC 830C 
     2DBE 830D 
0089 2DC0 1608  14         jne   tmgr10                ; No, get next slot
0090 2DC2 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DC4 FF00 
0091 2DC6 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DC8 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DCA 8330 
0096 2DCC 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DCE C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DD0 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DD2 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DD4 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DD6 8315 
     2DD8 8314 
0103 2DDA 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DDC 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DDE 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DE0 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DE2 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DE4 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DE6 FF00 
0109 2DE8 10B4  14         jmp   tmgr1
0110 2DEA 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0228                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 2DEC E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DEE 2010 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2DF0 06A0  32         bl    @realkb               ; Scan full keyboard
     2DF2 27F4 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DF4 0460  28         b     @tmgr3                ; Exit
     2DF6 2D76 
**** **** ****     > runlib.asm
0229                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 2DF8 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DFA 832E 
0018 2DFC E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DFE 2012 
0019 2E00 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D52     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2E02 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E04 832E 
0029 2E06 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E08 FEFF 
0030 2E0A 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0230               
0232                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 2E0C C13B  30 mkslot  mov   *r11+,tmp0
0018 2E0E C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E10 C184  18         mov   tmp0,tmp2
0023 2E12 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E14 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E16 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E18 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E1A 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E1C C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E1E 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E20 2022 
0035 2E22 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E24 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E26 05CB  14 mkslo1  inct  r11
0041 2E28 045B  20         b     *r11                  ; Exit
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
0052 2E2A C13B  30 clslot  mov   *r11+,tmp0
0053 2E2C 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E2E A120  34         a     @wtitab,tmp0          ; Add table base
     2E30 832C 
0055 2E32 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E34 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E36 045B  20         b     *r11                  ; Exit
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
0068 2E38 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E3A 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E3C A120  34         a     @wtitab,tmp0          ; Add table base
     2E3E 832C 
0071 2E40 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E42 C154  26         mov   *tmp0,tmp1
0073 2E44 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E46 FF00 
0074 2E48 C505  30         mov   tmp1,*tmp0
0075 2E4A 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0234               
0235               
0236               
0237               *//////////////////////////////////////////////////////////////
0238               *                    RUNLIB INITIALISATION
0239               *//////////////////////////////////////////////////////////////
0240               
0241               ***************************************************************
0242               *  RUNLIB - Runtime library initalisation
0243               ***************************************************************
0244               *  B  @RUNLIB
0245               *--------------------------------------------------------------
0246               *  REMARKS
0247               *  if R0 in WS1 equals >4a4a we were called from the system
0248               *  crash handler so we return there after initialisation.
0249               
0250               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0251               *  after clearing scratchpad memory. This has higher priority
0252               *  as crash handler flag R0.
0253               ********|*****|*********************|**************************
0260 2E4C 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E4E 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E50 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E52 0000 
0266 2E54 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E56 8300 
0267 2E58 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E5A 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E5C 0202  20 runli2  li    r2,>8308
     2E5E 8308 
0272 2E60 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E62 0282  22         ci    r2,>8400
     2E64 8400 
0274 2E66 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E68 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E6A FFFF 
0279 2E6C 1602  14         jne   runli4                ; No, continue
0280 2E6E 0420  54         blwp  @0                    ; Yes, bye bye
     2E70 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E72 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E74 833C 
0285 2E76 04C1  14         clr   r1                    ; Reset counter
0286 2E78 0202  20         li    r2,10                 ; We test 10 times
     2E7A 000A 
0287 2E7C C0E0  34 runli5  mov   @vdps,r3
     2E7E 8802 
0288 2E80 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E82 2020 
0289 2E84 1302  14         jeq   runli6
0290 2E86 0581  14         inc   r1                    ; Increase counter
0291 2E88 10F9  14         jmp   runli5
0292 2E8A 0602  14 runli6  dec   r2                    ; Next test
0293 2E8C 16F7  14         jne   runli5
0294 2E8E 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E90 1250 
0295 2E92 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E94 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E96 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E98 06A0  32 runli7  bl    @loadmc
     2E9A 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E9C 04C1  14 runli9  clr   r1
0305 2E9E 04C2  14         clr   r2
0306 2EA0 04C3  14         clr   r3
0307 2EA2 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2EA4 3000 
0308 2EA6 020F  20         li    r15,vdpw              ; Set VDP write address
     2EA8 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2EAA 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EAC 4A4A 
0317 2EAE 1605  14         jne   runlia
0318 2EB0 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EB2 2292 
0319 2EB4 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EB6 0000 
     2EB8 3000 
0324 2EBA 06A0  32 runlia  bl    @filv
     2EBC 2292 
0325 2EBE 0FC0             data  pctadr,spfclr,16      ; Load color table
     2EC0 00F4 
     2EC2 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2EC4 06A0  32         bl    @f18unl               ; Unlock the F18A
     2EC6 2736 
0333 2EC8 06A0  32         bl    @f18chk               ; Check if F18A is there
     2ECA 2756 
0334 2ECC 06A0  32         bl    @f18lck               ; Lock the F18A again
     2ECE 274C 
0335               
0336 2ED0 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2ED2 2336 
0337 2ED4 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2ED6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2ED8 22FC 
0351 2EDA 33A6             data  spvmod                ; Equate selected video mode table
0352 2EDC 0204  20         li    tmp0,spfont           ; Get font option
     2EDE 000C 
0353 2EE0 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EE2 1304  14         jeq   runlid                ; Yes, skip it
0355 2EE4 06A0  32         bl    @ldfnt
     2EE6 2364 
0356 2EE8 1100             data  fntadr,spfont         ; Load specified font
     2EEA 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EEC 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EEE 4A4A 
0361 2EF0 1602  14         jne   runlie                ; No, continue
0362 2EF2 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EF4 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EF6 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EF8 0040 
0367 2EFA 0460  28         b     @main                 ; Give control to main program
     2EFC 6046 
**** **** ****     > stevie_b1.asm.3765856
0044                                                   ; Relocated spectra2 in low MEMEXP, was
0045                                                   ; copied to >2000 from ROM in bank 0
0046                       ;------------------------------------------------------
0047                       ; End of File marker
0048                       ;------------------------------------------------------
0049 2EFE DEAD             data >dead,>beef,>dead,>beef
     2F00 BEEF 
     2F02 DEAD 
     2F04 BEEF 
0051               ***************************************************************
0052               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0053               ********|*****|*********************|**************************
0054                       aorg  >3000
0055                       ;------------------------------------------------------
0056                       ; Activate bank 1 and branch to  >6036
0057                       ;------------------------------------------------------
0058 3000 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3002 6002 
0059               
0063               
0064 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6046 
0065                       ;------------------------------------------------------
0066                       ; Resident Stevie modules: >3000 - >3fff
0067                       ;------------------------------------------------------
0068                       copy  "ram.resident.3000.asm"
**** **** ****     > ram.resident.3000.asm
0001               * FILE......: ram.resident.3000.asm
0002               * Purpose...: Resident modules at RAM >3000 callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules >3000 - >3fff
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
0021 3008 C13B  30         mov   *r11+,tmp0            ; P0
0022 300A C17B  30         mov   *r11+,tmp1            ; P1
0023 300C C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 300E 0649  14         dect  stack
0029 3010 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 3012 0649  14         dect  stack
0031 3014 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 3016 0649  14         dect  stack
0033 3018 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 301A 0649  14         dect  stack
0035 301C C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 301E 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     3020 6000 
0040 3022 1111  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 3024 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     3026 A026 
0044 3028 0647  14         dect  tmp3
0045 302A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 302C 0647  14         dect  tmp3
0047 302E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 3030 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3032 A026 
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 3034 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 3036 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 3038 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 303A 0224  22         ai    tmp0,>0800
     303C 0800 
0066 303E 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071 3040 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0072 3042 1301  14         jeq   rom.farjump.bankswitch.failed1
0073                                                   ; Crash if null-pointer in vector
0074 3044 1004  14         jmp   rom.farjump.bankswitch.call
0075                                                   ; Call function in target bank
0076                       ;------------------------------------------------------
0077                       ; Assert 1 failed before bank-switch
0078                       ;------------------------------------------------------
0079               rom.farjump.bankswitch.failed1:
0080 3046 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3048 FFCE 
0081 304A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     304C 2026 
0082                       ;------------------------------------------------------
0083                       ; Call function in target bank
0084                       ;------------------------------------------------------
0085               rom.farjump.bankswitch.call:
0086 304E 0694  24         bl    *tmp0                 ; Call function
0087                       ;------------------------------------------------------
0088                       ; Bankswitch back to source bank
0089                       ;------------------------------------------------------
0090               rom.farjump.return:
0091 3050 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     3052 A026 
0092 3054 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0093 3056 1312  14         jeq   rom.farjump.bankswitch.failed2
0094                                                   ; Crash if null-pointer in address
0095               
0096 3058 04F4  30         clr   *tmp0+                ; Remove bank write address from
0097                                                   ; farjump stack
0098               
0099 305A C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0100               
0101 305C 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0102                                                   ; farjump stack
0103               
0104 305E 028B  22         ci    r11,>6000
     3060 6000 
0105 3062 110C  14         jlt   rom.farjump.bankswitch.failed2
0106 3064 028B  22         ci    r11,>7fff
     3066 7FFF 
0107 3068 1509  14         jgt   rom.farjump.bankswitch.failed2
0108               
0109 306A C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     306C A026 
0110               
0114               
0115                       ;------------------------------------------------------
0116                       ; Bankswitch to source 8K ROM bank
0117                       ;------------------------------------------------------
0118               rom.farjump.bankswitch.src.rom8k:
0119 306E 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0120 3070 1009  14         jmp   rom.farjump.exit
0121                       ;------------------------------------------------------
0122                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0123                       ;------------------------------------------------------
0124               rom.farjump.bankswitch.src.advfg99:
0125 3072 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0126 3074 0225  22         ai    tmp1,>0800
     3076 0800 
0127 3078 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0128 307A 1004  14         jmp   rom.farjump.exit
0129                       ;------------------------------------------------------
0130                       ; Assert 2 failed after bank-switch
0131                       ;------------------------------------------------------
0132               rom.farjump.bankswitch.failed2:
0133 307C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     307E FFCE 
0134 3080 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3082 2026 
0135                       ;-------------------------------------------------------
0136                       ; Exit
0137                       ;-------------------------------------------------------
0138               rom.farjump.exit:
0139 3084 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0140 3086 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 3088 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 308A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 308C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
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
0020 308E 0649  14         dect  stack
0021 3090 C64B  30         mov   r11,*stack            ; Save return address
0022 3092 0649  14         dect  stack
0023 3094 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3096 0649  14         dect  stack
0025 3098 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 309A 0204  20         li    tmp0,fb.top
     309C A600 
0030 309E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     30A0 A100 
0031 30A2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     30A4 A104 
0032 30A6 04E0  34         clr   @fb.row               ; Current row=0
     30A8 A106 
0033 30AA 04E0  34         clr   @fb.column            ; Current column=0
     30AC A10C 
0034               
0035 30AE 0204  20         li    tmp0,colrow
     30B0 0050 
0036 30B2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     30B4 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 30B6 C160  34         mov   @tv.ruler.visible,tmp1
     30B8 A010 
0041 30BA 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 30BC 0204  20         li    tmp0,pane.botrow-2
     30BE 001B 
0043 30C0 1002  14         jmp   fb.init.cont
0044 30C2 0204  20 !       li    tmp0,pane.botrow-1
     30C4 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 30C6 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     30C8 A11A 
0050 30CA C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30CC A11C 
0051               
0052 30CE 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30D0 A022 
0053 30D2 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30D4 A110 
0054 30D6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30D8 A116 
0055 30DA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30DC A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 30DE 06A0  32         bl    @film
     30E0 223A 
0060 30E2 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30E4 0000 
     30E6 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 30E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 30EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 30EC C2F9  30         mov   *stack+,r11           ; Pop r11
0068 30EE 045B  20         b     *r11                  ; Return to caller
0069               
**** **** ****     > ram.resident.3000.asm
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
0046 30F0 0649  14         dect  stack
0047 30F2 C64B  30         mov   r11,*stack            ; Save return address
0048 30F4 0649  14         dect  stack
0049 30F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30F8 0204  20         li    tmp0,idx.top
     30FA B000 
0054 30FC C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30FE A202 
0055               
0056 3100 C120  34         mov   @tv.sams.b000,tmp0
     3102 A006 
0057 3104 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     3106 A500 
0058 3108 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     310A A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 310C 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     310E 0004 
0063 3110 C804  38         mov   tmp0,@idx.sams.hipage ; /
     3112 A504 
0064               
0065 3114 06A0  32         bl    @_idx.sams.mapcolumn.on
     3116 3132 
0066                                                   ; Index in continuous memory region
0067               
0068 3118 06A0  32         bl    @film
     311A 223A 
0069 311C B000                   data idx.top,>00,idx.size * 5
     311E 0000 
     3120 5000 
0070                                                   ; Clear index
0071               
0072 3122 06A0  32         bl    @_idx.sams.mapcolumn.off
     3124 3166 
0073                                                   ; Restore memory window layout
0074               
0075 3126 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     3128 A502 
     312A A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 312C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 312E C2F9  30         mov   *stack+,r11           ; Pop r11
0083 3130 045B  20         b     *r11                  ; Return to caller
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
0096 3132 0649  14         dect  stack
0097 3134 C64B  30         mov   r11,*stack            ; Push return address
0098 3136 0649  14         dect  stack
0099 3138 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 313A 0649  14         dect  stack
0101 313C C645  30         mov   tmp1,*stack           ; Push tmp1
0102 313E 0649  14         dect  stack
0103 3140 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 3142 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3144 A502 
0108 3146 0205  20         li    tmp1,idx.top
     3148 B000 
0109 314A 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     314C 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 314E 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3150 257A 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 3152 0584  14         inc   tmp0                  ; Next SAMS index page
0118 3154 0225  22         ai    tmp1,>1000            ; Next memory region
     3156 1000 
0119 3158 0606  14         dec   tmp2                  ; Update loop counter
0120 315A 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 315C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 315E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 3160 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 3162 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3164 045B  20         b     *r11                  ; Return to caller
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
0145 3166 0649  14         dect  stack
0146 3168 C64B  30         mov   r11,*stack            ; Push return address
0147 316A 0649  14         dect  stack
0148 316C C644  30         mov   tmp0,*stack           ; Push tmp0
0149 316E 0649  14         dect  stack
0150 3170 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 3172 0649  14         dect  stack
0152 3174 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 3176 0649  14         dect  stack
0154 3178 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 317A 0205  20         li    tmp1,idx.top
     317C B000 
0159 317E 0206  20         li    tmp2,5                ; Always 5 pages
     3180 0005 
0160 3182 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3184 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 3186 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 3188 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     318A 257A 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 318C 0225  22         ai    tmp1,>1000            ; Next memory region
     318E 1000 
0171 3190 0606  14         dec   tmp2                  ; Update loop counter
0172 3192 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3194 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 3196 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 3198 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 319A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 319C C2F9  30         mov   *stack+,r11           ; Pop return address
0182 319E 045B  20         b     *r11                  ; Return to caller
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
0206 31A0 0649  14         dect  stack
0207 31A2 C64B  30         mov   r11,*stack            ; Save return address
0208 31A4 0649  14         dect  stack
0209 31A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 31A8 0649  14         dect  stack
0211 31AA C645  30         mov   tmp1,*stack           ; Push tmp1
0212 31AC 0649  14         dect  stack
0213 31AE C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 31B0 C184  18         mov   tmp0,tmp2             ; Line number
0218 31B2 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 31B4 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     31B6 0800 
0220               
0221 31B8 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 31BA 0A16  56         sla   tmp2,1                ; line number * 2
0226 31BC C806  38         mov   tmp2,@outparm1        ; Offset index entry
     31BE 2F30 
0227               
0228 31C0 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     31C2 A502 
0229 31C4 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     31C6 A500 
0230               
0231 31C8 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 31CA C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31CC A500 
0237 31CE C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31D0 A006 
0238               
0239 31D2 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31D4 0205  20         li    tmp1,>b000            ; Memory window for index page
     31D6 B000 
0241               
0242 31D8 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31DA 257A 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31DC 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31DE A504 
0249 31E0 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31E2 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31E4 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31E6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31EC C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31EE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
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
0022 31F0 0649  14         dect  stack
0023 31F2 C64B  30         mov   r11,*stack            ; Save return address
0024 31F4 0649  14         dect  stack
0025 31F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31F8 0204  20         li    tmp0,edb.top          ; \
     31FA C000 
0030 31FC C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31FE A200 
0031 3200 C804  38         mov   tmp0,@edb.next_free.ptr
     3202 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 3204 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     3206 A20A 
0035               
0036 3208 0204  20         li    tmp0,1
     320A 0001 
0037 320C C804  38         mov   tmp0,@edb.lines       ; Lines=1
     320E A204 
0038               
0039 3210 0720  34         seto  @edb.block.m1         ; Reset block start line
     3212 A20C 
0040 3214 0720  34         seto  @edb.block.m2         ; Reset block end line
     3216 A20E 
0041               
0042 3218 0204  20         li    tmp0,txt.newfile      ; "New file"
     321A 3530 
0043 321C C804  38         mov   tmp0,@edb.filename.ptr
     321E A212 
0044               
0045 3220 0204  20         li    tmp0,txt.filetype.none
     3222 35E8 
0046 3224 C804  38         mov   tmp0,@edb.filetype.ptr
     3226 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 3228 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 322A C2F9  30         mov   *stack+,r11           ; Pop r11
0054 322C 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > ram.resident.3000.asm
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
0022 322E 0649  14         dect  stack
0023 3230 C64B  30         mov   r11,*stack            ; Save return address
0024 3232 0649  14         dect  stack
0025 3234 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3236 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3238 D000 
0030 323A C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     323C A300 
0031               
0032 323E 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3240 A302 
0033 3242 0204  20         li    tmp0,4
     3244 0004 
0034 3246 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3248 A306 
0035 324A C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     324C A308 
0036               
0037 324E 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3250 A316 
0038 3252 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3254 A318 
0039 3256 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3258 A326 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 325A 06A0  32         bl    @film
     325C 223A 
0044 325E D000             data  cmdb.top,>00,cmdb.size
     3260 0000 
     3262 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3264 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3266 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3268 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
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
0022 326A 0649  14         dect  stack
0023 326C C64B  30         mov   r11,*stack            ; Save return address
0024 326E 0649  14         dect  stack
0025 3270 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3272 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3274 A028 
0030               
0031 3276 06A0  32         bl    @film
     3278 223A 
0032 327A A02A                   data tv.error.msg,0,160
     327C 0000 
     327E 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3280 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3282 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3284 045B  20         b     *r11                  ; Return to caller
0040               
**** **** ****     > ram.resident.3000.asm
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
0022 3286 0649  14         dect  stack
0023 3288 C64B  30         mov   r11,*stack            ; Save return address
0024 328A 0649  14         dect  stack
0025 328C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 328E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3290 0001 
0030 3292 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3294 A012 
0031               
0032 3296 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3298 A024 
0033 329A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     329C 200C 
0034               
0035 329E 0204  20         li    tmp0,fj.bottom
     32A0 F000 
0036 32A2 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     32A4 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 32A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 32A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 32AA 045B  20         b     *r11                  ; Return to caller
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
0065 32AC 0649  14         dect  stack
0066 32AE C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 32B0 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32B2 322E 
0071 32B4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32B6 31F0 
0072 32B8 06A0  32         bl    @idx.init             ; Initialize index
     32BA 30F0 
0073 32BC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32BE 308E 
0074 32C0 06A0  32         bl    @errline.init         ; Initialize error line
     32C2 326A 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 32C4 06A0  32         bl    @hchar
     32C6 27CC 
0079 32C8 0034                   byte 0,52,32,18           ; Remove markers
     32CA 2012 
0080 32CC 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     32CE 2033 
0081 32D0 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32D2 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32D4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
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
0020 32D6 0649  14         dect  stack
0021 32D8 C64B  30         mov   r11,*stack            ; Save return address
0022 32DA 0649  14         dect  stack
0023 32DC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32DE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32E0 29DE 
0028 32E2 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32E4 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32E6 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32E8 0204  20         li    tmp0,unpacked.string
     32EA 2F44 
0034 32EC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32EE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32F0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32F2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32F4 2A36 
0039 32F6 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32F8 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32FA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32FE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3300 045B  20         b     *r11                  ; Return to caller
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
0073 3302 0649  14         dect  stack
0074 3304 C64B  30         mov   r11,*stack            ; Push return address
0075 3306 0649  14         dect  stack
0076 3308 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 330A 0649  14         dect  stack
0078 330C C645  30         mov   tmp1,*stack           ; Push tmp1
0079 330E 0649  14         dect  stack
0080 3310 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 3312 0649  14         dect  stack
0082 3314 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 3316 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     3318 2F20 
0087 331A D194  26         movb  *tmp0,tmp2            ; /
0088 331C 0986  56         srl   tmp2,8                ; Right align
0089 331E C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 3320 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3322 2F22 
0092 3324 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 3326 C120  34         mov   @parm1,tmp0           ; Get source address
     3328 2F20 
0097 332A C160  34         mov   @parm4,tmp1           ; Get destination address
     332C 2F26 
0098 332E 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3330 0649  14         dect  stack
0101 3332 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 3334 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3336 24E4 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 3338 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 333A C120  34         mov   @parm2,tmp0           ; Get requested length
     333C 2F22 
0113 333E 0A84  56         sla   tmp0,8                ; Left align
0114 3340 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3342 2F26 
0115 3344 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 3346 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 3348 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 334A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     334C 2F22 
0122 334E 6187  18         s     tmp3,tmp2             ; |
0123 3350 0586  14         inc   tmp2                  ; /
0124               
0125 3352 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3354 2F24 
0126 3356 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 3358 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 335A 0606  14         dec   tmp2                  ; Update loop counter
0133 335C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 335E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3360 2F26 
     3362 2F30 
0136 3364 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 3366 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3368 FFCE 
0142 336A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     336C 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 336E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3370 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3372 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3374 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 3376 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 3378 045B  20         b     *r11                  ; Return to caller
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
0174 337A 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     337C 27A0 
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 337E 04E0  34         clr   @bank0.rom            ; Activate bank 0
     3380 6000 
0179 3382 0420  54         blwp  @0                    ; Reset to monitor
     3384 0000 
**** **** ****     > ram.resident.3000.asm
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
0017 3386 0649  14         dect  stack
0018 3388 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 338A 06A0  32         bl    @sams.layout
     338C 25E6 
0023 338E 33BE                   data mem.sams.layout.data
0024               
0025 3390 06A0  32         bl    @sams.layout.copy
     3392 264A 
0026 3394 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 3396 C820  54         mov   @tv.sams.c000,@edb.sams.page
     3398 A008 
     339A A216 
0029 339C C820  54         mov   @edb.sams.page,@edb.sams.hipage
     339E A216 
     33A0 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 33A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 33A4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
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
0033 33A6 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     33A8 003F 
     33AA 0243 
     33AC 05F4 
     33AE 0050 
0034               
0035               romsat:
0036 33B0 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     33B2 0201 
0037 33B4 0000             data  >0000,>0301             ; Current line indicator
     33B6 0301 
0038 33B8 0820             data  >0820,>0401             ; Current line indicator
     33BA 0401 
0039               nosprite:
0040 33BC D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 33BE 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     33C0 0002 
0048 33C2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     33C4 0003 
0049 33C6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     33C8 000A 
0050               
0051 33CA B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     33CC 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 33CE C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     33D0 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 33D2 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     33D4 000D 
0060 33D6 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     33D8 000E 
0061 33DA F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     33DC 000F 
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
0117 33DE F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     33E0 F171 
     33E2 1B1F 
     33E4 71B1 
0118 33E6 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     33E8 F0FF 
     33EA 1F1A 
     33EC F1FF 
0119 33EE 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     33F0 F0FF 
     33F2 1F12 
     33F4 F1F6 
0120 33F6 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     33F8 1E11 
     33FA 1A17 
     33FC 1E11 
0121 33FE E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3400 E1FF 
     3402 1F1E 
     3404 E1FF 
0122 3406 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3408 1016 
     340A 1B71 
     340C 1711 
0123 340E 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3410 1011 
     3412 F1F1 
     3414 1F11 
0124 3416 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     3418 A1FF 
     341A 1F1F 
     341C F11F 
0125 341E 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3420 12FF 
     3422 1B12 
     3424 12FF 
0126 3426 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     3428 E1FF 
     342A 1B1F 
     342C F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 342E 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3430 0C19 
0131 3432 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     3434 3B4F 
0132 3436 FF00             byte  >ff,0,0,0               ; |
     3438 0000 
0133 343A 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     343C 0000 
0134 343E 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3440 0000 
0135                       even
**** **** ****     > ram.resident.3000.asm
0017                       copy  "data.strings.asm"       ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               ;--------------------------------------------------------------
0009               ; Strings for about pane
0010               ;--------------------------------------------------------------
0011               txt.stevie
0012 3442 0B53             byte  11
0013 3443 ....             text  'STEVIE 1.1P'
0014                       even
0015               
0016               txt.about.build
0017 344E 4C42             byte  76
0018 344F ....             text  'Build: 210807-3765856 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 349C 012C             byte  1
0024 349D ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 349E 0520             byte  5
0029 349F ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 34A4 034F             byte  3
0034 34A5 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 34A8 0349             byte  3
0039 34A9 ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 34AC 012A             byte  1
0044 34AD ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34AE 0A4C             byte  10
0049 34AF ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34BA 0A53             byte  10
0054 34BB ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34C6 1244             byte  18
0059 34C7 ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34DA 1143             byte  17
0064 34DB ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34EC 104D             byte  16
0069 34ED ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 34FE 1D53             byte  29
0074 34FF ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 351C 0846             byte  8
0079 351D ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 3526 026B             byte  2
0084 3527 ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 352A 054C             byte  5
0089 352B ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 3530 0A5B             byte  10
0094 3531 ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 353C 0444             byte  4
0099 353D ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 3542 034D             byte  3
0104 3543 ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 3546 034D             byte  3
0109 3547 ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 354A 0746             byte  7
0114 354B ....             text  'F9=Menu'
0115                       even
0116               
0117               txt.keys.block
0118 3552 3342             byte  51
0119 3553 ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0120                       even
0121               
0122 3586 ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 3590 ....                        text    '.........'
0125                                  byte    19
0126 359A ....                        text    '.........'
0127                                  byte    20
0128 35A4 ....                        text    '.........'
0129                                  byte    21
0130 35AE ....                        text    '.........'
0131                                  byte    22
0132 35B8 ....                        text    '.........'
0133                                  byte    23
0134 35C2 ....                        text    '.........'
0135                                  byte    24
0136 35CC ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139 35D6 020E     txt.alpha.down     data >020e,>0f00
     35D8 0F00 
0140 35DA 0110     txt.vertline       data >0110
0141 35DC 011C     txt.keymarker      byte 1,28
0142               
0143               txt.ws1
0144 35DE 0120             byte  1
0145 35DF ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 35E0 0220             byte  2
0150 35E1 ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 35E4 0320             byte  3
0155 35E5 ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 35E8 0420             byte  4
0160 35E9 ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 35EE 0520             byte  5
0165 35EF ....             text  '     '
0166                       even
0167               
0168      35E8     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 35F4 1301     txt.head.load      byte 19,1,3
     35F6 0320 
0175 35F7 ....                        text ' Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 3608 3D53             byte  61
0179 3609 ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 3646 3C46     txt.keys.load      byte 60
0184 3647 ....                        text 'File'
0185                                  byte 27
0186 364C ....                        text 'Open: F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End '
0187               
0188 3684 3D46     txt.keys.load2     byte 61
0189 3685 ....                        text 'File'
0190                                  byte 27
0191 368A ....                        text 'Open: F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End '
0192               
0193               ;--------------------------------------------------------------
0194               ; Dialog Save DV 80 file
0195               ;--------------------------------------------------------------
0196 36C4 0103     txt.head.save      byte 19,1,3
0197 36C6 ....                        text ' Save DV80 file '
0198 36D6 0223                        byte 2
0199 36D8 0103     txt.head.save2     byte 35,1,3,32
     36DA 2053 
0200 36DB ....                        text 'Save marked block to DV80 file '
0201 36FA 0201                        byte 2
0202               txt.hint.save
0203                       byte  1
0204 36FC ....             text  ' '
0205                       even
0206               
0207               
0208 36FE 2F46     txt.keys.save      byte 47
0209 36FF ....                        text 'File'
0210                                  byte 27
0211 3704 ....                        text 'Save: F9=Back  F3=Clear  F-H=Home  F-L=End'
0212               
0213               ;--------------------------------------------------------------
0214               ; Dialog "Unsaved changes"
0215               ;--------------------------------------------------------------
0216 372E 1401     txt.head.unsaved   byte 20,1,3
     3730 0320 
0217 3731 ....                        text ' Unsaved changes '
0218 3742 0221                        byte 2
0219               txt.info.unsaved
0220                       byte  33
0221 3744 ....             text  'Warning! Unsaved changes in file.'
0222                       even
0223               
0224               txt.hint.unsaved
0225 3766 2A50             byte  42
0226 3767 ....             text  'Press F6 to proceed or ENTER to save file.'
0227                       even
0228               
0229               txt.keys.unsaved
0230 3792 2843             byte  40
0231 3793 ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0232                       even
0233               
0234               
0235               ;--------------------------------------------------------------
0236               ; Dialog "About"
0237               ;--------------------------------------------------------------
0238 37BC 0A01     txt.head.about     byte 10,1,3
     37BE 0320 
0239 37BF ....                        text ' About '
0240 37C6 0200                        byte 2
0241               
0242               txt.info.about
0243                       byte  0
0244 37C8 ....             text
0245                       even
0246               
0247               txt.hint.about
0248 37C8 1D50             byte  29
0249 37C9 ....             text  'Press F9 to return to editor.'
0250                       even
0251               
0252 37E6 2148     txt.keys.about     byte 33
0253 37E7 ....                        text 'Help: F9=Back  '
0254 37F6 0E0F                        byte 14,15
0255 37F8 ....                        text '=Alpha Lock down'
0256               
0257               
0258               ;--------------------------------------------------------------
0259               ; Dialog "Menu"
0260               ;--------------------------------------------------------------
0261 3808 1001     txt.head.menu      byte 16,1,3
     380A 0320 
0262 380B ....                        text ' Stevie 1.1P '
0263 3818 0210                        byte 2
0264               
0265               txt.info.menu
0266                       byte  16
0267 381A ....             text  'File  Help  Quit'
0268                       even
0269               
0270 382A 0006     pos.info.menu      byte 0,6,12,>ff
     382C 0CFF 
0271               txt.hint.menu
0272 382E 2650             byte  38
0273 382F ....             text  'Press F,H,Q or F9 to return to editor.'
0274                       even
0275               
0276               txt.keys.menu
0277 3856 0D4D             byte  13
0278 3857 ....             text  'Menu: F9=Back'
0279                       even
0280               
0281               
0282               
0283               ;--------------------------------------------------------------
0284               ; Dialog "File"
0285               ;--------------------------------------------------------------
0286 3864 0901     txt.head.file      byte 9,1,3
     3866 0320 
0287 3867 ....                        text ' File '
0288                                  byte 2
0289               
0290               txt.info.file
0291 386E 0F4E             byte  15
0292 386F ....             text  'New  Open  Save'
0293                       even
0294               
0295 387E 0005     pos.info.file      byte 0,5,11,>ff
     3880 0BFF 
0296               txt.hint.file
0297 3882 2650             byte  38
0298 3883 ....             text  'Press N,O,S or F9 to return to editor.'
0299                       even
0300               
0301               txt.keys.file
0302 38AA 0D46             byte  13
0303 38AB ....             text  'File: F9=Back'
0304                       even
0305               
0306               
0307               
0308               
0309               ;--------------------------------------------------------------
0310               ; Strings for error line pane
0311               ;--------------------------------------------------------------
0312               txt.ioerr.load
0313 38B8 2049             byte  32
0314 38B9 ....             text  'I/O error. Failed loading file: '
0315                       even
0316               
0317               txt.ioerr.save
0318 38DA 2049             byte  32
0319 38DB ....             text  'I/O error. Failed saving file:  '
0320                       even
0321               
0322               txt.memfull.load
0323 38FC 4049             byte  64
0324 38FD ....             text  'Index memory full. Could not fully load file into editor buffer.'
0325                       even
0326               
0327               txt.io.nofile
0328 393E 2149             byte  33
0329 393F ....             text  'I/O error. No filename specified.'
0330                       even
0331               
0332               txt.block.inside
0333 3960 3445             byte  52
0334 3961 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0335                       even
0336               
0337               
0338               ;--------------------------------------------------------------
0339               ; Strings for command buffer
0340               ;--------------------------------------------------------------
0341               txt.cmdb.prompt
0342 3996 013E             byte  1
0343 3997 ....             text  '>'
0344                       even
0345               
0346               txt.colorscheme
0347 3998 0D43             byte  13
0348 3999 ....             text  'Color scheme:'
0349                       even
0350               
**** **** ****     > ram.resident.3000.asm
0018                       copy  "data.keymap.keys.asm"   ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Keyboard scancodes - Letter keys
0007               *-------------|---------------------|---------------------------
0008      0046     key.uc.f      equ >46               ; F
0009      0048     key.uc.h      equ >48               ; H
0010      004E     key.uc.n      equ >4e               ; N
0011      0053     key.uc.s      equ >53               ; S
0012      004F     key.uc.o      equ >4f               ; O
0013      0051     key.uc.q      equ >51               ; Q
0014      00A6     key.lc.f      equ >a6               ; f
0015      00A8     key.lc.h      equ >a8               ; h
0016      006E     key.lc.n      equ >6e               ; n
0017      0073     key.lc.s      equ >73               ; s
0018      006F     key.lc.o      equ >6f               ; o
0019      0071     key.lc.q      equ >71               ; q
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Keyboard scancodes - Function keys
0024               *-------------|---------------------|---------------------------
0025      00BC     key.fctn.0    equ >bc               ; fctn + 0
0026      0003     key.fctn.1    equ >03               ; fctn + 1
0027      0004     key.fctn.2    equ >04               ; fctn + 2
0028      0007     key.fctn.3    equ >07               ; fctn + 3
0029      0002     key.fctn.4    equ >02               ; fctn + 4
0030      000E     key.fctn.5    equ >0e               ; fctn + 5
0031      000C     key.fctn.6    equ >0c               ; fctn + 6
0032      0001     key.fctn.7    equ >01               ; fctn + 7
0033      0006     key.fctn.8    equ >06               ; fctn + 8
0034      000F     key.fctn.9    equ >0f               ; fctn + 9
0035      0000     key.fctn.a    equ >00               ; fctn + a
0036      00BE     key.fctn.b    equ >be               ; fctn + b
0037      0000     key.fctn.c    equ >00               ; fctn + c
0038      0009     key.fctn.d    equ >09               ; fctn + d
0039      000B     key.fctn.e    equ >0b               ; fctn + e
0040      0000     key.fctn.f    equ >00               ; fctn + f
0041      0000     key.fctn.g    equ >00               ; fctn + g
0042      00BF     key.fctn.h    equ >bf               ; fctn + h
0043      0000     key.fctn.i    equ >00               ; fctn + i
0044      00C0     key.fctn.j    equ >c0               ; fctn + j
0045      00C1     key.fctn.k    equ >c1               ; fctn + k
0046      00C2     key.fctn.l    equ >c2               ; fctn + l
0047      00C3     key.fctn.m    equ >c3               ; fctn + m
0048      00C4     key.fctn.n    equ >c4               ; fctn + n
0049      0000     key.fctn.o    equ >00               ; fctn + o
0050      0000     key.fctn.p    equ >00               ; fctn + p
0051      00C5     key.fctn.q    equ >c5               ; fctn + q
0052      0000     key.fctn.r    equ >00               ; fctn + r
0053      0008     key.fctn.s    equ >08               ; fctn + s
0054      0000     key.fctn.t    equ >00               ; fctn + t
0055      0000     key.fctn.u    equ >00               ; fctn + u
0056      007F     key.fctn.v    equ >7f               ; fctn + v
0057      007E     key.fctn.w    equ >7e               ; fctn + w
0058      000A     key.fctn.x    equ >0a               ; fctn + x
0059      00C6     key.fctn.y    equ >c6               ; fctn + y
0060      0000     key.fctn.z    equ >00               ; fctn + z
0061               *---------------------------------------------------------------
0062               * Keyboard scancodes - Function keys extra
0063               *---------------------------------------------------------------
0064      00B9     key.fctn.dot    equ >b9             ; fctn + .
0065      00B8     key.fctn.comma  equ >b8             ; fctn + ,
0066      0005     key.fctn.plus   equ >05             ; fctn + +
0067               *---------------------------------------------------------------
0068               * Keyboard scancodes - control keys
0069               *-------------|---------------------|---------------------------
0070      00B0     key.ctrl.0    equ >b0               ; ctrl + 0
0071      00B1     key.ctrl.1    equ >b1               ; ctrl + 1
0072      00B2     key.ctrl.2    equ >b2               ; ctrl + 2
0073      00B3     key.ctrl.3    equ >b3               ; ctrl + 3
0074      00B4     key.ctrl.4    equ >b4               ; ctrl + 4
0075      00B5     key.ctrl.5    equ >b5               ; ctrl + 5
0076      00B6     key.ctrl.6    equ >b6               ; ctrl + 6
0077      00B7     key.ctrl.7    equ >b7               ; ctrl + 7
0078      009E     key.ctrl.8    equ >9e               ; ctrl + 8
0079      009F     key.ctrl.9    equ >9f               ; ctrl + 9
0080      0081     key.ctrl.a    equ >81               ; ctrl + a
0081      0082     key.ctrl.b    equ >82               ; ctrl + b
0082      0083     key.ctrl.c    equ >83               ; ctrl + c
0083      0084     key.ctrl.d    equ >84               ; ctrl + d
0084      0085     key.ctrl.e    equ >85               ; ctrl + e
0085      0086     key.ctrl.f    equ >86               ; ctrl + f
0086      0087     key.ctrl.g    equ >87               ; ctrl + g
0087      0088     key.ctrl.h    equ >88               ; ctrl + h
0088      0089     key.ctrl.i    equ >89               ; ctrl + i
0089      008A     key.ctrl.j    equ >8a               ; ctrl + j
0090      008B     key.ctrl.k    equ >8b               ; ctrl + k
0091      008C     key.ctrl.l    equ >8c               ; ctrl + l
0092      008D     key.ctrl.m    equ >8d               ; ctrl + m
0093      008E     key.ctrl.n    equ >8e               ; ctrl + n
0094      008F     key.ctrl.o    equ >8f               ; ctrl + o
0095      0090     key.ctrl.p    equ >90               ; ctrl + p
0096      0091     key.ctrl.q    equ >91               ; ctrl + q
0097      0092     key.ctrl.r    equ >92               ; ctrl + r
0098      0093     key.ctrl.s    equ >93               ; ctrl + s
0099      0094     key.ctrl.t    equ >94               ; ctrl + t
0100      0095     key.ctrl.u    equ >95               ; ctrl + u
0101      0096     key.ctrl.v    equ >96               ; ctrl + v
0102      0097     key.ctrl.w    equ >97               ; ctrl + w
0103      0098     key.ctrl.x    equ >98               ; ctrl + x
0104      0099     key.ctrl.y    equ >99               ; ctrl + y
0105      009A     key.ctrl.z    equ >9a               ; ctrl + z
0106               *---------------------------------------------------------------
0107               * Keyboard scancodes - control keys extra
0108               *---------------------------------------------------------------
0109      009B     key.ctrl.dot    equ >9b             ; ctrl + .
0110      0080     key.ctrl.comma  equ >80             ; ctrl + ,
0111      009D     key.ctrl.plus   equ >9d             ; ctrl + +
0112               *---------------------------------------------------------------
0113               * Special keys
0114               *---------------------------------------------------------------
0115      000D     key.enter     equ >0d               ; enter
**** **** ****     > ram.resident.3000.asm
0019                       ;------------------------------------------------------
0020                       ; End of File marker
0021                       ;------------------------------------------------------
0022 39A6 DEAD             data  >dead,>beef,>dead,>beef
     39A8 BEEF 
     39AA DEAD 
     39AC BEEF 
**** **** ****     > stevie_b1.asm.3765856
0069               ***************************************************************
0070               * Step 4: Include main editor modules
0071               ********|*****|*********************|**************************
0072               main:
0073                       aorg  kickstart.code2       ; >6046
0074 6046 0460  28         b     @main.stevie          ; Start editor
     6048 604A 
0075                       ;-----------------------------------------------------------------------
0076                       ; Include files
0077                       ;-----------------------------------------------------------------------
0078                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
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
0029 604E 1302  14         jeq   main.continue
0030 6050 0460  28         b     @tv.quit              ; Exit for now if no F18a detected
     6052 337A 
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6054 06A0  32         bl    @scroff               ; Turn screen off
     6056 2692 
0037               
0038 6058 06A0  32         bl    @f18unl               ; Unlock the F18a
     605A 2736 
0039               
0041               
0042 605C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     605E 2336 
0043 6060 3140                   data >3140            ; F18a VR49 (>31), bit 40
0044               
0046               
0047 6062 06A0  32         bl    @putvr                ; Turn on position based attributes
     6064 2336 
0048 6066 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6068 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     606A 2336 
0051 606C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 606E 06A0  32         bl    @filv
     6070 2292 
0056 6072 0000                   data >0000,32,vdp.sit.size
     6074 0020 
     6076 0960 
0057                                                   ; Clear screen
0058                       ;------------------------------------------------------
0059                       ; Initialize high memory expansion
0060                       ;------------------------------------------------------
0061 6078 06A0  32         bl    @film
     607A 223A 
0062 607C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     607E 0000 
     6080 6000 
0063                       ;------------------------------------------------------
0064                       ; Setup SAMS windows
0065                       ;------------------------------------------------------
0066 6082 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6084 3386 
0067                       ;------------------------------------------------------
0068                       ; Setup cursor, screen, etc.
0069                       ;------------------------------------------------------
0070 6086 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6088 26B2 
0071 608A 06A0  32         bl    @s8x8                 ; Small sprite
     608C 26C2 
0072               
0073 608E 06A0  32         bl    @cpym2m
     6090 24DE 
0074 6092 33B0                   data romsat,ramsat,14 ; Load sprite SAT
     6094 2F5A 
     6096 000E 
0075               
0076 6098 C820  54         mov   @romsat+2,@tv.curshape
     609A 33B2 
     609C A014 
0077                                                   ; Save cursor shape & color
0078               
0079 609E 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     60A0 7D96 
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 3286 
0084 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 32AC 
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 7754 
0089                                                   ; Load color scheme and turn on screen
0090                       ;-------------------------------------------------------
0091                       ; Setup editor tasks & hook
0092                       ;-------------------------------------------------------
0093 60AE 0204  20         li    tmp0,>0300
     60B0 0300 
0094 60B2 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60B4 8314 
0095               
0096 60B6 06A0  32         bl    @at
     60B8 26D2 
0097 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0098               
0099 60BC 0204  20         li    tmp0,timers
     60BE 2F4A 
0100 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0101               
0103               
0104 60C4 06A0  32         bl    @mkslot
     60C6 2E0C 
0105 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 750A 
0106 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60CE 7596 
0107 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D2 7632 
0108 60D4 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D6 7660 
0109 60D8 FFFF                   data eol
0110               
0120               
0121               
0122 60DA 06A0  32         bl    @mkhook
     60DC 2DF8 
0123 60DE 74B4                   data hook.keyscan     ; Setup user hook
0124               
0125 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D4E 
**** **** ****     > stevie_b1.asm.3765856
0079                       ;-----------------------------------------------------------------------
0080                       ; Keyboard actions
0081                       ;-----------------------------------------------------------------------
0082                       copy  "edkey.key.process.asm"    ; Process keyboard actions
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 60E4 C160  34         mov   @waux1,tmp1           ; \
     60E6 833C 
0009 60E8 0245  22         andi  tmp1,>ff00            ; | Get key value and clear LSB
     60EA FF00 
0010 60EC C805  38         mov   tmp1,@waux1           ; /
     60EE 833C 
0011 60F0 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 60F2 C1A0  34         mov   @tv.pane.focus,tmp2
     60F4 A022 
0016 60F6 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60F8 0000 
0017 60FA 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 60FC 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     60FE 0001 
0021 6100 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 6102 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6104 FFCE 
0027 6106 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6108 2026 
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 610A 0206  20         li    tmp2,keymap_actions.editor
     610C 7EC4 
0033 610E 1002  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6110 0206  20         li    tmp2,keymap_actions.cmdb
     6112 7F5E 
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 6114 91D6  26         cb    *tmp2,tmp3            ; EOL reached ?
0044 6116 1327  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed, so
0046                                                   ; add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 6118 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0051 611A 130F  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053                       ;-------------------------------------------------------
0054                       ; If key in range 'a..z' then also check 'A..Z'
0055                       ;-------------------------------------------------------
0056 611C 0285  22         ci    tmp1,>6100            ; ASCII 97 'a'
     611E 6100 
0057 6120 1109  14         jlt   edkey.key.check.next.entry
0058               
0059 6122 0285  22         ci    tmp1,>7a00            ; ASCII 122 'z'
     6124 7A00 
0060 6126 1506  14         jgt   edkey.key.check.next.entry
0061               
0062 6128 0225  22         ai    tmp1,->2000           ; Make uppercase
     612A E000 
0063 612C 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0064 612E 1305  14         jeq   edkey.key.check.scope
0065                                                   ; Yes, check scope
0066                       ;-------------------------------------------------------
0067                       ; Key is no action key, keep case for later (buffer)
0068                       ;-------------------------------------------------------
0069 6130 0225  22         ai    tmp1,>2000            ; Make lowercase
     6132 2000 
0070               
0071               edkey.key.check.next.entry:
0072 6134 0226  22         ai    tmp2,4                ; Skip current entry
     6136 0004 
0073 6138 10ED  14         jmp   edkey.key.check.next  ; Check next entry
0074                       ;-------------------------------------------------------
0075                       ; Check scope of key
0076                       ;-------------------------------------------------------
0077               edkey.key.check.scope:
0078 613A 0586  14         inc   tmp2                  ; Move to scope
0079 613C 9816  46         cb    *tmp2,@tv.pane.focus+1
     613E A023 
0080                                                   ; (1) Process key if scope matches pane
0081 6140 1308  14         jeq   edkey.key.process.action
0082               
0083 6142 9816  46         cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
     6144 A31B 
0084 6146 1305  14         jeq   edkey.key.process.action
0085                       ;-------------------------------------------------------
0086                       ; Key pressed outside valid scope, ignore action entry
0087                       ;-------------------------------------------------------
0088 6148 0226  22         ai    tmp2,3                ; Skip current entry
     614A 0003 
0089 614C C160  34         mov   @waux1,tmp1           ; Restore original case of key
     614E 833C 
0090 6150 10E1  14         jmp   edkey.key.check.next  ; Process next action entry
0091                       ;-------------------------------------------------------
0092                       ; Trigger keyboard action
0093                       ;-------------------------------------------------------
0094               edkey.key.process.action:
0095 6152 0586  14         inc   tmp2                  ; Move to action address
0096 6154 C196  26         mov   *tmp2,tmp2            ; Get action address
0097               
0098 6156 0204  20         li    tmp0,id.dialog.unsaved
     6158 0065 
0099 615A 8120  34         c     @cmdb.dialog,tmp0
     615C A31A 
0100 615E 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0101               
0102 6160 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6162 A326 
0103 6164 0456  20 !       b     *tmp2                 ; Process key action
0104                       ;-------------------------------------------------------
0105                       ; Add character to editor or cmdb buffer
0106                       ;-------------------------------------------------------
0107               edkey.key.process.addbuffer:
0108 6166 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     6168 A022 
0109 616A 1602  14         jne   !                     ; No, skip frame buffer
0110 616C 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     616E 66B0 
0111                       ;-------------------------------------------------------
0112                       ; CMDB buffer
0113                       ;-------------------------------------------------------
0114 6170 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6172 0001 
0115 6174 1607  14         jne   edkey.key.process.crash
0116                                                   ; No, crash
0117                       ;-------------------------------------------------------
0118                       ; Don't add character if dialog has ID >= 100
0119                       ;-------------------------------------------------------
0120 6176 C120  34         mov   @cmdb.dialog,tmp0
     6178 A31A 
0121 617A 0284  22         ci    tmp0,99
     617C 0063 
0122 617E 1506  14         jgt   edkey.key.process.exit
0123                       ;-------------------------------------------------------
0124                       ; Add character to CMDB
0125                       ;-------------------------------------------------------
0126 6180 0460  28         b     @edkey.action.cmdb.char
     6182 68C8 
0127                                                   ; Add character to CMDB buffer
0128                       ;-------------------------------------------------------
0129                       ; Crash
0130                       ;-------------------------------------------------------
0131               edkey.key.process.crash:
0132 6184 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6186 FFCE 
0133 6188 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     618A 2026 
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137               edkey.key.process.exit:
0138 618C 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     618E 74FE 
**** **** ****     > stevie_b1.asm.3765856
0083                       ;-----------------------------------------------------------------------
0084                       ; Keyboard actions - Framebuffer (1)
0085                       ;-----------------------------------------------------------------------
0086                       copy  "edkey.fb.mov.leftright.asm"
**** **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 6190 C120  34         mov   @fb.column,tmp0
     6192 A10C 
0009 6194 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6196 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6198 A10C 
0014 619A 0620  34         dec   @wyx                  ; Column-- VDP cursor
     619C 832A 
0015 619E 0620  34         dec   @fb.current
     61A0 A102 
0016 61A2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61A4 A118 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 61A6 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61A8 74FE 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 61AA 8820  54         c     @fb.column,@fb.row.length
     61AC A10C 
     61AE A108 
0028 61B0 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 61B2 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     61B4 A10C 
0033 61B6 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     61B8 832A 
0034 61BA 05A0  34         inc   @fb.current
     61BC A102 
0035 61BE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C0 A118 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 61C2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61C4 74FE 
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61C6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C8 A118 
0047 61CA C120  34         mov   @wyx,tmp0
     61CC 832A 
0048 61CE 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     61D0 FF00 
0049 61D2 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     61D4 832A 
0050 61D6 04E0  34         clr   @fb.column
     61D8 A10C 
0051 61DA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61DC 6A50 
0052 61DE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61E0 A118 
0053                       ;-------------------------------------------------------
0054                       ; Exit
0055                       ;-------------------------------------------------------
0056 61E2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61E4 74FE 
0057               
0058               
0059               *---------------------------------------------------------------
0060               * Cursor end of line
0061               *---------------------------------------------------------------
0062               edkey.action.end:
0063 61E6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61E8 A118 
0064 61EA C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61EC A108 
0065 61EE 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61F0 0050 
0066 61F2 1102  14         jlt   !                     ; | is right of last character on line,
0067 61F4 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61F6 004F 
0068                       ;-------------------------------------------------------
0069                       ; Set cursor X position
0070                       ;-------------------------------------------------------
0071 61F8 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61FA A10C 
0072 61FC 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61FE 26EA 
0073 6200 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6202 6A50 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077 6204 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6206 74FE 
**** **** ****     > stevie_b1.asm.3765856
0087                                                        ; Move left / right / home / end
0088                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 6208 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     620A A118 
0009 620C C120  34         mov   @fb.column,tmp0
     620E A10C 
0010 6210 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 6212 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6214 A102 
0015 6216 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 6218 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 621A 0605  14         dec   tmp1
0022 621C 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 621E 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 6220 D195  26         movb  *tmp1,tmp2            ; Get character
0030 6222 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 6224 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 6226 0986  56         srl   tmp2,8                ; Right justify
0033 6228 0286  22         ci    tmp2,32               ; Space character found?
     622A 0020 
0034 622C 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 622E 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6230 2020 
0040 6232 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 6234 0287  22         ci    tmp3,>20ff            ; First character is space
     6236 20FF 
0043 6238 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 623A C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     623C A10C 
0048 623E 61C4  18         s     tmp0,tmp3
0049 6240 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6242 0002 
0050 6244 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 6246 0585  14         inc   tmp1
0056 6248 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 624A C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     624C A10C 
0062 624E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6250 26EA 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 6252 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6254 6A50 
0068 6256 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6258 74FE 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 625A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     625C A118 
0077 625E 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 6260 C120  34         mov   @fb.column,tmp0
     6262 A10C 
0079 6264 8804  38         c     tmp0,@fb.row.length
     6266 A108 
0080 6268 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 626A C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     626C A102 
0085 626E 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6270 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 6272 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 6274 0585  14         inc   tmp1
0097 6276 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6278 8804  38         c     tmp0,@fb.row.length
     627A A108 
0099 627C 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 627E D195  26         movb  *tmp1,tmp2            ; Get character
0106 6280 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 6282 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 6284 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6286 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6288 FFFF 
0111 628A 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 628C 0286  22         ci    tmp2,32
     628E 0020 
0117 6290 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 6292 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 6294 0286  22         ci    tmp2,32               ; Space character found?
     6296 0020 
0125 6298 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 629A 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     629C 2020 
0131 629E 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 62A0 0287  22         ci    tmp3,>20ff            ; First characer is space?
     62A2 20FF 
0134 62A4 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 62A6 0585  14         inc   tmp1
0139 62A8 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 62AA C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62AC A10C 
0145 62AE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62B0 26EA 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 62B2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62B4 6A50 
0151 62B6 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62B8 74FE 
0152               
0153               
**** **** ****     > stevie_b1.asm.3765856
0089                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 62BA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62BC A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 62BE 8820  54         c     @fb.row.dirty,@w$ffff
     62C0 A10A 
     62C2 2022 
0013 62C4 1604  14         jne   edkey.action.up.cursor
0014 62C6 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62C8 6E14 
0015 62CA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62CC A10A 
0016                       ;-------------------------------------------------------
0017                       ; Move cursor
0018                       ;-------------------------------------------------------
0019               edkey.action.up.cursor:
0020 62CE C120  34         mov   @fb.row,tmp0
     62D0 A106 
0021 62D2 150B  14         jgt   edkey.action.up.cursor_up
0022                                                   ; Move cursor up if fb.row > 0
0023 62D4 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     62D6 A104 
0024 62D8 130C  14         jeq   edkey.action.up.set_cursorx
0025                                                   ; At top, only position cursor X
0026                       ;-------------------------------------------------------
0027                       ; Scroll 1 line
0028                       ;-------------------------------------------------------
0029 62DA 0604  14         dec   tmp0                  ; fb.topline--
0030 62DC C804  38         mov   tmp0,@parm1           ; Scroll one line up
     62DE 2F20 
0031               
0032 62E0 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     62E2 6B38 
0033                                                   ; | i  @parm1 = Line to start with
0034                                                   ; /             (becomes @fb.topline)
0035               
0036 62E4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62E6 A110 
0037 62E8 1004  14         jmp   edkey.action.up.set_cursorx
0038                       ;-------------------------------------------------------
0039                       ; Move cursor up
0040                       ;-------------------------------------------------------
0041               edkey.action.up.cursor_up:
0042 62EA 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62EC A106 
0043 62EE 06A0  32         bl    @up                   ; Row-- VDP cursor
     62F0 26E0 
0044                       ;-------------------------------------------------------
0045                       ; Check line length and position cursor
0046                       ;-------------------------------------------------------
0047               edkey.action.up.set_cursorx:
0048 62F2 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62F4 700A 
0049                                                   ; | i  @fb.row        = Row in frame buffer
0050                                                   ; / o  @fb.row.length = Length of row
0051               
0052 62F6 8820  54         c     @fb.column,@fb.row.length
     62F8 A10C 
     62FA A108 
0053 62FC 1207  14         jle   edkey.action.up.exit
0054                       ;-------------------------------------------------------
0055                       ; Adjust cursor column position
0056                       ;-------------------------------------------------------
0057 62FE C820  54         mov   @fb.row.length,@fb.column
     6300 A108 
     6302 A10C 
0058 6304 C120  34         mov   @fb.column,tmp0
     6306 A10C 
0059 6308 06A0  32         bl    @xsetx                ; Set VDP cursor X
     630A 26EA 
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.up.exit:
0064 630C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     630E 6A50 
0065 6310 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6312 74FE 
0066               
0067               
0068               
0069               *---------------------------------------------------------------
0070               * Cursor down
0071               *---------------------------------------------------------------
0072               edkey.action.down:
0073 6314 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     6316 6A78 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077               edkey.action.down.exit:
0078 6318 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     631A 74FE 
**** **** ****     > stevie_b1.asm.3765856
0090                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 631C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     631E A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 6320 8820  54         c     @fb.row.dirty,@w$ffff
     6322 A10A 
     6324 2022 
0013 6326 1604  14         jne   edkey.action.ppage.sanity
0014 6328 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     632A 6E14 
0015 632C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     632E A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 6330 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6332 A104 
0021 6334 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 6336 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     6338 A11A 
0026 633A 1503  14         jgt   edkey.action.ppage.topline
0027 633C 04E0  34         clr   @fb.topline           ; topline = 0
     633E A104 
0028 6340 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6342 6820  54         s     @fb.scrrows,@fb.topline
     6344 A11A 
     6346 A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 6348 C820  54         mov   @fb.topline,@parm1
     634A A104 
     634C 2F20 
0039 634E 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6350 A110 
0040               
0041 6352 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 6354 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6356 74FE 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 6358 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     635A A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 635C 8820  54         c     @fb.row.dirty,@w$ffff
     635E A10A 
     6360 2022 
0061 6362 1604  14         jne   edkey.action.npage.sanity
0062 6364 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6366 6E14 
0063 6368 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     636A A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 636C C120  34         mov   @fb.topline,tmp0
     636E A104 
0069 6370 A120  34         a     @fb.scrrows,tmp0
     6372 A11A 
0070 6374 0584  14         inc   tmp0                  ; Base 1 offset !
0071 6376 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6378 A204 
0072 637A 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 637C A820  54         a     @fb.scrrows,@fb.topline
     637E A11A 
     6380 A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 6382 C820  54         mov   @fb.topline,@parm1
     6384 A104 
     6386 2F20 
0083 6388 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     638A A110 
0084               
0085 638C 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 638E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6390 74FE 
**** **** ****     > stevie_b1.asm.3765856
0091                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
**** **** ****     > edkey.fb.mov.topbot.asm
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
0011 6392 8820  54         c     @fb.row.dirty,@w$ffff
     6394 A10A 
     6396 2022 
0012 6398 1604  14         jne   edkey.action.top.refresh
0013 639A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     639C 6E14 
0014 639E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63A0 A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 63A2 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63A4 2F20 
0020 63A6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63A8 A110 
0021               
0022 63AA 0460  28         b     @ _edkey.goto.fb.toprow
     63AC 63DE 
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
0035 63AE 8820  54         c     @fb.row.dirty,@w$ffff
     63B0 A10A 
     63B2 2022 
0036 63B4 1604  14         jne   edkey.action.bot.refresh
0037 63B6 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63B8 6E14 
0038 63BA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63BC A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 63BE 8820  54         c     @edb.lines,@fb.scrrows
     63C0 A204 
     63C2 A11A 
0044 63C4 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 63C6 C120  34         mov   @edb.lines,tmp0
     63C8 A204 
0047 63CA 6120  34         s     @fb.scrrows,tmp0
     63CC A11A 
0048 63CE C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     63D0 2F20 
0049 63D2 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63D4 A110 
0050               
0051 63D6 0460  28         b     @ _edkey.goto.fb.toprow
     63D8 63DE 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 63DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63DC 74FE 
**** **** ****     > stevie_b1.asm.3765856
0092                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
**** **** ****     > edkey.fb.mov.goto.asm
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
0026 63DE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63E0 A118 
0027               
0028 63E2 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     63E4 6B38 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 63E6 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63E8 A106 
0033 63EA 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63EC A10C 
0034 63EE 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63F0 832A 
0035               
0036 63F2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63F4 6A50 
0037               
0038 63F6 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63F8 700A 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 63FA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63FC 74FE 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 63FE 8820  54         c     @fb.row.dirty,@w$ffff
     6400 A10A 
     6402 2022 
0053 6404 1609  14         jne   edkey.action.goto.refresh
0054               
0055 6406 0649  14         dect  stack
0056 6408 C660  46         mov   @parm1,*stack         ; Push parm1
     640A 2F20 
0057 640C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     640E 6E14 
0058 6410 C839  50         mov   *stack+,@parm1        ; Pop parm1
     6412 2F20 
0059               
0060 6414 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6416 A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 6418 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     641A A110 
0066               
0067 641C 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     641E 63DE 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.3765856
0093                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 6420 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6422 A206 
0009 6424 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6426 6A50 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 6428 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     642A A108 
0015 642C 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 642E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6430 A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6432 C1C6  18         mov   tmp2,tmp3             ; \
0024 6434 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 6436 81E0  34         c     @fb.column,tmp3
     6438 A10C 
0026 643A 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 643C 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 643E D505  30         movb  tmp1,*tmp0            ; /
0033 6440 C820  54         mov   @fb.column,@fb.row.length
     6442 A10C 
     6444 A108 
0034                                                   ; Row length - 1
0035 6446 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6448 A10A 
0036 644A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     644C A116 
0037 644E 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 6450 0286  22         ci    tmp2,colrow
     6452 0050 
0043 6454 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 6456 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6458 FFCE 
0049 645A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     645C 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 645E C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 6460 61E0  34         s     @fb.column,tmp3
     6462 A10C 
0056 6464 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 6466 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 6468 C144  18         mov   tmp0,tmp1
0059 646A 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 646C 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     646E A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 6470 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6472 A102 
0065 6474 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 6476 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 6478 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 647A 0606  14         dec   tmp2
0073 647C 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 647E 0206  20         li    tmp2,colrow
     6480 0050 
0078 6482 81A0  34         c     @fb.row.length,tmp2
     6484 A108 
0079 6486 1603  14         jne   edkey.action.del_char.save
0080 6488 0604  14         dec   tmp0                  ; One time adjustment
0081 648A 04C5  14         clr   tmp1
0082 648C D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 648E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6490 A10A 
0088 6492 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6494 A116 
0089 6496 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6498 A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 649A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     649C 74FE 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 649E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64A0 A206 
0102 64A2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64A4 6A50 
0103 64A6 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64A8 A108 
0104 64AA 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 64AC C120  34         mov   @fb.current,tmp0      ; Get pointer
     64AE A102 
0110 64B0 C1A0  34         mov   @fb.colsline,tmp2
     64B2 A10E 
0111 64B4 61A0  34         s     @fb.column,tmp2
     64B6 A10C 
0112 64B8 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 64BA DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 64BC 0606  14         dec   tmp2
0119 64BE 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 64C0 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64C2 A10A 
0124 64C4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64C6 A116 
0125               
0126 64C8 C820  54         mov   @fb.column,@fb.row.length
     64CA A10C 
     64CC A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 64CE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64D0 74FE 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 64D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64D4 6A50 
0143 64D6 04E0  34         clr   @fb.row.dirty         ; Discard current line
     64D8 A10A 
0144               
0145 64DA C820  54         mov   @fb.topline,@parm1    ; \
     64DC A104 
     64DE 2F20 
0146 64E0 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     64E2 A106 
     64E4 2F20 
0147 64E6 05A0  34         inc   @parm1                ; /
     64E8 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 64EA 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     64EC 2F20 
     64EE A204 
0153 64F0 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 64F2 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     64F4 A104 
     64F6 2F20 
0157 64F8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     64FA 6B38 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 64FC 0460  28         b     @edkey.action.up      ; Move cursor one line up
     64FE 62BA 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 6500 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6502 7110 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 6504 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     6506 2F20 
     6508 A204 
0170 650A 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 650C 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     650E 700A 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 6510 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6512 A104 
     6514 2F20 
0183               
0184 6516 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6518 6B38 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 651A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     651C A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 651E C120  34         mov   @fb.topline,tmp0
     6520 A104 
0193 6522 A120  34         a     @fb.row,tmp0
     6524 A106 
0194               
0195 6526 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6528 A204 
0196 652A 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 652C 0460  28         b     @edkey.action.up      ; Move cursor one line up
     652E 62BA 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 6530 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6532 61C6 
**** **** ****     > stevie_b1.asm.3765856
0094                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
**** **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert character
0006               *
0007               * @parm1 = high byte has character to insert
0008               *---------------------------------------------------------------
0009               edkey.action.ins_char.ws:
0010 6534 0204  20         li    tmp0,>2000            ; White space
     6536 2000 
0011 6538 C804  38         mov   tmp0,@parm1
     653A 2F20 
0012               edkey.action.ins_char:
0013 653C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     653E A206 
0014 6540 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6542 6A50 
0015                       ;-------------------------------------------------------
0016                       ; Assert 1 - Empty line
0017                       ;-------------------------------------------------------
0018 6544 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6546 A102 
0019 6548 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     654A A108 
0020 654C 132E  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Assert 2 - EOL
0024                       ;-------------------------------------------------------
0025 654E 8820  54         c     @fb.column,@fb.row.length
     6550 A10C 
     6552 A108 
0026 6554 132A  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Assert 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 6556 C160  34         mov   @fb.column,tmp1
     6558 A10C 
0032 655A 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     655C 004F 
0033 655E 1104  14         jlt   !
0034               
0035 6560 0460  28         b     @edkey.action.ins_line
     6562 65B2 
0036 6564 0460  28         b     @edkey.action.down
     6566 6314 
0037                       ;bl    @edb.line.pack        ; Copy line to editor buffer
0038                       ;clr   @fb.row.dirty         ; Current row no longer dirty
0039               
0040               
0041                       ;b     @edkey.action.char.overwrite
0042                       ;-------------------------------------------------------
0043                       ; Assert 4 - 80 characters maximum
0044                       ;-------------------------------------------------------
0045 6568 C160  34 !       mov   @fb.row.length,tmp1
     656A A108 
0046 656C 0285  22         ci    tmp1,colrow
     656E 0050 
0047 6570 1101  14         jlt   edkey.action.ins_char.prep
0048 6572 101D  14         jmp   edkey.action.ins_char.exit
0049                       ;-------------------------------------------------------
0050                       ; Calculate number of characters to move
0051                       ;-------------------------------------------------------
0052               edkey.action.ins_char.prep:
0053 6574 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0054 6576 61E0  34         s     @fb.column,tmp3
     6578 A10C 
0055 657A 0607  14         dec   tmp3                  ; Remove base 1 offset
0056 657C A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0057 657E C144  18         mov   tmp0,tmp1
0058 6580 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0059 6582 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6584 A10C 
0060                       ;-------------------------------------------------------
0061                       ; Loop from end of line until current character
0062                       ;-------------------------------------------------------
0063               edkey.action.ins_char.loop:
0064 6586 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0065 6588 0604  14         dec   tmp0
0066 658A 0605  14         dec   tmp1
0067 658C 0606  14         dec   tmp2
0068 658E 16FB  14         jne   edkey.action.ins_char.loop
0069                       ;-------------------------------------------------------
0070                       ; Insert specified character at current position
0071                       ;-------------------------------------------------------
0072 6590 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     6592 2F20 
0073                       ;-------------------------------------------------------
0074                       ; Save variables and exit
0075                       ;-------------------------------------------------------
0076 6594 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6596 A10A 
0077 6598 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     659A A116 
0078 659C 05A0  34         inc   @fb.column
     659E A10C 
0079 65A0 05A0  34         inc   @wyx
     65A2 832A 
0080 65A4 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65A6 A108 
0081 65A8 1002  14         jmp   edkey.action.ins_char.exit
0082                       ;-------------------------------------------------------
0083                       ; Add character in append mode
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_char.append:
0086 65AA 0460  28         b     @edkey.action.char.overwrite
     65AC 66D6 
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.ins_char.exit:
0091 65AE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65B0 74FE 
0092               
0093               
0094               
0095               
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Insert new line
0100               *---------------------------------------------------------------
0101               edkey.action.ins_line:
0102 65B2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65B4 A206 
0103                       ;-------------------------------------------------------
0104                       ; Crunch current line if dirty
0105                       ;-------------------------------------------------------
0106 65B6 8820  54         c     @fb.row.dirty,@w$ffff
     65B8 A10A 
     65BA 2022 
0107 65BC 1604  14         jne   edkey.action.ins_line.insert
0108 65BE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     65C0 6E14 
0109 65C2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65C4 A10A 
0110                       ;-------------------------------------------------------
0111                       ; Insert entry in index
0112                       ;-------------------------------------------------------
0113               edkey.action.ins_line.insert:
0114 65C6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65C8 6A50 
0115 65CA C820  54         mov   @fb.topline,@parm1
     65CC A104 
     65CE 2F20 
0116 65D0 A820  54         a     @fb.row,@parm1        ; Line number to insert
     65D2 A106 
     65D4 2F20 
0117 65D6 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     65D8 A204 
     65DA 2F22 
0118               
0119 65DC 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     65DE 6D2C 
0120                                                   ; \ i  parm1 = Line for insert
0121                                                   ; / i  parm2 = Last line to reorg
0122               
0123 65E0 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     65E2 A204 
0124                       ;-------------------------------------------------------
0125                       ; Check/Adjust marker M1
0126                       ;-------------------------------------------------------
0127               edkey.action.ins_line.m1:
0128 65E4 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     65E6 A20C 
     65E8 2022 
0129 65EA 1308  14         jeq   edkey.action.ins_line.m2
0130                                                   ; Yes, skip to M2 check
0131               
0132 65EC 8820  54         c     @parm1,@edb.block.m1
     65EE 2F20 
     65F0 A20C 
0133 65F2 1504  14         jgt   edkey.action.ins_line.m2
0134 65F4 05A0  34         inc   @edb.block.m1         ; M1++
     65F6 A20C 
0135 65F8 0720  34         seto  @fb.colorize          ; Set colorize flag
     65FA A110 
0136                       ;-------------------------------------------------------
0137                       ; Check/Adjust marker M2
0138                       ;-------------------------------------------------------
0139               edkey.action.ins_line.m2:
0140 65FC 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     65FE A20E 
     6600 2022 
0141 6602 1308  14         jeq   edkey.action.ins_line.refresh
0142                                                   ; Yes, skip to refresh frame buffer
0143               
0144 6604 8820  54         c     @parm1,@edb.block.m2
     6606 2F20 
     6608 A20E 
0145 660A 1504  14         jgt   edkey.action.ins_line.refresh
0146 660C 05A0  34         inc   @edb.block.m2         ; M2++
     660E A20E 
0147 6610 0720  34         seto  @fb.colorize          ; Set colorize flag
     6612 A110 
0148                       ;-------------------------------------------------------
0149                       ; Refresh frame buffer and physical screen
0150                       ;-------------------------------------------------------
0151               edkey.action.ins_line.refresh:
0152 6614 C820  54         mov   @fb.topline,@parm1
     6616 A104 
     6618 2F20 
0153               
0154 661A 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     661C 6B38 
0155                                                   ; | i  @parm1 = Line to start with
0156                                                   ; /             (becomes @fb.topline)
0157               
0158 661E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6620 A116 
0159                       ;-------------------------------------------------------
0160                       ; Exit
0161                       ;-------------------------------------------------------
0162               edkey.action.ins_line.exit:
0163 6622 0460  28         b     @edkey.action.home    ; Position cursor at home
     6624 61C6 
0164               
**** **** ****     > stevie_b1.asm.3765856
0095                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 6626 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6628 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 662A 8820  54         c     @fb.row.dirty,@w$ffff
     662C A10A 
     662E 2022 
0013 6630 1606  14         jne   edkey.action.enter.upd_counter
0014 6632 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6634 A206 
0015 6636 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6638 6E14 
0016 663A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     663C A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 663E C120  34         mov   @fb.topline,tmp0
     6640 A104 
0022 6642 A120  34         a     @fb.row,tmp0
     6644 A106 
0023 6646 0584  14         inc   tmp0
0024 6648 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     664A A204 
0025 664C 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 664E 05A0  34         inc   @edb.lines            ; Total lines++
     6650 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6652 C120  34         mov   @fb.scrrows,tmp0
     6654 A11A 
0035 6656 0604  14         dec   tmp0
0036 6658 8120  34         c     @fb.row,tmp0
     665A A106 
0037 665C 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 665E C120  34         mov   @fb.scrrows,tmp0
     6660 A11A 
0042 6662 C820  54         mov   @fb.topline,@parm1
     6664 A104 
     6666 2F20 
0043 6668 05A0  34         inc   @parm1
     666A 2F20 
0044 666C 06A0  32         bl    @fb.refresh
     666E 6B38 
0045 6670 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6672 A110 
0046 6674 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 6676 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6678 A106 
0052 667A 06A0  32         bl    @down                 ; Row++ VDP cursor
     667C 26D8 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 667E 06A0  32         bl    @fb.get.firstnonblank
     6680 6AF0 
0058 6682 C120  34         mov   @outparm1,tmp0
     6684 2F30 
0059 6686 C804  38         mov   tmp0,@fb.column
     6688 A10C 
0060 668A 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     668C 26EA 
0061 668E 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     6690 700A 
0062 6692 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6694 6A50 
0063 6696 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6698 A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 669A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     669C 74FE 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 669E 0649  14         dect  stack
0078 66A0 C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 66A2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66A4 A118 
0081 66A6 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     66A8 A20A 
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 66AA C2F9  30         mov   *stack+,r11           ; Pop r11
0087 66AC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66AE 74FE 
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 66B0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66B2 A118 
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 66B4 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 66B6 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 66B8 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     66BA 0020 
0103 66BC 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 66BE 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     66C0 007E 
0107 66C2 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 66C4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     66C6 A206 
0113 66C8 D805  38         movb  tmp1,@parm1           ; Store character for insert
     66CA 2F20 
0114 66CC C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     66CE A20A 
0115 66D0 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 66D2 0460  28         b     @edkey.action.ins_char
     66D4 653C 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 66D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66D8 6A50 
0126 66DA C120  34         mov   @fb.current,tmp0      ; Get pointer
     66DC A102 
0127               
0128 66DE D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     66E0 2F20 
0129 66E2 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     66E4 A10A 
0130 66E6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66E8 A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 66EA C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     66EC A10C 
0135 66EE 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     66F0 004F 
0136 66F2 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 66F4 0205  20         li    tmp1,colrow           ; \
     66F6 0050 
0140 66F8 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     66FA A108 
0141 66FC 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 66FE 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6700 A10C 
0147 6702 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6704 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 6706 8820  54         c     @fb.column,@fb.row.length
     6708 A10C 
     670A A108 
0152                                                   ; column < line length ?
0153 670C 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 670E C820  54         mov   @fb.column,@fb.row.length
     6710 A10C 
     6712 A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 6714 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6716 74FE 
**** **** ****     > stevie_b1.asm.3765856
0096                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
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
0011 6718 C120  34         mov   @edb.dirty,tmp0
     671A A206 
0012 671C 1302  14         jeq   !
0013 671E 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6720 7E3A 
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 6722 0460  28 !       b     @tv.quit
     6724 337A 
0018               
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Toggle ruler on/off
0023               ********|*****|*********************|**************************
0024               edkey.action.toggle.ruler:
0025 6726 0649  14         dect  stack
0026 6728 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 672A 0649  14         dect  stack
0028 672C C660  46         mov   @wyx,*stack           ; Push cursor YX
     672E 832A 
0029                       ;-------------------------------------------------------
0030                       ; Toggle ruler visibility
0031                       ;-------------------------------------------------------
0032 6730 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6732 A116 
0033 6734 0560  34         inv   @tv.ruler.visible     ; Toggle ruler visibility
     6736 A010 
0034 6738 1302  14         jeq   edkey.action.toggle.ruler.fb
0035 673A 06A0  32         bl    @fb.ruler.init        ; Setup ruler in ram
     673C 7E8E 
0036                       ;-------------------------------------------------------
0037                       ; Update framebuffer pane
0038                       ;-------------------------------------------------------
0039               edkey.action.toggle.ruler.fb:
0040 673E 06A0  32         bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
     6740 79B8 
0041 6742 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     6744 832A 
0042 6746 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.toggle.ruler.exit:
0047 6748 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     674A 74FE 
**** **** ****     > stevie_b1.asm.3765856
0097                       copy  "edkey.fb.file.asm"        ; File related actions
**** **** ****     > edkey.fb.file.asm
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
0017 674C C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     674E A444 
     6750 2F20 
0018 6752 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6754 2F22 
0019 6756 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 6758 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     675A A444 
     675C 2F20 
0023 675E 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6760 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 6762 C120  34         mov   @parm1,tmp0
     6764 2F20 
0030 6766 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 6768 C120  34         mov   @edb.dirty,tmp0
     676A A206 
0036 676C 1302  14         jeq   !
0037 676E 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6770 7E3A 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 6772 06A0  32 !       bl    @fm.browse.fname.suffix
     6774 7DE0 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 6776 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6778 E000 
0047 677A 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     677C 7DA8 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 677E 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6780 6392 
**** **** ****     > stevie_b1.asm.3765856
0098                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 6782 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     6784 71A0 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 6786 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6788 74FE 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 678A 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     678C 71C8 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 678E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6790 74FE 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 6792 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     6794 71F0 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 6796 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6798 74FE 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 679A 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     679C 7C16 
0043 679E 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67A0 722C 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 67A2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67A4 74FE 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 67A6 0649  14         dect  stack
0055 67A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 67AA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67AC A20E 
     67AE 2022 
0060 67B0 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 67B2 C120  34         mov   @wyx,tmp0             ; Get cursor position
     67B4 832A 
0066 67B6 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67B8 FF00 
0067 67BA C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67BC A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 67BE 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67C0 7C16 
0072               
0073 67C2 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     67C4 2F20 
0074 67C6 06A0  32         bl    @edb.block.copy       ; Copy code block
     67C8 7272 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 67CA 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     67CC 2F30 
     67CE 2000 
0079 67D0 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 67D2 C820  54         mov   @fb.yxsave,@parm1
     67D4 A114 
     67D6 2F20 
0083 67D8 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     67DA 6BA8 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 67DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 67DE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67E0 74FE 
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
0103 67E2 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67E4 A20E 
     67E6 2022 
0104 67E8 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 67EA 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     67EC 7C16 
0110               
0111 67EE 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     67F0 2F20 
0112 67F2 06A0  32         bl    @edb.block.delete     ; Delete code block
     67F4 7368 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 67F6 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     67F8 2F30 
     67FA 2000 
0119 67FC 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 67FE C820  54         mov   @fb.topline,@parm1
     6800 A104 
     6802 2F20 
0123 6804 0460  28         b     @_edkey.goto.fb.toprow
     6806 63DE 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 6808 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     680A 74FE 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 680C 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     680E A20E 
     6810 2022 
0142 6812 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 6814 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6816 7C16 
0148               
0149 6818 0720  34         seto  @parm1                ; Set message to "Moving block..."
     681A 2F20 
0150 681C 06A0  32         bl    @edb.block.copy       ; Copy code block
     681E 7272 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6820 0720  34         seto  @parm1                ; Don't display delete message
     6822 2F20 
0155 6824 06A0  32         bl    @edb.block.delete     ; Delete code block
     6826 7368 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 6828 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     682A 2F30 
     682C 2000 
0162 682E 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6830 C820  54         mov   @fb.topline,@parm1
     6832 A104 
     6834 2F20 
0166 6836 0460  28         b     @_edkey.goto.fb.toprow
     6838 63DE 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 683A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     683C 74FE 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 683E 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6840 A20C 
     6842 2022 
0182 6844 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 6846 C820  54         mov   @edb.block.m1,@parm1
     6848 A20C 
     684A 2F20 
0188 684C 0620  34         dec   @parm1                ; Base 0 offset
     684E 2F20 
0189               
0190 6850 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6852 63FE 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 6854 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6856 74FE 
**** **** ****     > stevie_b1.asm.3765856
0099                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
**** **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 6858 0649  14         dect  stack
0009 685A C64B  30         mov   r11,*stack            ; Save return address
0010 685C 06A0  32         bl  @fb.tab.next            ; Jump to next tab position on line
     685E 7E7C 
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 6860 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 6862 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6864 74FE 
**** **** ****     > stevie_b1.asm.3765856
0100                       ;-----------------------------------------------------------------------
0101                       ; Keyboard actions - Command Buffer
0102                       ;-----------------------------------------------------------------------
0103                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 6866 C120  34         mov   @cmdb.column,tmp0
     6868 A312 
0009 686A 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 686C 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     686E A312 
0014 6870 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6872 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 6874 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6876 74FE 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 6878 06A0  32         bl    @cmdb.cmd.getlength
     687A 7486 
0026 687C 8820  54         c     @cmdb.column,@outparm1
     687E A312 
     6880 2F30 
0027 6882 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 6884 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     6886 A312 
0032 6888 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     688A A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 688C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     688E 74FE 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 6890 04C4  14         clr   tmp0
0045 6892 C804  38         mov   tmp0,@cmdb.column      ; First column
     6894 A312 
0046 6896 0584  14         inc   tmp0
0047 6898 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     689A A30A 
0048 689C C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     689E A30A 
0049               
0050 68A0 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68A2 74FE 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 68A4 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     68A6 A328 
0057 68A8 0984  56         srl   tmp0,8                 ; Right justify
0058 68AA C804  38         mov   tmp0,@cmdb.column      ; Save column position
     68AC A312 
0059 68AE 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 68B0 0224  22         ai    tmp0,>1a00             ; Y=26
     68B2 1A00 
0061 68B4 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     68B6 A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 68B8 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68BA 74FE 
**** **** ****     > stevie_b1.asm.3765856
0104                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
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
0025 68BC 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     68BE 7454 
0026 68C0 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68C2 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 68C4 0460  28         b     @edkey.action.cmdb.home
     68C6 6890 
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
0060 68C8 D105  18         movb  tmp1,tmp0             ; Get keycode
0061 68CA 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 68CC 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     68CE 0020 
0064 68D0 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 68D2 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     68D4 007E 
0068 68D6 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 68D8 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68DA A318 
0074               
0075 68DC 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     68DE A329 
0076 68E0 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     68E2 A312 
0077 68E4 D505  30         movb  tmp1,*tmp0            ; Add character
0078 68E6 05A0  34         inc   @cmdb.column          ; Next column
     68E8 A312 
0079 68EA 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     68EC A30A 
0080               
0081 68EE 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68F0 7486 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 68F2 C120  34         mov   @outparm1,tmp0
     68F4 2F30 
0088 68F6 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 68F8 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68FA A328 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 68FC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     68FE 74FE 
**** **** ****     > stevie_b1.asm.3765856
0105                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6900 C120  34         mov   @cmdb.visible,tmp0
     6902 A302 
0009 6904 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 6906 04E0  34         clr   @cmdb.column          ; Column = 0
     6908 A312 
0015 690A 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     690C 7968 
0016 690E 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6910 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6912 79B8 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6914 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6916 74FE 
**** **** ****     > stevie_b1.asm.3765856
0106                       copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
**** **** ****     > edkey.cmdb.file.new.asm
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
0011 6918 0649  14         dect  stack
0012 691A C64B  30         mov   r11,*stack            ; Save return address
0013 691C 0649  14         dect  stack
0014 691E C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 6920 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6922 A206 
0019 6924 1303  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 6926 06A0  32         bl    @dialog.unsaved       ; Show dialog
     6928 7E3A 
0022 692A 1004  14         jmp   edkey.action.cmdb.file.new.exit
0023                       ;-------------------------------------------------------
0024                       ; Reset editor
0025                       ;-------------------------------------------------------
0026 692C 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     692E 79B8 
0027 6930 06A0  32         bl    @tv.reset             ; Reset editor
     6932 32AC 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.file.new.exit:
0032 6934 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0033 6936 C2F9  30         mov   *stack+,r11           ; Pop R11
0034 6938 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     693A 6392 
**** **** ****     > stevie_b1.asm.3765856
0107                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
**** **** ****     > edkey.cmdb.file.load.asm
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
0011 693C 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     693E 79B8 
0012               
0013 6940 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6942 7486 
0014 6944 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6946 2F30 
0015 6948 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 694A 06A0  32         bl    @pane.errline.show    ; Show error line
     694C 7BAE 
0020               
0021 694E 06A0  32         bl    @pane.show_hint
     6950 76E2 
0022 6952 1C00                   byte pane.botrow-1,0
0023 6954 393E                   data txt.io.nofile
0024               
0025 6956 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 6958 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 695A D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     695C A328 
0031               
0032 695E 06A0  32         bl    @cpym2m
     6960 24DE 
0033 6962 A328                   data cmdb.cmdlen,heap.top,80
     6964 E000 
     6966 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 6968 0204  20         li    tmp0,heap.top         ; 1st line in heap
     696A E000 
0039 696C C804  38         mov   tmp0,@parm1
     696E 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 6970 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6972 E000 
0045 6974 C804  38         mov   tmp0,@parm1
     6976 2F20 
0046               
0047 6978 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     697A 7DA8 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 697C 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     697E 6392 
**** **** ****     > stevie_b1.asm.3765856
0108                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
**** **** ****     > edkey.cmdb.file.save.asm
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
0011 6980 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6982 79B8 
0012               
0013 6984 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6986 7486 
0014 6988 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     698A 2F30 
0015 698C 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 698E 06A0  32         bl    @pane.errline.show    ; Show error line
     6990 7BAE 
0020               
0021 6992 06A0  32         bl    @pane.show_hint
     6994 76E2 
0022 6996 1C00                   byte pane.botrow-1,0
0023 6998 393E                   data txt.io.nofile
0024               
0025 699A 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 699C 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 699E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69A0 A328 
0031               
0032 69A2 06A0  32         bl    @cpym2m
     69A4 24DE 
0033 69A6 A328                   data cmdb.cmdlen,heap.top,80
     69A8 E000 
     69AA 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 69AC 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69AE E000 
0039 69B0 C804  38         mov   tmp0,@parm1
     69B2 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 69B4 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     69B6 A20E 
     69B8 2022 
0044 69BA 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 69BC C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     69BE A20C 
     69C0 2F22 
0050 69C2 0620  34         dec   @parm2                ; /
     69C4 2F22 
0051               
0052 69C6 C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     69C8 A20E 
     69CA 2F24 
0053               
0054 69CC 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 69CE 04E0  34         clr   @parm2                ; First line to save
     69D0 2F22 
0060 69D2 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     69D4 A204 
     69D6 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 69D8 06A0  32         bl    @fm.savefile          ; Save DV80 file
     69DA 7DCE 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 69DC 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     69DE 6392 
**** **** ****     > stevie_b1.asm.3765856
0109                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
**** **** ****     > edkey.cmdb.dialog.asm
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
0020 69E0 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     69E2 A206 
0021 69E4 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     69E6 78FE 
0022 69E8 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     69EA 7454 
0023 69EC C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     69EE A326 
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 69F0 0284  22         ci    tmp0,>2000
     69F2 2000 
0028 69F4 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 69F6 0284  22         ci    tmp0,>7fff
     69F8 7FFF 
0031 69FA 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 69FC 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 69FE C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6A00 FFCE 
0040 6A02 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A04 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6A06 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A08 74FE 
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
0063 6A0A 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6A0C 7DF2 
0064 6A0E 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6A10 A318 
0065 6A12 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6A14 74FE 
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
0086 6A16 06A0  32         bl    @hchar
     6A18 27CC 
0087 6A1A 0000                   byte 0,0,32,80*2
     6A1C 20A0 
0088 6A1E FFFF                   data EOL
0089 6A20 1000  14         jmp   edkey.action.cmdb.close.dialog
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
0108 6A22 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6A24 A31A 
0109 6A26 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A28 78FE 
0110 6A2A 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A2C 79B8 
0111 6A2E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6A30 A118 
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6A32 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A34 74FE 
**** **** ****     > stevie_b1.asm.3765856
0110                       ;-----------------------------------------------------------------------
0111                       ; Logic for Framebuffer (1)
0112                       ;-----------------------------------------------------------------------
0113                       copy  "fb.utils.asm"        ; Framebuffer utilities
**** **** ****     > fb.utils.asm
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
0024 6A36 0649  14         dect  stack
0025 6A38 C64B  30         mov   r11,*stack            ; Save return address
0026 6A3A 0649  14         dect  stack
0027 6A3C C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6A3E C120  34         mov   @parm1,tmp0
     6A40 2F20 
0032 6A42 A120  34         a     @fb.topline,tmp0
     6A44 A104 
0033 6A46 C804  38         mov   tmp0,@outparm1
     6A48 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6A4A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6A4C C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6A4E 045B  20         b     *r11                  ; Return to caller
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
0068 6A50 0649  14         dect  stack
0069 6A52 C64B  30         mov   r11,*stack            ; Save return address
0070 6A54 0649  14         dect  stack
0071 6A56 C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A58 0649  14         dect  stack
0073 6A5A C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A5C C120  34         mov   @fb.row,tmp0
     6A5E A106 
0078 6A60 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A62 A10E 
0079 6A64 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6A66 A10C 
0080 6A68 A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6A6A A100 
0081 6A6C C805  38         mov   tmp1,@fb.current
     6A6E A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6A70 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6A72 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6A74 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6A76 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0114                       copy  "fb.cursor.down.asm"  ; Cursor down logic
**** **** ****     > fb.cursor.down.asm
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
0021 6A78 0649  14         dect  stack
0022 6A7A C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6A7C 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6A7E A106 
     6A80 A204 
0027 6A82 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6A84 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A86 A118 
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6A88 8820  54         c     @fb.row.dirty,@w$ffff
     6A8A A10A 
     6A8C 2022 
0034 6A8E 1604  14         jne   fb.cursor.down.move
0035 6A90 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6A92 6E14 
0036 6A94 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6A96 A10A 
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6A98 C120  34         mov   @fb.topline,tmp0
     6A9A A104 
0045 6A9C A120  34         a     @fb.row,tmp0
     6A9E A106 
0046 6AA0 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6AA2 A204 
0047 6AA4 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6AA6 C120  34         mov   @fb.scrrows,tmp0
     6AA8 A11A 
0053 6AAA 0604  14         dec   tmp0
0054 6AAC 8120  34         c     @fb.row,tmp0
     6AAE A106 
0055 6AB0 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6AB2 C820  54         mov   @fb.topline,@parm1
     6AB4 A104 
     6AB6 2F20 
0060 6AB8 05A0  34         inc   @parm1
     6ABA 2F20 
0061               
0062 6ABC 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6ABE 6B38 
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6AC0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6AC2 A110 
0067 6AC4 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6AC6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6AC8 A106 
0073 6ACA 06A0  32         bl    @down                 ; Row++ VDP cursor
     6ACC 26D8 
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6ACE 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6AD0 700A 
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6AD2 8820  54         c     @fb.column,@fb.row.length
     6AD4 A10C 
     6AD6 A108 
0083 6AD8 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6ADA C820  54         mov   @fb.row.length,@fb.column
     6ADC A108 
     6ADE A10C 
0089 6AE0 C120  34         mov   @fb.column,tmp0
     6AE2 A10C 
0090 6AE4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6AE6 26EA 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6AE8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AEA 6A50 
0096 6AEC C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6AEE 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.3765856
0115                       copy  "fb.get.firstnonblank.asm"
**** **** ****     > fb.get.firstnonblank.asm
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
0015 6AF0 0649  14         dect  stack
0016 6AF2 C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6AF4 04E0  34         clr   @fb.column
     6AF6 A10C 
0021 6AF8 06A0  32         bl    @fb.calc_pointer
     6AFA 6A50 
0022 6AFC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6AFE 700A 
0023 6B00 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6B02 A108 
0024 6B04 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6B06 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6B08 A102 
0027 6B0A 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6B0C D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6B0E 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6B10 0285  22         ci    tmp1,>2000            ; Whitespace?
     6B12 2000 
0036 6B14 1503  14         jgt   fb.get.firstnonblank.match
0037 6B16 0606  14         dec   tmp2                  ; Counter--
0038 6B18 16F9  14         jne   fb.get.firstnonblank.loop
0039 6B1A 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6B1C 6120  34         s     @fb.current,tmp0      ; Calculate column
     6B1E A102 
0045 6B20 0604  14         dec   tmp0
0046 6B22 C804  38         mov   tmp0,@outparm1        ; Save column
     6B24 2F30 
0047 6B26 D805  38         movb  tmp1,@outparm2        ; Save character
     6B28 2F32 
0048 6B2A 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6B2C 04E0  34         clr   @outparm1             ; X=0
     6B2E 2F30 
0054 6B30 04E0  34         clr   @outparm2             ; Null
     6B32 2F32 
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6B34 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6B36 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0116                                                   ; Get column of first non-blank character
0117                       copy  "fb.refresh.asm"      ; Refresh framebuffer
**** **** ****     > fb.refresh.asm
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
0020 6B38 0649  14         dect  stack
0021 6B3A C64B  30         mov   r11,*stack            ; Push return address
0022 6B3C 0649  14         dect  stack
0023 6B3E C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B40 0649  14         dect  stack
0025 6B42 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6B44 0649  14         dect  stack
0027 6B46 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6B48 C820  54         mov   @parm1,@fb.topline
     6B4A 2F20 
     6B4C A104 
0032 6B4E 04E0  34         clr   @parm2                ; Target row in frame buffer
     6B50 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6B52 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6B54 2F20 
     6B56 A204 
0037 6B58 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6B5A 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6B5C 6F0C 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6B5E 05A0  34         inc   @parm1                ; Next line in editor buffer
     6B60 2F20 
0048 6B62 05A0  34         inc   @parm2                ; Next row in frame buffer
     6B64 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6B66 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6B68 2F20 
     6B6A A204 
0053 6B6C 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6B6E 8820  54         c     @parm2,@fb.scrrows
     6B70 2F22 
     6B72 A11A 
0056 6B74 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6B76 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6B78 C120  34         mov   @parm2,tmp0           ; Current row
     6B7A 2F22 
0064 6B7C C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6B7E A11A 
0065 6B80 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6B82 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6B84 A10E 
0067               
0068 6B86 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6B88 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6B8A 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6B8C A10E 
0072 6B8E A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6B90 A100 
0073               
0074 6B92 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6B94 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6B96 06A0  32         bl    @xfilm                ; \ Fill memory
     6B98 2240 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6B9A 0720  34         seto  @fb.dirty             ; Refresh screen
     6B9C A116 
0086 6B9E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6BA0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6BA2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6BA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6BA6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0118                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
**** **** ****     > fb.restore.asm
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
0021 6BA8 0649  14         dect  stack
0022 6BAA C64B  30         mov   r11,*stack            ; Save return address
0023 6BAC 0649  14         dect  stack
0024 6BAE C660  46         mov   @parm1,*stack         ; Push @parm1
     6BB0 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6BB2 C820  54         mov   @fb.topline,@parm1
     6BB4 A104 
     6BB6 2F20 
0029 6BB8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6BBA 6B38 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6BBC 0720  34         seto  @parm1                ; Skip Asserts
     6BBE 2F20 
0035 6BC0 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6BC2 7EA0 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6BC4 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6BC6 A018 
     6BC8 2F20 
0042 6BCA 06A0  32         bl    @pane.action.colorscheme.statlines
     6BCC 78C6 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6BCE 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6BD0 A118 
0050               
0051 6BD2 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6BD4 78FE 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6BD6 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6BD8 2F20 
0057 6BDA C820  54         mov   @parm1,@wyx           ; Set cursor position
     6BDC 2F20 
     6BDE 832A 
0058 6BE0 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6BE2 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.3765856
0119                       ;-----------------------------------------------------------------------
0120                       ; Logic for Index management
0121                       ;-----------------------------------------------------------------------
0122                       copy  "idx.update.asm"      ; Index management - Update entry
**** **** ****     > idx.update.asm
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
0022 6BE4 0649  14         dect  stack
0023 6BE6 C64B  30         mov   r11,*stack            ; Save return address
0024 6BE8 0649  14         dect  stack
0025 6BEA C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6BEC 0649  14         dect  stack
0027 6BEE C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6BF0 C120  34         mov   @parm1,tmp0           ; Get line number
     6BF2 2F20 
0032 6BF4 C160  34         mov   @parm2,tmp1           ; Get pointer
     6BF6 2F22 
0033 6BF8 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6BFA 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6BFC 0FFF 
0039 6BFE 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6C00 06E0  34         swpb  @parm3
     6C02 2F24 
0044 6C04 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6C06 2F24 
0045 6C08 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6C0A 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6C0C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C0E 31A0 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6C10 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6C12 2F30 
0056 6C14 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6C16 B000 
0057 6C18 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C1A 2F30 
0058 6C1C 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6C1E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C20 31A0 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6C22 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C24 2F30 
0068 6C26 04E4  34         clr   @idx.top(tmp0)        ; /
     6C28 B000 
0069 6C2A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C2C 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C2E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C30 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C32 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C34 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0123                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
**** **** ****     > idx.pointer.asm
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
0021 6C36 0649  14         dect  stack
0022 6C38 C64B  30         mov   r11,*stack            ; Save return address
0023 6C3A 0649  14         dect  stack
0024 6C3C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C3E 0649  14         dect  stack
0026 6C40 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C42 0649  14         dect  stack
0028 6C44 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C46 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C48 2F20 
0033               
0034 6C4A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C4C 31A0 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C4E C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C50 2F30 
0039 6C52 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6C54 B000 
0040               
0041 6C56 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6C58 C185  18         mov   tmp1,tmp2             ; \
0047 6C5A 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6C5C 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6C5E 00FF 
0052 6C60 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6C62 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6C64 C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6C66 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6C68 2F30 
0059 6C6A C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6C6C 2F32 
0060 6C6E 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6C70 04E0  34         clr   @outparm1
     6C72 2F30 
0066 6C74 04E0  34         clr   @outparm2
     6C76 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6C78 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6C7A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6C7C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6C7E C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6C80 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0124                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
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
0017 6C82 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C84 B000 
0018 6C86 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6C88 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6C8A CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6C8C 0606  14         dec   tmp2                  ; tmp2--
0026 6C8E 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6C90 045B  20         b     *r11                  ; Return to caller
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
0046 6C92 0649  14         dect  stack
0047 6C94 C64B  30         mov   r11,*stack            ; Save return address
0048 6C96 0649  14         dect  stack
0049 6C98 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6C9A 0649  14         dect  stack
0051 6C9C C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6C9E 0649  14         dect  stack
0053 6CA0 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6CA2 0649  14         dect  stack
0055 6CA4 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6CA6 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6CA8 2F20 
0060               
0061 6CAA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6CAC 31A0 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6CAE C120  34         mov   @outparm1,tmp0        ; Index offset
     6CB0 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6CB2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6CB4 2F22 
0070 6CB6 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6CB8 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6CBA 2F20 
0074 6CBC 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6CBE 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6CC0 B000 
0081 6CC2 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6CC4 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6CC6 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6CC8 2F22 
0088 6CCA 0287  22         ci    tmp3,2048
     6CCC 0800 
0089 6CCE 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6CD0 06A0  32         bl    @_idx.sams.mapcolumn.on
     6CD2 3132 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6CD4 C120  34         mov   @parm1,tmp0           ; Restore line number
     6CD6 2F20 
0103 6CD8 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6CDA 06A0  32         bl    @_idx.entry.delete.reorg
     6CDC 6C82 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6CDE 06A0  32         bl    @_idx.sams.mapcolumn.off
     6CE0 3166 
0111                                                   ; Restore memory window layout
0112               
0113 6CE2 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6CE4 06A0  32         bl    @_idx.entry.delete.reorg
     6CE6 6C82 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6CE8 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6CEA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6CEC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6CEE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6CF0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6CF2 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6CF4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0125                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
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
0017 6CF6 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6CF8 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6CFA 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6CFC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CFE FFCE 
0026 6D00 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D02 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6D04 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6D06 B000 
0031 6D08 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6D0A 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6D0C 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6D0E C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6D10 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6D12 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6D14 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6D16 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6D18 AFFE 
0042 6D1A 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6D1C C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6D1E 0644  14         dect  tmp0                  ; Move pointer up
0050 6D20 0645  14         dect  tmp1                  ; Move pointer up
0051 6D22 0606  14         dec   tmp2                  ; Next index entry
0052 6D24 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D26 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D28 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D2A 045B  20         b     *r11                  ; Return to caller
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
0082 6D2C 0649  14         dect  stack
0083 6D2E C64B  30         mov   r11,*stack            ; Save return address
0084 6D30 0649  14         dect  stack
0085 6D32 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D34 0649  14         dect  stack
0087 6D36 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D38 0649  14         dect  stack
0089 6D3A C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D3C 0649  14         dect  stack
0091 6D3E C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D40 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D42 2F22 
0096 6D44 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D46 2F20 
0097 6D48 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D4A C1E0  34         mov   @parm2,tmp3
     6D4C 2F22 
0104 6D4E 0287  22         ci    tmp3,2048
     6D50 0800 
0105 6D52 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6D54 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D56 3132 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6D58 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D5A 2F22 
0117 6D5C 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6D5E 06A0  32         bl    @_idx.entry.insert.reorg
     6D60 6CF6 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6D62 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D64 3166 
0125                                                   ; Restore memory window layout
0126               
0127 6D66 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6D68 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D6A 2F22 
0133               
0134 6D6C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D6E 31A0 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6D70 C120  34         mov   @outparm1,tmp0        ; Index offset
     6D72 2F30 
0139               
0140 6D74 06A0  32         bl    @_idx.entry.insert.reorg
     6D76 6CF6 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6D78 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6D7A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6D7C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6D7E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6D80 C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6D82 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0126                       ;-----------------------------------------------------------------------
0127                       ; Logic for Editor Buffer
0128                       ;-----------------------------------------------------------------------
0129                       copy  "edb.utils.asm"          ; Editor buffer utilities
**** **** ****     > edb.utils.asm
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
0020 6D84 0649  14         dect  stack
0021 6D86 C64B  30         mov   r11,*stack            ; Save return address
0022 6D88 0649  14         dect  stack
0023 6D8A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6D8C 0649  14         dect  stack
0025 6D8E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6D90 C120  34         mov   @edb.next_free.ptr,tmp0
     6D92 A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6D94 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6D96 0FFF 
0035 6D98 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6D9A 0052 
0036 6D9C 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D9E 0FF0 
0037 6DA0 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6DA2 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6DA4 A218 
0043 6DA6 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6DA8 A200 
     6DAA A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6DAC C120  34         mov   @edb.sams.hipage,tmp0
     6DAE A218 
0050 6DB0 C160  34         mov   @edb.top.ptr,tmp1
     6DB2 A200 
0051 6DB4 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6DB6 257A 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6DB8 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6DBA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DBC FFCE 
0061 6DBE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DC0 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6DC2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6DC4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6DC6 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6DC8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0130                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
**** **** ****     > edb.line.mappage.asm
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
0021 6DCA 0649  14         dect  stack
0022 6DCC C64B  30         mov   r11,*stack            ; Push return address
0023 6DCE 0649  14         dect  stack
0024 6DD0 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6DD2 0649  14         dect  stack
0026 6DD4 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6DD6 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6DD8 A204 
0031 6DDA 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6DDC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DDE FFCE 
0037 6DE0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DE2 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6DE4 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6DE6 2F20 
0043               
0044 6DE8 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6DEA 6C36 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6DEC C120  34         mov   @outparm2,tmp0        ; SAMS page
     6DEE 2F32 
0050 6DF0 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6DF2 2F30 
0051 6DF4 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6DF6 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6DF8 A008 
0057 6DFA 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6DFC 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6DFE 257A 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6E00 C820  54         mov   @outparm2,@tv.sams.c000
     6E02 2F32 
     6E04 A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6E06 C820  54         mov   @outparm2,@edb.sams.page
     6E08 2F32 
     6E0A A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6E0C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6E0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6E10 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6E12 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0131                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
**** **** ****     > edb.line.pack.fb.asm
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
0027 6E14 0649  14         dect  stack
0028 6E16 C64B  30         mov   r11,*stack            ; Save return address
0029 6E18 0649  14         dect  stack
0030 6E1A C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6E1C 0649  14         dect  stack
0032 6E1E C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6E20 0649  14         dect  stack
0034 6E22 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6E24 0649  14         dect  stack
0036 6E26 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6E28 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E2A A10C 
     6E2C 2F6A 
0041 6E2E 04E0  34         clr   @fb.column
     6E30 A10C 
0042 6E32 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E34 6A50 
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6E36 04C4  14         clr   tmp0                  ; Counter
0047 6E38 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6E3A C160  34         mov   @fb.current,tmp1      ; Get position
     6E3C A102 
0049 6E3E C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E40 2F6C 
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6E42 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6E44 0986  56         srl   tmp2,8                ; Right justify
0056 6E46 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6E48 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6E4A 0286  22         ci    tmp2,32               ; Was it a space character?
     6E4C 0020 
0063 6E4E 1301  14         jeq   edb.line.pack.fb.check80
0064 6E50 C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6E52 0284  22         ci    tmp0,colrow
     6E54 0050 
0070 6E56 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6E58 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6E5A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E5C FFCE 
0078 6E5E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E60 2026 
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6E62 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6E64 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6E66 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6E68 2F6E 
0086 6E6A 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6E6C C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6E6E 2F6E 
0092               
0093 6E70 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6E72 C184  18         mov   tmp0,tmp2             ; \
0096 6E74 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6E76 0586  14         inc   tmp2                  ; /
0098               
0099 6E78 C107  18         mov   tmp3,tmp0             ; \
0100 6E7A A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6E7C 2F6C 
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6E7E DD05  32         movb  tmp1,*tmp0+
0104 6E80 0606  14         dec   tmp2
0105 6E82 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6E84 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6E86 6D84 
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6E88 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6E8A A104 
     6E8C 2F20 
0117 6E8E A820  54         a     @fb.row,@parm1        ; /
     6E90 A106 
     6E92 2F20 
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6E94 C820  54         mov   @edb.next_free.ptr,@parm2
     6E96 A208 
     6E98 2F22 
0123                                                   ; Pointer to new line
0124 6E9A C820  54         mov   @edb.sams.hipage,@parm3
     6E9C A218 
     6E9E 2F24 
0125                                                   ; SAMS page to use
0126               
0127 6EA0 06A0  32         bl    @idx.entry.update     ; Update index
     6EA2 6BE4 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6EA4 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6EA6 2F6C 
0136 6EA8 C160  34         mov   @edb.next_free.ptr,tmp1
     6EAA A208 
0137                                                   ; Address of line in editor buffer
0138               
0139 6EAC 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6EAE A208 
0140               
0141 6EB0 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6EB2 2F6E 
0142 6EB4 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6EB6 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6EB8 0286  22         ci    tmp2,2
     6EBA 0002 
0150 6EBC 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6EBE DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6EC0 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6EC2 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6EC4 0286  22         ci    tmp2,1
     6EC6 0001 
0157 6EC8 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6ECA D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6ECC 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6ECE 06A0  32         bl    @xpym2m               ; Copy memory block
     6ED0 24E4 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6ED2 A820  54         a     @rambuf+4,@edb.next_free.ptr
     6ED4 2F6E 
     6ED6 A208 
0171                                                      ; Add length of line
0172               
0173 6ED8 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6EDA A208 
0174 6EDC 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6EDE 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6EE0 000F 
0176 6EE2 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6EE4 A208 
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6EE6 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6EE8 2F6A 
     6EEA A10C 
0182               
0183 6EEC 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6EEE A218 
     6EF0 A216 
0184 6EF2 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6EF4 C120  34         mov   @edb.sams.page,tmp0
     6EF6 A216 
0187 6EF8 C160  34         mov   @edb.top.ptr,tmp1
     6EFA A200 
0188 6EFC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6EFE 257A 
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6F00 C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6F02 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6F04 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6F06 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6F08 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6F0A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0132                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
**** **** ****     > edb.line.unpack.fb.asm
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
0028 6F0C 0649  14         dect  stack
0029 6F0E C64B  30         mov   r11,*stack            ; Save return address
0030 6F10 0649  14         dect  stack
0031 6F12 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6F14 0649  14         dect  stack
0033 6F16 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6F18 0649  14         dect  stack
0035 6F1A C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6F1C C820  54         mov   @parm1,@rambuf
     6F1E 2F20 
     6F20 2F6A 
0040 6F22 C820  54         mov   @parm2,@rambuf+2
     6F24 2F22 
     6F26 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6F28 C120  34         mov   @fb.colsline,tmp0
     6F2A A10E 
0045 6F2C 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6F2E 2F22 
0046 6F30 C1A0  34         mov   @fb.top.ptr,tmp2
     6F32 A100 
0047 6F34 A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6F36 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F38 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6F3A 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6F3C 2F20 
     6F3E A204 
0053 6F40 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6F42 04E0  34         clr   @rambuf+8             ; Set length=0
     6F44 2F72 
0056 6F46 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6F48 C120  34 !       mov   @parm1,tmp0
     6F4A 2F20 
0061 6F4C 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F4E 6DCA 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6F50 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F52 2F30 
0069 6F54 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6F56 04E0  34         clr   @rambuf+8             ; Set length=0
     6F58 2F72 
0073 6F5A 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6F5C C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6F5E C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6F60 2F6E 
0080 6F62 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6F64 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6F66 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6F68 0050 
0085                                                   ; /
0086 6F6A 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6F6C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F6E FFCE 
0091 6F70 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F72 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6F74 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6F76 2F70 
0097 6F78 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6F7A 2F72 
0098               
0099 6F7C 04C5  14         clr   tmp1                  ; Fill with >00
0100 6F7E C1A0  34         mov   @fb.colsline,tmp2
     6F80 A10E 
0101 6F82 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6F84 2F72 
0102 6F86 0586  14         inc   tmp2
0103               
0104 6F88 06A0  32         bl    @xfilm                ; Fill CPU memory
     6F8A 2240 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6F8C C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6F8E 2F72 
0113 6F90 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6F92 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6F94 2F6E 
0116 6F96 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6F98 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6F9A 0286  22         ci    tmp2,80               ; Check line length
     6F9C 0050 
0122 6F9E 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6FA0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FA2 FFCE 
0127 6FA4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FA6 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6FA8 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6FAA 2F30 
0133               
0134 6FAC 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6FAE 24E4 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6FB0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6FB2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6FB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 6FB6 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 6FB8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0133                       copy  "edb.line.getlen.asm"    ; Get line length
**** **** ****     > edb.line.getlen.asm
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
0021 6FBA 0649  14         dect  stack
0022 6FBC C64B  30         mov   r11,*stack            ; Push return address
0023 6FBE 0649  14         dect  stack
0024 6FC0 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6FC2 0649  14         dect  stack
0026 6FC4 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6FC6 04E0  34         clr   @outparm1             ; Reset length
     6FC8 2F30 
0031 6FCA 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6FCC 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 6FCE C120  34         mov   @parm1,tmp0           ; \
     6FD0 2F20 
0036 6FD2 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 6FD4 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     6FD6 A204 
0039 6FD8 1101  14         jlt   !                     ; No, continue processing
0040 6FDA 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 6FDC C120  34 !       mov   @parm1,tmp0           ; Get line
     6FDE 2F20 
0046               
0047 6FE0 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6FE2 6DCA 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 6FE4 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6FE6 2F30 
0053 6FE8 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 6FEA C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 6FEC C805  38         mov   tmp1,@outparm1        ; Save length
     6FEE 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 6FF0 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6FF2 0050 
0064 6FF4 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 6FF6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FF8 FFCE 
0070 6FFA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FFC 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 6FFE 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     7000 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 7002 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 7004 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 7006 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 7008 045B  20         b     *r11                  ; Return to caller
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
0103 700A 0649  14         dect  stack
0104 700C C64B  30         mov   r11,*stack            ; Save return address
0105 700E 0649  14         dect  stack
0106 7010 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 7012 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7014 A104 
0111 7016 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7018 A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 701A C804  38         mov   tmp0,@parm1
     701C 2F20 
0116 701E 06A0  32         bl    @edb.line.getlength
     7020 6FBA 
0117 7022 C820  54         mov   @outparm1,@fb.row.length
     7024 2F30 
     7026 A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 7028 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 702A C2F9  30         mov   *stack+,r11           ; Pop R11
0125 702C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0134                       copy  "edb.line.copy.asm"      ; Copy line
**** **** ****     > edb.line.copy.asm
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
0031 702E 0649  14         dect  stack
0032 7030 C64B  30         mov   r11,*stack            ; Save return address
0033 7032 0649  14         dect  stack
0034 7034 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 7036 0649  14         dect  stack
0036 7038 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 703A 0649  14         dect  stack
0038 703C C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 703E 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     7040 2F20 
     7042 A204 
0043 7044 1204  14         jle   !
0044 7046 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7048 FFCE 
0045 704A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     704C 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 704E C120  34 !       mov   @parm2,tmp0           ; Get target line number
     7050 2F22 
0050 7052 0604  14         dec   tmp0                  ; Base 0
0051 7054 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     7056 2F6C 
0052 7058 04E0  34         clr   @rambuf               ; Set source line length=0
     705A 2F6A 
0053 705C 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     705E 2F6E 
0054 7060 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     7062 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 7064 C120  34         mov   @parm1,tmp0           ; Get source line number
     7066 2F20 
0059 7068 0604  14         dec   tmp0                  ; Base 0
0060               
0061 706A 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     706C 6DCA 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 706E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     7070 2F30 
0069 7072 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 7074 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 7076 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 7078 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     707A 2F6A 
0077 707C 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     707E 2F6A 
0078 7080 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     7082 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 7084 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     7086 0050 
0083 7088 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 708A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     708C FFCE 
0088 708E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7090 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 7092 A820  54         a     @w$1000,@edb.top.ptr
     7094 201A 
     7096 A200 
0094 7098 A820  54         a     @w$1000,@edb.next_free.ptr
     709A 201A 
     709C A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 709E 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     70A0 6D84 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 70A2 C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     70A4 2F6E 
0111 70A6 C160  34         mov   @edb.next_free.ptr,tmp1
     70A8 A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 70AA C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     70AC 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 70AE 06A0  32         bl    @xpym2m               ; Copy memory block
     70B0 24E4 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 70B2 6820  54         s     @w$1000,@edb.top.ptr
     70B4 201A 
     70B6 A200 
0127 70B8 6820  54         s     @w$1000,@edb.next_free.ptr
     70BA 201A 
     70BC A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 70BE C820  54         mov   @edb.next_free.ptr,@rambuf+6
     70C0 A208 
     70C2 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 70C4 C120  34         mov   @edb.sams.page,tmp0
     70C6 A216 
0138 70C8 C160  34         mov   @edb.top.ptr,tmp1
     70CA A200 
0139 70CC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70CE 257A 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 70D0 C120  34         mov   @tv.sams.d000,tmp0
     70D2 A00A 
0146 70D4 0205  20         li    tmp1,>d000
     70D6 D000 
0147 70D8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70DA 257A 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 70DC A820  54         a     @rambuf,@edb.next_free.ptr
     70DE 2F6A 
     70E0 A208 
0154                                                      ; Add length of line
0155               
0156 70E2 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     70E4 A208 
0157 70E6 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 70E8 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     70EA 000F 
0159 70EC A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     70EE A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 70F0 C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     70F2 2F6C 
     70F4 2F20 
0165 70F6 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     70F8 2F70 
     70FA 2F22 
0166 70FC C820  54         mov   @edb.sams.hipage,@parm3
     70FE A218 
     7100 2F24 
0167                                                   ; SAMS page to use
0168               
0169 7102 06A0  32         bl    @idx.entry.update     ; Update index
     7104 6BE4 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 7106 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7108 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 710A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 710C C2F9  30         mov   *stack+,r11           ; Pop r11
0182 710E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0135                       copy  "edb.line.del.asm"       ; Delete line
**** **** ****     > edb.line.del.asm
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
0024 7110 0649  14         dect  stack
0025 7112 C64B  30         mov   r11,*stack            ; Save return address
0026 7114 0649  14         dect  stack
0027 7116 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 7118 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     711A 2F20 
     711C A204 
0032 711E 1204  14         jle   !
0033 7120 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7122 FFCE 
0034 7124 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7126 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 7128 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     712A A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 712C C120  34          mov   @edb.lines,tmp0      ; \
     712E A204 
0043 7130 0284  22          ci    tmp0,1               ; | Only single line?
     7132 0001 
0044 7134 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 7136 0620  34         dec   @parm1                ; Base 0
     7138 2F20 
0049 713A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     713C A204 
     713E 2F22 
0050               
0051 7140 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7142 6C92 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 7144 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7146 A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 7148 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     714A A20C 
     714C 2022 
0061 714E 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 7150 8820  54         c     @parm1,@edb.block.m1  ; \
     7152 2F20 
     7154 A20C 
0064 7156 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 7158 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 715A 8820  54         c     @edb.block.m1,@w$0001 ; \
     715C A20C 
     715E 2002 
0068 7160 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 7162 0620  34         dec   @edb.block.m1         ; M1--
     7164 A20C 
0071 7166 0720  34         seto  @fb.colorize          ; Set colorize flag
     7168 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 716A 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     716C A20E 
     716E 2022 
0077 7170 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 7172 8820  54         c     @parm1,@edb.block.m2  ; \
     7174 2F20 
     7176 A20E 
0080 7178 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 717A 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 717C 8820  54         c     @edb.block.m2,@w$0001 ; \
     717E A20E 
     7180 2002 
0084 7182 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 7184 0620  34         dec   @edb.block.m2         ; M2--
     7186 A20E 
0087 7188 0720  34         seto  @fb.colorize          ; Set colorize flag
     718A A110 
0088 718C 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 718E 04E0  34         clr   @parm1                ; 1st line
     7190 2F20 
0094 7192 04E0  34         clr   @parm2                ; 1st line
     7194 2F22 
0095               
0096 7196 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7198 6C92 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 719A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 719C C2F9  30         mov   *stack+,r11           ; Pop r11
0105 719E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0136                       copy  "edb.block.mark.asm"     ; Mark code block
**** **** ****     > edb.block.mark.asm
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
0020 71A0 0649  14         dect  stack
0021 71A2 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 71A4 C820  54         mov   @fb.row,@parm1
     71A6 A106 
     71A8 2F20 
0026 71AA 06A0  32         bl    @fb.row2line          ; Row to editor line
     71AC 6A36 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 71AE 05A0  34         inc   @outparm1             ; Add base 1
     71B0 2F30 
0032               
0033 71B2 C820  54         mov   @outparm1,@edb.block.m1
     71B4 2F30 
     71B6 A20C 
0034                                                   ; Set block marker M1
0035 71B8 0720  34         seto  @fb.colorize          ; Set colorize flag
     71BA A110 
0036 71BC 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     71BE A116 
0037 71C0 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71C2 A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 71C4 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 71C6 045B  20         b     *r11                  ; Return to caller
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
0062 71C8 0649  14         dect  stack
0063 71CA C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 71CC C820  54         mov   @fb.row,@parm1
     71CE A106 
     71D0 2F20 
0068 71D2 06A0  32         bl    @fb.row2line          ; Row to editor line
     71D4 6A36 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 71D6 05A0  34         inc   @outparm1             ; Add base 1
     71D8 2F30 
0074               
0075 71DA C820  54         mov   @outparm1,@edb.block.m2
     71DC 2F30 
     71DE A20E 
0076                                                   ; Set block marker M2
0077               
0078 71E0 0720  34         seto  @fb.colorize          ; Set colorize flag
     71E2 A110 
0079 71E4 0720  34         seto  @fb.dirty             ; Trigger refresh
     71E6 A116 
0080 71E8 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71EA A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 71EC C2F9  30         mov   *stack+,r11           ; Pop r11
0086 71EE 045B  20         b     *r11                  ; Return to caller
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
0106 71F0 0649  14         dect  stack
0107 71F2 C64B  30         mov   r11,*stack            ; Push return address
0108 71F4 0649  14         dect  stack
0109 71F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 71F8 0649  14         dect  stack
0111 71FA C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 71FC C820  54         mov   @fb.row,@parm1
     71FE A106 
     7200 2F20 
0116 7202 06A0  32         bl    @fb.row2line          ; Row to editor line
     7204 6A36 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 7206 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     7208 2F30 
0122 720A 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 720C C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     720E A20C 
0127 7210 0584  14         inc   tmp0                  ; /
0128 7212 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 7214 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     7216 71A0 
0135 7218 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 721A 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     721C A20C 
0141 721E 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 7220 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     7222 71C8 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 7224 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 7226 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 7228 C2F9  30         mov   *stack+,r11           ; Pop r11
0154 722A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0137                       copy  "edb.block.reset.asm"    ; Reset markers
**** **** ****     > edb.block.reset.asm
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
0017 722C 0649  14         dect  stack
0018 722E C64B  30         mov   r11,*stack            ; Push return address
0019 7230 0649  14         dect  stack
0020 7232 C660  46         mov   @wyx,*stack           ; Push cursor position
     7234 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 7236 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     7238 A20C 
0025 723A 0720  34         seto  @edb.block.m2         ; /
     723C A20E 
0026               
0027 723E 0720  34         seto  @fb.colorize          ; Set colorize flag
     7240 A110 
0028 7242 0720  34         seto  @fb.dirty             ; Trigger refresh
     7244 A116 
0029 7246 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7248 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 724A 0720  34         seto  @parm1
     724C 2F20 
0034 724E 06A0  32         bl    @pane.action.colorscheme.load
     7250 7754 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 7252 C820  54         mov   @tv.color,@parm1      ; Set normal color
     7254 A018 
     7256 2F20 
0042 7258 06A0  32         bl    @pane.action.colorscheme.statlines
     725A 78C6 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 725C 06A0  32         bl    @hchar
     725E 27CC 
0048 7260 0034                   byte 0,52,32,18           ; Remove markers
     7262 2012 
0049 7264 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     7266 2037 
0050 7268 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 726A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     726C 832A 
0056 726E C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7270 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0138                       copy  "edb.block.copy.asm"     ; Copy code block
**** **** ****     > edb.block.copy.asm
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
0027 7272 0649  14         dect  stack
0028 7274 C64B  30         mov   r11,*stack            ; Save return address
0029 7276 0649  14         dect  stack
0030 7278 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 727A 0649  14         dect  stack
0032 727C C645  30         mov   tmp1,*stack           ; Push tmp1
0033 727E 0649  14         dect  stack
0034 7280 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 7282 0649  14         dect  stack
0036 7284 C660  46         mov   @parm1,*stack         ; Push parm1
     7286 2F20 
0037 7288 04E0  34         clr   @outparm1             ; No action (>0000)
     728A 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 728C 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     728E A20C 
     7290 2022 
0042 7292 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 7294 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     7296 A20E 
     7298 2022 
0045 729A 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 729C 8820  54         c     @edb.block.m1,@edb.block.m2
     729E A20C 
     72A0 A20E 
0048                                                   ; M1 > M2 ?
0049 72A2 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 72A4 C820  54         mov   @fb.row,@parm1
     72A6 A106 
     72A8 2F20 
0054 72AA 06A0  32         bl    @fb.row2line          ; Row to editor line
     72AC 6A36 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 72AE C120  34         mov   @outparm1,tmp0        ; \
     72B0 2F30 
0060 72B2 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 72B4 C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     72B6 A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 72B8 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     72BA 2F30 
0066 72BC 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 72BE 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     72C0 2F30 
0069 72C2 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 72C4 06A0  32         bl    @cpym2m
     72C6 24DE 
0072 72C8 3960                   data txt.block.inside,tv.error.msg,53
     72CA A02A 
     72CC 0035 
0073               
0074 72CE 06A0  32         bl    @pane.errline.show    ; Show error line
     72D0 7BAE 
0075               
0076 72D2 04E0  34         clr   @outparm1             ; No action (>0000)
     72D4 2F30 
0077 72D6 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 72D8 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     72DA A01C 
     72DC 2F20 
0082 72DE 06A0  32         bl    @pane.action.colorscheme.statlines
     72E0 78C6 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 72E2 06A0  32         bl    @hchar
     72E4 27CC 
0088 72E6 1D00                   byte pane.botrow,0,32,55
     72E8 2037 
0089 72EA FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 72EC C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 72EE 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 72F0 06A0  32         bl    @putat
     72F2 2446 
0098 72F4 1D00                   byte pane.botrow,0
0099 72F6 34DA                   data txt.block.copy   ; Display "Copying block...."
0100 72F8 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 72FA 06A0  32         bl    @putat
     72FC 2446 
0104 72FE 1D00                   byte pane.botrow,0
0105 7300 34EC                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 7302 C120  34         mov   @edb.block.m1,tmp0    ; M1
     7304 A20C 
0111 7306 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     7308 A20E 
0112 730A 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 730C 0586  14         inc   tmp2                  ; /
0114               
0115 730E C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     7310 A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 7312 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     7314 2F20 
0121 7316 0620  34         dec   @parm1                ; Base 0 offset for index required
     7318 2F20 
0122 731A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     731C A204 
     731E 2F22 
0123               
0124 7320 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     7322 6D2C 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 7324 8805  38         c     tmp1,@edb.block.m1
     7326 A20C 
0131 7328 1506  14         jgt   edb.block.copy.loop.docopy
0132 732A 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 732C 05A0  34         inc   @edb.block.m1         ; M1++
     732E A20C 
0135 7330 05A0  34         inc   @edb.block.m2         ; M2++
     7332 A20E 
0136 7334 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 7336 C804  38         mov   tmp0,@parm1           ; Source line for copy
     7338 2F20 
0142 733A C805  38         mov   tmp1,@parm2           ; Target line for copy
     733C 2F22 
0143               
0144 733E 06A0  32         bl    @edb.line.copy        ; Copy line
     7340 702E 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 7342 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     7344 A204 
0151 7346 0584  14         inc   tmp0                  ; Next source line
0152 7348 0585  14         inc   tmp1                  ; Next target line
0153 734A 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 734C 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 734E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7350 A206 
0159 7352 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     7354 A116 
0160 7356 0720  34         seto  @outparm1             ; Copy completed
     7358 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 735A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     735C 2F20 
0166 735E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 7360 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 7362 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 7364 C2F9  30         mov   *stack+,r11           ; Pop R11
0170 7366 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0139                       copy  "edb.block.del.asm"      ; Delete code block
**** **** ****     > edb.block.del.asm
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
0027 7368 0649  14         dect  stack
0028 736A C64B  30         mov   r11,*stack            ; Save return address
0029 736C 0649  14         dect  stack
0030 736E C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7370 0649  14         dect  stack
0032 7372 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7374 0649  14         dect  stack
0034 7376 C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 7378 04E0  34         clr   @outparm1             ; No action (>0000)
     737A 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 737C C120  34         mov   @edb.block.m1,tmp0    ; \
     737E A20C 
0041 7380 0584  14         inc   tmp0                  ; | M1 unset?
0042 7382 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 7384 C160  34         mov   @edb.block.m2,tmp1    ; \
     7386 A20E 
0045 7388 0584  14         inc   tmp0                  ; | M2 unset?
0046 738A 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 738C C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     738E 2F20 
0051 7390 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 7392 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     7394 A01C 
     7396 2F20 
0056               
0057 7398 06A0  32         bl    @pane.action.colorscheme.statlines
     739A 78C6 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 739C 06A0  32         bl    @hchar
     739E 27CC 
0063 73A0 1D00                   byte pane.botrow,0,32,55
     73A2 2037 
0064 73A4 FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 73A6 06A0  32         bl    @putat
     73A8 2446 
0067 73AA 1D00                   byte pane.botrow,0
0068 73AC 34C6                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 73AE C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     73B0 A20C 
0074 73B2 0604  14         dec   tmp0                  ; Base 0
0075               
0076 73B4 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     73B6 A20E 
0077 73B8 0605  14         dec   tmp1                  ; Base 0
0078               
0079 73BA C804  38         mov   tmp0,@parm1           ; Delete line on M1
     73BC 2F20 
0080 73BE C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     73C0 A204 
     73C2 2F22 
0081 73C4 0620  34         dec   @parm2                ; Base 0
     73C6 2F22 
0082               
0083 73C8 C185  18         mov   tmp1,tmp2             ; \
0084 73CA 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 73CC 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 73CE 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     73D0 6C92 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 73D2 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     73D4 A204 
0095 73D6 0620  34         dec   @parm2                ; /
     73D8 2F22 
0096               
0097 73DA 0606  14         dec   tmp2
0098 73DC 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 73DE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     73E0 A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 73E2 8820  54         c     @fb.topline,@edb.lines
     73E4 A104 
     73E6 A204 
0104                                                   ; Beyond editor buffer?
0105 73E8 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 73EA C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     73EC A104 
     73EE 2F20 
0108 73F0 1002  14         jmp   edb.block.delete.fb.refresh
0109 73F2 04E0  34 !       clr   @parm1                ; Set line to start with
     73F4 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 73F6 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     73F8 6B38 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 73FA 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     73FC 722C 
0119               
0120 73FE 0720  34         seto  @outparm1             ; Delete completed
     7400 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 7402 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 7404 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 7406 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7408 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.3765856
0140                       ;-----------------------------------------------------------------------
0141                       ; Command buffer handling
0142                       ;-----------------------------------------------------------------------
0143                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
**** **** ****     > cmdb.refresh.asm
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
0022 740A 0649  14         dect  stack
0023 740C C64B  30         mov   r11,*stack            ; Save return address
0024 740E 0649  14         dect  stack
0025 7410 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7412 0649  14         dect  stack
0027 7414 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 7416 0649  14         dect  stack
0029 7418 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 741A 0649  14         dect  stack
0031 741C C660  46         mov   @wyx,*stack           ; Push cursor position
     741E 832A 
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 7420 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     7422 A310 
     7424 832A 
0036               
0037 7426 05A0  34         inc   @wyx                  ; X +1 for prompt
     7428 832A 
0038               
0039 742A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     742C 23FE 
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 742E 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     7430 A329 
0044 7432 0206  20         li    tmp2,1*79             ; Command length
     7434 004F 
0045               
0046 7436 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     7438 2490 
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 743A C820  54         mov   @cmdb.yxprompt,@wyx
     743C A310 
     743E 832A 
0054 7440 06A0  32         bl    @putstr
     7442 2422 
0055 7444 3996                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 7446 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7448 832A 
0061 744A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 744C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 744E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 7450 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 7452 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0144                       copy  "cmdb.cmd.asm"        ; Command line handling
**** **** ****     > cmdb.cmd.asm
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
0022 7454 0649  14         dect  stack
0023 7456 C64B  30         mov   r11,*stack            ; Save return address
0024 7458 0649  14         dect  stack
0025 745A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 745C 0649  14         dect  stack
0027 745E C645  30         mov   tmp1,*stack           ; Push tmp1
0028 7460 0649  14         dect  stack
0029 7462 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 7464 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     7466 A328 
0034 7468 06A0  32         bl    @film                 ; Clear command
     746A 223A 
0035 746C A329                   data  cmdb.cmd,>00,80
     746E 0000 
     7470 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 7472 C120  34         mov   @cmdb.yxprompt,tmp0
     7474 A310 
0040 7476 0584  14         inc   tmp0
0041 7478 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     747A A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 747C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 747E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 7480 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7482 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7484 045B  20         b     *r11                  ; Return to caller
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
0075 7486 0649  14         dect  stack
0076 7488 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 748A 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     748C 2AD2 
0081 748E A329                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     7490 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 7492 C820  54         mov   @waux1,@outparm1     ; Save length of string
     7494 833C 
     7496 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 7498 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 749A 045B  20         b     *r11                  ; Return to caller
0091               
0092               
0093               
0094               
0095               
0096               ***************************************************************
0097               * cmdb.cmd.addhist
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
0115 749C 0649  14         dect  stack
0116 749E C64B  30         mov   r11,*stack            ; Save return address
0117 74A0 0649  14         dect  stack
0118 74A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 74A4 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     74A6 7486 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Assert
0125                       ;------------------------------------------------------
0126 74A8 C120  34         mov   @outparm1,tmp0        ; Check length
     74AA 2F30 
0127 74AC 1300  14         jeq   cmdb.cmd.history.add.exit
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
0139 74AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 74B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0141 74B2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0145                       ;-----------------------------------------------------------------------
0146                       ; User hook, background tasks
0147                       ;-----------------------------------------------------------------------
0148                       copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 74B4 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     74B6 200A 
0009 74B8 161C  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 74BA C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     74BC 833C 
     74BE 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 74C0 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     74C2 200A 
0016 74C4 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     74C6 2F40 
     74C8 2F42 
0017 74CA 1608  14         jne   hook.keyscan.new      ; New key pressed
0018               *---------------------------------------------------------------
0019               * Activate auto-repeat ?
0020               *---------------------------------------------------------------
0021 74CC 05A0  34         inc   @keyrptcnt
     74CE 2F3E 
0022 74D0 C120  34         mov   @keyrptcnt,tmp0
     74D2 2F3E 
0023 74D4 0284  22         ci    tmp0,30
     74D6 001E 
0024 74D8 1112  14         jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
0025 74DA 1002  14         jmp   hook.keyscan.autorepeat
0026               *--------------------------------------------------------------
0027               * New key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.new:
0030 74DC 04E0  34         clr   @keyrptcnt            ; Reset key-repeat counter
     74DE 2F3E 
0031               hook.keyscan.autorepeat:
0032 74E0 0204  20         li    tmp0,250              ; \
     74E2 00FA 
0033 74E4 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0034 74E6 16FE  14         jne   -!                    ; /
0035 74E8 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     74EA 2F40 
     74EC 2F42 
0036 74EE 0460  28         b     @edkey.key.process    ; Process key
     74F0 60E4 
0037               *--------------------------------------------------------------
0038               * Clear keyboard buffer if no key pressed
0039               *--------------------------------------------------------------
0040               hook.keyscan.clear_kbbuffer:
0041 74F2 04E0  34         clr   @keycode1
     74F4 2F40 
0042 74F6 04E0  34         clr   @keycode2
     74F8 2F42 
0043 74FA 04E0  34         clr   @keyrptcnt
     74FC 2F3E 
0044               *--------------------------------------------------------------
0045               * Delay to avoid key bouncing
0046               *--------------------------------------------------------------
0047               hook.keyscan.bounce:
0048 74FE 0204  20         li    tmp0,2000             ; Avoid key bouncing
     7500 07D0 
0049                       ;------------------------------------------------------
0050                       ; Delay loop
0051                       ;------------------------------------------------------
0052               hook.keyscan.bounce.loop:
0053 7502 0604  14         dec   tmp0
0054 7504 16FE  14         jne   hook.keyscan.bounce.loop
0055 7506 0460  28         b     @hookok               ; Return
     7508 2D52 
0056               
**** **** ****     > stevie_b1.asm.3765856
0149                       copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 750A 0649  14         dect  stack
0009 750C C64B  30         mov   r11,*stack            ; Save return address
0010 750E 0649  14         dect  stack
0011 7510 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7512 0649  14         dect  stack
0013 7514 C660  46         mov   @wyx,*stack           ; Push cursor position
     7516 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 7518 20A0  38         coc   @wbit10,config
     751A 200C 
0019 751C 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 751E 06A0  32         bl    @putat
     7520 2446 
0024 7522 1D4E                   byte pane.botrow,78
0025 7524 35E8                   data txt.ws4
0026 7526 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 7528 06A0  32         bl    @putat
     752A 2446 
0032 752C 1D4E                   byte pane.botrow,78
0033 752E 35D6                   data txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 7530 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7532 A302 
0039 7534 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 7536 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7538 A318 
0045 753A 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 753C 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     753E 7A0A 
0048 7540 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7542 A318 
0049 7544 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 7546 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7548 A116 
0054 754A 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056 754C C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     754E A11A 
     7550 2F20 
0057               
0058               task.vdp.panes.dump:
0059 7552 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7554 7EB2 
0060                                                   ; \ i  @parm1 = number of lines to dump
0061                                                   ; /
0062                       ;------------------------------------------------------
0063                       ; Color the lines in the framebuffer (TAT)
0064                       ;------------------------------------------------------
0065 7556 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     7558 A110 
0066 755A 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0067               
0068 755C 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     755E 7EA0 
0069                       ;-------------------------------------------------------
0070                       ; Finished with frame buffer
0071                       ;-------------------------------------------------------
0072               task.vdp.panes.dumped:
0073 7560 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7562 A116 
0074 7564 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     7566 A118 
0075                       ;-------------------------------------------------------
0076                       ; Refresh top and bottom line
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.statlines:
0079 7568 C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     756A A118 
0080 756C 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0081               
0082 756E 06A0  32         bl    @pane.topline         ; Draw top line
     7570 7B12 
0083 7572 06A0  32         bl    @pane.botline         ; Draw bottom line
     7574 7C48 
0084 7576 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     7578 A118 
0085                       ;------------------------------------------------------
0086                       ; Show ruler with tab positions
0087                       ;------------------------------------------------------
0088 757A C120  34         mov   @tv.ruler.visible,tmp0
     757C A010 
0089                                                   ; Should ruler be visible?
0090 757E 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0091               
0092 7580 06A0  32         bl    @cpym2v
     7582 248A 
0093 7584 0050                   data vdp.fb.toprow.sit
0094 7586 A11E                   data fb.ruler.sit
0095 7588 0050                   data 80               ; Show ruler
0096                       ;------------------------------------------------------
0097                       ; Exit task
0098                       ;------------------------------------------------------
0099               task.vdp.panes.exit:
0100 758A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     758C 832A 
0101 758E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7590 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7592 0460  28         b     @slotok
     7594 2DCE 
**** **** ****     > stevie_b1.asm.3765856
0150               
0152               
0153                       copy  "task.vdp.cursor.sat.asm"    ; Copy cursor SAT to VDP
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 7596 0649  14         dect  stack
0009 7598 C64B  30         mov   r11,*stack            ; Save return address
0010 759A 0649  14         dect  stack
0011 759C C644  30         mov   tmp0,*stack           ; Push tmp0
0012 759E 0649  14         dect  stack
0013 75A0 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 75A2 0649  14         dect  stack
0015 75A4 C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 75A6 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     75A8 A022 
0020               
0021 75AA 0284  22         ci    tmp0,pane.focus.fb
     75AC 0000 
0022 75AE 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 75B0 0284  22         ci    tmp0,pane.focus.cmdb
     75B2 0001 
0025 75B4 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 75B6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     75B8 FFCE 
0031 75BA 06A0  32         bl    @cpu.crash            ; / Halt system.
     75BC 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 75BE C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     75C0 A30A 
     75C2 832A 
0037 75C4 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     75C6 2020 
0038 75C8 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     75CA 26F4 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 75CC 100D  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 75CE E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     75D0 2020 
0048 75D2 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     75D4 26F4 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 75D6 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     75D8 A010 
     75DA A010 
0053 75DC 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0054 75DE 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     75E0 1000 
0055 75E2 1002  14         jmp   task.vdp.copy.sat.write
0056               task.vdp.copy.sat.fb.noruler:
0057 75E4 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     75E6 0800 
0058                       ;------------------------------------------------------
0059                       ; Dump sprite attribute table
0060                       ;------------------------------------------------------
0061               task.vdp.copy.sat.write:
0062 75E8 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     75EA 2F5A 
0063                       ;------------------------------------------------------
0064                       ; Handle column and row indicators
0065                       ;------------------------------------------------------
0066 75EC C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     75EE A010 
     75F0 A010 
0067                                                   ; Is ruler visible?
0068 75F2 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0069               
0070 75F4 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     75F6 FF00 
0071 75F8 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     75FA 00F0 
0072 75FC C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     75FE 2F5E 
0073               
0074 7600 C120  34         mov   @ramsat,tmp0
     7602 2F5A 
0075 7604 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     7606 00FF 
0076 7608 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     760A 0800 
0077 760C C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     760E 2F62 
0078               
0079 7610 1005  14         jmp   task.vdp.copy.sat.write2
0080                       ;------------------------------------------------------
0081                       ; Do not show column and row indicators
0082                       ;------------------------------------------------------
0083               task.vdp.copy.sat.hide.indicators:
0084 7612 04C5  14         clr   tmp1
0085 7614 D805  38         movb  tmp1,@ramsat+7        ; Hide line indicator    <
     7616 2F61 
0086 7618 D805  38         movb  tmp1,@ramsat+11       ; Hide column indicator  v
     761A 2F65 
0087                       ;------------------------------------------------------
0088                       ; Dump to VDP
0089                       ;------------------------------------------------------
0090               task.vdp.copy.sat.write2:
0091 761C 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     761E 248A 
0092 7620 2180                   data sprsat,ramsat,14 ; \ i  tmp0 = VDP destination
     7622 2F5A 
     7624 000E 
0093                                                   ; | i  tmp1 = ROM/RAM source
0094                                                   ; / i  tmp2 = Number of bytes to write
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               task.vdp.copy.sat.exit:
0099 7626 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 7628 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 762A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 762C C2F9  30         mov   *stack+,r11           ; Pop r11
0103 762E 0460  28         b     @slotok               ; Exit task
     7630 2DCE 
**** **** ****     > stevie_b1.asm.3765856
0154                       copy  "task.vdp.cursor.f18a.asm"   ; Set cursor shape in VDP (blink)
**** **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 7632 0649  14         dect  stack
0009 7634 C64B  30         mov   r11,*stack            ; Save return address
0010 7636 0649  14         dect  stack
0011 7638 C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 763A 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     763C A112 
0016 763E 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 7640 04C4  14         clr   tmp0
0021 7642 D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     7644 2F5D 
0022 7646 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 7648 C820  54         mov   @tv.curshape,@ramsat+2
     764A A014 
     764C 2F5C 
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 764E 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7650 248A 
0035 7652 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     7654 2F5A 
     7656 0004 
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 7658 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 765A C2F9  30         mov   *stack+,r11           ; Pop r11
0044 765C 0460  28         b     @slotok               ; Exit task
     765E 2DCE 
**** **** ****     > stevie_b1.asm.3765856
0155               
0161               
0162                       copy  "task.oneshot.asm"           ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7660 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7662 A024 
0010 7664 1301  14         jeq   task.oneshot.exit
0011               
0012 7666 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 7668 0460  28         b     @slotok                ; Exit task
     766A 2DCE 
**** **** ****     > stevie_b1.asm.3765856
0163                       ;-----------------------------------------------------------------------
0164                       ; Screen pane utilities
0165                       ;-----------------------------------------------------------------------
0166                       copy  "pane.utils.asm"             ; Pane utility functions
**** **** ****     > pane.utils.asm
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
0020 766C 0649  14         dect  stack
0021 766E C64B  30         mov   r11,*stack            ; Push return address
0022 7670 0649  14         dect  stack
0023 7672 C660  46         mov   @wyx,*stack           ; Push cursor position
     7674 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 7676 06A0  32         bl    @hchar
     7678 27CC 
0028 767A 0034                   byte 0,52,32,18
     767C 2012 
0029 767E FFFF                   data EOL              ; Clear message
0030               
0031 7680 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7682 A024 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 7684 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7686 832A 
0037 7688 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 768A 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.3765856
0167                       copy  "pane.utils.hint.asm"        ; Show hint in pane
**** **** ****     > pane.utils.hint.asm
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
0021 768C 0649  14         dect  stack
0022 768E C64B  30         mov   r11,*stack            ; Save return address
0023 7690 0649  14         dect  stack
0024 7692 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7694 0649  14         dect  stack
0026 7696 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7698 0649  14         dect  stack
0028 769A C646  30         mov   tmp2,*stack           ; Push tmp2
0029 769C 0649  14         dect  stack
0030 769E C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 76A0 C820  54         mov   @parm1,@wyx           ; Set cursor
     76A2 2F20 
     76A4 832A 
0035 76A6 C160  34         mov   @parm2,tmp1           ; Get string to display
     76A8 2F22 
0036 76AA 06A0  32         bl    @xutst0               ; Display string
     76AC 2424 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 76AE C120  34         mov   @parm2,tmp0
     76B0 2F22 
0041 76B2 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 76B4 0984  56         srl   tmp0,8                ; Right justify
0043 76B6 C184  18         mov   tmp0,tmp2
0044 76B8 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 76BA 0506  16         neg   tmp2
0046 76BC 0226  22         ai    tmp2,80               ; Number of bytes to fill
     76BE 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 76C0 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     76C2 2F20 
0051 76C4 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 76C6 C804  38         mov   tmp0,@wyx             ; / Set cursor
     76C8 832A 
0053               
0054 76CA 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     76CC 23FE 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 76CE 0205  20         li    tmp1,32               ; Byte to fill
     76D0 0020 
0059               
0060 76D2 06A0  32         bl    @xfilv                ; Clear line
     76D4 2298 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 76D6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 76D8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 76DA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 76DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 76DE C2F9  30         mov   *stack+,r11           ; Pop R11
0073 76E0 045B  20         b     *r11                  ; Return to caller
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
0095 76E2 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     76E4 2F20 
0096 76E6 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     76E8 2F22 
0097 76EA 0649  14         dect  stack
0098 76EC C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 76EE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     76F0 768C 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 76F2 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 76F4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0168                       copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes
**** **** ****     > pane.utils.colorscheme.asm
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
0017 76F6 0649  14         dect  stack
0018 76F8 C64B  30         mov   r11,*stack            ; Push return address
0019 76FA 0649  14         dect  stack
0020 76FC C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 76FE C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7700 A012 
0023 7702 0284  22         ci    tmp0,tv.colorscheme.entries
     7704 000A 
0024                                                   ; Last entry reached?
0025 7706 1103  14         jlt   !
0026 7708 0204  20         li    tmp0,1                ; Reset color scheme index
     770A 0001 
0027 770C 1001  14         jmp   pane.action.colorscheme.switch
0028 770E 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 7710 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7712 A012 
0034               
0035 7714 06A0  32         bl    @pane.action.colorscheme.load
     7716 7754 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 7718 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     771A 832A 
     771C 833C 
0041               
0042 771E 06A0  32         bl    @putnum
     7720 2A5C 
0043 7722 003E                   byte 0,62
0044 7724 A012                   data tv.colorscheme,rambuf,>3020
     7726 2F6A 
     7728 3020 
0045               
0046 772A 06A0  32         bl    @putat
     772C 2446 
0047 772E 0034                   byte 0,52
0048 7730 3998                   data txt.colorscheme  ; Show color palette message
0049               
0050 7732 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     7734 833C 
     7736 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 7738 0204  20         li    tmp0,12000
     773A 2EE0 
0055 773C 0604  14 !       dec   tmp0
0056 773E 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 7740 0204  20         li    tmp0,pane.clearmsg.task.callback
     7742 766C 
0061 7744 C804  38         mov   tmp0,@tv.task.oneshot
     7746 A024 
0062               
0063 7748 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     774A 2E38 
0064 774C 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 774E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7750 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 7752 045B  20         b     *r11                  ; Return to caller
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
0093 7754 0649  14         dect  stack
0094 7756 C64B  30         mov   r11,*stack            ; Save return address
0095 7758 0649  14         dect  stack
0096 775A C644  30         mov   tmp0,*stack           ; Push tmp0
0097 775C 0649  14         dect  stack
0098 775E C645  30         mov   tmp1,*stack           ; Push tmp1
0099 7760 0649  14         dect  stack
0100 7762 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 7764 0649  14         dect  stack
0102 7766 C647  30         mov   tmp3,*stack           ; Push tmp3
0103 7768 0649  14         dect  stack
0104 776A C648  30         mov   tmp4,*stack           ; Push tmp4
0105 776C 0649  14         dect  stack
0106 776E C660  46         mov   @parm1,*stack         ; Push parm1
     7770 2F20 
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 7772 C120  34         mov   @parm1,tmp0
     7774 2F20 
0111 7776 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7778 FFFF 
0112 777A 1302  14         jeq   !                     ; Yes, so skip screen off
0113 777C 06A0  32         bl    @scroff               ; Turn screen off
     777E 2692 
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7780 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7782 A012 
0118 7784 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 7786 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 7788 0224  22         ai    tmp0,tv.colorscheme.table
     778A 33DE 
0122                                                   ; Add base for color scheme data table
0123 778C C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 778E C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7790 A018 
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 7792 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 7794 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     7796 00FF 
0130 7798 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     779A A016 
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 779C C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 779E 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     77A0 FF00 
0136 77A2 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 77A4 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 77A6 C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 77A8 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 77AA C806  38         mov   tmp2,@tv.busycolor    ; /
     77AC A01C 
0142               
0143 77AE 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     77B0 00FF 
0144 77B2 C805  38         mov   tmp1,@tv.markcolor    ; /
     77B4 A01A 
0145               
0146 77B6 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 77B8 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 77BA C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     77BC A020 
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 77BE C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 77C0 0245  22         andi  tmp1,>000f            ; Only keep P
     77C2 000F 
0154 77C4 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 77C6 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     77C8 A01E 
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 77CA C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 77CC 0245  22         andi  tmp1,>00f0            ; Only keep O
     77CE 00F0 
0161 77D0 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 77D2 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     77D4 2F61 
0163 77D6 D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     77D8 2F65 
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 77DA C147  18         mov   tmp3,tmp1             ; Get work copy
0168 77DC 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 77DE 0265  22         ori   tmp1,>0700
     77E0 0700 
0170 77E2 C105  18         mov   tmp1,tmp0
0171 77E4 06A0  32         bl    @putvrx               ; Write VDP register
     77E6 2338 
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 77E8 C120  34         mov   @tv.ruler.visible,tmp0
     77EA A010 
0176 77EC 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177 77EE 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     77F0 18A0 
0178                                                   ; VDP start address (frame buffer area)
0179 77F2 0206  20         li    tmp2,(pane.botrow-2)*80
     77F4 0870 
0180                                                   ; Number of bytes to fill
0181 77F6 1004  14         jmp   pane.action.colorscheme.fbdump
0182               pane.action.colorscheme.fbdump.noruler:
0183 77F8 0204  20         li    tmp0,vdp.fb.toprow.tat
     77FA 1850 
0184                                                   ; VDP start address (frame buffer area)
0185 77FC 0206  20         li    tmp2,(pane.botrow-1)*80
     77FE 08C0 
0186                                                   ; Number of bytes to fill
0187               pane.action.colorscheme.fbdump:
0188 7800 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0189 7802 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0190               
0191 7804 06A0  32         bl    @xfilv                ; Fill colors
     7806 2298 
0192                                                   ; i \  tmp0 = start address
0193                                                   ; i |  tmp1 = byte to fill
0194                                                   ; i /  tmp2 = number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Colorize marked lines
0197                       ;-------------------------------------------------------
0198 7808 C120  34         mov   @parm2,tmp0
     780A 2F22 
0199 780C 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     780E FFFF 
0200 7810 1304  14         jeq   pane.action.colorscheme.cmdbpane
0201               
0202 7812 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     7814 A110 
0203 7816 06A0  32         bl    @fb.colorlines
     7818 7EA0 
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for CMDB pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.cmdbpane:
0208 781A C120  34         mov   @cmdb.visible,tmp0
     781C A302 
0209 781E 130F  14         jeq   pane.action.colorscheme.errpane
0210                                                   ; Skip if CMDB pane is hidden
0211               
0212 7820 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     7822 1FD0 
0213                                                   ; VDP start address (CMDB top line)
0214               
0215 7824 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     7826 A020 
0216 7828 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     782A 0050 
0217 782C 06A0  32         bl    @xfilv                ; Fill colors
     782E 2298 
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for CMDB pane content (TAT)
0223                       ;-------------------------------------------------------
0224 7830 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     7832 2020 
0225                                                   ; VDP start address (CMDB top line + 1)
0226 7834 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0227 7836 0206  20         li    tmp2,3*80             ; Number of bytes to fill
     7838 00F0 
0228 783A 06A0  32         bl    @xfilv                ; Fill colors
     783C 2298 
0229                                                   ; i \  tmp0 = start address
0230                                                   ; i |  tmp1 = byte to fill
0231                                                   ; i /  tmp2 = number of bytes to fill
0232                       ;-------------------------------------------------------
0233                       ; Dump colors for error line (TAT)
0234                       ;-------------------------------------------------------
0235               pane.action.colorscheme.errpane:
0236 783E C120  34         mov   @tv.error.visible,tmp0
     7840 A028 
0237 7842 130A  14         jeq   pane.action.colorscheme.statline
0238                                                   ; Skip if error line pane is hidden
0239               
0240 7844 0205  20         li    tmp1,>00f6            ; White on dark red
     7846 00F6 
0241 7848 C805  38         mov   tmp1,@parm1           ; Pass color combination
     784A 2F20 
0242               
0243 784C 0205  20         li    tmp1,pane.botrow-1    ;
     784E 001C 
0244 7850 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7852 2F22 
0245               
0246 7854 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7856 791E 
0247                                                   ; \ i  @parm1 = Color combination
0248                                                   ; / i  @parm2 = Row on physical screen
0249                       ;-------------------------------------------------------
0250                       ; Dump colors for top line and bottom line (TAT)
0251                       ;-------------------------------------------------------
0252               pane.action.colorscheme.statline:
0253 7858 C160  34         mov   @tv.color,tmp1
     785A A018 
0254 785C 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     785E 00FF 
0255 7860 C805  38         mov   tmp1,@parm1           ; Set color combination
     7862 2F20 
0256               
0257               
0258 7864 04E0  34         clr   @parm2                ; Top row on screen
     7866 2F22 
0259 7868 06A0  32         bl    @colors.line.set      ; Load color combination for line
     786A 791E 
0260                                                   ; \ i  @parm1 = Color combination
0261                                                   ; / i  @parm2 = Row on physical screen
0262               
0263 786C 0205  20         li    tmp1,pane.botrow
     786E 001D 
0264 7870 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     7872 2F22 
0265 7874 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7876 791E 
0266                                                   ; \ i  @parm1 = Color combination
0267                                                   ; / i  @parm2 = Row on physical screen
0268                       ;-------------------------------------------------------
0269                       ; Dump colors for ruler if visible (TAT)
0270                       ;-------------------------------------------------------
0271 7878 C160  34         mov   @tv.ruler.visible,tmp1
     787A A010 
0272 787C 1307  14         jeq   pane.action.colorscheme.cursorcolor
0273               
0274 787E 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     7880 7E8E 
0275 7882 06A0  32         bl    @cpym2v
     7884 248A 
0276 7886 1850                   data vdp.fb.toprow.tat
0277 7888 A16E                   data fb.ruler.tat
0278 788A 0050                   data 80               ; Show ruler colors
0279                       ;-------------------------------------------------------
0280                       ; Dump cursor FG color to sprite table (SAT)
0281                       ;-------------------------------------------------------
0282               pane.action.colorscheme.cursorcolor:
0283 788C C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     788E A016 
0284               
0285 7890 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7892 A022 
0286 7894 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     7896 0000 
0287 7898 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0288                                                   ; Yes, set cursor color
0289               
0290               pane.action.colorscheme.cursorcolor.cmdb:
0291 789A 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     789C 00F0 
0292 789E 0A48  56         sla   tmp4,4                ; Move to MSB
0293 78A0 1003  14         jmp   !
0294               
0295               pane.action.colorscheme.cursorcolor.fb:
0296 78A2 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     78A4 000F 
0297 78A6 0A88  56         sla   tmp4,8                ; Move to MSB
0298               
0299 78A8 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     78AA 2F5D 
0300 78AC D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     78AE A015 
0301                       ;-------------------------------------------------------
0302                       ; Exit
0303                       ;-------------------------------------------------------
0304               pane.action.colorscheme.load.exit:
0305 78B0 06A0  32         bl    @scron                ; Turn screen on
     78B2 269A 
0306 78B4 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     78B6 2F20 
0307 78B8 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0308 78BA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0309 78BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0310 78BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0311 78C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0312 78C2 C2F9  30         mov   *stack+,r11           ; Pop R11
0313 78C4 045B  20         b     *r11                  ; Return to caller
0314               
0315               
0316               
0317               ***************************************************************
0318               * pane.action.colorscheme.statline
0319               * Set color combination for bottom status line
0320               ***************************************************************
0321               * bl @pane.action.colorscheme.statlines
0322               *--------------------------------------------------------------
0323               * INPUT
0324               * @parm1 = Color combination to set
0325               *--------------------------------------------------------------
0326               * OUTPUT
0327               * none
0328               *--------------------------------------------------------------
0329               * Register usage
0330               * tmp0, tmp1, tmp2
0331               ********|*****|*********************|**************************
0332               pane.action.colorscheme.statlines:
0333 78C6 0649  14         dect  stack
0334 78C8 C64B  30         mov   r11,*stack            ; Save return address
0335 78CA 0649  14         dect  stack
0336 78CC C644  30         mov   tmp0,*stack           ; Push tmp0
0337                       ;------------------------------------------------------
0338                       ; Bottom line
0339                       ;------------------------------------------------------
0340 78CE 0204  20         li    tmp0,pane.botrow
     78D0 001D 
0341 78D2 C804  38         mov   tmp0,@parm2           ; Last row on screen
     78D4 2F22 
0342 78D6 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78D8 791E 
0343                                                   ; \ i  @parm1 = Color combination
0344                                                   ; / i  @parm2 = Row on physical screen
0345                       ;------------------------------------------------------
0346                       ; Exit
0347                       ;------------------------------------------------------
0348               pane.action.colorscheme.statlines.exit:
0349 78DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0350 78DC C2F9  30         mov   *stack+,r11           ; Pop R11
0351 78DE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0169                       copy  "pane.cursor.asm"            ; Cursor utility functions
**** **** ****     > pane.cursor.asm
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
0020 78E0 0649  14         dect  stack
0021 78E2 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 78E4 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     78E6 2292 
0026 78E8 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     78EA 0000 
     78EC 0008 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 78EE 06A0  32         bl    @clslot
     78F0 2E2A 
0031 78F2 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 78F4 06A0  32         bl    @clslot
     78F6 2E2A 
0034 78F8 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 78FA C2F9  30         mov   *stack+,r11           ; Pop R11
0040 78FC 045B  20         b     *r11                  ; Return to caller
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
0060 78FE 0649  14         dect  stack
0061 7900 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 7902 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7904 2292 
0066 7906 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7908 0000 
     790A 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 790C 06A0  32         bl    @mkslot
     790E 2E0C 
0073 7910 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     7912 7596 
0074 7914 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     7916 7632 
0075 7918 FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 791A C2F9  30         mov   *stack+,r11           ; Pop R11
0090 791C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0170                       ;-----------------------------------------------------------------------
0171                       ; Screen panes
0172                       ;-----------------------------------------------------------------------
0173                       copy  "colors.line.set.asm"        ; Set color combination for line
**** **** ****     > colors.line.set.asm
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
0021 791E 0649  14         dect  stack
0022 7920 C64B  30         mov   r11,*stack            ; Save return address
0023 7922 0649  14         dect  stack
0024 7924 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7926 0649  14         dect  stack
0026 7928 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 792A 0649  14         dect  stack
0028 792C C646  30         mov   tmp2,*stack           ; Push tmp2
0029 792E 0649  14         dect  stack
0030 7930 C660  46         mov   @parm1,*stack         ; Push parm1
     7932 2F20 
0031 7934 0649  14         dect  stack
0032 7936 C660  46         mov   @parm2,*stack         ; Push parm2
     7938 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 793A C120  34         mov   @parm2,tmp0           ; Get target line
     793C 2F22 
0037 793E 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7940 0050 
0038 7942 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 7944 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 7946 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     7948 1800 
0042 794A C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     794C 2F20 
0043 794E 0206  20         li    tmp2,80               ; Number of bytes to fill
     7950 0050 
0044               
0045 7952 06A0  32         bl    @xfilv                ; Fill colors
     7954 2298 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 7956 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     7958 2F22 
0054 795A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     795C 2F20 
0055 795E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7960 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7962 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7964 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 7966 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0174                       copy  "pane.cmdb.asm"              ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.3765856
0175                       copy  "pane.cmdb.show.asm"         ; Show command buffer pane
**** **** ****     > pane.cmdb.show.asm
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
0022 7968 0649  14         dect  stack
0023 796A C64B  30         mov   r11,*stack            ; Save return address
0024 796C 0649  14         dect  stack
0025 796E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7970 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7972 832A 
     7974 A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 7976 0204  20         li    tmp0,pane.botrow
     7978 001D 
0033 797A 6120  34         s     @cmdb.scrrows,tmp0
     797C A306 
0034 797E C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7980 A11A 
0035               
0036 7982 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 7984 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7986 A30E 
0038               
0039 7988 0224  22         ai    tmp0,>0100
     798A 0100 
0040 798C C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     798E A310 
0041 7990 0584  14         inc   tmp0
0042 7992 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7994 A30A 
0043               
0044 7996 0720  34         seto  @cmdb.visible         ; Show pane
     7998 A302 
0045 799A 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     799C A318 
0046               
0047 799E 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     79A0 0001 
0048 79A2 C804  38         mov   tmp0,@tv.pane.focus   ; /
     79A4 A022 
0049               
0050 79A6 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     79A8 7C16 
0051               
0052 79AA 0720  34         seto  @parm1                ; Do not turn screen off while
     79AC 2F20 
0053                                                   ; reloading color scheme
0054               
0055 79AE 06A0  32         bl    @pane.action.colorscheme.load
     79B0 7754 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 79B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 79B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 79B6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0176                       copy  "pane.cmdb.hide.asm"         ; Hide command buffer pane
**** **** ****     > pane.cmdb.hide.asm
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
0023 79B8 0649  14         dect  stack
0024 79BA C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 79BC C820  54         mov   @fb.scrrows.max,@fb.scrrows
     79BE A11C 
     79C0 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 79C2 C820  54         mov   @tv.error.visible,@tv.error.visible
     79C4 A028 
     79C6 A028 
0033 79C8 1302  14         jeq   !
0034 79CA 0620  34         dec   @fb.scrrows
     79CC A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 79CE 06A0  32 !       bl    @hchar
     79D0 27CC 
0039 79D2 1900                   byte pane.botrow-4,0,32,80*3
     79D4 20F0 
0040 79D6 1C00                   byte pane.botrow-1,0,32,80*2
     79D8 20A0 
0041 79DA FFFF                   data EOL
0042                       ;------------------------------------------------------
0043                       ; Adjust frame buffer size if ruler visible
0044                       ;------------------------------------------------------
0045 79DC C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     79DE A010 
     79E0 A010 
0046 79E2 1302  14         jeq   pane.cmdb.hide.rest
0047 79E4 0620  34         dec   @fb.scrrows
     79E6 A11A 
0048                       ;------------------------------------------------------
0049                       ; Hide command buffer pane (rest)
0050                       ;------------------------------------------------------
0051               pane.cmdb.hide.rest:
0052 79E8 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     79EA A304 
     79EC 832A 
0053 79EE 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     79F0 A302 
0054 79F2 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     79F4 A116 
0055 79F6 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     79F8 A022 
0056                       ;------------------------------------------------------
0057                       ; Reload current color scheme
0058                       ;------------------------------------------------------
0059 79FA 0720  34         seto  @parm1                ; Do not turn screen off while
     79FC 2F20 
0060                                                   ; reloading color scheme
0061               
0062 79FE 06A0  32         bl    @pane.action.colorscheme.load
     7A00 7754 
0063                                                   ; Reload color scheme
0064                                                   ; i  parm1 = Skip screen off if >FFFF
0065                       ;------------------------------------------------------
0066                       ; Show cursor again
0067                       ;------------------------------------------------------
0068 7A02 06A0  32         bl    @pane.cursor.blink
     7A04 78FE 
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               pane.cmdb.hide.exit:
0073 7A06 C2F9  30         mov   *stack+,r11           ; Pop r11
0074 7A08 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0177                       copy  "pane.cmdb.draw.asm"         ; Draw command buffer pane contents
**** **** ****     > pane.cmdb.draw.asm
0001               * FILE......: pane.cmdb.draw.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               ***************************************************************
0005               * pane.cmdb.draw
0006               * Draw Stevie Command Buffer in pane
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
0017 7A0A 0649  14         dect  stack
0018 7A0C C64B  30         mov   r11,*stack            ; Save return address
0019 7A0E 0649  14         dect  stack
0020 7A10 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7A12 0649  14         dect  stack
0022 7A14 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Command buffer header line
0025                       ;------------------------------------------------------
0026 7A16 C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     7A18 A31C 
     7A1A 2F20 
0027 7A1C 0204  20         li    tmp0,80
     7A1E 0050 
0028 7A20 C804  38         mov   tmp0,@parm2           ; Set requested length
     7A22 2F22 
0029 7A24 0204  20         li    tmp0,1
     7A26 0001 
0030 7A28 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A2A 2F24 
0031 7A2C 0204  20         li    tmp0,rambuf
     7A2E 2F6A 
0032 7A30 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A32 2F26 
0033               
0034 7A34 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A36 3302 
0035                                                   ; \ i  @parm1 = Pointer to string
0036                                                   ; | i  @parm2 = Requested length
0037                                                   ; | i  @parm3 = Fill character
0038                                                   ; | i  @parm4 = Pointer to buffer with
0039                                                   ; /             output string
0040               
0041 7A38 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7A3A A30E 
     7A3C 832A 
0042 7A3E C160  34         mov   @outparm1,tmp1        ; | Display pane header
     7A40 2F30 
0043 7A42 06A0  32         bl    @xutst0               ; /
     7A44 2424 
0044                       ;------------------------------------------------------
0045                       ; Check dialog id
0046                       ;------------------------------------------------------
0047 7A46 04E0  34         clr   @waux1                ; Default is show prompt
     7A48 833C 
0048               
0049 7A4A C120  34         mov   @cmdb.dialog,tmp0
     7A4C A31A 
0050 7A4E 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     7A50 0063 
0051 7A52 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0052 7A54 0720  34         seto  @waux1                ; /
     7A56 833C 
0053                       ;------------------------------------------------------
0054                       ; Show info message instead of prompt
0055                       ;------------------------------------------------------
0056 7A58 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     7A5A A31E 
0057 7A5C 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0058               
0059 7A5E C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     7A60 A31E 
     7A62 2F20 
0060 7A64 0204  20         li    tmp0,80
     7A66 0050 
0061 7A68 C804  38         mov   tmp0,@parm2           ; Set requested length
     7A6A 2F22 
0062 7A6C 0204  20         li    tmp0,32
     7A6E 0020 
0063 7A70 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A72 2F24 
0064 7A74 0204  20         li    tmp0,rambuf
     7A76 2F6A 
0065 7A78 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A7A 2F26 
0066               
0067 7A7C 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A7E 3302 
0068                                                   ; \ i  @parm1 = Pointer to string
0069                                                   ; | i  @parm2 = Requested length
0070                                                   ; | i  @parm3 = Fill character
0071                                                   ; | i  @parm4 = Pointer to buffer with
0072                                                   ; /             output string
0073               
0074 7A80 06A0  32         bl    @at
     7A82 26D2 
0075 7A84 1A00                   byte pane.botrow-3,0  ; Position cursor
0076               
0077 7A86 C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     7A88 2F30 
0078 7A8A 06A0  32         bl    @xutst0               ; /
     7A8C 2424 
0079                       ;------------------------------------------------------
0080                       ; Clear lines after prompt in command buffer
0081                       ;------------------------------------------------------
0082               pane.cmdb.draw.clear:
0083 7A8E 06A0  32         bl    @hchar
     7A90 27CC 
0084 7A92 1B00                   byte pane.botrow-2,0,32,80
     7A94 2050 
0085 7A96 FFFF                   data EOL              ; Remove key markers
0086                       ;------------------------------------------------------
0087                       ; Show key markers ?
0088                       ;------------------------------------------------------
0089 7A98 C120  34         mov   @cmdb.panmarkers,tmp0
     7A9A A322 
0090 7A9C 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0091                       ;------------------------------------------------------
0092                       ; Loop over key marker list
0093                       ;------------------------------------------------------
0094               pane.cmdb.draw.marker.loop:
0095 7A9E D174  28         movb  *tmp0+,tmp1           ; Get X position
0096 7AA0 0985  56         srl   tmp1,8                ; Right align
0097 7AA2 0285  22         ci    tmp1,>00ff            ; End of list reached?
     7AA4 00FF 
0098 7AA6 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0099               
0100 7AA8 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     7AAA 1B00 
0101                                                   ; y=bottom row - 3, x=(key marker position)
0102 7AAC C805  38         mov   tmp1,@wyx             ; Set cursor position
     7AAE 832A 
0103               
0104 7AB0 0649  14         dect  stack
0105 7AB2 C644  30         mov   tmp0,*stack           ; Push tmp0
0106               
0107 7AB4 06A0  32         bl    @putstr
     7AB6 2422 
0108 7AB8 35DC                   data txt.keymarker    ; Show key marker
0109               
0110 7ABA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111                       ;------------------------------------------------------
0112                       ; Show marker
0113                       ;------------------------------------------------------
0114 7ABC 10F0  14         jmp   pane.cmdb.draw.marker.loop
0115                                                   ; Next iteration
0116               
0117               
0118                       ;------------------------------------------------------
0119                       ; Display pane hint in command buffer
0120                       ;------------------------------------------------------
0121               pane.cmdb.draw.hint:
0122 7ABE 0204  20         li    tmp0,pane.botrow - 1  ; \
     7AC0 001C 
0123 7AC2 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0124 7AC4 C804  38         mov   tmp0,@parm1           ; Set parameter
     7AC6 2F20 
0125 7AC8 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7ACA A320 
     7ACC 2F22 
0126               
0127 7ACE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7AD0 768C 
0128                                                   ; \ i  parm1 = Pointer to string with hint
0129                                                   ; / i  parm2 = YX position
0130                       ;------------------------------------------------------
0131                       ; Display keys in status line
0132                       ;------------------------------------------------------
0133 7AD2 0204  20         li    tmp0,pane.botrow      ; \
     7AD4 001D 
0134 7AD6 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0135 7AD8 C804  38         mov   tmp0,@parm1           ; Set parameter
     7ADA 2F20 
0136 7ADC C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7ADE A324 
     7AE0 2F22 
0137               
0138 7AE2 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7AE4 768C 
0139                                                   ; \ i  parm1 = Pointer to string with hint
0140                                                   ; / i  parm2 = YX position
0141                       ;------------------------------------------------------
0142                       ; ALPHA-Lock key down?
0143                       ;------------------------------------------------------
0144 7AE6 20A0  38         coc   @wbit10,config
     7AE8 200C 
0145 7AEA 1306  14         jeq   pane.cmdb.draw.alpha.down
0146                       ;------------------------------------------------------
0147                       ; AlPHA-Lock is up
0148                       ;------------------------------------------------------
0149 7AEC 06A0  32         bl    @hchar
     7AEE 27CC 
0150 7AF0 1D4E                   byte pane.botrow,78,32,2
     7AF2 2002 
0151 7AF4 FFFF                   data eol
0152               
0153 7AF6 1004  14         jmp   pane.cmdb.draw.promptcmd
0154                       ;------------------------------------------------------
0155                       ; AlPHA-Lock is down
0156                       ;------------------------------------------------------
0157               pane.cmdb.draw.alpha.down:
0158 7AF8 06A0  32         bl    @putat
     7AFA 2446 
0159 7AFC 1D4E                   byte   pane.botrow,78
0160 7AFE 35D6                   data   txt.alpha.down
0161                       ;------------------------------------------------------
0162                       ; Command buffer content
0163                       ;------------------------------------------------------
0164               pane.cmdb.draw.promptcmd:
0165 7B00 C120  34         mov   @waux1,tmp0           ; Flag set?
     7B02 833C 
0166 7B04 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0167 7B06 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7B08 740A 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               pane.cmdb.draw.exit:
0172 7B0A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0173 7B0C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0174 7B0E C2F9  30         mov   *stack+,r11           ; Pop r11
0175 7B10 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.3765856
0178               
0179                       copy  "pane.topline.asm"           ; Top line
**** **** ****     > pane.topline.asm
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
0017 7B12 0649  14         dect  stack
0018 7B14 C64B  30         mov   r11,*stack            ; Save return address
0019 7B16 0649  14         dect  stack
0020 7B18 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7B1A 0649  14         dect  stack
0022 7B1C C660  46         mov   @wyx,*stack           ; Push cursor position
     7B1E 832A 
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 7B20 06A0  32         bl    @at
     7B22 26D2 
0028 7B24 0000                   byte 0,0              ; y=0, x=0
0029               
0030 7B26 C820  54         mov   @edb.filename.ptr,@parm1
     7B28 A212 
     7B2A 2F20 
0031                                                   ; Get string to display
0032 7B2C 0204  20         li    tmp0,47
     7B2E 002F 
0033 7B30 C804  38         mov   tmp0,@parm2           ; Set requested length
     7B32 2F22 
0034 7B34 0204  20         li    tmp0,32
     7B36 0020 
0035 7B38 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7B3A 2F24 
0036 7B3C 0204  20         li    tmp0,rambuf
     7B3E 2F6A 
0037 7B40 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7B42 2F26 
0038               
0039               
0040 7B44 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B46 3302 
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 7B48 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7B4A 2F30 
0048 7B4C 06A0  32         bl    @xutst0               ; /
     7B4E 2424 
0049                       ;------------------------------------------------------
0050                       ; Show M1 marker
0051                       ;------------------------------------------------------
0052 7B50 C120  34         mov   @edb.block.m1,tmp0    ; \
     7B52 A20C 
0053 7B54 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0054 7B56 1326  14         jeq   pane.topline.exit     ; /
0055               
0056 7B58 06A0  32         bl    @putat
     7B5A 2446 
0057 7B5C 0034                   byte 0,52
0058 7B5E 3542                   data txt.m1           ; Show M1 marker message
0059               
0060 7B60 C820  54         mov   @edb.block.m1,@parm1
     7B62 A20C 
     7B64 2F20 
0061 7B66 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B68 32D6 
0062                                                   ; \ i @parm1           = uint16
0063                                                   ; / o @unpacked.string = Output string
0064               
0065 7B6A 0204  20         li    tmp0,>0500
     7B6C 0500 
0066 7B6E D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B70 2F44 
0067               
0068 7B72 06A0  32         bl    @putat
     7B74 2446 
0069 7B76 0037                   byte 0,55
0070 7B78 2F44                   data unpacked.string  ; Show M1 value
0071                       ;------------------------------------------------------
0072                       ; Show M2 marker
0073                       ;------------------------------------------------------
0074 7B7A C120  34         mov   @edb.block.m2,tmp0    ; \
     7B7C A20E 
0075 7B7E 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0076 7B80 1311  14         jeq   pane.topline.exit     ; /
0077               
0078 7B82 06A0  32         bl    @putat
     7B84 2446 
0079 7B86 003E                   byte 0,62
0080 7B88 3546                   data txt.m2           ; Show M2 marker message
0081               
0082 7B8A C820  54         mov   @edb.block.m2,@parm1
     7B8C A20E 
     7B8E 2F20 
0083 7B90 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B92 32D6 
0084                                                   ; \ i @parm1           = uint16
0085                                                   ; / o @unpacked.string = Output string
0086               
0087 7B94 0204  20         li    tmp0,>0500
     7B96 0500 
0088 7B98 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B9A 2F44 
0089               
0090 7B9C 06A0  32         bl    @putat
     7B9E 2446 
0091 7BA0 0041                   byte 0,65
0092 7BA2 2F44                   data unpacked.string  ; Show M2 value
0093                       ;------------------------------------------------------
0094                       ; Exit
0095                       ;------------------------------------------------------
0096               pane.topline.exit:
0097 7BA4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7BA6 832A 
0098 7BA8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 7BAA C2F9  30         mov   *stack+,r11           ; Pop r11
0100 7BAC 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.3765856
0180                       copy  "pane.errline.asm"           ; Error line
**** **** ****     > pane.errline.asm
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
0022 7BAE 0649  14         dect  stack
0023 7BB0 C64B  30         mov   r11,*stack            ; Save return address
0024 7BB2 0649  14         dect  stack
0025 7BB4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7BB6 0649  14         dect  stack
0027 7BB8 C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7BBA 0205  20         li    tmp1,>00f6            ; White on dark red
     7BBC 00F6 
0030 7BBE C805  38         mov   tmp1,@parm1
     7BC0 2F20 
0031               
0032 7BC2 0205  20         li    tmp1,pane.botrow-1    ;
     7BC4 001C 
0033 7BC6 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BC8 2F22 
0034               
0035 7BCA 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BCC 791E 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7BCE 0204  20         li    tmp0,tv.error.msg
     7BD0 A02A 
0043 7BD2 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7BD4 2F20 
0044               
0045 7BD6 0204  20         li    tmp0,80
     7BD8 0050 
0046 7BDA C804  38         mov   tmp0,@parm2           ; Set requested length
     7BDC 2F22 
0047               
0048 7BDE 0204  20         li    tmp0,32
     7BE0 0020 
0049 7BE2 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7BE4 2F24 
0050               
0051 7BE6 0204  20         li    tmp0,rambuf
     7BE8 2F6A 
0052 7BEA C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7BEC 2F26 
0053               
0054 7BEE 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7BF0 3302 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7BF2 06A0  32         bl    @at
     7BF4 26D2 
0064 7BF6 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7BF8 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7BFA 2F30 
0067 7BFC 06A0  32         bl    @xutst0               ; /
     7BFE 2424 
0068               
0069 7C00 C120  34         mov   @fb.scrrows.max,tmp0
     7C02 A11C 
0070 7C04 0604  14         dec   tmp0
0071 7C06 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7C08 A11A 
0072               
0073 7C0A 0720  34         seto  @tv.error.visible     ; Error line is visible
     7C0C A028 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7C0E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7C10 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7C12 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7C14 045B  20         b     *r11                  ; Return to caller
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
0103 7C16 0649  14         dect  stack
0104 7C18 C64B  30         mov   r11,*stack            ; Save return address
0105 7C1A 0649  14         dect  stack
0106 7C1C C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7C1E 06A0  32         bl    @errline.init         ; Clear error line
     7C20 326A 
0111               
0112 7C22 C120  34         mov   @tv.color,tmp0        ; Get colors
     7C24 A018 
0113 7C26 0984  56         srl   tmp0,8                ; Right aligns
0114 7C28 C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7C2A 2F20 
0115               
0116               
0117 7C2C 0205  20         li    tmp1,pane.botrow-1    ;
     7C2E 001C 
0118 7C30 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7C32 2F22 
0119               
0120 7C34 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7C36 791E 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7C38 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7C3A A028 
0125 7C3C C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7C3E A11C 
     7C40 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7C42 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7C44 C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7C46 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0181                       copy  "pane.botline.asm"           ; Bottom line
**** **** ****     > pane.botline.asm
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
0017 7C48 0649  14         dect  stack
0018 7C4A C64B  30         mov   r11,*stack            ; Save return address
0019 7C4C 0649  14         dect  stack
0020 7C4E C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7C50 0649  14         dect  stack
0022 7C52 C660  46         mov   @wyx,*stack           ; Push cursor position
     7C54 832A 
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 7C56 C120  34         mov   @edb.block.m2,tmp0    ; \
     7C58 A20E 
0027 7C5A 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 7C5C 1305  14         jeq   pane.botline.show_keys
0030               
0031 7C5E 06A0  32         bl    @putat
     7C60 2446 
0032 7C62 1D00                   byte pane.botrow,0
0033 7C64 3552                   data txt.keys.block   ; Show block shortcuts
0034               
0035 7C66 1004  14         jmp   pane.botline.show_dirty
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 7C68 06A0  32         bl    @putat
     7C6A 2446 
0041 7C6C 1D00                   byte pane.botrow,0
0042 7C6E 354A                   data txt.keys.default ; Show default shortcuts
0043                       ;------------------------------------------------------
0044                       ; Show if text was changed in editor buffer
0045                       ;------------------------------------------------------
0046               pane.botline.show_dirty:
0047 7C70 C120  34         mov   @edb.dirty,tmp0
     7C72 A206 
0048 7C74 1305  14         jeq   pane.botline.nochange
0049                       ;------------------------------------------------------
0050                       ; Show "*"
0051                       ;------------------------------------------------------
0052 7C76 06A0  32         bl    @putat
     7C78 2446 
0053 7C7A 1D35                   byte pane.botrow,53   ; x=53
0054 7C7C 34AC                   data txt.star
0055 7C7E 1004  14         jmp   pane.botline.show_mode
0056                       ;------------------------------------------------------
0057                       ; Show " "
0058                       ;------------------------------------------------------
0059               pane.botline.nochange:
0060 7C80 06A0  32         bl    @putat
     7C82 2446 
0061 7C84 1D35                   byte pane.botrow,53   ; x=53
0062 7C86 35DE                   data txt.ws1          ; Single white space
0063                       ;------------------------------------------------------
0064                       ; Show text editing mode
0065                       ;------------------------------------------------------
0066               pane.botline.show_mode:
0067 7C88 C120  34         mov   @edb.insmode,tmp0
     7C8A A20A 
0068 7C8C 1605  14         jne   pane.botline.show_mode.insert
0069                       ;------------------------------------------------------
0070                       ; Overwrite mode
0071                       ;------------------------------------------------------
0072 7C8E 06A0  32         bl    @putat
     7C90 2446 
0073 7C92 1D37                   byte  pane.botrow,55
0074 7C94 34A4                   data  txt.ovrwrite
0075 7C96 1004  14         jmp   pane.botline.show_linecol
0076                       ;------------------------------------------------------
0077                       ; Insert mode
0078                       ;------------------------------------------------------
0079               pane.botline.show_mode.insert:
0080 7C98 06A0  32         bl    @putat
     7C9A 2446 
0081 7C9C 1D37                   byte  pane.botrow,55
0082 7C9E 34A8                   data  txt.insert
0083                       ;------------------------------------------------------
0084                       ; Show "line,column"
0085                       ;------------------------------------------------------
0086               pane.botline.show_linecol:
0087 7CA0 C820  54         mov   @fb.row,@parm1
     7CA2 A106 
     7CA4 2F20 
0088 7CA6 06A0  32         bl    @fb.row2line          ; Row to editor line
     7CA8 6A36 
0089                                                   ; \ i @fb.topline = Top line in frame buffer
0090                                                   ; | i @parm1      = Row in frame buffer
0091                                                   ; / o @outparm1   = Matching line in EB
0092               
0093 7CAA 05A0  34         inc   @outparm1             ; Add base 1
     7CAC 2F30 
0094                       ;------------------------------------------------------
0095                       ; Show line
0096                       ;------------------------------------------------------
0097 7CAE 06A0  32         bl    @putnum
     7CB0 2A5C 
0098 7CB2 1D3B                   byte  pane.botrow,59  ; YX
0099 7CB4 2F30                   data  outparm1,rambuf
     7CB6 2F6A 
0100 7CB8 3020                   byte  48              ; ASCII offset
0101                             byte  32              ; Padding character
0102                       ;------------------------------------------------------
0103                       ; Show comma
0104                       ;------------------------------------------------------
0105 7CBA 06A0  32         bl    @putat
     7CBC 2446 
0106 7CBE 1D40                   byte  pane.botrow,64
0107 7CC0 349C                   data  txt.delim
0108                       ;------------------------------------------------------
0109                       ; Show column
0110                       ;------------------------------------------------------
0111 7CC2 06A0  32         bl    @film
     7CC4 223A 
0112 7CC6 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7CC8 0020 
     7CCA 000C 
0113               
0114 7CCC C820  54         mov   @fb.column,@waux1
     7CCE A10C 
     7CD0 833C 
0115 7CD2 05A0  34         inc   @waux1                ; Offset 1
     7CD4 833C 
0116               
0117 7CD6 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7CD8 29DE 
0118 7CDA 833C                   data  waux1,rambuf
     7CDC 2F6A 
0119 7CDE 3020                   byte  48              ; ASCII offset
0120                             byte  32              ; Fill character
0121               
0122 7CE0 06A0  32         bl    @trimnum              ; Trim number to the left
     7CE2 2A36 
0123 7CE4 2F6A                   data  rambuf,rambuf+5,32
     7CE6 2F6F 
     7CE8 0020 
0124               
0125 7CEA 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7CEC 0600 
0126 7CEE D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7CF0 2F6F 
0127               
0128                       ;------------------------------------------------------
0129                       ; Decide if row length is to be shown
0130                       ;------------------------------------------------------
0131 7CF2 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7CF4 A10C 
0132 7CF6 0584  14         inc   tmp0                  ; /
0133 7CF8 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7CFA A108 
0134 7CFC 1101  14         jlt   pane.botline.show_linecol.linelen
0135 7CFE 102B  14         jmp   pane.botline.show_linecol.colstring
0136                                                   ; Yes, skip showing row length
0137                       ;------------------------------------------------------
0138                       ; Add ',' delimiter and length of line to string
0139                       ;------------------------------------------------------
0140               pane.botline.show_linecol.linelen:
0141 7D00 C120  34         mov   @fb.column,tmp0       ; \
     7D02 A10C 
0142 7D04 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7D06 2F71 
0143 7D08 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7D0A 0009 
0144 7D0C 1101  14         jlt   !                     ; | column.
0145 7D0E 0585  14         inc   tmp1                  ; /
0146               
0147 7D10 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7D12 2D00 
0148 7D14 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0149               
0150 7D16 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7D18 833C 
0151               
0152 7D1A 06A0  32         bl    @mknum
     7D1C 29DE 
0153 7D1E A108                   data  fb.row.length,rambuf
     7D20 2F6A 
0154 7D22 3020                   byte  48              ; ASCII offset
0155                             byte  32              ; Padding character
0156               
0157 7D24 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7D26 833C 
0158               
0159 7D28 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7D2A A108 
0160 7D2C 0284  22         ci    tmp0,10               ; /
     7D2E 000A 
0161 7D30 110B  14         jlt   pane.botline.show_line.1digit
0162                       ;------------------------------------------------------
0163                       ; Assert
0164                       ;------------------------------------------------------
0165 7D32 0284  22         ci    tmp0,80
     7D34 0050 
0166 7D36 1204  14         jle   pane.botline.show_line.2digits
0167                       ;------------------------------------------------------
0168                       ; Asserts failed
0169                       ;------------------------------------------------------
0170 7D38 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7D3A FFCE 
0171 7D3C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7D3E 2026 
0172                       ;------------------------------------------------------
0173                       ; Show length of line (2 digits)
0174                       ;------------------------------------------------------
0175               pane.botline.show_line.2digits:
0176 7D40 0204  20         li    tmp0,rambuf+3
     7D42 2F6D 
0177 7D44 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0178 7D46 1002  14         jmp   pane.botline.show_line.rest
0179                       ;------------------------------------------------------
0180                       ; Show length of line (1 digits)
0181                       ;------------------------------------------------------
0182               pane.botline.show_line.1digit:
0183 7D48 0204  20         li    tmp0,rambuf+4
     7D4A 2F6E 
0184               pane.botline.show_line.rest:
0185 7D4C DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0186 7D4E DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D50 2F6A 
0187 7D52 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D54 2F6A 
0188                       ;------------------------------------------------------
0189                       ; Show column string
0190                       ;------------------------------------------------------
0191               pane.botline.show_linecol.colstring:
0192 7D56 06A0  32         bl    @putat
     7D58 2446 
0193 7D5A 1D41                   byte pane.botrow,65
0194 7D5C 2F6F                   data rambuf+5         ; Show string
0195                       ;------------------------------------------------------
0196                       ; Show lines in buffer unless on last line in file
0197                       ;------------------------------------------------------
0198 7D5E C820  54         mov   @fb.row,@parm1
     7D60 A106 
     7D62 2F20 
0199 7D64 06A0  32         bl    @fb.row2line
     7D66 6A36 
0200 7D68 8820  54         c     @edb.lines,@outparm1
     7D6A A204 
     7D6C 2F30 
0201 7D6E 1605  14         jne   pane.botline.show_lines_in_buffer
0202               
0203 7D70 06A0  32         bl    @putat
     7D72 2446 
0204 7D74 1D48                   byte pane.botrow,72
0205 7D76 349E                   data txt.bottom
0206               
0207 7D78 1009  14         jmp   pane.botline.exit
0208                       ;------------------------------------------------------
0209                       ; Show lines in buffer
0210                       ;------------------------------------------------------
0211               pane.botline.show_lines_in_buffer:
0212 7D7A C820  54         mov   @edb.lines,@waux1
     7D7C A204 
     7D7E 833C 
0213               
0214 7D80 06A0  32         bl    @putnum
     7D82 2A5C 
0215 7D84 1D48                   byte pane.botrow,72   ; YX
0216 7D86 833C                   data waux1,rambuf
     7D88 2F6A 
0217 7D8A 3020                   byte 48
0218                             byte 32
0219                       ;------------------------------------------------------
0220                       ; Exit
0221                       ;------------------------------------------------------
0222               pane.botline.exit:
0223 7D8C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7D8E 832A 
0224 7D90 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0225 7D92 C2F9  30         mov   *stack+,r11           ; Pop r11
0226 7D94 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.3765856
0182                       ;-----------------------------------------------------------------------
0183                       ; Stubs using trampoline
0184                       ;-----------------------------------------------------------------------
0185                       copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "vdp.patterns.dump"
0007               * bank0 vec.1
0008               ********|*****|*********************|**************************
0009               vdp.patterns.dump:
0010 7D96 0649  14         dect  stack
0011 7D98 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7D9A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D9C 3008 
0016 7D9E 600A                   data bank5.rom        ; | i  p0 = bank address
0017 7DA0 6000                   data vec.1            ; | i  p1 = Vector with target address
0018 7DA2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7DA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7DA6 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7DA8 0649  14         dect  stack
0032 7DAA C64B  30         mov   r11,*stack            ; Save return address
0033 7DAC 0649  14         dect  stack
0034 7DAE C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7DB0 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DB2 3008 
0039 7DB4 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7DB6 6000                   data vec.1            ; | i  p1 = Vector with target address
0041 7DB8 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7DBA C120  34         mov   @outparm1,tmp0
     7DBC 2F30 
0046 7DBE 1304  14         jeq   fm.loadfile.exit
0047               
0048 7DC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7DC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7DC4 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7DC6 7E3A 
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7DC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7DCA C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7DCC 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.savefile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.savefile:
0065 7DCE 0649  14         dect  stack
0066 7DD0 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Call function in bank 2
0069                       ;------------------------------------------------------
0070 7DD2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DD4 3008 
0071 7DD6 6004                   data bank2.rom        ; | i  p0 = bank address
0072 7DD8 6002                   data vec.2            ; | i  p1 = Vector with target address
0073 7DDA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077 7DDC C2F9  30         mov   *stack+,r11           ; Pop r11
0078 7DDE 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               **************************************************************
0082               * Stub for "fm.browse.fname.suffix"
0083               * bank2 vec.3
0084               ********|*****|*********************|**************************
0085               fm.browse.fname.suffix:
0086 7DE0 0649  14         dect  stack
0087 7DE2 C64B  30         mov   r11,*stack            ; Save return address
0088                       ;------------------------------------------------------
0089                       ; Call function in bank 2
0090                       ;------------------------------------------------------
0091 7DE4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DE6 3008 
0092 7DE8 6004                   data bank2.rom        ; | i  p0 = bank address
0093 7DEA 6004                   data vec.3            ; | i  p1 = Vector with target address
0094 7DEC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098 7DEE C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7DF0 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               **************************************************************
0103               * Stub for "fm.fastmode"
0104               * bank2 vec.4
0105               ********|*****|*********************|**************************
0106               fm.fastmode:
0107 7DF2 0649  14         dect  stack
0108 7DF4 C64B  30         mov   r11,*stack            ; Save return address
0109                       ;------------------------------------------------------
0110                       ; Call function in bank 2
0111                       ;------------------------------------------------------
0112 7DF6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DF8 3008 
0113 7DFA 6004                   data bank2.rom        ; | i  p0 = bank address
0114 7DFC 6006                   data vec.4            ; | i  p1 = Vector with target address
0115 7DFE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119 7E00 C2F9  30         mov   *stack+,r11           ; Pop r11
0120 7E02 045B  20         b     *r11                  ; Return to caller
0121               
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * Stub for "About dialog"
0128               * bank3 vec.1
0129               ********|*****|*********************|**************************
0130               edkey.action.about:
0131 7E04 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E06 78E0 
0132                       ;------------------------------------------------------
0133                       ; Show dialog
0134                       ;------------------------------------------------------
0135 7E08 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E0A 3008 
0136 7E0C 6006                   data bank3.rom        ; | i  p0 = bank address
0137 7E0E 6000                   data vec.1            ; | i  p1 = Vector with target address
0138 7E10 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0139                       ;------------------------------------------------------
0140                       ; Exit
0141                       ;------------------------------------------------------
0142 7E12 0460  28         b     @edkey.action.cmdb.show
     7E14 6906 
0143                                                   ; Show dialog in CMDB pane
0144               
0145               
0146               ***************************************************************
0147               * Stub for "Load DV80 file"
0148               * bank3 vec.2
0149               ********|*****|*********************|**************************
0150               dialog.load:
0151 7E16 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E18 78E0 
0152                       ;------------------------------------------------------
0153                       ; Show dialog
0154                       ;------------------------------------------------------
0155 7E1A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E1C 3008 
0156 7E1E 6006                   data bank3.rom        ; | i  p0 = bank address
0157 7E20 6002                   data vec.2            ; | i  p1 = Vector with target address
0158 7E22 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0159                       ;------------------------------------------------------
0160                       ; Exit
0161                       ;------------------------------------------------------
0162 7E24 0460  28         b     @edkey.action.cmdb.show
     7E26 6906 
0163                                                   ; Show dialog in CMDB pane
0164               
0165               
0166               ***************************************************************
0167               * Stub for "Save DV80 file"
0168               * bank3 vec.3
0169               ********|*****|*********************|**************************
0170               dialog.save:
0171 7E28 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E2A 78E0 
0172                       ;------------------------------------------------------
0173                       ; Show dialog
0174                       ;------------------------------------------------------
0175 7E2C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E2E 3008 
0176 7E30 6006                   data bank3.rom        ; | i  p0 = bank address
0177 7E32 6004                   data vec.3            ; | i  p1 = Vector with target address
0178 7E34 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182 7E36 0460  28         b     @edkey.action.cmdb.show
     7E38 6906 
0183                                                   ; Show dialog in CMDB pane
0184               
0185               
0186               ***************************************************************
0187               * Stub for "Unsaved Changes"
0188               * bank3 vec.4
0189               ********|*****|*********************|**************************
0190               dialog.unsaved:
0191 7E3A 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7E3C A322 
0192 7E3E 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E40 78E0 
0193                       ;------------------------------------------------------
0194                       ; Show dialog
0195                       ;------------------------------------------------------
0196 7E42 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E44 3008 
0197 7E46 6006                   data bank3.rom        ; | i  p0 = bank address
0198 7E48 6006                   data vec.4            ; | i  p1 = Vector with target address
0199 7E4A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0200                       ;------------------------------------------------------
0201                       ; Exit
0202                       ;------------------------------------------------------
0203 7E4C 0460  28         b     @edkey.action.cmdb.show
     7E4E 6906 
0204                                                   ; Show dialog in CMDB pane
0205               
0206               ***************************************************************
0207               * Stub for Dialog "File dialog"
0208               * bank3 vec.5
0209               ********|*****|*********************|**************************
0210               dialog.file:
0211 7E50 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E52 78E0 
0212                       ;------------------------------------------------------
0213                       ; Show dialog
0214                       ;------------------------------------------------------
0215 7E54 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E56 3008 
0216 7E58 6006                   data bank3.rom        ; | i  p0 = bank address
0217 7E5A 6008                   data vec.5            ; | i  p1 = Vector with target address
0218 7E5C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0219                       ;------------------------------------------------------
0220                       ; Exit
0221                       ;------------------------------------------------------
0222 7E5E 0460  28         b     @edkey.action.cmdb.show
     7E60 6906 
0223                                                   ; Show dialog in CMDB pane
0224               
0225               
0226               ***************************************************************
0227               * Stub for Dialog "Stevie Menu dialog"
0228               * bank3 vec.6
0229               ********|*****|*********************|**************************
0230               dialog.menu:
0231                       ;------------------------------------------------------
0232                       ; Check if block mode is active
0233                       ;------------------------------------------------------
0234 7E62 C120  34         mov   @edb.block.m2,tmp0    ; \
     7E64 A20E 
0235 7E66 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0236                                                   ; /
0237 7E68 1302  14         jeq   !                     : Block mode inactive, show dialog
0238                       ;------------------------------------------------------
0239                       ; Special treatment for block mode
0240                       ;------------------------------------------------------
0241 7E6A 0460  28         b     @edkey.action.block.reset
     7E6C 679A 
0242                                                   ; Reset block mode
0243                       ;------------------------------------------------------
0244                       ; Show dialog
0245                       ;------------------------------------------------------
0246 7E6E 06A0  32 !       bl    @rom.farjump          ; \ Trampoline jump to bank
     7E70 3008 
0247 7E72 6006                   data bank3.rom        ; | i  p0 = bank address
0248 7E74 600A                   data vec.6            ; | i  p1 = Vector with target address
0249 7E76 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0250                       ;------------------------------------------------------
0251                       ; Exit
0252                       ;------------------------------------------------------
0253 7E78 0460  28         b     @edkey.action.cmdb.show
     7E7A 6906 
0254                                                   ; Show dialog in CMDB pane
0255               
0256               
0257               ***************************************************************
0258               * Stub for "fb.tab.next"
0259               * bank4 vec.1
0260               ********|*****|*********************|**************************
0261               fb.tab.next:
0262 7E7C 0649  14         dect  stack
0263 7E7E C64B  30         mov   r11,*stack            ; Save return address
0264                       ;------------------------------------------------------
0265                       ; Put cursor on next tab position
0266                       ;------------------------------------------------------
0267 7E80 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E82 3008 
0268 7E84 6008                   data bank4.rom        ; | i  p0 = bank address
0269 7E86 6000                   data vec.1            ; | i  p1 = Vector with target address
0270 7E88 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0271                       ;------------------------------------------------------
0272                       ; Exit
0273                       ;------------------------------------------------------
0274 7E8A C2F9  30         mov   *stack+,r11           ; Pop r11
0275 7E8C 045B  20         b     *r11                  ; Return to caller
0276               
0277               
0278               ***************************************************************
0279               * Stub for "fb.ruler.init"
0280               * bank4 vec.2
0281               ********|*****|*********************|**************************
0282               fb.ruler.init:
0283 7E8E 0649  14         dect  stack
0284 7E90 C64B  30         mov   r11,*stack            ; Save return address
0285                       ;------------------------------------------------------
0286                       ; Setup ruler in memory
0287                       ;------------------------------------------------------
0288 7E92 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E94 3008 
0289 7E96 6008                   data bank4.rom        ; | i  p0 = bank address
0290 7E98 6002                   data vec.2            ; | i  p1 = Vector with target address
0291 7E9A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0292                       ;------------------------------------------------------
0293                       ; Exit
0294                       ;------------------------------------------------------
0295 7E9C C2F9  30         mov   *stack+,r11           ; Pop r11
0296 7E9E 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               ***************************************************************
0300               * Stub for "fb.colorlines"
0301               * bank4 vec.3
0302               ********|*****|*********************|**************************
0303               fb.colorlines:
0304 7EA0 0649  14         dect  stack
0305 7EA2 C64B  30         mov   r11,*stack            ; Save return address
0306                       ;------------------------------------------------------
0307                       ; Colorize frame buffer content
0308                       ;------------------------------------------------------
0309 7EA4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7EA6 3008 
0310 7EA8 6008                   data bank4.rom        ; | i  p0 = bank address
0311 7EAA 6004                   data vec.3            ; | i  p1 = Vector with target address
0312 7EAC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0313                       ;------------------------------------------------------
0314                       ; Exit
0315                       ;------------------------------------------------------
0316 7EAE C2F9  30         mov   *stack+,r11           ; Pop r11
0317 7EB0 045B  20         b     *r11                  ; Return to caller
0318               
0319               
0320               ***************************************************************
0321               * Stub for "fb.vdpdump"
0322               * bank4 vec.4
0323               ********|*****|*********************|**************************
0324               fb.vdpdump:
0325 7EB2 0649  14         dect  stack
0326 7EB4 C64B  30         mov   r11,*stack            ; Save return address
0327                       ;------------------------------------------------------
0328                       ; Colorize frame buffer content
0329                       ;------------------------------------------------------
0330 7EB6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7EB8 3008 
0331 7EBA 6008                   data bank4.rom        ; | i  p0 = bank address
0332 7EBC 6006                   data vec.4            ; | i  p1 = Vector with target address
0333 7EBE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337 7EC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0338 7EC2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.3765856
0186                       ;-----------------------------------------------------------------------
0187                       ; Program data
0188                       ;-----------------------------------------------------------------------
0189                       copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
**** **** ****     > data.keymap.actions.asm
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
0011 7EC4 0D00             byte  key.enter, pane.focus.fb
0012 7EC6 6626             data  edkey.action.enter
0013               
0014 7EC8 0800             byte  key.fctn.s, pane.focus.fb
0015 7ECA 6190             data  edkey.action.left
0016               
0017 7ECC 0900             byte  key.fctn.d, pane.focus.fb
0018 7ECE 61AA             data  edkey.action.right
0019               
0020 7ED0 0B00             byte  key.fctn.e, pane.focus.fb
0021 7ED2 62BA             data  edkey.action.up
0022               
0023 7ED4 0A00             byte  key.fctn.x, pane.focus.fb
0024 7ED6 6314             data  edkey.action.down
0025               
0026 7ED8 BF00             byte  key.fctn.h, pane.focus.fb
0027 7EDA 61C6             data  edkey.action.home
0028               
0029 7EDC C000             byte  key.fctn.j, pane.focus.fb
0030 7EDE 6208             data  edkey.action.pword
0031               
0032 7EE0 C100             byte  key.fctn.k, pane.focus.fb
0033 7EE2 625A             data  edkey.action.nword
0034               
0035 7EE4 C200             byte  key.fctn.l, pane.focus.fb
0036 7EE6 61E6             data  edkey.action.end
0037               
0038 7EE8 0C00             byte  key.fctn.6, pane.focus.fb
0039 7EEA 631C             data  edkey.action.ppage
0040               
0041 7EEC 0200             byte  key.fctn.4, pane.focus.fb
0042 7EEE 6358             data  edkey.action.npage
0043               
0044 7EF0 8500             byte  key.ctrl.e, pane.focus.fb
0045 7EF2 631C             data  edkey.action.ppage
0046               
0047 7EF4 9800             byte  key.ctrl.x, pane.focus.fb
0048 7EF6 6358             data  edkey.action.npage
0049               
0050 7EF8 9400             byte  key.ctrl.t, pane.focus.fb
0051 7EFA 6392             data  edkey.action.top
0052               
0053 7EFC 8200             byte  key.ctrl.b, pane.focus.fb
0054 7EFE 63AE             data  edkey.action.bot
0055                       ;-------------------------------------------------------
0056                       ; Modifier keys - Delete
0057                       ;-------------------------------------------------------
0058 7F00 0300             byte  key.fctn.1, pane.focus.fb
0059 7F02 6420             data  edkey.action.del_char
0060               
0061 7F04 0700             byte  key.fctn.3, pane.focus.fb
0062 7F06 64D2             data  edkey.action.del_line
0063               
0064 7F08 0200             byte  key.fctn.4, pane.focus.fb
0065 7F0A 649E             data  edkey.action.del_eol
0066                       ;-------------------------------------------------------
0067                       ; Modifier keys - Insert
0068                       ;-------------------------------------------------------
0069 7F0C 0400             byte  key.fctn.2, pane.focus.fb
0070 7F0E 6534             data  edkey.action.ins_char.ws
0071               
0072 7F10 B900             byte  key.fctn.dot, pane.focus.fb
0073 7F12 669E             data  edkey.action.ins_onoff
0074               
0075 7F14 0100             byte  key.fctn.7, pane.focus.fb
0076 7F16 6858             data  edkey.action.fb.tab.next
0077               
0078 7F18 0600             byte  key.fctn.8, pane.focus.fb
0079 7F1A 65B2             data  edkey.action.ins_line
0080                       ;-------------------------------------------------------
0081                       ; Block marking/modifier
0082                       ;-------------------------------------------------------
0083 7F1C 9600             byte  key.ctrl.v, pane.focus.fb
0084 7F1E 6792             data  edkey.action.block.mark
0085               
0086 7F20 8300             byte  key.ctrl.c, pane.focus.fb
0087 7F22 67A6             data  edkey.action.block.copy
0088               
0089 7F24 8400             byte  key.ctrl.d, pane.focus.fb
0090 7F26 67E2             data  edkey.action.block.delete
0091               
0092 7F28 8D00             byte  key.ctrl.m, pane.focus.fb
0093 7F2A 680C             data  edkey.action.block.move
0094               
0095 7F2C 8700             byte  key.ctrl.g, pane.focus.fb
0096 7F2E 683E             data  edkey.action.block.goto.m1
0097                       ;-------------------------------------------------------
0098                       ; Other action keys
0099                       ;-------------------------------------------------------
0100 7F30 0500             byte  key.fctn.plus, pane.focus.fb
0101 7F32 6718             data  edkey.action.quit
0102               
0103 7F34 9100             byte  key.ctrl.q, pane.focus.fb
0104 7F36 6718             data  edkey.action.quit
0105               
0106 7F38 9500             byte  key.ctrl.u, pane.focus.fb
0107 7F3A 6726             data  edkey.action.toggle.ruler
0108               
0109 7F3C 9A00             byte  key.ctrl.z, pane.focus.fb
0110 7F3E 76F6             data  pane.action.colorscheme.cycle
0111               
0112 7F40 8000             byte  key.ctrl.comma, pane.focus.fb
0113 7F42 674C             data  edkey.action.fb.fname.dec.load
0114               
0115 7F44 9B00             byte  key.ctrl.dot, pane.focus.fb
0116 7F46 6758             data  edkey.action.fb.fname.inc.load
0117                       ;-------------------------------------------------------
0118                       ; Dialog keys
0119                       ;-------------------------------------------------------
0120 7F48 8800             byte  key.ctrl.h, pane.focus.fb
0121 7F4A 7E04             data  edkey.action.about
0122               
0123 7F4C 8600             byte  key.ctrl.f, pane.focus.fb
0124 7F4E 7E50             data  dialog.file
0125               
0126 7F50 9300             byte  key.ctrl.s, pane.focus.fb
0127 7F52 7E28             data  dialog.save
0128               
0129 7F54 8F00             byte  key.ctrl.o, pane.focus.fb
0130 7F56 7E16             data  dialog.load
0131               
0132                       ;
0133                       ; FCTN-9 has multipe purposes, if block mode is on it
0134                       ; resets the block, otherwise show Stevie menu dialog.
0135                       ;
0136 7F58 0F00             byte  key.fctn.9, pane.focus.fb
0137 7F5A 7E62             data  dialog.menu
0138                       ;-------------------------------------------------------
0139                       ; End of list
0140                       ;-------------------------------------------------------
0141 7F5C FFFF             data  EOL                           ; EOL
0142               
0143               
0144               
0145               *---------------------------------------------------------------
0146               * Action keys mapping table: Command Buffer (CMDB)
0147               *---------------------------------------------------------------
0148               keymap_actions.cmdb:
0149                       ;-------------------------------------------------------
0150                       ; Dialog: Stevie Menu
0151                       ;-------------------------------------------------------
0152 7F5E 4664             byte  key.uc.f, id.dialog.menu
0153 7F60 7E50             data  dialog.file
0154               
0155 7F62 4864             byte  key.uc.h, id.dialog.menu
0156 7F64 7E04             data  edkey.action.about
0157               
0158 7F66 5164             byte  key.uc.q, id.dialog.menu
0159 7F68 6718             data  edkey.action.quit
0160                       ;-------------------------------------------------------
0161                       ; Dialog: File
0162                       ;-------------------------------------------------------
0163 7F6A 4E68             byte  key.uc.n, id.dialog.file
0164 7F6C 6918             data  edkey.action.cmdb.file.new
0165               
0166 7F6E 5368             byte  key.uc.s, id.dialog.file
0167 7F70 7E28             data  dialog.save
0168               
0169 7F72 4F68             byte  key.uc.o, id.dialog.file
0170 7F74 7E16             data  dialog.load
0171                       ;-------------------------------------------------------
0172                       ; Dialog: Open DV80 file
0173                       ;-------------------------------------------------------
0174 7F76 0E0A             byte  key.fctn.5, id.dialog.load
0175 7F78 6A0A             data  edkey.action.cmdb.fastmode.toggle
0176               
0177 7F7A 0D0A             byte  key.enter, id.dialog.load
0178 7F7C 693C             data  edkey.action.cmdb.load
0179                       ;-------------------------------------------------------
0180                       ; Dialog: Unsaved changes
0181                       ;-------------------------------------------------------
0182 7F7E 0C65             byte  key.fctn.6, id.dialog.unsaved
0183 7F80 69E0             data  edkey.action.cmdb.proceed
0184               
0185 7F82 0D65             byte  key.enter, id.dialog.unsaved
0186 7F84 7E28             data  dialog.save
0187                       ;-------------------------------------------------------
0188                       ; Dialog: Save DV80 file
0189                       ;-------------------------------------------------------
0190 7F86 0D0B             byte  key.enter, id.dialog.save
0191 7F88 6980             data  edkey.action.cmdb.save
0192               
0193 7F8A 0D0C             byte  key.enter, id.dialog.saveblock
0194 7F8C 6980             data  edkey.action.cmdb.save
0195                       ;-------------------------------------------------------
0196                       ; Dialog: About
0197                       ;-------------------------------------------------------
0198 7F8E 0F67             byte  key.fctn.9, id.dialog.about
0199 7F90 6A16             data  edkey.action.cmdb.close.about
0200                       ;-------------------------------------------------------
0201                       ; Movement keys
0202                       ;-------------------------------------------------------
0203 7F92 0801             byte  key.fctn.s, pane.focus.cmdb
0204 7F94 6866             data  edkey.action.cmdb.left
0205               
0206 7F96 0901             byte  key.fctn.d, pane.focus.cmdb
0207 7F98 6878             data  edkey.action.cmdb.right
0208               
0209 7F9A BF01             byte  key.fctn.h, pane.focus.cmdb
0210 7F9C 6890             data  edkey.action.cmdb.home
0211               
0212 7F9E C201             byte  key.fctn.l, pane.focus.cmdb
0213 7FA0 68A4             data  edkey.action.cmdb.end
0214                       ;-------------------------------------------------------
0215                       ; Modifier keys
0216                       ;-------------------------------------------------------
0217 7FA2 0701             byte  key.fctn.3, pane.focus.cmdb
0218 7FA4 68BC             data  edkey.action.cmdb.clear
0219                       ;-------------------------------------------------------
0220                       ; Other action keys
0221                       ;-------------------------------------------------------
0222 7FA6 0F01             byte  key.fctn.9, pane.focus.cmdb
0223 7FA8 6A22             data  edkey.action.cmdb.close.dialog
0224               
0225 7FAA 0501             byte  key.fctn.plus, pane.focus.cmdb
0226 7FAC 6718             data  edkey.action.quit
0227               
0228 7FAE 9A01             byte  key.ctrl.z, pane.focus.cmdb
0229 7FB0 76F6             data  pane.action.colorscheme.cycle
0230                       ;------------------------------------------------------
0231                       ; End of list
0232                       ;-------------------------------------------------------
0233 7FB2 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.3765856
0190                       ;-----------------------------------------------------------------------
0191                       ; Bank specific vector table
0192                       ;-----------------------------------------------------------------------
0196 7FB4 7FB4                   data $                ; Bank 1 ROM size OK.
0198               
0199               *--------------------------------------------------------------
0200               * Video mode configuration
0201               *--------------------------------------------------------------
0202      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0203      0004     spfbck  equ   >04                   ; Screen background color.
0204      33A6     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0205      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0206      0050     colrow  equ   80                    ; Columns per row
0207      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0208      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0209      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0210      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

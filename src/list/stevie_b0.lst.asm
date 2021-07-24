XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.asm.1384146
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 210724-1384146
0010               *
0011               * Bank 0 "Jill"
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
**** **** ****     > stevie_b0.asm.1384146
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
**** **** ****     > stevie_b0.asm.1384146
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
**** **** ****     > stevie_b0.asm.1384146
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 0
0025               ********|*****|*********************|**************************
0026      6000     bankid  equ   bank0.rom             ; Set bank identifier to current bank
0027                       aorg  >6000
0028                       save  >6000,>7fff           ; Save bank
0029                       copy  "rom.header.asm"      ; Include cartridge header
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
0045 6011 ....             text  'STEVIE 1.1P'
0046                       even
0047               
0049               
**** **** ****     > stevie_b0.asm.1384146
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6040
0035               kickstart.step1:
0036 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0037               ***************************************************************
0038               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0039               ********|*****|*********************|**************************
0040               kickstart.step2:
0041 6044 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
     6046 608A 
0042 6048 0201  20         li    r1,>2000
     604A 2000 
0043 604C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     604E 0100 
0044 6050 06A0  32         bl    @kickstart.copy       ; Copy memory
     6052 6074 
0045               ***************************************************************
0046               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0047               ********|*****|*********************|**************************
0048               kickstart.step3:
0049 6054 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
     6056 70BE 
0050 6058 0201  20         li    r1,>3000
     605A 3000 
0051 605C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     605E 0100 
0052 6060 06A0  32         bl    @kickstart.copy       ; Copy memory
     6062 6074 
0053               ***************************************************************
0054               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0055               ********|*****|*********************|**************************
0056               kickstart.step4:
0057 6064 0460  28         b     @runlib               ; Start spectra2 library
     6066 2E4C 
0058                       ;------------------------------------------------------
0059                       ; Assert. Should not get here! Crash and burn!
0060                       ;------------------------------------------------------
0061 6068 0200  20         li    r0,$                  ; Current location
     606A 6068 
0062 606C C800  38         mov   r0,@>ffce             ; \ Save caller address
     606E FFCE 
0063 6070 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6072 2026 
0064               ***************************************************************
0065               * Step 5: Handover from SP2 to Stevie "main" in low MEMEXP
0066               ********|*****|*********************|**************************
0067                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0068               
0069               ***************************************************************
0070               * Copy routine
0071               ********|*****|*********************|**************************
0072               kickstart.copy:
0073                       ;------------------------------------------------------
0074                       ; Copy memory to destination
0075                       ; r0 = Source CPU address
0076                       ; r1 = Target CPU address
0077                       ; r2 = Bytes to copy/16
0078                       ;------------------------------------------------------
0079 6074 CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0080 6076 CC70  46         mov   *r0+,*r1+             ; Copy word 2
0081 6078 CC70  46         mov   *r0+,*r1+             ; Copy word 3
0082 607A CC70  46         mov   *r0+,*r1+             ; Copy word 4
0083 607C CC70  46         mov   *r0+,*r1+             ; Copy word 5
0084 607E CC70  46         mov   *r0+,*r1+             ; Copy word 6
0085 6080 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0086 6082 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0087 6084 0602  14         dec   r2
0088 6086 16F6  14         jne   -!                    ; Loop until done
0089 6088 045B  20         b     *r11                  ; Return to caller
0090               
0091               
0092               ***************************************************************
0093               * Code data: Relocated code SP2 >2000 - >2eff (3840 bytes max)
0094               ********|*****|*********************|**************************
0095               reloc.sp2:
0096                       xorg  >2000                 ; Relocate SP2 code to >2000
0097                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0012 608A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 608C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 608E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 6090 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 6092 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6094 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6096 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6098 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 609A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 609C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 609E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 60A0 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 60A2 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 60A4 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 60A6 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 60A8 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 60AA 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 60AC FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 60AE D000     w$d000  data  >d000                 ; >d000
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
0038 60B0 022B  22         ai    r11,-4                ; Remove opcode offset
     60B2 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60B4 C800  38         mov   r0,@>ffe0
     60B6 FFE0 
0043 60B8 C801  38         mov   r1,@>ffe2
     60BA FFE2 
0044 60BC C802  38         mov   r2,@>ffe4
     60BE FFE4 
0045 60C0 C803  38         mov   r3,@>ffe6
     60C2 FFE6 
0046 60C4 C804  38         mov   r4,@>ffe8
     60C6 FFE8 
0047 60C8 C805  38         mov   r5,@>ffea
     60CA FFEA 
0048 60CC C806  38         mov   r6,@>ffec
     60CE FFEC 
0049 60D0 C807  38         mov   r7,@>ffee
     60D2 FFEE 
0050 60D4 C808  38         mov   r8,@>fff0
     60D6 FFF0 
0051 60D8 C809  38         mov   r9,@>fff2
     60DA FFF2 
0052 60DC C80A  38         mov   r10,@>fff4
     60DE FFF4 
0053 60E0 C80B  38         mov   r11,@>fff6
     60E2 FFF6 
0054 60E4 C80C  38         mov   r12,@>fff8
     60E6 FFF8 
0055 60E8 C80D  38         mov   r13,@>fffa
     60EA FFFA 
0056 60EC C80E  38         mov   r14,@>fffc
     60EE FFFC 
0057 60F0 C80F  38         mov   r15,@>ffff
     60F2 FFFF 
0058 60F4 02A0  12         stwp  r0
0059 60F6 C800  38         mov   r0,@>ffdc
     60F8 FFDC 
0060 60FA 02C0  12         stst  r0
0061 60FC C800  38         mov   r0,@>ffde
     60FE FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 6100 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6102 8300 
0067 6104 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6106 8302 
0068 6108 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     610A 4A4A 
0069 610C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     610E 2E50 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 6110 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6112 22FC 
0078 6114 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 6116 06A0  32         bl    @ldfnt
     6118 2364 
0081 611A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     611C 000C 
0082               
0083 611E 06A0  32         bl    @filv
     6120 2292 
0084 6122 0380                   data >0380,>f0,32*24  ; Load color table
     6124 00F0 
     6126 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 6128 06A0  32         bl    @putat                ; Show crash message
     612A 2446 
0089 612C 0000                   data >0000,cpu.crash.msg.crashed
     612E 2178 
0090               
0091 6130 06A0  32         bl    @puthex               ; Put hex value on screen
     6132 29D4 
0092 6134 0015                   byte 0,21             ; \ i  p0 = YX position
0093 6136 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 6138 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 613A 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 613C 06A0  32         bl    @putat                ; Show caller message
     613E 2446 
0101 6140 0100                   data >0100,cpu.crash.msg.caller
     6142 218E 
0102               
0103 6144 06A0  32         bl    @puthex               ; Put hex value on screen
     6146 29D4 
0104 6148 0115                   byte 1,21             ; \ i  p0 = YX position
0105 614A FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 614C 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 614E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 6150 06A0  32         bl    @putat
     6152 2446 
0113 6154 0300                   byte 3,0
0114 6156 21AA                   data cpu.crash.msg.wp
0115 6158 06A0  32         bl    @putat
     615A 2446 
0116 615C 0400                   byte 4,0
0117 615E 21B0                   data cpu.crash.msg.st
0118 6160 06A0  32         bl    @putat
     6162 2446 
0119 6164 1600                   byte 22,0
0120 6166 21B6                   data cpu.crash.msg.source
0121 6168 06A0  32         bl    @putat
     616A 2446 
0122 616C 1700                   byte 23,0
0123 616E 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 6170 06A0  32         bl    @at                   ; Put cursor at YX
     6172 26D2 
0128 6174 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6176 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6178 FFDC 
0132 617A 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 617C C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 617E 0649  14         dect  stack
0138 6180 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 6182 0649  14         dect  stack
0140 6184 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6186 0649  14         dect  stack
0142 6188 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 618A C046  18         mov   tmp2,r1               ; Save register number
0148 618C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     618E 0001 
0149 6190 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 6192 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 6194 06A0  32         bl    @mknum
     6196 29DE 
0154 6198 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 619A 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 619C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 619E 06A0  32         bl    @setx                 ; Set cursor X position
     61A0 26E8 
0160 61A2 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 61A4 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A6 2422 
0164 61A8 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 61AA 06A0  32         bl    @setx                 ; Set cursor X position
     61AC 26E8 
0168 61AE 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 61B0 0281  22         ci    r1,10
     61B2 000A 
0172 61B4 1102  14         jlt   !
0173 61B6 0620  34         dec   @wyx                  ; x=x-1
     61B8 832A 
0174               
0175 61BA 06A0  32 !       bl    @putstr
     61BC 2422 
0176 61BE 21A4                   data cpu.crash.msg.r
0177               
0178 61C0 06A0  32         bl    @mknum
     61C2 29DE 
0179 61C4 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 61C6 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 61C8 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 61CA 06A0  32         bl    @mkhex                ; Convert hex word to string
     61CC 2950 
0188 61CE 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 61D0 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 61D2 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 61D4 06A0  32         bl    @setx                 ; Set cursor X position
     61D6 26E8 
0194 61D8 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 61DA 06A0  32         bl    @putstr               ; Put '  >'
     61DC 2422 
0198 61DE 21A6                   data cpu.crash.msg.marker
0199               
0200 61E0 06A0  32         bl    @setx                 ; Set cursor X position
     61E2 26E8 
0201 61E4 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61E6 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61E8 2422 
0205 61EA 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61EC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61EE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61F0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61F2 06A0  32         bl    @down                 ; y=y+1
     61F4 26D8 
0213               
0214 61F6 0586  14         inc   tmp2
0215 61F8 0286  22         ci    tmp2,17
     61FA 0011 
0216 61FC 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61FE 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     6200 2D4E 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 6202 1553             byte  21
0225 6203 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 6218 1543             byte  21
0230 6219 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 622E 0152             byte  1
0235 622F ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 6230 0320             byte  3
0240 6231 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 6234 042A             byte  4
0245 6235 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 623A 042A             byte  4
0250 623B ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 6240 1B53             byte  27
0255 6241 ....             text  'Source    stevie_b0.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 625C 1842             byte  24
0260 625D ....             text  'Build-ID  210724-1384146'
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
0007 6276 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6278 000E 
     627A 0106 
     627C 0204 
     627E 0020 
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
0032 6280 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6282 000E 
     6284 0106 
     6286 00F4 
     6288 0028 
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
0058 628A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     628C 003F 
     628E 0240 
     6290 03F4 
     6292 0050 
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
0084 6294 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6296 003F 
     6298 0240 
     629A 03F4 
     629C 0050 
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
0013 629E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 62A0 16FD             data  >16fd                 ; |         jne   mcloop
0015 62A2 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 62A4 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 62A6 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 62A8 0201  20         li    r1,mccode             ; Machinecode to patch
     62AA 2214 
0037 62AC 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     62AE 8322 
0038 62B0 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62B2 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62B4 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62B6 045B  20         b     *r11                  ; Return to caller
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
0056 62B8 C0F9  30 popr3   mov   *stack+,r3
0057 62BA C0B9  30 popr2   mov   *stack+,r2
0058 62BC C079  30 popr1   mov   *stack+,r1
0059 62BE C039  30 popr0   mov   *stack+,r0
0060 62C0 C2F9  30 poprt   mov   *stack+,r11
0061 62C2 045B  20         b     *r11
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
0085 62C4 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 62C6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 62C8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 62CA C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 62CC 1604  14         jne   filchk                ; No, continue checking
0093               
0094 62CE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62D0 FFCE 
0095 62D2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62D4 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62D6 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62D8 830B 
     62DA 830A 
0100               
0101 62DC 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62DE 0001 
0102 62E0 1602  14         jne   filchk2
0103 62E2 DD05  32         movb  tmp1,*tmp0+
0104 62E4 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62E6 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62E8 0002 
0109 62EA 1603  14         jne   filchk3
0110 62EC DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62EE DD05  32         movb  tmp1,*tmp0+
0112 62F0 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62F2 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62F4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62F6 0001 
0118 62F8 1305  14         jeq   fil16b
0119 62FA DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62FC 0606  14         dec   tmp2
0121 62FE 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6300 0002 
0122 6302 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 6304 C1C6  18 fil16b  mov   tmp2,tmp3
0127 6306 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6308 0001 
0128 630A 1301  14         jeq   dofill
0129 630C 0606  14         dec   tmp2                  ; Make TMP2 even
0130 630E CD05  34 dofill  mov   tmp1,*tmp0+
0131 6310 0646  14         dect  tmp2
0132 6312 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 6314 C1C7  18         mov   tmp3,tmp3
0137 6316 1301  14         jeq   fil.exit
0138 6318 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 631A 045B  20         b     *r11
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
0159 631C C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 631E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 6320 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 6322 0264  22 xfilv   ori   tmp0,>4000
     6324 4000 
0166 6326 06C4  14         swpb  tmp0
0167 6328 D804  38         movb  tmp0,@vdpa
     632A 8C02 
0168 632C 06C4  14         swpb  tmp0
0169 632E D804  38         movb  tmp0,@vdpa
     6330 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 6332 020F  20         li    r15,vdpw              ; Set VDP write address
     6334 8C00 
0174 6336 06C5  14         swpb  tmp1
0175 6338 C820  54         mov   @filzz,@mcloop        ; Setup move command
     633A 22B8 
     633C 8320 
0176 633E 0460  28         b     @mcloop               ; Write data to VDP
     6340 8320 
0177               *--------------------------------------------------------------
0181 6342 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6344 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6346 4000 
0202 6348 06C4  14 vdra    swpb  tmp0
0203 634A D804  38         movb  tmp0,@vdpa
     634C 8C02 
0204 634E 06C4  14         swpb  tmp0
0205 6350 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6352 8C02 
0206 6354 045B  20         b     *r11                  ; Exit
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
0217 6356 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6358 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 635A 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     635C 4000 
0223 635E 06C4  14         swpb  tmp0                  ; \
0224 6360 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6362 8C02 
0225 6364 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6366 D804  38         movb  tmp0,@vdpa            ; /
     6368 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 636A 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 636C D7C5  30         movb  tmp1,*r15             ; Write byte
0232 636E 045B  20         b     *r11                  ; Exit
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
0251 6370 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6372 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6374 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6376 8C02 
0257 6378 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 637A D804  38         movb  tmp0,@vdpa            ; /
     637C 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 637E D120  34         movb  @vdpr,tmp0            ; Read byte
     6380 8800 
0263 6382 0984  56         srl   tmp0,8                ; Right align
0264 6384 045B  20         b     *r11                  ; Exit
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
0283 6386 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6388 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 638A C144  18         mov   tmp0,tmp1
0289 638C 05C5  14         inct  tmp1
0290 638E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 6390 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6392 FF00 
0292 6394 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 6396 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6398 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 639A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     639C 8000 
0298 639E 0206  20         li    tmp2,8
     63A0 0008 
0299 63A2 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     63A4 830B 
0300 63A6 06C5  14         swpb  tmp1
0301 63A8 D805  38         movb  tmp1,@vdpa
     63AA 8C02 
0302 63AC 06C5  14         swpb  tmp1
0303 63AE D805  38         movb  tmp1,@vdpa
     63B0 8C02 
0304 63B2 0225  22         ai    tmp1,>0100
     63B4 0100 
0305 63B6 0606  14         dec   tmp2
0306 63B8 16F4  14         jne   vidta1                ; Next register
0307 63BA C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     63BC 833A 
0308 63BE 045B  20         b     *r11
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
0325 63C0 C13B  30 putvr   mov   *r11+,tmp0
0326 63C2 0264  22 putvrx  ori   tmp0,>8000
     63C4 8000 
0327 63C6 06C4  14         swpb  tmp0
0328 63C8 D804  38         movb  tmp0,@vdpa
     63CA 8C02 
0329 63CC 06C4  14         swpb  tmp0
0330 63CE D804  38         movb  tmp0,@vdpa
     63D0 8C02 
0331 63D2 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 63D4 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63D6 C10E  18         mov   r14,tmp0
0341 63D8 0984  56         srl   tmp0,8
0342 63DA 06A0  32         bl    @putvrx               ; Write VR#0
     63DC 2338 
0343 63DE 0204  20         li    tmp0,>0100
     63E0 0100 
0344 63E2 D820  54         movb  @r14lb,@tmp0lb
     63E4 831D 
     63E6 8309 
0345 63E8 06A0  32         bl    @putvrx               ; Write VR#1
     63EA 2338 
0346 63EC 0458  20         b     *tmp4                 ; Exit
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
0360 63EE C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63F0 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63F2 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63F4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63F6 7FFF 
0364 63F8 2120  38         coc   @wbit0,tmp0
     63FA 2020 
0365 63FC 1604  14         jne   ldfnt1
0366 63FE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6400 8000 
0367 6402 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6404 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 6406 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6408 23E6 
0372 640A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     640C 9C02 
0373 640E 06C4  14         swpb  tmp0
0374 6410 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6412 9C02 
0375 6414 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6416 9800 
0376 6418 06C5  14         swpb  tmp1
0377 641A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     641C 9800 
0378 641E 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 6420 D805  38         movb  tmp1,@grmwa
     6422 9C02 
0383 6424 06C5  14         swpb  tmp1
0384 6426 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6428 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 642A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 642C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     642E 22BA 
0390 6430 05C8  14         inct  tmp4                  ; R11=R11+2
0391 6432 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 6434 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6436 7FFF 
0393 6438 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     643A 23E8 
0394 643C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     643E 23EA 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 6440 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6442 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6444 D120  34         movb  @grmrd,tmp0
     6446 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 6448 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     644A 2020 
0405 644C 1603  14         jne   ldfnt3                ; No, so skip
0406 644E D1C4  18         movb  tmp0,tmp3
0407 6450 0917  56         srl   tmp3,1
0408 6452 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6454 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6456 8C00 
0413 6458 0606  14         dec   tmp2
0414 645A 16F2  14         jne   ldfnt2
0415 645C 05C8  14         inct  tmp4                  ; R11=R11+2
0416 645E 020F  20         li    r15,vdpw              ; Set VDP write address
     6460 8C00 
0417 6462 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6464 7FFF 
0418 6466 0458  20         b     *tmp4                 ; Exit
0419 6468 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     646A 2000 
     646C 8C00 
0420 646E 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 6470 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6472 0200 
     6474 0000 
0425 6476 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6478 01C0 
     647A 0101 
0426 647C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     647E 02A0 
     6480 0101 
0427 6482 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6484 00E0 
     6486 0101 
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
0445 6488 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 648A C3A0  34         mov   @wyx,r14              ; Get YX
     648C 832A 
0447 648E 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 6490 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6492 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6494 C3A0  34         mov   @wyx,r14              ; Get YX
     6496 832A 
0454 6498 024E  22         andi  r14,>00ff             ; Remove Y
     649A 00FF 
0455 649C A3CE  18         a     r14,r15               ; pos = pos + X
0456 649E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     64A0 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 64A2 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 64A4 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 64A6 020F  20         li    r15,vdpw              ; VDP write address
     64A8 8C00 
0463 64AA 045B  20         b     *r11
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
0481 64AC C17B  30 putstr  mov   *r11+,tmp1
0482 64AE D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 64B0 C1CB  18 xutstr  mov   r11,tmp3
0484 64B2 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64B4 23FE 
0485 64B6 C2C7  18         mov   tmp3,r11
0486 64B8 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 64BA C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 64BC 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 64BE 0286  22         ci    tmp2,255              ; Length > 255 ?
     64C0 00FF 
0494 64C2 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 64C4 0460  28         b     @xpym2v               ; Display string
     64C6 2490 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 64C8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64CA FFCE 
0501 64CC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64CE 2026 
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
0517 64D0 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64D2 832A 
0518 64D4 0460  28         b     @putstr
     64D6 2422 
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
0539 64D8 0649  14         dect  stack
0540 64DA C64B  30         mov   r11,*stack            ; Save return address
0541 64DC 0649  14         dect  stack
0542 64DE C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64E0 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64E2 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64E4 0649  14         dect  stack
0551 64E6 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 64E8 0649  14         dect  stack
0553 64EA C646  30         mov   tmp2,*stack           ; Push tmp2
0554 64EC 0649  14         dect  stack
0555 64EE C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64F0 06A0  32         bl    @xutst0               ; Display string
     64F2 2424 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64F4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64FA 06A0  32         bl    @down                 ; Move cursor down
     64FC 26D8 
0566               
0567 64FE A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 6500 0585  14         inc   tmp1                  ; Consider length byte
0569 6502 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     6504 2002 
0570 6506 1301  14         jeq   !                     ; Yes, skip adjustment
0571 6508 0585  14         inc   tmp1                  ; Make address even
0572 650A 0606  14 !       dec   tmp2
0573 650C 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 650E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 6510 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 6512 045B  20         b     *r11                  ; Return
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
0020 6514 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6516 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6518 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 651A C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 651C 1604  14         jne   !                     ; No, continue
0028               
0029 651E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6520 FFCE 
0030 6522 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6524 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 6526 0264  22 !       ori   tmp0,>4000
     6528 4000 
0035 652A 06C4  14         swpb  tmp0
0036 652C D804  38         movb  tmp0,@vdpa
     652E 8C02 
0037 6530 06C4  14         swpb  tmp0
0038 6532 D804  38         movb  tmp0,@vdpa
     6534 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 6536 020F  20         li    r15,vdpw              ; Set VDP write address
     6538 8C00 
0043 653A C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     653C 24BA 
     653E 8320 
0044 6540 0460  28         b     @mcloop               ; Write data to VDP and return
     6542 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 6544 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6546 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6548 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 654A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 654C 06C4  14 xpyv2m  swpb  tmp0
0027 654E D804  38         movb  tmp0,@vdpa
     6550 8C02 
0028 6552 06C4  14         swpb  tmp0
0029 6554 D804  38         movb  tmp0,@vdpa
     6556 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6558 020F  20         li    r15,vdpr              ; Set VDP read address
     655A 8800 
0034 655C C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     655E 24DC 
     6560 8320 
0035 6562 0460  28         b     @mcloop               ; Read data from VDP
     6564 8320 
0036 6566 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6568 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 656A C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 656C C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 656E C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6570 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6572 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6574 FFCE 
0034 6576 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6578 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 657A 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     657C 0001 
0039 657E 1603  14         jne   cpym0                 ; No, continue checking
0040 6580 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6582 04C6  14         clr   tmp2                  ; Reset counter
0042 6584 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6586 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6588 7FFF 
0047 658A C1C4  18         mov   tmp0,tmp3
0048 658C 0247  22         andi  tmp3,1
     658E 0001 
0049 6590 1618  14         jne   cpyodd                ; Odd source address handling
0050 6592 C1C5  18 cpym1   mov   tmp1,tmp3
0051 6594 0247  22         andi  tmp3,1
     6596 0001 
0052 6598 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 659A 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     659C 2020 
0057 659E 1605  14         jne   cpym3
0058 65A0 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     65A2 253E 
     65A4 8320 
0059 65A6 0460  28         b     @mcloop               ; Copy memory and exit
     65A8 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 65AA C1C6  18 cpym3   mov   tmp2,tmp3
0064 65AC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     65AE 0001 
0065 65B0 1301  14         jeq   cpym4
0066 65B2 0606  14         dec   tmp2                  ; Make TMP2 even
0067 65B4 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 65B6 0646  14         dect  tmp2
0069 65B8 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 65BA C1C7  18         mov   tmp3,tmp3
0074 65BC 1301  14         jeq   cpymz
0075 65BE D554  38         movb  *tmp0,*tmp1
0076 65C0 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 65C2 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     65C4 8000 
0081 65C6 10E9  14         jmp   cpym2
0082 65C8 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 65CA C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 65CC 0649  14         dect  stack
0065 65CE C64B  30         mov   r11,*stack            ; Push return address
0066 65D0 0649  14         dect  stack
0067 65D2 C640  30         mov   r0,*stack             ; Push r0
0068 65D4 0649  14         dect  stack
0069 65D6 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 65D8 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 65DA 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65DC 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65DE 4000 
0077 65E0 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65E2 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65E4 020C  20         li    r12,>1e00             ; SAMS CRU address
     65E6 1E00 
0082 65E8 04C0  14         clr   r0
0083 65EA 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65EC D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65EE D100  18         movb  r0,tmp0
0086 65F0 0984  56         srl   tmp0,8                ; Right align
0087 65F2 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65F4 833C 
0088 65F6 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65F8 C339  30         mov   *stack+,r12           ; Pop r12
0094 65FA C039  30         mov   *stack+,r0            ; Pop r0
0095 65FC C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65FE 045B  20         b     *r11                  ; Return to caller
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
0131 6600 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6602 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6604 0649  14         dect  stack
0135 6606 C64B  30         mov   r11,*stack            ; Push return address
0136 6608 0649  14         dect  stack
0137 660A C640  30         mov   r0,*stack             ; Push r0
0138 660C 0649  14         dect  stack
0139 660E C64C  30         mov   r12,*stack            ; Push r12
0140 6610 0649  14         dect  stack
0141 6612 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6614 0649  14         dect  stack
0143 6616 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6618 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 661A 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 661C 0284  22         ci    tmp0,255              ; Crash if page > 255
     661E 00FF 
0153 6620 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 6622 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6624 001E 
0158 6626 150A  14         jgt   !
0159 6628 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     662A 0004 
0160 662C 1107  14         jlt   !
0161 662E 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     6630 0012 
0162 6632 1508  14         jgt   sams.page.set.switch_page
0163 6634 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6636 0006 
0164 6638 1501  14         jgt   !
0165 663A 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 663C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     663E FFCE 
0170 6640 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6642 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 6644 020C  20         li    r12,>1e00             ; SAMS CRU address
     6646 1E00 
0176 6648 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 664A 06C0  14         swpb  r0                    ; LSB to MSB
0178 664C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 664E D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6650 4000 
0180 6652 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6654 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6656 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6658 C339  30         mov   *stack+,r12           ; Pop r12
0188 665A C039  30         mov   *stack+,r0            ; Pop r0
0189 665C C2F9  30         mov   *stack+,r11           ; Pop return address
0190 665E 045B  20         b     *r11                  ; Return to caller
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
0204 6660 020C  20         li    r12,>1e00             ; SAMS CRU address
     6662 1E00 
0205 6664 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6666 045B  20         b     *r11                  ; Return to caller
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
0227 6668 020C  20         li    r12,>1e00             ; SAMS CRU address
     666A 1E00 
0228 666C 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 666E 045B  20         b     *r11                  ; Return to caller
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
0260 6670 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 6672 0649  14         dect  stack
0263 6674 C64B  30         mov   r11,*stack            ; Save return address
0264 6676 0649  14         dect  stack
0265 6678 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 667A 0649  14         dect  stack
0267 667C C645  30         mov   tmp1,*stack           ; Save tmp1
0268 667E 0649  14         dect  stack
0269 6680 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 6682 0649  14         dect  stack
0271 6684 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6686 0206  20         li    tmp2,8                ; Set loop counter
     6688 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 668A C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 668C C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 668E 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6690 257A 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 6692 0606  14         dec   tmp2                  ; Next iteration
0288 6694 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6696 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6698 25D6 
0294                                                   ; / activating changes.
0295               
0296 669A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 669C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 669E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 66A0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 66A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 66A4 045B  20         b     *r11                  ; Return to caller
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
0318 66A6 0649  14         dect  stack
0319 66A8 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 66AA 06A0  32         bl    @sams.layout
     66AC 25E6 
0324 66AE 262A                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 66B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 66B2 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 66B4 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     66B6 0002 
0336 66B8 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     66BA 0003 
0337 66BC A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     66BE 000A 
0338 66C0 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     66C2 000B 
0339 66C4 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     66C6 000C 
0340 66C8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     66CA 000D 
0341 66CC E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     66CE 000E 
0342 66D0 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     66D2 000F 
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
0363 66D4 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 66D6 0649  14         dect  stack
0366 66D8 C64B  30         mov   r11,*stack            ; Push return address
0367 66DA 0649  14         dect  stack
0368 66DC C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66DE 0649  14         dect  stack
0370 66E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66E2 0649  14         dect  stack
0372 66E4 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66E6 0649  14         dect  stack
0374 66E8 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66EA 0205  20         li    tmp1,sams.layout.copy.data
     66EC 2682 
0379 66EE 0206  20         li    tmp2,8                ; Set loop counter
     66F0 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66F2 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66F4 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66F6 2542 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66F8 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66FA 833C 
0390               
0391 66FC 0606  14         dec   tmp2                  ; Next iteration
0392 66FE 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 6700 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 6702 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 6704 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 6706 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 6708 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 670A 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 670C 2000             data  >2000                 ; >2000-2fff
0408 670E 3000             data  >3000                 ; >3000-3fff
0409 6710 A000             data  >a000                 ; >a000-afff
0410 6712 B000             data  >b000                 ; >b000-bfff
0411 6714 C000             data  >c000                 ; >c000-cfff
0412 6716 D000             data  >d000                 ; >d000-dfff
0413 6718 E000             data  >e000                 ; >e000-efff
0414 671A F000             data  >f000                 ; >f000-ffff
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
0009 671C 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     671E FFBF 
0010 6720 0460  28         b     @putv01
     6722 234A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6724 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6726 0040 
0018 6728 0460  28         b     @putv01
     672A 234A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 672C 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     672E FFDF 
0026 6730 0460  28         b     @putv01
     6732 234A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6734 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6736 0020 
0034 6738 0460  28         b     @putv01
     673A 234A 
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
0010 673C 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     673E FFFE 
0011 6740 0460  28         b     @putv01
     6742 234A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6744 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6746 0001 
0019 6748 0460  28         b     @putv01
     674A 234A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 674C 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     674E FFFD 
0027 6750 0460  28         b     @putv01
     6752 234A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6754 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6756 0002 
0035 6758 0460  28         b     @putv01
     675A 234A 
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
0018 675C C83B  50 at      mov   *r11+,@wyx
     675E 832A 
0019 6760 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6762 B820  54 down    ab    @hb$01,@wyx
     6764 2012 
     6766 832A 
0028 6768 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 676A 7820  54 up      sb    @hb$01,@wyx
     676C 2012 
     676E 832A 
0037 6770 045B  20         b     *r11
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
0049 6772 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6774 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6776 832A 
0051 6778 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     677A 832A 
0052 677C 045B  20         b     *r11
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
0021 677E C120  34 yx2px   mov   @wyx,tmp0
     6780 832A 
0022 6782 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6784 06C4  14         swpb  tmp0                  ; Y<->X
0024 6786 04C5  14         clr   tmp1                  ; Clear before copy
0025 6788 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 678A 20A0  38         coc   @wbit1,config         ; f18a present ?
     678C 201E 
0030 678E 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6790 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6792 833A 
     6794 2734 
0032 6796 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6798 0A15  56         sla   tmp1,1                ; X = X * 2
0035 679A B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 679C 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     679E 0500 
0037 67A0 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 67A2 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 67A4 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 67A6 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 67A8 D105  18         movb  tmp1,tmp0
0051 67AA 06C4  14         swpb  tmp0                  ; X<->Y
0052 67AC 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     67AE 2020 
0053 67B0 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 67B2 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     67B4 2012 
0059 67B6 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     67B8 2024 
0060 67BA 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 67BC 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 67BE 0050            data   80
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
0013 67C0 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 67C2 06A0  32         bl    @putvr                ; Write once
     67C4 2336 
0015 67C6 391C             data  >391c                 ; VR1/57, value 00011100
0016 67C8 06A0  32         bl    @putvr                ; Write twice
     67CA 2336 
0017 67CC 391C             data  >391c                 ; VR1/57, value 00011100
0018 67CE 06A0  32         bl    @putvr
     67D0 2336 
0019 67D2 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 67D4 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 67D6 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 67D8 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     67DA 2336 
0030 67DC 391C             data  >391c
0031 67DE 0458  20         b     *tmp4                 ; Exit
0032               
0033               
0034               ***************************************************************
0035               * f18chk - Check if F18A VDP present
0036               ***************************************************************
0037               *  bl   @f18chk
0038               *--------------------------------------------------------------
0039               *  REMARKS
0040               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0041               ********|*****|*********************|**************************
0042 67E0 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0043 67E2 06A0  32         bl    @cpym2v
     67E4 248A 
0044 67E6 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     67E8 279A 
     67EA 0006 
0045 67EC 06A0  32         bl    @putvr
     67EE 2336 
0046 67F0 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0047 67F2 06A0  32         bl    @putvr
     67F4 2336 
0048 67F6 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0049                                                   ; GPU code should run now
0050               ***************************************************************
0051               * VDP @>3f00 == 0 ? F18A present : F18a not present
0052               ***************************************************************
0053 67F8 0204  20         li    tmp0,>3f00
     67FA 3F00 
0054 67FC 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67FE 22BE 
0055 6800 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6802 8800 
0056 6804 0984  56         srl   tmp0,8
0057 6806 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6808 8800 
0058 680A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0059 680C 1303  14         jeq   f18chk_yes
0060               f18chk_no:
0061 680E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6810 BFFF 
0062 6812 1002  14         jmp   f18chk_exit
0063               f18chk_yes:
0064 6814 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6816 4000 
0065               f18chk_exit:
0066 6818 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     681A 2292 
0067 681C 3F00             data  >3f00,>00,6
     681E 0000 
     6820 0006 
0068 6822 0458  20         b     *tmp4                 ; Exit
0069               ***************************************************************
0070               * GPU code
0071               ********|*****|*********************|**************************
0072               f18chk_gpu
0073 6824 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0074 6826 3F00             data  >3f00                 ; 3f02 / 3f00
0075 6828 0340             data  >0340                 ; 3f04   0340  idle
0076               
0077               
0078               ***************************************************************
0079               * f18rst - Reset f18a into standard settings
0080               ***************************************************************
0081               *  bl   @f18rst
0082               *--------------------------------------------------------------
0083               *  REMARKS
0084               *  This is used to leave the F18A mode and revert all settings
0085               *  that could lead to corruption when doing BLWP @0
0086               *
0087               *  There are some F18a settings that stay on when doing blwp @0
0088               *  and the TI title screen cannot recover from that.
0089               *
0090               *  It is your responsibility to set video mode tables should
0091               *  you want to continue instead of doing blwp @0 after your
0092               *  program cleanup
0093               ********|*****|*********************|**************************
0094 682A C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0095                       ;------------------------------------------------------
0096                       ; Reset all F18a VDP registers to power-on defaults
0097                       ;------------------------------------------------------
0098 682C 06A0  32         bl    @putvr
     682E 2336 
0099 6830 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0100               
0101 6832 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6834 2336 
0102 6836 391C             data  >391c                 ; Lock the F18a
0103 6838 0458  20         b     *tmp4                 ; Exit
0104               
0105               
0106               
0107               ***************************************************************
0108               * f18fwv - Get F18A Firmware Version
0109               ***************************************************************
0110               *  bl   @f18fwv
0111               *--------------------------------------------------------------
0112               *  REMARKS
0113               *  Successfully tested with F18A v1.8, note that this does not
0114               *  work with F18 v1.3 but you shouldn't be using such old F18A
0115               *  firmware to begin with.
0116               *--------------------------------------------------------------
0117               *  TMP0 High nibble = major version
0118               *  TMP0 Low nibble  = minor version
0119               *
0120               *  Example: >0018     F18a Firmware v1.8
0121               ********|*****|*********************|**************************
0122 683A C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0123 683C 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     683E 201E 
0124 6840 1609  14         jne   f18fw1
0125               ***************************************************************
0126               * Read F18A major/minor version
0127               ***************************************************************
0128 6842 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6844 8802 
0129 6846 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6848 2336 
0130 684A 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0131 684C 04C4  14         clr   tmp0
0132 684E D120  34         movb  @vdps,tmp0
     6850 8802 
0133 6852 0984  56         srl   tmp0,8
0134 6854 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6856 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6858 832A 
0018 685A D17B  28         movb  *r11+,tmp1
0019 685C 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 685E D1BB  28         movb  *r11+,tmp2
0021 6860 0986  56         srl   tmp2,8                ; Repeat count
0022 6862 C1CB  18         mov   r11,tmp3
0023 6864 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6866 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6868 020B  20         li    r11,hchar1
     686A 27E6 
0028 686C 0460  28         b     @xfilv                ; Draw
     686E 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6870 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6872 2022 
0033 6874 1302  14         jeq   hchar2                ; Yes, exit
0034 6876 C2C7  18         mov   tmp3,r11
0035 6878 10EE  14         jmp   hchar                 ; Next one
0036 687A 05C7  14 hchar2  inct  tmp3
0037 687C 0457  20         b     *tmp3                 ; Exit
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
0016 687E 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6880 2020 
0017 6882 020C  20         li    r12,>0024
     6884 0024 
0018 6886 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6888 2890 
0019 688A 04C6  14         clr   tmp2
0020 688C 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 688E 04CC  14         clr   r12
0025 6890 1F08  20         tb    >0008                 ; Shift-key ?
0026 6892 1302  14         jeq   realk1                ; No
0027 6894 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6896 28C0 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6898 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 689A 1302  14         jeq   realk2                ; No
0033 689C 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     689E 28F0 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 68A0 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 68A2 1302  14         jeq   realk3                ; No
0039 68A4 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     68A6 2920 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 68A8 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     68AA 200C 
0044 68AC 1E15  20         sbz   >0015                 ; Set P5
0045 68AE 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 68B0 1302  14         jeq   realk4                ; No
0047 68B2 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     68B4 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 68B6 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 68B8 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     68BA 0006 
0053 68BC 0606  14 realk5  dec   tmp2
0054 68BE 020C  20         li    r12,>24               ; CRU address for P2-P4
     68C0 0024 
0055 68C2 06C6  14         swpb  tmp2
0056 68C4 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 68C6 06C6  14         swpb  tmp2
0058 68C8 020C  20         li    r12,6                 ; CRU read address
     68CA 0006 
0059 68CC 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 68CE 0547  14         inv   tmp3                  ;
0061 68D0 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     68D2 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 68D4 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 68D6 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 68D8 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 68DA 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 68DC 0285  22         ci    tmp1,8
     68DE 0008 
0070 68E0 1AFA  14         jl    realk6
0071 68E2 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 68E4 1BEB  14         jh    realk5                ; No, next column
0073 68E6 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 68E8 C206  18 realk8  mov   tmp2,tmp4
0078 68EA 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 68EC A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 68EE A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 68F0 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 68F2 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 68F4 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 68F6 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     68F8 200C 
0089 68FA 1608  14         jne   realka                ; No, continue saving key
0090 68FC 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     68FE 28BA 
0091 6900 1A05  14         jl    realka
0092 6902 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6904 28B8 
0093 6906 1B02  14         jh    realka                ; No, continue
0094 6908 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     690A E000 
0095 690C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     690E 833C 
0096 6910 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6912 200A 
0097 6914 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     6916 8C00 
0098                                                   ; / using R15 as temp storage
0099 6918 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 691A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     691C 0000 
     691E FF0D 
     6920 203D 
0102 6922 ....             text  'xws29ol.'
0103 692A ....             text  'ced38ik,'
0104 6932 ....             text  'vrf47ujm'
0105 693A ....             text  'btg56yhn'
0106 6942 ....             text  'zqa10p;/'
0107 694A FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     694C 0000 
     694E FF0D 
     6950 202B 
0108 6952 ....             text  'XWS@(OL>'
0109 695A ....             text  'CED#*IK<'
0110 6962 ....             text  'VRF$&UJM'
0111 696A ....             text  'BTG%^YHN'
0112 6972 ....             text  'ZQA!)P:-'
0113 697A FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     697C 0000 
     697E FF0D 
     6980 2005 
0114 6982 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6984 0804 
     6986 0F27 
     6988 C2B9 
0115 698A 600B             data  >600b,>0907,>063f,>c1B8
     698C 0907 
     698E 063F 
     6990 C1B8 
0116 6992 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6994 7B02 
     6996 015F 
     6998 C0C3 
0117 699A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     699C 7D0E 
     699E 0CC6 
     69A0 BFC4 
0118 69A2 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     69A4 7C03 
     69A6 BC22 
     69A8 BDBA 
0119 69AA FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     69AC 0000 
     69AE FF0D 
     69B0 209D 
0120 69B2 9897             data  >9897,>93b2,>9f8f,>8c9B
     69B4 93B2 
     69B6 9F8F 
     69B8 8C9B 
0121 69BA 8385             data  >8385,>84b3,>9e89,>8b80
     69BC 84B3 
     69BE 9E89 
     69C0 8B80 
0122 69C2 9692             data  >9692,>86b4,>b795,>8a8D
     69C4 86B4 
     69C6 B795 
     69C8 8A8D 
0123 69CA 8294             data  >8294,>87b5,>b698,>888E
     69CC 87B5 
     69CE B698 
     69D0 888E 
0124 69D2 9A91             data  >9a91,>81b1,>b090,>9cBB
     69D4 81B1 
     69D6 B090 
     69D8 9CBB 
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
0023 69DA C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 69DC C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     69DE 8340 
0025 69E0 04E0  34         clr   @waux1
     69E2 833C 
0026 69E4 04E0  34         clr   @waux2
     69E6 833E 
0027 69E8 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     69EA 833C 
0028 69EC C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 69EE 0205  20         li    tmp1,4                ; 4 nibbles
     69F0 0004 
0033 69F2 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 69F4 0246  22         andi  tmp2,>000f            ; Only keep LSN
     69F6 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 69F8 0286  22         ci    tmp2,>000a
     69FA 000A 
0039 69FC 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 69FE C21B  26         mov   *r11,tmp4
0045 6A00 0988  56         srl   tmp4,8                ; Right justify
0046 6A02 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A04 FFF6 
0047 6A06 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A08 C21B  26         mov   *r11,tmp4
0054 6A0A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A0C 00FF 
0055               
0056 6A0E A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A10 06C6  14         swpb  tmp2
0058 6A12 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A14 0944  56         srl   tmp0,4                ; Next nibble
0060 6A16 0605  14         dec   tmp1
0061 6A18 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A1A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A1C BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A1E C160  34         mov   @waux3,tmp1           ; Get pointer
     6A20 8340 
0067 6A22 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6A24 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6A26 C120  34         mov   @waux2,tmp0
     6A28 833E 
0070 6A2A 06C4  14         swpb  tmp0
0071 6A2C DD44  32         movb  tmp0,*tmp1+
0072 6A2E 06C4  14         swpb  tmp0
0073 6A30 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6A32 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6A34 8340 
0078 6A36 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6A38 2016 
0079 6A3A 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6A3C C120  34         mov   @waux1,tmp0
     6A3E 833C 
0084 6A40 06C4  14         swpb  tmp0
0085 6A42 DD44  32         movb  tmp0,*tmp1+
0086 6A44 06C4  14         swpb  tmp0
0087 6A46 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6A48 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A4A 2020 
0092 6A4C 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6A4E 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6A50 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6A52 7FFF 
0098 6A54 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A56 8340 
0099 6A58 0460  28         b     @xutst0               ; Display string
     6A5A 2424 
0100 6A5C 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A5E C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A60 832A 
0122 6A62 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A64 8000 
0123 6A66 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6A68 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A6A 0005 
0020 6A6C C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A6E C155  26         mov   *tmp1,tmp1            ; /
0022 6A70 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A72 0228  22         ai    tmp4,4                ; Get end of buffer
     6A74 0004 
0024 6A76 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A78 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A7A 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A7C 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A7E 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A80 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A82 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A84 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6A86 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A88 0607  14         dec   tmp3                  ; Decrease counter
0036 6A8A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A8C 0207  20         li    tmp3,4                ; Check first 4 digits
     6A8E 0004 
0041 6A90 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A92 C11B  26         mov   *r11,tmp0
0043 6A94 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6A96 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6A98 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6A9A 05CB  14 mknum3  inct  r11
0047 6A9C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A9E 2020 
0048 6AA0 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6AA2 045B  20         b     *r11                  ; Exit
0050 6AA4 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6AA6 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6AA8 13F8  14         jeq   mknum3                ; Yes, exit
0053 6AAA 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6AAC 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6AAE 7FFF 
0058 6AB0 C10B  18         mov   r11,tmp0
0059 6AB2 0224  22         ai    tmp0,-4
     6AB4 FFFC 
0060 6AB6 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6AB8 0206  20         li    tmp2,>0500            ; String length = 5
     6ABA 0500 
0062 6ABC 0460  28         b     @xutstr               ; Display string
     6ABE 2426 
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
0093 6AC0 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6AC2 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6AC4 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6AC6 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6AC8 0207  20         li    tmp3,5                ; Set counter
     6ACA 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6ACC 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6ACE 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6AD0 0584  14         inc   tmp0                  ; Next character
0105 6AD2 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6AD4 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6AD6 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6AD8 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6ADA DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6ADC 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6ADE DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6AE0 0607  14         dec   tmp3                  ; Last character ?
0121 6AE2 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6AE4 045B  20         b     *r11                  ; Return
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
0139 6AE6 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6AE8 832A 
0140 6AEA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AEC 8000 
0141 6AEE 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6AF0 0649  14         dect  stack
0023 6AF2 C64B  30         mov   r11,*stack            ; Save return address
0024 6AF4 0649  14         dect  stack
0025 6AF6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6AF8 0649  14         dect  stack
0027 6AFA C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6AFC 0649  14         dect  stack
0029 6AFE C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B00 0649  14         dect  stack
0031 6B02 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B04 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B06 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B08 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B0A 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B0C 0649  14         dect  stack
0044 6B0E C64B  30         mov   r11,*stack            ; Save return address
0045 6B10 0649  14         dect  stack
0046 6B12 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B14 0649  14         dect  stack
0048 6B16 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B18 0649  14         dect  stack
0050 6B1A C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B1C 0649  14         dect  stack
0052 6B1E C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6B20 C1D4  26 !       mov   *tmp0,tmp3
0057 6B22 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6B24 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6B26 00FF 
0059 6B28 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6B2A 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6B2C 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6B2E 0584  14         inc   tmp0                  ; Next byte
0067 6B30 0607  14         dec   tmp3                  ; Shorten string length
0068 6B32 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6B34 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6B36 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6B38 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6B3A 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6B3C C187  18         mov   tmp3,tmp2
0078 6B3E 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6B40 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6B42 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6B44 24E4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6B46 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6B48 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B4A FFCE 
0090 6B4C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B4E 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6B50 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6B52 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B54 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B56 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B58 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B5A 045B  20         b     *r11                  ; Return to caller
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
0123 6B5C 0649  14         dect  stack
0124 6B5E C64B  30         mov   r11,*stack            ; Save return address
0125 6B60 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B62 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B64 0649  14         dect  stack
0128 6B66 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B68 0649  14         dect  stack
0130 6B6A C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B6C 0649  14         dect  stack
0132 6B6E C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B70 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B72 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B74 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B76 0649  14         dect  stack
0144 6B78 C64B  30         mov   r11,*stack            ; Save return address
0145 6B7A 0649  14         dect  stack
0146 6B7C C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B7E 0649  14         dect  stack
0148 6B80 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B82 0649  14         dect  stack
0150 6B84 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B86 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B88 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B8A 0586  14         inc   tmp2
0161 6B8C 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B8E 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6B90 0286  22         ci    tmp2,255
     6B92 00FF 
0167 6B94 1505  14         jgt   string.getlenc.panic
0168 6B96 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6B98 0606  14         dec   tmp2                  ; One time adjustment
0174 6B9A C806  38         mov   tmp2,@waux1           ; Store length
     6B9C 833C 
0175 6B9E 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6BA0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BA2 FFCE 
0181 6BA4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BA6 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6BA8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6BAA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6BAC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6BAE C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6BB0 045B  20         b     *r11                  ; Return to caller
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
0056 6BB2 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6BB4 2B2C             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6BB6 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6BB8 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6BBA A428 
0064 6BBC 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6BBE 201C 
0065 6BC0 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6BC2 8356 
0066 6BC4 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6BC6 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6BC8 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6BCA C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6BCC A434 
0073                       ;---------------------------; Inline VSBR start
0074 6BCE 06C0  14         swpb  r0                    ;
0075 6BD0 D800  38         movb  r0,@vdpa              ; Send low byte
     6BD2 8C02 
0076 6BD4 06C0  14         swpb  r0                    ;
0077 6BD6 D800  38         movb  r0,@vdpa              ; Send high byte
     6BD8 8C02 
0078 6BDA D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6BDC 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6BDE 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6BE0 0704  14         seto  r4                    ; Init counter
0086 6BE2 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6BE4 A420 
0087 6BE6 0580  14 !       inc   r0                    ; Point to next char of name
0088 6BE8 0584  14         inc   r4                    ; Increment char counter
0089 6BEA 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6BEC 0007 
0090 6BEE 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6BF0 80C4  18         c     r4,r3                 ; End of name?
0093 6BF2 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6BF4 06C0  14         swpb  r0                    ;
0098 6BF6 D800  38         movb  r0,@vdpa              ; Send low byte
     6BF8 8C02 
0099 6BFA 06C0  14         swpb  r0                    ;
0100 6BFC D800  38         movb  r0,@vdpa              ; Send high byte
     6BFE 8C02 
0101 6C00 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6C02 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6C04 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6C06 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6C08 2C94 
0109 6C0A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6C0C C104  18         mov   r4,r4                 ; Check if length = 0
0115 6C0E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6C10 04E0  34         clr   @>83d0
     6C12 83D0 
0118 6C14 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6C16 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6C18 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6C1A A432 
0121               
0122 6C1C 0584  14         inc   r4                    ; Adjust for dot
0123 6C1E A804  38         a     r4,@>8356             ; Point to position after name
     6C20 8356 
0124 6C22 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6C24 8356 
     6C26 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6C28 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6C2A 83E0 
0130 6C2C 04C1  14         clr   r1                    ; Version found of dsr
0131 6C2E 020C  20         li    r12,>0f00             ; Init cru address
     6C30 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6C32 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6C34 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6C36 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6C38 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6C3A 0100 
0145 6C3C 04E0  34         clr   @>83d0                ; Clear in case we are done
     6C3E 83D0 
0146 6C40 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6C42 2000 
0147 6C44 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6C46 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6C48 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6C4A 1D00  20         sbo   0                     ; Turn on ROM
0154 6C4C 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6C4E 4000 
0155 6C50 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6C52 2C90 
0156 6C54 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6C56 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6C58 A40A 
0166 6C5A 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6C5C C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C5E 83D2 
0172                                                   ; subprogram
0173               
0174 6C60 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6C62 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6C64 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6C66 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C68 83D2 
0183                                                   ; subprogram
0184               
0185 6C6A 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6C6C C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6C6E 04C5  14         clr   r5                    ; Remove any old stuff
0194 6C70 D160  34         movb  @>8355,r5             ; Get length as counter
     6C72 8355 
0195 6C74 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6C76 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6C78 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6C7A 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6C7C 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C7E A420 
0206 6C80 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6C82 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6C84 0605  14         dec   r5                    ; Update loop counter
0211 6C86 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6C88 0581  14         inc   r1                    ; Next version found
0217 6C8A C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6C8C A42A 
0218 6C8E C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6C90 A42C 
0219 6C92 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6C94 A430 
0220               
0221 6C96 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6C98 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6C9A 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6C9C 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6C9E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6CA0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6CA2 A400 
0233 6CA4 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6CA6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6CA8 A428 
0239                                                   ; (8 or >a)
0240 6CAA 0281  22         ci    r1,8                  ; was it 8?
     6CAC 0008 
0241 6CAE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6CB0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6CB2 8350 
0243                                                   ; Get error byte from @>8350
0244 6CB4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6CB6 06C0  14         swpb  r0                    ;
0252 6CB8 D800  38         movb  r0,@vdpa              ; send low byte
     6CBA 8C02 
0253 6CBC 06C0  14         swpb  r0                    ;
0254 6CBE D800  38         movb  r0,@vdpa              ; send high byte
     6CC0 8C02 
0255 6CC2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6CC4 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6CC6 09D1  56         srl   r1,13                 ; just keep error bits
0263 6CC8 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6CCA 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6CCC 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6CCE 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6CD0 A400 
0275               dsrlnk.error.devicename_invalid:
0276 6CD2 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6CD4 06C1  14         swpb  r1                    ; put error in hi byte
0279 6CD6 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6CD8 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6CDA 201C 
0281                                                   ; / to indicate error
0282 6CDC 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6CDE A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6CE0 2C58             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6CE2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6CE4 83E0 
0316               
0317 6CE6 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6CE8 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6CEA 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6CEC A42A 
0322 6CEE C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6CF0 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6CF2 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6CF4 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6CF6 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6CF8 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6CFA 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6CFC 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6CFE 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6D00 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6D02 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6D04 4000 
     6D06 2C90 
0337 6D08 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6D0A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6D0C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6D0E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6D10 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6D12 A400 
0355 6D14 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6D16 A434 
0356               
0357 6D18 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6D1A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6D1C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6D1E ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6D20 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6D22 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6D24 0649  14         dect  stack
0052 6D26 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6D28 0204  20         li    tmp0,dsrlnk.savcru
     6D2A A42A 
0057 6D2C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6D2E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6D30 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6D32 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6D34 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6D36 37D7 
0065 6D38 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6D3A 8370 
0066                                                   ; / location
0067 6D3C C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6D3E A44C 
0068 6D40 04C5  14         clr   tmp1                  ; io.op.open
0069 6D42 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6D44 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6D46 0649  14         dect  stack
0097 6D48 C64B  30         mov   r11,*stack            ; Save return address
0098 6D4A 0205  20         li    tmp1,io.op.close      ; io.op.close
     6D4C 0001 
0099 6D4E 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6D50 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6D52 0649  14         dect  stack
0125 6D54 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6D56 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D58 0002 
0128 6D5A 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6D5C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6D5E 0649  14         dect  stack
0155 6D60 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6D62 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6D64 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6D66 0005 
0159               
0160 6D68 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6D6A A43E 
0161               
0162 6D6C 06A0  32         bl    @xvputb               ; Write character count to PAB
     6D6E 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6D70 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D72 0003 
0167 6D74 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6D76 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6D78 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6D7A 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6D7C 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6D7E 1000  14         nop
0189               
0190               
0191               file.status:
0192 6D80 1000  14         nop
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
0227 6D82 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6D84 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6D86 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6D88 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6D8A A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6D8C 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6D8E 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6D90 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6D92 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6D94 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6D96 A44C 
0246               
0247 6D98 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6D9A 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6D9C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6D9E 0009 
0254 6DA0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DA2 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6DA4 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6DA6 8322 
     6DA8 833C 
0259               
0260 6DAA C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6DAC A42A 
0261 6DAE 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6DB0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DB2 2B28 
0268 6DB4 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6DB6 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6DB8 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6DBA 2C54 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6DBC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6DBE C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6DC0 833C 
     6DC2 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6DC4 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6DC6 A436 
0292 6DC8 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6DCA 0005 
0293 6DCC 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6DCE 22E8 
0294 6DD0 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6DD2 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6DD4 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6DD6 045B  20         b     *r11                  ; Return to caller
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
0020 6DD8 0300  24 tmgr    limi  0                     ; No interrupt processing
     6DDA 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6DDC D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6DDE 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6DE0 2360  38         coc   @wbit2,r13            ; C flag on ?
     6DE2 201C 
0029 6DE4 1602  14         jne   tmgr1a                ; No, so move on
0030 6DE6 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6DE8 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6DEA 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6DEC 2020 
0035 6DEE 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6DF0 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6DF2 2010 
0048 6DF4 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6DF6 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6DF8 200E 
0050 6DFA 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6DFC 0460  28         b     @kthread              ; Run kernel thread
     6DFE 2DEC 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6E00 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6E02 2014 
0056 6E04 13EB  14         jeq   tmgr1
0057 6E06 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6E08 2012 
0058 6E0A 16E8  14         jne   tmgr1
0059 6E0C C120  34         mov   @wtiusr,tmp0
     6E0E 832E 
0060 6E10 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6E12 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6E14 2DEA 
0065 6E16 C10A  18         mov   r10,tmp0
0066 6E18 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6E1A 00FF 
0067 6E1C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6E1E 201C 
0068 6E20 1303  14         jeq   tmgr5
0069 6E22 0284  22         ci    tmp0,60               ; 1 second reached ?
     6E24 003C 
0070 6E26 1002  14         jmp   tmgr6
0071 6E28 0284  22 tmgr5   ci    tmp0,50
     6E2A 0032 
0072 6E2C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6E2E 1001  14         jmp   tmgr8
0074 6E30 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6E32 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6E34 832C 
0079 6E36 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6E38 FF00 
0080 6E3A C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6E3C 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6E3E 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6E40 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6E42 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6E44 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6E46 830C 
     6E48 830D 
0089 6E4A 1608  14         jne   tmgr10                ; No, get next slot
0090 6E4C 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6E4E FF00 
0091 6E50 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6E52 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E54 8330 
0096 6E56 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6E58 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6E5A 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6E5C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6E5E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6E60 8315 
     6E62 8314 
0103 6E64 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6E66 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6E68 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6E6A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6E6C 10F7  14         jmp   tmgr10                ; Process next slot
0108 6E6E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6E70 FF00 
0109 6E72 10B4  14         jmp   tmgr1
0110 6E74 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6E76 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E78 2010 
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
0041 6E7A 06A0  32         bl    @realkb               ; Scan full keyboard
     6E7C 27F4 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E7E 0460  28         b     @tmgr3                ; Exit
     6E80 2D76 
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
0017 6E82 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E84 832E 
0018 6E86 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6E88 2012 
0019 6E8A 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D52     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6E8C 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6E8E 832E 
0029 6E90 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E92 FEFF 
0030 6E94 045B  20         b     *r11                  ; Return
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
0017 6E96 C13B  30 mkslot  mov   *r11+,tmp0
0018 6E98 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6E9A C184  18         mov   tmp0,tmp2
0023 6E9C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6E9E A1A0  34         a     @wtitab,tmp2          ; Add table base
     6EA0 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6EA2 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6EA4 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6EA6 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6EA8 881B  46         c     *r11,@w$ffff          ; End of list ?
     6EAA 2022 
0035 6EAC 1301  14         jeq   mkslo1                ; Yes, exit
0036 6EAE 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6EB0 05CB  14 mkslo1  inct  r11
0041 6EB2 045B  20         b     *r11                  ; Exit
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
0052 6EB4 C13B  30 clslot  mov   *r11+,tmp0
0053 6EB6 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6EB8 A120  34         a     @wtitab,tmp0          ; Add table base
     6EBA 832C 
0055 6EBC 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6EBE 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6EC0 045B  20         b     *r11                  ; Exit
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
0068 6EC2 C13B  30 rsslot  mov   *r11+,tmp0
0069 6EC4 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6EC6 A120  34         a     @wtitab,tmp0          ; Add table base
     6EC8 832C 
0071 6ECA 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6ECC C154  26         mov   *tmp0,tmp1
0073 6ECE 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6ED0 FF00 
0074 6ED2 C505  30         mov   tmp1,*tmp0
0075 6ED4 045B  20         b     *r11                  ; Exit
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
0260 6ED6 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6ED8 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 6EDA 0300  24 runli1  limi  0                     ; Turn off interrupts
     6EDC 0000 
0266 6EDE 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6EE0 8300 
0267 6EE2 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6EE4 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 6EE6 0202  20 runli2  li    r2,>8308
     6EE8 8308 
0272 6EEA 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 6EEC 0282  22         ci    r2,>8400
     6EEE 8400 
0274 6EF0 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 6EF2 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6EF4 FFFF 
0279 6EF6 1602  14         jne   runli4                ; No, continue
0280 6EF8 0420  54         blwp  @0                    ; Yes, bye bye
     6EFA 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 6EFC C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6EFE 833C 
0285 6F00 04C1  14         clr   r1                    ; Reset counter
0286 6F02 0202  20         li    r2,10                 ; We test 10 times
     6F04 000A 
0287 6F06 C0E0  34 runli5  mov   @vdps,r3
     6F08 8802 
0288 6F0A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6F0C 2020 
0289 6F0E 1302  14         jeq   runli6
0290 6F10 0581  14         inc   r1                    ; Increase counter
0291 6F12 10F9  14         jmp   runli5
0292 6F14 0602  14 runli6  dec   r2                    ; Next test
0293 6F16 16F7  14         jne   runli5
0294 6F18 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6F1A 1250 
0295 6F1C 1202  14         jle   runli7                ; No, so it must be NTSC
0296 6F1E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6F20 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 6F22 06A0  32 runli7  bl    @loadmc
     6F24 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 6F26 04C1  14 runli9  clr   r1
0305 6F28 04C2  14         clr   r2
0306 6F2A 04C3  14         clr   r3
0307 6F2C 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6F2E 3000 
0308 6F30 020F  20         li    r15,vdpw              ; Set VDP write address
     6F32 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 6F34 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6F36 4A4A 
0317 6F38 1605  14         jne   runlia
0318 6F3A 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6F3C 2292 
0319 6F3E 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     6F40 0000 
     6F42 3000 
0324 6F44 06A0  32 runlia  bl    @filv
     6F46 2292 
0325 6F48 0FC0             data  pctadr,spfclr,16      ; Load color table
     6F4A 00F4 
     6F4C 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 6F4E 06A0  32         bl    @f18unl               ; Unlock the F18A
     6F50 2736 
0333 6F52 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F54 2756 
0334 6F56 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F58 274C 
0335               
0336 6F5A 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6F5C 2336 
0337 6F5E 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 6F60 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F62 22FC 
0351 6F64 33A6             data  spvmod                ; Equate selected video mode table
0352 6F66 0204  20         li    tmp0,spfont           ; Get font option
     6F68 000C 
0353 6F6A 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 6F6C 1304  14         jeq   runlid                ; Yes, skip it
0355 6F6E 06A0  32         bl    @ldfnt
     6F70 2364 
0356 6F72 1100             data  fntadr,spfont         ; Load specified font
     6F74 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 6F76 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F78 4A4A 
0361 6F7A 1602  14         jne   runlie                ; No, continue
0362 6F7C 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F7E 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 6F80 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F82 0040 
0367 6F84 0460  28         b     @main                 ; Give control to main program
     6F86 3000 
**** **** ****     > stevie_b0.asm.1384146
0098                                                   ; Spectra 2
0099                       ;------------------------------------------------------
0100                       ; End of File marker
0101                       ;------------------------------------------------------
0102 6F88 DEAD             data  >dead,>beef,>dead,>beef
     6F8A BEEF 
     6F8C DEAD 
     6F8E BEEF 
0104               
0108 6F90 2F06                   data $                ; Bank 0 ROM size OK.
0110               
0111 6F92 ....             bss  300                    ; Fill remaining space with >00
0112               
0113               ***************************************************************
0114               * Code data: Relocated Stevie modules >3000 - >3fff (4K max)
0115               ********|*****|*********************|**************************
0116               reloc.stevie:
0117                       xorg  >3000                 ; Relocate Stevie modules to >3000
0118                       ;------------------------------------------------------
0119                       ; Activate bank 1 and branch to >6046
0120                       ;------------------------------------------------------
0121               main:
0122 70BE 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     70C0 6002 
0123               
0127               
0128 70C2 0460  28         b     @kickstart.code2      ; Jump to entry routine
     70C4 6046 
0129                       ;------------------------------------------------------
0130                       ; Resident Stevie modules: >3000 - >3fff
0131                       ;------------------------------------------------------
0132                       copy  "ram.resident.3000.asm"
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
0021 70C6 C13B  30         mov   *r11+,tmp0            ; P0
0022 70C8 C17B  30         mov   *r11+,tmp1            ; P1
0023 70CA C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 70CC 0649  14         dect  stack
0029 70CE C644  30         mov   tmp0,*stack           ; Push tmp0
0030 70D0 0649  14         dect  stack
0031 70D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 70D4 0649  14         dect  stack
0033 70D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 70D8 0649  14         dect  stack
0035 70DA C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 70DC 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     70DE 6000 
0040 70E0 1111  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 70E2 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     70E4 A026 
0044 70E6 0647  14         dect  tmp3
0045 70E8 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 70EA 0647  14         dect  tmp3
0047 70EC C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 70EE C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     70F0 A026 
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 70F2 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 70F4 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 70F6 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 70F8 0224  22         ai    tmp0,>0800
     70FA 0800 
0066 70FC 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071 70FE C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0072 7100 1301  14         jeq   rom.farjump.bankswitch.failed1
0073                                                   ; Crash if null-pointer in vector
0074 7102 1004  14         jmp   rom.farjump.bankswitch.call
0075                                                   ; Call function in target bank
0076                       ;------------------------------------------------------
0077                       ; Assert 1 failed before bank-switch
0078                       ;------------------------------------------------------
0079               rom.farjump.bankswitch.failed1:
0080 7104 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7106 FFCE 
0081 7108 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     710A 2026 
0082                       ;------------------------------------------------------
0083                       ; Call function in target bank
0084                       ;------------------------------------------------------
0085               rom.farjump.bankswitch.call:
0086 710C 0694  24         bl    *tmp0                 ; Call function
0087                       ;------------------------------------------------------
0088                       ; Bankswitch back to source bank
0089                       ;------------------------------------------------------
0090               rom.farjump.return:
0091 710E C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     7110 A026 
0092 7112 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0093 7114 1312  14         jeq   rom.farjump.bankswitch.failed2
0094                                                   ; Crash if null-pointer in address
0095               
0096 7116 04F4  30         clr   *tmp0+                ; Remove bank write address from
0097                                                   ; farjump stack
0098               
0099 7118 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0100               
0101 711A 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0102                                                   ; farjump stack
0103               
0104 711C 028B  22         ci    r11,>6000
     711E 6000 
0105 7120 110C  14         jlt   rom.farjump.bankswitch.failed2
0106 7122 028B  22         ci    r11,>7fff
     7124 7FFF 
0107 7126 1509  14         jgt   rom.farjump.bankswitch.failed2
0108               
0109 7128 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     712A A026 
0110               
0114               
0115                       ;------------------------------------------------------
0116                       ; Bankswitch to source 8K ROM bank
0117                       ;------------------------------------------------------
0118               rom.farjump.bankswitch.src.rom8k:
0119 712C 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0120 712E 1009  14         jmp   rom.farjump.exit
0121                       ;------------------------------------------------------
0122                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0123                       ;------------------------------------------------------
0124               rom.farjump.bankswitch.src.advfg99:
0125 7130 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0126 7132 0225  22         ai    tmp1,>0800
     7134 0800 
0127 7136 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0128 7138 1004  14         jmp   rom.farjump.exit
0129                       ;------------------------------------------------------
0130                       ; Assert 2 failed after bank-switch
0131                       ;------------------------------------------------------
0132               rom.farjump.bankswitch.failed2:
0133 713A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     713C FFCE 
0134 713E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7140 2026 
0135                       ;-------------------------------------------------------
0136                       ; Exit
0137                       ;-------------------------------------------------------
0138               rom.farjump.exit:
0139 7142 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0140 7144 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 7146 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 7148 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 714A 045B  20         b     *r11                  ; Return to caller
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
0020 714C 0649  14         dect  stack
0021 714E C64B  30         mov   r11,*stack            ; Save return address
0022 7150 0649  14         dect  stack
0023 7152 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 7154 0649  14         dect  stack
0025 7156 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7158 0204  20         li    tmp0,fb.top
     715A A600 
0030 715C C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     715E A100 
0031 7160 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     7162 A104 
0032 7164 04E0  34         clr   @fb.row               ; Current row=0
     7166 A106 
0033 7168 04E0  34         clr   @fb.column            ; Current column=0
     716A A10C 
0034               
0035 716C 0204  20         li    tmp0,colrow
     716E 0050 
0036 7170 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7172 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 7174 C160  34         mov   @tv.ruler.visible,tmp1
     7176 A010 
0041 7178 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 717A 0204  20         li    tmp0,pane.botrow-2
     717C 001B 
0043 717E 1002  14         jmp   fb.init.cont
0044 7180 0204  20 !       li    tmp0,pane.botrow-1
     7182 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 7184 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     7186 A11A 
0050 7188 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     718A A11C 
0051               
0052 718C 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     718E A022 
0053 7190 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     7192 A110 
0054 7194 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     7196 A116 
0055 7198 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     719A A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 719C 06A0  32         bl    @film
     719E 223A 
0060 71A0 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     71A2 0000 
     71A4 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 71A6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 71A8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 71AA C2F9  30         mov   *stack+,r11           ; Pop r11
0068 71AC 045B  20         b     *r11                  ; Return to caller
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
0046 71AE 0649  14         dect  stack
0047 71B0 C64B  30         mov   r11,*stack            ; Save return address
0048 71B2 0649  14         dect  stack
0049 71B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 71B6 0204  20         li    tmp0,idx.top
     71B8 B000 
0054 71BA C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     71BC A202 
0055               
0056 71BE C120  34         mov   @tv.sams.b000,tmp0
     71C0 A006 
0057 71C2 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     71C4 A500 
0058 71C6 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     71C8 A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 71CA 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     71CC 0004 
0063 71CE C804  38         mov   tmp0,@idx.sams.hipage ; /
     71D0 A504 
0064               
0065 71D2 06A0  32         bl    @_idx.sams.mapcolumn.on
     71D4 3132 
0066                                                   ; Index in continuous memory region
0067               
0068 71D6 06A0  32         bl    @film
     71D8 223A 
0069 71DA B000                   data idx.top,>00,idx.size * 5
     71DC 0000 
     71DE 5000 
0070                                                   ; Clear index
0071               
0072 71E0 06A0  32         bl    @_idx.sams.mapcolumn.off
     71E2 3166 
0073                                                   ; Restore memory window layout
0074               
0075 71E4 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     71E6 A502 
     71E8 A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 71EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 71EC C2F9  30         mov   *stack+,r11           ; Pop r11
0083 71EE 045B  20         b     *r11                  ; Return to caller
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
0096 71F0 0649  14         dect  stack
0097 71F2 C64B  30         mov   r11,*stack            ; Push return address
0098 71F4 0649  14         dect  stack
0099 71F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 71F8 0649  14         dect  stack
0101 71FA C645  30         mov   tmp1,*stack           ; Push tmp1
0102 71FC 0649  14         dect  stack
0103 71FE C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 7200 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     7202 A502 
0108 7204 0205  20         li    tmp1,idx.top
     7206 B000 
0109 7208 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     720A 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 720C 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     720E 257A 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 7210 0584  14         inc   tmp0                  ; Next SAMS index page
0118 7212 0225  22         ai    tmp1,>1000            ; Next memory region
     7214 1000 
0119 7216 0606  14         dec   tmp2                  ; Update loop counter
0120 7218 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 721A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 721C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 721E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7220 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 7222 045B  20         b     *r11                  ; Return to caller
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
0145 7224 0649  14         dect  stack
0146 7226 C64B  30         mov   r11,*stack            ; Push return address
0147 7228 0649  14         dect  stack
0148 722A C644  30         mov   tmp0,*stack           ; Push tmp0
0149 722C 0649  14         dect  stack
0150 722E C645  30         mov   tmp1,*stack           ; Push tmp1
0151 7230 0649  14         dect  stack
0152 7232 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 7234 0649  14         dect  stack
0154 7236 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 7238 0205  20         li    tmp1,idx.top
     723A B000 
0159 723C 0206  20         li    tmp2,5                ; Always 5 pages
     723E 0005 
0160 7240 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     7242 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 7244 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 7246 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7248 257A 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 724A 0225  22         ai    tmp1,>1000            ; Next memory region
     724C 1000 
0171 724E 0606  14         dec   tmp2                  ; Update loop counter
0172 7250 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 7252 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 7254 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7256 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7258 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 725A C2F9  30         mov   *stack+,r11           ; Pop return address
0182 725C 045B  20         b     *r11                  ; Return to caller
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
0206 725E 0649  14         dect  stack
0207 7260 C64B  30         mov   r11,*stack            ; Save return address
0208 7262 0649  14         dect  stack
0209 7264 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 7266 0649  14         dect  stack
0211 7268 C645  30         mov   tmp1,*stack           ; Push tmp1
0212 726A 0649  14         dect  stack
0213 726C C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 726E C184  18         mov   tmp0,tmp2             ; Line number
0218 7270 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 7272 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     7274 0800 
0220               
0221 7276 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 7278 0A16  56         sla   tmp2,1                ; line number * 2
0226 727A C806  38         mov   tmp2,@outparm1        ; Offset index entry
     727C 2F30 
0227               
0228 727E A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     7280 A502 
0229 7282 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     7284 A500 
0230               
0231 7286 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 7288 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     728A A500 
0237 728C C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     728E A006 
0238               
0239 7290 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 7292 0205  20         li    tmp1,>b000            ; Memory window for index page
     7294 B000 
0241               
0242 7296 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     7298 257A 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 729A 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     729C A504 
0249 729E 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 72A0 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     72A2 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 72A4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 72A6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 72A8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 72AA C2F9  30         mov   *stack+,r11           ; Pop r11
0260 72AC 045B  20         b     *r11                  ; Return to caller
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
0022 72AE 0649  14         dect  stack
0023 72B0 C64B  30         mov   r11,*stack            ; Save return address
0024 72B2 0649  14         dect  stack
0025 72B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72B6 0204  20         li    tmp0,edb.top          ; \
     72B8 C000 
0030 72BA C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     72BC A200 
0031 72BE C804  38         mov   tmp0,@edb.next_free.ptr
     72C0 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 72C2 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     72C4 A20A 
0035               
0036 72C6 0204  20         li    tmp0,1
     72C8 0001 
0037 72CA C804  38         mov   tmp0,@edb.lines       ; Lines=1
     72CC A204 
0038               
0039 72CE 0720  34         seto  @edb.block.m1         ; Reset block start line
     72D0 A20C 
0040 72D2 0720  34         seto  @edb.block.m2         ; Reset block end line
     72D4 A20E 
0041               
0042 72D6 0204  20         li    tmp0,txt.newfile      ; "New file"
     72D8 3530 
0043 72DA C804  38         mov   tmp0,@edb.filename.ptr
     72DC A212 
0044               
0045 72DE 0204  20         li    tmp0,txt.filetype.none
     72E0 35E8 
0046 72E2 C804  38         mov   tmp0,@edb.filetype.ptr
     72E4 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 72E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 72E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 72EA 045B  20         b     *r11                  ; Return to caller
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
0022 72EC 0649  14         dect  stack
0023 72EE C64B  30         mov   r11,*stack            ; Save return address
0024 72F0 0649  14         dect  stack
0025 72F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72F4 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     72F6 D000 
0030 72F8 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     72FA A300 
0031               
0032 72FC 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     72FE A302 
0033 7300 0204  20         li    tmp0,4
     7302 0004 
0034 7304 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     7306 A306 
0035 7308 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     730A A308 
0036               
0037 730C 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     730E A316 
0038 7310 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     7312 A318 
0039 7314 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     7316 A326 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7318 06A0  32         bl    @film
     731A 223A 
0044 731C D000             data  cmdb.top,>00,cmdb.size
     731E 0000 
     7320 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7322 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 7324 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 7326 045B  20         b     *r11                  ; Return to caller
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
0022 7328 0649  14         dect  stack
0023 732A C64B  30         mov   r11,*stack            ; Save return address
0024 732C 0649  14         dect  stack
0025 732E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7330 04E0  34         clr   @tv.error.visible     ; Set to hidden
     7332 A028 
0030               
0031 7334 06A0  32         bl    @film
     7336 223A 
0032 7338 A02A                   data tv.error.msg,0,160
     733A 0000 
     733C 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 733E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 7340 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 7342 045B  20         b     *r11                  ; Return to caller
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
0022 7344 0649  14         dect  stack
0023 7346 C64B  30         mov   r11,*stack            ; Save return address
0024 7348 0649  14         dect  stack
0025 734A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 734C 0204  20         li    tmp0,1                ; \ Set default color scheme
     734E 0001 
0030 7350 C804  38         mov   tmp0,@tv.colorscheme  ; /
     7352 A012 
0031               
0032 7354 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     7356 A024 
0033 7358 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     735A 200C 
0034               
0035 735C 0204  20         li    tmp0,fj.bottom
     735E F000 
0036 7360 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     7362 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 7364 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 7366 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 7368 045B  20         b     *r11                  ; Return to caller
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
0065 736A 0649  14         dect  stack
0066 736C C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 736E 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     7370 322E 
0071 7372 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7374 31F0 
0072 7376 06A0  32         bl    @idx.init             ; Initialize index
     7378 30F0 
0073 737A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     737C 308E 
0074 737E 06A0  32         bl    @errline.init         ; Initialize error line
     7380 326A 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 7382 06A0  32         bl    @hchar
     7384 27CC 
0079 7386 0034                   byte 0,52,32,18           ; Remove markers
     7388 2012 
0080 738A 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     738C 2033 
0081 738E FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 7390 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 7392 045B  20         b     *r11                  ; Return to caller
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
0020 7394 0649  14         dect  stack
0021 7396 C64B  30         mov   r11,*stack            ; Save return address
0022 7398 0649  14         dect  stack
0023 739A C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 739C 06A0  32         bl    @mknum                ; Convert unsigned number to string
     739E 29DE 
0028 73A0 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 73A2 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 73A4 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 73A6 0204  20         li    tmp0,unpacked.string
     73A8 2F44 
0034 73AA 04F4  30         clr   *tmp0+                ; Clear string 01
0035 73AC 04F4  30         clr   *tmp0+                ; Clear string 23
0036 73AE 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 73B0 06A0  32         bl    @trimnum              ; Trim unsigned number string
     73B2 2A36 
0039 73B4 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 73B6 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 73B8 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 73BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 73BC C2F9  30         mov   *stack+,r11           ; Pop r11
0048 73BE 045B  20         b     *r11                  ; Return to caller
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
0073 73C0 0649  14         dect  stack
0074 73C2 C64B  30         mov   r11,*stack            ; Push return address
0075 73C4 0649  14         dect  stack
0076 73C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73C8 0649  14         dect  stack
0078 73CA C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73CC 0649  14         dect  stack
0080 73CE C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73D0 0649  14         dect  stack
0082 73D2 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 73D4 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     73D6 2F20 
0087 73D8 D194  26         movb  *tmp0,tmp2            ; /
0088 73DA 0986  56         srl   tmp2,8                ; Right align
0089 73DC C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 73DE 8806  38         c     tmp2,@parm2           ; String length > requested length?
     73E0 2F22 
0092 73E2 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 73E4 C120  34         mov   @parm1,tmp0           ; Get source address
     73E6 2F20 
0097 73E8 C160  34         mov   @parm4,tmp1           ; Get destination address
     73EA 2F26 
0098 73EC 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 73EE 0649  14         dect  stack
0101 73F0 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 73F2 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     73F4 24E4 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 73F6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 73F8 C120  34         mov   @parm2,tmp0           ; Get requested length
     73FA 2F22 
0113 73FC 0A84  56         sla   tmp0,8                ; Left align
0114 73FE C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     7400 2F26 
0115 7402 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 7404 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 7406 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7408 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     740A 2F22 
0122 740C 6187  18         s     tmp3,tmp2             ; |
0123 740E 0586  14         inc   tmp2                  ; /
0124               
0125 7410 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     7412 2F24 
0126 7414 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 7416 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 7418 0606  14         dec   tmp2                  ; Update loop counter
0133 741A 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 741C C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     741E 2F26 
     7420 2F30 
0136 7422 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 7424 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7426 FFCE 
0142 7428 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     742A 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 742C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 742E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 7430 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 7432 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 7434 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 7436 045B  20         b     *r11                  ; Return to caller
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
0174 7438 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     743A 27A0 
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 743C 04E0  34         clr   @bank0.rom            ; Activate bank 0
     743E 6000 
0179 7440 0420  54         blwp  @0                    ; Reset to monitor
     7442 0000 
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
0017 7444 0649  14         dect  stack
0018 7446 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 7448 06A0  32         bl    @sams.layout
     744A 25E6 
0023 744C 33BE                   data mem.sams.layout.data
0024               
0025 744E 06A0  32         bl    @sams.layout.copy
     7450 264A 
0026 7452 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 7454 C820  54         mov   @tv.sams.c000,@edb.sams.page
     7456 A008 
     7458 A216 
0029 745A C820  54         mov   @edb.sams.page,@edb.sams.hipage
     745C A216 
     745E A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 7460 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 7462 045B  20         b     *r11                  ; Return to caller
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
0033 7464 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     7466 003F 
     7468 0243 
     746A 05F4 
     746C 0050 
0034               
0035               romsat:
0036 746E 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     7470 0201 
0037 7472 0000             data  >0000,>0301             ; Current line indicator
     7474 0301 
0038 7476 0820             data  >0820,>0401             ; Current line indicator
     7478 0401 
0039               nosprite:
0040 747A D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 747C 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     747E 0002 
0048 7480 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7482 0003 
0049 7484 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7486 000A 
0050               
0051 7488 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     748A 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 748C C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     748E 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 7490 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7492 000D 
0060 7494 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7496 000E 
0061 7498 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     749A 000F 
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
0117 749C F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     749E F171 
     74A0 1B1F 
     74A2 71B1 
0118 74A4 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     74A6 F0FF 
     74A8 1F1A 
     74AA F1FF 
0119 74AC 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     74AE F0FF 
     74B0 1F12 
     74B2 F1F6 
0120 74B4 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     74B6 1E11 
     74B8 1A17 
     74BA 1E11 
0121 74BC E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     74BE E1FF 
     74C0 1F1E 
     74C2 E1FF 
0122 74C4 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     74C6 1016 
     74C8 1B71 
     74CA 1711 
0123 74CC 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     74CE 1011 
     74D0 F1F1 
     74D2 1F11 
0124 74D4 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     74D6 A1FF 
     74D8 1F1F 
     74DA F11F 
0125 74DC 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     74DE 12FF 
     74E0 1B12 
     74E2 12FF 
0126 74E4 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     74E6 E1FF 
     74E8 1B1F 
     74EA F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 74EC 0007             byte  0,7,12,25               ; \   Default tab positions as used
     74EE 0C19 
0131 74F0 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     74F2 3B4F 
0132 74F4 FF00             byte  >ff,0,0,0               ; |
     74F6 0000 
0133 74F8 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     74FA 0000 
0134 74FC 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     74FE 0000 
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
0012 7500 0B53             byte  11
0013 7501 ....             text  'STEVIE 1.1P'
0014                       even
0015               
0016               txt.about.build
0017 750C 4C42             byte  76
0018 750D ....             text  'Build: 210724-1384146 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 755A 012C             byte  1
0024 755B ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 755C 0520             byte  5
0029 755D ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 7562 034F             byte  3
0034 7563 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 7566 0349             byte  3
0039 7567 ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 756A 012A             byte  1
0044 756B ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 756C 0A4C             byte  10
0049 756D ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 7578 0A53             byte  10
0054 7579 ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 7584 1244             byte  18
0059 7585 ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 7598 1143             byte  17
0064 7599 ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 75AA 104D             byte  16
0069 75AB ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 75BC 1D53             byte  29
0074 75BD ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 75DA 0846             byte  8
0079 75DB ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 75E4 026B             byte  2
0084 75E5 ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 75E8 054C             byte  5
0089 75E9 ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 75EE 0A5B             byte  10
0094 75EF ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 75FA 0444             byte  4
0099 75FB ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 7600 034D             byte  3
0104 7601 ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 7604 034D             byte  3
0109 7605 ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 7608 0746             byte  7
0114 7609 ....             text  'F9=Menu'
0115                       even
0116               
0117               txt.keys.block
0118 7610 3342             byte  51
0119 7611 ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0120                       even
0121               
0122 7644 ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 764E ....                        text    '.........'
0125                                  byte    19
0126 7658 ....                        text    '.........'
0127                                  byte    20
0128 7662 ....                        text    '.........'
0129                                  byte    21
0130 766C ....                        text    '.........'
0131                                  byte    22
0132 7676 ....                        text    '.........'
0133                                  byte    23
0134 7680 ....                        text    '.........'
0135                                  byte    24
0136 768A ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139 7694 020E     txt.alpha.down     data >020e,>0f00
     7696 0F00 
0140 7698 0110     txt.vertline       data >0110
0141 769A 011C     txt.keymarker      byte 1,28
0142               
0143               txt.ws1
0144 769C 0120             byte  1
0145 769D ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 769E 0220             byte  2
0150 769F ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 76A2 0320             byte  3
0155 76A3 ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 76A6 0420             byte  4
0160 76A7 ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 76AC 0520             byte  5
0165 76AD ....             text  '     '
0166                       even
0167               
0168      35E8     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 76B2 1301     txt.head.load      byte 19,1,3
     76B4 0320 
0175 76B5 ....                        text ' Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 76C6 3D53             byte  61
0179 76C7 ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 7704 3C46     txt.keys.load      byte 60
0184 7705 ....                        text 'File'
0185                                  byte 27
0186 770A ....                        text 'Open: F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End '
0187               
0188 7742 3D46     txt.keys.load2     byte 61
0189 7743 ....                        text 'File'
0190                                  byte 27
0191 7748 ....                        text 'Open: F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End '
0192               
0193               ;--------------------------------------------------------------
0194               ; Dialog Save DV 80 file
0195               ;--------------------------------------------------------------
0196 7782 0103     txt.head.save      byte 19,1,3
0197 7784 ....                        text ' Save DV80 file '
0198 7794 0223                        byte 2
0199 7796 0103     txt.head.save2     byte 35,1,3,32
     7798 2053 
0200 7799 ....                        text 'Save marked block to DV80 file '
0201 77B8 0201                        byte 2
0202               txt.hint.save
0203                       byte  1
0204 77BA ....             text  ' '
0205                       even
0206               
0207               
0208 77BC 2F46     txt.keys.save      byte 47
0209 77BD ....                        text 'File'
0210                                  byte 27
0211 77C2 ....                        text 'Save: F9=Back  F3=Clear  F-H=Home  F-L=End'
0212               
0213               ;--------------------------------------------------------------
0214               ; Dialog "Unsaved changes"
0215               ;--------------------------------------------------------------
0216 77EC 1401     txt.head.unsaved   byte 20,1,3
     77EE 0320 
0217 77EF ....                        text ' Unsaved changes '
0218 7800 0221                        byte 2
0219               txt.info.unsaved
0220                       byte  33
0221 7802 ....             text  'Warning! Unsaved changes in file.'
0222                       even
0223               
0224               txt.hint.unsaved
0225 7824 2A50             byte  42
0226 7825 ....             text  'Press F6 to proceed or ENTER to save file.'
0227                       even
0228               
0229               txt.keys.unsaved
0230 7850 2843             byte  40
0231 7851 ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0232                       even
0233               
0234               
0235               ;--------------------------------------------------------------
0236               ; Dialog "About"
0237               ;--------------------------------------------------------------
0238 787A 0A01     txt.head.about     byte 10,1,3
     787C 0320 
0239 787D ....                        text ' About '
0240 7884 0200                        byte 2
0241               
0242               txt.info.about
0243                       byte  0
0244 7886 ....             text
0245                       even
0246               
0247               txt.hint.about
0248 7886 1D50             byte  29
0249 7887 ....             text  'Press F9 to return to editor.'
0250                       even
0251               
0252 78A4 2148     txt.keys.about     byte 33
0253 78A5 ....                        text 'Help: F9=Back  '
0254 78B4 0E0F                        byte 14,15
0255 78B6 ....                        text '=Alpha Lock down'
0256               
0257               
0258               ;--------------------------------------------------------------
0259               ; Dialog "Menu"
0260               ;--------------------------------------------------------------
0261 78C6 1001     txt.head.menu      byte 16,1,3
     78C8 0320 
0262 78C9 ....                        text ' Stevie 1.1P '
0263 78D6 0210                        byte 2
0264               
0265               txt.info.menu
0266                       byte  16
0267 78D8 ....             text  'File  Help  Quit'
0268                       even
0269               
0270 78E8 0006     pos.info.menu      byte 0,6,12,>ff
     78EA 0CFF 
0271               txt.hint.menu
0272 78EC 2650             byte  38
0273 78ED ....             text  'Press F,H,Q or F9 to return to editor.'
0274                       even
0275               
0276               txt.keys.menu
0277 7914 0D4D             byte  13
0278 7915 ....             text  'Menu: F9=Back'
0279                       even
0280               
0281               
0282               
0283               ;--------------------------------------------------------------
0284               ; Dialog "File"
0285               ;--------------------------------------------------------------
0286 7922 0901     txt.head.file      byte 9,1,3
     7924 0320 
0287 7925 ....                        text ' File '
0288                                  byte 2
0289               
0290               txt.info.file
0291 792C 0F4E             byte  15
0292 792D ....             text  'New  Open  Save'
0293                       even
0294               
0295 793C 0005     pos.info.file      byte 0,5,11,>ff
     793E 0BFF 
0296               txt.hint.file
0297 7940 2650             byte  38
0298 7941 ....             text  'Press N,O,S or F9 to return to editor.'
0299                       even
0300               
0301               txt.keys.file
0302 7968 0D46             byte  13
0303 7969 ....             text  'File: F9=Back'
0304                       even
0305               
0306               
0307               
0308               
0309               ;--------------------------------------------------------------
0310               ; Strings for error line pane
0311               ;--------------------------------------------------------------
0312               txt.ioerr.load
0313 7976 2049             byte  32
0314 7977 ....             text  'I/O error. Failed loading file: '
0315                       even
0316               
0317               txt.ioerr.save
0318 7998 2049             byte  32
0319 7999 ....             text  'I/O error. Failed saving file:  '
0320                       even
0321               
0322               txt.memfull.load
0323 79BA 4049             byte  64
0324 79BB ....             text  'Index memory full. Could not fully load file into editor buffer.'
0325                       even
0326               
0327               txt.io.nofile
0328 79FC 2149             byte  33
0329 79FD ....             text  'I/O error. No filename specified.'
0330                       even
0331               
0332               txt.block.inside
0333 7A1E 3445             byte  52
0334 7A1F ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0335                       even
0336               
0337               
0338               ;--------------------------------------------------------------
0339               ; Strings for command buffer
0340               ;--------------------------------------------------------------
0341               txt.cmdb.prompt
0342 7A54 013E             byte  1
0343 7A55 ....             text  '>'
0344                       even
0345               
0346               txt.colorscheme
0347 7A56 0D43             byte  13
0348 7A57 ....             text  'Color scheme:'
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
0022 7A64 DEAD             data  >dead,>beef,>dead,>beef
     7A66 BEEF 
     7A68 DEAD 
     7A6A BEEF 
**** **** ****     > stevie_b0.asm.1384146
0133               
0137 7A6C 39AE                   data $                ; Bank 0 ROM size OK.
0139                       ;------------------------------------------------------
0140                       ; Bank specific vector table
0141                       ;------------------------------------------------------
0145 7A6E 39B0                   data $                ; Bank 0 ROM size OK.
0147               
0148               *--------------------------------------------------------------
0149               * Video mode configuration for SP2
0150               *--------------------------------------------------------------
0151      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0152      0004     spfbck  equ   >04                   ; Screen background color.
0153      33A6     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0154      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0155      0050     colrow  equ   80                    ; Columns per row
0156      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0157      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0158      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0159      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

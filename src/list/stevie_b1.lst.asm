XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.56185
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210909-56185
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
**** **** ****     > stevie_b1.asm.56185
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
**** **** ****     > stevie_b1.asm.56185
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
0013               *     2000-2f1f    3872           spectra2 core library
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
0046               *     eef0-efef     256           Backup scratchpad memory
0047               *     eff0-efff      16           Farjump return stack (trampolines)
0048               *     f000-ffff    4096           spectra2 extended library
0049               *
0050               *
0051               * CARTRIDGE SPACE (6000-7fff)
0052               *
0053               *     Mem range   Bytes    BANK   Purpose
0054               *     =========   =====    ====   ==================================
0055               *     6000-633f               0   Cartridge header
0056               *     6040-7fff               0   SP2 library + Stevie library
0057               *                                 relocated to RAM space
0058               *     ..............................................................
0059               *     6000-633f               1   Cartridge header
0060               *     6040-7fbf               1   Stevie program code
0061               *     7fc0-7fff      64       1   Vector table (32 vectors)
0062               *     ..............................................................
0063               *     6000-633f               2   Cartridge header
0064               *     6040-7fbf               2   Stevie program code
0065               *     7fc0-7fff      64       2   Vector table (32 vectors)
0066               *     ..............................................................
0067               *     6000-633f               3   Cartridge header
0068               *     6040-7fbf               3   Stevie program code
0069               *     7fc0-7fff      64       3   Vector table (32 vectors)
0070               *     ..............................................................
0071               *     6000-633f               4   Cartridge header
0072               *     6040-7fbf               4   Stevie program code
0073               *     7fc0-7fff      64       4   Vector table (32 vectors)
0074               *     ..............................................................
0075               *     6000-633f               5   Cartridge header
0076               *     6040-7fbf               5   Stevie program code
0077               *     7fc0-7fff      64       5   Vector table (32 vectors)
0078               *     ..............................................................
0079               *     6000-633f               6   Cartridge header
0080               *     6040-7fbf               6   Stevie program code
0081               *     7fc0-7fff      64       6   Vector table (32 vectors)
0082               *     ..............................................................
0083               *     6000-633f               7   Cartridge header
0084               *     6040-7fbf               7   SP2 library in cartridge space
0085               *     7fc0-7fff      64       7   Vector table (32 vectors)
0086               *
0087               *
0088               *
0089               * VDP RAM F18a (0000-47ff)
0090               *
0091               *     Mem range   Bytes    Hex    Purpose
0092               *     =========   =====   =====   =================================
0093               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0094               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0095               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0096               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0097               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0098               *                                      (Position based colors F18a, 80 colums)
0099               *     2180                        SAT: Sprite Attribute Table
0100               *                                      (Cursor in F18a, 80 cols mode)
0101               *     2800                        SPT: Sprite Pattern Table
0102               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0103               *===============================================================================
0104               
0105               *--------------------------------------------------------------
0106               * Graphics mode selection
0107               *--------------------------------------------------------------
0109               
0110      001D     pane.botrow               equ  29      ; Bottom row on screen
0111               
0117               *--------------------------------------------------------------
0118               * Stevie Dialog / Pane specific equates
0119               *--------------------------------------------------------------
0120      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0121      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0122               ;-----------------------------------------------------------------
0123               ;   Dialog ID's >= 100 indicate that command prompt should be
0124               ;   hidden and no characters added to CMDB keyboard buffer
0125               ;-----------------------------------------------------------------
0126      000A     id.dialog.load            equ  10      ; "Load DV80 file"
0127      000B     id.dialog.save            equ  11      ; "Save DV80 file"
0128      000C     id.dialog.saveblock       equ  12      ; "Save codeblock to DV80 file"
0129      0064     id.dialog.menu            equ  100     ; "Stevie Menu"
0130      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0131      0066     id.dialog.block           equ  102     ; "Block move/copy/delete"
0132      0067     id.dialog.about           equ  103     ; "About"
0133      0068     id.dialog.file            equ  104     ; "File"
0134      0069     id.dialog.basic           equ  105     ; "Basic"
0135               *--------------------------------------------------------------
0136               * Stevie specific equates
0137               *--------------------------------------------------------------
0138      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0139      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0140      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0141      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0142      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0143      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0144                                                      ; VDP TAT address of 1st CMDB row
0145      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0146                                                      ; VDP SIT size 80 columns, 24/30 rows
0147      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0148      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0149               *--------------------------------------------------------------
0150               * SPECTRA2 / Stevie startup options
0151               *--------------------------------------------------------------
0152      0001     debug                     equ  1       ; Turn on spectra2 debugging
0153      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0154      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0155      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0156      7E00     cpu.scrpad.tgt            equ  >7e00   ; Scratchpad dump of OS Monitor in bank3
0157               *--------------------------------------------------------------
0158               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0159               *--------------------------------------------------------------
0160      2F20     parm1             equ  >2f20           ; Function parameter 1
0161      2F22     parm2             equ  >2f22           ; Function parameter 2
0162      2F24     parm3             equ  >2f24           ; Function parameter 3
0163      2F26     parm4             equ  >2f26           ; Function parameter 4
0164      2F28     parm5             equ  >2f28           ; Function parameter 5
0165      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0166      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0167      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0168      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0169      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0170      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0171      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0172      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0173      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0174      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0175      2F3E     keyrptcnt         equ  >2f3e           ; Key repeat-count (auto-repeat function)
0176      2F40     keycode1          equ  >2f40           ; Current key scanned
0177      2F42     keycode2          equ  >2f42           ; Previous key scanned
0178      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0179      2F4A     timers            equ  >2f4a           ; Timer table
0180      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0181      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0182               *--------------------------------------------------------------
0183               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0184               *--------------------------------------------------------------
0185      A000     tv.top            equ  >a000           ; Structure begin
0186      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0187      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0188      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0189      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0190      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0191      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0192      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0193      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0194      A010     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0195      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0196      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0197      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0198      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0199      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0200      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0201      A01E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0202      A020     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0203      A022     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0204      A024     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0205      A026     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0206      A028     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0207      A02A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0208      A0CA     tv.free           equ  tv.top + 202    ; End of structure
0209               *--------------------------------------------------------------
0210               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0211               *--------------------------------------------------------------
0212      A100     fb.struct         equ  >a100           ; Structure begin
0213      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0214      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0215      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0216                                                      ; line X in editor buffer).
0217      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0218                                                      ; (offset 0 .. @fb.scrrows)
0219      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0220      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0221      A10C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0222      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0223      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0224      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0225      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0226      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0227      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0228      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0229      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0230      A11E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0231      A16E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0232      A1BE     fb.free           equ  fb.struct + 190 ; End of structure
0233               *--------------------------------------------------------------
0234               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0235               *--------------------------------------------------------------
0236      A200     edb.struct        equ  >a200           ; Begin structure
0237      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0238      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0239      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0240      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0241      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0242      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0243      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0244      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0245      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0246      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0247                                                      ; with current filename.
0248      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0249                                                      ; with current file type.
0250      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0251      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0252      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0253                                                      ; for filename, but not always used.
0254      A269     edb.free          equ  edb.struct + 105; End of structure
0255               *--------------------------------------------------------------
0256               * Command buffer structure            @>a300-a3ff   (256 bytes)
0257               *--------------------------------------------------------------
0258      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0259      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0260      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0261      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0262      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0263      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0264      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0265      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0266      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0267      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0268      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0269      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0270      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0271      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0272      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0273      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0274      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0275      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0276      A322     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0277      A324     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0278      A326     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0279      A328     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0280      A329     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0281      A379     cmdb.free         equ  cmdb.struct +121; End of structure
0282               *--------------------------------------------------------------
0283               * File handle structure               @>a400-a4ff   (256 bytes)
0284               *--------------------------------------------------------------
0285      A400     fh.struct         equ  >a400           ; stevie file handling structures
0286               ;***********************************************************************
0287               ; ATTENTION
0288               ; The dsrlnk variables must form a continuous memory block and keep
0289               ; their order!
0290               ;***********************************************************************
0291      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0292      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0293      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0294      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0295      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0296      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0297      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0298      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0299      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0300      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0301      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0302      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0303      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0304      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0305      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0306      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0307      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0308      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0309      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0310      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0311      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0312      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0313      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0314      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0315      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0316      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0317      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0318      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0319      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0320      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0321      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0322      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0323               *--------------------------------------------------------------
0324               * Index structure                     @>a500-a5ff   (256 bytes)
0325               *--------------------------------------------------------------
0326      A500     idx.struct        equ  >a500           ; stevie index structure
0327      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0328      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0329      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0330               *--------------------------------------------------------------
0331               * Frame buffer                        @>a600-afff  (2560 bytes)
0332               *--------------------------------------------------------------
0333      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0334      0960     fb.size           equ  80*30           ; Frame buffer size
0335               *--------------------------------------------------------------
0336               * Index                               @>b000-bfff  (4096 bytes)
0337               *--------------------------------------------------------------
0338      B000     idx.top           equ  >b000           ; Top of index
0339      1000     idx.size          equ  4096            ; Index size
0340               *--------------------------------------------------------------
0341               * Editor buffer                       @>c000-cfff  (4096 bytes)
0342               *--------------------------------------------------------------
0343      C000     edb.top           equ  >c000           ; Editor buffer high memory
0344      1000     edb.size          equ  4096            ; Editor buffer size
0345               *--------------------------------------------------------------
0346               * Command history buffer              @>d000-dfff  (4096 bytes)
0347               *--------------------------------------------------------------
0348      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0349      1000     cmdb.size         equ  4096            ; Command buffer size
0350               *--------------------------------------------------------------
0351               * Heap                                @>e000-ebff  (3072 bytes)
0352               *--------------------------------------------------------------
0353      E000     heap.top          equ  >e000           ; Top of heap
0354               *--------------------------------------------------------------
0355               * Farjump return stack                @>ec00-efff  (1024 bytes)
0356               *--------------------------------------------------------------
0357      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b1.asm.56185
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
0045 6011 ....             text  'STEVIE 1.1S'
0046                       even
0047               
0049               
**** **** ****     > stevie_b1.asm.56185
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6040
0035 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0036               ***************************************************************
0037               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0038               ********|*****|*********************|**************************
0039                       aorg  >2000
0040                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     2084 2E58 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 2304 
0078 208A 21EA                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 236C 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 229A 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 244E 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 29DC 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 244E 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 29DC 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 244E 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 244E 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 244E 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 244E 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 26DA 
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
     210C 29E6 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26F0 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 242A 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26F0 
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
     2132 242A 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 29E6 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 2958 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26F0 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 242A 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26F0 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 242A 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 26E0 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D56 
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
0259 21D2 1642             byte  22
0260 21D3 ....             text  'Build-ID  210909-56185'
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
0007 21EA 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21EC 000E 
     21EE 0106 
     21F0 0204 
     21F2 0020 
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
0033 21F4 00E2     tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
     21F6 000C 
     21F8 0006 
     21FA 0004 
     21FC 0020 
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
0060 21FE 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2200 000E 
     2202 0106 
     2204 00F4 
     2206 0028 
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
0086 2208 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220A 003F 
     220C 0240 
     220E 03F4 
     2210 0050 
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
0112 2212 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2214 003F 
     2216 0240 
     2218 03F4 
     221A 0050 
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
0013 221C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 221E 16FD             data  >16fd                 ; |         jne   mcloop
0015 2220 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2222 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2224 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 2226 0201  20         li    r1,mccode             ; Machinecode to patch
     2228 221C 
0037 222A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     222C 8322 
0038 222E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2230 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2232 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2234 045B  20         b     *r11                  ; Return to caller
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
0056 2236 C0F9  30 popr3   mov   *stack+,r3
0057 2238 C0B9  30 popr2   mov   *stack+,r2
0058 223A C079  30 popr1   mov   *stack+,r1
0059 223C C039  30 popr0   mov   *stack+,r0
0060 223E C2F9  30 poprt   mov   *stack+,r11
0061 2240 045B  20         b     *r11
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
0085 2242 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2244 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 2246 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 2248 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 224A 1604  14         jne   filchk                ; No, continue checking
0093               
0094 224C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     224E FFCE 
0095 2250 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2252 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2254 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2256 830B 
     2258 830A 
0100               
0101 225A 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     225C 0001 
0102 225E 1602  14         jne   filchk2
0103 2260 DD05  32         movb  tmp1,*tmp0+
0104 2262 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2264 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2266 0002 
0109 2268 1603  14         jne   filchk3
0110 226A DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 226C DD05  32         movb  tmp1,*tmp0+
0112 226E 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2270 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2272 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2274 0001 
0118 2276 1305  14         jeq   fil16b
0119 2278 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 227A 0606  14         dec   tmp2
0121 227C 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     227E 0002 
0122 2280 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2282 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2284 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2286 0001 
0128 2288 1301  14         jeq   dofill
0129 228A 0606  14         dec   tmp2                  ; Make TMP2 even
0130 228C CD05  34 dofill  mov   tmp1,*tmp0+
0131 228E 0646  14         dect  tmp2
0132 2290 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2292 C1C7  18         mov   tmp3,tmp3
0137 2294 1301  14         jeq   fil.exit
0138 2296 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2298 045B  20         b     *r11
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
0159 229A C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 229C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 229E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A0 0264  22 xfilv   ori   tmp0,>4000
     22A2 4000 
0166 22A4 06C4  14         swpb  tmp0
0167 22A6 D804  38         movb  tmp0,@vdpa
     22A8 8C02 
0168 22AA 06C4  14         swpb  tmp0
0169 22AC D804  38         movb  tmp0,@vdpa
     22AE 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B0 020F  20         li    r15,vdpw              ; Set VDP write address
     22B2 8C00 
0174 22B4 06C5  14         swpb  tmp1
0175 22B6 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B8 22C0 
     22BA 8320 
0176 22BC 0460  28         b     @mcloop               ; Write data to VDP
     22BE 8320 
0177               *--------------------------------------------------------------
0181 22C0 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22C2 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C4 4000 
0202 22C6 06C4  14 vdra    swpb  tmp0
0203 22C8 D804  38         movb  tmp0,@vdpa
     22CA 8C02 
0204 22CC 06C4  14         swpb  tmp0
0205 22CE D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D0 8C02 
0206 22D2 045B  20         b     *r11                  ; Exit
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
0217 22D4 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22D6 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D8 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22DA 4000 
0223 22DC 06C4  14         swpb  tmp0                  ; \
0224 22DE D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E0 8C02 
0225 22E2 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E4 D804  38         movb  tmp0,@vdpa            ; /
     22E6 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E8 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22EA D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22EC 045B  20         b     *r11                  ; Exit
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
0251 22EE C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F0 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F2 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F4 8C02 
0257 22F6 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F8 D804  38         movb  tmp0,@vdpa            ; /
     22FA 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22FC D120  34         movb  @vdpr,tmp0            ; Read byte
     22FE 8800 
0263 2300 0984  56         srl   tmp0,8                ; Right align
0264 2302 045B  20         b     *r11                  ; Exit
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
0283 2304 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 2306 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2308 C144  18         mov   tmp0,tmp1
0289 230A 05C5  14         inct  tmp1
0290 230C D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 230E 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2310 FF00 
0292 2312 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2314 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2316 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2318 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     231A 8000 
0298 231C 0206  20         li    tmp2,8
     231E 0008 
0299 2320 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2322 830B 
0300 2324 06C5  14         swpb  tmp1
0301 2326 D805  38         movb  tmp1,@vdpa
     2328 8C02 
0302 232A 06C5  14         swpb  tmp1
0303 232C D805  38         movb  tmp1,@vdpa
     232E 8C02 
0304 2330 0225  22         ai    tmp1,>0100
     2332 0100 
0305 2334 0606  14         dec   tmp2
0306 2336 16F4  14         jne   vidta1                ; Next register
0307 2338 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     233A 833A 
0308 233C 045B  20         b     *r11
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
0325 233E C13B  30 putvr   mov   *r11+,tmp0
0326 2340 0264  22 putvrx  ori   tmp0,>8000
     2342 8000 
0327 2344 06C4  14         swpb  tmp0
0328 2346 D804  38         movb  tmp0,@vdpa
     2348 8C02 
0329 234A 06C4  14         swpb  tmp0
0330 234C D804  38         movb  tmp0,@vdpa
     234E 8C02 
0331 2350 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2352 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2354 C10E  18         mov   r14,tmp0
0341 2356 0984  56         srl   tmp0,8
0342 2358 06A0  32         bl    @putvrx               ; Write VR#0
     235A 2340 
0343 235C 0204  20         li    tmp0,>0100
     235E 0100 
0344 2360 D820  54         movb  @r14lb,@tmp0lb
     2362 831D 
     2364 8309 
0345 2366 06A0  32         bl    @putvrx               ; Write VR#1
     2368 2340 
0346 236A 0458  20         b     *tmp4                 ; Exit
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
0360 236C C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 236E 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2370 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2372 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2374 7FFF 
0364 2376 2120  38         coc   @wbit0,tmp0
     2378 2020 
0365 237A 1604  14         jne   ldfnt1
0366 237C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     237E 8000 
0367 2380 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2382 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2384 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2386 23EE 
0372 2388 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     238A 9C02 
0373 238C 06C4  14         swpb  tmp0
0374 238E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2390 9C02 
0375 2392 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2394 9800 
0376 2396 06C5  14         swpb  tmp1
0377 2398 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     239A 9800 
0378 239C 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 239E D805  38         movb  tmp1,@grmwa
     23A0 9C02 
0383 23A2 06C5  14         swpb  tmp1
0384 23A4 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23A6 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A8 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23AA 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23AC 22C2 
0390 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B0 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B2 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B4 7FFF 
0393 23B6 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B8 23F0 
0394 23BA C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23BC 23F2 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23BE 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C0 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C2 D120  34         movb  @grmrd,tmp0
     23C4 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23C6 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C8 2020 
0405 23CA 1603  14         jne   ldfnt3                ; No, so skip
0406 23CC D1C4  18         movb  tmp0,tmp3
0407 23CE 0917  56         srl   tmp3,1
0408 23D0 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D2 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D4 8C00 
0413 23D6 0606  14         dec   tmp2
0414 23D8 16F2  14         jne   ldfnt2
0415 23DA 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23DC 020F  20         li    r15,vdpw              ; Set VDP write address
     23DE 8C00 
0417 23E0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E2 7FFF 
0418 23E4 0458  20         b     *tmp4                 ; Exit
0419 23E6 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E8 2000 
     23EA 8C00 
0420 23EC 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23EE 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F0 0200 
     23F2 0000 
0425 23F4 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23F6 01C0 
     23F8 0101 
0426 23FA 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23FC 02A0 
     23FE 0101 
0427 2400 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2402 00E0 
     2404 0101 
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
0445 2406 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2408 C3A0  34         mov   @wyx,r14              ; Get YX
     240A 832A 
0447 240C 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 240E 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2410 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2412 C3A0  34         mov   @wyx,r14              ; Get YX
     2414 832A 
0454 2416 024E  22         andi  r14,>00ff             ; Remove Y
     2418 00FF 
0455 241A A3CE  18         a     r14,r15               ; pos = pos + X
0456 241C A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     241E 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2420 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2422 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2424 020F  20         li    r15,vdpw              ; VDP write address
     2426 8C00 
0463 2428 045B  20         b     *r11
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
0481 242A C17B  30 putstr  mov   *r11+,tmp1
0482 242C D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 242E C1CB  18 xutstr  mov   r11,tmp3
0484 2430 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2432 2406 
0485 2434 C2C7  18         mov   tmp3,r11
0486 2436 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 2438 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 243A 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 243C 0286  22         ci    tmp2,255              ; Length > 255 ?
     243E 00FF 
0494 2440 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 2442 0460  28         b     @xpym2v               ; Display string
     2444 2498 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 2446 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2448 FFCE 
0501 244A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     244C 2026 
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
0517 244E C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2450 832A 
0518 2452 0460  28         b     @putstr
     2454 242A 
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
0539 2456 0649  14         dect  stack
0540 2458 C64B  30         mov   r11,*stack            ; Save return address
0541 245A 0649  14         dect  stack
0542 245C C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 245E D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2460 0987  56         srl   tmp3,8                ; Right align
0549               
0550 2462 0649  14         dect  stack
0551 2464 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 2466 0649  14         dect  stack
0553 2468 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 246A 0649  14         dect  stack
0555 246C C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 246E 06A0  32         bl    @xutst0               ; Display string
     2470 242C 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 2472 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 2474 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 2476 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 2478 06A0  32         bl    @down                 ; Move cursor down
     247A 26E0 
0566               
0567 247C A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 247E 0585  14         inc   tmp1                  ; Consider length byte
0569 2480 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     2482 2002 
0570 2484 1301  14         jeq   !                     ; Yes, skip adjustment
0571 2486 0585  14         inc   tmp1                  ; Make address even
0572 2488 0606  14 !       dec   tmp2
0573 248A 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 248C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 248E C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2490 045B  20         b     *r11                  ; Return
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
0020 2492 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2494 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2496 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 2498 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 249A 1604  14         jne   !                     ; No, continue
0028               
0029 249C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     249E FFCE 
0030 24A0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24A2 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 24A4 0264  22 !       ori   tmp0,>4000
     24A6 4000 
0035 24A8 06C4  14         swpb  tmp0
0036 24AA D804  38         movb  tmp0,@vdpa
     24AC 8C02 
0037 24AE 06C4  14         swpb  tmp0
0038 24B0 D804  38         movb  tmp0,@vdpa
     24B2 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24B4 020F  20         li    r15,vdpw              ; Set VDP write address
     24B6 8C00 
0043 24B8 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24BA 24C2 
     24BC 8320 
0044 24BE 0460  28         b     @mcloop               ; Write data to VDP and return
     24C0 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24C2 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 24C4 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24C6 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24C8 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24CA 06C4  14 xpyv2m  swpb  tmp0
0027 24CC D804  38         movb  tmp0,@vdpa
     24CE 8C02 
0028 24D0 06C4  14         swpb  tmp0
0029 24D2 D804  38         movb  tmp0,@vdpa
     24D4 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24D6 020F  20         li    r15,vdpr              ; Set VDP read address
     24D8 8800 
0034 24DA C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24DC 24E4 
     24DE 8320 
0035 24E0 0460  28         b     @mcloop               ; Read data from VDP
     24E2 8320 
0036 24E4 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24E6 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24E8 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24EA C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24EC C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24EE 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24F0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24F2 FFCE 
0034 24F4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24F6 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24F8 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24FA 0001 
0039 24FC 1603  14         jne   cpym0                 ; No, continue checking
0040 24FE DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 2500 04C6  14         clr   tmp2                  ; Reset counter
0042 2502 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 2504 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     2506 7FFF 
0047 2508 C1C4  18         mov   tmp0,tmp3
0048 250A 0247  22         andi  tmp3,1
     250C 0001 
0049 250E 1618  14         jne   cpyodd                ; Odd source address handling
0050 2510 C1C5  18 cpym1   mov   tmp1,tmp3
0051 2512 0247  22         andi  tmp3,1
     2514 0001 
0052 2516 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2518 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     251A 2020 
0057 251C 1605  14         jne   cpym3
0058 251E C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2520 2546 
     2522 8320 
0059 2524 0460  28         b     @mcloop               ; Copy memory and exit
     2526 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 2528 C1C6  18 cpym3   mov   tmp2,tmp3
0064 252A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     252C 0001 
0065 252E 1301  14         jeq   cpym4
0066 2530 0606  14         dec   tmp2                  ; Make TMP2 even
0067 2532 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 2534 0646  14         dect  tmp2
0069 2536 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2538 C1C7  18         mov   tmp3,tmp3
0074 253A 1301  14         jeq   cpymz
0075 253C D554  38         movb  *tmp0,*tmp1
0076 253E 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2540 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     2542 8000 
0081 2544 10E9  14         jmp   cpym2
0082 2546 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 2548 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 254A 0649  14         dect  stack
0065 254C C64B  30         mov   r11,*stack            ; Push return address
0066 254E 0649  14         dect  stack
0067 2550 C640  30         mov   r0,*stack             ; Push r0
0068 2552 0649  14         dect  stack
0069 2554 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 2556 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2558 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 255A 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     255C 4000 
0077 255E C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2560 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2562 020C  20         li    r12,>1e00             ; SAMS CRU address
     2564 1E00 
0082 2566 04C0  14         clr   r0
0083 2568 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 256A D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 256C D100  18         movb  r0,tmp0
0086 256E 0984  56         srl   tmp0,8                ; Right align
0087 2570 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2572 833C 
0088 2574 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 2576 C339  30         mov   *stack+,r12           ; Pop r12
0094 2578 C039  30         mov   *stack+,r0            ; Pop r0
0095 257A C2F9  30         mov   *stack+,r11           ; Pop return address
0096 257C 045B  20         b     *r11                  ; Return to caller
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
0131 257E C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2580 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2582 0649  14         dect  stack
0135 2584 C64B  30         mov   r11,*stack            ; Push return address
0136 2586 0649  14         dect  stack
0137 2588 C640  30         mov   r0,*stack             ; Push r0
0138 258A 0649  14         dect  stack
0139 258C C64C  30         mov   r12,*stack            ; Push r12
0140 258E 0649  14         dect  stack
0141 2590 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2592 0649  14         dect  stack
0143 2594 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2596 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2598 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 259A 0284  22         ci    tmp0,255              ; Crash if page > 255
     259C 00FF 
0153 259E 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 25A0 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     25A2 001E 
0158 25A4 150A  14         jgt   !
0159 25A6 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25A8 0004 
0160 25AA 1107  14         jlt   !
0161 25AC 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25AE 0012 
0162 25B0 1508  14         jgt   sams.page.set.switch_page
0163 25B2 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25B4 0006 
0164 25B6 1501  14         jgt   !
0165 25B8 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25BA C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25BC FFCE 
0170 25BE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25C0 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25C2 020C  20         li    r12,>1e00             ; SAMS CRU address
     25C4 1E00 
0176 25C6 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25C8 06C0  14         swpb  r0                    ; LSB to MSB
0178 25CA 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25CC D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25CE 4000 
0180 25D0 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25D6 C339  30         mov   *stack+,r12           ; Pop r12
0188 25D8 C039  30         mov   *stack+,r0            ; Pop r0
0189 25DA C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25DC 045B  20         b     *r11                  ; Return to caller
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
0204 25DE 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E0 1E00 
0205 25E2 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25E4 045B  20         b     *r11                  ; Return to caller
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
0227 25E6 020C  20         li    r12,>1e00             ; SAMS CRU address
     25E8 1E00 
0228 25EA 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25EC 045B  20         b     *r11                  ; Return to caller
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
0260 25EE C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25F0 0649  14         dect  stack
0263 25F2 C64B  30         mov   r11,*stack            ; Save return address
0264 25F4 0649  14         dect  stack
0265 25F6 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25F8 0649  14         dect  stack
0267 25FA C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25FC 0649  14         dect  stack
0269 25FE C646  30         mov   tmp2,*stack           ; Save tmp2
0270 2600 0649  14         dect  stack
0271 2602 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 2604 0206  20         li    tmp2,8                ; Set loop counter
     2606 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 2608 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 260A C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 260C 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     260E 2582 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 2610 0606  14         dec   tmp2                  ; Next iteration
0288 2612 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 2614 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     2616 25DE 
0294                                                   ; / activating changes.
0295               
0296 2618 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 261A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 261C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 261E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 2620 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 2622 045B  20         b     *r11                  ; Return to caller
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
0318 2624 0649  14         dect  stack
0319 2626 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 2628 06A0  32         bl    @sams.layout
     262A 25EE 
0324 262C 2632                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 262E C2F9  30         mov   *stack+,r11           ; Pop r11
0330 2630 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 2632 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     2634 0002 
0336 2636 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     2638 0003 
0337 263A A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     263C 000A 
0338 263E B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2640 000B 
0339 2642 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     2644 000C 
0340 2646 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2648 000D 
0341 264A E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     264C 000E 
0342 264E F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2650 000F 
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
0363 2652 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 2654 0649  14         dect  stack
0366 2656 C64B  30         mov   r11,*stack            ; Push return address
0367 2658 0649  14         dect  stack
0368 265A C644  30         mov   tmp0,*stack           ; Push tmp0
0369 265C 0649  14         dect  stack
0370 265E C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2660 0649  14         dect  stack
0372 2662 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 2664 0649  14         dect  stack
0374 2666 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2668 0205  20         li    tmp1,sams.layout.copy.data
     266A 268A 
0379 266C 0206  20         li    tmp2,8                ; Set loop counter
     266E 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2670 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2672 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2674 254A 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 2676 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2678 833C 
0390               
0391 267A 0606  14         dec   tmp2                  ; Next iteration
0392 267C 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 267E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2680 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2682 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 2684 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 2686 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2688 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 268A 2000             data  >2000                 ; >2000-2fff
0408 268C 3000             data  >3000                 ; >3000-3fff
0409 268E A000             data  >a000                 ; >a000-afff
0410 2690 B000             data  >b000                 ; >b000-bfff
0411 2692 C000             data  >c000                 ; >c000-cfff
0412 2694 D000             data  >d000                 ; >d000-dfff
0413 2696 E000             data  >e000                 ; >e000-efff
0414 2698 F000             data  >f000                 ; >f000-ffff
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
0009 269A 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     269C FFBF 
0010 269E 0460  28         b     @putv01
     26A0 2352 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 26A2 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     26A4 0040 
0018 26A6 0460  28         b     @putv01
     26A8 2352 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26AA 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26AC FFDF 
0026 26AE 0460  28         b     @putv01
     26B0 2352 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26B2 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26B4 0020 
0034 26B6 0460  28         b     @putv01
     26B8 2352 
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
0010 26BA 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26BC FFFE 
0011 26BE 0460  28         b     @putv01
     26C0 2352 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26C2 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26C4 0001 
0019 26C6 0460  28         b     @putv01
     26C8 2352 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26CA 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26CC FFFD 
0027 26CE 0460  28         b     @putv01
     26D0 2352 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26D2 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26D4 0002 
0035 26D6 0460  28         b     @putv01
     26D8 2352 
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
0013 273E C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2740 06A0  32         bl    @putvr                ; Write once
     2742 233E 
0015 2744 391C             data  >391c                 ; VR1/57, value 00011100
0016 2746 06A0  32         bl    @putvr                ; Write twice
     2748 233E 
0017 274A 391C             data  >391c                 ; VR1/57, value 00011100
0018 274C 06A0  32         bl    @putvr
     274E 233E 
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
     2758 233E 
0030 275A 3900             data  >3900
0031 275C 0458  20         b     *tmp4                 ; Exit
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
0043 275E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 2760 06A0  32         bl    @cpym2v
     2762 2492 
0045 2764 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2766 27A2 
     2768 0006 
0046 276A 06A0  32         bl    @putvr
     276C 233E 
0047 276E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 2770 06A0  32         bl    @putvr
     2772 233E 
0049 2774 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 2776 0204  20         li    tmp0,>3f00
     2778 3F00 
0055 277A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     277C 22C6 
0056 277E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2780 8800 
0057 2782 0984  56         srl   tmp0,8
0058 2784 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2786 8800 
0059 2788 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 278A 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 278C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     278E BFFF 
0063 2790 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 2792 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2794 4000 
0066               f18chk_exit:
0067 2796 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     2798 229A 
0068 279A 3F00             data  >3f00,>00,6
     279C 0000 
     279E 0006 
0069 27A0 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 27A2 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 27A4 3F00             data  >3f00                 ; 3f02 / 3f00
0076 27A6 0340             data  >0340                 ; 3f04   0340  idle
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
0097 27A8 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 27AA 06A0  32         bl    @putvr
     27AC 233E 
0102 27AE 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 27B0 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27B2 233E 
0105 27B4 3900             data  >3900                 ; Lock the F18a
0106 27B6 0458  20         b     *tmp4                 ; Exit
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
0125 27B8 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 27BA 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27BC 201E 
0127 27BE 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 27C0 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27C2 8802 
0132 27C4 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27C6 233E 
0133 27C8 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 27CA 04C4  14         clr   tmp0
0135 27CC D120  34         movb  @vdps,tmp0
     27CE 8802 
0136 27D0 0984  56         srl   tmp0,8
0137 27D2 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27D4 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27D6 832A 
0018 27D8 D17B  28         movb  *r11+,tmp1
0019 27DA 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27DC D1BB  28         movb  *r11+,tmp2
0021 27DE 0986  56         srl   tmp2,8                ; Repeat count
0022 27E0 C1CB  18         mov   r11,tmp3
0023 27E2 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27E4 2406 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27E6 020B  20         li    r11,hchar1
     27E8 27EE 
0028 27EA 0460  28         b     @xfilv                ; Draw
     27EC 22A0 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27EE 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27F0 2022 
0033 27F2 1302  14         jeq   hchar2                ; Yes, exit
0034 27F4 C2C7  18         mov   tmp3,r11
0035 27F6 10EE  14         jmp   hchar                 ; Next one
0036 27F8 05C7  14 hchar2  inct  tmp3
0037 27FA 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0148               
0152               
0156               
0160               
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
0016 27FC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27FE 2020 
0017 2800 020C  20         li    r12,>0024
     2802 0024 
0018 2804 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     2806 2898 
0019 2808 04C6  14         clr   tmp2
0020 280A 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 280C 04CC  14         clr   r12
0025 280E 1F08  20         tb    >0008                 ; Shift-key ?
0026 2810 1302  14         jeq   realk1                ; No
0027 2812 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2814 28C8 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 2816 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 2818 1302  14         jeq   realk2                ; No
0033 281A 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     281C 28F8 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 281E 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2820 1302  14         jeq   realk3                ; No
0039 2822 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2824 2928 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 2826 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     2828 200C 
0044 282A 1E15  20         sbz   >0015                 ; Set P5
0045 282C 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 282E 1302  14         jeq   realk4                ; No
0047 2830 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2832 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2834 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 2836 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     2838 0006 
0053 283A 0606  14 realk5  dec   tmp2
0054 283C 020C  20         li    r12,>24               ; CRU address for P2-P4
     283E 0024 
0055 2840 06C6  14         swpb  tmp2
0056 2842 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2844 06C6  14         swpb  tmp2
0058 2846 020C  20         li    r12,6                 ; CRU read address
     2848 0006 
0059 284A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 284C 0547  14         inv   tmp3                  ;
0061 284E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2850 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2852 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2854 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2856 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2858 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 285A 0285  22         ci    tmp1,8
     285C 0008 
0070 285E 1AFA  14         jl    realk6
0071 2860 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2862 1BEB  14         jh    realk5                ; No, next column
0073 2864 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2866 C206  18 realk8  mov   tmp2,tmp4
0078 2868 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 286A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 286C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 286E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2870 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2872 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2874 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2876 200C 
0089 2878 1608  14         jne   realka                ; No, continue saving key
0090 287A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     287C 28C2 
0091 287E 1A05  14         jl    realka
0092 2880 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2882 28C0 
0093 2884 1B02  14         jh    realka                ; No, continue
0094 2886 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2888 E000 
0095 288A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     288C 833C 
0096 288E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2890 200A 
0097 2892 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2894 8C00 
0098                                                   ; / using R15 as temp storage
0099 2896 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2898 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     289A 0000 
     289C FF0D 
     289E 203D 
0102 28A0 ....             text  'xws29ol.'
0103 28A8 ....             text  'ced38ik,'
0104 28B0 ....             text  'vrf47ujm'
0105 28B8 ....             text  'btg56yhn'
0106 28C0 ....             text  'zqa10p;/'
0107 28C8 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28CA 0000 
     28CC FF0D 
     28CE 202B 
0108 28D0 ....             text  'XWS@(OL>'
0109 28D8 ....             text  'CED#*IK<'
0110 28E0 ....             text  'VRF$&UJM'
0111 28E8 ....             text  'BTG%^YHN'
0112 28F0 ....             text  'ZQA!)P:-'
0113 28F8 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28FA 0000 
     28FC FF0D 
     28FE 2005 
0114 2900 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     2902 0804 
     2904 0F27 
     2906 C2B9 
0115 2908 600B             data  >600b,>0907,>063f,>c1B8
     290A 0907 
     290C 063F 
     290E C1B8 
0116 2910 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     2912 7B02 
     2914 015F 
     2916 C0C3 
0117 2918 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     291A 7D0E 
     291C 0CC6 
     291E BFC4 
0118 2920 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     2922 7C03 
     2924 BC22 
     2926 BDBA 
0119 2928 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     292A 0000 
     292C FF0D 
     292E 209D 
0120 2930 9897             data  >9897,>93b2,>9f8f,>8c9B
     2932 93B2 
     2934 9F8F 
     2936 8C9B 
0121 2938 8385             data  >8385,>84b3,>9e89,>8b80
     293A 84B3 
     293C 9E89 
     293E 8B80 
0122 2940 9692             data  >9692,>86b4,>b795,>8a8D
     2942 86B4 
     2944 B795 
     2946 8A8D 
0123 2948 8294             data  >8294,>87b5,>b698,>888E
     294A 87B5 
     294C B698 
     294E 888E 
0124 2950 9A91             data  >9a91,>81b1,>b090,>9cBB
     2952 81B1 
     2954 B090 
     2956 9CBB 
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
0023 2958 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 295A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     295C 8340 
0025 295E 04E0  34         clr   @waux1
     2960 833C 
0026 2962 04E0  34         clr   @waux2
     2964 833E 
0027 2966 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2968 833C 
0028 296A C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 296C 0205  20         li    tmp1,4                ; 4 nibbles
     296E 0004 
0033 2970 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2972 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2974 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2976 0286  22         ci    tmp2,>000a
     2978 000A 
0039 297A 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 297C C21B  26         mov   *r11,tmp4
0045 297E 0988  56         srl   tmp4,8                ; Right justify
0046 2980 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2982 FFF6 
0047 2984 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2986 C21B  26         mov   *r11,tmp4
0054 2988 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     298A 00FF 
0055               
0056 298C A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 298E 06C6  14         swpb  tmp2
0058 2990 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2992 0944  56         srl   tmp0,4                ; Next nibble
0060 2994 0605  14         dec   tmp1
0061 2996 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2998 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     299A BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 299C C160  34         mov   @waux3,tmp1           ; Get pointer
     299E 8340 
0067 29A0 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 29A2 0585  14         inc   tmp1                  ; Next byte, not word!
0069 29A4 C120  34         mov   @waux2,tmp0
     29A6 833E 
0070 29A8 06C4  14         swpb  tmp0
0071 29AA DD44  32         movb  tmp0,*tmp1+
0072 29AC 06C4  14         swpb  tmp0
0073 29AE DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29B0 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29B2 8340 
0078 29B4 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29B6 2016 
0079 29B8 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29BA C120  34         mov   @waux1,tmp0
     29BC 833C 
0084 29BE 06C4  14         swpb  tmp0
0085 29C0 DD44  32         movb  tmp0,*tmp1+
0086 29C2 06C4  14         swpb  tmp0
0087 29C4 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29C6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29C8 2020 
0092 29CA 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29CC 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29CE 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29D0 7FFF 
0098 29D2 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29D4 8340 
0099 29D6 0460  28         b     @xutst0               ; Display string
     29D8 242C 
0100 29DA 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29DC C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29DE 832A 
0122 29E0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29E2 8000 
0123 29E4 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29E6 0207  20 mknum   li    tmp3,5                ; Digit counter
     29E8 0005 
0020 29EA C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29EC C155  26         mov   *tmp1,tmp1            ; /
0022 29EE C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29F0 0228  22         ai    tmp4,4                ; Get end of buffer
     29F2 0004 
0024 29F4 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29F6 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29F8 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29FA 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29FC 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29FE B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 2A00 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 2A02 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 2A04 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2A06 0607  14         dec   tmp3                  ; Decrease counter
0036 2A08 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2A0A 0207  20         li    tmp3,4                ; Check first 4 digits
     2A0C 0004 
0041 2A0E 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A10 C11B  26         mov   *r11,tmp0
0043 2A12 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A14 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A16 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A18 05CB  14 mknum3  inct  r11
0047 2A1A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A1C 2020 
0048 2A1E 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A20 045B  20         b     *r11                  ; Exit
0050 2A22 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A24 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A26 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A28 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A2A 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A2C 7FFF 
0058 2A2E C10B  18         mov   r11,tmp0
0059 2A30 0224  22         ai    tmp0,-4
     2A32 FFFC 
0060 2A34 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A36 0206  20         li    tmp2,>0500            ; String length = 5
     2A38 0500 
0062 2A3A 0460  28         b     @xutstr               ; Display string
     2A3C 242E 
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
0093 2A3E C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A40 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A42 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A44 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A46 0207  20         li    tmp3,5                ; Set counter
     2A48 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A4A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A4C 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A4E 0584  14         inc   tmp0                  ; Next character
0105 2A50 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A52 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A54 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A56 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A58 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A5A 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A5C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A5E 0607  14         dec   tmp3                  ; Last character ?
0121 2A60 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A62 045B  20         b     *r11                  ; Return
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
0139 2A64 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A66 832A 
0140 2A68 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A6A 8000 
0141 2A6C 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A6E 0649  14         dect  stack
0023 2A70 C64B  30         mov   r11,*stack            ; Save return address
0024 2A72 0649  14         dect  stack
0025 2A74 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A76 0649  14         dect  stack
0027 2A78 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A7A 0649  14         dect  stack
0029 2A7C C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A7E 0649  14         dect  stack
0031 2A80 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A82 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A84 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A86 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A88 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A8A 0649  14         dect  stack
0044 2A8C C64B  30         mov   r11,*stack            ; Save return address
0045 2A8E 0649  14         dect  stack
0046 2A90 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A92 0649  14         dect  stack
0048 2A94 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A96 0649  14         dect  stack
0050 2A98 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A9A 0649  14         dect  stack
0052 2A9C C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A9E C1D4  26 !       mov   *tmp0,tmp3
0057 2AA0 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2AA2 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2AA4 00FF 
0059 2AA6 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2AA8 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2AAA 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2AAC 0584  14         inc   tmp0                  ; Next byte
0067 2AAE 0607  14         dec   tmp3                  ; Shorten string length
0068 2AB0 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AB2 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AB4 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AB6 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2AB8 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2ABA C187  18         mov   tmp3,tmp2
0078 2ABC 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2ABE DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AC0 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2AC2 24EC 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2AC4 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2AC6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AC8 FFCE 
0090 2ACA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2ACC 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2ACE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AD0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AD2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AD4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AD6 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2AD8 045B  20         b     *r11                  ; Return to caller
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
0123 2ADA 0649  14         dect  stack
0124 2ADC C64B  30         mov   r11,*stack            ; Save return address
0125 2ADE 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AE0 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AE2 0649  14         dect  stack
0128 2AE4 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AE6 0649  14         dect  stack
0130 2AE8 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AEA 0649  14         dect  stack
0132 2AEC C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AEE C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AF0 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AF2 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AF4 0649  14         dect  stack
0144 2AF6 C64B  30         mov   r11,*stack            ; Save return address
0145 2AF8 0649  14         dect  stack
0146 2AFA C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AFC 0649  14         dect  stack
0148 2AFE C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2B00 0649  14         dect  stack
0150 2B02 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2B04 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2B06 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2B08 0586  14         inc   tmp2
0161 2B0A 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2B0C 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B0E 0286  22         ci    tmp2,255
     2B10 00FF 
0167 2B12 1505  14         jgt   string.getlenc.panic
0168 2B14 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B16 0606  14         dec   tmp2                  ; One time adjustment
0174 2B18 C806  38         mov   tmp2,@waux1           ; Store length
     2B1A 833C 
0175 2B1C 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B1E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B20 FFCE 
0181 2B22 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B24 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B26 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B28 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B2A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B2C C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B2E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0208               
0212               
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
0056 2B30 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B32 2B34             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B34 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B36 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B38 A428 
0064 2B3A 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B3C 201C 
0065 2B3E C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B40 8356 
0066 2B42 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B44 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B46 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B48 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B4A A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B4C 06C0  14         swpb  r0                    ;
0075 2B4E D800  38         movb  r0,@vdpa              ; Send low byte
     2B50 8C02 
0076 2B52 06C0  14         swpb  r0                    ;
0077 2B54 D800  38         movb  r0,@vdpa              ; Send high byte
     2B56 8C02 
0078 2B58 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B5A 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B5C 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B5E 0704  14         seto  r4                    ; Init counter
0086 2B60 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B62 A420 
0087 2B64 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B66 0584  14         inc   r4                    ; Increment char counter
0089 2B68 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B6A 0007 
0090 2B6C 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B6E 80C4  18         c     r4,r3                 ; End of name?
0093 2B70 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B72 06C0  14         swpb  r0                    ;
0098 2B74 D800  38         movb  r0,@vdpa              ; Send low byte
     2B76 8C02 
0099 2B78 06C0  14         swpb  r0                    ;
0100 2B7A D800  38         movb  r0,@vdpa              ; Send high byte
     2B7C 8C02 
0101 2B7E D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B80 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B82 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B84 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B86 2C9C 
0109 2B88 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B8A C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B8C 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B8E 04E0  34         clr   @>83d0
     2B90 83D0 
0118 2B92 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B94 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B96 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B98 A432 
0121               
0122 2B9A 0584  14         inc   r4                    ; Adjust for dot
0123 2B9C A804  38         a     r4,@>8356             ; Point to position after name
     2B9E 8356 
0124 2BA0 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2BA2 8356 
     2BA4 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2BA6 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2BA8 83E0 
0130 2BAA 04C1  14         clr   r1                    ; Version found of dsr
0131 2BAC 020C  20         li    r12,>0f00             ; Init cru address
     2BAE 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BB0 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BB2 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BB4 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BB6 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BB8 0100 
0145 2BBA 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BBC 83D0 
0146 2BBE 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BC0 2000 
0147 2BC2 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BC4 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BC6 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BC8 1D00  20         sbo   0                     ; Turn on ROM
0154 2BCA 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BCC 4000 
0155 2BCE 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BD0 2C98 
0156 2BD2 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BD4 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BD6 A40A 
0166 2BD8 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BDA C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BDC 83D2 
0172                                                   ; subprogram
0173               
0174 2BDE 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BE0 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BE2 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BE4 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BE6 83D2 
0183                                                   ; subprogram
0184               
0185 2BE8 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BEA C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BEC 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BEE D160  34         movb  @>8355,r5             ; Get length as counter
     2BF0 8355 
0195 2BF2 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BF4 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BF6 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BF8 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BFA 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BFC A420 
0206 2BFE 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2C00 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2C02 0605  14         dec   r5                    ; Update loop counter
0211 2C04 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2C06 0581  14         inc   r1                    ; Next version found
0217 2C08 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2C0A A42A 
0218 2C0C C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C0E A42C 
0219 2C10 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C12 A430 
0220               
0221 2C14 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C16 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C18 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C1A 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C1C 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C1E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C20 A400 
0233 2C22 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C24 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C26 A428 
0239                                                   ; (8 or >a)
0240 2C28 0281  22         ci    r1,8                  ; was it 8?
     2C2A 0008 
0241 2C2C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C2E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C30 8350 
0243                                                   ; Get error byte from @>8350
0244 2C32 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C34 06C0  14         swpb  r0                    ;
0252 2C36 D800  38         movb  r0,@vdpa              ; send low byte
     2C38 8C02 
0253 2C3A 06C0  14         swpb  r0                    ;
0254 2C3C D800  38         movb  r0,@vdpa              ; send high byte
     2C3E 8C02 
0255 2C40 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C42 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C44 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C46 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C48 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C4A 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C4C 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C4E A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C50 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C52 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C54 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C56 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C58 201C 
0281                                                   ; / to indicate error
0282 2C5A 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C5C A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C5E 2C60             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C60 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C62 83E0 
0316               
0317 2C64 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C66 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C68 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C6A A42A 
0322 2C6C C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C6E C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C70 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C72 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C74 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C76 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C78 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C7A 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C7C 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C7E 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C80 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C82 4000 
     2C84 2C98 
0337 2C86 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C88 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C8A 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C8C 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C8E 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C90 A400 
0355 2C92 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C94 A434 
0356               
0357 2C96 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C98 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C9A 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C9C ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C9E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2CA0 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2CA2 0649  14         dect  stack
0052 2CA4 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2CA6 0204  20         li    tmp0,dsrlnk.savcru
     2CA8 A42A 
0057 2CAA 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2CAC 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CAE 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CB0 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CB2 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CB4 37D7 
0065 2CB6 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CB8 8370 
0066                                                   ; / location
0067 2CBA C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CBC A44C 
0068 2CBE 04C5  14         clr   tmp1                  ; io.op.open
0069 2CC0 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2CC2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CC4 0649  14         dect  stack
0097 2CC6 C64B  30         mov   r11,*stack            ; Save return address
0098 2CC8 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CCA 0001 
0099 2CCC 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2CCE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CD0 0649  14         dect  stack
0125 2CD2 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CD4 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CD6 0002 
0128 2CD8 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2CDA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CDC 0649  14         dect  stack
0155 2CDE C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CE0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CE2 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CE4 0005 
0159               
0160 2CE6 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CE8 A43E 
0161               
0162 2CEA 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CEC 22D8 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CEE 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CF0 0003 
0167 2CF2 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CF4 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CF6 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CF8 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CFA 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CFC 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CFE 1000  14         nop
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
0227 2D00 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2D02 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2D04 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2D06 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2D08 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2D0A 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D0C 22D8 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D0E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D10 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D12 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D14 A44C 
0246               
0247 2D16 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D18 22D8 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D1A 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D1C 0009 
0254 2D1E C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D20 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D22 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D24 8322 
     2D26 833C 
0259               
0260 2D28 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D2A A42A 
0261 2D2C 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D2E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D30 2B30 
0268 2D32 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D34 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D36 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D38 2C5C 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D3A 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D3C C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D3E 833C 
     2D40 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D42 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D44 A436 
0292 2D46 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D48 0005 
0293 2D4A 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D4C 22F0 
0294 2D4E C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D50 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D52 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D54 045B  20         b     *r11                  ; Return to caller
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
0020 2D56 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D58 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D5A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D5C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D5E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D60 201C 
0029 2D62 1602  14         jne   tmgr1a                ; No, so move on
0030 2D64 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D66 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D68 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D6A 2020 
0035 2D6C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D6E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D70 2010 
0048 2D72 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D74 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D76 200E 
0050 2D78 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D7A 0460  28         b     @kthread              ; Run kernel thread
     2D7C 2DF4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D7E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D80 2014 
0056 2D82 13EB  14         jeq   tmgr1
0057 2D84 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D86 2012 
0058 2D88 16E8  14         jne   tmgr1
0059 2D8A C120  34         mov   @wtiusr,tmp0
     2D8C 832E 
0060 2D8E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D90 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D92 2DF2 
0065 2D94 C10A  18         mov   r10,tmp0
0066 2D96 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D98 00FF 
0067 2D9A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D9C 201C 
0068 2D9E 1303  14         jeq   tmgr5
0069 2DA0 0284  22         ci    tmp0,60               ; 1 second reached ?
     2DA2 003C 
0070 2DA4 1002  14         jmp   tmgr6
0071 2DA6 0284  22 tmgr5   ci    tmp0,50
     2DA8 0032 
0072 2DAA 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2DAC 1001  14         jmp   tmgr8
0074 2DAE 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DB0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DB2 832C 
0079 2DB4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DB6 FF00 
0080 2DB8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DBA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DBC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DBE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DC0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DC2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DC4 830C 
     2DC6 830D 
0089 2DC8 1608  14         jne   tmgr10                ; No, get next slot
0090 2DCA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DCC FF00 
0091 2DCE C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DD0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DD2 8330 
0096 2DD4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DD6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DD8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DDA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DDC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DDE 8315 
     2DE0 8314 
0103 2DE2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DE4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DE6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DE8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DEA 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DEC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DEE FF00 
0109 2DF0 10B4  14         jmp   tmgr1
0110 2DF2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DF4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DF6 2010 
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
0041 2DF8 06A0  32         bl    @realkb               ; Scan full keyboard
     2DFA 27FC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DFC 0460  28         b     @tmgr3                ; Exit
     2DFE 2D7E 
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
0017 2E00 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2E02 832E 
0018 2E04 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2E06 2012 
0019 2E08 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D5A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2E0A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E0C 832E 
0029 2E0E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E10 FEFF 
0030 2E12 045B  20         b     *r11                  ; Return
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
0017 2E14 C13B  30 mkslot  mov   *r11+,tmp0
0018 2E16 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E18 C184  18         mov   tmp0,tmp2
0023 2E1A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E1C A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E1E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E20 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E22 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E24 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E26 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E28 2022 
0035 2E2A 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E2C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E2E 05CB  14 mkslo1  inct  r11
0041 2E30 045B  20         b     *r11                  ; Exit
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
0052 2E32 C13B  30 clslot  mov   *r11+,tmp0
0053 2E34 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E36 A120  34         a     @wtitab,tmp0          ; Add table base
     2E38 832C 
0055 2E3A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E3C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E3E 045B  20         b     *r11                  ; Exit
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
0068 2E40 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E42 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E44 A120  34         a     @wtitab,tmp0          ; Add table base
     2E46 832C 
0071 2E48 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E4A C154  26         mov   *tmp0,tmp1
0073 2E4C 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E4E FF00 
0074 2E50 C505  30         mov   tmp1,*tmp0
0075 2E52 045B  20         b     *r11                  ; Exit
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
0261 2E54 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E56 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 2E58 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E5A 0000 
0267 2E5C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E5E 8300 
0268 2E60 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E62 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 2E64 0202  20 runli2  li    r2,>8308
     2E66 8308 
0273 2E68 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 2E6A 0282  22         ci    r2,>8400
     2E6C 8400 
0275 2E6E 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 2E70 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E72 FFFF 
0280 2E74 1602  14         jne   runli4                ; No, continue
0281 2E76 0420  54         blwp  @0                    ; Yes, bye bye
     2E78 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 2E7A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E7C 833C 
0286 2E7E 04C1  14         clr   r1                    ; Reset counter
0287 2E80 0202  20         li    r2,10                 ; We test 10 times
     2E82 000A 
0288 2E84 C0E0  34 runli5  mov   @vdps,r3
     2E86 8802 
0289 2E88 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E8A 2020 
0290 2E8C 1302  14         jeq   runli6
0291 2E8E 0581  14         inc   r1                    ; Increase counter
0292 2E90 10F9  14         jmp   runli5
0293 2E92 0602  14 runli6  dec   r2                    ; Next test
0294 2E94 16F7  14         jne   runli5
0295 2E96 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E98 1250 
0296 2E9A 1202  14         jle   runli7                ; No, so it must be NTSC
0297 2E9C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E9E 201C 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 2EA0 06A0  32 runli7  bl    @loadmc
     2EA2 2226 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 2EA4 04C1  14 runli9  clr   r1
0306 2EA6 04C2  14         clr   r2
0307 2EA8 04C3  14         clr   r3
0308 2EAA 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2EAC 3000 
0309 2EAE 020F  20         li    r15,vdpw              ; Set VDP write address
     2EB0 8C00 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 2EB2 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EB4 4A4A 
0318 2EB6 1605  14         jne   runlia
0319 2EB8 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EBA 229A 
0320 2EBC 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EBE 0000 
     2EC0 3000 
0325 2EC2 06A0  32 runlia  bl    @filv
     2EC4 229A 
0326 2EC6 0FC0             data  pctadr,spfclr,16      ; Load color table
     2EC8 00F4 
     2ECA 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 2ECC 06A0  32         bl    @f18unl               ; Unlock the F18A
     2ECE 273E 
0334 2ED0 06A0  32         bl    @f18chk               ; Check if F18A is there
     2ED2 275E 
0335 2ED4 06A0  32         bl    @f18lck               ; Lock the F18A again
     2ED6 2754 
0336               
0337 2ED8 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2EDA 233E 
0338 2EDC 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 2EDE 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2EE0 2304 
0352 2EE2 33B0             data  spvmod                ; Equate selected video mode table
0353 2EE4 0204  20         li    tmp0,spfont           ; Get font option
     2EE6 000C 
0354 2EE8 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 2EEA 1304  14         jeq   runlid                ; Yes, skip it
0356 2EEC 06A0  32         bl    @ldfnt
     2EEE 236C 
0357 2EF0 1100             data  fntadr,spfont         ; Load specified font
     2EF2 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 2EF4 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EF6 4A4A 
0362 2EF8 1602  14         jne   runlie                ; No, continue
0363 2EFA 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EFC 2086 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 2EFE 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2F00 0040 
0368 2F02 0460  28         b     @main                 ; Give control to main program
     2F04 6046 
**** **** ****     > stevie_b1.asm.56185
0041                                                   ; Relocated spectra2 in low MEMEXP, was
0042                                                   ; copied to >2000 from ROM in bank 0
0043                       ;------------------------------------------------------
0044                       ; End of File marker
0045                       ;------------------------------------------------------
0046 2F06 DEAD             data >dead,>beef,>dead,>beef
     2F08 BEEF 
     2F0A DEAD 
     2F0C BEEF 
0048               ***************************************************************
0049               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0050               ********|*****|*********************|**************************
0051                       aorg  >3000
0052                       ;------------------------------------------------------
0053                       ; Activate bank 1 and branch to  >6036
0054                       ;------------------------------------------------------
0055 3000 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3002 6002 
0056               
0060               
0061 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6046 
0062                       ;------------------------------------------------------
0063                       ; Resident Stevie modules: >3000 - >3fff
0064                       ;------------------------------------------------------
0065                       copy  "ram.resident.3000.asm"
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
0040 3022 1116  14         jlt   rom.farjump.bankswitch.failed1
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
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 3040 0285  22         ci    tmp1,>ffff
     3042 FFFF 
0075 3044 1602  14         jne   !
0076 3046 C160  34         mov   @parm1,tmp1
     3048 2F20 
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 304A C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 304C 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 304E 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 3050 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3052 FFCE 
0092 3054 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3056 2026 
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 3058 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 305A C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     305C A026 
0103 305E C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 3060 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 3062 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 3064 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 3066 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 3068 028B  22         ci    r11,>6000
     306A 6000 
0116 306C 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 306E 028B  22         ci    r11,>7fff
     3070 7FFF 
0118 3072 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 3074 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3076 A026 
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 3078 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 307A 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 307C 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 307E 0225  22         ai    tmp1,>0800
     3080 0800 
0138 3082 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 3084 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 3086 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3088 FFCE 
0145 308A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     308C 2026 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 308E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 3090 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 3092 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 3094 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 3096 045B  20         b     *r11                  ; Return to caller
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
0020 3098 0649  14         dect  stack
0021 309A C64B  30         mov   r11,*stack            ; Save return address
0022 309C 0649  14         dect  stack
0023 309E C644  30         mov   tmp0,*stack           ; Push tmp0
0024 30A0 0649  14         dect  stack
0025 30A2 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 30A4 0204  20         li    tmp0,fb.top
     30A6 A600 
0030 30A8 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     30AA A100 
0031 30AC 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     30AE A104 
0032 30B0 04E0  34         clr   @fb.row               ; Current row=0
     30B2 A106 
0033 30B4 04E0  34         clr   @fb.column            ; Current column=0
     30B6 A10C 
0034               
0035 30B8 0204  20         li    tmp0,colrow
     30BA 0050 
0036 30BC C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     30BE A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 30C0 C160  34         mov   @tv.ruler.visible,tmp1
     30C2 A010 
0041 30C4 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 30C6 0204  20         li    tmp0,pane.botrow-2
     30C8 001B 
0043 30CA 1002  14         jmp   fb.init.cont
0044 30CC 0204  20 !       li    tmp0,pane.botrow-1
     30CE 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 30D0 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     30D2 A11A 
0050 30D4 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30D6 A11C 
0051               
0052 30D8 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30DA A022 
0053 30DC 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30DE A110 
0054 30E0 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30E2 A116 
0055 30E4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30E6 A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 30E8 06A0  32         bl    @film
     30EA 2242 
0060 30EC A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30EE 0000 
     30F0 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 30F2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 30F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 30F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 30F8 045B  20         b     *r11                  ; Return to caller
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
0046 30FA 0649  14         dect  stack
0047 30FC C64B  30         mov   r11,*stack            ; Save return address
0048 30FE 0649  14         dect  stack
0049 3100 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 3102 0204  20         li    tmp0,idx.top
     3104 B000 
0054 3106 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     3108 A202 
0055               
0056 310A C120  34         mov   @tv.sams.b000,tmp0
     310C A006 
0057 310E C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     3110 A500 
0058 3112 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     3114 A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 3116 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     3118 0004 
0063 311A C804  38         mov   tmp0,@idx.sams.hipage ; /
     311C A504 
0064               
0065 311E 06A0  32         bl    @_idx.sams.mapcolumn.on
     3120 313C 
0066                                                   ; Index in continuous memory region
0067               
0068 3122 06A0  32         bl    @film
     3124 2242 
0069 3126 B000                   data idx.top,>00,idx.size * 5
     3128 0000 
     312A 5000 
0070                                                   ; Clear index
0071               
0072 312C 06A0  32         bl    @_idx.sams.mapcolumn.off
     312E 3170 
0073                                                   ; Restore memory window layout
0074               
0075 3130 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     3132 A502 
     3134 A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 3136 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 3138 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 313A 045B  20         b     *r11                  ; Return to caller
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
0096 313C 0649  14         dect  stack
0097 313E C64B  30         mov   r11,*stack            ; Push return address
0098 3140 0649  14         dect  stack
0099 3142 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 3144 0649  14         dect  stack
0101 3146 C645  30         mov   tmp1,*stack           ; Push tmp1
0102 3148 0649  14         dect  stack
0103 314A C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 314C C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     314E A502 
0108 3150 0205  20         li    tmp1,idx.top
     3152 B000 
0109 3154 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3156 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 3158 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     315A 2582 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 315C 0584  14         inc   tmp0                  ; Next SAMS index page
0118 315E 0225  22         ai    tmp1,>1000            ; Next memory region
     3160 1000 
0119 3162 0606  14         dec   tmp2                  ; Update loop counter
0120 3164 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 3166 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 3168 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 316A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 316C C2F9  30         mov   *stack+,r11           ; Pop return address
0129 316E 045B  20         b     *r11                  ; Return to caller
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
0145 3170 0649  14         dect  stack
0146 3172 C64B  30         mov   r11,*stack            ; Push return address
0147 3174 0649  14         dect  stack
0148 3176 C644  30         mov   tmp0,*stack           ; Push tmp0
0149 3178 0649  14         dect  stack
0150 317A C645  30         mov   tmp1,*stack           ; Push tmp1
0151 317C 0649  14         dect  stack
0152 317E C646  30         mov   tmp2,*stack           ; Push tmp2
0153 3180 0649  14         dect  stack
0154 3182 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 3184 0205  20         li    tmp1,idx.top
     3186 B000 
0159 3188 0206  20         li    tmp2,5                ; Always 5 pages
     318A 0005 
0160 318C 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     318E A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 3190 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 3192 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3194 2582 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 3196 0225  22         ai    tmp1,>1000            ; Next memory region
     3198 1000 
0171 319A 0606  14         dec   tmp2                  ; Update loop counter
0172 319C 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 319E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 31A0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 31A2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 31A4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 31A6 C2F9  30         mov   *stack+,r11           ; Pop return address
0182 31A8 045B  20         b     *r11                  ; Return to caller
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
0206 31AA 0649  14         dect  stack
0207 31AC C64B  30         mov   r11,*stack            ; Save return address
0208 31AE 0649  14         dect  stack
0209 31B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 31B2 0649  14         dect  stack
0211 31B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0212 31B6 0649  14         dect  stack
0213 31B8 C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 31BA C184  18         mov   tmp0,tmp2             ; Line number
0218 31BC 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 31BE 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     31C0 0800 
0220               
0221 31C2 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 31C4 0A16  56         sla   tmp2,1                ; line number * 2
0226 31C6 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     31C8 2F30 
0227               
0228 31CA A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     31CC A502 
0229 31CE 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     31D0 A500 
0230               
0231 31D2 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 31D4 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31D6 A500 
0237 31D8 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31DA A006 
0238               
0239 31DC C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31DE 0205  20         li    tmp1,>b000            ; Memory window for index page
     31E0 B000 
0241               
0242 31E2 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31E4 2582 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31E6 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31E8 A504 
0249 31EA 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31EC C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31EE A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31F0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31F2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31F8 045B  20         b     *r11                  ; Return to caller
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
0022 31FA 0649  14         dect  stack
0023 31FC C64B  30         mov   r11,*stack            ; Save return address
0024 31FE 0649  14         dect  stack
0025 3200 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3202 0204  20         li    tmp0,edb.top          ; \
     3204 C000 
0030 3206 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     3208 A200 
0031 320A C804  38         mov   tmp0,@edb.next_free.ptr
     320C A208 
0032                                                   ; Set pointer to next free line
0033               
0034 320E 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     3210 A20A 
0035               
0036 3212 0204  20         li    tmp0,1
     3214 0001 
0037 3216 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     3218 A204 
0038               
0039 321A 0720  34         seto  @edb.block.m1         ; Reset block start line
     321C A20C 
0040 321E 0720  34         seto  @edb.block.m2         ; Reset block end line
     3220 A20E 
0041               
0042 3222 0204  20         li    tmp0,txt.newfile      ; "New file"
     3224 3538 
0043 3226 C804  38         mov   tmp0,@edb.filename.ptr
     3228 A212 
0044               
0045 322A 0204  20         li    tmp0,txt.filetype.none
     322C 35F0 
0046 322E C804  38         mov   tmp0,@edb.filetype.ptr
     3230 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 3232 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 3234 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 3236 045B  20         b     *r11                  ; Return to caller
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
0022 3238 0649  14         dect  stack
0023 323A C64B  30         mov   r11,*stack            ; Save return address
0024 323C 0649  14         dect  stack
0025 323E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3240 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3242 D000 
0030 3244 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3246 A300 
0031               
0032 3248 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     324A A302 
0033 324C 0204  20         li    tmp0,4
     324E 0004 
0034 3250 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3252 A306 
0035 3254 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3256 A308 
0036               
0037 3258 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     325A A316 
0038 325C 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     325E A318 
0039 3260 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3262 A326 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 3264 06A0  32         bl    @film
     3266 2242 
0044 3268 D000             data  cmdb.top,>00,cmdb.size
     326A 0000 
     326C 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 326E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3270 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3272 045B  20         b     *r11                  ; Return to caller
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
0022 3274 0649  14         dect  stack
0023 3276 C64B  30         mov   r11,*stack            ; Save return address
0024 3278 0649  14         dect  stack
0025 327A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 327C 04E0  34         clr   @tv.error.visible     ; Set to hidden
     327E A028 
0030               
0031 3280 06A0  32         bl    @film
     3282 2242 
0032 3284 A02A                   data tv.error.msg,0,160
     3286 0000 
     3288 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 328A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 328C C2F9  30         mov   *stack+,r11           ; Pop R11
0039 328E 045B  20         b     *r11                  ; Return to caller
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
0022 3290 0649  14         dect  stack
0023 3292 C64B  30         mov   r11,*stack            ; Save return address
0024 3294 0649  14         dect  stack
0025 3296 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3298 0204  20         li    tmp0,1                ; \ Set default color scheme
     329A 0001 
0030 329C C804  38         mov   tmp0,@tv.colorscheme  ; /
     329E A012 
0031               
0032 32A0 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     32A2 A024 
0033 32A4 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     32A6 200C 
0034               
0035 32A8 0204  20         li    tmp0,fj.bottom
     32AA F000 
0036 32AC C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     32AE A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 32B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 32B2 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 32B4 045B  20         b     *r11                  ; Return to caller
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
0065 32B6 0649  14         dect  stack
0066 32B8 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 32BA 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32BC 3238 
0071 32BE 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32C0 31FA 
0072 32C2 06A0  32         bl    @idx.init             ; Initialize index
     32C4 30FA 
0073 32C6 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32C8 3098 
0074 32CA 06A0  32         bl    @errline.init         ; Initialize error line
     32CC 3274 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 32CE 06A0  32         bl    @hchar
     32D0 27D4 
0079 32D2 0034                   byte 0,52,32,18           ; Remove markers
     32D4 2012 
0080 32D6 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     32D8 2033 
0081 32DA FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32DC C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32DE 045B  20         b     *r11                  ; Return to caller
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
0020 32E0 0649  14         dect  stack
0021 32E2 C64B  30         mov   r11,*stack            ; Save return address
0022 32E4 0649  14         dect  stack
0023 32E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32E8 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32EA 29E6 
0028 32EC 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32EE 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32F0 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32F2 0204  20         li    tmp0,unpacked.string
     32F4 2F44 
0034 32F6 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32F8 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32FA 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32FC 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32FE 2A3E 
0039 3300 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 3302 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 3304 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 3306 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 3308 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 330A 045B  20         b     *r11                  ; Return to caller
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
0073 330C 0649  14         dect  stack
0074 330E C64B  30         mov   r11,*stack            ; Push return address
0075 3310 0649  14         dect  stack
0076 3312 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 3314 0649  14         dect  stack
0078 3316 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 3318 0649  14         dect  stack
0080 331A C646  30         mov   tmp2,*stack           ; Push tmp2
0081 331C 0649  14         dect  stack
0082 331E C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 3320 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     3322 2F20 
0087 3324 D194  26         movb  *tmp0,tmp2            ; /
0088 3326 0986  56         srl   tmp2,8                ; Right align
0089 3328 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 332A 8806  38         c     tmp2,@parm2           ; String length > requested length?
     332C 2F22 
0092 332E 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 3330 C120  34         mov   @parm1,tmp0           ; Get source address
     3332 2F20 
0097 3334 C160  34         mov   @parm4,tmp1           ; Get destination address
     3336 2F26 
0098 3338 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 333A 0649  14         dect  stack
0101 333C C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 333E 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3340 24EC 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 3342 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 3344 C120  34         mov   @parm2,tmp0           ; Get requested length
     3346 2F22 
0113 3348 0A84  56         sla   tmp0,8                ; Left align
0114 334A C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     334C 2F26 
0115 334E D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 3350 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 3352 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 3354 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3356 2F22 
0122 3358 6187  18         s     tmp3,tmp2             ; |
0123 335A 0586  14         inc   tmp2                  ; /
0124               
0125 335C C120  34         mov   @parm3,tmp0           ; Get byte to padd
     335E 2F24 
0126 3360 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 3362 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 3364 0606  14         dec   tmp2                  ; Update loop counter
0133 3366 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 3368 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     336A 2F26 
     336C 2F30 
0136 336E 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 3370 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3372 FFCE 
0142 3374 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3376 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 3378 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 337A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 337C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 337E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 3380 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 3382 045B  20         b     *r11                  ; Return to caller
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
0174 3384 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     3386 27A8 
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 3388 04E0  34         clr   @bank0.rom            ; Activate bank 0
     338A 6000 
0179 338C 0420  54         blwp  @0                    ; Reset to monitor
     338E 0000 
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
0017 3390 0649  14         dect  stack
0018 3392 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 3394 06A0  32         bl    @sams.layout
     3396 25EE 
0023 3398 33C8                   data mem.sams.layout.data
0024               
0025 339A 06A0  32         bl    @sams.layout.copy
     339C 2652 
0026 339E A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 33A0 C820  54         mov   @tv.sams.c000,@edb.sams.page
     33A2 A008 
     33A4 A216 
0029 33A6 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     33A8 A216 
     33AA A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 33AC C2F9  30         mov   *stack+,r11           ; Pop r11
0036 33AE 045B  20         b     *r11                  ; Return to caller
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
0033 33B0 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     33B2 003F 
     33B4 0243 
     33B6 05F4 
     33B8 0050 
0034               
0035               romsat:
0036 33BA 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     33BC 0201 
0037 33BE 0000             data  >0000,>0301             ; Current line indicator
     33C0 0301 
0038 33C2 0820             data  >0820,>0401             ; Current line indicator
     33C4 0401 
0039               nosprite:
0040 33C6 D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 33C8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     33CA 0002 
0048 33CC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     33CE 0003 
0049 33D0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     33D2 000A 
0050               
0051 33D4 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     33D6 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 33D8 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     33DA 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 33DC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     33DE 000D 
0060 33E0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     33E2 000E 
0061 33E4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     33E6 000F 
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
0117 33E8 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     33EA F171 
     33EC 1B1F 
     33EE 71B1 
0118 33F0 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     33F2 F0FF 
     33F4 1F1A 
     33F6 F1FF 
0119 33F8 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     33FA F0FF 
     33FC 1F12 
     33FE F1F6 
0120 3400 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3402 1E11 
     3404 1A17 
     3406 1E11 
0121 3408 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     340A E1FF 
     340C 1F1E 
     340E E1FF 
0122 3410 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3412 1016 
     3414 1B71 
     3416 1711 
0123 3418 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     341A 1011 
     341C F1F1 
     341E 1F11 
0124 3420 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     3422 A1FF 
     3424 1F1F 
     3426 F11F 
0125 3428 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     342A 12FF 
     342C 1B12 
     342E 12FF 
0126 3430 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     3432 E1FF 
     3434 1B1F 
     3436 F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 3438 0007             byte  0,7,12,25               ; \   Default tab positions as used
     343A 0C19 
0131 343C 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     343E 3B4F 
0132 3440 FF00             byte  >ff,0,0,0               ; |
     3442 0000 
0133 3444 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     3446 0000 
0134 3448 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     344A 0000 
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
0012 344C 0B53             byte  11
0013 344D ....             text  'STEVIE 1.1S'
0014                       even
0015               
0016               txt.about.build
0017 3458 4A42             byte  74
0018 3459 ....             text  'Build: 210909-56185 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 34A4 012C             byte  1
0024 34A5 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 34A6 0520             byte  5
0029 34A7 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 34AC 034F             byte  3
0034 34AD ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 34B0 0349             byte  3
0039 34B1 ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 34B4 012A             byte  1
0044 34B5 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34B6 0A4C             byte  10
0049 34B7 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34C2 0A53             byte  10
0054 34C3 ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34CE 1244             byte  18
0059 34CF ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34E2 1143             byte  17
0064 34E3 ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34F4 104D             byte  16
0069 34F5 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 3506 1D53             byte  29
0074 3507 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 3524 0846             byte  8
0079 3525 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 352E 026B             byte  2
0084 352F ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 3532 054C             byte  5
0089 3533 ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 3538 0A5B             byte  10
0094 3539 ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 3544 0444             byte  4
0099 3545 ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 354A 034D             byte  3
0104 354B ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 354E 034D             byte  3
0109 354F ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 3552 0746             byte  7
0114 3553 ....             text  'F9=Menu'
0115                       even
0116               
0117               txt.keys.block
0118 355A 3342             byte  51
0119 355B ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0120                       even
0121               
0122 358E ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 3598 ....                        text    '.........'
0125                                  byte    19
0126 35A2 ....                        text    '.........'
0127                                  byte    20
0128 35AC ....                        text    '.........'
0129                                  byte    21
0130 35B6 ....                        text    '.........'
0131                                  byte    22
0132 35C0 ....                        text    '.........'
0133                                  byte    23
0134 35CA ....                        text    '.........'
0135                                  byte    24
0136 35D4 ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139 35DE 020E     txt.alpha.down     data >020e,>0f00
     35E0 0F00 
0140 35E2 0110     txt.vertline       data >0110
0141 35E4 011C     txt.keymarker      byte 1,28
0142               
0143               txt.ws1
0144 35E6 0120             byte  1
0145 35E7 ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 35E8 0220             byte  2
0150 35E9 ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 35EC 0320             byte  3
0155 35ED ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 35F0 0420             byte  4
0160 35F1 ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 35F6 0520             byte  5
0165 35F7 ....             text  '     '
0166                       even
0167               
0168      35F0     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 35FC 1301     txt.head.load      byte 19,1,3
     35FE 0320 
0175 35FF ....                        text ' Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 3610 3D53             byte  61
0179 3611 ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 364E 3146     txt.keys.load      byte 49
0184 364F ....                        text 'F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End'
0185               
0186 3680 3246     txt.keys.load2     byte 50
0187 3681 ....                        text 'F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End'
0188               
0189               ;--------------------------------------------------------------
0190               ; Dialog Save DV 80 file
0191               ;--------------------------------------------------------------
0192 36B4 0103     txt.head.save      byte 19,1,3
0193 36B6 ....                        text ' Save DV80 file '
0194 36C6 0223                        byte 2
0195 36C8 0103     txt.head.save2     byte 35,1,3,32
     36CA 2053 
0196 36CB ....                        text 'Save marked block to DV80 file '
0197 36EA 0201                        byte 2
0198               txt.hint.save
0199                       byte  1
0200 36EC ....             text  ' '
0201                       even
0202               
0203               
0204 36EE 2446     txt.keys.save      byte 36
0205 36EF ....                        text 'F9=Back  F3=Clear  F-H=Home  F-L=End'
0206               
0207               ;--------------------------------------------------------------
0208               ; Dialog "Unsaved changes"
0209               ;--------------------------------------------------------------
0210 3714 0103     txt.head.unsaved   byte 20,1,3
0211 3716 ....                        text ' Unsaved changes '
0212                                  byte 2
0213               txt.info.unsaved
0214 3728 2157             byte  33
0215 3729 ....             text  'Warning! Unsaved changes in file.'
0216                       even
0217               
0218               txt.hint.unsaved
0219 374A 2A50             byte  42
0220 374B ....             text  'Press F6 to proceed or ENTER to save file.'
0221                       even
0222               
0223               txt.keys.unsaved
0224 3776 2843             byte  40
0225 3777 ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0226                       even
0227               
0228               
0229               ;--------------------------------------------------------------
0230               ; Dialog "About"
0231               ;--------------------------------------------------------------
0232 37A0 0A01     txt.head.about     byte 10,1,3
     37A2 0320 
0233 37A3 ....                        text ' About '
0234 37AA 0200                        byte 2
0235               
0236               txt.info.about
0237                       byte  0
0238 37AC ....             text
0239                       even
0240               
0241               txt.hint.about
0242 37AC 1D50             byte  29
0243 37AD ....             text  'Press F9 to return to editor.'
0244                       even
0245               
0246 37CA 2148     txt.keys.about     byte 33
0247 37CB ....                        text 'Help: F9=Back  '
0248 37DA 0E0F                        byte 14,15
0249 37DC ....                        text '=Alpha Lock down'
0250               
0251               
0252               ;--------------------------------------------------------------
0253               ; Dialog "Menu"
0254               ;--------------------------------------------------------------
0255 37EC 1001     txt.head.menu      byte 16,1,3
     37EE 0320 
0256 37EF ....                        text ' Stevie 1.1S '
0257 37FC 021A                        byte 2
0258               
0259               txt.info.menu
0260                       byte  26
0261 37FE ....             text  'File / Basic / Help / Quit'
0262                       even
0263               
0264 3818 0007     pos.info.menu      byte 0,7,15,22,>ff
     381A 0F16 
     381C FF28 
0265               txt.hint.menu
0266                       byte  40
0267 381E ....             text  'Press F,B,H,Q or F9 to return to editor.'
0268                       even
0269               
0270               txt.keys.menu
0271 3846 0746             byte  7
0272 3847 ....             text  'F9=Back'
0273                       even
0274               
0275               
0276               
0277               ;--------------------------------------------------------------
0278               ; Dialog "File"
0279               ;--------------------------------------------------------------
0280 384E 0901     txt.head.file      byte 9,1,3
     3850 0320 
0281 3851 ....                        text ' File '
0282                                  byte 2
0283               
0284               txt.info.file
0285 3858 114E             byte  17
0286 3859 ....             text  'New / Open / Save'
0287                       even
0288               
0289 386A 0006     pos.info.file      byte 0,6,13,>ff
     386C 0DFF 
0290               txt.hint.file
0291 386E 2650             byte  38
0292 386F ....             text  'Press N,O,S or F9 to return to editor.'
0293                       even
0294               
0295               txt.keys.file
0296 3896 0746             byte  7
0297 3897 ....             text  'F9=Back'
0298                       even
0299               
0300               
0301               ;--------------------------------------------------------------
0302               ; Dialog "Basic"
0303               ;--------------------------------------------------------------
0304 389E 0E01     txt.head.basic     byte 14,1,3
     38A0 0320 
0305 38A1 ....                        text ' Run basic '
0306 38AC 021C                        byte 2
0307               
0308               txt.info.basic
0309                       byte  28
0310 38AE ....             text  'TI Basic / TI Extended Basic'
0311                       even
0312               
0313 38CA 030E     pos.info.basic     byte 3,14,>ff
     38CC FF3E 
0314               txt.hint.basic
0315                       byte  62
0316 38CE ....             text  'Press B,E for running basic dialect or F9 to return to editor.'
0317                       even
0318               
0319               txt.keys.basic
0320 390C 0746             byte  7
0321 390D ....             text  'F9=Back'
0322                       even
0323               
0324               
0325               
0326               ;--------------------------------------------------------------
0327               ; Strings for error line pane
0328               ;--------------------------------------------------------------
0329               txt.ioerr.load
0330 3914 2049             byte  32
0331 3915 ....             text  'I/O error. Failed loading file: '
0332                       even
0333               
0334               txt.ioerr.save
0335 3936 2049             byte  32
0336 3937 ....             text  'I/O error. Failed saving file:  '
0337                       even
0338               
0339               txt.memfull.load
0340 3958 4049             byte  64
0341 3959 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0342                       even
0343               
0344               txt.io.nofile
0345 399A 2149             byte  33
0346 399B ....             text  'I/O error. No filename specified.'
0347                       even
0348               
0349               txt.block.inside
0350 39BC 3445             byte  52
0351 39BD ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0352                       even
0353               
0354               
0355               ;--------------------------------------------------------------
0356               ; Strings for command buffer
0357               ;--------------------------------------------------------------
0358               txt.cmdb.prompt
0359 39F2 013E             byte  1
0360 39F3 ....             text  '>'
0361                       even
0362               
0363               txt.colorscheme
0364 39F4 0D43             byte  13
0365 39F5 ....             text  'Color scheme:'
0366                       even
0367               
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
**** **** ****     > ram.resident.3000.asm
0019                       ;------------------------------------------------------
0020                       ; End of File marker
0021                       ;------------------------------------------------------
0022 3A02 DEAD             data  >dead,>beef,>dead,>beef
     3A04 BEEF 
     3A06 DEAD 
     3A08 BEEF 
**** **** ****     > stevie_b1.asm.56185
0066               
0067               ***************************************************************
0068               * Step 4: Satisfy assembler, must know SP2 EXT in high MeMEXP
0069               ********|*****|*********************|**************************
0070                       aorg  >f000
0071                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/modules/cpu_scrpad_backrest.asm"
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
0023 F000 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     F002 7E00 
0024 F004 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     F006 7E02 
0025 F008 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     F00A 7E04 
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 F00C 0200  20         li    r0,>8306              ; Scratchpad source address
     F00E 8306 
0030 F010 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     F012 7E06 
0031 F014 0202  20         li    r2,62                 ; Loop counter
     F016 003E 
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 F018 CC70  46         mov   *r0+,*r1+
0037 F01A CC70  46         mov   *r0+,*r1+
0038 F01C 0642  14         dect  r2
0039 F01E 16FC  14         jne   cpu.scrpad.backup.copy
0040 F020 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     F022 83FE 
     F024 7EFE 
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 F026 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     F028 7E00 
0046 F02A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     F02C 7E02 
0047 F02E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     F030 7E04 
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 F032 045B  20         b     *r11                  ; Return to caller
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
0069 F034 C80B  38         mov   r11,@rambuf           ; Backup return address
     F036 2F6A 
0070                       ;------------------------------------------------------
0071                       ; Prepare for copy loop, WS
0072                       ;------------------------------------------------------
0073 F038 0200  20         li    r0,cpu.scrpad.tgt + 6
     F03A 7E06 
0074 F03C 0201  20         li    r1,>8306
     F03E 8306 
0075 F040 0202  20         li    r2,62
     F042 003E 
0076                       ;------------------------------------------------------
0077                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 F044 CC70  46         mov   *r0+,*r1+
0081 F046 CC70  46         mov   *r0+,*r1+
0082 F048 0642  14         dect  r2
0083 F04A 16FC  14         jne   cpu.scrpad.restore.copy
0084 F04C C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     F04E 7EFE 
     F050 83FE 
0085                                                   ; Copy last word
0086                       ;------------------------------------------------------
0087                       ; Restore scratchpad >8300 - >8304
0088                       ;------------------------------------------------------
0089 F052 C820  54         mov   @cpu.scrpad.tgt,@>8300       ; r0
     F054 7E00 
     F056 8300 
0090 F058 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302   ; r1
     F05A 7E02 
     F05C 8302 
0091 F05E C820  54         mov   @cpu.scrpad.tgt + 4,@>8304   ; r2
     F060 7E04 
     F062 8304 
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095               cpu.scrpad.restore.exit:
0096 F064 C2E0  34         mov   @rambuf,r11           ; Restore return address
     F066 2F6A 
0097 F068 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0072                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/modules/snd_player.asm"
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
0014 F06A 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     F06C 8334 
0015 F06E 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     F070 2006 
0016 F072 0204  20         li    tmp0,muttab
     F074 F084 
0017 F076 0205  20         li    tmp1,sound            ; Sound generator port >8400
     F078 8400 
0018 F07A D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 F07C D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 F07E D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 F080 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 F082 045B  20         b     *r11
0023 F084 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     F086 DFFF 
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
0043 F088 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     F08A 8334 
0044 F08C C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     F08E 8336 
0045 F090 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     F092 FFF8 
0046 F094 E0BB  30         soc   *r11+,config          ; Set options
0047 F096 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     F098 2012 
     F09A 831B 
0048 F09C 045B  20         b     *r11
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
0059 F09E 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     F0A0 2006 
0060 F0A2 1301  14         jeq   sdpla1                ; Yes, play
0061 F0A4 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 F0A6 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 F0A8 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     F0AA 831B 
     F0AC 2000 
0067 F0AE 1301  14         jeq   sdpla3                ; Play next note
0068 F0B0 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 F0B2 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     F0B4 2002 
0070 F0B6 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 F0B8 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     F0BA 8336 
0075 F0BC 06C4  14         swpb  tmp0
0076 F0BE D804  38         movb  tmp0,@vdpa
     F0C0 8C02 
0077 F0C2 06C4  14         swpb  tmp0
0078 F0C4 D804  38         movb  tmp0,@vdpa
     F0C6 8C02 
0079 F0C8 04C4  14         clr   tmp0
0080 F0CA D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     F0CC 8800 
0081 F0CE 131E  14         jeq   sdexit                ; Yes. exit
0082 F0D0 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 F0D2 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     F0D4 8336 
0084 F0D6 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     F0D8 8800 
     F0DA 8400 
0085 F0DC 0604  14         dec   tmp0
0086 F0DE 16FB  14         jne   vdpla2
0087 F0E0 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     F0E2 8800 
     F0E4 831B 
0088 F0E6 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     F0E8 8336 
0089 F0EA 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 F0EC C120  34 mmplay  mov   @wsdtmp,tmp0
     F0EE 8336 
0094 F0F0 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 F0F2 130C  14         jeq   sdexit                ; Yes, exit
0096 F0F4 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 F0F6 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     F0F8 8336 
0098 F0FA D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     F0FC 8400 
0099 F0FE 0605  14         dec   tmp1
0100 F100 16FC  14         jne   mmpla2
0101 F102 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     F104 831B 
0102 F106 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     F108 8336 
0103 F10A 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 F10C 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     F10E 2004 
0108 F110 1607  14         jne   sdexi2                ; No, exit
0109 F112 C820  54         mov   @wsdlst,@wsdtmp
     F114 8334 
     F116 8336 
0110 F118 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     F11A 2012 
     F11C 831B 
0111 F11E 045B  20 sdexi1  b     *r11                  ; Exit
0112 F120 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     F122 FFF8 
0113 F124 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > stevie_b1.asm.56185
0073                                                   ; Spectra 2 extended
0074               
0075               ***************************************************************
0076               * Step 5: Include main editor modules
0077               ********|*****|*********************|**************************
0078               main:
0079                       aorg  kickstart.code2       ; >6046
0080 6046 0460  28         b     @main.stevie          ; Start editor
     6048 604A 
0081                       ;-----------------------------------------------------------------------
0082                       ; Include files
0083                       ;-----------------------------------------------------------------------
0084                       copy  "main.asm"            ; Main file (entrypoint)
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
     6052 3384 
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6054 06A0  32         bl    @mute                 ; Turn sound generators off
     6056 F06A 
0037 6058 06A0  32         bl    @scroff               ; Turn screen off
     605A 269A 
0038               
0039 605C 06A0  32         bl    @f18unl               ; Unlock the F18a
     605E 273E 
0040               
0042               
0043 6060 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6062 233E 
0044 6064 3140                   data >3140            ; F18a VR49 (>31), bit 40
0045               
0047               
0048 6066 06A0  32         bl    @putvr                ; Turn on position based attributes
     6068 233E 
0049 606A 3202                   data >3202            ; F18a VR50 (>32), bit 2
0050               
0051 606C 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     606E 233E 
0052 6070 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0053                       ;------------------------------------------------------
0054                       ; Clear screen (VDP SIT)
0055                       ;------------------------------------------------------
0056 6072 06A0  32         bl    @filv
     6074 229A 
0057 6076 0000                   data >0000,32,vdp.sit.size
     6078 0020 
     607A 0960 
0058                                                   ; Clear screen
0059                       ;------------------------------------------------------
0060                       ; Initialize high memory expansion
0061                       ;------------------------------------------------------
0062 607C 06A0  32         bl    @film
     607E 2242 
0063 6080 A000                   data >a000,00,20000   ; Clear a000-eedf
     6082 0000 
     6084 4E20 
0064                       ;------------------------------------------------------
0065                       ; Setup SAMS windows
0066                       ;------------------------------------------------------
0067 6086 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6088 3390 
0068                       ;------------------------------------------------------
0069                       ; Setup cursor, screen, etc.
0070                       ;------------------------------------------------------
0071 608A 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608C 26BA 
0072 608E 06A0  32         bl    @s8x8                 ; Small sprite
     6090 26CA 
0073               
0074 6092 06A0  32         bl    @cpym2m
     6094 24E6 
0075 6096 33BA                   data romsat,ramsat,14 ; Load sprite SAT
     6098 2F5A 
     609A 000E 
0076               
0077 609C C820  54         mov   @romsat+2,@tv.curshape
     609E 33BC 
     60A0 A014 
0078                                                   ; Save cursor shape & color
0079               
0080 60A2 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     60A4 7D3A 
0081               *--------------------------------------------------------------
0082               * Initialize
0083               *--------------------------------------------------------------
0084 60A6 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A8 3290 
0085 60AA 06A0  32         bl    @tv.reset             ; Reset editor
     60AC 32B6 
0086                       ;------------------------------------------------------
0087                       ; Load colorscheme amd turn on screen
0088                       ;------------------------------------------------------
0089 60AE 06A0  32         bl    @pane.action.colorscheme.Load
     60B0 76F8 
0090                                                   ; Load color scheme and turn on screen
0091                       ;-------------------------------------------------------
0092                       ; Setup editor tasks & hook
0093                       ;-------------------------------------------------------
0094 60B2 0204  20         li    tmp0,>0300
     60B4 0300 
0095 60B6 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60B8 8314 
0096               
0097 60BA 06A0  32         bl    @at
     60BC 26DA 
0098 60BE 0000                   data  >0000           ; Cursor YX position = >0000
0099               
0100 60C0 0204  20         li    tmp0,timers
     60C2 2F4A 
0101 60C4 C804  38         mov   tmp0,@wtitab
     60C6 832C 
0102               
0104               
0105 60C8 06A0  32         bl    @mkslot
     60CA 2E14 
0106 60CC 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CE 74AE 
0107 60D0 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60D2 753A 
0108 60D4 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D6 75D6 
0109 60D8 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60DA 7604 
0110 60DC FFFF                   data eol
0111               
0121               
0122               
0123 60DE 06A0  32         bl    @mkhook
     60E0 2E00 
0124 60E2 7458                   data hook.keyscan     ; Setup user hook
0125               
0126 60E4 0460  28         b     @tmgr                 ; Start timers and kthread
     60E6 2D56 
**** **** ****     > stevie_b1.asm.56185
0085                       ;-----------------------------------------------------------------------
0086                       ; Keyboard actions
0087                       ;-----------------------------------------------------------------------
0088                       copy  "edkey.key.process.asm"
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 60E8 C160  34         mov   @waux1,tmp1           ; \
     60EA 833C 
0009 60EC 0245  22         andi  tmp1,>ff00            ; | Get key value and clear LSB
     60EE FF00 
0010 60F0 C805  38         mov   tmp1,@waux1           ; /
     60F2 833C 
0011 60F4 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 60F6 C1A0  34         mov   @tv.pane.focus,tmp2
     60F8 A022 
0016 60FA 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60FC 0000 
0017 60FE 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 6100 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6102 0001 
0021 6104 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 6106 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6108 FFCE 
0027 610A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     610C 2026 
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 610E 0206  20         li    tmp2,keymap_actions.editor
     6110 7EA0 
0033 6112 1002  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6114 0206  20         li    tmp2,keymap_actions.cmdb
     6116 7F3A 
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 6118 91D6  26         cb    *tmp2,tmp3            ; EOL reached ?
0044 611A 1327  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed, so
0046                                                   ; add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 611C 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0051 611E 130F  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053                       ;-------------------------------------------------------
0054                       ; If key in range 'a..z' then also check 'A..Z'
0055                       ;-------------------------------------------------------
0056 6120 0285  22         ci    tmp1,>6100            ; ASCII 97 'a'
     6122 6100 
0057 6124 1109  14         jlt   edkey.key.check.next.entry
0058               
0059 6126 0285  22         ci    tmp1,>7a00            ; ASCII 122 'z'
     6128 7A00 
0060 612A 1506  14         jgt   edkey.key.check.next.entry
0061               
0062 612C 0225  22         ai    tmp1,->2000           ; Make uppercase
     612E E000 
0063 6130 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0064 6132 1305  14         jeq   edkey.key.check.scope
0065                                                   ; Yes, check scope
0066                       ;-------------------------------------------------------
0067                       ; Key is no action key, keep case for later (buffer)
0068                       ;-------------------------------------------------------
0069 6134 0225  22         ai    tmp1,>2000            ; Make lowercase
     6136 2000 
0070               
0071               edkey.key.check.next.entry:
0072 6138 0226  22         ai    tmp2,4                ; Skip current entry
     613A 0004 
0073 613C 10ED  14         jmp   edkey.key.check.next  ; Check next entry
0074                       ;-------------------------------------------------------
0075                       ; Check scope of key
0076                       ;-------------------------------------------------------
0077               edkey.key.check.scope:
0078 613E 0586  14         inc   tmp2                  ; Move to scope
0079 6140 9816  46         cb    *tmp2,@tv.pane.focus+1
     6142 A023 
0080                                                   ; (1) Process key if scope matches pane
0081 6144 1308  14         jeq   edkey.key.process.action
0082               
0083 6146 9816  46         cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
     6148 A31B 
0084 614A 1305  14         jeq   edkey.key.process.action
0085                       ;-------------------------------------------------------
0086                       ; Key pressed outside valid scope, ignore action entry
0087                       ;-------------------------------------------------------
0088 614C 0226  22         ai    tmp2,3                ; Skip current entry
     614E 0003 
0089 6150 C160  34         mov   @waux1,tmp1           ; Restore original case of key
     6152 833C 
0090 6154 10E1  14         jmp   edkey.key.check.next  ; Process next action entry
0091                       ;-------------------------------------------------------
0092                       ; Trigger keyboard action
0093                       ;-------------------------------------------------------
0094               edkey.key.process.action:
0095 6156 0586  14         inc   tmp2                  ; Move to action address
0096 6158 C196  26         mov   *tmp2,tmp2            ; Get action address
0097               
0098 615A 0204  20         li    tmp0,id.dialog.unsaved
     615C 0065 
0099 615E 8120  34         c     @cmdb.dialog,tmp0
     6160 A31A 
0100 6162 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0101               
0102 6164 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6166 A326 
0103 6168 0456  20 !       b     *tmp2                 ; Process key action
0104                       ;-------------------------------------------------------
0105                       ; Add character to editor or cmdb buffer
0106                       ;-------------------------------------------------------
0107               edkey.key.process.addbuffer:
0108 616A C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     616C A022 
0109 616E 1602  14         jne   !                     ; No, skip frame buffer
0110 6170 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6172 65F6 
0111                       ;-------------------------------------------------------
0112                       ; CMDB buffer
0113                       ;-------------------------------------------------------
0114 6174 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6176 0001 
0115 6178 1607  14         jne   edkey.key.process.crash
0116                                                   ; No, crash
0117                       ;-------------------------------------------------------
0118                       ; Don't add character if dialog has ID >= 100
0119                       ;-------------------------------------------------------
0120 617A C120  34         mov   @cmdb.dialog,tmp0
     617C A31A 
0121 617E 0284  22         ci    tmp0,99
     6180 0063 
0122 6182 1506  14         jgt   edkey.key.process.exit
0123                       ;-------------------------------------------------------
0124                       ; Add character to CMDB
0125                       ;-------------------------------------------------------
0126 6184 0460  28         b     @edkey.action.cmdb.char
     6186 680E 
0127                                                   ; Add character to CMDB buffer
0128                       ;-------------------------------------------------------
0129                       ; Crash
0130                       ;-------------------------------------------------------
0131               edkey.key.process.crash:
0132 6188 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     618A FFCE 
0133 618C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     618E 2026 
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137               edkey.key.process.exit:
0138 6190 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6192 74A2 
**** **** ****     > stevie_b1.asm.56185
0089                                                   ; Process keyboard actions
0090                       ;-----------------------------------------------------------------------
0091                       ; Keyboard actions - Framebuffer (1)
0092                       ;-----------------------------------------------------------------------
0093                       copy  "edkey.fb.mov.leftright.asm"
**** **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 6194 C120  34         mov   @fb.column,tmp0
     6196 A10C 
0009 6198 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 619A 0620  34         dec   @fb.column            ; Column-- in screen buffer
     619C A10C 
0014 619E 0620  34         dec   @wyx                  ; Column-- VDP cursor
     61A0 832A 
0015 61A2 0620  34         dec   @fb.current
     61A4 A102 
0016 61A6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61A8 A118 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 61AA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61AC 74A2 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 61AE 8820  54         c     @fb.column,@fb.row.length
     61B0 A10C 
     61B2 A108 
0028 61B4 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 61B6 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     61B8 A10C 
0033 61BA 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     61BC 832A 
0034 61BE 05A0  34         inc   @fb.current
     61C0 A102 
0035 61C2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C4 A118 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 61C6 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61C8 74A2 
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61CA 06A0  32         bl    @fb.cursor.home       ; Move cursor to beginning of line
     61CC 6A94 
0047                       ;-------------------------------------------------------
0048                       ; Exit
0049                       ;-------------------------------------------------------
0050 61CE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61D0 74A2 
0051               
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.end:
0057 61D2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61D4 A118 
0058 61D6 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61D8 A108 
0059 61DA 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61DC 0050 
0060 61DE 1102  14         jlt   !                     ; | is right of last character on line,
0061 61E0 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61E2 004F 
0062                       ;-------------------------------------------------------
0063                       ; Set cursor X position
0064                       ;-------------------------------------------------------
0065 61E4 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61E6 A10C 
0066 61E8 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61EA 26F2 
0067 61EC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61EE 6996 
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071 61F0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61F2 74A2 
**** **** ****     > stevie_b1.asm.56185
0094                                                        ; Move left / right / home / end
0095                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61F4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61F6 A118 
0009 61F8 C120  34         mov   @fb.column,tmp0
     61FA A10C 
0010 61FC 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61FE C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6200 A102 
0015 6202 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 6204 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 6206 0605  14         dec   tmp1
0022 6208 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 620A 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 620C D195  26         movb  *tmp1,tmp2            ; Get character
0030 620E 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 6210 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 6212 0986  56         srl   tmp2,8                ; Right justify
0033 6214 0286  22         ci    tmp2,32               ; Space character found?
     6216 0020 
0034 6218 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 621A 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     621C 2020 
0040 621E 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 6220 0287  22         ci    tmp3,>20ff            ; First character is space
     6222 20FF 
0043 6224 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 6226 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6228 A10C 
0048 622A 61C4  18         s     tmp0,tmp3
0049 622C 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     622E 0002 
0050 6230 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 6232 0585  14         inc   tmp1
0056 6234 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 6236 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6238 A10C 
0062 623A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     623C 26F2 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 623E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6240 6996 
0068 6242 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6244 74A2 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 6246 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6248 A118 
0077 624A 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 624C C120  34         mov   @fb.column,tmp0
     624E A10C 
0079 6250 8804  38         c     tmp0,@fb.row.length
     6252 A108 
0080 6254 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 6256 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6258 A102 
0085 625A 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 625C 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 625E 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 6260 0585  14         inc   tmp1
0097 6262 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6264 8804  38         c     tmp0,@fb.row.length
     6266 A108 
0099 6268 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 626A D195  26         movb  *tmp1,tmp2            ; Get character
0106 626C 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 626E D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 6270 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6272 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6274 FFFF 
0111 6276 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 6278 0286  22         ci    tmp2,32
     627A 0020 
0117 627C 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 627E 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 6280 0286  22         ci    tmp2,32               ; Space character found?
     6282 0020 
0125 6284 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 6286 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6288 2020 
0131 628A 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 628C 0287  22         ci    tmp3,>20ff            ; First characer is space?
     628E 20FF 
0134 6290 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 6292 0585  14         inc   tmp1
0139 6294 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 6296 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6298 A10C 
0145 629A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     629C 26F2 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 629E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62A0 6996 
0151 62A2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62A4 74A2 
0152               
0153               
**** **** ****     > stevie_b1.asm.56185
0096                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 62A6 06A0  32         bl    @fb.cursor.up         ; Move cursor up
     62A8 69BE 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.up.exit:
0013 62AA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62AC 74A2 
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Cursor down
0019               *---------------------------------------------------------------
0020               edkey.action.down:
0021 62AE 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     62B0 6A1C 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.down.exit:
0026 62B2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62B4 74A2 
**** **** ****     > stevie_b1.asm.56185
0097                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 62B6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62B8 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 62BA 8820  54         c     @fb.row.dirty,@w$ffff
     62BC A10A 
     62BE 2022 
0013 62C0 1604  14         jne   edkey.action.ppage.sanity
0014 62C2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62C4 6E62 
0015 62C6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62C8 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 62CA C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     62CC A104 
0021 62CE 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 62D0 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     62D2 A11A 
0026 62D4 1503  14         jgt   edkey.action.ppage.topline
0027 62D6 04E0  34         clr   @fb.topline           ; topline = 0
     62D8 A104 
0028 62DA 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 62DC 6820  54         s     @fb.scrrows,@fb.topline
     62DE A11A 
     62E0 A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 62E2 C820  54         mov   @fb.topline,@parm1
     62E4 A104 
     62E6 2F20 
0039 62E8 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62EA A110 
0040               
0041 62EC 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 62EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62F0 74A2 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 62F2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62F4 A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 62F6 8820  54         c     @fb.row.dirty,@w$ffff
     62F8 A10A 
     62FA 2022 
0061 62FC 1604  14         jne   edkey.action.npage.sanity
0062 62FE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6300 6E62 
0063 6302 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6304 A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 6306 C120  34         mov   @fb.topline,tmp0
     6308 A104 
0069 630A A120  34         a     @fb.scrrows,tmp0
     630C A11A 
0070 630E 0584  14         inc   tmp0                  ; Base 1 offset !
0071 6310 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6312 A204 
0072 6314 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 6316 A820  54         a     @fb.scrrows,@fb.topline
     6318 A11A 
     631A A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 631C C820  54         mov   @fb.topline,@parm1
     631E A104 
     6320 2F20 
0083 6322 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6324 A110 
0084               
0085 6326 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 6328 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     632A 74A2 
**** **** ****     > stevie_b1.asm.56185
0098                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
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
0011 632C 8820  54         c     @fb.row.dirty,@w$ffff
     632E A10A 
     6330 2022 
0012 6332 1604  14         jne   edkey.action.top.refresh
0013 6334 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6336 6E62 
0014 6338 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     633A A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 633C 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     633E 2F20 
0020 6340 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6342 A110 
0021               
0022 6344 0460  28         b     @ _edkey.goto.fb.toprow
     6346 6378 
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
0035 6348 8820  54         c     @fb.row.dirty,@w$ffff
     634A A10A 
     634C 2022 
0036 634E 1604  14         jne   edkey.action.bot.refresh
0037 6350 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6352 6E62 
0038 6354 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6356 A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 6358 8820  54         c     @edb.lines,@fb.scrrows
     635A A204 
     635C A11A 
0044 635E 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 6360 C120  34         mov   @edb.lines,tmp0
     6362 A204 
0047 6364 6120  34         s     @fb.scrrows,tmp0
     6366 A11A 
0048 6368 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     636A 2F20 
0049 636C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     636E A110 
0050               
0051 6370 0460  28         b     @ _edkey.goto.fb.toprow
     6372 6378 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 6374 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6376 74A2 
**** **** ****     > stevie_b1.asm.56185
0099                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
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
0026 6378 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     637A A118 
0027               
0028 637C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     637E 6B86 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 6380 04E0  34         clr   @fb.row               ; Frame buffer line 0
     6382 A106 
0033 6384 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6386 A10C 
0034 6388 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     638A 832A 
0035               
0036 638C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     638E 6996 
0037               
0038 6390 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6392 7058 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6394 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6396 74A2 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 6398 8820  54         c     @fb.row.dirty,@w$ffff
     639A A10A 
     639C 2022 
0053 639E 1609  14         jne   edkey.action.goto.refresh
0054               
0055 63A0 0649  14         dect  stack
0056 63A2 C660  46         mov   @parm1,*stack         ; Push parm1
     63A4 2F20 
0057 63A6 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63A8 6E62 
0058 63AA C839  50         mov   *stack+,@parm1        ; Pop parm1
     63AC 2F20 
0059               
0060 63AE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63B0 A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 63B2 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63B4 A110 
0066               
0067 63B6 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     63B8 6378 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.56185
0100                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 63BA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     63BC A206 
0009 63BE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63C0 6996 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 63C2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     63C4 A108 
0015 63C6 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 63C8 C120  34         mov   @fb.current,tmp0      ; Get pointer
     63CA A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 63CC C1C6  18         mov   tmp2,tmp3             ; \
0024 63CE 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 63D0 81E0  34         c     @fb.column,tmp3
     63D2 A10C 
0026 63D4 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 63D6 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 63D8 D505  30         movb  tmp1,*tmp0            ; /
0033 63DA C820  54         mov   @fb.column,@fb.row.length
     63DC A10C 
     63DE A108 
0034                                                   ; Row length - 1
0035 63E0 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     63E2 A10A 
0036 63E4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     63E6 A116 
0037 63E8 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 63EA 0286  22         ci    tmp2,colrow
     63EC 0050 
0043 63EE 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 63F0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     63F2 FFCE 
0049 63F4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     63F6 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 63F8 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 63FA 61E0  34         s     @fb.column,tmp3
     63FC A10C 
0056 63FE 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 6400 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 6402 C144  18         mov   tmp0,tmp1
0059 6404 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 6406 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6408 A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 640A C120  34         mov   @fb.current,tmp0      ; Get pointer
     640C A102 
0065 640E C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 6410 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 6412 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 6414 0606  14         dec   tmp2
0073 6416 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 6418 0206  20         li    tmp2,colrow
     641A 0050 
0078 641C 81A0  34         c     @fb.row.length,tmp2
     641E A108 
0079 6420 1603  14         jne   edkey.action.del_char.save
0080 6422 0604  14         dec   tmp0                  ; One time adjustment
0081 6424 04C5  14         clr   tmp1
0082 6426 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 6428 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     642A A10A 
0088 642C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     642E A116 
0089 6430 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6432 A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 6434 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6436 74A2 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 6438 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     643A A206 
0102 643C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     643E 6996 
0103 6440 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6442 A108 
0104 6444 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 6446 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6448 A102 
0110 644A C1A0  34         mov   @fb.colsline,tmp2
     644C A10E 
0111 644E 61A0  34         s     @fb.column,tmp2
     6450 A10C 
0112 6452 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 6454 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 6456 0606  14         dec   tmp2
0119 6458 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 645A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     645C A10A 
0124 645E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6460 A116 
0125               
0126 6462 C820  54         mov   @fb.column,@fb.row.length
     6464 A10C 
     6466 A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 6468 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     646A 74A2 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 646C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     646E 6996 
0143 6470 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6472 A10A 
0144               
0145 6474 C820  54         mov   @fb.topline,@parm1    ; \
     6476 A104 
     6478 2F20 
0146 647A A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     647C A106 
     647E 2F20 
0147 6480 05A0  34         inc   @parm1                ; /
     6482 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6484 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     6486 2F20 
     6488 A204 
0153 648A 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 648C C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     648E A104 
     6490 2F20 
0157 6492 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6494 6B86 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 6496 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6498 62A6 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 649A 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     649C 715E 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 649E 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     64A0 2F20 
     64A2 A204 
0170 64A4 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 64A6 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     64A8 7058 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 64AA C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     64AC A104 
     64AE 2F20 
0183               
0184 64B0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     64B2 6B86 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 64B4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64B6 A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 64B8 C120  34         mov   @fb.topline,tmp0
     64BA A104 
0193 64BC A120  34         a     @fb.row,tmp0
     64BE A106 
0194               
0195 64C0 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64C2 A204 
0196 64C4 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 64C6 0460  28         b     @edkey.action.up      ; Move cursor one line up
     64C8 62A6 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 64CA 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64CC 61CA 
**** **** ****     > stevie_b1.asm.56185
0101                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0010 64CE 0204  20         li    tmp0,>2000            ; White space
     64D0 2000 
0011 64D2 C804  38         mov   tmp0,@parm1
     64D4 2F20 
0012               edkey.action.ins_char:
0013 64D6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64D8 A206 
0014 64DA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64DC 6996 
0015                       ;-------------------------------------------------------
0016                       ; Check 1 - Empty line
0017                       ;-------------------------------------------------------
0018               edkey.actions.ins.char.empty_line:
0019 64DE C120  34         mov   @fb.current,tmp0      ; Get pointer
     64E0 A102 
0020 64E2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64E4 A108 
0021 64E6 133A  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Check 2 - line-wrap if at character 80
0025                       ;-------------------------------------------------------
0026 64E8 C160  34         mov   @fb.column,tmp1
     64EA A10C 
0027 64EC 0285  22         ci    tmp1,colrow-1         ; At 80th character?
     64EE 004F 
0028 64F0 1110  14         jlt   !
0029 64F2 C160  34         mov   @fb.row.length,tmp1
     64F4 A108 
0030 64F6 0285  22         ci    tmp1,colrow
     64F8 0050 
0031 64FA 160B  14         jne   !
0032                       ;-------------------------------------------------------
0033                       ; Wrap to new line
0034                       ;-------------------------------------------------------
0035 64FC 0649  14         dect  Stack
0036 64FE C660  46         mov   @parm1,*stack         ; Save character to add
     6500 2F20 
0037 6502 06A0  32         bl    @fb.cursor.down       ; Move cursor down 1 line
     6504 6A1C 
0038 6506 06A0  32         bl    @fb.insert.line       ; Insert empty line
     6508 6ABE 
0039 650A C839  50         mov   *stack+,@parm1        ; Restore character to add
     650C 2F20 
0040 650E 04C6  14         clr   tmp2                  ; Clear line length
0041 6510 1025  14         jmp   edkey.action.ins_char.append
0042                       ;-------------------------------------------------------
0043                       ; Check 3 - EOL
0044                       ;-------------------------------------------------------
0045 6512 8820  54 !       c     @fb.column,@fb.row.length
     6514 A10C 
     6516 A108 
0046 6518 1321  14         jeq   edkey.action.ins_char.append
0047                                                   ; Add character in append mode
0048                       ;-------------------------------------------------------
0049                       ; Check 4 - Insert only until line length reaches 80th column
0050                       ;-------------------------------------------------------
0051 651A C160  34         mov   @fb.row.length,tmp1
     651C A108 
0052 651E 0285  22         ci    tmp1,colrow
     6520 0050 
0053 6522 1101  14         jlt   edkey.action.ins_char.prep
0054 6524 101D  14         jmp   edkey.action.ins_char.exit
0055                       ;-------------------------------------------------------
0056                       ; Calculate number of characters to move
0057                       ;-------------------------------------------------------
0058               edkey.action.ins_char.prep:
0059 6526 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0060 6528 61E0  34         s     @fb.column,tmp3
     652A A10C 
0061 652C 0607  14         dec   tmp3                  ; Remove base 1 offset
0062 652E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0063 6530 C144  18         mov   tmp0,tmp1
0064 6532 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0065 6534 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6536 A10C 
0066                       ;-------------------------------------------------------
0067                       ; Loop from end of line until current character
0068                       ;-------------------------------------------------------
0069               edkey.action.ins_char.loop:
0070 6538 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0071 653A 0604  14         dec   tmp0
0072 653C 0605  14         dec   tmp1
0073 653E 0606  14         dec   tmp2
0074 6540 16FB  14         jne   edkey.action.ins_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Insert specified character at current position
0077                       ;-------------------------------------------------------
0078 6542 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     6544 2F20 
0079                       ;-------------------------------------------------------
0080                       ; Save variables and exit
0081                       ;-------------------------------------------------------
0082 6546 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6548 A10A 
0083 654A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     654C A116 
0084 654E 05A0  34         inc   @fb.column
     6550 A10C 
0085 6552 05A0  34         inc   @wyx
     6554 832A 
0086 6556 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6558 A108 
0087 655A 1002  14         jmp   edkey.action.ins_char.exit
0088                       ;-------------------------------------------------------
0089                       ; Add character in append mode
0090                       ;-------------------------------------------------------
0091               edkey.action.ins_char.append:
0092 655C 0460  28         b     @edkey.action.char.overwrite
     655E 661C 
0093                       ;-------------------------------------------------------
0094                       ; Exit
0095                       ;-------------------------------------------------------
0096               edkey.action.ins_char.exit:
0097 6560 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6562 74A2 
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
0108 6564 06A0  32         bl    @fb.insert.line       ; Insert new line
     6566 6ABE 
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.ins_line.exit:
0113 6568 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     656A 74A2 
**** **** ****     > stevie_b1.asm.56185
0102                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 656C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     656E A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 6570 8820  54         c     @fb.row.dirty,@w$ffff
     6572 A10A 
     6574 2022 
0013 6576 1606  14         jne   edkey.action.enter.upd_counter
0014 6578 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     657A A206 
0015 657C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     657E 6E62 
0016 6580 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6582 A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6584 C120  34         mov   @fb.topline,tmp0
     6586 A104 
0022 6588 A120  34         a     @fb.row,tmp0
     658A A106 
0023 658C 0584  14         inc   tmp0
0024 658E 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6590 A204 
0025 6592 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6594 05A0  34         inc   @edb.lines            ; Total lines++
     6596 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6598 C120  34         mov   @fb.scrrows,tmp0
     659A A11A 
0035 659C 0604  14         dec   tmp0
0036 659E 8120  34         c     @fb.row,tmp0
     65A0 A106 
0037 65A2 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 65A4 C120  34         mov   @fb.scrrows,tmp0
     65A6 A11A 
0042 65A8 C820  54         mov   @fb.topline,@parm1
     65AA A104 
     65AC 2F20 
0043 65AE 05A0  34         inc   @parm1
     65B0 2F20 
0044 65B2 06A0  32         bl    @fb.refresh
     65B4 6B86 
0045 65B6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     65B8 A110 
0046 65BA 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 65BC 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65BE A106 
0052 65C0 06A0  32         bl    @down                 ; Row++ VDP cursor
     65C2 26E0 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 65C4 06A0  32         bl    @fb.get.firstnonblank
     65C6 6B3E 
0058 65C8 C120  34         mov   @outparm1,tmp0
     65CA 2F30 
0059 65CC C804  38         mov   tmp0,@fb.column
     65CE A10C 
0060 65D0 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65D2 26F2 
0061 65D4 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65D6 7058 
0062 65D8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65DA 6996 
0063 65DC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65DE A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 65E0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65E2 74A2 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 65E4 0649  14         dect  stack
0078 65E6 C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 65E8 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65EA A118 
0081 65EC 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65EE A20A 
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 65F0 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 65F2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65F4 74A2 
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 65F6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65F8 A118 
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 65FA D105  18         movb  tmp1,tmp0             ; Get keycode
0100 65FC 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 65FE 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6600 0020 
0103 6602 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 6604 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6606 007E 
0107 6608 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 660A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     660C A206 
0113 660E D805  38         movb  tmp1,@parm1           ; Store character for insert
     6610 2F20 
0114 6612 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6614 A20A 
0115 6616 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 6618 0460  28         b     @edkey.action.ins_char
     661A 64D6 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 661C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     661E 6996 
0126 6620 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6622 A102 
0127               
0128 6624 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6626 2F20 
0129 6628 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     662A A10A 
0130 662C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     662E A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 6630 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6632 A10C 
0135 6634 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     6636 004F 
0136 6638 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 663A 0205  20         li    tmp1,colrow           ; \
     663C 0050 
0140 663E C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     6640 A108 
0141 6642 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 6644 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6646 A10C 
0147 6648 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     664A 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 664C 8820  54         c     @fb.column,@fb.row.length
     664E A10C 
     6650 A108 
0152                                                   ; column < line length ?
0153 6652 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 6654 C820  54         mov   @fb.column,@fb.row.length
     6656 A10C 
     6658 A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 665A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     665C 74A2 
**** **** ****     > stevie_b1.asm.56185
0103                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 665E C120  34         mov   @edb.dirty,tmp0
     6660 A206 
0012 6662 1302  14         jeq   !
0013 6664 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6666 7DC6 
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 6668 0460  28 !       b     @tv.quit
     666A 3384 
0018               
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Toggle ruler on/off
0023               ********|*****|*********************|**************************
0024               edkey.action.toggle.ruler:
0025 666C 0649  14         dect  stack
0026 666E C644  30         mov   tmp0,*stack           ; Push tmp0
0027 6670 0649  14         dect  stack
0028 6672 C660  46         mov   @wyx,*stack           ; Push cursor YX
     6674 832A 
0029                       ;-------------------------------------------------------
0030                       ; Toggle ruler visibility
0031                       ;-------------------------------------------------------
0032 6676 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6678 A116 
0033 667A 0560  34         inv   @tv.ruler.visible     ; Toggle ruler visibility
     667C A010 
0034 667E 1302  14         jeq   edkey.action.toggle.ruler.fb
0035 6680 06A0  32         bl    @fb.ruler.init        ; Setup ruler in ram
     6682 7E46 
0036                       ;-------------------------------------------------------
0037                       ; Update framebuffer pane
0038                       ;-------------------------------------------------------
0039               edkey.action.toggle.ruler.fb:
0040 6684 06A0  32         bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
     6686 795C 
0041 6688 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     668A 832A 
0042 668C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.toggle.ruler.exit:
0047 668E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6690 74A2 
**** **** ****     > stevie_b1.asm.56185
0104                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 6692 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6694 A444 
     6696 2F20 
0018 6698 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     669A 2F22 
0019 669C 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 669E C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66A0 A444 
     66A2 2F20 
0023 66A4 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     66A6 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 66A8 C120  34         mov   @parm1,tmp0
     66AA 2F20 
0030 66AC 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 66AE C120  34         mov   @edb.dirty,tmp0
     66B0 A206 
0036 66B2 1302  14         jeq   !
0037 66B4 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66B6 7DC6 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 66B8 06A0  32 !       bl    @fm.browse.fname.suffix
     66BA 7D84 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 66BC 0204  20         li    tmp0,heap.top         ; 1st line in heap
     66BE E000 
0047 66C0 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     66C2 7D4C 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 66C4 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66C6 632C 
**** **** ****     > stevie_b1.asm.56185
0105                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 66C8 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     66CA 71EE 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 66CC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66CE 74A2 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 66D0 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     66D2 7216 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 66D4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D6 74A2 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 66D8 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     66DA 723E 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 66DC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66DE 74A2 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 66E0 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     66E2 7BBA 
0043 66E4 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     66E6 727A 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 66E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66EA 74A2 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 66EC 0649  14         dect  stack
0055 66EE C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 66F0 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     66F2 A20E 
     66F4 2022 
0060 66F6 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 66F8 C120  34         mov   @wyx,tmp0             ; Get cursor position
     66FA 832A 
0066 66FC 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     66FE FF00 
0067 6700 C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     6702 A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 6704 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     6706 7BBA 
0072               
0073 6708 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     670A 2F20 
0074 670C 06A0  32         bl    @edb.block.copy       ; Copy code block
     670E 72C0 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 6710 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     6712 2F30 
     6714 2000 
0079 6716 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6718 C820  54         mov   @fb.yxsave,@parm1
     671A A114 
     671C 2F20 
0083 671E 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     6720 6BF6 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 6722 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6724 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6726 74A2 
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
0103 6728 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     672A A20E 
     672C 2022 
0104 672E 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 6730 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6732 7BBA 
0110               
0111 6734 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     6736 2F20 
0112 6738 06A0  32         bl    @edb.block.delete     ; Delete code block
     673A 73B6 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 673C 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     673E 2F30 
     6740 2000 
0119 6742 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 6744 C820  54         mov   @fb.topline,@parm1
     6746 A104 
     6748 2F20 
0123 674A 0460  28         b     @_edkey.goto.fb.toprow
     674C 6378 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 674E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6750 74A2 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 6752 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6754 A20E 
     6756 2022 
0142 6758 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 675A 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     675C 7BBA 
0148               
0149 675E 0720  34         seto  @parm1                ; Set message to "Moving block..."
     6760 2F20 
0150 6762 06A0  32         bl    @edb.block.copy       ; Copy code block
     6764 72C0 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6766 0720  34         seto  @parm1                ; Don't display delete message
     6768 2F20 
0155 676A 06A0  32         bl    @edb.block.delete     ; Delete code block
     676C 73B6 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 676E 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6770 2F30 
     6772 2000 
0162 6774 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6776 C820  54         mov   @fb.topline,@parm1
     6778 A104 
     677A 2F20 
0166 677C 0460  28         b     @_edkey.goto.fb.toprow
     677E 6378 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 6780 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6782 74A2 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 6784 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6786 A20C 
     6788 2022 
0182 678A 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 678C C820  54         mov   @edb.block.m1,@parm1
     678E A20C 
     6790 2F20 
0188 6792 0620  34         dec   @parm1                ; Base 0 offset
     6794 2F20 
0189               
0190 6796 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6798 6398 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 679A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     679C 74A2 
**** **** ****     > stevie_b1.asm.56185
0106                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
**** **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 679E 0649  14         dect  stack
0009 67A0 C64B  30         mov   r11,*stack            ; Save return address
0010 67A2 06A0  32         bl    @fb.tab.next          ; Jump to next tab position on line
     67A4 7E34 
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 67A6 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 67A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67AA 74A2 
**** **** ****     > stevie_b1.asm.56185
0107                       ;-----------------------------------------------------------------------
0108                       ; Keyboard actions - Command Buffer
0109                       ;-----------------------------------------------------------------------
0110                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 67AC C120  34         mov   @cmdb.column,tmp0
     67AE A312 
0009 67B0 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 67B2 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     67B4 A312 
0014 67B6 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     67B8 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 67BA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     67BC 74A2 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 67BE 06A0  32         bl    @cmdb.cmd.getlength
     67C0 7E20 
0026 67C2 8820  54         c     @cmdb.column,@outparm1
     67C4 A312 
     67C6 2F30 
0027 67C8 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 67CA 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     67CC A312 
0032 67CE 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     67D0 A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 67D2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     67D4 74A2 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 67D6 04C4  14         clr   tmp0
0045 67D8 C804  38         mov   tmp0,@cmdb.column      ; First column
     67DA A312 
0046 67DC 0584  14         inc   tmp0
0047 67DE D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     67E0 A30A 
0048 67E2 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     67E4 A30A 
0049               
0050 67E6 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     67E8 74A2 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 67EA D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     67EC A328 
0057 67EE 0984  56         srl   tmp0,8                 ; Right justify
0058 67F0 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     67F2 A312 
0059 67F4 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 67F6 0224  22         ai    tmp0,>1a00             ; Y=26
     67F8 1A00 
0061 67FA C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     67FC A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 67FE 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6800 74A2 
**** **** ****     > stevie_b1.asm.56185
0111                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 6802 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6804 7E16 
0026 6806 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6808 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 680A 0460  28         b     @edkey.action.cmdb.home
     680C 67D6 
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
0060 680E D105  18         movb  tmp1,tmp0             ; Get keycode
0061 6810 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6812 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6814 0020 
0064 6816 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6818 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     681A 007E 
0068 681C 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 681E 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6820 A318 
0074               
0075 6822 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6824 A329 
0076 6826 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6828 A312 
0077 682A D505  30         movb  tmp1,*tmp0            ; Add character
0078 682C 05A0  34         inc   @cmdb.column          ; Next column
     682E A312 
0079 6830 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6832 A30A 
0080               
0081 6834 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6836 7E20 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 6838 C120  34         mov   @outparm1,tmp0
     683A 2F30 
0088 683C 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 683E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6840 A328 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 6842 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6844 74A2 
**** **** ****     > stevie_b1.asm.56185
0112                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6846 C120  34         mov   @cmdb.visible,tmp0
     6848 A302 
0009 684A 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 684C 04E0  34         clr   @cmdb.column          ; Column = 0
     684E A312 
0015 6850 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6852 790C 
0016 6854 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6856 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6858 795C 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 685A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     685C 74A2 
**** **** ****     > stevie_b1.asm.56185
0113                       copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
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
0011 685E 0649  14         dect  stack
0012 6860 C64B  30         mov   r11,*stack            ; Save return address
0013 6862 0649  14         dect  stack
0014 6864 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 6866 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6868 A206 
0019 686A 1303  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 686C 06A0  32         bl    @dialog.unsaved       ; Show dialog
     686E 7DC6 
0022 6870 1004  14         jmp   edkey.action.cmdb.file.new.exit
0023                       ;-------------------------------------------------------
0024                       ; Reset editor
0025                       ;-------------------------------------------------------
0026 6872 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     6874 795C 
0027 6876 06A0  32         bl    @tv.reset             ; Reset editor
     6878 32B6 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.file.new.exit:
0032 687A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0033 687C C2F9  30         mov   *stack+,r11           ; Pop R11
0034 687E 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     6880 632C 
**** **** ****     > stevie_b1.asm.56185
0114                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
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
0011 6882 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6884 795C 
0012               
0013 6886 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6888 7E20 
0014 688A C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     688C 2F30 
0015 688E 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6890 06A0  32         bl    @pane.errline.show    ; Show error line
     6892 7B52 
0020               
0021 6894 06A0  32         bl    @pane.show_hint
     6896 7686 
0022 6898 1C00                   byte pane.botrow-1,0
0023 689A 399A                   data txt.io.nofile
0024               
0025 689C 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 689E 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 68A0 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68A2 A328 
0031               
0032 68A4 06A0  32         bl    @cpym2m
     68A6 24E6 
0033 68A8 A328                   data cmdb.cmdlen,heap.top,80
     68AA E000 
     68AC 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68AE 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68B0 E000 
0039 68B2 C804  38         mov   tmp0,@parm1
     68B4 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 68B6 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68B8 E000 
0045 68BA C804  38         mov   tmp0,@parm1
     68BC 2F20 
0046               
0047 68BE 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     68C0 7D4C 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 68C2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     68C4 632C 
**** **** ****     > stevie_b1.asm.56185
0115                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
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
0011 68C6 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     68C8 795C 
0012               
0013 68CA 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68CC 7E20 
0014 68CE C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     68D0 2F30 
0015 68D2 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 68D4 06A0  32         bl    @pane.errline.show    ; Show error line
     68D6 7B52 
0020               
0021 68D8 06A0  32         bl    @pane.show_hint
     68DA 7686 
0022 68DC 1C00                   byte pane.botrow-1,0
0023 68DE 399A                   data txt.io.nofile
0024               
0025 68E0 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 68E2 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 68E4 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68E6 A328 
0031               
0032 68E8 06A0  32         bl    @cpym2m
     68EA 24E6 
0033 68EC A328                   data cmdb.cmdlen,heap.top,80
     68EE E000 
     68F0 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68F2 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68F4 E000 
0039 68F6 C804  38         mov   tmp0,@parm1
     68F8 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 68FA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     68FC A20E 
     68FE 2022 
0044 6900 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 6902 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6904 A20C 
     6906 2F22 
0050 6908 0620  34         dec   @parm2                ; /
     690A 2F22 
0051               
0052 690C C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     690E A20E 
     6910 2F24 
0053               
0054 6912 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 6914 04E0  34         clr   @parm2                ; First line to save
     6916 2F22 
0060 6918 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     691A A204 
     691C 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 691E 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6920 7D72 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 6922 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6924 632C 
**** **** ****     > stevie_b1.asm.56185
0116                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0020 6926 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6928 A206 
0021 692A 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     692C 78A2 
0022 692E 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6930 7E16 
0023 6932 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6934 A326 
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6936 0284  22         ci    tmp0,>2000
     6938 2000 
0028 693A 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 693C 0284  22         ci    tmp0,>7fff
     693E 7FFF 
0031 6940 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6942 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6944 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6946 FFCE 
0040 6948 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     694A 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 694C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     694E 74A2 
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
0063 6950 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6952 7D96 
0064 6954 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6956 A318 
0065 6958 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     695A 74A2 
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
0086 695C 06A0  32         bl    @hchar
     695E 27D4 
0087 6960 0000                   byte 0,0,32,80*2
     6962 20A0 
0088 6964 FFFF                   data EOL
0089 6966 1000  14         jmp   edkey.action.cmdb.close.dialog
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
0108 6968 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     696A A31A 
0109 696C 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     696E 78A2 
0110 6970 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6972 795C 
0111 6974 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6976 A118 
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6978 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     697A 74A2 
**** **** ****     > stevie_b1.asm.56185
0117                       ;-----------------------------------------------------------------------
0118                       ; Logic for Framebuffer (1)
0119                       ;-----------------------------------------------------------------------
0120                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 697C 0649  14         dect  stack
0025 697E C64B  30         mov   r11,*stack            ; Save return address
0026 6980 0649  14         dect  stack
0027 6982 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6984 C120  34         mov   @parm1,tmp0
     6986 2F20 
0032 6988 A120  34         a     @fb.topline,tmp0
     698A A104 
0033 698C C804  38         mov   tmp0,@outparm1
     698E 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6990 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6992 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6994 045B  20         b     *r11                  ; Return to caller
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
0068 6996 0649  14         dect  stack
0069 6998 C64B  30         mov   r11,*stack            ; Save return address
0070 699A 0649  14         dect  stack
0071 699C C644  30         mov   tmp0,*stack           ; Push tmp0
0072 699E 0649  14         dect  stack
0073 69A0 C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 69A2 C120  34         mov   @fb.row,tmp0
     69A4 A106 
0078 69A6 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     69A8 A10E 
0079 69AA A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     69AC A10C 
0080 69AE A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     69B0 A100 
0081 69B2 C805  38         mov   tmp1,@fb.current
     69B4 A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 69B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 69B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 69BA C2F9  30         mov   *stack+,r11           ; Pop r11
0089 69BC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0121                       copy  "fb.cursor.up.asm"    ; Cursor up
**** **** ****     > fb.cursor.up.asm
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
0021 69BE 0649  14         dect  stack
0022 69C0 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;-------------------------------------------------------
0024                       ; Crunch current line if dirty
0025                       ;-------------------------------------------------------
0026 69C2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     69C4 A118 
0027 69C6 8820  54         c     @fb.row.dirty,@w$ffff
     69C8 A10A 
     69CA 2022 
0028 69CC 1604  14         jne   fb.cursor.up.cursor
0029 69CE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     69D0 6E62 
0030 69D2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     69D4 A10A 
0031                       ;-------------------------------------------------------
0032                       ; Move cursor
0033                       ;-------------------------------------------------------
0034               fb.cursor.up.cursor:
0035 69D6 C120  34         mov   @fb.row,tmp0
     69D8 A106 
0036 69DA 150B  14         jgt   fb.cursor.up.cursor_up
0037                                                   ; Move cursor up if fb.row > 0
0038 69DC C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     69DE A104 
0039 69E0 130C  14         jeq   fb.cursor.up.set_cursorx
0040                                                   ; At top, only position cursor X
0041                       ;-------------------------------------------------------
0042                       ; Scroll 1 line
0043                       ;-------------------------------------------------------
0044 69E2 0604  14         dec   tmp0                  ; fb.topline--
0045 69E4 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     69E6 2F20 
0046               
0047 69E8 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     69EA 6B86 
0048                                                   ; | i  @parm1 = Line to start with
0049                                                   ; /             (becomes @fb.topline)
0050               
0051 69EC 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     69EE A110 
0052 69F0 1004  14         jmp   fb.cursor.up.set_cursorx
0053                       ;-------------------------------------------------------
0054                       ; Move cursor up
0055                       ;-------------------------------------------------------
0056               fb.cursor.up.cursor_up:
0057 69F2 0620  34         dec   @fb.row               ; Row-- in screen buffer
     69F4 A106 
0058 69F6 06A0  32         bl    @up                   ; Row-- VDP cursor
     69F8 26E8 
0059                       ;-------------------------------------------------------
0060                       ; Check line length and position cursor
0061                       ;-------------------------------------------------------
0062               fb.cursor.up.set_cursorx:
0063 69FA 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     69FC 7058 
0064                                                   ; | i  @fb.row        = Row in frame buffer
0065                                                   ; / o  @fb.row.length = Length of row
0066               
0067 69FE 8820  54         c     @fb.column,@fb.row.length
     6A00 A10C 
     6A02 A108 
0068 6A04 1207  14         jle   fb.cursor.up.exit
0069                       ;-------------------------------------------------------
0070                       ; Adjust cursor column position
0071                       ;-------------------------------------------------------
0072 6A06 C820  54         mov   @fb.row.length,@fb.column
     6A08 A108 
     6A0A A10C 
0073 6A0C C120  34         mov   @fb.column,tmp0
     6A0E A10C 
0074 6A10 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6A12 26F2 
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               fb.cursor.up.exit:
0079 6A14 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6A16 6996 
0080 6A18 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6A1A 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0122                       copy  "fb.cursor.down.asm"  ; Cursor down
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
0021 6A1C 0649  14         dect  stack
0022 6A1E C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6A20 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6A22 A106 
     6A24 A204 
0027 6A26 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6A28 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A2A A118 
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6A2C 8820  54         c     @fb.row.dirty,@w$ffff
     6A2E A10A 
     6A30 2022 
0034 6A32 1604  14         jne   fb.cursor.down.move
0035 6A34 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6A36 6E62 
0036 6A38 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6A3A A10A 
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6A3C C120  34         mov   @fb.topline,tmp0
     6A3E A104 
0045 6A40 A120  34         a     @fb.row,tmp0
     6A42 A106 
0046 6A44 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6A46 A204 
0047 6A48 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6A4A C120  34         mov   @fb.scrrows,tmp0
     6A4C A11A 
0053 6A4E 0604  14         dec   tmp0
0054 6A50 8120  34         c     @fb.row,tmp0
     6A52 A106 
0055 6A54 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6A56 C820  54         mov   @fb.topline,@parm1
     6A58 A104 
     6A5A 2F20 
0060 6A5C 05A0  34         inc   @parm1
     6A5E 2F20 
0061               
0062 6A60 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6A62 6B86 
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6A64 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6A66 A110 
0067 6A68 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6A6A 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6A6C A106 
0073 6A6E 06A0  32         bl    @down                 ; Row++ VDP cursor
     6A70 26E0 
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6A72 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6A74 7058 
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6A76 8820  54         c     @fb.column,@fb.row.length
     6A78 A10C 
     6A7A A108 
0083 6A7C 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6A7E C820  54         mov   @fb.row.length,@fb.column
     6A80 A108 
     6A82 A10C 
0089 6A84 C120  34         mov   @fb.column,tmp0
     6A86 A10C 
0090 6A88 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6A8A 26F2 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6A8C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6A8E 6996 
0096 6A90 C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6A92 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0123                       copy  "fb.cursor.home.asm"  ; Cursor home
**** **** ****     > fb.cursor.home.asm
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
0021 6A94 0649  14         dect  stack
0022 6A96 C64B  30         mov   r11,*stack            ; Save return address
0023 6A98 0649  14         dect  stack
0024 6A9A C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;------------------------------------------------------
0026                       ; Cursor home
0027                       ;------------------------------------------------------
0028 6A9C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A9E A118 
0029 6AA0 C120  34         mov   @wyx,tmp0
     6AA2 832A 
0030 6AA4 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6AA6 FF00 
0031 6AA8 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6AAA 832A 
0032 6AAC 04E0  34         clr   @fb.column
     6AAE A10C 
0033 6AB0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AB2 6996 
0034 6AB4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6AB6 A118 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               fb.cursor.home.exit:
0039 6AB8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6ABA C2F9  30         mov   *stack+,r11           ; Pop r11
0041 6ABC 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0124                       copy  "fb.insert.line.asm"  ; Insert new line
**** **** ****     > fb.insert.line.asm
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
0020 6ABE 0649  14         dect  stack
0021 6AC0 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Initialisation
0024                       ;-------------------------------------------------------
0025 6AC2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6AC4 A206 
0026                       ;-------------------------------------------------------
0027                       ; Crunch current line if dirty
0028                       ;-------------------------------------------------------
0029 6AC6 8820  54         c     @fb.row.dirty,@w$ffff
     6AC8 A10A 
     6ACA 2022 
0030 6ACC 1604  14         jne   fb.insert.line.insert
0031 6ACE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6AD0 6E62 
0032 6AD2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6AD4 A10A 
0033                       ;-------------------------------------------------------
0034                       ; Insert entry in index
0035                       ;-------------------------------------------------------
0036               fb.insert.line.insert:
0037 6AD6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AD8 6996 
0038 6ADA C820  54         mov   @fb.topline,@parm1
     6ADC A104 
     6ADE 2F20 
0039 6AE0 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6AE2 A106 
     6AE4 2F20 
0040 6AE6 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6AE8 A204 
     6AEA 2F22 
0041               
0042 6AEC 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6AEE 6D7A 
0043                                                   ; \ i  parm1 = Line for insert
0044                                                   ; / i  parm2 = Last line to reorg
0045               
0046 6AF0 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6AF2 A204 
0047 6AF4 04E0  34         clr   @fb.row.length        ; Current row length = 0
     6AF6 A108 
0048                       ;-------------------------------------------------------
0049                       ; Check/Adjust marker M1
0050                       ;-------------------------------------------------------
0051               fb.insert.line.m1:
0052 6AF8 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6AFA A20C 
     6AFC 2022 
0053 6AFE 1308  14         jeq   fb.insert.line.m2
0054                                                   ; Yes, skip to M2 check
0055               
0056 6B00 8820  54         c     @parm1,@edb.block.m1
     6B02 2F20 
     6B04 A20C 
0057 6B06 1504  14         jgt   fb.insert.line.m2
0058 6B08 05A0  34         inc   @edb.block.m1         ; M1++
     6B0A A20C 
0059 6B0C 0720  34         seto  @fb.colorize          ; Set colorize flag
     6B0E A110 
0060                       ;-------------------------------------------------------
0061                       ; Check/Adjust marker M2
0062                       ;-------------------------------------------------------
0063               fb.insert.line.m2:
0064 6B10 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6B12 A20E 
     6B14 2022 
0065 6B16 1308  14         jeq   fb.insert.line.refresh
0066                                                   ; Yes, skip to refresh frame buffer
0067               
0068 6B18 8820  54         c     @parm1,@edb.block.m2
     6B1A 2F20 
     6B1C A20E 
0069 6B1E 1504  14         jgt   fb.insert.line.refresh
0070 6B20 05A0  34         inc   @edb.block.m2         ; M2++
     6B22 A20E 
0071 6B24 0720  34         seto  @fb.colorize          ; Set colorize flag
     6B26 A110 
0072                       ;-------------------------------------------------------
0073                       ; Refresh frame buffer and physical screen
0074                       ;-------------------------------------------------------
0075               fb.insert.line.refresh:
0076 6B28 C820  54         mov   @fb.topline,@parm1
     6B2A A104 
     6B2C 2F20 
0077               
0078 6B2E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6B30 6B86 
0079                                                   ; | i  @parm1 = Line to start with
0080                                                   ; /             (becomes @fb.topline)
0081               
0082 6B32 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6B34 A116 
0083 6B36 06A0  32         bl    @fb.cursor.home       ; Move cursor home
     6B38 6A94 
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               fb.insert.line.exit:
0088 6B3A C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6B3C 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0125                       copy  "fb.get.firstnonblank.asm"
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
0015 6B3E 0649  14         dect  stack
0016 6B40 C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6B42 04E0  34         clr   @fb.column
     6B44 A10C 
0021 6B46 06A0  32         bl    @fb.calc_pointer
     6B48 6996 
0022 6B4A 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6B4C 7058 
0023 6B4E C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6B50 A108 
0024 6B52 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6B54 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6B56 A102 
0027 6B58 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6B5A D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6B5C 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6B5E 0285  22         ci    tmp1,>2000            ; Whitespace?
     6B60 2000 
0036 6B62 1503  14         jgt   fb.get.firstnonblank.match
0037 6B64 0606  14         dec   tmp2                  ; Counter--
0038 6B66 16F9  14         jne   fb.get.firstnonblank.loop
0039 6B68 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6B6A 6120  34         s     @fb.current,tmp0      ; Calculate column
     6B6C A102 
0045 6B6E 0604  14         dec   tmp0
0046 6B70 C804  38         mov   tmp0,@outparm1        ; Save column
     6B72 2F30 
0047 6B74 D805  38         movb  tmp1,@outparm2        ; Save character
     6B76 2F32 
0048 6B78 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6B7A 04E0  34         clr   @outparm1             ; X=0
     6B7C 2F30 
0054 6B7E 04E0  34         clr   @outparm2             ; Null
     6B80 2F32 
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6B82 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6B84 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0126                                                   ; Get column of first non-blank character
0127                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6B86 0649  14         dect  stack
0021 6B88 C64B  30         mov   r11,*stack            ; Push return address
0022 6B8A 0649  14         dect  stack
0023 6B8C C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B8E 0649  14         dect  stack
0025 6B90 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6B92 0649  14         dect  stack
0027 6B94 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6B96 C820  54         mov   @parm1,@fb.topline
     6B98 2F20 
     6B9A A104 
0032 6B9C 04E0  34         clr   @parm2                ; Target row in frame buffer
     6B9E 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6BA0 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6BA2 2F20 
     6BA4 A204 
0037 6BA6 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6BA8 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6BAA 6F5A 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6BAC 05A0  34         inc   @parm1                ; Next line in editor buffer
     6BAE 2F20 
0048 6BB0 05A0  34         inc   @parm2                ; Next row in frame buffer
     6BB2 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6BB4 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6BB6 2F20 
     6BB8 A204 
0053 6BBA 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6BBC 8820  54         c     @parm2,@fb.scrrows
     6BBE 2F22 
     6BC0 A11A 
0056 6BC2 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6BC4 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6BC6 C120  34         mov   @parm2,tmp0           ; Current row
     6BC8 2F22 
0064 6BCA C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6BCC A11A 
0065 6BCE 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6BD0 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6BD2 A10E 
0067               
0068 6BD4 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6BD6 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6BD8 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6BDA A10E 
0072 6BDC A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6BDE A100 
0073               
0074 6BE0 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6BE2 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6BE4 06A0  32         bl    @xfilm                ; \ Fill memory
     6BE6 2248 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6BE8 0720  34         seto  @fb.dirty             ; Refresh screen
     6BEA A116 
0086 6BEC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6BEE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6BF0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6BF2 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6BF4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0128                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6BF6 0649  14         dect  stack
0022 6BF8 C64B  30         mov   r11,*stack            ; Save return address
0023 6BFA 0649  14         dect  stack
0024 6BFC C660  46         mov   @parm1,*stack         ; Push @parm1
     6BFE 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6C00 C820  54         mov   @fb.topline,@parm1
     6C02 A104 
     6C04 2F20 
0029 6C06 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6C08 6B86 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6C0A 0720  34         seto  @parm1                ; Skip Asserts
     6C0C 2F20 
0035 6C0E 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6C10 7E58 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6C12 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6C14 A018 
     6C16 2F20 
0042 6C18 06A0  32         bl    @pane.action.colorscheme.statlines
     6C1A 786A 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6C1C 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6C1E A118 
0050               
0051 6C20 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6C22 78A2 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6C24 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6C26 2F20 
0057 6C28 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6C2A 2F20 
     6C2C 832A 
0058 6C2E C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6C30 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0129                       ;-----------------------------------------------------------------------
0130                       ; Logic for Index management
0131                       ;-----------------------------------------------------------------------
0132                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6C32 0649  14         dect  stack
0023 6C34 C64B  30         mov   r11,*stack            ; Save return address
0024 6C36 0649  14         dect  stack
0025 6C38 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6C3A 0649  14         dect  stack
0027 6C3C C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6C3E C120  34         mov   @parm1,tmp0           ; Get line number
     6C40 2F20 
0032 6C42 C160  34         mov   @parm2,tmp1           ; Get pointer
     6C44 2F22 
0033 6C46 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6C48 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6C4A 0FFF 
0039 6C4C 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6C4E 06E0  34         swpb  @parm3
     6C50 2F24 
0044 6C52 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6C54 2F24 
0045 6C56 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6C58 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6C5A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C5C 31AA 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6C5E C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6C60 2F30 
0056 6C62 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6C64 B000 
0057 6C66 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C68 2F30 
0058 6C6A 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6C6C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C6E 31AA 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6C70 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C72 2F30 
0068 6C74 04E4  34         clr   @idx.top(tmp0)        ; /
     6C76 B000 
0069 6C78 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C7A 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C7C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C7E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C80 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C82 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0133                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6C84 0649  14         dect  stack
0022 6C86 C64B  30         mov   r11,*stack            ; Save return address
0023 6C88 0649  14         dect  stack
0024 6C8A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C8C 0649  14         dect  stack
0026 6C8E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C90 0649  14         dect  stack
0028 6C92 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C94 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C96 2F20 
0033               
0034 6C98 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C9A 31AA 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C9C C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C9E 2F30 
0039 6CA0 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6CA2 B000 
0040               
0041 6CA4 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6CA6 C185  18         mov   tmp1,tmp2             ; \
0047 6CA8 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6CAA 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6CAC 00FF 
0052 6CAE 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6CB0 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6CB2 C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6CB4 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6CB6 2F30 
0059 6CB8 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6CBA 2F32 
0060 6CBC 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6CBE 04E0  34         clr   @outparm1
     6CC0 2F30 
0066 6CC2 04E0  34         clr   @outparm2
     6CC4 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6CC6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6CC8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6CCA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6CCC C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6CCE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0134                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6CD0 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6CD2 B000 
0018 6CD4 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6CD6 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6CD8 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6CDA 0606  14         dec   tmp2                  ; tmp2--
0026 6CDC 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6CDE 045B  20         b     *r11                  ; Return to caller
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
0046 6CE0 0649  14         dect  stack
0047 6CE2 C64B  30         mov   r11,*stack            ; Save return address
0048 6CE4 0649  14         dect  stack
0049 6CE6 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6CE8 0649  14         dect  stack
0051 6CEA C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6CEC 0649  14         dect  stack
0053 6CEE C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6CF0 0649  14         dect  stack
0055 6CF2 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6CF4 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6CF6 2F20 
0060               
0061 6CF8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6CFA 31AA 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6CFC C120  34         mov   @outparm1,tmp0        ; Index offset
     6CFE 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6D00 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D02 2F22 
0070 6D04 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6D06 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D08 2F20 
0074 6D0A 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6D0C 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6D0E B000 
0081 6D10 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6D12 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6D14 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6D16 2F22 
0088 6D18 0287  22         ci    tmp3,2048
     6D1A 0800 
0089 6D1C 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6D1E 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D20 313C 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6D22 C120  34         mov   @parm1,tmp0           ; Restore line number
     6D24 2F20 
0103 6D26 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6D28 06A0  32         bl    @_idx.entry.delete.reorg
     6D2A 6CD0 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6D2C 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D2E 3170 
0111                                                   ; Restore memory window layout
0112               
0113 6D30 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6D32 06A0  32         bl    @_idx.entry.delete.reorg
     6D34 6CD0 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6D36 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6D38 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6D3A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6D3C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6D3E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6D40 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6D42 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0135                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 6D44 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6D46 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6D48 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6D4A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D4C FFCE 
0026 6D4E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D50 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6D52 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6D54 B000 
0031 6D56 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6D58 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6D5A 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6D5C C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6D5E 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6D60 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6D62 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6D64 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6D66 AFFE 
0042 6D68 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6D6A C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6D6C 0644  14         dect  tmp0                  ; Move pointer up
0050 6D6E 0645  14         dect  tmp1                  ; Move pointer up
0051 6D70 0606  14         dec   tmp2                  ; Next index entry
0052 6D72 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D74 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D76 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D78 045B  20         b     *r11                  ; Return to caller
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
0082 6D7A 0649  14         dect  stack
0083 6D7C C64B  30         mov   r11,*stack            ; Save return address
0084 6D7E 0649  14         dect  stack
0085 6D80 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D82 0649  14         dect  stack
0087 6D84 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D86 0649  14         dect  stack
0089 6D88 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D8A 0649  14         dect  stack
0091 6D8C C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D8E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D90 2F22 
0096 6D92 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D94 2F20 
0097 6D96 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D98 C1E0  34         mov   @parm2,tmp3
     6D9A 2F22 
0104 6D9C 0287  22         ci    tmp3,2048
     6D9E 0800 
0105 6DA0 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6DA2 06A0  32         bl    @_idx.sams.mapcolumn.on
     6DA4 313C 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6DA6 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DA8 2F22 
0117 6DAA 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6DAC 06A0  32         bl    @_idx.entry.insert.reorg
     6DAE 6D44 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6DB0 06A0  32         bl    @_idx.sams.mapcolumn.off
     6DB2 3170 
0125                                                   ; Restore memory window layout
0126               
0127 6DB4 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6DB6 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DB8 2F22 
0133               
0134 6DBA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6DBC 31AA 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6DBE C120  34         mov   @outparm1,tmp0        ; Index offset
     6DC0 2F30 
0139               
0140 6DC2 06A0  32         bl    @_idx.entry.insert.reorg
     6DC4 6D44 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6DC6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6DC8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6DCA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6DCC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6DCE C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6DD0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0136                       ;-----------------------------------------------------------------------
0137                       ; Logic for Editor Buffer
0138                       ;-----------------------------------------------------------------------
0139                       copy  "edb.utils.asm"          ; Editor buffer utilities
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
0020 6DD2 0649  14         dect  stack
0021 6DD4 C64B  30         mov   r11,*stack            ; Save return address
0022 6DD6 0649  14         dect  stack
0023 6DD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6DDA 0649  14         dect  stack
0025 6DDC C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6DDE C120  34         mov   @edb.next_free.ptr,tmp0
     6DE0 A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6DE2 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6DE4 0FFF 
0035 6DE6 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6DE8 0052 
0036 6DEA 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6DEC 0FF0 
0037 6DEE 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6DF0 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6DF2 A218 
0043 6DF4 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6DF6 A200 
     6DF8 A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6DFA C120  34         mov   @edb.sams.hipage,tmp0
     6DFC A218 
0050 6DFE C160  34         mov   @edb.top.ptr,tmp1
     6E00 A200 
0051 6E02 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6E04 2582 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6E06 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6E08 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E0A FFCE 
0061 6E0C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E0E 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6E10 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6E12 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6E14 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6E16 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0140                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6E18 0649  14         dect  stack
0022 6E1A C64B  30         mov   r11,*stack            ; Push return address
0023 6E1C 0649  14         dect  stack
0024 6E1E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6E20 0649  14         dect  stack
0026 6E22 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6E24 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6E26 A204 
0031 6E28 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6E2A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E2C FFCE 
0037 6E2E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E30 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6E32 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6E34 2F20 
0043               
0044 6E36 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6E38 6C84 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6E3A C120  34         mov   @outparm2,tmp0        ; SAMS page
     6E3C 2F32 
0050 6E3E C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6E40 2F30 
0051 6E42 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6E44 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6E46 A008 
0057 6E48 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6E4A 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6E4C 2582 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6E4E C820  54         mov   @outparm2,@tv.sams.c000
     6E50 2F32 
     6E52 A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6E54 C820  54         mov   @outparm2,@edb.sams.page
     6E56 2F32 
     6E58 A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6E5A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6E5C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6E5E C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6E60 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0141                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6E62 0649  14         dect  stack
0028 6E64 C64B  30         mov   r11,*stack            ; Save return address
0029 6E66 0649  14         dect  stack
0030 6E68 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6E6A 0649  14         dect  stack
0032 6E6C C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6E6E 0649  14         dect  stack
0034 6E70 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6E72 0649  14         dect  stack
0036 6E74 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6E76 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E78 A10C 
     6E7A 2F6A 
0041 6E7C 04E0  34         clr   @fb.column
     6E7E A10C 
0042 6E80 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E82 6996 
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6E84 04C4  14         clr   tmp0                  ; Counter
0047 6E86 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6E88 C160  34         mov   @fb.current,tmp1      ; Get position
     6E8A A102 
0049 6E8C C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E8E 2F6C 
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6E90 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6E92 0986  56         srl   tmp2,8                ; Right justify
0056 6E94 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6E96 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6E98 0286  22         ci    tmp2,32               ; Was it a space character?
     6E9A 0020 
0063 6E9C 1301  14         jeq   edb.line.pack.fb.check80
0064 6E9E C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6EA0 0284  22         ci    tmp0,colrow
     6EA2 0050 
0070 6EA4 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6EA6 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6EA8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6EAA FFCE 
0078 6EAC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6EAE 2026 
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6EB0 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6EB2 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6EB4 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6EB6 2F6E 
0086 6EB8 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6EBA C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6EBC 2F6E 
0092               
0093 6EBE 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6EC0 C184  18         mov   tmp0,tmp2             ; \
0096 6EC2 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6EC4 0586  14         inc   tmp2                  ; /
0098               
0099 6EC6 C107  18         mov   tmp3,tmp0             ; \
0100 6EC8 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6ECA 2F6C 
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6ECC DD05  32         movb  tmp1,*tmp0+
0104 6ECE 0606  14         dec   tmp2
0105 6ED0 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6ED2 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6ED4 6DD2 
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6ED6 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6ED8 A104 
     6EDA 2F20 
0117 6EDC A820  54         a     @fb.row,@parm1        ; /
     6EDE A106 
     6EE0 2F20 
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6EE2 C820  54         mov   @edb.next_free.ptr,@parm2
     6EE4 A208 
     6EE6 2F22 
0123                                                   ; Pointer to new line
0124 6EE8 C820  54         mov   @edb.sams.hipage,@parm3
     6EEA A218 
     6EEC 2F24 
0125                                                   ; SAMS page to use
0126               
0127 6EEE 06A0  32         bl    @idx.entry.update     ; Update index
     6EF0 6C32 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6EF2 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6EF4 2F6C 
0136 6EF6 C160  34         mov   @edb.next_free.ptr,tmp1
     6EF8 A208 
0137                                                   ; Address of line in editor buffer
0138               
0139 6EFA 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6EFC A208 
0140               
0141 6EFE C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6F00 2F6E 
0142 6F02 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6F04 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6F06 0286  22         ci    tmp2,2
     6F08 0002 
0150 6F0A 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6F0C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6F0E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6F10 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6F12 0286  22         ci    tmp2,1
     6F14 0001 
0157 6F16 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6F18 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6F1A 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6F1C 06A0  32         bl    @xpym2m               ; Copy memory block
     6F1E 24EC 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6F20 A820  54         a     @rambuf+4,@edb.next_free.ptr
     6F22 2F6E 
     6F24 A208 
0171                                                      ; Add length of line
0172               
0173 6F26 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6F28 A208 
0174 6F2A 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6F2C 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6F2E 000F 
0176 6F30 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6F32 A208 
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6F34 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6F36 2F6A 
     6F38 A10C 
0182               
0183 6F3A 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6F3C A218 
     6F3E A216 
0184 6F40 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6F42 C120  34         mov   @edb.sams.page,tmp0
     6F44 A216 
0187 6F46 C160  34         mov   @edb.top.ptr,tmp1
     6F48 A200 
0188 6F4A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6F4C 2582 
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6F4E C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6F50 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6F52 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6F54 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6F56 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6F58 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0142                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0028 6F5A 0649  14         dect  stack
0029 6F5C C64B  30         mov   r11,*stack            ; Save return address
0030 6F5E 0649  14         dect  stack
0031 6F60 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6F62 0649  14         dect  stack
0033 6F64 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6F66 0649  14         dect  stack
0035 6F68 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6F6A C820  54         mov   @parm1,@rambuf
     6F6C 2F20 
     6F6E 2F6A 
0040 6F70 C820  54         mov   @parm2,@rambuf+2
     6F72 2F22 
     6F74 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6F76 C120  34         mov   @fb.colsline,tmp0
     6F78 A10E 
0045 6F7A 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6F7C 2F22 
0046 6F7E C1A0  34         mov   @fb.top.ptr,tmp2
     6F80 A100 
0047 6F82 A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6F84 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F86 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6F88 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6F8A 2F20 
     6F8C A204 
0053 6F8E 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6F90 04E0  34         clr   @rambuf+8             ; Set length=0
     6F92 2F72 
0056 6F94 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6F96 C120  34 !       mov   @parm1,tmp0
     6F98 2F20 
0061 6F9A 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F9C 6E18 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6F9E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6FA0 2F30 
0069 6FA2 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6FA4 04E0  34         clr   @rambuf+8             ; Set length=0
     6FA6 2F72 
0073 6FA8 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6FAA C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6FAC C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6FAE 2F6E 
0080 6FB0 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6FB2 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6FB4 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6FB6 0050 
0085                                                   ; /
0086 6FB8 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6FBA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FBC FFCE 
0091 6FBE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FC0 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6FC2 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6FC4 2F70 
0097 6FC6 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6FC8 2F72 
0098               
0099 6FCA 04C5  14         clr   tmp1                  ; Fill with >00
0100 6FCC C1A0  34         mov   @fb.colsline,tmp2
     6FCE A10E 
0101 6FD0 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6FD2 2F72 
0102 6FD4 0586  14         inc   tmp2
0103               
0104 6FD6 06A0  32         bl    @xfilm                ; Fill CPU memory
     6FD8 2248 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6FDA C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6FDC 2F72 
0113 6FDE 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6FE0 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6FE2 2F6E 
0116 6FE4 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6FE6 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6FE8 0286  22         ci    tmp2,80               ; Check line length
     6FEA 0050 
0122 6FEC 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6FEE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FF0 FFCE 
0127 6FF2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FF4 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6FF6 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6FF8 2F30 
0133               
0134 6FFA 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6FFC 24EC 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6FFE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 7000 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 7002 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 7004 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 7006 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0143                       copy  "edb.line.getlen.asm"    ; Get line length
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
0021 7008 0649  14         dect  stack
0022 700A C64B  30         mov   r11,*stack            ; Push return address
0023 700C 0649  14         dect  stack
0024 700E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7010 0649  14         dect  stack
0026 7012 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 7014 04E0  34         clr   @outparm1             ; Reset length
     7016 2F30 
0031 7018 04E0  34         clr   @outparm2             ; Reset SAMS bank
     701A 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 701C C120  34         mov   @parm1,tmp0           ; \
     701E 2F20 
0036 7020 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 7022 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     7024 A204 
0039 7026 1101  14         jlt   !                     ; No, continue processing
0040 7028 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 702A C120  34 !       mov   @parm1,tmp0           ; Get line
     702C 2F20 
0046               
0047 702E 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7030 6E18 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 7032 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     7034 2F30 
0053 7036 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 7038 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 703A C805  38         mov   tmp1,@outparm1        ; Save length
     703C 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 703E 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     7040 0050 
0064 7042 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 7044 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7046 FFCE 
0070 7048 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     704A 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 704C 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     704E 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 7050 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 7052 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 7054 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 7056 045B  20         b     *r11                  ; Return to caller
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
0103 7058 0649  14         dect  stack
0104 705A C64B  30         mov   r11,*stack            ; Save return address
0105 705C 0649  14         dect  stack
0106 705E C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 7060 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7062 A104 
0111 7064 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7066 A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 7068 C804  38         mov   tmp0,@parm1
     706A 2F20 
0116 706C 06A0  32         bl    @edb.line.getlength
     706E 7008 
0117 7070 C820  54         mov   @outparm1,@fb.row.length
     7072 2F30 
     7074 A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 7076 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 7078 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 707A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0144                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 707C 0649  14         dect  stack
0032 707E C64B  30         mov   r11,*stack            ; Save return address
0033 7080 0649  14         dect  stack
0034 7082 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 7084 0649  14         dect  stack
0036 7086 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 7088 0649  14         dect  stack
0038 708A C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 708C 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     708E 2F20 
     7090 A204 
0043 7092 1204  14         jle   !
0044 7094 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7096 FFCE 
0045 7098 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     709A 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 709C C120  34 !       mov   @parm2,tmp0           ; Get target line number
     709E 2F22 
0050 70A0 0604  14         dec   tmp0                  ; Base 0
0051 70A2 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     70A4 2F6C 
0052 70A6 04E0  34         clr   @rambuf               ; Set source line length=0
     70A8 2F6A 
0053 70AA 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     70AC 2F6E 
0054 70AE 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     70B0 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 70B2 C120  34         mov   @parm1,tmp0           ; Get source line number
     70B4 2F20 
0059 70B6 0604  14         dec   tmp0                  ; Base 0
0060               
0061 70B8 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     70BA 6E18 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 70BC C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     70BE 2F30 
0069 70C0 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 70C2 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 70C4 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 70C6 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     70C8 2F6A 
0077 70CA 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     70CC 2F6A 
0078 70CE C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     70D0 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 70D2 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     70D4 0050 
0083 70D6 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 70D8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70DA FFCE 
0088 70DC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70DE 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 70E0 A820  54         a     @w$1000,@edb.top.ptr
     70E2 201A 
     70E4 A200 
0094 70E6 A820  54         a     @w$1000,@edb.next_free.ptr
     70E8 201A 
     70EA A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 70EC 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     70EE 6DD2 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 70F0 C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     70F2 2F6E 
0111 70F4 C160  34         mov   @edb.next_free.ptr,tmp1
     70F6 A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 70F8 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     70FA 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 70FC 06A0  32         bl    @xpym2m               ; Copy memory block
     70FE 24EC 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 7100 6820  54         s     @w$1000,@edb.top.ptr
     7102 201A 
     7104 A200 
0127 7106 6820  54         s     @w$1000,@edb.next_free.ptr
     7108 201A 
     710A A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 710C C820  54         mov   @edb.next_free.ptr,@rambuf+6
     710E A208 
     7110 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 7112 C120  34         mov   @edb.sams.page,tmp0
     7114 A216 
0138 7116 C160  34         mov   @edb.top.ptr,tmp1
     7118 A200 
0139 711A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     711C 2582 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 711E C120  34         mov   @tv.sams.d000,tmp0
     7120 A00A 
0146 7122 0205  20         li    tmp1,>d000
     7124 D000 
0147 7126 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7128 2582 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 712A A820  54         a     @rambuf,@edb.next_free.ptr
     712C 2F6A 
     712E A208 
0154                                                      ; Add length of line
0155               
0156 7130 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7132 A208 
0157 7134 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7136 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7138 000F 
0159 713A A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     713C A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 713E C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     7140 2F6C 
     7142 2F20 
0165 7144 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     7146 2F70 
     7148 2F22 
0166 714A C820  54         mov   @edb.sams.hipage,@parm3
     714C A218 
     714E 2F24 
0167                                                   ; SAMS page to use
0168               
0169 7150 06A0  32         bl    @idx.entry.update     ; Update index
     7152 6C32 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 7154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 715A C2F9  30         mov   *stack+,r11           ; Pop r11
0182 715C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0145                       copy  "edb.line.del.asm"       ; Delete line
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
0024 715E 0649  14         dect  stack
0025 7160 C64B  30         mov   r11,*stack            ; Save return address
0026 7162 0649  14         dect  stack
0027 7164 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 7166 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     7168 2F20 
     716A A204 
0032 716C 1204  14         jle   !
0033 716E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7170 FFCE 
0034 7172 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7174 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 7176 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7178 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 717A C120  34          mov   @edb.lines,tmp0      ; \
     717C A204 
0043 717E 0284  22          ci    tmp0,1               ; | Only single line?
     7180 0001 
0044 7182 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 7184 0620  34         dec   @parm1                ; Base 0
     7186 2F20 
0049 7188 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     718A A204 
     718C 2F22 
0050               
0051 718E 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7190 6CE0 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 7192 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7194 A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 7196 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7198 A20C 
     719A 2022 
0061 719C 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 719E 8820  54         c     @parm1,@edb.block.m1  ; \
     71A0 2F20 
     71A2 A20C 
0064 71A4 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 71A6 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 71A8 8820  54         c     @edb.block.m1,@w$0001 ; \
     71AA A20C 
     71AC 2002 
0068 71AE 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 71B0 0620  34         dec   @edb.block.m1         ; M1--
     71B2 A20C 
0071 71B4 0720  34         seto  @fb.colorize          ; Set colorize flag
     71B6 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 71B8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     71BA A20E 
     71BC 2022 
0077 71BE 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 71C0 8820  54         c     @parm1,@edb.block.m2  ; \
     71C2 2F20 
     71C4 A20E 
0080 71C6 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 71C8 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 71CA 8820  54         c     @edb.block.m2,@w$0001 ; \
     71CC A20E 
     71CE 2002 
0084 71D0 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 71D2 0620  34         dec   @edb.block.m2         ; M2--
     71D4 A20E 
0087 71D6 0720  34         seto  @fb.colorize          ; Set colorize flag
     71D8 A110 
0088 71DA 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 71DC 04E0  34         clr   @parm1                ; 1st line
     71DE 2F20 
0094 71E0 04E0  34         clr   @parm2                ; 1st line
     71E2 2F22 
0095               
0096 71E4 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     71E6 6CE0 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 71E8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 71EA C2F9  30         mov   *stack+,r11           ; Pop r11
0105 71EC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0146                       copy  "edb.block.mark.asm"     ; Mark code block
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
0020 71EE 0649  14         dect  stack
0021 71F0 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 71F2 C820  54         mov   @fb.row,@parm1
     71F4 A106 
     71F6 2F20 
0026 71F8 06A0  32         bl    @fb.row2line          ; Row to editor line
     71FA 697C 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 71FC 05A0  34         inc   @outparm1             ; Add base 1
     71FE 2F30 
0032               
0033 7200 C820  54         mov   @outparm1,@edb.block.m1
     7202 2F30 
     7204 A20C 
0034                                                   ; Set block marker M1
0035 7206 0720  34         seto  @fb.colorize          ; Set colorize flag
     7208 A110 
0036 720A 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     720C A116 
0037 720E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7210 A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 7212 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 7214 045B  20         b     *r11                  ; Return to caller
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
0062 7216 0649  14         dect  stack
0063 7218 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 721A C820  54         mov   @fb.row,@parm1
     721C A106 
     721E 2F20 
0068 7220 06A0  32         bl    @fb.row2line          ; Row to editor line
     7222 697C 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7224 05A0  34         inc   @outparm1             ; Add base 1
     7226 2F30 
0074               
0075 7228 C820  54         mov   @outparm1,@edb.block.m2
     722A 2F30 
     722C A20E 
0076                                                   ; Set block marker M2
0077               
0078 722E 0720  34         seto  @fb.colorize          ; Set colorize flag
     7230 A110 
0079 7232 0720  34         seto  @fb.dirty             ; Trigger refresh
     7234 A116 
0080 7236 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7238 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 723A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 723C 045B  20         b     *r11                  ; Return to caller
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
0106 723E 0649  14         dect  stack
0107 7240 C64B  30         mov   r11,*stack            ; Push return address
0108 7242 0649  14         dect  stack
0109 7244 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 7246 0649  14         dect  stack
0111 7248 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 724A C820  54         mov   @fb.row,@parm1
     724C A106 
     724E 2F20 
0116 7250 06A0  32         bl    @fb.row2line          ; Row to editor line
     7252 697C 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 7254 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     7256 2F30 
0122 7258 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 725A C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     725C A20C 
0127 725E 0584  14         inc   tmp0                  ; /
0128 7260 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 7262 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     7264 71EE 
0135 7266 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 7268 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     726A A20C 
0141 726C 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 726E 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     7270 7216 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 7272 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 7274 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 7276 C2F9  30         mov   *stack+,r11           ; Pop r11
0154 7278 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0147                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 727A 0649  14         dect  stack
0018 727C C64B  30         mov   r11,*stack            ; Push return address
0019 727E 0649  14         dect  stack
0020 7280 C660  46         mov   @wyx,*stack           ; Push cursor position
     7282 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 7284 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     7286 A20C 
0025 7288 0720  34         seto  @edb.block.m2         ; /
     728A A20E 
0026               
0027 728C 0720  34         seto  @fb.colorize          ; Set colorize flag
     728E A110 
0028 7290 0720  34         seto  @fb.dirty             ; Trigger refresh
     7292 A116 
0029 7294 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7296 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 7298 0720  34         seto  @parm1
     729A 2F20 
0034 729C 06A0  32         bl    @pane.action.colorscheme.load
     729E 76F8 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 72A0 C820  54         mov   @tv.color,@parm1      ; Set normal color
     72A2 A018 
     72A4 2F20 
0042 72A6 06A0  32         bl    @pane.action.colorscheme.statlines
     72A8 786A 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 72AA 06A0  32         bl    @hchar
     72AC 27D4 
0048 72AE 0034                   byte 0,52,32,18           ; Remove markers
     72B0 2012 
0049 72B2 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     72B4 2037 
0050 72B6 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 72B8 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     72BA 832A 
0056 72BC C2F9  30         mov   *stack+,r11           ; Pop r11
0057 72BE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0148                       copy  "edb.block.copy.asm"     ; Copy code block
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
0027 72C0 0649  14         dect  stack
0028 72C2 C64B  30         mov   r11,*stack            ; Save return address
0029 72C4 0649  14         dect  stack
0030 72C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 72C8 0649  14         dect  stack
0032 72CA C645  30         mov   tmp1,*stack           ; Push tmp1
0033 72CC 0649  14         dect  stack
0034 72CE C646  30         mov   tmp2,*stack           ; Push tmp2
0035 72D0 0649  14         dect  stack
0036 72D2 C660  46         mov   @parm1,*stack         ; Push parm1
     72D4 2F20 
0037 72D6 04E0  34         clr   @outparm1             ; No action (>0000)
     72D8 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 72DA 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     72DC A20C 
     72DE 2022 
0042 72E0 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 72E2 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     72E4 A20E 
     72E6 2022 
0045 72E8 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 72EA 8820  54         c     @edb.block.m1,@edb.block.m2
     72EC A20C 
     72EE A20E 
0048                                                   ; M1 > M2 ?
0049 72F0 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 72F2 C820  54         mov   @fb.row,@parm1
     72F4 A106 
     72F6 2F20 
0054 72F8 06A0  32         bl    @fb.row2line          ; Row to editor line
     72FA 697C 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 72FC C120  34         mov   @outparm1,tmp0        ; \
     72FE 2F30 
0060 7300 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 7302 C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     7304 A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 7306 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7308 2F30 
0066 730A 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 730C 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     730E 2F30 
0069 7310 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 7312 06A0  32         bl    @cpym2m
     7314 24E6 
0072 7316 39BC                   data txt.block.inside,tv.error.msg,53
     7318 A02A 
     731A 0035 
0073               
0074 731C 06A0  32         bl    @pane.errline.show    ; Show error line
     731E 7B52 
0075               
0076 7320 04E0  34         clr   @outparm1             ; No action (>0000)
     7322 2F30 
0077 7324 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 7326 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7328 A01C 
     732A 2F20 
0082 732C 06A0  32         bl    @pane.action.colorscheme.statlines
     732E 786A 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 7330 06A0  32         bl    @hchar
     7332 27D4 
0088 7334 1D00                   byte pane.botrow,0,32,55
     7336 2037 
0089 7338 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 733A C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 733C 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 733E 06A0  32         bl    @putat
     7340 244E 
0098 7342 1D00                   byte pane.botrow,0
0099 7344 34E2                   data txt.block.copy   ; Display "Copying block...."
0100 7346 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 7348 06A0  32         bl    @putat
     734A 244E 
0104 734C 1D00                   byte pane.botrow,0
0105 734E 34F4                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 7350 C120  34         mov   @edb.block.m1,tmp0    ; M1
     7352 A20C 
0111 7354 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     7356 A20E 
0112 7358 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 735A 0586  14         inc   tmp2                  ; /
0114               
0115 735C C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     735E A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 7360 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     7362 2F20 
0121 7364 0620  34         dec   @parm1                ; Base 0 offset for index required
     7366 2F20 
0122 7368 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     736A A204 
     736C 2F22 
0123               
0124 736E 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     7370 6D7A 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 7372 8805  38         c     tmp1,@edb.block.m1
     7374 A20C 
0131 7376 1506  14         jgt   edb.block.copy.loop.docopy
0132 7378 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 737A 05A0  34         inc   @edb.block.m1         ; M1++
     737C A20C 
0135 737E 05A0  34         inc   @edb.block.m2         ; M2++
     7380 A20E 
0136 7382 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 7384 C804  38         mov   tmp0,@parm1           ; Source line for copy
     7386 2F20 
0142 7388 C805  38         mov   tmp1,@parm2           ; Target line for copy
     738A 2F22 
0143               
0144 738C 06A0  32         bl    @edb.line.copy        ; Copy line
     738E 707C 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 7390 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     7392 A204 
0151 7394 0584  14         inc   tmp0                  ; Next source line
0152 7396 0585  14         inc   tmp1                  ; Next target line
0153 7398 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 739A 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 739C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     739E A206 
0159 73A0 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     73A2 A116 
0160 73A4 0720  34         seto  @outparm1             ; Copy completed
     73A6 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 73A8 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     73AA 2F20 
0166 73AC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 73AE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 73B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 73B2 C2F9  30         mov   *stack+,r11           ; Pop R11
0170 73B4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0149                       copy  "edb.block.del.asm"      ; Delete code block
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
0027 73B6 0649  14         dect  stack
0028 73B8 C64B  30         mov   r11,*stack            ; Save return address
0029 73BA 0649  14         dect  stack
0030 73BC C644  30         mov   tmp0,*stack           ; Push tmp0
0031 73BE 0649  14         dect  stack
0032 73C0 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 73C2 0649  14         dect  stack
0034 73C4 C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 73C6 04E0  34         clr   @outparm1             ; No action (>0000)
     73C8 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 73CA C120  34         mov   @edb.block.m1,tmp0    ; \
     73CC A20C 
0041 73CE 0584  14         inc   tmp0                  ; | M1 unset?
0042 73D0 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 73D2 C160  34         mov   @edb.block.m2,tmp1    ; \
     73D4 A20E 
0045 73D6 0584  14         inc   tmp0                  ; | M2 unset?
0046 73D8 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 73DA C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     73DC 2F20 
0051 73DE 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 73E0 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     73E2 A01C 
     73E4 2F20 
0056               
0057 73E6 06A0  32         bl    @pane.action.colorscheme.statlines
     73E8 786A 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 73EA 06A0  32         bl    @hchar
     73EC 27D4 
0063 73EE 1D00                   byte pane.botrow,0,32,55
     73F0 2037 
0064 73F2 FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 73F4 06A0  32         bl    @putat
     73F6 244E 
0067 73F8 1D00                   byte pane.botrow,0
0068 73FA 34CE                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 73FC C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     73FE A20C 
0074 7400 0604  14         dec   tmp0                  ; Base 0
0075               
0076 7402 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     7404 A20E 
0077 7406 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7408 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     740A 2F20 
0080 740C C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     740E A204 
     7410 2F22 
0081 7412 0620  34         dec   @parm2                ; Base 0
     7414 2F22 
0082               
0083 7416 C185  18         mov   tmp1,tmp2             ; \
0084 7418 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 741A 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 741C 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     741E 6CE0 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 7420 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     7422 A204 
0095 7424 0620  34         dec   @parm2                ; /
     7426 2F22 
0096               
0097 7428 0606  14         dec   tmp2
0098 742A 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 742C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     742E A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 7430 8820  54         c     @fb.topline,@edb.lines
     7432 A104 
     7434 A204 
0104                                                   ; Beyond editor buffer?
0105 7436 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7438 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     743A A104 
     743C 2F20 
0108 743E 1002  14         jmp   edb.block.delete.fb.refresh
0109 7440 04E0  34 !       clr   @parm1                ; Set line to start with
     7442 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 7444 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     7446 6B86 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 7448 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     744A 727A 
0119               
0120 744C 0720  34         seto  @outparm1             ; Delete completed
     744E 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 7450 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 7452 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 7454 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7456 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.56185
0150                       ;-----------------------------------------------------------------------
0151                       ; User hook, background tasks
0152                       ;-----------------------------------------------------------------------
0153                       copy  "hook.keyscan.asm"       ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 7458 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     745A 200A 
0009 745C 161C  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 745E C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7460 833C 
     7462 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 7464 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7466 200A 
0016 7468 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     746A 2F40 
     746C 2F42 
0017 746E 1608  14         jne   hook.keyscan.new      ; New key pressed
0018               *---------------------------------------------------------------
0019               * Activate auto-repeat ?
0020               *---------------------------------------------------------------
0021 7470 05A0  34         inc   @keyrptcnt
     7472 2F3E 
0022 7474 C120  34         mov   @keyrptcnt,tmp0
     7476 2F3E 
0023 7478 0284  22         ci    tmp0,30
     747A 001E 
0024 747C 1112  14         jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
0025 747E 1002  14         jmp   hook.keyscan.autorepeat
0026               *--------------------------------------------------------------
0027               * New key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.new:
0030 7480 04E0  34         clr   @keyrptcnt            ; Reset key-repeat counter
     7482 2F3E 
0031               hook.keyscan.autorepeat:
0032 7484 0204  20         li    tmp0,250              ; \
     7486 00FA 
0033 7488 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0034 748A 16FE  14         jne   -!                    ; /
0035 748C C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     748E 2F40 
     7490 2F42 
0036 7492 0460  28         b     @edkey.key.process    ; Process key
     7494 60E8 
0037               *--------------------------------------------------------------
0038               * Clear keyboard buffer if no key pressed
0039               *--------------------------------------------------------------
0040               hook.keyscan.clear_kbbuffer:
0041 7496 04E0  34         clr   @keycode1
     7498 2F40 
0042 749A 04E0  34         clr   @keycode2
     749C 2F42 
0043 749E 04E0  34         clr   @keyrptcnt
     74A0 2F3E 
0044               *--------------------------------------------------------------
0045               * Delay to avoid key bouncing
0046               *--------------------------------------------------------------
0047               hook.keyscan.bounce:
0048 74A2 0204  20         li    tmp0,2000             ; Avoid key bouncing
     74A4 07D0 
0049                       ;------------------------------------------------------
0050                       ; Delay loop
0051                       ;------------------------------------------------------
0052               hook.keyscan.bounce.loop:
0053 74A6 0604  14         dec   tmp0
0054 74A8 16FE  14         jne   hook.keyscan.bounce.loop
0055 74AA 0460  28         b     @hookok               ; Return
     74AC 2D5A 
0056               
**** **** ****     > stevie_b1.asm.56185
0154                       copy  "task.vdp.panes.asm"     ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 74AE 0649  14         dect  stack
0009 74B0 C64B  30         mov   r11,*stack            ; Save return address
0010 74B2 0649  14         dect  stack
0011 74B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 74B6 0649  14         dect  stack
0013 74B8 C660  46         mov   @wyx,*stack           ; Push cursor position
     74BA 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 74BC 20A0  38         coc   @wbit10,config
     74BE 200C 
0019 74C0 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 74C2 06A0  32         bl    @putat
     74C4 244E 
0024 74C6 1D4E                   byte pane.botrow,78
0025 74C8 35F0                   data txt.ws4
0026 74CA 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 74CC 06A0  32         bl    @putat
     74CE 244E 
0032 74D0 1D4E                   byte pane.botrow,78
0033 74D2 35DE                   data txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 74D4 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74D6 A302 
0039 74D8 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 74DA C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74DC A318 
0045 74DE 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 74E0 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     74E2 79AE 
0048 74E4 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     74E6 A318 
0049 74E8 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 74EA C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     74EC A116 
0054 74EE 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056 74F0 C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     74F2 A11A 
     74F4 2F20 
0057               
0058               task.vdp.panes.dump:
0059 74F6 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     74F8 7E6A 
0060                                                   ; \ i  @parm1 = number of lines to dump
0061                                                   ; /
0062                       ;------------------------------------------------------
0063                       ; Color the lines in the framebuffer (TAT)
0064                       ;------------------------------------------------------
0065 74FA C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     74FC A110 
0066 74FE 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0067               
0068 7500 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     7502 7E58 
0069                       ;-------------------------------------------------------
0070                       ; Finished with frame buffer
0071                       ;-------------------------------------------------------
0072               task.vdp.panes.dumped:
0073 7504 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7506 A116 
0074 7508 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     750A A118 
0075                       ;-------------------------------------------------------
0076                       ; Refresh top and bottom line
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.statlines:
0079 750C C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     750E A118 
0080 7510 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0081               
0082 7512 06A0  32         bl    @pane.topline         ; Draw top line
     7514 7AB6 
0083 7516 06A0  32         bl    @pane.botline         ; Draw bottom line
     7518 7BEC 
0084 751A 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     751C A118 
0085                       ;------------------------------------------------------
0086                       ; Show ruler with tab positions
0087                       ;------------------------------------------------------
0088 751E C120  34         mov   @tv.ruler.visible,tmp0
     7520 A010 
0089                                                   ; Should ruler be visible?
0090 7522 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0091               
0092 7524 06A0  32         bl    @cpym2v
     7526 2492 
0093 7528 0050                   data vdp.fb.toprow.sit
0094 752A A11E                   data fb.ruler.sit
0095 752C 0050                   data 80               ; Show ruler
0096                       ;------------------------------------------------------
0097                       ; Exit task
0098                       ;------------------------------------------------------
0099               task.vdp.panes.exit:
0100 752E C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7530 832A 
0101 7532 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7534 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7536 0460  28         b     @slotok
     7538 2DD6 
**** **** ****     > stevie_b1.asm.56185
0155               
0157               
0158                       copy  "task.vdp.cursor.sat.asm"
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 753A 0649  14         dect  stack
0009 753C C64B  30         mov   r11,*stack            ; Save return address
0010 753E 0649  14         dect  stack
0011 7540 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7542 0649  14         dect  stack
0013 7544 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7546 0649  14         dect  stack
0015 7548 C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 754A C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     754C A022 
0020               
0021 754E 0284  22         ci    tmp0,pane.focus.fb
     7550 0000 
0022 7552 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7554 0284  22         ci    tmp0,pane.focus.cmdb
     7556 0001 
0025 7558 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 755A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     755C FFCE 
0031 755E 06A0  32         bl    @cpu.crash            ; / Halt system.
     7560 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7562 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7564 A30A 
     7566 832A 
0037 7568 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     756A 2020 
0038 756C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     756E 26FC 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 7570 100D  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 7572 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7574 2020 
0048 7576 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7578 26FC 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 757A C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     757C A010 
     757E A010 
0053 7580 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0054 7582 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     7584 1000 
0055 7586 1002  14         jmp   task.vdp.copy.sat.write
0056               task.vdp.copy.sat.fb.noruler:
0057 7588 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     758A 0800 
0058                       ;------------------------------------------------------
0059                       ; Dump sprite attribute table
0060                       ;------------------------------------------------------
0061               task.vdp.copy.sat.write:
0062 758C C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     758E 2F5A 
0063                       ;------------------------------------------------------
0064                       ; Handle column and row indicators
0065                       ;------------------------------------------------------
0066 7590 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     7592 A010 
     7594 A010 
0067                                                   ; Is ruler visible?
0068 7596 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0069               
0070 7598 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     759A FF00 
0071 759C 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     759E 00F0 
0072 75A0 C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     75A2 2F5E 
0073               
0074 75A4 C120  34         mov   @ramsat,tmp0
     75A6 2F5A 
0075 75A8 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     75AA 00FF 
0076 75AC 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     75AE 0800 
0077 75B0 C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     75B2 2F62 
0078               
0079 75B4 1005  14         jmp   task.vdp.copy.sat.write2
0080                       ;------------------------------------------------------
0081                       ; Do not show column and row indicators
0082                       ;------------------------------------------------------
0083               task.vdp.copy.sat.hide.indicators:
0084 75B6 04C5  14         clr   tmp1
0085 75B8 D805  38         movb  tmp1,@ramsat+7        ; Hide line indicator    <
     75BA 2F61 
0086 75BC D805  38         movb  tmp1,@ramsat+11       ; Hide column indicator  v
     75BE 2F65 
0087                       ;------------------------------------------------------
0088                       ; Dump to VDP
0089                       ;------------------------------------------------------
0090               task.vdp.copy.sat.write2:
0091 75C0 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75C2 2492 
0092 75C4 2180                   data sprsat,ramsat,14 ; \ i  tmp0 = VDP destination
     75C6 2F5A 
     75C8 000E 
0093                                                   ; | i  tmp1 = ROM/RAM source
0094                                                   ; / i  tmp2 = Number of bytes to write
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               task.vdp.copy.sat.exit:
0099 75CA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 75CC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 75CE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 75D0 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 75D2 0460  28         b     @slotok               ; Exit task
     75D4 2DD6 
**** **** ****     > stevie_b1.asm.56185
0159                                                      ; Copy cursor SAT to VDP
0160                       copy  "task.vdp.cursor.f18a.asm"
**** **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 75D6 0649  14         dect  stack
0009 75D8 C64B  30         mov   r11,*stack            ; Save return address
0010 75DA 0649  14         dect  stack
0011 75DC C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 75DE 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     75E0 A112 
0016 75E2 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 75E4 04C4  14         clr   tmp0
0021 75E6 D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     75E8 2F5D 
0022 75EA 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 75EC C820  54         mov   @tv.curshape,@ramsat+2
     75EE A014 
     75F0 2F5C 
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 75F2 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75F4 2492 
0035 75F6 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     75F8 2F5A 
     75FA 0004 
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 75FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 75FE C2F9  30         mov   *stack+,r11           ; Pop r11
0044 7600 0460  28         b     @slotok               ; Exit task
     7602 2DD6 
**** **** ****     > stevie_b1.asm.56185
0161                                                      ; Set cursor shape in VDP (blink)
0168               
0169                       copy  "task.oneshot.asm"       ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7604 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7606 A024 
0010 7608 1301  14         jeq   task.oneshot.exit
0011               
0012 760A 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 760C 0460  28         b     @slotok                ; Exit task
     760E 2DD6 
**** **** ****     > stevie_b1.asm.56185
0170                       ;-----------------------------------------------------------------------
0171                       ; Screen pane utilities
0172                       ;-----------------------------------------------------------------------
0173                       copy  "pane.utils.asm"         ; Pane utility functions
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
0020 7610 0649  14         dect  stack
0021 7612 C64B  30         mov   r11,*stack            ; Push return address
0022 7614 0649  14         dect  stack
0023 7616 C660  46         mov   @wyx,*stack           ; Push cursor position
     7618 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 761A 06A0  32         bl    @hchar
     761C 27D4 
0028 761E 0034                   byte 0,52,32,18
     7620 2012 
0029 7622 FFFF                   data EOL              ; Clear message
0030               
0031 7624 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7626 A024 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 7628 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     762A 832A 
0037 762C C2F9  30         mov   *stack+,r11           ; Pop R11
0038 762E 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.56185
0174                       copy  "pane.utils.hint.asm"    ; Show hint in pane
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
0021 7630 0649  14         dect  stack
0022 7632 C64B  30         mov   r11,*stack            ; Save return address
0023 7634 0649  14         dect  stack
0024 7636 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7638 0649  14         dect  stack
0026 763A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 763C 0649  14         dect  stack
0028 763E C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7640 0649  14         dect  stack
0030 7642 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 7644 C820  54         mov   @parm1,@wyx           ; Set cursor
     7646 2F20 
     7648 832A 
0035 764A C160  34         mov   @parm2,tmp1           ; Get string to display
     764C 2F22 
0036 764E 06A0  32         bl    @xutst0               ; Display string
     7650 242C 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 7652 C120  34         mov   @parm2,tmp0
     7654 2F22 
0041 7656 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 7658 0984  56         srl   tmp0,8                ; Right justify
0043 765A C184  18         mov   tmp0,tmp2
0044 765C C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 765E 0506  16         neg   tmp2
0046 7660 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7662 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 7664 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7666 2F20 
0051 7668 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 766A C804  38         mov   tmp0,@wyx             ; / Set cursor
     766C 832A 
0053               
0054 766E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7670 2406 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 7672 0205  20         li    tmp1,32               ; Byte to fill
     7674 0020 
0059               
0060 7676 06A0  32         bl    @xfilv                ; Clear line
     7678 22A0 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 767A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 767C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 767E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 7680 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 7682 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 7684 045B  20         b     *r11                  ; Return to caller
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
0095 7686 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7688 2F20 
0096 768A C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     768C 2F22 
0097 768E 0649  14         dect  stack
0098 7690 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 7692 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7694 7630 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 7696 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 7698 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0175                       copy  "pane.utils.colorscheme.asm"
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
0017 769A 0649  14         dect  stack
0018 769C C64B  30         mov   r11,*stack            ; Push return address
0019 769E 0649  14         dect  stack
0020 76A0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 76A2 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     76A4 A012 
0023 76A6 0284  22         ci    tmp0,tv.colorscheme.entries
     76A8 000A 
0024                                                   ; Last entry reached?
0025 76AA 1103  14         jlt   !
0026 76AC 0204  20         li    tmp0,1                ; Reset color scheme index
     76AE 0001 
0027 76B0 1001  14         jmp   pane.action.colorscheme.switch
0028 76B2 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 76B4 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     76B6 A012 
0034               
0035 76B8 06A0  32         bl    @pane.action.colorscheme.load
     76BA 76F8 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 76BC C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     76BE 832A 
     76C0 833C 
0041               
0042 76C2 06A0  32         bl    @putnum
     76C4 2A64 
0043 76C6 003E                   byte 0,62
0044 76C8 A012                   data tv.colorscheme,rambuf,>3020
     76CA 2F6A 
     76CC 3020 
0045               
0046 76CE 06A0  32         bl    @putat
     76D0 244E 
0047 76D2 0034                   byte 0,52
0048 76D4 39F4                   data txt.colorscheme  ; Show color palette message
0049               
0050 76D6 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     76D8 833C 
     76DA 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 76DC 0204  20         li    tmp0,12000
     76DE 2EE0 
0055 76E0 0604  14 !       dec   tmp0
0056 76E2 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 76E4 0204  20         li    tmp0,pane.clearmsg.task.callback
     76E6 7610 
0061 76E8 C804  38         mov   tmp0,@tv.task.oneshot
     76EA A024 
0062               
0063 76EC 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     76EE 2E40 
0064 76F0 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 76F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 76F4 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 76F6 045B  20         b     *r11                  ; Return to caller
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
0093 76F8 0649  14         dect  stack
0094 76FA C64B  30         mov   r11,*stack            ; Save return address
0095 76FC 0649  14         dect  stack
0096 76FE C644  30         mov   tmp0,*stack           ; Push tmp0
0097 7700 0649  14         dect  stack
0098 7702 C645  30         mov   tmp1,*stack           ; Push tmp1
0099 7704 0649  14         dect  stack
0100 7706 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 7708 0649  14         dect  stack
0102 770A C647  30         mov   tmp3,*stack           ; Push tmp3
0103 770C 0649  14         dect  stack
0104 770E C648  30         mov   tmp4,*stack           ; Push tmp4
0105 7710 0649  14         dect  stack
0106 7712 C660  46         mov   @parm1,*stack         ; Push parm1
     7714 2F20 
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 7716 C120  34         mov   @parm1,tmp0
     7718 2F20 
0111 771A 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     771C FFFF 
0112 771E 1302  14         jeq   !                     ; Yes, so skip screen off
0113 7720 06A0  32         bl    @scroff               ; Turn screen off
     7722 269A 
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7724 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7726 A012 
0118 7728 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 772A 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 772C 0224  22         ai    tmp0,tv.colorscheme.table
     772E 33E8 
0122                                                   ; Add base for color scheme data table
0123 7730 C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 7732 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7734 A018 
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 7736 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 7738 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     773A 00FF 
0130 773C C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     773E A016 
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 7740 C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 7742 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7744 FF00 
0136 7746 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 7748 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 774A C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 774C 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 774E C806  38         mov   tmp2,@tv.busycolor    ; /
     7750 A01C 
0142               
0143 7752 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     7754 00FF 
0144 7756 C805  38         mov   tmp1,@tv.markcolor    ; /
     7758 A01A 
0145               
0146 775A C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 775C 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 775E C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     7760 A020 
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 7762 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 7764 0245  22         andi  tmp1,>000f            ; Only keep P
     7766 000F 
0154 7768 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 776A C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     776C A01E 
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 776E C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 7770 0245  22         andi  tmp1,>00f0            ; Only keep O
     7772 00F0 
0161 7774 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 7776 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     7778 2F61 
0163 777A D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     777C 2F65 
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 777E C147  18         mov   tmp3,tmp1             ; Get work copy
0168 7780 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 7782 0265  22         ori   tmp1,>0700
     7784 0700 
0170 7786 C105  18         mov   tmp1,tmp0
0171 7788 06A0  32         bl    @putvrx               ; Write VDP register
     778A 2340 
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 778C C120  34         mov   @tv.ruler.visible,tmp0
     778E A010 
0176 7790 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177 7792 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     7794 18A0 
0178                                                   ; VDP start address (frame buffer area)
0179 7796 0206  20         li    tmp2,(pane.botrow-2)*80
     7798 0870 
0180                                                   ; Number of bytes to fill
0181 779A 1004  14         jmp   pane.action.colorscheme.fbdump
0182               pane.action.colorscheme.fbdump.noruler:
0183 779C 0204  20         li    tmp0,vdp.fb.toprow.tat
     779E 1850 
0184                                                   ; VDP start address (frame buffer area)
0185 77A0 0206  20         li    tmp2,(pane.botrow-1)*80
     77A2 08C0 
0186                                                   ; Number of bytes to fill
0187               pane.action.colorscheme.fbdump:
0188 77A4 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0189 77A6 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0190               
0191 77A8 06A0  32         bl    @xfilv                ; Fill colors
     77AA 22A0 
0192                                                   ; i \  tmp0 = start address
0193                                                   ; i |  tmp1 = byte to fill
0194                                                   ; i /  tmp2 = number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Colorize marked lines
0197                       ;-------------------------------------------------------
0198 77AC C120  34         mov   @parm2,tmp0
     77AE 2F22 
0199 77B0 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     77B2 FFFF 
0200 77B4 1304  14         jeq   pane.action.colorscheme.cmdbpane
0201               
0202 77B6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     77B8 A110 
0203 77BA 06A0  32         bl    @fb.colorlines
     77BC 7E58 
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for CMDB pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.cmdbpane:
0208 77BE C120  34         mov   @cmdb.visible,tmp0
     77C0 A302 
0209 77C2 130F  14         jeq   pane.action.colorscheme.errpane
0210                                                   ; Skip if CMDB pane is hidden
0211               
0212 77C4 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     77C6 1FD0 
0213                                                   ; VDP start address (CMDB top line)
0214               
0215 77C8 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     77CA A020 
0216 77CC 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     77CE 0050 
0217 77D0 06A0  32         bl    @xfilv                ; Fill colors
     77D2 22A0 
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for CMDB pane content (TAT)
0223                       ;-------------------------------------------------------
0224 77D4 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     77D6 2020 
0225                                                   ; VDP start address (CMDB top line + 1)
0226 77D8 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0227 77DA 0206  20         li    tmp2,3*80             ; Number of bytes to fill
     77DC 00F0 
0228 77DE 06A0  32         bl    @xfilv                ; Fill colors
     77E0 22A0 
0229                                                   ; i \  tmp0 = start address
0230                                                   ; i |  tmp1 = byte to fill
0231                                                   ; i /  tmp2 = number of bytes to fill
0232                       ;-------------------------------------------------------
0233                       ; Dump colors for error line (TAT)
0234                       ;-------------------------------------------------------
0235               pane.action.colorscheme.errpane:
0236 77E2 C120  34         mov   @tv.error.visible,tmp0
     77E4 A028 
0237 77E6 130A  14         jeq   pane.action.colorscheme.statline
0238                                                   ; Skip if error line pane is hidden
0239               
0240 77E8 0205  20         li    tmp1,>00f6            ; White on dark red
     77EA 00F6 
0241 77EC C805  38         mov   tmp1,@parm1           ; Pass color combination
     77EE 2F20 
0242               
0243 77F0 0205  20         li    tmp1,pane.botrow-1    ;
     77F2 001C 
0244 77F4 C805  38         mov   tmp1,@parm2           ; Error line on screen
     77F6 2F22 
0245               
0246 77F8 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77FA 78C2 
0247                                                   ; \ i  @parm1 = Color combination
0248                                                   ; / i  @parm2 = Row on physical screen
0249                       ;-------------------------------------------------------
0250                       ; Dump colors for top line and bottom line (TAT)
0251                       ;-------------------------------------------------------
0252               pane.action.colorscheme.statline:
0253 77FC C160  34         mov   @tv.color,tmp1
     77FE A018 
0254 7800 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7802 00FF 
0255 7804 C805  38         mov   tmp1,@parm1           ; Set color combination
     7806 2F20 
0256               
0257               
0258 7808 04E0  34         clr   @parm2                ; Top row on screen
     780A 2F22 
0259 780C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     780E 78C2 
0260                                                   ; \ i  @parm1 = Color combination
0261                                                   ; / i  @parm2 = Row on physical screen
0262               
0263 7810 0205  20         li    tmp1,pane.botrow
     7812 001D 
0264 7814 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     7816 2F22 
0265 7818 06A0  32         bl    @colors.line.set      ; Load color combination for line
     781A 78C2 
0266                                                   ; \ i  @parm1 = Color combination
0267                                                   ; / i  @parm2 = Row on physical screen
0268                       ;-------------------------------------------------------
0269                       ; Dump colors for ruler if visible (TAT)
0270                       ;-------------------------------------------------------
0271 781C C160  34         mov   @tv.ruler.visible,tmp1
     781E A010 
0272 7820 1307  14         jeq   pane.action.colorscheme.cursorcolor
0273               
0274 7822 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     7824 7E46 
0275 7826 06A0  32         bl    @cpym2v
     7828 2492 
0276 782A 1850                   data vdp.fb.toprow.tat
0277 782C A16E                   data fb.ruler.tat
0278 782E 0050                   data 80               ; Show ruler colors
0279                       ;-------------------------------------------------------
0280                       ; Dump cursor FG color to sprite table (SAT)
0281                       ;-------------------------------------------------------
0282               pane.action.colorscheme.cursorcolor:
0283 7830 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     7832 A016 
0284               
0285 7834 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7836 A022 
0286 7838 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     783A 0000 
0287 783C 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0288                                                   ; Yes, set cursor color
0289               
0290               pane.action.colorscheme.cursorcolor.cmdb:
0291 783E 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     7840 00F0 
0292 7842 0A48  56         sla   tmp4,4                ; Move to MSB
0293 7844 1003  14         jmp   !
0294               
0295               pane.action.colorscheme.cursorcolor.fb:
0296 7846 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     7848 000F 
0297 784A 0A88  56         sla   tmp4,8                ; Move to MSB
0298               
0299 784C D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     784E 2F5D 
0300 7850 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7852 A015 
0301                       ;-------------------------------------------------------
0302                       ; Exit
0303                       ;-------------------------------------------------------
0304               pane.action.colorscheme.load.exit:
0305 7854 06A0  32         bl    @scron                ; Turn screen on
     7856 26A2 
0306 7858 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     785A 2F20 
0307 785C C239  30         mov   *stack+,tmp4          ; Pop tmp4
0308 785E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0309 7860 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0310 7862 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0311 7864 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0312 7866 C2F9  30         mov   *stack+,r11           ; Pop R11
0313 7868 045B  20         b     *r11                  ; Return to caller
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
0333 786A 0649  14         dect  stack
0334 786C C64B  30         mov   r11,*stack            ; Save return address
0335 786E 0649  14         dect  stack
0336 7870 C644  30         mov   tmp0,*stack           ; Push tmp0
0337                       ;------------------------------------------------------
0338                       ; Bottom line
0339                       ;------------------------------------------------------
0340 7872 0204  20         li    tmp0,pane.botrow
     7874 001D 
0341 7876 C804  38         mov   tmp0,@parm2           ; Last row on screen
     7878 2F22 
0342 787A 06A0  32         bl    @colors.line.set      ; Load color combination for line
     787C 78C2 
0343                                                   ; \ i  @parm1 = Color combination
0344                                                   ; / i  @parm2 = Row on physical screen
0345                       ;------------------------------------------------------
0346                       ; Exit
0347                       ;------------------------------------------------------
0348               pane.action.colorscheme.statlines.exit:
0349 787E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0350 7880 C2F9  30         mov   *stack+,r11           ; Pop R11
0351 7882 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0176                                                      ; Colorscheme handling in panes
0177                       copy  "pane.cursor.asm"        ; Cursor utility functions
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
0020 7884 0649  14         dect  stack
0021 7886 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 7888 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     788A 229A 
0026 788C 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     788E 0000 
     7890 0008 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 7892 06A0  32         bl    @clslot
     7894 2E32 
0031 7896 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 7898 06A0  32         bl    @clslot
     789A 2E32 
0034 789C 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 789E C2F9  30         mov   *stack+,r11           ; Pop R11
0040 78A0 045B  20         b     *r11                  ; Return to caller
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
0060 78A2 0649  14         dect  stack
0061 78A4 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 78A6 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     78A8 229A 
0066 78AA 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     78AC 0000 
     78AE 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 78B0 06A0  32         bl    @mkslot
     78B2 2E14 
0073 78B4 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     78B6 753A 
0074 78B8 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     78BA 75D6 
0075 78BC FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 78BE C2F9  30         mov   *stack+,r11           ; Pop R11
0090 78C0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0178                       ;-----------------------------------------------------------------------
0179                       ; Screen panes
0180                       ;-----------------------------------------------------------------------
0181                       copy  "colors.line.set.asm"    ; Set color combination for line
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
0021 78C2 0649  14         dect  stack
0022 78C4 C64B  30         mov   r11,*stack            ; Save return address
0023 78C6 0649  14         dect  stack
0024 78C8 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 78CA 0649  14         dect  stack
0026 78CC C645  30         mov   tmp1,*stack           ; Push tmp1
0027 78CE 0649  14         dect  stack
0028 78D0 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 78D2 0649  14         dect  stack
0030 78D4 C660  46         mov   @parm1,*stack         ; Push parm1
     78D6 2F20 
0031 78D8 0649  14         dect  stack
0032 78DA C660  46         mov   @parm2,*stack         ; Push parm2
     78DC 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 78DE C120  34         mov   @parm2,tmp0           ; Get target line
     78E0 2F22 
0037 78E2 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     78E4 0050 
0038 78E6 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 78E8 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 78EA 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     78EC 1800 
0042 78EE C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     78F0 2F20 
0043 78F2 0206  20         li    tmp2,80               ; Number of bytes to fill
     78F4 0050 
0044               
0045 78F6 06A0  32         bl    @xfilv                ; Fill colors
     78F8 22A0 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 78FA C839  50         mov   *stack+,@parm2        ; Pop @parm2
     78FC 2F22 
0054 78FE C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7900 2F20 
0055 7902 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7904 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7906 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7908 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 790A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0182                       copy  "pane.cmdb.asm"          ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.56185
0183                       copy  "pane.cmdb.show.asm"     ; Show command buffer pane
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
0022 790C 0649  14         dect  stack
0023 790E C64B  30         mov   r11,*stack            ; Save return address
0024 7910 0649  14         dect  stack
0025 7912 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7914 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7916 832A 
     7918 A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 791A 0204  20         li    tmp0,pane.botrow
     791C 001D 
0033 791E 6120  34         s     @cmdb.scrrows,tmp0
     7920 A306 
0034 7922 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7924 A11A 
0035               
0036 7926 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 7928 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     792A A30E 
0038               
0039 792C 0224  22         ai    tmp0,>0100
     792E 0100 
0040 7930 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7932 A310 
0041 7934 0584  14         inc   tmp0
0042 7936 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7938 A30A 
0043               
0044 793A 0720  34         seto  @cmdb.visible         ; Show pane
     793C A302 
0045 793E 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7940 A318 
0046               
0047 7942 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7944 0001 
0048 7946 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7948 A022 
0049               
0050 794A 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     794C 7BBA 
0051               
0052 794E 0720  34         seto  @parm1                ; Do not turn screen off while
     7950 2F20 
0053                                                   ; reloading color scheme
0054               
0055 7952 06A0  32         bl    @pane.action.colorscheme.load
     7954 76F8 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 7956 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 7958 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 795A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0184                       copy  "pane.cmdb.hide.asm"     ; Hide command buffer pane
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
0023 795C 0649  14         dect  stack
0024 795E C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 7960 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7962 A11C 
     7964 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 7966 C820  54         mov   @tv.error.visible,@tv.error.visible
     7968 A028 
     796A A028 
0033 796C 1302  14         jeq   !
0034 796E 0620  34         dec   @fb.scrrows
     7970 A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 7972 06A0  32 !       bl    @hchar
     7974 27D4 
0039 7976 1900                   byte pane.botrow-4,0,32,80*3
     7978 20F0 
0040 797A 1C00                   byte pane.botrow-1,0,32,80*2
     797C 20A0 
0041 797E FFFF                   data EOL
0042                       ;------------------------------------------------------
0043                       ; Adjust frame buffer size if ruler visible
0044                       ;------------------------------------------------------
0045 7980 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     7982 A010 
     7984 A010 
0046 7986 1302  14         jeq   pane.cmdb.hide.rest
0047 7988 0620  34         dec   @fb.scrrows
     798A A11A 
0048                       ;------------------------------------------------------
0049                       ; Hide command buffer pane (rest)
0050                       ;------------------------------------------------------
0051               pane.cmdb.hide.rest:
0052 798C C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     798E A304 
     7990 832A 
0053 7992 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7994 A302 
0054 7996 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7998 A116 
0055 799A 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     799C A022 
0056                       ;------------------------------------------------------
0057                       ; Reload current color scheme
0058                       ;------------------------------------------------------
0059 799E 0720  34         seto  @parm1                ; Do not turn screen off while
     79A0 2F20 
0060                                                   ; reloading color scheme
0061               
0062 79A2 06A0  32         bl    @pane.action.colorscheme.load
     79A4 76F8 
0063                                                   ; Reload color scheme
0064                                                   ; i  parm1 = Skip screen off if >FFFF
0065                       ;------------------------------------------------------
0066                       ; Show cursor again
0067                       ;------------------------------------------------------
0068 79A6 06A0  32         bl    @pane.cursor.blink
     79A8 78A2 
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               pane.cmdb.hide.exit:
0073 79AA C2F9  30         mov   *stack+,r11           ; Pop r11
0074 79AC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0185                       copy  "pane.cmdb.draw.asm"     ; Draw command buffer pane contents
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
0017 79AE 0649  14         dect  stack
0018 79B0 C64B  30         mov   r11,*stack            ; Save return address
0019 79B2 0649  14         dect  stack
0020 79B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79B6 0649  14         dect  stack
0022 79B8 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Command buffer header line
0025                       ;------------------------------------------------------
0026 79BA C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     79BC A31C 
     79BE 2F20 
0027 79C0 0204  20         li    tmp0,80
     79C2 0050 
0028 79C4 C804  38         mov   tmp0,@parm2           ; Set requested length
     79C6 2F22 
0029 79C8 0204  20         li    tmp0,1
     79CA 0001 
0030 79CC C804  38         mov   tmp0,@parm3           ; Set character to fill
     79CE 2F24 
0031 79D0 0204  20         li    tmp0,rambuf
     79D2 2F6A 
0032 79D4 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     79D6 2F26 
0033               
0034 79D8 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     79DA 330C 
0035                                                   ; \ i  @parm1 = Pointer to string
0036                                                   ; | i  @parm2 = Requested length
0037                                                   ; | i  @parm3 = Fill character
0038                                                   ; | i  @parm4 = Pointer to buffer with
0039                                                   ; /             output string
0040               
0041 79DC C820  54         mov   @cmdb.yxtop,@wyx      ; \
     79DE A30E 
     79E0 832A 
0042 79E2 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     79E4 2F30 
0043 79E6 06A0  32         bl    @xutst0               ; /
     79E8 242C 
0044                       ;------------------------------------------------------
0045                       ; Check dialog id
0046                       ;------------------------------------------------------
0047 79EA 04E0  34         clr   @waux1                ; Default is show prompt
     79EC 833C 
0048               
0049 79EE C120  34         mov   @cmdb.dialog,tmp0
     79F0 A31A 
0050 79F2 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     79F4 0063 
0051 79F6 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0052 79F8 0720  34         seto  @waux1                ; /
     79FA 833C 
0053                       ;------------------------------------------------------
0054                       ; Show info message instead of prompt
0055                       ;------------------------------------------------------
0056 79FC C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     79FE A31E 
0057 7A00 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0058               
0059 7A02 C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     7A04 A31E 
     7A06 2F20 
0060 7A08 0204  20         li    tmp0,80
     7A0A 0050 
0061 7A0C C804  38         mov   tmp0,@parm2           ; Set requested length
     7A0E 2F22 
0062 7A10 0204  20         li    tmp0,32
     7A12 0020 
0063 7A14 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A16 2F24 
0064 7A18 0204  20         li    tmp0,rambuf
     7A1A 2F6A 
0065 7A1C C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A1E 2F26 
0066               
0067 7A20 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A22 330C 
0068                                                   ; \ i  @parm1 = Pointer to string
0069                                                   ; | i  @parm2 = Requested length
0070                                                   ; | i  @parm3 = Fill character
0071                                                   ; | i  @parm4 = Pointer to buffer with
0072                                                   ; /             output string
0073               
0074 7A24 06A0  32         bl    @at
     7A26 26DA 
0075 7A28 1A00                   byte pane.botrow-3,0  ; Position cursor
0076               
0077 7A2A C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     7A2C 2F30 
0078 7A2E 06A0  32         bl    @xutst0               ; /
     7A30 242C 
0079                       ;------------------------------------------------------
0080                       ; Clear lines after prompt in command buffer
0081                       ;------------------------------------------------------
0082               pane.cmdb.draw.clear:
0083 7A32 06A0  32         bl    @hchar
     7A34 27D4 
0084 7A36 1B00                   byte pane.botrow-2,0,32,80
     7A38 2050 
0085 7A3A FFFF                   data EOL              ; Remove key markers
0086                       ;------------------------------------------------------
0087                       ; Show key markers ?
0088                       ;------------------------------------------------------
0089 7A3C C120  34         mov   @cmdb.panmarkers,tmp0
     7A3E A322 
0090 7A40 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0091                       ;------------------------------------------------------
0092                       ; Loop over key marker list
0093                       ;------------------------------------------------------
0094               pane.cmdb.draw.marker.loop:
0095 7A42 D174  28         movb  *tmp0+,tmp1           ; Get X position
0096 7A44 0985  56         srl   tmp1,8                ; Right align
0097 7A46 0285  22         ci    tmp1,>00ff            ; End of list reached?
     7A48 00FF 
0098 7A4A 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0099               
0100 7A4C 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     7A4E 1B00 
0101                                                   ; y=bottom row - 3, x=(key marker position)
0102 7A50 C805  38         mov   tmp1,@wyx             ; Set cursor position
     7A52 832A 
0103               
0104 7A54 0649  14         dect  stack
0105 7A56 C644  30         mov   tmp0,*stack           ; Push tmp0
0106               
0107 7A58 06A0  32         bl    @putstr
     7A5A 242A 
0108 7A5C 35E4                   data txt.keymarker    ; Show key marker
0109               
0110 7A5E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111                       ;------------------------------------------------------
0112                       ; Show marker
0113                       ;------------------------------------------------------
0114 7A60 10F0  14         jmp   pane.cmdb.draw.marker.loop
0115                                                   ; Next iteration
0116               
0117               
0118                       ;------------------------------------------------------
0119                       ; Display pane hint in command buffer
0120                       ;------------------------------------------------------
0121               pane.cmdb.draw.hint:
0122 7A62 0204  20         li    tmp0,pane.botrow - 1  ; \
     7A64 001C 
0123 7A66 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0124 7A68 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A6A 2F20 
0125 7A6C C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7A6E A320 
     7A70 2F22 
0126               
0127 7A72 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A74 7630 
0128                                                   ; \ i  parm1 = Pointer to string with hint
0129                                                   ; / i  parm2 = YX position
0130                       ;------------------------------------------------------
0131                       ; Display keys in status line
0132                       ;------------------------------------------------------
0133 7A76 0204  20         li    tmp0,pane.botrow      ; \
     7A78 001D 
0134 7A7A 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0135 7A7C C804  38         mov   tmp0,@parm1           ; Set parameter
     7A7E 2F20 
0136 7A80 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7A82 A324 
     7A84 2F22 
0137               
0138 7A86 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A88 7630 
0139                                                   ; \ i  parm1 = Pointer to string with hint
0140                                                   ; / i  parm2 = YX position
0141                       ;------------------------------------------------------
0142                       ; ALPHA-Lock key down?
0143                       ;------------------------------------------------------
0144 7A8A 20A0  38         coc   @wbit10,config
     7A8C 200C 
0145 7A8E 1306  14         jeq   pane.cmdb.draw.alpha.down
0146                       ;------------------------------------------------------
0147                       ; AlPHA-Lock is up
0148                       ;------------------------------------------------------
0149 7A90 06A0  32         bl    @hchar
     7A92 27D4 
0150 7A94 1D4E                   byte pane.botrow,78,32,2
     7A96 2002 
0151 7A98 FFFF                   data eol
0152               
0153 7A9A 1004  14         jmp   pane.cmdb.draw.promptcmd
0154                       ;------------------------------------------------------
0155                       ; AlPHA-Lock is down
0156                       ;------------------------------------------------------
0157               pane.cmdb.draw.alpha.down:
0158 7A9C 06A0  32         bl    @putat
     7A9E 244E 
0159 7AA0 1D4E                   byte   pane.botrow,78
0160 7AA2 35DE                   data   txt.alpha.down
0161                       ;------------------------------------------------------
0162                       ; Command buffer content
0163                       ;------------------------------------------------------
0164               pane.cmdb.draw.promptcmd:
0165 7AA4 C120  34         mov   @waux1,tmp0           ; Flag set?
     7AA6 833C 
0166 7AA8 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0167 7AAA 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7AAC 7E0C 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               pane.cmdb.draw.exit:
0172 7AAE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0173 7AB0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0174 7AB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0175 7AB4 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0186                       copy  "pane.topline.asm"       ; Top line
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
0017 7AB6 0649  14         dect  stack
0018 7AB8 C64B  30         mov   r11,*stack            ; Save return address
0019 7ABA 0649  14         dect  stack
0020 7ABC C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7ABE 0649  14         dect  stack
0022 7AC0 C660  46         mov   @wyx,*stack           ; Push cursor position
     7AC2 832A 
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 7AC4 06A0  32         bl    @at
     7AC6 26DA 
0028 7AC8 0000                   byte 0,0              ; y=0, x=0
0029               
0030 7ACA C820  54         mov   @edb.filename.ptr,@parm1
     7ACC A212 
     7ACE 2F20 
0031                                                   ; Get string to display
0032 7AD0 0204  20         li    tmp0,47
     7AD2 002F 
0033 7AD4 C804  38         mov   tmp0,@parm2           ; Set requested length
     7AD6 2F22 
0034 7AD8 0204  20         li    tmp0,32
     7ADA 0020 
0035 7ADC C804  38         mov   tmp0,@parm3           ; Set character to fill
     7ADE 2F24 
0036 7AE0 0204  20         li    tmp0,rambuf
     7AE2 2F6A 
0037 7AE4 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7AE6 2F26 
0038               
0039               
0040 7AE8 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7AEA 330C 
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 7AEC C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7AEE 2F30 
0048 7AF0 06A0  32         bl    @xutst0               ; /
     7AF2 242C 
0049                       ;------------------------------------------------------
0050                       ; Show M1 marker
0051                       ;------------------------------------------------------
0052 7AF4 C120  34         mov   @edb.block.m1,tmp0    ; \
     7AF6 A20C 
0053 7AF8 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0054 7AFA 1326  14         jeq   pane.topline.exit     ; /
0055               
0056 7AFC 06A0  32         bl    @putat
     7AFE 244E 
0057 7B00 0034                   byte 0,52
0058 7B02 354A                   data txt.m1           ; Show M1 marker message
0059               
0060 7B04 C820  54         mov   @edb.block.m1,@parm1
     7B06 A20C 
     7B08 2F20 
0061 7B0A 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B0C 32E0 
0062                                                   ; \ i @parm1           = uint16
0063                                                   ; / o @unpacked.string = Output string
0064               
0065 7B0E 0204  20         li    tmp0,>0500
     7B10 0500 
0066 7B12 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B14 2F44 
0067               
0068 7B16 06A0  32         bl    @putat
     7B18 244E 
0069 7B1A 0037                   byte 0,55
0070 7B1C 2F44                   data unpacked.string  ; Show M1 value
0071                       ;------------------------------------------------------
0072                       ; Show M2 marker
0073                       ;------------------------------------------------------
0074 7B1E C120  34         mov   @edb.block.m2,tmp0    ; \
     7B20 A20E 
0075 7B22 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0076 7B24 1311  14         jeq   pane.topline.exit     ; /
0077               
0078 7B26 06A0  32         bl    @putat
     7B28 244E 
0079 7B2A 003E                   byte 0,62
0080 7B2C 354E                   data txt.m2           ; Show M2 marker message
0081               
0082 7B2E C820  54         mov   @edb.block.m2,@parm1
     7B30 A20E 
     7B32 2F20 
0083 7B34 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B36 32E0 
0084                                                   ; \ i @parm1           = uint16
0085                                                   ; / o @unpacked.string = Output string
0086               
0087 7B38 0204  20         li    tmp0,>0500
     7B3A 0500 
0088 7B3C D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B3E 2F44 
0089               
0090 7B40 06A0  32         bl    @putat
     7B42 244E 
0091 7B44 0041                   byte 0,65
0092 7B46 2F44                   data unpacked.string  ; Show M2 value
0093                       ;------------------------------------------------------
0094                       ; Exit
0095                       ;------------------------------------------------------
0096               pane.topline.exit:
0097 7B48 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7B4A 832A 
0098 7B4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 7B4E C2F9  30         mov   *stack+,r11           ; Pop r11
0100 7B50 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0187                       copy  "pane.errline.asm"       ; Error line
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
0022 7B52 0649  14         dect  stack
0023 7B54 C64B  30         mov   r11,*stack            ; Save return address
0024 7B56 0649  14         dect  stack
0025 7B58 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7B5A 0649  14         dect  stack
0027 7B5C C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7B5E 0205  20         li    tmp1,>00f6            ; White on dark red
     7B60 00F6 
0030 7B62 C805  38         mov   tmp1,@parm1
     7B64 2F20 
0031               
0032 7B66 0205  20         li    tmp1,pane.botrow-1    ;
     7B68 001C 
0033 7B6A C805  38         mov   tmp1,@parm2           ; Error line on screen
     7B6C 2F22 
0034               
0035 7B6E 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7B70 78C2 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7B72 0204  20         li    tmp0,tv.error.msg
     7B74 A02A 
0043 7B76 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7B78 2F20 
0044               
0045 7B7A 0204  20         li    tmp0,80
     7B7C 0050 
0046 7B7E C804  38         mov   tmp0,@parm2           ; Set requested length
     7B80 2F22 
0047               
0048 7B82 0204  20         li    tmp0,32
     7B84 0020 
0049 7B86 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7B88 2F24 
0050               
0051 7B8A 0204  20         li    tmp0,rambuf
     7B8C 2F6A 
0052 7B8E C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7B90 2F26 
0053               
0054 7B92 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B94 330C 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7B96 06A0  32         bl    @at
     7B98 26DA 
0064 7B9A 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7B9C C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7B9E 2F30 
0067 7BA0 06A0  32         bl    @xutst0               ; /
     7BA2 242C 
0068               
0069 7BA4 C120  34         mov   @fb.scrrows.max,tmp0
     7BA6 A11C 
0070 7BA8 0604  14         dec   tmp0
0071 7BAA C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7BAC A11A 
0072               
0073 7BAE 0720  34         seto  @tv.error.visible     ; Error line is visible
     7BB0 A028 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7BB2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7BB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7BB6 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7BB8 045B  20         b     *r11                  ; Return to caller
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
0103 7BBA 0649  14         dect  stack
0104 7BBC C64B  30         mov   r11,*stack            ; Save return address
0105 7BBE 0649  14         dect  stack
0106 7BC0 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7BC2 06A0  32         bl    @errline.init         ; Clear error line
     7BC4 3274 
0111               
0112 7BC6 C120  34         mov   @tv.color,tmp0        ; Get colors
     7BC8 A018 
0113 7BCA 0984  56         srl   tmp0,8                ; Right aligns
0114 7BCC C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7BCE 2F20 
0115               
0116               
0117 7BD0 0205  20         li    tmp1,pane.botrow-1    ;
     7BD2 001C 
0118 7BD4 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BD6 2F22 
0119               
0120 7BD8 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BDA 78C2 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7BDC 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7BDE A028 
0125 7BE0 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7BE2 A11C 
     7BE4 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7BE6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7BE8 C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7BEA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0188                       copy  "pane.botline.asm"       ; Bottom line
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
0017 7BEC 0649  14         dect  stack
0018 7BEE C64B  30         mov   r11,*stack            ; Save return address
0019 7BF0 0649  14         dect  stack
0020 7BF2 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7BF4 0649  14         dect  stack
0022 7BF6 C660  46         mov   @wyx,*stack           ; Push cursor position
     7BF8 832A 
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 7BFA C120  34         mov   @edb.block.m2,tmp0    ; \
     7BFC A20E 
0027 7BFE 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 7C00 1305  14         jeq   pane.botline.show_keys
0030               
0031 7C02 06A0  32         bl    @putat
     7C04 244E 
0032 7C06 1D00                   byte pane.botrow,0
0033 7C08 355A                   data txt.keys.block   ; Show block shortcuts
0034               
0035 7C0A 1004  14         jmp   pane.botline.show_dirty
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 7C0C 06A0  32         bl    @putat
     7C0E 244E 
0041 7C10 1D00                   byte pane.botrow,0
0042 7C12 3552                   data txt.keys.default ; Show default shortcuts
0043                       ;------------------------------------------------------
0044                       ; Show if text was changed in editor buffer
0045                       ;------------------------------------------------------
0046               pane.botline.show_dirty:
0047 7C14 C120  34         mov   @edb.dirty,tmp0
     7C16 A206 
0048 7C18 1305  14         jeq   pane.botline.nochange
0049                       ;------------------------------------------------------
0050                       ; Show "*"
0051                       ;------------------------------------------------------
0052 7C1A 06A0  32         bl    @putat
     7C1C 244E 
0053 7C1E 1D35                   byte pane.botrow,53   ; x=53
0054 7C20 34B4                   data txt.star
0055 7C22 1004  14         jmp   pane.botline.show_mode
0056                       ;------------------------------------------------------
0057                       ; Show " "
0058                       ;------------------------------------------------------
0059               pane.botline.nochange:
0060 7C24 06A0  32         bl    @putat
     7C26 244E 
0061 7C28 1D35                   byte pane.botrow,53   ; x=53
0062 7C2A 35E6                   data txt.ws1          ; Single white space
0063                       ;------------------------------------------------------
0064                       ; Show text editing mode
0065                       ;------------------------------------------------------
0066               pane.botline.show_mode:
0067 7C2C C120  34         mov   @edb.insmode,tmp0
     7C2E A20A 
0068 7C30 1605  14         jne   pane.botline.show_mode.insert
0069                       ;------------------------------------------------------
0070                       ; Overwrite mode
0071                       ;------------------------------------------------------
0072 7C32 06A0  32         bl    @putat
     7C34 244E 
0073 7C36 1D37                   byte  pane.botrow,55
0074 7C38 34AC                   data  txt.ovrwrite
0075 7C3A 1004  14         jmp   pane.botline.show_linecol
0076                       ;------------------------------------------------------
0077                       ; Insert mode
0078                       ;------------------------------------------------------
0079               pane.botline.show_mode.insert:
0080 7C3C 06A0  32         bl    @putat
     7C3E 244E 
0081 7C40 1D37                   byte  pane.botrow,55
0082 7C42 34B0                   data  txt.insert
0083                       ;------------------------------------------------------
0084                       ; Show "line,column"
0085                       ;------------------------------------------------------
0086               pane.botline.show_linecol:
0087 7C44 C820  54         mov   @fb.row,@parm1
     7C46 A106 
     7C48 2F20 
0088 7C4A 06A0  32         bl    @fb.row2line          ; Row to editor line
     7C4C 697C 
0089                                                   ; \ i @fb.topline = Top line in frame buffer
0090                                                   ; | i @parm1      = Row in frame buffer
0091                                                   ; / o @outparm1   = Matching line in EB
0092               
0093 7C4E 05A0  34         inc   @outparm1             ; Add base 1
     7C50 2F30 
0094                       ;------------------------------------------------------
0095                       ; Show line
0096                       ;------------------------------------------------------
0097 7C52 06A0  32         bl    @putnum
     7C54 2A64 
0098 7C56 1D3B                   byte  pane.botrow,59  ; YX
0099 7C58 2F30                   data  outparm1,rambuf
     7C5A 2F6A 
0100 7C5C 3020                   byte  48              ; ASCII offset
0101                             byte  32              ; Padding character
0102                       ;------------------------------------------------------
0103                       ; Show comma
0104                       ;------------------------------------------------------
0105 7C5E 06A0  32         bl    @putat
     7C60 244E 
0106 7C62 1D40                   byte  pane.botrow,64
0107 7C64 34A4                   data  txt.delim
0108                       ;------------------------------------------------------
0109                       ; Show column
0110                       ;------------------------------------------------------
0111 7C66 06A0  32         bl    @film
     7C68 2242 
0112 7C6A 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7C6C 0020 
     7C6E 000C 
0113               
0114 7C70 C820  54         mov   @fb.column,@waux1
     7C72 A10C 
     7C74 833C 
0115 7C76 05A0  34         inc   @waux1                ; Offset 1
     7C78 833C 
0116               
0117 7C7A 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7C7C 29E6 
0118 7C7E 833C                   data  waux1,rambuf
     7C80 2F6A 
0119 7C82 3020                   byte  48              ; ASCII offset
0120                             byte  32              ; Fill character
0121               
0122 7C84 06A0  32         bl    @trimnum              ; Trim number to the left
     7C86 2A3E 
0123 7C88 2F6A                   data  rambuf,rambuf+5,32
     7C8A 2F6F 
     7C8C 0020 
0124               
0125 7C8E 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7C90 0600 
0126 7C92 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7C94 2F6F 
0127               
0128                       ;------------------------------------------------------
0129                       ; Decide if row length is to be shown
0130                       ;------------------------------------------------------
0131 7C96 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7C98 A10C 
0132 7C9A 0584  14         inc   tmp0                  ; /
0133 7C9C 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7C9E A108 
0134 7CA0 1101  14         jlt   pane.botline.show_linecol.linelen
0135 7CA2 102B  14         jmp   pane.botline.show_linecol.colstring
0136                                                   ; Yes, skip showing row length
0137                       ;------------------------------------------------------
0138                       ; Add ',' delimiter and length of line to string
0139                       ;------------------------------------------------------
0140               pane.botline.show_linecol.linelen:
0141 7CA4 C120  34         mov   @fb.column,tmp0       ; \
     7CA6 A10C 
0142 7CA8 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7CAA 2F71 
0143 7CAC 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7CAE 0009 
0144 7CB0 1101  14         jlt   !                     ; | column.
0145 7CB2 0585  14         inc   tmp1                  ; /
0146               
0147 7CB4 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7CB6 2D00 
0148 7CB8 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0149               
0150 7CBA C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7CBC 833C 
0151               
0152 7CBE 06A0  32         bl    @mknum
     7CC0 29E6 
0153 7CC2 A108                   data  fb.row.length,rambuf
     7CC4 2F6A 
0154 7CC6 3020                   byte  48              ; ASCII offset
0155                             byte  32              ; Padding character
0156               
0157 7CC8 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7CCA 833C 
0158               
0159 7CCC C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7CCE A108 
0160 7CD0 0284  22         ci    tmp0,10               ; /
     7CD2 000A 
0161 7CD4 110B  14         jlt   pane.botline.show_line.1digit
0162                       ;------------------------------------------------------
0163                       ; Assert
0164                       ;------------------------------------------------------
0165 7CD6 0284  22         ci    tmp0,80
     7CD8 0050 
0166 7CDA 1204  14         jle   pane.botline.show_line.2digits
0167                       ;------------------------------------------------------
0168                       ; Asserts failed
0169                       ;------------------------------------------------------
0170 7CDC C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7CDE FFCE 
0171 7CE0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7CE2 2026 
0172                       ;------------------------------------------------------
0173                       ; Show length of line (2 digits)
0174                       ;------------------------------------------------------
0175               pane.botline.show_line.2digits:
0176 7CE4 0204  20         li    tmp0,rambuf+3
     7CE6 2F6D 
0177 7CE8 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0178 7CEA 1002  14         jmp   pane.botline.show_line.rest
0179                       ;------------------------------------------------------
0180                       ; Show length of line (1 digits)
0181                       ;------------------------------------------------------
0182               pane.botline.show_line.1digit:
0183 7CEC 0204  20         li    tmp0,rambuf+4
     7CEE 2F6E 
0184               pane.botline.show_line.rest:
0185 7CF0 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0186 7CF2 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CF4 2F6A 
0187 7CF6 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CF8 2F6A 
0188                       ;------------------------------------------------------
0189                       ; Show column string
0190                       ;------------------------------------------------------
0191               pane.botline.show_linecol.colstring:
0192 7CFA 06A0  32         bl    @putat
     7CFC 244E 
0193 7CFE 1D41                   byte pane.botrow,65
0194 7D00 2F6F                   data rambuf+5         ; Show string
0195                       ;------------------------------------------------------
0196                       ; Show lines in buffer unless on last line in file
0197                       ;------------------------------------------------------
0198 7D02 C820  54         mov   @fb.row,@parm1
     7D04 A106 
     7D06 2F20 
0199 7D08 06A0  32         bl    @fb.row2line
     7D0A 697C 
0200 7D0C 8820  54         c     @edb.lines,@outparm1
     7D0E A204 
     7D10 2F30 
0201 7D12 1605  14         jne   pane.botline.show_lines_in_buffer
0202               
0203 7D14 06A0  32         bl    @putat
     7D16 244E 
0204 7D18 1D48                   byte pane.botrow,72
0205 7D1A 34A6                   data txt.bottom
0206               
0207 7D1C 1009  14         jmp   pane.botline.exit
0208                       ;------------------------------------------------------
0209                       ; Show lines in buffer
0210                       ;------------------------------------------------------
0211               pane.botline.show_lines_in_buffer:
0212 7D1E C820  54         mov   @edb.lines,@waux1
     7D20 A204 
     7D22 833C 
0213               
0214 7D24 06A0  32         bl    @putnum
     7D26 2A64 
0215 7D28 1D48                   byte pane.botrow,72   ; YX
0216 7D2A 833C                   data waux1,rambuf
     7D2C 2F6A 
0217 7D2E 3020                   byte 48
0218                             byte 32
0219                       ;------------------------------------------------------
0220                       ; Exit
0221                       ;------------------------------------------------------
0222               pane.botline.exit:
0223 7D30 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7D32 832A 
0224 7D34 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0225 7D36 C2F9  30         mov   *stack+,r11           ; Pop r11
0226 7D38 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.56185
0189                       ;-----------------------------------------------------------------------
0190                       ; Stubs using trampoline
0191                       ;-----------------------------------------------------------------------
0192                       copy  "rom.stubs.bank1.asm"    ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "vdp.patterns.dump"
0007               * bank5 vec.1
0008               ********|*****|*********************|**************************
0009               vdp.patterns.dump:
0010 7D3A 0649  14         dect  stack
0011 7D3C C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7D3E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D40 3008 
0016 7D42 600A                   data bank5.rom        ; | i  p0 = bank address
0017 7D44 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0018 7D46 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7D48 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7D4A 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7D4C 0649  14         dect  stack
0032 7D4E C64B  30         mov   r11,*stack            ; Save return address
0033 7D50 0649  14         dect  stack
0034 7D52 C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7D54 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D56 3008 
0039 7D58 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7D5A 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0041 7D5C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7D5E C120  34         mov   @outparm1,tmp0
     7D60 2F30 
0046 7D62 1304  14         jeq   fm.loadfile.exit
0047               
0048 7D64 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7D66 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7D68 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D6A 7DC6 
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7D6C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7D6E C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7D70 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.savefile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.savefile:
0065 7D72 0649  14         dect  stack
0066 7D74 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Call function in bank 2
0069                       ;------------------------------------------------------
0070 7D76 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D78 3008 
0071 7D7A 6004                   data bank2.rom        ; | i  p0 = bank address
0072 7D7C 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0073 7D7E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077 7D80 C2F9  30         mov   *stack+,r11           ; Pop r11
0078 7D82 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               **************************************************************
0082               * Stub for "fm.browse.fname.suffix"
0083               * bank2 vec.3
0084               ********|*****|*********************|**************************
0085               fm.browse.fname.suffix:
0086 7D84 0649  14         dect  stack
0087 7D86 C64B  30         mov   r11,*stack            ; Save return address
0088                       ;------------------------------------------------------
0089                       ; Call function in bank 2
0090                       ;------------------------------------------------------
0091 7D88 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D8A 3008 
0092 7D8C 6004                   data bank2.rom        ; | i  p0 = bank address
0093 7D8E 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0094 7D90 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098 7D92 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7D94 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               **************************************************************
0103               * Stub for "fm.fastmode"
0104               * bank2 vec.4
0105               ********|*****|*********************|**************************
0106               fm.fastmode:
0107 7D96 0649  14         dect  stack
0108 7D98 C64B  30         mov   r11,*stack            ; Save return address
0109                       ;------------------------------------------------------
0110                       ; Call function in bank 2
0111                       ;------------------------------------------------------
0112 7D9A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D9C 3008 
0113 7D9E 6004                   data bank2.rom        ; | i  p0 = bank address
0114 7DA0 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0115 7DA2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119 7DA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0120 7DA6 045B  20         b     *r11                  ; Return to caller
0121               
0122               
0123               ***************************************************************
0124               * Stub for "About dialog"
0125               * bank3 vec.1
0126               ********|*****|*********************|**************************
0127               edkey.action.about:
0128 7DA8 C820  54         mov   @edkey.action.about.vector,@parm1
     7DAA 7DB0 
     7DAC 2F20 
0129 7DAE 1066  14         jmp   _trampoline.bank3     ; Show dialog
0130               edkey.action.about.vector:
0131 7DB0 7FC0             data  vec.1
0132               
0133               
0134               ***************************************************************
0135               * Stub for "Load DV80 file"
0136               * bank3 vec.2
0137               ********|*****|*********************|**************************
0138               dialog.load:
0139 7DB2 C820  54         mov   @dialog.load.vector,@parm1
     7DB4 7DBA 
     7DB6 2F20 
0140 7DB8 1061  14         jmp   _trampoline.bank3     ; Show dialog
0141               dialog.load.vector:
0142 7DBA 7FC2             data  vec.2
0143               
0144               
0145               ***************************************************************
0146               * Stub for "Save DV80 file"
0147               * bank3 vec.3
0148               ********|*****|*********************|**************************
0149               dialog.save:
0150 7DBC C820  54         mov   @dialog.save.vector,@parm1
     7DBE 7DC4 
     7DC0 2F20 
0151 7DC2 105C  14         jmp   _trampoline.bank3     ; Show dialog
0152               dialog.save.vector:
0153 7DC4 7FC4             data  vec.3
0154               
0155               
0156               ***************************************************************
0157               * Stub for "Unsaved Changes"
0158               * bank3 vec.4
0159               ********|*****|*********************|**************************
0160               dialog.unsaved:
0161 7DC6 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7DC8 A322 
0162 7DCA C820  54         mov   @dialog.unsaved.vector,@parm1
     7DCC 7DD2 
     7DCE 2F20 
0163 7DD0 1055  14         jmp   _trampoline.bank3     ; Show dialog
0164               dialog.unsaved.vector:
0165 7DD2 7FC6             data  vec.4
0166               
0167               
0168               ***************************************************************
0169               * Stub for Dialog "File dialog"
0170               * bank3 vec.5
0171               ********|*****|*********************|**************************
0172               dialog.file:
0173 7DD4 C820  54         mov   @dialog.file.vector,@parm1
     7DD6 7DDC 
     7DD8 2F20 
0174 7DDA 1050  14         jmp   _trampoline.bank3     ; Show dialog
0175               dialog.file.vector:
0176 7DDC 7FC8             data  vec.5
0177               
0178               
0179               ***************************************************************
0180               * Stub for Dialog "Stevie Menu dialog"
0181               * bank3 vec.6
0182               ********|*****|*********************|**************************
0183               dialog.menu:
0184                       ;------------------------------------------------------
0185                       ; Check if block mode is active
0186                       ;------------------------------------------------------
0187 7DDE C120  34         mov   @edb.block.m2,tmp0    ; \
     7DE0 A20E 
0188 7DE2 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0189                                                   ; /
0190 7DE4 1302  14         jeq   !                     : Block mode inactive, show dialog
0191                       ;------------------------------------------------------
0192                       ; Special treatment for block mode
0193                       ;------------------------------------------------------
0194 7DE6 0460  28         b     @edkey.action.block.reset
     7DE8 66E0 
0195                                                   ; Reset block mode
0196                       ;------------------------------------------------------
0197                       ; Show dialog
0198                       ;------------------------------------------------------
0199 7DEA 06A0  32 !       bl    @rom.farjump          ; \ Trampoline jump to bank
     7DEC 3008 
0200 7DEE 6006                   data bank3.rom        ; | i  p0 = bank address
0201 7DF0 7FCA                   data vec.6            ; | i  p1 = Vector with target address
0202 7DF2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0203                       ;------------------------------------------------------
0204                       ; Exit
0205                       ;------------------------------------------------------
0206 7DF4 0460  28         b     @edkey.action.cmdb.show
     7DF6 684C 
0207                                                   ; Show dialog in CMDB pane
0208               
0209               
0210               ***************************************************************
0211               * Stub for Dialog "Basic dialog"
0212               * bank3 vec.7
0213               ********|*****|*********************|**************************
0214               dialog.basic:
0215 7DF8 C820  54         mov   @dialog.basic.vector,@parm1
     7DFA 7E00 
     7DFC 2F20 
0216 7DFE 103E  14         jmp   _trampoline.bank3     ; Show dialog
0217               dialog.basic.vector:
0218 7E00 7FCC             data  vec.7
0219               
0220               
0221               
0222               ***************************************************************
0223               * Stub for "run.tibasic"
0224               * bank3 vec.24
0225               ********|*****|*********************|**************************
0226               run.tibasic:
0227 7E02 C820  54         mov   @run.tibasic.vector,@parm1
     7E04 7E0A 
     7E06 2F20 
0228 7E08 1042  14         jmp   _trampoline.bank3.ret ; Longjump
0229               run.tibasic.vector:
0230 7E0A 7FE6             data  vec.20
0231               
0232               
0233               ***************************************************************
0234               * Stub for "cmdb.refresh"
0235               * bank3 vec.24
0236               ********|*****|*********************|**************************
0237               cmdb.refresh:
0238 7E0C C820  54         mov   @cmdb.refresh.vector,@parm1
     7E0E 7E14 
     7E10 2F20 
0239 7E12 103D  14         jmp   _trampoline.bank3.ret ; Longjump
0240               cmdb.refresh.vector:
0241 7E14 7FEE             data  vec.24
0242               
0243               
0244               ***************************************************************
0245               * Stub for "cmdb.cmd.clear"
0246               * bank3 vec.25
0247               ********|*****|*********************|**************************
0248               cmdb.cmd.clear:
0249 7E16 C820  54         mov   @cmdb.cmd.clear.vector,@parm1
     7E18 7E1E 
     7E1A 2F20 
0250 7E1C 1038  14         jmp   _trampoline.bank3.ret ; Longjump
0251               cmdb.cmd.clear.vector:
0252 7E1E 7FF0             data  vec.25
0253               
0254               
0255               ***************************************************************
0256               * Stub for "cmdb.cmdb.getlength"
0257               * bank3 vec.26
0258               ********|*****|*********************|**************************
0259               cmdb.cmd.getlength:
0260 7E20 C820  54         mov   @cmdb.cmd.getlength.vector,@parm1
     7E22 7E28 
     7E24 2F20 
0261 7E26 1033  14         jmp   _trampoline.bank3.ret ; Longjump
0262               cmdb.cmd.getlength.vector:
0263 7E28 7FF2             data  vec.26
0264               
0265               
0266               ***************************************************************
0267               * Stub for "cmdb.cmdb.addhist"
0268               * bank3 vec.27
0269               ********|*****|*********************|**************************
0270               cmdb.cmd.addhist:
0271 7E2A C820  54         mov   @cmdb.cmd.addhist.vector,@parm1
     7E2C 7E32 
     7E2E 2F20 
0272 7E30 102E  14         jmp   _trampoline.bank3.ret ; Longjump
0273               cmdb.cmd.addhist.vector:
0274 7E32 7FF4             data  vec.27
0275               
0276               
0277               ***************************************************************
0278               * Stub for "fb.tab.next"
0279               * bank4 vec.1
0280               ********|*****|*********************|**************************
0281               fb.tab.next:
0282 7E34 0649  14         dect  stack
0283 7E36 C64B  30         mov   r11,*stack            ; Save return address
0284                       ;------------------------------------------------------
0285                       ; Put cursor on next tab position
0286                       ;------------------------------------------------------
0287 7E38 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E3A 3008 
0288 7E3C 6008                   data bank4.rom        ; | i  p0 = bank address
0289 7E3E 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0290 7E40 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0291                       ;------------------------------------------------------
0292                       ; Exit
0293                       ;------------------------------------------------------
0294 7E42 C2F9  30         mov   *stack+,r11           ; Pop r11
0295 7E44 045B  20         b     *r11                  ; Return to caller
0296               
0297               
0298               ***************************************************************
0299               * Stub for "fb.ruler.init"
0300               * bank4 vec.2
0301               ********|*****|*********************|**************************
0302               fb.ruler.init:
0303 7E46 0649  14         dect  stack
0304 7E48 C64B  30         mov   r11,*stack            ; Save return address
0305                       ;------------------------------------------------------
0306                       ; Setup ruler in memory
0307                       ;------------------------------------------------------
0308 7E4A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E4C 3008 
0309 7E4E 6008                   data bank4.rom        ; | i  p0 = bank address
0310 7E50 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0311 7E52 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0312                       ;------------------------------------------------------
0313                       ; Exit
0314                       ;------------------------------------------------------
0315 7E54 C2F9  30         mov   *stack+,r11           ; Pop r11
0316 7E56 045B  20         b     *r11                  ; Return to caller
0317               
0318               
0319               ***************************************************************
0320               * Stub for "fb.colorlines"
0321               * bank4 vec.3
0322               ********|*****|*********************|**************************
0323               fb.colorlines:
0324 7E58 0649  14         dect  stack
0325 7E5A C64B  30         mov   r11,*stack            ; Save return address
0326                       ;------------------------------------------------------
0327                       ; Colorize frame buffer content
0328                       ;------------------------------------------------------
0329 7E5C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E5E 3008 
0330 7E60 6008                   data bank4.rom        ; | i  p0 = bank address
0331 7E62 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0332 7E64 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0333                       ;------------------------------------------------------
0334                       ; Exit
0335                       ;------------------------------------------------------
0336 7E66 C2F9  30         mov   *stack+,r11           ; Pop r11
0337 7E68 045B  20         b     *r11                  ; Return to caller
0338               
0339               
0340               ***************************************************************
0341               * Stub for "fb.vdpdump"
0342               * bank4 vec.4
0343               ********|*****|*********************|**************************
0344               fb.vdpdump:
0345 7E6A 0649  14         dect  stack
0346 7E6C C64B  30         mov   r11,*stack            ; Save return address
0347                       ;------------------------------------------------------
0348                       ; Colorize frame buffer content
0349                       ;------------------------------------------------------
0350 7E6E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E70 3008 
0351 7E72 6008                   data bank4.rom        ; | i  p0 = bank address
0352 7E74 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0353 7E76 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0354                       ;------------------------------------------------------
0355                       ; Exit
0356                       ;------------------------------------------------------
0357 7E78 C2F9  30         mov   *stack+,r11           ; Pop r11
0358 7E7A 045B  20         b     *r11                  ; Return to caller
0359               
0360               
0361               ***************************************************************
0362               * Trampoline 1 (bank 3, dialog)
0363               ********|*****|*********************|**************************
0364               _trampoline.bank3:
0365 7E7C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E7E 7884 
0366                       ;------------------------------------------------------
0367                       ; Show dialog
0368                       ;------------------------------------------------------
0369 7E80 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E82 3008 
0370 7E84 6006                   data bank3.rom        ; | i  p0 = bank address
0371 7E86 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0372                                                   ; |         (deref @parm1)
0373 7E88 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0374                       ;------------------------------------------------------
0375                       ; Exit
0376                       ;------------------------------------------------------
0377 7E8A 0460  28         b     @edkey.action.cmdb.show
     7E8C 684C 
0378                                                   ; Show dialog in CMDB pane
0379               
0380               
0381               ***************************************************************
0382               * Trampoline 2 (bank 3 with return)
0383               ********|*****|*********************|**************************
0384               _trampoline.bank3.ret:
0385 7E8E 0649  14         dect  stack
0386 7E90 C64B  30         mov   r11,*stack            ; Save return address
0387                       ;------------------------------------------------------
0388                       ; Show dialog
0389                       ;------------------------------------------------------
0390 7E92 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E94 3008 
0391 7E96 6006                   data bank3.rom        ; | i  p0 = bank address
0392 7E98 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0393                                                   ; |         (deref @parm1)
0394 7E9A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0395                       ;------------------------------------------------------
0396                       ; Exit
0397                       ;------------------------------------------------------
0398 7E9C C2F9  30         mov   *stack+,r11           ; Pop r11
0399 7E9E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.56185
0193                       ;-----------------------------------------------------------------------
0194                       ; Program data
0195                       ;-----------------------------------------------------------------------
0196                       copy  "data.keymap.actions.asm"; Data segment - Keyboard actions
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
0011 7EA0 0D00             byte  key.enter, pane.focus.fb
0012 7EA2 656C             data  edkey.action.enter
0013               
0014 7EA4 0800             byte  key.fctn.s, pane.focus.fb
0015 7EA6 6194             data  edkey.action.left
0016               
0017 7EA8 0900             byte  key.fctn.d, pane.focus.fb
0018 7EAA 61AE             data  edkey.action.right
0019               
0020 7EAC 0B00             byte  key.fctn.e, pane.focus.fb
0021 7EAE 62A6             data  edkey.action.up
0022               
0023 7EB0 0A00             byte  key.fctn.x, pane.focus.fb
0024 7EB2 62AE             data  edkey.action.down
0025               
0026 7EB4 BF00             byte  key.fctn.h, pane.focus.fb
0027 7EB6 61CA             data  edkey.action.home
0028               
0029 7EB8 C000             byte  key.fctn.j, pane.focus.fb
0030 7EBA 61F4             data  edkey.action.pword
0031               
0032 7EBC C100             byte  key.fctn.k, pane.focus.fb
0033 7EBE 6246             data  edkey.action.nword
0034               
0035 7EC0 C200             byte  key.fctn.l, pane.focus.fb
0036 7EC2 61D2             data  edkey.action.end
0037               
0038 7EC4 0C00             byte  key.fctn.6, pane.focus.fb
0039 7EC6 62B6             data  edkey.action.ppage
0040               
0041 7EC8 0200             byte  key.fctn.4, pane.focus.fb
0042 7ECA 62F2             data  edkey.action.npage
0043               
0044 7ECC 8500             byte  key.ctrl.e, pane.focus.fb
0045 7ECE 62B6             data  edkey.action.ppage
0046               
0047 7ED0 9800             byte  key.ctrl.x, pane.focus.fb
0048 7ED2 62F2             data  edkey.action.npage
0049               
0050 7ED4 9400             byte  key.ctrl.t, pane.focus.fb
0051 7ED6 632C             data  edkey.action.top
0052               
0053 7ED8 8200             byte  key.ctrl.b, pane.focus.fb
0054 7EDA 6348             data  edkey.action.bot
0055                       ;-------------------------------------------------------
0056                       ; Modifier keys - Delete
0057                       ;-------------------------------------------------------
0058 7EDC 0300             byte  key.fctn.1, pane.focus.fb
0059 7EDE 63BA             data  edkey.action.del_char
0060               
0061 7EE0 0700             byte  key.fctn.3, pane.focus.fb
0062 7EE2 646C             data  edkey.action.del_line
0063               
0064 7EE4 0200             byte  key.fctn.4, pane.focus.fb
0065 7EE6 6438             data  edkey.action.del_eol
0066                       ;-------------------------------------------------------
0067                       ; Modifier keys - Insert
0068                       ;-------------------------------------------------------
0069 7EE8 0400             byte  key.fctn.2, pane.focus.fb
0070 7EEA 64CE             data  edkey.action.ins_char.ws
0071               
0072 7EEC B900             byte  key.fctn.dot, pane.focus.fb
0073 7EEE 65E4             data  edkey.action.ins_onoff
0074               
0075 7EF0 0100             byte  key.fctn.7, pane.focus.fb
0076 7EF2 679E             data  edkey.action.fb.tab.next
0077               
0078 7EF4 0600             byte  key.fctn.8, pane.focus.fb
0079 7EF6 6564             data  edkey.action.ins_line
0080                       ;-------------------------------------------------------
0081                       ; Block marking/modifier
0082                       ;-------------------------------------------------------
0083 7EF8 9600             byte  key.ctrl.v, pane.focus.fb
0084 7EFA 66D8             data  edkey.action.block.mark
0085               
0086 7EFC 8300             byte  key.ctrl.c, pane.focus.fb
0087 7EFE 66EC             data  edkey.action.block.copy
0088               
0089 7F00 8400             byte  key.ctrl.d, pane.focus.fb
0090 7F02 6728             data  edkey.action.block.delete
0091               
0092 7F04 8D00             byte  key.ctrl.m, pane.focus.fb
0093 7F06 6752             data  edkey.action.block.move
0094               
0095 7F08 8700             byte  key.ctrl.g, pane.focus.fb
0096 7F0A 6784             data  edkey.action.block.goto.m1
0097                       ;-------------------------------------------------------
0098                       ; Other action keys
0099                       ;-------------------------------------------------------
0100 7F0C 0500             byte  key.fctn.plus, pane.focus.fb
0101 7F0E 665E             data  edkey.action.quit
0102               
0103 7F10 9100             byte  key.ctrl.q, pane.focus.fb
0104 7F12 665E             data  edkey.action.quit
0105               
0106 7F14 9500             byte  key.ctrl.u, pane.focus.fb
0107 7F16 666C             data  edkey.action.toggle.ruler
0108               
0109 7F18 9A00             byte  key.ctrl.z, pane.focus.fb
0110 7F1A 769A             data  pane.action.colorscheme.cycle
0111               
0112 7F1C 8000             byte  key.ctrl.comma, pane.focus.fb
0113 7F1E 6692             data  edkey.action.fb.fname.dec.load
0114               
0115 7F20 9B00             byte  key.ctrl.dot, pane.focus.fb
0116 7F22 669E             data  edkey.action.fb.fname.inc.load
0117                       ;-------------------------------------------------------
0118                       ; Dialog keys
0119                       ;-------------------------------------------------------
0120 7F24 8800             byte  key.ctrl.h, pane.focus.fb
0121 7F26 7DA8             data  edkey.action.about
0122               
0123 7F28 8600             byte  key.ctrl.f, pane.focus.fb
0124 7F2A 7DD4             data  dialog.file
0125               
0126 7F2C 9300             byte  key.ctrl.s, pane.focus.fb
0127 7F2E 7DBC             data  dialog.save
0128               
0129 7F30 8F00             byte  key.ctrl.o, pane.focus.fb
0130 7F32 7DB2             data  dialog.load
0131               
0132                       ;
0133                       ; FCTN-9 has multipe purposes, if block mode is on it
0134                       ; resets the block, otherwise show Stevie menu dialog.
0135                       ;
0136 7F34 0F00             byte  key.fctn.9, pane.focus.fb
0137 7F36 7DDE             data  dialog.menu
0138                       ;-------------------------------------------------------
0139                       ; End of list
0140                       ;-------------------------------------------------------
0141 7F38 FFFF             data  EOL                           ; EOL
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
0152 7F3A 4664             byte  key.uc.f, id.dialog.menu
0153 7F3C 7DD4             data  dialog.file
0154               
0155 7F3E 4264             byte  key.uc.b, id.dialog.menu
0156 7F40 7E02             data  run.tibasic
0157               
0158 7F42 4864             byte  key.uc.h, id.dialog.menu
0159 7F44 7DA8             data  edkey.action.about
0160               
0161 7F46 5164             byte  key.uc.q, id.dialog.menu
0162 7F48 665E             data  edkey.action.quit
0163                       ;-------------------------------------------------------
0164                       ; Dialog: File
0165                       ;-------------------------------------------------------
0166 7F4A 4E68             byte  key.uc.n, id.dialog.file
0167 7F4C 685E             data  edkey.action.cmdb.file.new
0168               
0169 7F4E 5368             byte  key.uc.s, id.dialog.file
0170 7F50 7DBC             data  dialog.save
0171               
0172 7F52 4F68             byte  key.uc.o, id.dialog.file
0173 7F54 7DB2             data  dialog.load
0174                       ;-------------------------------------------------------
0175                       ; Dialog: Open DV80 file
0176                       ;-------------------------------------------------------
0177 7F56 0E0A             byte  key.fctn.5, id.dialog.load
0178 7F58 6950             data  edkey.action.cmdb.fastmode.toggle
0179               
0180 7F5A 0D0A             byte  key.enter, id.dialog.load
0181 7F5C 6882             data  edkey.action.cmdb.load
0182                       ;-------------------------------------------------------
0183                       ; Dialog: Unsaved changes
0184                       ;-------------------------------------------------------
0185 7F5E 0C65             byte  key.fctn.6, id.dialog.unsaved
0186 7F60 6926             data  edkey.action.cmdb.proceed
0187               
0188 7F62 0D65             byte  key.enter, id.dialog.unsaved
0189 7F64 7DBC             data  dialog.save
0190                       ;-------------------------------------------------------
0191                       ; Dialog: Save DV80 file
0192                       ;-------------------------------------------------------
0193 7F66 0D0B             byte  key.enter, id.dialog.save
0194 7F68 68C6             data  edkey.action.cmdb.save
0195               
0196 7F6A 0D0C             byte  key.enter, id.dialog.saveblock
0197 7F6C 68C6             data  edkey.action.cmdb.save
0198                       ;-------------------------------------------------------
0199                       ; Dialog: Basic
0200                       ;-------------------------------------------------------
0201 7F6E 4269             byte  key.uc.b, id.dialog.basic
0202 7F70 7E02             data  run.tibasic
0203               
0204                       ;-------------------------------------------------------
0205                       ; Dialog: About
0206                       ;-------------------------------------------------------
0207 7F72 0F67             byte  key.fctn.9, id.dialog.about
0208 7F74 695C             data  edkey.action.cmdb.close.about
0209                       ;-------------------------------------------------------
0210                       ; Movement keys
0211                       ;-------------------------------------------------------
0212 7F76 0801             byte  key.fctn.s, pane.focus.cmdb
0213 7F78 67AC             data  edkey.action.cmdb.left
0214               
0215 7F7A 0901             byte  key.fctn.d, pane.focus.cmdb
0216 7F7C 67BE             data  edkey.action.cmdb.right
0217               
0218 7F7E BF01             byte  key.fctn.h, pane.focus.cmdb
0219 7F80 67D6             data  edkey.action.cmdb.home
0220               
0221 7F82 C201             byte  key.fctn.l, pane.focus.cmdb
0222 7F84 67EA             data  edkey.action.cmdb.end
0223                       ;-------------------------------------------------------
0224                       ; Modifier keys
0225                       ;-------------------------------------------------------
0226 7F86 0701             byte  key.fctn.3, pane.focus.cmdb
0227 7F88 6802             data  edkey.action.cmdb.clear
0228                       ;-------------------------------------------------------
0229                       ; Other action keys
0230                       ;-------------------------------------------------------
0231 7F8A 0F01             byte  key.fctn.9, pane.focus.cmdb
0232 7F8C 6968             data  edkey.action.cmdb.close.dialog
0233               
0234 7F8E 0501             byte  key.fctn.plus, pane.focus.cmdb
0235 7F90 665E             data  edkey.action.quit
0236               
0237 7F92 9A01             byte  key.ctrl.z, pane.focus.cmdb
0238 7F94 769A             data  pane.action.colorscheme.cycle
0239                       ;------------------------------------------------------
0240                       ; End of list
0241                       ;-------------------------------------------------------
0242 7F96 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.56185
0197                       ;-----------------------------------------------------------------------
0198                       ; Bank full check
0199                       ;-----------------------------------------------------------------------
0203                       ;-----------------------------------------------------------------------
0204                       ; Vector table
0205                       ;-----------------------------------------------------------------------
0206                       aorg  >7fc0
0207                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 6D7A     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0008 7FC2 6C32     vec.2   data  idx.entry.update      ;    for index functions.
0009 7FC4 6CE0     vec.3   data  idx.entry.delete      ;
0010 7FC6 6C84     vec.4   data  idx.pointer.get       ;
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 6E62     vec.10  data  edb.line.pack.fb      ;
0017 7FD4 6F5A     vec.11  data  edb.line.unpack.fb    ;
0018 7FD6 2026     vec.12  data  cpu.crash             ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 684C     vec.15  data  edkey.action.cmdb.show
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 2026     vec.18  data  cpu.crash             ;
0025 7FE4 7E16     vec.19  data  cmdb.cmd.clear        ;
0026 7FE6 6B86     vec.20  data  fb.refresh            ;
0027 7FE8 7E6A     vec.21  data  fb.vdpdump            ;
0028 7FEA 2026     vec.22  data  cpu.crash             ;
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 2026     vec.24  data  cpu.crash             ;
0031 7FF0 2026     vec.25  data  cpu.crash             ;
0032 7FF2 2026     vec.26  data  cpu.crash             ;
0033 7FF4 2026     vec.27  data  cpu.crash             ;
0034 7FF6 78A2     vec.28  data  pane.cursor.blink     ;
0035 7FF8 7884     vec.29  data  pane.cursor.hide      ;
0036 7FFA 7B52     vec.30  data  pane.errline.show     ;
0037 7FFC 76F8     vec.31  data  pane.action.colorscheme.load
0038 7FFE 786A     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.56185
0208                                                   ; Vector table bank 1
0209               *--------------------------------------------------------------
0210               * Video mode configuration
0211               *--------------------------------------------------------------
0212      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0213      0004     spfbck  equ   >04                   ; Screen background color.
0214      33B0     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0215      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0216      0050     colrow  equ   80                    ; Columns per row
0217      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0218      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0219      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0220      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

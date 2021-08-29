XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.1406079
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210829-1406079
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
**** **** ****     > stevie_b1.asm.1406079
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
**** **** ****     > stevie_b1.asm.1406079
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
**** **** ****     > stevie_b1.asm.1406079
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
**** **** ****     > stevie_b1.asm.1406079
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
     2084 2E5A 
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
     20A8 29DE 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
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
     20BC 29DE 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
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
     210C 29E8 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
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
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
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
     2138 29E8 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 295A 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
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
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
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
     2176 2D58 
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
0260 21D3 ....             text  'Build-ID  210829-1406079'
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
0016 27FE 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     2800 2020 
0017 2802 020C  20         li    r12,>0024
     2804 0024 
0018 2806 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     2808 289A 
0019 280A 04C6  14         clr   tmp2
0020 280C 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 280E 04CC  14         clr   r12
0025 2810 1F08  20         tb    >0008                 ; Shift-key ?
0026 2812 1302  14         jeq   realk1                ; No
0027 2814 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2816 28CA 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 2818 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 281A 1302  14         jeq   realk2                ; No
0033 281C 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     281E 28FA 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 2820 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2822 1302  14         jeq   realk3                ; No
0039 2824 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2826 292A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 2828 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     282A 200C 
0044 282C 1E15  20         sbz   >0015                 ; Set P5
0045 282E 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2830 1302  14         jeq   realk4                ; No
0047 2832 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2834 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2836 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 2838 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     283A 0006 
0053 283C 0606  14 realk5  dec   tmp2
0054 283E 020C  20         li    r12,>24               ; CRU address for P2-P4
     2840 0024 
0055 2842 06C6  14         swpb  tmp2
0056 2844 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2846 06C6  14         swpb  tmp2
0058 2848 020C  20         li    r12,6                 ; CRU read address
     284A 0006 
0059 284C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 284E 0547  14         inv   tmp3                  ;
0061 2850 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2852 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2854 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2856 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2858 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 285A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 285C 0285  22         ci    tmp1,8
     285E 0008 
0070 2860 1AFA  14         jl    realk6
0071 2862 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2864 1BEB  14         jh    realk5                ; No, next column
0073 2866 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2868 C206  18 realk8  mov   tmp2,tmp4
0078 286A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 286C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 286E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2870 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2872 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2874 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2876 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2878 200C 
0089 287A 1608  14         jne   realka                ; No, continue saving key
0090 287C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     287E 28C4 
0091 2880 1A05  14         jl    realka
0092 2882 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2884 28C2 
0093 2886 1B02  14         jh    realka                ; No, continue
0094 2888 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     288A E000 
0095 288C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     288E 833C 
0096 2890 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2892 200A 
0097 2894 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2896 8C00 
0098                                                   ; / using R15 as temp storage
0099 2898 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 289A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     289C 0000 
     289E FF0D 
     28A0 203D 
0102 28A2 ....             text  'xws29ol.'
0103 28AA ....             text  'ced38ik,'
0104 28B2 ....             text  'vrf47ujm'
0105 28BA ....             text  'btg56yhn'
0106 28C2 ....             text  'zqa10p;/'
0107 28CA FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28CC 0000 
     28CE FF0D 
     28D0 202B 
0108 28D2 ....             text  'XWS@(OL>'
0109 28DA ....             text  'CED#*IK<'
0110 28E2 ....             text  'VRF$&UJM'
0111 28EA ....             text  'BTG%^YHN'
0112 28F2 ....             text  'ZQA!)P:-'
0113 28FA FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28FC 0000 
     28FE FF0D 
     2900 2005 
0114 2902 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     2904 0804 
     2906 0F27 
     2908 C2B9 
0115 290A 600B             data  >600b,>0907,>063f,>c1B8
     290C 0907 
     290E 063F 
     2910 C1B8 
0116 2912 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     2914 7B02 
     2916 015F 
     2918 C0C3 
0117 291A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     291C 7D0E 
     291E 0CC6 
     2920 BFC4 
0118 2922 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     2924 7C03 
     2926 BC22 
     2928 BDBA 
0119 292A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     292C 0000 
     292E FF0D 
     2930 209D 
0120 2932 9897             data  >9897,>93b2,>9f8f,>8c9B
     2934 93B2 
     2936 9F8F 
     2938 8C9B 
0121 293A 8385             data  >8385,>84b3,>9e89,>8b80
     293C 84B3 
     293E 9E89 
     2940 8B80 
0122 2942 9692             data  >9692,>86b4,>b795,>8a8D
     2944 86B4 
     2946 B795 
     2948 8A8D 
0123 294A 8294             data  >8294,>87b5,>b698,>888E
     294C 87B5 
     294E B698 
     2950 888E 
0124 2952 9A91             data  >9a91,>81b1,>b090,>9cBB
     2954 81B1 
     2956 B090 
     2958 9CBB 
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
0023 295A C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 295C C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     295E 8340 
0025 2960 04E0  34         clr   @waux1
     2962 833C 
0026 2964 04E0  34         clr   @waux2
     2966 833E 
0027 2968 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     296A 833C 
0028 296C C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 296E 0205  20         li    tmp1,4                ; 4 nibbles
     2970 0004 
0033 2972 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2974 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2976 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2978 0286  22         ci    tmp2,>000a
     297A 000A 
0039 297C 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 297E C21B  26         mov   *r11,tmp4
0045 2980 0988  56         srl   tmp4,8                ; Right justify
0046 2982 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2984 FFF6 
0047 2986 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2988 C21B  26         mov   *r11,tmp4
0054 298A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     298C 00FF 
0055               
0056 298E A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2990 06C6  14         swpb  tmp2
0058 2992 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2994 0944  56         srl   tmp0,4                ; Next nibble
0060 2996 0605  14         dec   tmp1
0061 2998 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 299A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     299C BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 299E C160  34         mov   @waux3,tmp1           ; Get pointer
     29A0 8340 
0067 29A2 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 29A4 0585  14         inc   tmp1                  ; Next byte, not word!
0069 29A6 C120  34         mov   @waux2,tmp0
     29A8 833E 
0070 29AA 06C4  14         swpb  tmp0
0071 29AC DD44  32         movb  tmp0,*tmp1+
0072 29AE 06C4  14         swpb  tmp0
0073 29B0 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29B2 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29B4 8340 
0078 29B6 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29B8 2016 
0079 29BA 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29BC C120  34         mov   @waux1,tmp0
     29BE 833C 
0084 29C0 06C4  14         swpb  tmp0
0085 29C2 DD44  32         movb  tmp0,*tmp1+
0086 29C4 06C4  14         swpb  tmp0
0087 29C6 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29C8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29CA 2020 
0092 29CC 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29CE 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29D0 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29D2 7FFF 
0098 29D4 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29D6 8340 
0099 29D8 0460  28         b     @xutst0               ; Display string
     29DA 242E 
0100 29DC 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29DE C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29E0 832A 
0122 29E2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29E4 8000 
0123 29E6 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29E8 0207  20 mknum   li    tmp3,5                ; Digit counter
     29EA 0005 
0020 29EC C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29EE C155  26         mov   *tmp1,tmp1            ; /
0022 29F0 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29F2 0228  22         ai    tmp4,4                ; Get end of buffer
     29F4 0004 
0024 29F6 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29F8 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29FA 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29FC 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29FE 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2A00 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 2A02 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 2A04 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 2A06 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2A08 0607  14         dec   tmp3                  ; Decrease counter
0036 2A0A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2A0C 0207  20         li    tmp3,4                ; Check first 4 digits
     2A0E 0004 
0041 2A10 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A12 C11B  26         mov   *r11,tmp0
0043 2A14 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A16 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A18 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A1A 05CB  14 mknum3  inct  r11
0047 2A1C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A1E 2020 
0048 2A20 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A22 045B  20         b     *r11                  ; Exit
0050 2A24 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A26 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A28 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A2A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A2C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A2E 7FFF 
0058 2A30 C10B  18         mov   r11,tmp0
0059 2A32 0224  22         ai    tmp0,-4
     2A34 FFFC 
0060 2A36 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A38 0206  20         li    tmp2,>0500            ; String length = 5
     2A3A 0500 
0062 2A3C 0460  28         b     @xutstr               ; Display string
     2A3E 2430 
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
0093 2A40 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A42 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A44 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A46 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A48 0207  20         li    tmp3,5                ; Set counter
     2A4A 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A4C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A4E 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A50 0584  14         inc   tmp0                  ; Next character
0105 2A52 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A54 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A56 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A58 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A5A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A5C 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A5E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A60 0607  14         dec   tmp3                  ; Last character ?
0121 2A62 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A64 045B  20         b     *r11                  ; Return
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
0139 2A66 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A68 832A 
0140 2A6A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A6C 8000 
0141 2A6E 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A70 0649  14         dect  stack
0023 2A72 C64B  30         mov   r11,*stack            ; Save return address
0024 2A74 0649  14         dect  stack
0025 2A76 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A78 0649  14         dect  stack
0027 2A7A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A7C 0649  14         dect  stack
0029 2A7E C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A80 0649  14         dect  stack
0031 2A82 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A84 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A86 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A88 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A8A 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A8C 0649  14         dect  stack
0044 2A8E C64B  30         mov   r11,*stack            ; Save return address
0045 2A90 0649  14         dect  stack
0046 2A92 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A94 0649  14         dect  stack
0048 2A96 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A98 0649  14         dect  stack
0050 2A9A C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A9C 0649  14         dect  stack
0052 2A9E C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2AA0 C1D4  26 !       mov   *tmp0,tmp3
0057 2AA2 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2AA4 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2AA6 00FF 
0059 2AA8 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2AAA 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2AAC 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2AAE 0584  14         inc   tmp0                  ; Next byte
0067 2AB0 0607  14         dec   tmp3                  ; Shorten string length
0068 2AB2 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AB4 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AB6 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AB8 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2ABA 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2ABC C187  18         mov   tmp3,tmp2
0078 2ABE 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2AC0 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AC2 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2AC4 24EE 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2AC6 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2AC8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ACA FFCE 
0090 2ACC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2ACE 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AD0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AD2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AD4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2ADA 045B  20         b     *r11                  ; Return to caller
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
0123 2ADC 0649  14         dect  stack
0124 2ADE C64B  30         mov   r11,*stack            ; Save return address
0125 2AE0 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AE2 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AE4 0649  14         dect  stack
0128 2AE6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AE8 0649  14         dect  stack
0130 2AEA C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AEC 0649  14         dect  stack
0132 2AEE C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AF0 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AF2 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AF4 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AF6 0649  14         dect  stack
0144 2AF8 C64B  30         mov   r11,*stack            ; Save return address
0145 2AFA 0649  14         dect  stack
0146 2AFC C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AFE 0649  14         dect  stack
0148 2B00 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2B02 0649  14         dect  stack
0150 2B04 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2B06 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2B08 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2B0A 0586  14         inc   tmp2
0161 2B0C 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2B0E 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B10 0286  22         ci    tmp2,255
     2B12 00FF 
0167 2B14 1505  14         jgt   string.getlenc.panic
0168 2B16 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B18 0606  14         dec   tmp2                  ; One time adjustment
0174 2B1A C806  38         mov   tmp2,@waux1           ; Store length
     2B1C 833C 
0175 2B1E 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B20 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B22 FFCE 
0181 2B24 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B26 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B28 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B2A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B2C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B2E C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B30 045B  20         b     *r11                  ; Return to caller
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
0056 2B32 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B34 2B36             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B36 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B38 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B3A A428 
0064 2B3C 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B3E 201C 
0065 2B40 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B42 8356 
0066 2B44 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B46 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B48 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B4A C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B4C A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B4E 06C0  14         swpb  r0                    ;
0075 2B50 D800  38         movb  r0,@vdpa              ; Send low byte
     2B52 8C02 
0076 2B54 06C0  14         swpb  r0                    ;
0077 2B56 D800  38         movb  r0,@vdpa              ; Send high byte
     2B58 8C02 
0078 2B5A D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B5C 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B5E 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B60 0704  14         seto  r4                    ; Init counter
0086 2B62 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B64 A420 
0087 2B66 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B68 0584  14         inc   r4                    ; Increment char counter
0089 2B6A 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B6C 0007 
0090 2B6E 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B70 80C4  18         c     r4,r3                 ; End of name?
0093 2B72 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B74 06C0  14         swpb  r0                    ;
0098 2B76 D800  38         movb  r0,@vdpa              ; Send low byte
     2B78 8C02 
0099 2B7A 06C0  14         swpb  r0                    ;
0100 2B7C D800  38         movb  r0,@vdpa              ; Send high byte
     2B7E 8C02 
0101 2B80 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B82 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B84 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B86 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B88 2C9E 
0109 2B8A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B8C C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B8E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B90 04E0  34         clr   @>83d0
     2B92 83D0 
0118 2B94 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B96 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B98 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B9A A432 
0121               
0122 2B9C 0584  14         inc   r4                    ; Adjust for dot
0123 2B9E A804  38         a     r4,@>8356             ; Point to position after name
     2BA0 8356 
0124 2BA2 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2BA4 8356 
     2BA6 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2BA8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2BAA 83E0 
0130 2BAC 04C1  14         clr   r1                    ; Version found of dsr
0131 2BAE 020C  20         li    r12,>0f00             ; Init cru address
     2BB0 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BB2 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BB4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BB6 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BB8 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BBA 0100 
0145 2BBC 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BBE 83D0 
0146 2BC0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BC2 2000 
0147 2BC4 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BC6 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BC8 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BCA 1D00  20         sbo   0                     ; Turn on ROM
0154 2BCC 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BCE 4000 
0155 2BD0 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BD2 2C9A 
0156 2BD4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BD6 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BD8 A40A 
0166 2BDA 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BDC C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BDE 83D2 
0172                                                   ; subprogram
0173               
0174 2BE0 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BE2 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BE4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BE6 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BE8 83D2 
0183                                                   ; subprogram
0184               
0185 2BEA 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BEC C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BEE 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BF0 D160  34         movb  @>8355,r5             ; Get length as counter
     2BF2 8355 
0195 2BF4 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BF6 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BF8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BFA 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BFC 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BFE A420 
0206 2C00 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2C02 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2C04 0605  14         dec   r5                    ; Update loop counter
0211 2C06 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2C08 0581  14         inc   r1                    ; Next version found
0217 2C0A C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2C0C A42A 
0218 2C0E C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C10 A42C 
0219 2C12 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C14 A430 
0220               
0221 2C16 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C18 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C1A 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C1C 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C1E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C20 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C22 A400 
0233 2C24 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C26 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C28 A428 
0239                                                   ; (8 or >a)
0240 2C2A 0281  22         ci    r1,8                  ; was it 8?
     2C2C 0008 
0241 2C2E 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C30 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C32 8350 
0243                                                   ; Get error byte from @>8350
0244 2C34 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C36 06C0  14         swpb  r0                    ;
0252 2C38 D800  38         movb  r0,@vdpa              ; send low byte
     2C3A 8C02 
0253 2C3C 06C0  14         swpb  r0                    ;
0254 2C3E D800  38         movb  r0,@vdpa              ; send high byte
     2C40 8C02 
0255 2C42 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C44 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C46 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C48 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C4A 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C4C 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C4E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C50 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C52 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C54 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C56 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C58 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C5A 201C 
0281                                                   ; / to indicate error
0282 2C5C 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C5E A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C60 2C62             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C62 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C64 83E0 
0316               
0317 2C66 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C68 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C6A 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C6C A42A 
0322 2C6E C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C70 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C72 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C74 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C76 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C78 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C7A 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C7C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C7E 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C80 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C82 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C84 4000 
     2C86 2C9A 
0337 2C88 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C8A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C8C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C8E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C90 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C92 A400 
0355 2C94 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C96 A434 
0356               
0357 2C98 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C9A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C9C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C9E ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2CA0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2CA2 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2CA4 0649  14         dect  stack
0052 2CA6 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2CA8 0204  20         li    tmp0,dsrlnk.savcru
     2CAA A42A 
0057 2CAC 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2CAE 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CB0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CB2 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CB4 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CB6 37D7 
0065 2CB8 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CBA 8370 
0066                                                   ; / location
0067 2CBC C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CBE A44C 
0068 2CC0 04C5  14         clr   tmp1                  ; io.op.open
0069 2CC2 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2CC4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CC6 0649  14         dect  stack
0097 2CC8 C64B  30         mov   r11,*stack            ; Save return address
0098 2CCA 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CCC 0001 
0099 2CCE 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2CD0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CD2 0649  14         dect  stack
0125 2CD4 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CD6 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CD8 0002 
0128 2CDA 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2CDC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CDE 0649  14         dect  stack
0155 2CE0 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CE2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CE4 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CE6 0005 
0159               
0160 2CE8 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CEA A43E 
0161               
0162 2CEC 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CEE 22DA 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CF0 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CF2 0003 
0167 2CF4 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CF6 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CF8 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CFA 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CFC 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CFE 1000  14         nop
0189               
0190               
0191               file.status:
0192 2D00 1000  14         nop
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
0227 2D02 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2D04 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2D06 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2D08 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2D0A A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2D0C 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D0E 22DA 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D10 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D12 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D14 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D16 A44C 
0246               
0247 2D18 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D1A 22DA 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D1C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D1E 0009 
0254 2D20 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D22 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D24 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D26 8322 
     2D28 833C 
0259               
0260 2D2A C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D2C A42A 
0261 2D2E 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D30 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D32 2B32 
0268 2D34 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D36 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D38 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D3A 2C5E 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D3C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D3E C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D40 833C 
     2D42 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D44 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D46 A436 
0292 2D48 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D4A 0005 
0293 2D4C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D4E 22F2 
0294 2D50 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D52 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D54 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D56 045B  20         b     *r11                  ; Return to caller
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
0020 2D58 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D5A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D5C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D5E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D60 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D62 201C 
0029 2D64 1602  14         jne   tmgr1a                ; No, so move on
0030 2D66 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D68 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D6A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D6C 2020 
0035 2D6E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D70 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D72 2010 
0048 2D74 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D76 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D78 200E 
0050 2D7A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D7C 0460  28         b     @kthread              ; Run kernel thread
     2D7E 2DF6 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D80 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D82 2014 
0056 2D84 13EB  14         jeq   tmgr1
0057 2D86 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D88 2012 
0058 2D8A 16E8  14         jne   tmgr1
0059 2D8C C120  34         mov   @wtiusr,tmp0
     2D8E 832E 
0060 2D90 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D92 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D94 2DF4 
0065 2D96 C10A  18         mov   r10,tmp0
0066 2D98 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D9A 00FF 
0067 2D9C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D9E 201C 
0068 2DA0 1303  14         jeq   tmgr5
0069 2DA2 0284  22         ci    tmp0,60               ; 1 second reached ?
     2DA4 003C 
0070 2DA6 1002  14         jmp   tmgr6
0071 2DA8 0284  22 tmgr5   ci    tmp0,50
     2DAA 0032 
0072 2DAC 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2DAE 1001  14         jmp   tmgr8
0074 2DB0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DB2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DB4 832C 
0079 2DB6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DB8 FF00 
0080 2DBA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DBC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DBE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DC0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DC2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DC4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DC6 830C 
     2DC8 830D 
0089 2DCA 1608  14         jne   tmgr10                ; No, get next slot
0090 2DCC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DCE FF00 
0091 2DD0 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DD2 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DD4 8330 
0096 2DD6 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DD8 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DDA 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DDC 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DDE 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DE0 8315 
     2DE2 8314 
0103 2DE4 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DE6 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DE8 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DEA 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DEC 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DEE 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DF0 FF00 
0109 2DF2 10B4  14         jmp   tmgr1
0110 2DF4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DF6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DF8 2010 
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
0041 2DFA 06A0  32         bl    @realkb               ; Scan full keyboard
     2DFC 27FE 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DFE 0460  28         b     @tmgr3                ; Exit
     2E00 2D80 
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
0017 2E02 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2E04 832E 
0018 2E06 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2E08 2012 
0019 2E0A 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D5C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2E0C 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E0E 832E 
0029 2E10 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E12 FEFF 
0030 2E14 045B  20         b     *r11                  ; Return
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
0017 2E16 C13B  30 mkslot  mov   *r11+,tmp0
0018 2E18 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E1A C184  18         mov   tmp0,tmp2
0023 2E1C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E1E A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E20 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E22 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E24 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E26 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E28 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E2A 2022 
0035 2E2C 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E2E 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E30 05CB  14 mkslo1  inct  r11
0041 2E32 045B  20         b     *r11                  ; Exit
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
0052 2E34 C13B  30 clslot  mov   *r11+,tmp0
0053 2E36 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E38 A120  34         a     @wtitab,tmp0          ; Add table base
     2E3A 832C 
0055 2E3C 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E3E 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E40 045B  20         b     *r11                  ; Exit
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
0068 2E42 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E44 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E46 A120  34         a     @wtitab,tmp0          ; Add table base
     2E48 832C 
0071 2E4A 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E4C C154  26         mov   *tmp0,tmp1
0073 2E4E 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E50 FF00 
0074 2E52 C505  30         mov   tmp1,*tmp0
0075 2E54 045B  20         b     *r11                  ; Exit
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
0261 2E56 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E58 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 2E5A 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E5C 0000 
0267 2E5E 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E60 8300 
0268 2E62 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E64 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 2E66 0202  20 runli2  li    r2,>8308
     2E68 8308 
0273 2E6A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 2E6C 0282  22         ci    r2,>8400
     2E6E 8400 
0275 2E70 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 2E72 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E74 FFFF 
0280 2E76 1602  14         jne   runli4                ; No, continue
0281 2E78 0420  54         blwp  @0                    ; Yes, bye bye
     2E7A 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 2E7C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E7E 833C 
0286 2E80 04C1  14         clr   r1                    ; Reset counter
0287 2E82 0202  20         li    r2,10                 ; We test 10 times
     2E84 000A 
0288 2E86 C0E0  34 runli5  mov   @vdps,r3
     2E88 8802 
0289 2E8A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E8C 2020 
0290 2E8E 1302  14         jeq   runli6
0291 2E90 0581  14         inc   r1                    ; Increase counter
0292 2E92 10F9  14         jmp   runli5
0293 2E94 0602  14 runli6  dec   r2                    ; Next test
0294 2E96 16F7  14         jne   runli5
0295 2E98 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E9A 1250 
0296 2E9C 1202  14         jle   runli7                ; No, so it must be NTSC
0297 2E9E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2EA0 201C 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 2EA2 06A0  32 runli7  bl    @loadmc
     2EA4 2228 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 2EA6 04C1  14 runli9  clr   r1
0306 2EA8 04C2  14         clr   r2
0307 2EAA 04C3  14         clr   r3
0308 2EAC 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2EAE 3000 
0309 2EB0 020F  20         li    r15,vdpw              ; Set VDP write address
     2EB2 8C00 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 2EB4 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EB6 4A4A 
0318 2EB8 1605  14         jne   runlia
0319 2EBA 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EBC 229C 
0320 2EBE 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EC0 0000 
     2EC2 3000 
0325 2EC4 06A0  32 runlia  bl    @filv
     2EC6 229C 
0326 2EC8 0FC0             data  pctadr,spfclr,16      ; Load color table
     2ECA 00F4 
     2ECC 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 2ECE 06A0  32         bl    @f18unl               ; Unlock the F18A
     2ED0 2740 
0334 2ED2 06A0  32         bl    @f18chk               ; Check if F18A is there
     2ED4 2760 
0335 2ED6 06A0  32         bl    @f18lck               ; Lock the F18A again
     2ED8 2756 
0336               
0337 2EDA 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2EDC 2340 
0338 2EDE 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 2EE0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2EE2 2306 
0352 2EE4 33B0             data  spvmod                ; Equate selected video mode table
0353 2EE6 0204  20         li    tmp0,spfont           ; Get font option
     2EE8 000C 
0354 2EEA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 2EEC 1304  14         jeq   runlid                ; Yes, skip it
0356 2EEE 06A0  32         bl    @ldfnt
     2EF0 236E 
0357 2EF2 1100             data  fntadr,spfont         ; Load specified font
     2EF4 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 2EF6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EF8 4A4A 
0362 2EFA 1602  14         jne   runlie                ; No, continue
0363 2EFC 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EFE 2086 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 2F00 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2F02 0040 
0368 2F04 0460  28         b     @main                 ; Give control to main program
     2F06 6046 
**** **** ****     > stevie_b1.asm.1406079
0041                                                   ; Relocated spectra2 in low MEMEXP, was
0042                                                   ; copied to >2000 from ROM in bank 0
0043                       ;------------------------------------------------------
0044                       ; End of File marker
0045                       ;------------------------------------------------------
0046 2F08 DEAD             data >dead,>beef,>dead,>beef
     2F0A BEEF 
     2F0C DEAD 
     2F0E BEEF 
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
     30EA 2244 
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
     3124 2244 
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
     315A 2584 
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
     3194 2584 
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
     31E4 2584 
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
     3224 353A 
0043 3226 C804  38         mov   tmp0,@edb.filename.ptr
     3228 A212 
0044               
0045 322A 0204  20         li    tmp0,txt.filetype.none
     322C 35F2 
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
     3266 2244 
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
     3282 2244 
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
     32D0 27D6 
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
     32EA 29E8 
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
     32FE 2A40 
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
     3340 24EE 
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
     3386 27AA 
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
     3396 25F0 
0023 3398 33C8                   data mem.sams.layout.data
0024               
0025 339A 06A0  32         bl    @sams.layout.copy
     339C 2654 
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
0017 3458 4C42             byte  76
0018 3459 ....             text  'Build: 210829-1406079 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 34A6 012C             byte  1
0024 34A7 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 34A8 0520             byte  5
0029 34A9 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 34AE 034F             byte  3
0034 34AF ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 34B2 0349             byte  3
0039 34B3 ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 34B6 012A             byte  1
0044 34B7 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34B8 0A4C             byte  10
0049 34B9 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34C4 0A53             byte  10
0054 34C5 ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34D0 1244             byte  18
0059 34D1 ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34E4 1143             byte  17
0064 34E5 ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34F6 104D             byte  16
0069 34F7 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 3508 1D53             byte  29
0074 3509 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 3526 0846             byte  8
0079 3527 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 3530 026B             byte  2
0084 3531 ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 3534 054C             byte  5
0089 3535 ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 353A 0A5B             byte  10
0094 353B ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 3546 0444             byte  4
0099 3547 ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 354C 034D             byte  3
0104 354D ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 3550 034D             byte  3
0109 3551 ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 3554 0746             byte  7
0114 3555 ....             text  'F9=Menu'
0115                       even
0116               
0117               txt.keys.block
0118 355C 3342             byte  51
0119 355D ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0120                       even
0121               
0122 3590 ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 359A ....                        text    '.........'
0125                                  byte    19
0126 35A4 ....                        text    '.........'
0127                                  byte    20
0128 35AE ....                        text    '.........'
0129                                  byte    21
0130 35B8 ....                        text    '.........'
0131                                  byte    22
0132 35C2 ....                        text    '.........'
0133                                  byte    23
0134 35CC ....                        text    '.........'
0135                                  byte    24
0136 35D6 ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139 35E0 020E     txt.alpha.down     data >020e,>0f00
     35E2 0F00 
0140 35E4 0110     txt.vertline       data >0110
0141 35E6 011C     txt.keymarker      byte 1,28
0142               
0143               txt.ws1
0144 35E8 0120             byte  1
0145 35E9 ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 35EA 0220             byte  2
0150 35EB ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 35EE 0320             byte  3
0155 35EF ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 35F2 0420             byte  4
0160 35F3 ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 35F8 0520             byte  5
0165 35F9 ....             text  '     '
0166                       even
0167               
0168      35F2     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 35FE 1301     txt.head.load      byte 19,1,3
     3600 0320 
0175 3601 ....                        text ' Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 3612 3D53             byte  61
0179 3613 ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 3650 3146     txt.keys.load      byte 49
0184 3651 ....                        text 'F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End'
0185               
0186 3682 3246     txt.keys.load2     byte 50
0187 3683 ....                        text 'F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End'
0188               
0189               ;--------------------------------------------------------------
0190               ; Dialog Save DV 80 file
0191               ;--------------------------------------------------------------
0192 36B6 0103     txt.head.save      byte 19,1,3
0193 36B8 ....                        text ' Save DV80 file '
0194 36C8 0223                        byte 2
0195 36CA 0103     txt.head.save2     byte 35,1,3,32
     36CC 2053 
0196 36CD ....                        text 'Save marked block to DV80 file '
0197 36EC 0201                        byte 2
0198               txt.hint.save
0199                       byte  1
0200 36EE ....             text  ' '
0201                       even
0202               
0203               
0204 36F0 2446     txt.keys.save      byte 36
0205 36F1 ....                        text 'F9=Back  F3=Clear  F-H=Home  F-L=End'
0206               
0207               ;--------------------------------------------------------------
0208               ; Dialog "Unsaved changes"
0209               ;--------------------------------------------------------------
0210 3716 0103     txt.head.unsaved   byte 20,1,3
0211 3718 ....                        text ' Unsaved changes '
0212                                  byte 2
0213               txt.info.unsaved
0214 372A 2157             byte  33
0215 372B ....             text  'Warning! Unsaved changes in file.'
0216                       even
0217               
0218               txt.hint.unsaved
0219 374C 2A50             byte  42
0220 374D ....             text  'Press F6 to proceed or ENTER to save file.'
0221                       even
0222               
0223               txt.keys.unsaved
0224 3778 2843             byte  40
0225 3779 ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0226                       even
0227               
0228               
0229               ;--------------------------------------------------------------
0230               ; Dialog "About"
0231               ;--------------------------------------------------------------
0232 37A2 0A01     txt.head.about     byte 10,1,3
     37A4 0320 
0233 37A5 ....                        text ' About '
0234 37AC 0200                        byte 2
0235               
0236               txt.info.about
0237                       byte  0
0238 37AE ....             text
0239                       even
0240               
0241               txt.hint.about
0242 37AE 1D50             byte  29
0243 37AF ....             text  'Press F9 to return to editor.'
0244                       even
0245               
0246 37CC 2148     txt.keys.about     byte 33
0247 37CD ....                        text 'Help: F9=Back  '
0248 37DC 0E0F                        byte 14,15
0249 37DE ....                        text '=Alpha Lock down'
0250               
0251               
0252               ;--------------------------------------------------------------
0253               ; Dialog "Menu"
0254               ;--------------------------------------------------------------
0255 37EE 1001     txt.head.menu      byte 16,1,3
     37F0 0320 
0256 37F1 ....                        text ' Stevie 1.1R '
0257 37FE 021A                        byte 2
0258               
0259               txt.info.menu
0260                       byte  26
0261 3800 ....             text  'File / Basic / Help / Quit'
0262                       even
0263               
0264 381A 0007     pos.info.menu      byte 0,7,15,22,>ff
     381C 0F16 
     381E FF28 
0265               txt.hint.menu
0266                       byte  40
0267 3820 ....             text  'Press F,B,H,Q or F9 to return to editor.'
0268                       even
0269               
0270               txt.keys.menu
0271 3848 0746             byte  7
0272 3849 ....             text  'F9=Back'
0273                       even
0274               
0275               
0276               
0277               ;--------------------------------------------------------------
0278               ; Dialog "File"
0279               ;--------------------------------------------------------------
0280 3850 0901     txt.head.file      byte 9,1,3
     3852 0320 
0281 3853 ....                        text ' File '
0282                                  byte 2
0283               
0284               txt.info.file
0285 385A 114E             byte  17
0286 385B ....             text  'New / Open / Save'
0287                       even
0288               
0289 386C 0006     pos.info.file      byte 0,6,13,>ff
     386E 0DFF 
0290               txt.hint.file
0291 3870 2650             byte  38
0292 3871 ....             text  'Press N,O,S or F9 to return to editor.'
0293                       even
0294               
0295               txt.keys.file
0296 3898 0746             byte  7
0297 3899 ....             text  'F9=Back'
0298                       even
0299               
0300               
0301               ;--------------------------------------------------------------
0302               ; Dialog "Basic"
0303               ;--------------------------------------------------------------
0304 38A0 0E01     txt.head.basic     byte 14,1,3
     38A2 0320 
0305 38A3 ....                        text ' Run basic '
0306 38AE 021C                        byte 2
0307               
0308               txt.info.basic
0309                       byte  28
0310 38B0 ....             text  'TI Basic / TI Extended Basic'
0311                       even
0312               
0313 38CC 030E     pos.info.basic     byte 3,14,>ff
     38CE FF3E 
0314               txt.hint.basic
0315                       byte  62
0316 38D0 ....             text  'Press B,E for running basic dialect or F9 to return to editor.'
0317                       even
0318               
0319               txt.keys.basic
0320 390E 0746             byte  7
0321 390F ....             text  'F9=Back'
0322                       even
0323               
0324               
0325               
0326               ;--------------------------------------------------------------
0327               ; Strings for error line pane
0328               ;--------------------------------------------------------------
0329               txt.ioerr.load
0330 3916 2049             byte  32
0331 3917 ....             text  'I/O error. Failed loading file: '
0332                       even
0333               
0334               txt.ioerr.save
0335 3938 2049             byte  32
0336 3939 ....             text  'I/O error. Failed saving file:  '
0337                       even
0338               
0339               txt.memfull.load
0340 395A 4049             byte  64
0341 395B ....             text  'Index memory full. Could not fully load file into editor buffer.'
0342                       even
0343               
0344               txt.io.nofile
0345 399C 2149             byte  33
0346 399D ....             text  'I/O error. No filename specified.'
0347                       even
0348               
0349               txt.block.inside
0350 39BE 3445             byte  52
0351 39BF ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0352                       even
0353               
0354               
0355               ;--------------------------------------------------------------
0356               ; Strings for command buffer
0357               ;--------------------------------------------------------------
0358               txt.cmdb.prompt
0359 39F4 013E             byte  1
0360 39F5 ....             text  '>'
0361                       even
0362               
0363               txt.colorscheme
0364 39F6 0D43             byte  13
0365 39F7 ....             text  'Color scheme:'
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
0022 3A04 DEAD             data  >dead,>beef,>dead,>beef
     3A06 BEEF 
     3A08 DEAD 
     3A0A BEEF 
**** **** ****     > stevie_b1.asm.1406079
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
**** **** ****     > stevie_b1.asm.1406079
0072                                                   ; Spectra 2 extended
0073               
0074               ***************************************************************
0075               * Step 5: Include main editor modules
0076               ********|*****|*********************|**************************
0077               main:
0078                       aorg  kickstart.code2       ; >6046
0079 6046 0460  28         b     @main.stevie          ; Start editor
     6048 604A 
0080                       ;-----------------------------------------------------------------------
0081                       ; Include files
0082                       ;-----------------------------------------------------------------------
0083                       copy  "main.asm"            ; Main file (entrypoint)
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
0036 6054 06A0  32         bl    @scroff               ; Turn screen off
     6056 269C 
0037               
0038 6058 06A0  32         bl    @f18unl               ; Unlock the F18a
     605A 2740 
0039               
0041               
0042 605C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     605E 2340 
0043 6060 3140                   data >3140            ; F18a VR49 (>31), bit 40
0044               
0046               
0047 6062 06A0  32         bl    @putvr                ; Turn on position based attributes
     6064 2340 
0048 6066 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6068 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     606A 2340 
0051 606C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 606E 06A0  32         bl    @filv
     6070 229C 
0056 6072 0000                   data >0000,32,vdp.sit.size
     6074 0020 
     6076 0960 
0057                                                   ; Clear screen
0058                       ;------------------------------------------------------
0059                       ; Initialize high memory expansion
0060                       ;------------------------------------------------------
0061 6078 06A0  32         bl    @film
     607A 2244 
0062 607C A000                   data >a000,00,20000   ; Clear a000-eedf
     607E 0000 
     6080 4E20 
0063                       ;------------------------------------------------------
0064                       ; Setup SAMS windows
0065                       ;------------------------------------------------------
0066 6082 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6084 3390 
0067                       ;------------------------------------------------------
0068                       ; Setup cursor, screen, etc.
0069                       ;------------------------------------------------------
0070 6086 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6088 26BC 
0071 608A 06A0  32         bl    @s8x8                 ; Small sprite
     608C 26CC 
0072               
0073 608E 06A0  32         bl    @cpym2m
     6090 24E8 
0074 6092 33BA                   data romsat,ramsat,14 ; Load sprite SAT
     6094 2F5A 
     6096 000E 
0075               
0076 6098 C820  54         mov   @romsat+2,@tv.curshape
     609A 33BC 
     609C A014 
0077                                                   ; Save cursor shape & color
0078               
0079 609E 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     60A0 7D36 
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 3290 
0084 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 32B6 
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 76F4 
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
     60B8 26DC 
0097 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0098               
0099 60BC 0204  20         li    tmp0,timers
     60BE 2F4A 
0100 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0101               
0103               
0104 60C4 06A0  32         bl    @mkslot
     60C6 2E16 
0105 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 74AA 
0106 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60CE 7536 
0107 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D2 75D2 
0108 60D4 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D6 7600 
0109 60D8 FFFF                   data eol
0110               
0120               
0121               
0122 60DA 06A0  32         bl    @mkhook
     60DC 2E02 
0123 60DE 7454                   data hook.keyscan     ; Setup user hook
0124               
0125 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D58 
**** **** ****     > stevie_b1.asm.1406079
0084                       ;-----------------------------------------------------------------------
0085                       ; Keyboard actions
0086                       ;-----------------------------------------------------------------------
0087                       copy  "edkey.key.process.asm"
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
     610C 7E9C 
0033 610E 1002  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6110 0206  20         li    tmp2,keymap_actions.cmdb
     6112 7F36 
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
     616E 65F2 
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
     6182 680A 
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
     618E 749E 
**** **** ****     > stevie_b1.asm.1406079
0088                                                   ; Process keyboard actions
0089                       ;-----------------------------------------------------------------------
0090                       ; Keyboard actions - Framebuffer (1)
0091                       ;-----------------------------------------------------------------------
0092                       copy  "edkey.fb.mov.leftright.asm"
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
     61A8 749E 
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
     61C4 749E 
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61C6 06A0  32         bl    @fb.cursor.home       ; Move cursor to beginning of line
     61C8 6A90 
0047                       ;-------------------------------------------------------
0048                       ; Exit
0049                       ;-------------------------------------------------------
0050 61CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61CC 749E 
0051               
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.end:
0057 61CE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61D0 A118 
0058 61D2 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61D4 A108 
0059 61D6 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61D8 0050 
0060 61DA 1102  14         jlt   !                     ; | is right of last character on line,
0061 61DC 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61DE 004F 
0062                       ;-------------------------------------------------------
0063                       ; Set cursor X position
0064                       ;-------------------------------------------------------
0065 61E0 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61E2 A10C 
0066 61E4 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61E6 26F4 
0067 61E8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61EA 6992 
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071 61EC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61EE 749E 
**** **** ****     > stevie_b1.asm.1406079
0093                                                        ; Move left / right / home / end
0094                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61F0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61F2 A118 
0009 61F4 C120  34         mov   @fb.column,tmp0
     61F6 A10C 
0010 61F8 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61FA C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61FC A102 
0015 61FE 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 6200 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 6202 0605  14         dec   tmp1
0022 6204 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 6206 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 6208 D195  26         movb  *tmp1,tmp2            ; Get character
0030 620A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 620C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 620E 0986  56         srl   tmp2,8                ; Right justify
0033 6210 0286  22         ci    tmp2,32               ; Space character found?
     6212 0020 
0034 6214 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 6216 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6218 2020 
0040 621A 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 621C 0287  22         ci    tmp3,>20ff            ; First character is space
     621E 20FF 
0043 6220 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 6222 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6224 A10C 
0048 6226 61C4  18         s     tmp0,tmp3
0049 6228 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     622A 0002 
0050 622C 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 622E 0585  14         inc   tmp1
0056 6230 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 6232 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6234 A10C 
0062 6236 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6238 26F4 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 623A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     623C 6992 
0068 623E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6240 749E 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 6242 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6244 A118 
0077 6246 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 6248 C120  34         mov   @fb.column,tmp0
     624A A10C 
0079 624C 8804  38         c     tmp0,@fb.row.length
     624E A108 
0080 6250 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 6252 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6254 A102 
0085 6256 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6258 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 625A 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 625C 0585  14         inc   tmp1
0097 625E 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6260 8804  38         c     tmp0,@fb.row.length
     6262 A108 
0099 6264 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6266 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6268 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 626A D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 626C 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 626E 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6270 FFFF 
0111 6272 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 6274 0286  22         ci    tmp2,32
     6276 0020 
0117 6278 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 627A 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 627C 0286  22         ci    tmp2,32               ; Space character found?
     627E 0020 
0125 6280 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 6282 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6284 2020 
0131 6286 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 6288 0287  22         ci    tmp3,>20ff            ; First characer is space?
     628A 20FF 
0134 628C 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 628E 0585  14         inc   tmp1
0139 6290 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 6292 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6294 A10C 
0145 6296 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6298 26F4 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 629A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     629C 6992 
0151 629E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62A0 749E 
0152               
0153               
**** **** ****     > stevie_b1.asm.1406079
0095                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 62A2 06A0  32         bl    @fb.cursor.up         ; Move cursor up
     62A4 69BA 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.up.exit:
0013 62A6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62A8 749E 
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Cursor down
0019               *---------------------------------------------------------------
0020               edkey.action.down:
0021 62AA 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     62AC 6A18 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.down.exit:
0026 62AE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62B0 749E 
**** **** ****     > stevie_b1.asm.1406079
0096                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 62B2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62B4 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 62B6 8820  54         c     @fb.row.dirty,@w$ffff
     62B8 A10A 
     62BA 2022 
0013 62BC 1604  14         jne   edkey.action.ppage.sanity
0014 62BE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62C0 6E5E 
0015 62C2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62C4 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 62C6 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     62C8 A104 
0021 62CA 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 62CC 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     62CE A11A 
0026 62D0 1503  14         jgt   edkey.action.ppage.topline
0027 62D2 04E0  34         clr   @fb.topline           ; topline = 0
     62D4 A104 
0028 62D6 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 62D8 6820  54         s     @fb.scrrows,@fb.topline
     62DA A11A 
     62DC A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 62DE C820  54         mov   @fb.topline,@parm1
     62E0 A104 
     62E2 2F20 
0039 62E4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62E6 A110 
0040               
0041 62E8 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 62EA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62EC 749E 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 62EE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62F0 A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 62F2 8820  54         c     @fb.row.dirty,@w$ffff
     62F4 A10A 
     62F6 2022 
0061 62F8 1604  14         jne   edkey.action.npage.sanity
0062 62FA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62FC 6E5E 
0063 62FE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6300 A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 6302 C120  34         mov   @fb.topline,tmp0
     6304 A104 
0069 6306 A120  34         a     @fb.scrrows,tmp0
     6308 A11A 
0070 630A 0584  14         inc   tmp0                  ; Base 1 offset !
0071 630C 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     630E A204 
0072 6310 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 6312 A820  54         a     @fb.scrrows,@fb.topline
     6314 A11A 
     6316 A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 6318 C820  54         mov   @fb.topline,@parm1
     631A A104 
     631C 2F20 
0083 631E 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6320 A110 
0084               
0085 6322 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 6324 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6326 749E 
**** **** ****     > stevie_b1.asm.1406079
0097                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
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
0011 6328 8820  54         c     @fb.row.dirty,@w$ffff
     632A A10A 
     632C 2022 
0012 632E 1604  14         jne   edkey.action.top.refresh
0013 6330 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6332 6E5E 
0014 6334 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6336 A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 6338 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     633A 2F20 
0020 633C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     633E A110 
0021               
0022 6340 0460  28         b     @ _edkey.goto.fb.toprow
     6342 6374 
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
0035 6344 8820  54         c     @fb.row.dirty,@w$ffff
     6346 A10A 
     6348 2022 
0036 634A 1604  14         jne   edkey.action.bot.refresh
0037 634C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     634E 6E5E 
0038 6350 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6352 A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 6354 8820  54         c     @edb.lines,@fb.scrrows
     6356 A204 
     6358 A11A 
0044 635A 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 635C C120  34         mov   @edb.lines,tmp0
     635E A204 
0047 6360 6120  34         s     @fb.scrrows,tmp0
     6362 A11A 
0048 6364 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6366 2F20 
0049 6368 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     636A A110 
0050               
0051 636C 0460  28         b     @ _edkey.goto.fb.toprow
     636E 6374 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 6370 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6372 749E 
**** **** ****     > stevie_b1.asm.1406079
0098                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
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
0026 6374 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6376 A118 
0027               
0028 6378 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     637A 6B82 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 637C 04E0  34         clr   @fb.row               ; Frame buffer line 0
     637E A106 
0033 6380 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6382 A10C 
0034 6384 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     6386 832A 
0035               
0036 6388 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     638A 6992 
0037               
0038 638C 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     638E 7054 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6390 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6392 749E 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 6394 8820  54         c     @fb.row.dirty,@w$ffff
     6396 A10A 
     6398 2022 
0053 639A 1609  14         jne   edkey.action.goto.refresh
0054               
0055 639C 0649  14         dect  stack
0056 639E C660  46         mov   @parm1,*stack         ; Push parm1
     63A0 2F20 
0057 63A2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63A4 6E5E 
0058 63A6 C839  50         mov   *stack+,@parm1        ; Pop parm1
     63A8 2F20 
0059               
0060 63AA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63AC A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 63AE 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63B0 A110 
0066               
0067 63B2 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     63B4 6374 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.1406079
0099                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 63B6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     63B8 A206 
0009 63BA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63BC 6992 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 63BE C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     63C0 A108 
0015 63C2 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 63C4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     63C6 A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 63C8 C1C6  18         mov   tmp2,tmp3             ; \
0024 63CA 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 63CC 81E0  34         c     @fb.column,tmp3
     63CE A10C 
0026 63D0 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 63D2 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 63D4 D505  30         movb  tmp1,*tmp0            ; /
0033 63D6 C820  54         mov   @fb.column,@fb.row.length
     63D8 A10C 
     63DA A108 
0034                                                   ; Row length - 1
0035 63DC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     63DE A10A 
0036 63E0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     63E2 A116 
0037 63E4 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 63E6 0286  22         ci    tmp2,colrow
     63E8 0050 
0043 63EA 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 63EC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     63EE FFCE 
0049 63F0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     63F2 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 63F4 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 63F6 61E0  34         s     @fb.column,tmp3
     63F8 A10C 
0056 63FA 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 63FC A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 63FE C144  18         mov   tmp0,tmp1
0059 6400 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 6402 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6404 A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 6406 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6408 A102 
0065 640A C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 640C 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 640E DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 6410 0606  14         dec   tmp2
0073 6412 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 6414 0206  20         li    tmp2,colrow
     6416 0050 
0078 6418 81A0  34         c     @fb.row.length,tmp2
     641A A108 
0079 641C 1603  14         jne   edkey.action.del_char.save
0080 641E 0604  14         dec   tmp0                  ; One time adjustment
0081 6420 04C5  14         clr   tmp1
0082 6422 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 6424 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6426 A10A 
0088 6428 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     642A A116 
0089 642C 0620  34         dec   @fb.row.length        ; @fb.row.length--
     642E A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 6430 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6432 749E 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 6434 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6436 A206 
0102 6438 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     643A 6992 
0103 643C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     643E A108 
0104 6440 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 6442 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6444 A102 
0110 6446 C1A0  34         mov   @fb.colsline,tmp2
     6448 A10E 
0111 644A 61A0  34         s     @fb.column,tmp2
     644C A10C 
0112 644E 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 6450 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 6452 0606  14         dec   tmp2
0119 6454 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 6456 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6458 A10A 
0124 645A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     645C A116 
0125               
0126 645E C820  54         mov   @fb.column,@fb.row.length
     6460 A10C 
     6462 A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 6464 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6466 749E 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 6468 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     646A 6992 
0143 646C 04E0  34         clr   @fb.row.dirty         ; Discard current line
     646E A10A 
0144               
0145 6470 C820  54         mov   @fb.topline,@parm1    ; \
     6472 A104 
     6474 2F20 
0146 6476 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     6478 A106 
     647A 2F20 
0147 647C 05A0  34         inc   @parm1                ; /
     647E 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6480 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     6482 2F20 
     6484 A204 
0153 6486 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 6488 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     648A A104 
     648C 2F20 
0157 648E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6490 6B82 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 6492 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6494 62A2 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 6496 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6498 715A 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 649A 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     649C 2F20 
     649E A204 
0170 64A0 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 64A2 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     64A4 7054 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 64A6 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     64A8 A104 
     64AA 2F20 
0183               
0184 64AC 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     64AE 6B82 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 64B0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64B2 A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 64B4 C120  34         mov   @fb.topline,tmp0
     64B6 A104 
0193 64B8 A120  34         a     @fb.row,tmp0
     64BA A106 
0194               
0195 64BC 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64BE A204 
0196 64C0 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 64C2 0460  28         b     @edkey.action.up      ; Move cursor one line up
     64C4 62A2 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 64C6 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64C8 61C6 
**** **** ****     > stevie_b1.asm.1406079
0100                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0010 64CA 0204  20         li    tmp0,>2000            ; White space
     64CC 2000 
0011 64CE C804  38         mov   tmp0,@parm1
     64D0 2F20 
0012               edkey.action.ins_char:
0013 64D2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64D4 A206 
0014 64D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64D8 6992 
0015                       ;-------------------------------------------------------
0016                       ; Check 1 - Empty line
0017                       ;-------------------------------------------------------
0018               edkey.actions.ins.char.empty_line:
0019 64DA C120  34         mov   @fb.current,tmp0      ; Get pointer
     64DC A102 
0020 64DE C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64E0 A108 
0021 64E2 133A  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Check 2 - line-wrap if at character 80
0025                       ;-------------------------------------------------------
0026 64E4 C160  34         mov   @fb.column,tmp1
     64E6 A10C 
0027 64E8 0285  22         ci    tmp1,colrow-1         ; At 80th character?
     64EA 004F 
0028 64EC 1110  14         jlt   !
0029 64EE C160  34         mov   @fb.row.length,tmp1
     64F0 A108 
0030 64F2 0285  22         ci    tmp1,colrow
     64F4 0050 
0031 64F6 160B  14         jne   !
0032                       ;-------------------------------------------------------
0033                       ; Wrap to new line
0034                       ;-------------------------------------------------------
0035 64F8 0649  14         dect  Stack
0036 64FA C660  46         mov   @parm1,*stack         ; Save character to add
     64FC 2F20 
0037 64FE 06A0  32         bl    @fb.cursor.down       ; Move cursor down 1 line
     6500 6A18 
0038 6502 06A0  32         bl    @fb.insert.line       ; Insert empty line
     6504 6ABA 
0039 6506 C839  50         mov   *stack+,@parm1        ; Restore character to add
     6508 2F20 
0040 650A 04C6  14         clr   tmp2                  ; Clear line length
0041 650C 1025  14         jmp   edkey.action.ins_char.append
0042                       ;-------------------------------------------------------
0043                       ; Check 3 - EOL
0044                       ;-------------------------------------------------------
0045 650E 8820  54 !       c     @fb.column,@fb.row.length
     6510 A10C 
     6512 A108 
0046 6514 1321  14         jeq   edkey.action.ins_char.append
0047                                                   ; Add character in append mode
0048                       ;-------------------------------------------------------
0049                       ; Check 4 - Insert only until line length reaches 80th column
0050                       ;-------------------------------------------------------
0051 6516 C160  34         mov   @fb.row.length,tmp1
     6518 A108 
0052 651A 0285  22         ci    tmp1,colrow
     651C 0050 
0053 651E 1101  14         jlt   edkey.action.ins_char.prep
0054 6520 101D  14         jmp   edkey.action.ins_char.exit
0055                       ;-------------------------------------------------------
0056                       ; Calculate number of characters to move
0057                       ;-------------------------------------------------------
0058               edkey.action.ins_char.prep:
0059 6522 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0060 6524 61E0  34         s     @fb.column,tmp3
     6526 A10C 
0061 6528 0607  14         dec   tmp3                  ; Remove base 1 offset
0062 652A A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0063 652C C144  18         mov   tmp0,tmp1
0064 652E 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0065 6530 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6532 A10C 
0066                       ;-------------------------------------------------------
0067                       ; Loop from end of line until current character
0068                       ;-------------------------------------------------------
0069               edkey.action.ins_char.loop:
0070 6534 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0071 6536 0604  14         dec   tmp0
0072 6538 0605  14         dec   tmp1
0073 653A 0606  14         dec   tmp2
0074 653C 16FB  14         jne   edkey.action.ins_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Insert specified character at current position
0077                       ;-------------------------------------------------------
0078 653E D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     6540 2F20 
0079                       ;-------------------------------------------------------
0080                       ; Save variables and exit
0081                       ;-------------------------------------------------------
0082 6542 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6544 A10A 
0083 6546 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6548 A116 
0084 654A 05A0  34         inc   @fb.column
     654C A10C 
0085 654E 05A0  34         inc   @wyx
     6550 832A 
0086 6552 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6554 A108 
0087 6556 1002  14         jmp   edkey.action.ins_char.exit
0088                       ;-------------------------------------------------------
0089                       ; Add character in append mode
0090                       ;-------------------------------------------------------
0091               edkey.action.ins_char.append:
0092 6558 0460  28         b     @edkey.action.char.overwrite
     655A 6618 
0093                       ;-------------------------------------------------------
0094                       ; Exit
0095                       ;-------------------------------------------------------
0096               edkey.action.ins_char.exit:
0097 655C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     655E 749E 
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
0108 6560 06A0  32         bl    @fb.insert.line       ; Insert new line
     6562 6ABA 
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.ins_line.exit:
0113 6564 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6566 749E 
**** **** ****     > stevie_b1.asm.1406079
0101                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 6568 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     656A A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 656C 8820  54         c     @fb.row.dirty,@w$ffff
     656E A10A 
     6570 2022 
0013 6572 1606  14         jne   edkey.action.enter.upd_counter
0014 6574 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6576 A206 
0015 6578 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     657A 6E5E 
0016 657C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     657E A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6580 C120  34         mov   @fb.topline,tmp0
     6582 A104 
0022 6584 A120  34         a     @fb.row,tmp0
     6586 A106 
0023 6588 0584  14         inc   tmp0
0024 658A 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     658C A204 
0025 658E 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6590 05A0  34         inc   @edb.lines            ; Total lines++
     6592 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6594 C120  34         mov   @fb.scrrows,tmp0
     6596 A11A 
0035 6598 0604  14         dec   tmp0
0036 659A 8120  34         c     @fb.row,tmp0
     659C A106 
0037 659E 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 65A0 C120  34         mov   @fb.scrrows,tmp0
     65A2 A11A 
0042 65A4 C820  54         mov   @fb.topline,@parm1
     65A6 A104 
     65A8 2F20 
0043 65AA 05A0  34         inc   @parm1
     65AC 2F20 
0044 65AE 06A0  32         bl    @fb.refresh
     65B0 6B82 
0045 65B2 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     65B4 A110 
0046 65B6 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 65B8 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65BA A106 
0052 65BC 06A0  32         bl    @down                 ; Row++ VDP cursor
     65BE 26E2 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 65C0 06A0  32         bl    @fb.get.firstnonblank
     65C2 6B3A 
0058 65C4 C120  34         mov   @outparm1,tmp0
     65C6 2F30 
0059 65C8 C804  38         mov   tmp0,@fb.column
     65CA A10C 
0060 65CC 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65CE 26F4 
0061 65D0 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65D2 7054 
0062 65D4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65D6 6992 
0063 65D8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65DA A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 65DC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65DE 749E 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 65E0 0649  14         dect  stack
0078 65E2 C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 65E4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65E6 A118 
0081 65E8 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65EA A20A 
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 65EC C2F9  30         mov   *stack+,r11           ; Pop r11
0087 65EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65F0 749E 
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 65F2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     65F4 A118 
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 65F6 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 65F8 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 65FA 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     65FC 0020 
0103 65FE 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 6600 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6602 007E 
0107 6604 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 6606 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6608 A206 
0113 660A D805  38         movb  tmp1,@parm1           ; Store character for insert
     660C 2F20 
0114 660E C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6610 A20A 
0115 6612 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 6614 0460  28         b     @edkey.action.ins_char
     6616 64D2 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6618 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     661A 6992 
0126 661C C120  34         mov   @fb.current,tmp0      ; Get pointer
     661E A102 
0127               
0128 6620 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6622 2F20 
0129 6624 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6626 A10A 
0130 6628 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     662A A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 662C C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     662E A10C 
0135 6630 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     6632 004F 
0136 6634 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 6636 0205  20         li    tmp1,colrow           ; \
     6638 0050 
0140 663A C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     663C A108 
0141 663E 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 6640 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6642 A10C 
0147 6644 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6646 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 6648 8820  54         c     @fb.column,@fb.row.length
     664A A10C 
     664C A108 
0152                                                   ; column < line length ?
0153 664E 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 6650 C820  54         mov   @fb.column,@fb.row.length
     6652 A10C 
     6654 A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 6656 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6658 749E 
**** **** ****     > stevie_b1.asm.1406079
0102                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 665A C120  34         mov   @edb.dirty,tmp0
     665C A206 
0012 665E 1302  14         jeq   !
0013 6660 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6662 7DC2 
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 6664 0460  28 !       b     @tv.quit
     6666 3384 
0018               
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Toggle ruler on/off
0023               ********|*****|*********************|**************************
0024               edkey.action.toggle.ruler:
0025 6668 0649  14         dect  stack
0026 666A C644  30         mov   tmp0,*stack           ; Push tmp0
0027 666C 0649  14         dect  stack
0028 666E C660  46         mov   @wyx,*stack           ; Push cursor YX
     6670 832A 
0029                       ;-------------------------------------------------------
0030                       ; Toggle ruler visibility
0031                       ;-------------------------------------------------------
0032 6672 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     6674 A116 
0033 6676 0560  34         inv   @tv.ruler.visible     ; Toggle ruler visibility
     6678 A010 
0034 667A 1302  14         jeq   edkey.action.toggle.ruler.fb
0035 667C 06A0  32         bl    @fb.ruler.init        ; Setup ruler in ram
     667E 7E42 
0036                       ;-------------------------------------------------------
0037                       ; Update framebuffer pane
0038                       ;-------------------------------------------------------
0039               edkey.action.toggle.ruler.fb:
0040 6680 06A0  32         bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
     6682 7958 
0041 6684 C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     6686 832A 
0042 6688 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.toggle.ruler.exit:
0047 668A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     668C 749E 
**** **** ****     > stevie_b1.asm.1406079
0103                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 668E C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6690 A444 
     6692 2F20 
0018 6694 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6696 2F22 
0019 6698 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 669A C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     669C A444 
     669E 2F20 
0023 66A0 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     66A2 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 66A4 C120  34         mov   @parm1,tmp0
     66A6 2F20 
0030 66A8 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 66AA C120  34         mov   @edb.dirty,tmp0
     66AC A206 
0036 66AE 1302  14         jeq   !
0037 66B0 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66B2 7DC2 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 66B4 06A0  32 !       bl    @fm.browse.fname.suffix
     66B6 7D80 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 66B8 0204  20         li    tmp0,heap.top         ; 1st line in heap
     66BA E000 
0047 66BC 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     66BE 7D48 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 66C0 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66C2 6328 
**** **** ****     > stevie_b1.asm.1406079
0104                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 66C4 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     66C6 71EA 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 66C8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66CA 749E 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 66CC 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     66CE 7212 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 66D0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D2 749E 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 66D4 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     66D6 723A 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 66D8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66DA 749E 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 66DC 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     66DE 7BB6 
0043 66E0 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     66E2 7276 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 66E4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66E6 749E 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 66E8 0649  14         dect  stack
0055 66EA C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 66EC 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     66EE A20E 
     66F0 2022 
0060 66F2 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 66F4 C120  34         mov   @wyx,tmp0             ; Get cursor position
     66F6 832A 
0066 66F8 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     66FA FF00 
0067 66FC C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     66FE A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 6700 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     6702 7BB6 
0072               
0073 6704 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     6706 2F20 
0074 6708 06A0  32         bl    @edb.block.copy       ; Copy code block
     670A 72BC 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 670C 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     670E 2F30 
     6710 2000 
0079 6712 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6714 C820  54         mov   @fb.yxsave,@parm1
     6716 A114 
     6718 2F20 
0083 671A 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     671C 6BF2 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 671E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6720 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6722 749E 
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
0103 6724 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6726 A20E 
     6728 2022 
0104 672A 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 672C 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     672E 7BB6 
0110               
0111 6730 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     6732 2F20 
0112 6734 06A0  32         bl    @edb.block.delete     ; Delete code block
     6736 73B2 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 6738 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     673A 2F30 
     673C 2000 
0119 673E 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 6740 C820  54         mov   @fb.topline,@parm1
     6742 A104 
     6744 2F20 
0123 6746 0460  28         b     @_edkey.goto.fb.toprow
     6748 6374 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 674A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     674C 749E 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 674E 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6750 A20E 
     6752 2022 
0142 6754 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 6756 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6758 7BB6 
0148               
0149 675A 0720  34         seto  @parm1                ; Set message to "Moving block..."
     675C 2F20 
0150 675E 06A0  32         bl    @edb.block.copy       ; Copy code block
     6760 72BC 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6762 0720  34         seto  @parm1                ; Don't display delete message
     6764 2F20 
0155 6766 06A0  32         bl    @edb.block.delete     ; Delete code block
     6768 73B2 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 676A 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     676C 2F30 
     676E 2000 
0162 6770 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6772 C820  54         mov   @fb.topline,@parm1
     6774 A104 
     6776 2F20 
0166 6778 0460  28         b     @_edkey.goto.fb.toprow
     677A 6374 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 677C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     677E 749E 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 6780 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6782 A20C 
     6784 2022 
0182 6786 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 6788 C820  54         mov   @edb.block.m1,@parm1
     678A A20C 
     678C 2F20 
0188 678E 0620  34         dec   @parm1                ; Base 0 offset
     6790 2F20 
0189               
0190 6792 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6794 6394 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 6796 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6798 749E 
**** **** ****     > stevie_b1.asm.1406079
0105                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
**** **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 679A 0649  14         dect  stack
0009 679C C64B  30         mov   r11,*stack            ; Save return address
0010 679E 06A0  32         bl    @fb.tab.next          ; Jump to next tab position on line
     67A0 7E30 
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 67A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 67A4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67A6 749E 
**** **** ****     > stevie_b1.asm.1406079
0106                       ;-----------------------------------------------------------------------
0107                       ; Keyboard actions - Command Buffer
0108                       ;-----------------------------------------------------------------------
0109                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 67A8 C120  34         mov   @cmdb.column,tmp0
     67AA A312 
0009 67AC 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 67AE 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     67B0 A312 
0014 67B2 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     67B4 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 67B6 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     67B8 749E 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 67BA 06A0  32         bl    @cmdb.cmd.getlength
     67BC 7E1C 
0026 67BE 8820  54         c     @cmdb.column,@outparm1
     67C0 A312 
     67C2 2F30 
0027 67C4 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 67C6 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     67C8 A312 
0032 67CA 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     67CC A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 67CE 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     67D0 749E 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 67D2 04C4  14         clr   tmp0
0045 67D4 C804  38         mov   tmp0,@cmdb.column      ; First column
     67D6 A312 
0046 67D8 0584  14         inc   tmp0
0047 67DA D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     67DC A30A 
0048 67DE C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     67E0 A30A 
0049               
0050 67E2 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     67E4 749E 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 67E6 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     67E8 A328 
0057 67EA 0984  56         srl   tmp0,8                 ; Right justify
0058 67EC C804  38         mov   tmp0,@cmdb.column      ; Save column position
     67EE A312 
0059 67F0 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 67F2 0224  22         ai    tmp0,>1a00             ; Y=26
     67F4 1A00 
0061 67F6 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     67F8 A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 67FA 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     67FC 749E 
**** **** ****     > stevie_b1.asm.1406079
0110                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 67FE 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6800 7E12 
0026 6802 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6804 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 6806 0460  28         b     @edkey.action.cmdb.home
     6808 67D2 
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
0060 680A D105  18         movb  tmp1,tmp0             ; Get keycode
0061 680C 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 680E 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6810 0020 
0064 6812 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6814 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6816 007E 
0068 6818 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 681A 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     681C A318 
0074               
0075 681E 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6820 A329 
0076 6822 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6824 A312 
0077 6826 D505  30         movb  tmp1,*tmp0            ; Add character
0078 6828 05A0  34         inc   @cmdb.column          ; Next column
     682A A312 
0079 682C 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     682E A30A 
0080               
0081 6830 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6832 7E1C 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 6834 C120  34         mov   @outparm1,tmp0
     6836 2F30 
0088 6838 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 683A D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     683C A328 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 683E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6840 749E 
**** **** ****     > stevie_b1.asm.1406079
0111                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6842 C120  34         mov   @cmdb.visible,tmp0
     6844 A302 
0009 6846 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 6848 04E0  34         clr   @cmdb.column          ; Column = 0
     684A A312 
0015 684C 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     684E 7908 
0016 6850 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6852 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6854 7958 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6856 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6858 749E 
**** **** ****     > stevie_b1.asm.1406079
0112                       copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
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
0011 685A 0649  14         dect  stack
0012 685C C64B  30         mov   r11,*stack            ; Save return address
0013 685E 0649  14         dect  stack
0014 6860 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 6862 C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6864 A206 
0019 6866 1303  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 6868 06A0  32         bl    @dialog.unsaved       ; Show dialog
     686A 7DC2 
0022 686C 1004  14         jmp   edkey.action.cmdb.file.new.exit
0023                       ;-------------------------------------------------------
0024                       ; Reset editor
0025                       ;-------------------------------------------------------
0026 686E 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     6870 7958 
0027 6872 06A0  32         bl    @tv.reset             ; Reset editor
     6874 32B6 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.file.new.exit:
0032 6876 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0033 6878 C2F9  30         mov   *stack+,r11           ; Pop R11
0034 687A 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     687C 6328 
**** **** ****     > stevie_b1.asm.1406079
0113                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
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
0011 687E 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6880 7958 
0012               
0013 6882 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6884 7E1C 
0014 6886 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6888 2F30 
0015 688A 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 688C 06A0  32         bl    @pane.errline.show    ; Show error line
     688E 7B4E 
0020               
0021 6890 06A0  32         bl    @pane.show_hint
     6892 7682 
0022 6894 1C00                   byte pane.botrow-1,0
0023 6896 399C                   data txt.io.nofile
0024               
0025 6898 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 689A 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 689C D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     689E A328 
0031               
0032 68A0 06A0  32         bl    @cpym2m
     68A2 24E8 
0033 68A4 A328                   data cmdb.cmdlen,heap.top,80
     68A6 E000 
     68A8 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68AA 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68AC E000 
0039 68AE C804  38         mov   tmp0,@parm1
     68B0 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 68B2 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68B4 E000 
0045 68B6 C804  38         mov   tmp0,@parm1
     68B8 2F20 
0046               
0047 68BA 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     68BC 7D48 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 68BE 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     68C0 6328 
**** **** ****     > stevie_b1.asm.1406079
0114                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
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
0011 68C2 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     68C4 7958 
0012               
0013 68C6 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68C8 7E1C 
0014 68CA C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     68CC 2F30 
0015 68CE 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 68D0 06A0  32         bl    @pane.errline.show    ; Show error line
     68D2 7B4E 
0020               
0021 68D4 06A0  32         bl    @pane.show_hint
     68D6 7682 
0022 68D8 1C00                   byte pane.botrow-1,0
0023 68DA 399C                   data txt.io.nofile
0024               
0025 68DC 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 68DE 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 68E0 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68E2 A328 
0031               
0032 68E4 06A0  32         bl    @cpym2m
     68E6 24E8 
0033 68E8 A328                   data cmdb.cmdlen,heap.top,80
     68EA E000 
     68EC 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68EE 0204  20         li    tmp0,heap.top         ; 1st line in heap
     68F0 E000 
0039 68F2 C804  38         mov   tmp0,@parm1
     68F4 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 68F6 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     68F8 A20E 
     68FA 2022 
0044 68FC 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 68FE C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6900 A20C 
     6902 2F22 
0050 6904 0620  34         dec   @parm2                ; /
     6906 2F22 
0051               
0052 6908 C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     690A A20E 
     690C 2F24 
0053               
0054 690E 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 6910 04E0  34         clr   @parm2                ; First line to save
     6912 2F22 
0060 6914 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6916 A204 
     6918 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 691A 06A0  32         bl    @fm.savefile          ; Save DV80 file
     691C 7D6E 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 691E 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6920 6328 
**** **** ****     > stevie_b1.asm.1406079
0115                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0020 6922 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6924 A206 
0021 6926 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     6928 789E 
0022 692A 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     692C 7E12 
0023 692E C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6930 A326 
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6932 0284  22         ci    tmp0,>2000
     6934 2000 
0028 6936 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 6938 0284  22         ci    tmp0,>7fff
     693A 7FFF 
0031 693C 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 693E 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6940 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6942 FFCE 
0040 6944 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6946 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6948 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     694A 749E 
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
0063 694C 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     694E 7D92 
0064 6950 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6952 A318 
0065 6954 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6956 749E 
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
0086 6958 06A0  32         bl    @hchar
     695A 27D6 
0087 695C 0000                   byte 0,0,32,80*2
     695E 20A0 
0088 6960 FFFF                   data EOL
0089 6962 1000  14         jmp   edkey.action.cmdb.close.dialog
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
0108 6964 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6966 A31A 
0109 6968 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     696A 789E 
0110 696C 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     696E 7958 
0111 6970 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6972 A118 
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6974 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6976 749E 
**** **** ****     > stevie_b1.asm.1406079
0116                       ;-----------------------------------------------------------------------
0117                       ; Logic for Framebuffer (1)
0118                       ;-----------------------------------------------------------------------
0119                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 6978 0649  14         dect  stack
0025 697A C64B  30         mov   r11,*stack            ; Save return address
0026 697C 0649  14         dect  stack
0027 697E C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6980 C120  34         mov   @parm1,tmp0
     6982 2F20 
0032 6984 A120  34         a     @fb.topline,tmp0
     6986 A104 
0033 6988 C804  38         mov   tmp0,@outparm1
     698A 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 698C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 698E C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6990 045B  20         b     *r11                  ; Return to caller
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
0068 6992 0649  14         dect  stack
0069 6994 C64B  30         mov   r11,*stack            ; Save return address
0070 6996 0649  14         dect  stack
0071 6998 C644  30         mov   tmp0,*stack           ; Push tmp0
0072 699A 0649  14         dect  stack
0073 699C C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 699E C120  34         mov   @fb.row,tmp0
     69A0 A106 
0078 69A2 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     69A4 A10E 
0079 69A6 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     69A8 A10C 
0080 69AA A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     69AC A100 
0081 69AE C805  38         mov   tmp1,@fb.current
     69B0 A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 69B2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 69B4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 69B6 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 69B8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0120                       copy  "fb.cursor.up.asm"    ; Cursor up
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
0021 69BA 0649  14         dect  stack
0022 69BC C64B  30         mov   r11,*stack            ; Save return address
0023                       ;-------------------------------------------------------
0024                       ; Crunch current line if dirty
0025                       ;-------------------------------------------------------
0026 69BE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     69C0 A118 
0027 69C2 8820  54         c     @fb.row.dirty,@w$ffff
     69C4 A10A 
     69C6 2022 
0028 69C8 1604  14         jne   fb.cursor.up.cursor
0029 69CA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     69CC 6E5E 
0030 69CE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     69D0 A10A 
0031                       ;-------------------------------------------------------
0032                       ; Move cursor
0033                       ;-------------------------------------------------------
0034               fb.cursor.up.cursor:
0035 69D2 C120  34         mov   @fb.row,tmp0
     69D4 A106 
0036 69D6 150B  14         jgt   fb.cursor.up.cursor_up
0037                                                   ; Move cursor up if fb.row > 0
0038 69D8 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     69DA A104 
0039 69DC 130C  14         jeq   fb.cursor.up.set_cursorx
0040                                                   ; At top, only position cursor X
0041                       ;-------------------------------------------------------
0042                       ; Scroll 1 line
0043                       ;-------------------------------------------------------
0044 69DE 0604  14         dec   tmp0                  ; fb.topline--
0045 69E0 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     69E2 2F20 
0046               
0047 69E4 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     69E6 6B82 
0048                                                   ; | i  @parm1 = Line to start with
0049                                                   ; /             (becomes @fb.topline)
0050               
0051 69E8 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     69EA A110 
0052 69EC 1004  14         jmp   fb.cursor.up.set_cursorx
0053                       ;-------------------------------------------------------
0054                       ; Move cursor up
0055                       ;-------------------------------------------------------
0056               fb.cursor.up.cursor_up:
0057 69EE 0620  34         dec   @fb.row               ; Row-- in screen buffer
     69F0 A106 
0058 69F2 06A0  32         bl    @up                   ; Row-- VDP cursor
     69F4 26EA 
0059                       ;-------------------------------------------------------
0060                       ; Check line length and position cursor
0061                       ;-------------------------------------------------------
0062               fb.cursor.up.set_cursorx:
0063 69F6 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     69F8 7054 
0064                                                   ; | i  @fb.row        = Row in frame buffer
0065                                                   ; / o  @fb.row.length = Length of row
0066               
0067 69FA 8820  54         c     @fb.column,@fb.row.length
     69FC A10C 
     69FE A108 
0068 6A00 1207  14         jle   fb.cursor.up.exit
0069                       ;-------------------------------------------------------
0070                       ; Adjust cursor column position
0071                       ;-------------------------------------------------------
0072 6A02 C820  54         mov   @fb.row.length,@fb.column
     6A04 A108 
     6A06 A10C 
0073 6A08 C120  34         mov   @fb.column,tmp0
     6A0A A10C 
0074 6A0C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6A0E 26F4 
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               fb.cursor.up.exit:
0079 6A10 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6A12 6992 
0080 6A14 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6A16 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0121                       copy  "fb.cursor.down.asm"  ; Cursor down
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
0021 6A18 0649  14         dect  stack
0022 6A1A C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6A1C 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6A1E A106 
     6A20 A204 
0027 6A22 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6A24 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A26 A118 
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6A28 8820  54         c     @fb.row.dirty,@w$ffff
     6A2A A10A 
     6A2C 2022 
0034 6A2E 1604  14         jne   fb.cursor.down.move
0035 6A30 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6A32 6E5E 
0036 6A34 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6A36 A10A 
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6A38 C120  34         mov   @fb.topline,tmp0
     6A3A A104 
0045 6A3C A120  34         a     @fb.row,tmp0
     6A3E A106 
0046 6A40 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6A42 A204 
0047 6A44 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6A46 C120  34         mov   @fb.scrrows,tmp0
     6A48 A11A 
0053 6A4A 0604  14         dec   tmp0
0054 6A4C 8120  34         c     @fb.row,tmp0
     6A4E A106 
0055 6A50 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6A52 C820  54         mov   @fb.topline,@parm1
     6A54 A104 
     6A56 2F20 
0060 6A58 05A0  34         inc   @parm1
     6A5A 2F20 
0061               
0062 6A5C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6A5E 6B82 
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6A60 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6A62 A110 
0067 6A64 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6A66 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6A68 A106 
0073 6A6A 06A0  32         bl    @down                 ; Row++ VDP cursor
     6A6C 26E2 
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6A6E 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6A70 7054 
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6A72 8820  54         c     @fb.column,@fb.row.length
     6A74 A10C 
     6A76 A108 
0083 6A78 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6A7A C820  54         mov   @fb.row.length,@fb.column
     6A7C A108 
     6A7E A10C 
0089 6A80 C120  34         mov   @fb.column,tmp0
     6A82 A10C 
0090 6A84 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6A86 26F4 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6A88 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6A8A 6992 
0096 6A8C C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6A8E 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0122                       copy  "fb.cursor.home.asm"  ; Cursor home
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
0021 6A90 0649  14         dect  stack
0022 6A92 C64B  30         mov   r11,*stack            ; Save return address
0023 6A94 0649  14         dect  stack
0024 6A96 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;------------------------------------------------------
0026                       ; Cursor home
0027                       ;------------------------------------------------------
0028 6A98 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6A9A A118 
0029 6A9C C120  34         mov   @wyx,tmp0
     6A9E 832A 
0030 6AA0 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6AA2 FF00 
0031 6AA4 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6AA6 832A 
0032 6AA8 04E0  34         clr   @fb.column
     6AAA A10C 
0033 6AAC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AAE 6992 
0034 6AB0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6AB2 A118 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               fb.cursor.home.exit:
0039 6AB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6AB6 C2F9  30         mov   *stack+,r11           ; Pop r11
0041 6AB8 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0123                       copy  "fb.insert.line.asm"  ; Insert new line
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
0020 6ABA 0649  14         dect  stack
0021 6ABC C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Initialisation
0024                       ;-------------------------------------------------------
0025 6ABE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6AC0 A206 
0026                       ;-------------------------------------------------------
0027                       ; Crunch current line if dirty
0028                       ;-------------------------------------------------------
0029 6AC2 8820  54         c     @fb.row.dirty,@w$ffff
     6AC4 A10A 
     6AC6 2022 
0030 6AC8 1604  14         jne   fb.insert.line.insert
0031 6ACA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6ACC 6E5E 
0032 6ACE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6AD0 A10A 
0033                       ;-------------------------------------------------------
0034                       ; Insert entry in index
0035                       ;-------------------------------------------------------
0036               fb.insert.line.insert:
0037 6AD2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6AD4 6992 
0038 6AD6 C820  54         mov   @fb.topline,@parm1
     6AD8 A104 
     6ADA 2F20 
0039 6ADC A820  54         a     @fb.row,@parm1        ; Line number to insert
     6ADE A106 
     6AE0 2F20 
0040 6AE2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6AE4 A204 
     6AE6 2F22 
0041               
0042 6AE8 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6AEA 6D76 
0043                                                   ; \ i  parm1 = Line for insert
0044                                                   ; / i  parm2 = Last line to reorg
0045               
0046 6AEC 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6AEE A204 
0047 6AF0 04E0  34         clr   @fb.row.length        ; Current row length = 0
     6AF2 A108 
0048                       ;-------------------------------------------------------
0049                       ; Check/Adjust marker M1
0050                       ;-------------------------------------------------------
0051               fb.insert.line.m1:
0052 6AF4 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6AF6 A20C 
     6AF8 2022 
0053 6AFA 1308  14         jeq   fb.insert.line.m2
0054                                                   ; Yes, skip to M2 check
0055               
0056 6AFC 8820  54         c     @parm1,@edb.block.m1
     6AFE 2F20 
     6B00 A20C 
0057 6B02 1504  14         jgt   fb.insert.line.m2
0058 6B04 05A0  34         inc   @edb.block.m1         ; M1++
     6B06 A20C 
0059 6B08 0720  34         seto  @fb.colorize          ; Set colorize flag
     6B0A A110 
0060                       ;-------------------------------------------------------
0061                       ; Check/Adjust marker M2
0062                       ;-------------------------------------------------------
0063               fb.insert.line.m2:
0064 6B0C 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6B0E A20E 
     6B10 2022 
0065 6B12 1308  14         jeq   fb.insert.line.refresh
0066                                                   ; Yes, skip to refresh frame buffer
0067               
0068 6B14 8820  54         c     @parm1,@edb.block.m2
     6B16 2F20 
     6B18 A20E 
0069 6B1A 1504  14         jgt   fb.insert.line.refresh
0070 6B1C 05A0  34         inc   @edb.block.m2         ; M2++
     6B1E A20E 
0071 6B20 0720  34         seto  @fb.colorize          ; Set colorize flag
     6B22 A110 
0072                       ;-------------------------------------------------------
0073                       ; Refresh frame buffer and physical screen
0074                       ;-------------------------------------------------------
0075               fb.insert.line.refresh:
0076 6B24 C820  54         mov   @fb.topline,@parm1
     6B26 A104 
     6B28 2F20 
0077               
0078 6B2A 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6B2C 6B82 
0079                                                   ; | i  @parm1 = Line to start with
0080                                                   ; /             (becomes @fb.topline)
0081               
0082 6B2E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6B30 A116 
0083 6B32 06A0  32         bl    @fb.cursor.home       ; Move cursor home
     6B34 6A90 
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               fb.insert.line.exit:
0088 6B36 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6B38 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0124                       copy  "fb.get.firstnonblank.asm"
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
0015 6B3A 0649  14         dect  stack
0016 6B3C C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6B3E 04E0  34         clr   @fb.column
     6B40 A10C 
0021 6B42 06A0  32         bl    @fb.calc_pointer
     6B44 6992 
0022 6B46 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6B48 7054 
0023 6B4A C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6B4C A108 
0024 6B4E 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6B50 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6B52 A102 
0027 6B54 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6B56 D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6B58 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6B5A 0285  22         ci    tmp1,>2000            ; Whitespace?
     6B5C 2000 
0036 6B5E 1503  14         jgt   fb.get.firstnonblank.match
0037 6B60 0606  14         dec   tmp2                  ; Counter--
0038 6B62 16F9  14         jne   fb.get.firstnonblank.loop
0039 6B64 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6B66 6120  34         s     @fb.current,tmp0      ; Calculate column
     6B68 A102 
0045 6B6A 0604  14         dec   tmp0
0046 6B6C C804  38         mov   tmp0,@outparm1        ; Save column
     6B6E 2F30 
0047 6B70 D805  38         movb  tmp1,@outparm2        ; Save character
     6B72 2F32 
0048 6B74 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6B76 04E0  34         clr   @outparm1             ; X=0
     6B78 2F30 
0054 6B7A 04E0  34         clr   @outparm2             ; Null
     6B7C 2F32 
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6B7E C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6B80 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0125                                                   ; Get column of first non-blank character
0126                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6B82 0649  14         dect  stack
0021 6B84 C64B  30         mov   r11,*stack            ; Push return address
0022 6B86 0649  14         dect  stack
0023 6B88 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B8A 0649  14         dect  stack
0025 6B8C C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6B8E 0649  14         dect  stack
0027 6B90 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6B92 C820  54         mov   @parm1,@fb.topline
     6B94 2F20 
     6B96 A104 
0032 6B98 04E0  34         clr   @parm2                ; Target row in frame buffer
     6B9A 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6B9C 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6B9E 2F20 
     6BA0 A204 
0037 6BA2 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6BA4 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6BA6 6F56 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6BA8 05A0  34         inc   @parm1                ; Next line in editor buffer
     6BAA 2F20 
0048 6BAC 05A0  34         inc   @parm2                ; Next row in frame buffer
     6BAE 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6BB0 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6BB2 2F20 
     6BB4 A204 
0053 6BB6 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6BB8 8820  54         c     @parm2,@fb.scrrows
     6BBA 2F22 
     6BBC A11A 
0056 6BBE 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6BC0 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6BC2 C120  34         mov   @parm2,tmp0           ; Current row
     6BC4 2F22 
0064 6BC6 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6BC8 A11A 
0065 6BCA 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6BCC 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6BCE A10E 
0067               
0068 6BD0 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6BD2 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6BD4 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6BD6 A10E 
0072 6BD8 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6BDA A100 
0073               
0074 6BDC C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6BDE 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6BE0 06A0  32         bl    @xfilm                ; \ Fill memory
     6BE2 224A 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6BE4 0720  34         seto  @fb.dirty             ; Refresh screen
     6BE6 A116 
0086 6BE8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6BEA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6BEC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6BEE C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6BF0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0127                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6BF2 0649  14         dect  stack
0022 6BF4 C64B  30         mov   r11,*stack            ; Save return address
0023 6BF6 0649  14         dect  stack
0024 6BF8 C660  46         mov   @parm1,*stack         ; Push @parm1
     6BFA 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6BFC C820  54         mov   @fb.topline,@parm1
     6BFE A104 
     6C00 2F20 
0029 6C02 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6C04 6B82 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6C06 0720  34         seto  @parm1                ; Skip Asserts
     6C08 2F20 
0035 6C0A 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6C0C 7E54 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6C0E C820  54         mov   @tv.color,@parm1      ; Set normal color
     6C10 A018 
     6C12 2F20 
0042 6C14 06A0  32         bl    @pane.action.colorscheme.statlines
     6C16 7866 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6C18 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6C1A A118 
0050               
0051 6C1C 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6C1E 789E 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6C20 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6C22 2F20 
0057 6C24 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6C26 2F20 
     6C28 832A 
0058 6C2A C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6C2C 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0128                       ;-----------------------------------------------------------------------
0129                       ; Logic for Index management
0130                       ;-----------------------------------------------------------------------
0131                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6C2E 0649  14         dect  stack
0023 6C30 C64B  30         mov   r11,*stack            ; Save return address
0024 6C32 0649  14         dect  stack
0025 6C34 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6C36 0649  14         dect  stack
0027 6C38 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6C3A C120  34         mov   @parm1,tmp0           ; Get line number
     6C3C 2F20 
0032 6C3E C160  34         mov   @parm2,tmp1           ; Get pointer
     6C40 2F22 
0033 6C42 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6C44 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6C46 0FFF 
0039 6C48 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6C4A 06E0  34         swpb  @parm3
     6C4C 2F24 
0044 6C4E D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6C50 2F24 
0045 6C52 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6C54 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6C56 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C58 31AA 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6C5A C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6C5C 2F30 
0056 6C5E C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6C60 B000 
0057 6C62 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C64 2F30 
0058 6C66 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6C68 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C6A 31AA 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6C6C C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C6E 2F30 
0068 6C70 04E4  34         clr   @idx.top(tmp0)        ; /
     6C72 B000 
0069 6C74 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C76 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C78 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C7A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C7C C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C7E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0132                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6C80 0649  14         dect  stack
0022 6C82 C64B  30         mov   r11,*stack            ; Save return address
0023 6C84 0649  14         dect  stack
0024 6C86 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C88 0649  14         dect  stack
0026 6C8A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C8C 0649  14         dect  stack
0028 6C8E C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C90 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C92 2F20 
0033               
0034 6C94 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C96 31AA 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C98 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C9A 2F30 
0039 6C9C C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6C9E B000 
0040               
0041 6CA0 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6CA2 C185  18         mov   tmp1,tmp2             ; \
0047 6CA4 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6CA6 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6CA8 00FF 
0052 6CAA 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6CAC 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6CAE C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6CB0 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6CB2 2F30 
0059 6CB4 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6CB6 2F32 
0060 6CB8 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6CBA 04E0  34         clr   @outparm1
     6CBC 2F30 
0066 6CBE 04E0  34         clr   @outparm2
     6CC0 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6CC2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6CC4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6CC6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6CC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6CCA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0133                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6CCC 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6CCE B000 
0018 6CD0 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6CD2 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6CD4 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6CD6 0606  14         dec   tmp2                  ; tmp2--
0026 6CD8 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6CDA 045B  20         b     *r11                  ; Return to caller
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
0046 6CDC 0649  14         dect  stack
0047 6CDE C64B  30         mov   r11,*stack            ; Save return address
0048 6CE0 0649  14         dect  stack
0049 6CE2 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6CE4 0649  14         dect  stack
0051 6CE6 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6CE8 0649  14         dect  stack
0053 6CEA C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6CEC 0649  14         dect  stack
0055 6CEE C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6CF0 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6CF2 2F20 
0060               
0061 6CF4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6CF6 31AA 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6CF8 C120  34         mov   @outparm1,tmp0        ; Index offset
     6CFA 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6CFC C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6CFE 2F22 
0070 6D00 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6D02 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D04 2F20 
0074 6D06 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6D08 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6D0A B000 
0081 6D0C 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6D0E 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6D10 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6D12 2F22 
0088 6D14 0287  22         ci    tmp3,2048
     6D16 0800 
0089 6D18 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6D1A 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D1C 313C 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6D1E C120  34         mov   @parm1,tmp0           ; Restore line number
     6D20 2F20 
0103 6D22 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6D24 06A0  32         bl    @_idx.entry.delete.reorg
     6D26 6CCC 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6D28 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D2A 3170 
0111                                                   ; Restore memory window layout
0112               
0113 6D2C 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6D2E 06A0  32         bl    @_idx.entry.delete.reorg
     6D30 6CCC 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6D32 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6D34 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6D36 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6D38 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6D3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6D3C C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6D3E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0134                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 6D40 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6D42 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6D44 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6D46 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D48 FFCE 
0026 6D4A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D4C 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6D4E 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6D50 B000 
0031 6D52 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6D54 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6D56 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6D58 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6D5A 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6D5C 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6D5E A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6D60 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6D62 AFFE 
0042 6D64 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6D66 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6D68 0644  14         dect  tmp0                  ; Move pointer up
0050 6D6A 0645  14         dect  tmp1                  ; Move pointer up
0051 6D6C 0606  14         dec   tmp2                  ; Next index entry
0052 6D6E 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D70 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D72 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D74 045B  20         b     *r11                  ; Return to caller
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
0082 6D76 0649  14         dect  stack
0083 6D78 C64B  30         mov   r11,*stack            ; Save return address
0084 6D7A 0649  14         dect  stack
0085 6D7C C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D7E 0649  14         dect  stack
0087 6D80 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D82 0649  14         dect  stack
0089 6D84 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D86 0649  14         dect  stack
0091 6D88 C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D8A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D8C 2F22 
0096 6D8E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D90 2F20 
0097 6D92 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D94 C1E0  34         mov   @parm2,tmp3
     6D96 2F22 
0104 6D98 0287  22         ci    tmp3,2048
     6D9A 0800 
0105 6D9C 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6D9E 06A0  32         bl    @_idx.sams.mapcolumn.on
     6DA0 313C 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6DA2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DA4 2F22 
0117 6DA6 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6DA8 06A0  32         bl    @_idx.entry.insert.reorg
     6DAA 6D40 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6DAC 06A0  32         bl    @_idx.sams.mapcolumn.off
     6DAE 3170 
0125                                                   ; Restore memory window layout
0126               
0127 6DB0 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6DB2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DB4 2F22 
0133               
0134 6DB6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6DB8 31AA 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6DBA C120  34         mov   @outparm1,tmp0        ; Index offset
     6DBC 2F30 
0139               
0140 6DBE 06A0  32         bl    @_idx.entry.insert.reorg
     6DC0 6D40 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6DC2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6DC4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6DC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6DC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6DCA C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6DCC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0135                       ;-----------------------------------------------------------------------
0136                       ; Logic for Editor Buffer
0137                       ;-----------------------------------------------------------------------
0138                       copy  "edb.utils.asm"          ; Editor buffer utilities
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
0020 6DCE 0649  14         dect  stack
0021 6DD0 C64B  30         mov   r11,*stack            ; Save return address
0022 6DD2 0649  14         dect  stack
0023 6DD4 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6DD6 0649  14         dect  stack
0025 6DD8 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6DDA C120  34         mov   @edb.next_free.ptr,tmp0
     6DDC A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6DDE 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6DE0 0FFF 
0035 6DE2 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6DE4 0052 
0036 6DE6 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6DE8 0FF0 
0037 6DEA 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6DEC 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6DEE A218 
0043 6DF0 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6DF2 A200 
     6DF4 A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6DF6 C120  34         mov   @edb.sams.hipage,tmp0
     6DF8 A218 
0050 6DFA C160  34         mov   @edb.top.ptr,tmp1
     6DFC A200 
0051 6DFE 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6E00 2584 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6E02 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6E04 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E06 FFCE 
0061 6E08 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E0A 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6E0C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6E0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6E10 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6E12 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0139                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6E14 0649  14         dect  stack
0022 6E16 C64B  30         mov   r11,*stack            ; Push return address
0023 6E18 0649  14         dect  stack
0024 6E1A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6E1C 0649  14         dect  stack
0026 6E1E C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6E20 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6E22 A204 
0031 6E24 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6E26 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E28 FFCE 
0037 6E2A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E2C 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6E2E C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6E30 2F20 
0043               
0044 6E32 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6E34 6C80 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6E36 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6E38 2F32 
0050 6E3A C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6E3C 2F30 
0051 6E3E 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6E40 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6E42 A008 
0057 6E44 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6E46 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6E48 2584 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6E4A C820  54         mov   @outparm2,@tv.sams.c000
     6E4C 2F32 
     6E4E A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6E50 C820  54         mov   @outparm2,@edb.sams.page
     6E52 2F32 
     6E54 A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6E56 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6E58 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6E5A C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6E5C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0140                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6E5E 0649  14         dect  stack
0028 6E60 C64B  30         mov   r11,*stack            ; Save return address
0029 6E62 0649  14         dect  stack
0030 6E64 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6E66 0649  14         dect  stack
0032 6E68 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6E6A 0649  14         dect  stack
0034 6E6C C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6E6E 0649  14         dect  stack
0036 6E70 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6E72 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E74 A10C 
     6E76 2F6A 
0041 6E78 04E0  34         clr   @fb.column
     6E7A A10C 
0042 6E7C 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E7E 6992 
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6E80 04C4  14         clr   tmp0                  ; Counter
0047 6E82 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6E84 C160  34         mov   @fb.current,tmp1      ; Get position
     6E86 A102 
0049 6E88 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E8A 2F6C 
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6E8C D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6E8E 0986  56         srl   tmp2,8                ; Right justify
0056 6E90 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6E92 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6E94 0286  22         ci    tmp2,32               ; Was it a space character?
     6E96 0020 
0063 6E98 1301  14         jeq   edb.line.pack.fb.check80
0064 6E9A C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6E9C 0284  22         ci    tmp0,colrow
     6E9E 0050 
0070 6EA0 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6EA2 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6EA4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6EA6 FFCE 
0078 6EA8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6EAA 2026 
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6EAC 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6EAE 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6EB0 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6EB2 2F6E 
0086 6EB4 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6EB6 C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6EB8 2F6E 
0092               
0093 6EBA 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6EBC C184  18         mov   tmp0,tmp2             ; \
0096 6EBE 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6EC0 0586  14         inc   tmp2                  ; /
0098               
0099 6EC2 C107  18         mov   tmp3,tmp0             ; \
0100 6EC4 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6EC6 2F6C 
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6EC8 DD05  32         movb  tmp1,*tmp0+
0104 6ECA 0606  14         dec   tmp2
0105 6ECC 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6ECE 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6ED0 6DCE 
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6ED2 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6ED4 A104 
     6ED6 2F20 
0117 6ED8 A820  54         a     @fb.row,@parm1        ; /
     6EDA A106 
     6EDC 2F20 
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6EDE C820  54         mov   @edb.next_free.ptr,@parm2
     6EE0 A208 
     6EE2 2F22 
0123                                                   ; Pointer to new line
0124 6EE4 C820  54         mov   @edb.sams.hipage,@parm3
     6EE6 A218 
     6EE8 2F24 
0125                                                   ; SAMS page to use
0126               
0127 6EEA 06A0  32         bl    @idx.entry.update     ; Update index
     6EEC 6C2E 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6EEE C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6EF0 2F6C 
0136 6EF2 C160  34         mov   @edb.next_free.ptr,tmp1
     6EF4 A208 
0137                                                   ; Address of line in editor buffer
0138               
0139 6EF6 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6EF8 A208 
0140               
0141 6EFA C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6EFC 2F6E 
0142 6EFE CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6F00 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6F02 0286  22         ci    tmp2,2
     6F04 0002 
0150 6F06 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6F08 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6F0A DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6F0C 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6F0E 0286  22         ci    tmp2,1
     6F10 0001 
0157 6F12 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6F14 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6F16 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6F18 06A0  32         bl    @xpym2m               ; Copy memory block
     6F1A 24EE 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6F1C A820  54         a     @rambuf+4,@edb.next_free.ptr
     6F1E 2F6E 
     6F20 A208 
0171                                                      ; Add length of line
0172               
0173 6F22 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6F24 A208 
0174 6F26 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6F28 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6F2A 000F 
0176 6F2C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6F2E A208 
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6F30 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6F32 2F6A 
     6F34 A10C 
0182               
0183 6F36 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6F38 A218 
     6F3A A216 
0184 6F3C 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6F3E C120  34         mov   @edb.sams.page,tmp0
     6F40 A216 
0187 6F42 C160  34         mov   @edb.top.ptr,tmp1
     6F44 A200 
0188 6F46 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6F48 2584 
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6F4A C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6F4C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6F4E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6F50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6F52 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6F54 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0141                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0028 6F56 0649  14         dect  stack
0029 6F58 C64B  30         mov   r11,*stack            ; Save return address
0030 6F5A 0649  14         dect  stack
0031 6F5C C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6F5E 0649  14         dect  stack
0033 6F60 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6F62 0649  14         dect  stack
0035 6F64 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6F66 C820  54         mov   @parm1,@rambuf
     6F68 2F20 
     6F6A 2F6A 
0040 6F6C C820  54         mov   @parm2,@rambuf+2
     6F6E 2F22 
     6F70 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6F72 C120  34         mov   @fb.colsline,tmp0
     6F74 A10E 
0045 6F76 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6F78 2F22 
0046 6F7A C1A0  34         mov   @fb.top.ptr,tmp2
     6F7C A100 
0047 6F7E A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6F80 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F82 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6F84 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6F86 2F20 
     6F88 A204 
0053 6F8A 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6F8C 04E0  34         clr   @rambuf+8             ; Set length=0
     6F8E 2F72 
0056 6F90 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6F92 C120  34 !       mov   @parm1,tmp0
     6F94 2F20 
0061 6F96 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F98 6E14 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6F9A C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F9C 2F30 
0069 6F9E 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6FA0 04E0  34         clr   @rambuf+8             ; Set length=0
     6FA2 2F72 
0073 6FA4 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6FA6 C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6FA8 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6FAA 2F6E 
0080 6FAC C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6FAE 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6FB0 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6FB2 0050 
0085                                                   ; /
0086 6FB4 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6FB6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FB8 FFCE 
0091 6FBA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FBC 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6FBE C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6FC0 2F70 
0097 6FC2 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6FC4 2F72 
0098               
0099 6FC6 04C5  14         clr   tmp1                  ; Fill with >00
0100 6FC8 C1A0  34         mov   @fb.colsline,tmp2
     6FCA A10E 
0101 6FCC 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6FCE 2F72 
0102 6FD0 0586  14         inc   tmp2
0103               
0104 6FD2 06A0  32         bl    @xfilm                ; Fill CPU memory
     6FD4 224A 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6FD6 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6FD8 2F72 
0113 6FDA 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6FDC C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6FDE 2F6E 
0116 6FE0 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6FE2 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6FE4 0286  22         ci    tmp2,80               ; Check line length
     6FE6 0050 
0122 6FE8 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6FEA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FEC FFCE 
0127 6FEE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FF0 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6FF2 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6FF4 2F30 
0133               
0134 6FF6 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6FF8 24EE 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6FFA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6FFC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6FFE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 7000 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 7002 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0142                       copy  "edb.line.getlen.asm"    ; Get line length
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
0021 7004 0649  14         dect  stack
0022 7006 C64B  30         mov   r11,*stack            ; Push return address
0023 7008 0649  14         dect  stack
0024 700A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 700C 0649  14         dect  stack
0026 700E C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 7010 04E0  34         clr   @outparm1             ; Reset length
     7012 2F30 
0031 7014 04E0  34         clr   @outparm2             ; Reset SAMS bank
     7016 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 7018 C120  34         mov   @parm1,tmp0           ; \
     701A 2F20 
0036 701C 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 701E 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     7020 A204 
0039 7022 1101  14         jlt   !                     ; No, continue processing
0040 7024 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 7026 C120  34 !       mov   @parm1,tmp0           ; Get line
     7028 2F20 
0046               
0047 702A 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     702C 6E14 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 702E C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     7030 2F30 
0053 7032 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 7034 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 7036 C805  38         mov   tmp1,@outparm1        ; Save length
     7038 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 703A 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     703C 0050 
0064 703E 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 7040 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7042 FFCE 
0070 7044 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7046 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 7048 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     704A 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 704C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 704E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 7050 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 7052 045B  20         b     *r11                  ; Return to caller
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
0103 7054 0649  14         dect  stack
0104 7056 C64B  30         mov   r11,*stack            ; Save return address
0105 7058 0649  14         dect  stack
0106 705A C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 705C C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     705E A104 
0111 7060 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7062 A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 7064 C804  38         mov   tmp0,@parm1
     7066 2F20 
0116 7068 06A0  32         bl    @edb.line.getlength
     706A 7004 
0117 706C C820  54         mov   @outparm1,@fb.row.length
     706E 2F30 
     7070 A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 7072 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 7074 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 7076 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0143                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 7078 0649  14         dect  stack
0032 707A C64B  30         mov   r11,*stack            ; Save return address
0033 707C 0649  14         dect  stack
0034 707E C644  30         mov   tmp0,*stack           ; Push tmp0
0035 7080 0649  14         dect  stack
0036 7082 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 7084 0649  14         dect  stack
0038 7086 C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 7088 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     708A 2F20 
     708C A204 
0043 708E 1204  14         jle   !
0044 7090 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7092 FFCE 
0045 7094 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7096 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 7098 C120  34 !       mov   @parm2,tmp0           ; Get target line number
     709A 2F22 
0050 709C 0604  14         dec   tmp0                  ; Base 0
0051 709E C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     70A0 2F6C 
0052 70A2 04E0  34         clr   @rambuf               ; Set source line length=0
     70A4 2F6A 
0053 70A6 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     70A8 2F6E 
0054 70AA 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     70AC 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 70AE C120  34         mov   @parm1,tmp0           ; Get source line number
     70B0 2F20 
0059 70B2 0604  14         dec   tmp0                  ; Base 0
0060               
0061 70B4 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     70B6 6E14 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 70B8 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     70BA 2F30 
0069 70BC 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 70BE 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 70C0 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 70C2 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     70C4 2F6A 
0077 70C6 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     70C8 2F6A 
0078 70CA C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     70CC 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 70CE 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     70D0 0050 
0083 70D2 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 70D4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70D6 FFCE 
0088 70D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70DA 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 70DC A820  54         a     @w$1000,@edb.top.ptr
     70DE 201A 
     70E0 A200 
0094 70E2 A820  54         a     @w$1000,@edb.next_free.ptr
     70E4 201A 
     70E6 A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 70E8 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     70EA 6DCE 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 70EC C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     70EE 2F6E 
0111 70F0 C160  34         mov   @edb.next_free.ptr,tmp1
     70F2 A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 70F4 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     70F6 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 70F8 06A0  32         bl    @xpym2m               ; Copy memory block
     70FA 24EE 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 70FC 6820  54         s     @w$1000,@edb.top.ptr
     70FE 201A 
     7100 A200 
0127 7102 6820  54         s     @w$1000,@edb.next_free.ptr
     7104 201A 
     7106 A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 7108 C820  54         mov   @edb.next_free.ptr,@rambuf+6
     710A A208 
     710C 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 710E C120  34         mov   @edb.sams.page,tmp0
     7110 A216 
0138 7112 C160  34         mov   @edb.top.ptr,tmp1
     7114 A200 
0139 7116 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7118 2584 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 711A C120  34         mov   @tv.sams.d000,tmp0
     711C A00A 
0146 711E 0205  20         li    tmp1,>d000
     7120 D000 
0147 7122 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7124 2584 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 7126 A820  54         a     @rambuf,@edb.next_free.ptr
     7128 2F6A 
     712A A208 
0154                                                      ; Add length of line
0155               
0156 712C C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     712E A208 
0157 7130 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7132 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7134 000F 
0159 7136 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7138 A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 713A C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     713C 2F6C 
     713E 2F20 
0165 7140 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     7142 2F70 
     7144 2F22 
0166 7146 C820  54         mov   @edb.sams.hipage,@parm3
     7148 A218 
     714A 2F24 
0167                                                   ; SAMS page to use
0168               
0169 714C 06A0  32         bl    @idx.entry.update     ; Update index
     714E 6C2E 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 7150 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 7152 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7154 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 7156 C2F9  30         mov   *stack+,r11           ; Pop r11
0182 7158 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0144                       copy  "edb.line.del.asm"       ; Delete line
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
0024 715A 0649  14         dect  stack
0025 715C C64B  30         mov   r11,*stack            ; Save return address
0026 715E 0649  14         dect  stack
0027 7160 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 7162 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     7164 2F20 
     7166 A204 
0032 7168 1204  14         jle   !
0033 716A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     716C FFCE 
0034 716E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7170 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 7172 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7174 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 7176 C120  34          mov   @edb.lines,tmp0      ; \
     7178 A204 
0043 717A 0284  22          ci    tmp0,1               ; | Only single line?
     717C 0001 
0044 717E 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 7180 0620  34         dec   @parm1                ; Base 0
     7182 2F20 
0049 7184 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7186 A204 
     7188 2F22 
0050               
0051 718A 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     718C 6CDC 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 718E 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7190 A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 7192 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7194 A20C 
     7196 2022 
0061 7198 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 719A 8820  54         c     @parm1,@edb.block.m1  ; \
     719C 2F20 
     719E A20C 
0064 71A0 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 71A2 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 71A4 8820  54         c     @edb.block.m1,@w$0001 ; \
     71A6 A20C 
     71A8 2002 
0068 71AA 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 71AC 0620  34         dec   @edb.block.m1         ; M1--
     71AE A20C 
0071 71B0 0720  34         seto  @fb.colorize          ; Set colorize flag
     71B2 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 71B4 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     71B6 A20E 
     71B8 2022 
0077 71BA 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 71BC 8820  54         c     @parm1,@edb.block.m2  ; \
     71BE 2F20 
     71C0 A20E 
0080 71C2 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 71C4 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 71C6 8820  54         c     @edb.block.m2,@w$0001 ; \
     71C8 A20E 
     71CA 2002 
0084 71CC 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 71CE 0620  34         dec   @edb.block.m2         ; M2--
     71D0 A20E 
0087 71D2 0720  34         seto  @fb.colorize          ; Set colorize flag
     71D4 A110 
0088 71D6 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 71D8 04E0  34         clr   @parm1                ; 1st line
     71DA 2F20 
0094 71DC 04E0  34         clr   @parm2                ; 1st line
     71DE 2F22 
0095               
0096 71E0 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     71E2 6CDC 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 71E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 71E6 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 71E8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0145                       copy  "edb.block.mark.asm"     ; Mark code block
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
0020 71EA 0649  14         dect  stack
0021 71EC C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 71EE C820  54         mov   @fb.row,@parm1
     71F0 A106 
     71F2 2F20 
0026 71F4 06A0  32         bl    @fb.row2line          ; Row to editor line
     71F6 6978 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 71F8 05A0  34         inc   @outparm1             ; Add base 1
     71FA 2F30 
0032               
0033 71FC C820  54         mov   @outparm1,@edb.block.m1
     71FE 2F30 
     7200 A20C 
0034                                                   ; Set block marker M1
0035 7202 0720  34         seto  @fb.colorize          ; Set colorize flag
     7204 A110 
0036 7206 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     7208 A116 
0037 720A 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     720C A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 720E C2F9  30         mov   *stack+,r11           ; Pop r11
0043 7210 045B  20         b     *r11                  ; Return to caller
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
0062 7212 0649  14         dect  stack
0063 7214 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 7216 C820  54         mov   @fb.row,@parm1
     7218 A106 
     721A 2F20 
0068 721C 06A0  32         bl    @fb.row2line          ; Row to editor line
     721E 6978 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7220 05A0  34         inc   @outparm1             ; Add base 1
     7222 2F30 
0074               
0075 7224 C820  54         mov   @outparm1,@edb.block.m2
     7226 2F30 
     7228 A20E 
0076                                                   ; Set block marker M2
0077               
0078 722A 0720  34         seto  @fb.colorize          ; Set colorize flag
     722C A110 
0079 722E 0720  34         seto  @fb.dirty             ; Trigger refresh
     7230 A116 
0080 7232 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7234 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 7236 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 7238 045B  20         b     *r11                  ; Return to caller
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
0106 723A 0649  14         dect  stack
0107 723C C64B  30         mov   r11,*stack            ; Push return address
0108 723E 0649  14         dect  stack
0109 7240 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 7242 0649  14         dect  stack
0111 7244 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 7246 C820  54         mov   @fb.row,@parm1
     7248 A106 
     724A 2F20 
0116 724C 06A0  32         bl    @fb.row2line          ; Row to editor line
     724E 6978 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 7250 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     7252 2F30 
0122 7254 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 7256 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     7258 A20C 
0127 725A 0584  14         inc   tmp0                  ; /
0128 725C 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 725E 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     7260 71EA 
0135 7262 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 7264 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     7266 A20C 
0141 7268 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 726A 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     726C 7212 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 726E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 7270 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 7272 C2F9  30         mov   *stack+,r11           ; Pop r11
0154 7274 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0146                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 7276 0649  14         dect  stack
0018 7278 C64B  30         mov   r11,*stack            ; Push return address
0019 727A 0649  14         dect  stack
0020 727C C660  46         mov   @wyx,*stack           ; Push cursor position
     727E 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 7280 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     7282 A20C 
0025 7284 0720  34         seto  @edb.block.m2         ; /
     7286 A20E 
0026               
0027 7288 0720  34         seto  @fb.colorize          ; Set colorize flag
     728A A110 
0028 728C 0720  34         seto  @fb.dirty             ; Trigger refresh
     728E A116 
0029 7290 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7292 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 7294 0720  34         seto  @parm1
     7296 2F20 
0034 7298 06A0  32         bl    @pane.action.colorscheme.load
     729A 76F4 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 729C C820  54         mov   @tv.color,@parm1      ; Set normal color
     729E A018 
     72A0 2F20 
0042 72A2 06A0  32         bl    @pane.action.colorscheme.statlines
     72A4 7866 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 72A6 06A0  32         bl    @hchar
     72A8 27D6 
0048 72AA 0034                   byte 0,52,32,18           ; Remove markers
     72AC 2012 
0049 72AE 1D00                   byte pane.botrow,0,32,55  ; Remove block shortcuts
     72B0 2037 
0050 72B2 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 72B4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     72B6 832A 
0056 72B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 72BA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0147                       copy  "edb.block.copy.asm"     ; Copy code block
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
0027 72BC 0649  14         dect  stack
0028 72BE C64B  30         mov   r11,*stack            ; Save return address
0029 72C0 0649  14         dect  stack
0030 72C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 72C4 0649  14         dect  stack
0032 72C6 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 72C8 0649  14         dect  stack
0034 72CA C646  30         mov   tmp2,*stack           ; Push tmp2
0035 72CC 0649  14         dect  stack
0036 72CE C660  46         mov   @parm1,*stack         ; Push parm1
     72D0 2F20 
0037 72D2 04E0  34         clr   @outparm1             ; No action (>0000)
     72D4 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 72D6 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     72D8 A20C 
     72DA 2022 
0042 72DC 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 72DE 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     72E0 A20E 
     72E2 2022 
0045 72E4 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 72E6 8820  54         c     @edb.block.m1,@edb.block.m2
     72E8 A20C 
     72EA A20E 
0048                                                   ; M1 > M2 ?
0049 72EC 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 72EE C820  54         mov   @fb.row,@parm1
     72F0 A106 
     72F2 2F20 
0054 72F4 06A0  32         bl    @fb.row2line          ; Row to editor line
     72F6 6978 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 72F8 C120  34         mov   @outparm1,tmp0        ; \
     72FA 2F30 
0060 72FC 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 72FE C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     7300 A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 7302 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7304 2F30 
0066 7306 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 7308 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     730A 2F30 
0069 730C 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 730E 06A0  32         bl    @cpym2m
     7310 24E8 
0072 7312 39BE                   data txt.block.inside,tv.error.msg,53
     7314 A02A 
     7316 0035 
0073               
0074 7318 06A0  32         bl    @pane.errline.show    ; Show error line
     731A 7B4E 
0075               
0076 731C 04E0  34         clr   @outparm1             ; No action (>0000)
     731E 2F30 
0077 7320 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 7322 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7324 A01C 
     7326 2F20 
0082 7328 06A0  32         bl    @pane.action.colorscheme.statlines
     732A 7866 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 732C 06A0  32         bl    @hchar
     732E 27D6 
0088 7330 1D00                   byte pane.botrow,0,32,55
     7332 2037 
0089 7334 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 7336 C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 7338 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 733A 06A0  32         bl    @putat
     733C 2450 
0098 733E 1D00                   byte pane.botrow,0
0099 7340 34E4                   data txt.block.copy   ; Display "Copying block...."
0100 7342 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 7344 06A0  32         bl    @putat
     7346 2450 
0104 7348 1D00                   byte pane.botrow,0
0105 734A 34F6                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 734C C120  34         mov   @edb.block.m1,tmp0    ; M1
     734E A20C 
0111 7350 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     7352 A20E 
0112 7354 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 7356 0586  14         inc   tmp2                  ; /
0114               
0115 7358 C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     735A A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 735C C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     735E 2F20 
0121 7360 0620  34         dec   @parm1                ; Base 0 offset for index required
     7362 2F20 
0122 7364 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7366 A204 
     7368 2F22 
0123               
0124 736A 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     736C 6D76 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 736E 8805  38         c     tmp1,@edb.block.m1
     7370 A20C 
0131 7372 1506  14         jgt   edb.block.copy.loop.docopy
0132 7374 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 7376 05A0  34         inc   @edb.block.m1         ; M1++
     7378 A20C 
0135 737A 05A0  34         inc   @edb.block.m2         ; M2++
     737C A20E 
0136 737E 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 7380 C804  38         mov   tmp0,@parm1           ; Source line for copy
     7382 2F20 
0142 7384 C805  38         mov   tmp1,@parm2           ; Target line for copy
     7386 2F22 
0143               
0144 7388 06A0  32         bl    @edb.line.copy        ; Copy line
     738A 7078 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 738C 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     738E A204 
0151 7390 0584  14         inc   tmp0                  ; Next source line
0152 7392 0585  14         inc   tmp1                  ; Next target line
0153 7394 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 7396 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 7398 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     739A A206 
0159 739C 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     739E A116 
0160 73A0 0720  34         seto  @outparm1             ; Copy completed
     73A2 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 73A4 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     73A6 2F20 
0166 73A8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 73AA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 73AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 73AE C2F9  30         mov   *stack+,r11           ; Pop R11
0170 73B0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0148                       copy  "edb.block.del.asm"      ; Delete code block
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
0027 73B2 0649  14         dect  stack
0028 73B4 C64B  30         mov   r11,*stack            ; Save return address
0029 73B6 0649  14         dect  stack
0030 73B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 73BA 0649  14         dect  stack
0032 73BC C645  30         mov   tmp1,*stack           ; Push tmp1
0033 73BE 0649  14         dect  stack
0034 73C0 C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 73C2 04E0  34         clr   @outparm1             ; No action (>0000)
     73C4 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 73C6 C120  34         mov   @edb.block.m1,tmp0    ; \
     73C8 A20C 
0041 73CA 0584  14         inc   tmp0                  ; | M1 unset?
0042 73CC 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 73CE C160  34         mov   @edb.block.m2,tmp1    ; \
     73D0 A20E 
0045 73D2 0584  14         inc   tmp0                  ; | M2 unset?
0046 73D4 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 73D6 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     73D8 2F20 
0051 73DA 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 73DC C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     73DE A01C 
     73E0 2F20 
0056               
0057 73E2 06A0  32         bl    @pane.action.colorscheme.statlines
     73E4 7866 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 73E6 06A0  32         bl    @hchar
     73E8 27D6 
0063 73EA 1D00                   byte pane.botrow,0,32,55
     73EC 2037 
0064 73EE FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 73F0 06A0  32         bl    @putat
     73F2 2450 
0067 73F4 1D00                   byte pane.botrow,0
0068 73F6 34D0                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 73F8 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     73FA A20C 
0074 73FC 0604  14         dec   tmp0                  ; Base 0
0075               
0076 73FE C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     7400 A20E 
0077 7402 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7404 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     7406 2F20 
0080 7408 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     740A A204 
     740C 2F22 
0081 740E 0620  34         dec   @parm2                ; Base 0
     7410 2F22 
0082               
0083 7412 C185  18         mov   tmp1,tmp2             ; \
0084 7414 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 7416 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 7418 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     741A 6CDC 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 741C 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     741E A204 
0095 7420 0620  34         dec   @parm2                ; /
     7422 2F22 
0096               
0097 7424 0606  14         dec   tmp2
0098 7426 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 7428 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     742A A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 742C 8820  54         c     @fb.topline,@edb.lines
     742E A104 
     7430 A204 
0104                                                   ; Beyond editor buffer?
0105 7432 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7434 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     7436 A104 
     7438 2F20 
0108 743A 1002  14         jmp   edb.block.delete.fb.refresh
0109 743C 04E0  34 !       clr   @parm1                ; Set line to start with
     743E 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 7440 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     7442 6B82 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 7444 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     7446 7276 
0119               
0120 7448 0720  34         seto  @outparm1             ; Delete completed
     744A 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 744C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 744E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 7450 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 7452 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.1406079
0149                       ;-----------------------------------------------------------------------
0150                       ; User hook, background tasks
0151                       ;-----------------------------------------------------------------------
0152                       copy  "hook.keyscan.asm"       ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 7454 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7456 200A 
0009 7458 161C  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 745A C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     745C 833C 
     745E 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 7460 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7462 200A 
0016 7464 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     7466 2F40 
     7468 2F42 
0017 746A 1608  14         jne   hook.keyscan.new      ; New key pressed
0018               *---------------------------------------------------------------
0019               * Activate auto-repeat ?
0020               *---------------------------------------------------------------
0021 746C 05A0  34         inc   @keyrptcnt
     746E 2F3E 
0022 7470 C120  34         mov   @keyrptcnt,tmp0
     7472 2F3E 
0023 7474 0284  22         ci    tmp0,30
     7476 001E 
0024 7478 1112  14         jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
0025 747A 1002  14         jmp   hook.keyscan.autorepeat
0026               *--------------------------------------------------------------
0027               * New key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.new:
0030 747C 04E0  34         clr   @keyrptcnt            ; Reset key-repeat counter
     747E 2F3E 
0031               hook.keyscan.autorepeat:
0032 7480 0204  20         li    tmp0,250              ; \
     7482 00FA 
0033 7484 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0034 7486 16FE  14         jne   -!                    ; /
0035 7488 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     748A 2F40 
     748C 2F42 
0036 748E 0460  28         b     @edkey.key.process    ; Process key
     7490 60E4 
0037               *--------------------------------------------------------------
0038               * Clear keyboard buffer if no key pressed
0039               *--------------------------------------------------------------
0040               hook.keyscan.clear_kbbuffer:
0041 7492 04E0  34         clr   @keycode1
     7494 2F40 
0042 7496 04E0  34         clr   @keycode2
     7498 2F42 
0043 749A 04E0  34         clr   @keyrptcnt
     749C 2F3E 
0044               *--------------------------------------------------------------
0045               * Delay to avoid key bouncing
0046               *--------------------------------------------------------------
0047               hook.keyscan.bounce:
0048 749E 0204  20         li    tmp0,2000             ; Avoid key bouncing
     74A0 07D0 
0049                       ;------------------------------------------------------
0050                       ; Delay loop
0051                       ;------------------------------------------------------
0052               hook.keyscan.bounce.loop:
0053 74A2 0604  14         dec   tmp0
0054 74A4 16FE  14         jne   hook.keyscan.bounce.loop
0055 74A6 0460  28         b     @hookok               ; Return
     74A8 2D5C 
0056               
**** **** ****     > stevie_b1.asm.1406079
0153                       copy  "task.vdp.panes.asm"     ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 74AA 0649  14         dect  stack
0009 74AC C64B  30         mov   r11,*stack            ; Save return address
0010 74AE 0649  14         dect  stack
0011 74B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 74B2 0649  14         dect  stack
0013 74B4 C660  46         mov   @wyx,*stack           ; Push cursor position
     74B6 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 74B8 20A0  38         coc   @wbit10,config
     74BA 200C 
0019 74BC 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 74BE 06A0  32         bl    @putat
     74C0 2450 
0024 74C2 1D4E                   byte pane.botrow,78
0025 74C4 35F2                   data txt.ws4
0026 74C6 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 74C8 06A0  32         bl    @putat
     74CA 2450 
0032 74CC 1D4E                   byte pane.botrow,78
0033 74CE 35E0                   data txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 74D0 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74D2 A302 
0039 74D4 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 74D6 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74D8 A318 
0045 74DA 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 74DC 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     74DE 79AA 
0048 74E0 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     74E2 A318 
0049 74E4 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 74E6 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     74E8 A116 
0054 74EA 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056 74EC C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     74EE A11A 
     74F0 2F20 
0057               
0058               task.vdp.panes.dump:
0059 74F2 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     74F4 7E66 
0060                                                   ; \ i  @parm1 = number of lines to dump
0061                                                   ; /
0062                       ;------------------------------------------------------
0063                       ; Color the lines in the framebuffer (TAT)
0064                       ;------------------------------------------------------
0065 74F6 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     74F8 A110 
0066 74FA 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0067               
0068 74FC 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     74FE 7E54 
0069                       ;-------------------------------------------------------
0070                       ; Finished with frame buffer
0071                       ;-------------------------------------------------------
0072               task.vdp.panes.dumped:
0073 7500 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7502 A116 
0074 7504 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     7506 A118 
0075                       ;-------------------------------------------------------
0076                       ; Refresh top and bottom line
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.statlines:
0079 7508 C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     750A A118 
0080 750C 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0081               
0082 750E 06A0  32         bl    @pane.topline         ; Draw top line
     7510 7AB2 
0083 7512 06A0  32         bl    @pane.botline         ; Draw bottom line
     7514 7BE8 
0084 7516 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     7518 A118 
0085                       ;------------------------------------------------------
0086                       ; Show ruler with tab positions
0087                       ;------------------------------------------------------
0088 751A C120  34         mov   @tv.ruler.visible,tmp0
     751C A010 
0089                                                   ; Should ruler be visible?
0090 751E 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0091               
0092 7520 06A0  32         bl    @cpym2v
     7522 2494 
0093 7524 0050                   data vdp.fb.toprow.sit
0094 7526 A11E                   data fb.ruler.sit
0095 7528 0050                   data 80               ; Show ruler
0096                       ;------------------------------------------------------
0097                       ; Exit task
0098                       ;------------------------------------------------------
0099               task.vdp.panes.exit:
0100 752A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     752C 832A 
0101 752E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7530 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7532 0460  28         b     @slotok
     7534 2DD8 
**** **** ****     > stevie_b1.asm.1406079
0154               
0156               
0157                       copy  "task.vdp.cursor.sat.asm"
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 7536 0649  14         dect  stack
0009 7538 C64B  30         mov   r11,*stack            ; Save return address
0010 753A 0649  14         dect  stack
0011 753C C644  30         mov   tmp0,*stack           ; Push tmp0
0012 753E 0649  14         dect  stack
0013 7540 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7542 0649  14         dect  stack
0015 7544 C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 7546 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7548 A022 
0020               
0021 754A 0284  22         ci    tmp0,pane.focus.fb
     754C 0000 
0022 754E 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7550 0284  22         ci    tmp0,pane.focus.cmdb
     7552 0001 
0025 7554 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 7556 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7558 FFCE 
0031 755A 06A0  32         bl    @cpu.crash            ; / Halt system.
     755C 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 755E C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7560 A30A 
     7562 832A 
0037 7564 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7566 2020 
0038 7568 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     756A 26FE 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 756C 100D  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 756E E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7570 2020 
0048 7572 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7574 26FE 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 7576 C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     7578 A010 
     757A A010 
0053 757C 1303  14         jeq   task.vdp.copy.sat.fb.noruler
0054 757E 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     7580 1000 
0055 7582 1002  14         jmp   task.vdp.copy.sat.write
0056               task.vdp.copy.sat.fb.noruler:
0057 7584 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline
     7586 0800 
0058                       ;------------------------------------------------------
0059                       ; Dump sprite attribute table
0060                       ;------------------------------------------------------
0061               task.vdp.copy.sat.write:
0062 7588 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     758A 2F5A 
0063                       ;------------------------------------------------------
0064                       ; Handle column and row indicators
0065                       ;------------------------------------------------------
0066 758C C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     758E A010 
     7590 A010 
0067                                                   ; Is ruler visible?
0068 7592 130F  14         jeq   task.vdp.copy.sat.hide.indicators
0069               
0070 7594 0244  22         andi  tmp0,>ff00            ; \ Clear X position
     7596 FF00 
0071 7598 0264  22         ori   tmp0,240              ; | Line indicator on pixel X 240
     759A 00F0 
0072 759C C804  38         mov   tmp0,@ramsat+4        ; / Set line indicator    <
     759E 2F5E 
0073               
0074 75A0 C120  34         mov   @ramsat,tmp0
     75A2 2F5A 
0075 75A4 0244  22         andi  tmp0,>00ff            ; \ Clear Y position
     75A6 00FF 
0076 75A8 0264  22         ori   tmp0,>0800            ; | Column indicator on pixel Y 8
     75AA 0800 
0077 75AC C804  38         mov   tmp0,@ramsat+8        ; / Set column indicator  v
     75AE 2F62 
0078               
0079 75B0 1005  14         jmp   task.vdp.copy.sat.write2
0080                       ;------------------------------------------------------
0081                       ; Do not show column and row indicators
0082                       ;------------------------------------------------------
0083               task.vdp.copy.sat.hide.indicators:
0084 75B2 04C5  14         clr   tmp1
0085 75B4 D805  38         movb  tmp1,@ramsat+7        ; Hide line indicator    <
     75B6 2F61 
0086 75B8 D805  38         movb  tmp1,@ramsat+11       ; Hide column indicator  v
     75BA 2F65 
0087                       ;------------------------------------------------------
0088                       ; Dump to VDP
0089                       ;------------------------------------------------------
0090               task.vdp.copy.sat.write2:
0091 75BC 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75BE 2494 
0092 75C0 2180                   data sprsat,ramsat,14 ; \ i  tmp0 = VDP destination
     75C2 2F5A 
     75C4 000E 
0093                                                   ; | i  tmp1 = ROM/RAM source
0094                                                   ; / i  tmp2 = Number of bytes to write
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               task.vdp.copy.sat.exit:
0099 75C6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 75C8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 75CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 75CC C2F9  30         mov   *stack+,r11           ; Pop r11
0103 75CE 0460  28         b     @slotok               ; Exit task
     75D0 2DD8 
**** **** ****     > stevie_b1.asm.1406079
0158                                                      ; Copy cursor SAT to VDP
0159                       copy  "task.vdp.cursor.f18a.asm"
**** **** ****     > task.vdp.cursor.f18a.asm
0001               * FILE......: task.vdp.cursor.f18a.asm
0002               * Purpose...: VDP sprite cursor shape (F18a version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 75D2 0649  14         dect  stack
0009 75D4 C64B  30         mov   r11,*stack            ; Save return address
0010 75D6 0649  14         dect  stack
0011 75D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0012                       ;------------------------------------------------------
0013                       ; Toggle cursor
0014                       ;------------------------------------------------------
0015 75DA 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     75DC A112 
0016 75DE 1304  14         jeq   task.vdp.cursor.visible
0017                       ;------------------------------------------------------
0018                       ; Hide cursor
0019                       ;------------------------------------------------------
0020 75E0 04C4  14         clr   tmp0
0021 75E2 D804  38         movb  tmp0,@ramsat+3        ; Hide cursor
     75E4 2F5D 
0022 75E6 1003  14         jmp   task.vdp.cursor.copy.sat
0023                                                   ; Update VDP SAT and exit task
0024                       ;------------------------------------------------------
0025                       ; Show cursor
0026                       ;------------------------------------------------------
0027               task.vdp.cursor.visible:
0028 75E8 C820  54         mov   @tv.curshape,@ramsat+2
     75EA A014 
     75EC 2F5C 
0029                                                   ; Get cursor shape and color
0030                       ;------------------------------------------------------
0031                       ; Copy SAT
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.copy.sat:
0034 75EE 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75F0 2494 
0035 75F2 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     75F4 2F5A 
     75F6 0004 
0036                                                   ; | i  p1 = ROM/RAM source
0037                                                   ; / i  p2 = Number of bytes to write
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               task.vdp.cursor.exit:
0042 75F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0043 75FA C2F9  30         mov   *stack+,r11           ; Pop r11
0044 75FC 0460  28         b     @slotok               ; Exit task
     75FE 2DD8 
**** **** ****     > stevie_b1.asm.1406079
0160                                                      ; Set cursor shape in VDP (blink)
0167               
0168                       copy  "task.oneshot.asm"       ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7600 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7602 A024 
0010 7604 1301  14         jeq   task.oneshot.exit
0011               
0012 7606 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 7608 0460  28         b     @slotok                ; Exit task
     760A 2DD8 
**** **** ****     > stevie_b1.asm.1406079
0169                       ;-----------------------------------------------------------------------
0170                       ; Screen pane utilities
0171                       ;-----------------------------------------------------------------------
0172                       copy  "pane.utils.asm"         ; Pane utility functions
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
0020 760C 0649  14         dect  stack
0021 760E C64B  30         mov   r11,*stack            ; Push return address
0022 7610 0649  14         dect  stack
0023 7612 C660  46         mov   @wyx,*stack           ; Push cursor position
     7614 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 7616 06A0  32         bl    @hchar
     7618 27D6 
0028 761A 0034                   byte 0,52,32,18
     761C 2012 
0029 761E FFFF                   data EOL              ; Clear message
0030               
0031 7620 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7622 A024 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 7624 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7626 832A 
0037 7628 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 762A 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.1406079
0173                       copy  "pane.utils.hint.asm"    ; Show hint in pane
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
0021 762C 0649  14         dect  stack
0022 762E C64B  30         mov   r11,*stack            ; Save return address
0023 7630 0649  14         dect  stack
0024 7632 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7634 0649  14         dect  stack
0026 7636 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7638 0649  14         dect  stack
0028 763A C646  30         mov   tmp2,*stack           ; Push tmp2
0029 763C 0649  14         dect  stack
0030 763E C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 7640 C820  54         mov   @parm1,@wyx           ; Set cursor
     7642 2F20 
     7644 832A 
0035 7646 C160  34         mov   @parm2,tmp1           ; Get string to display
     7648 2F22 
0036 764A 06A0  32         bl    @xutst0               ; Display string
     764C 242E 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 764E C120  34         mov   @parm2,tmp0
     7650 2F22 
0041 7652 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 7654 0984  56         srl   tmp0,8                ; Right justify
0043 7656 C184  18         mov   tmp0,tmp2
0044 7658 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 765A 0506  16         neg   tmp2
0046 765C 0226  22         ai    tmp2,80               ; Number of bytes to fill
     765E 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 7660 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7662 2F20 
0051 7664 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 7666 C804  38         mov   tmp0,@wyx             ; / Set cursor
     7668 832A 
0053               
0054 766A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     766C 2408 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 766E 0205  20         li    tmp1,32               ; Byte to fill
     7670 0020 
0059               
0060 7672 06A0  32         bl    @xfilv                ; Clear line
     7674 22A2 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 7676 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 7678 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 767A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 767C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 767E C2F9  30         mov   *stack+,r11           ; Pop R11
0073 7680 045B  20         b     *r11                  ; Return to caller
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
0095 7682 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7684 2F20 
0096 7686 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7688 2F22 
0097 768A 0649  14         dect  stack
0098 768C C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 768E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7690 762C 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 7692 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 7694 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0174                       copy  "pane.utils.colorscheme.asm"
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
0017 7696 0649  14         dect  stack
0018 7698 C64B  30         mov   r11,*stack            ; Push return address
0019 769A 0649  14         dect  stack
0020 769C C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 769E C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     76A0 A012 
0023 76A2 0284  22         ci    tmp0,tv.colorscheme.entries
     76A4 000A 
0024                                                   ; Last entry reached?
0025 76A6 1103  14         jlt   !
0026 76A8 0204  20         li    tmp0,1                ; Reset color scheme index
     76AA 0001 
0027 76AC 1001  14         jmp   pane.action.colorscheme.switch
0028 76AE 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 76B0 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     76B2 A012 
0034               
0035 76B4 06A0  32         bl    @pane.action.colorscheme.load
     76B6 76F4 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 76B8 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     76BA 832A 
     76BC 833C 
0041               
0042 76BE 06A0  32         bl    @putnum
     76C0 2A66 
0043 76C2 003E                   byte 0,62
0044 76C4 A012                   data tv.colorscheme,rambuf,>3020
     76C6 2F6A 
     76C8 3020 
0045               
0046 76CA 06A0  32         bl    @putat
     76CC 2450 
0047 76CE 0034                   byte 0,52
0048 76D0 39F6                   data txt.colorscheme  ; Show color palette message
0049               
0050 76D2 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     76D4 833C 
     76D6 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 76D8 0204  20         li    tmp0,12000
     76DA 2EE0 
0055 76DC 0604  14 !       dec   tmp0
0056 76DE 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 76E0 0204  20         li    tmp0,pane.clearmsg.task.callback
     76E2 760C 
0061 76E4 C804  38         mov   tmp0,@tv.task.oneshot
     76E6 A024 
0062               
0063 76E8 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     76EA 2E42 
0064 76EC 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 76EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 76F0 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 76F2 045B  20         b     *r11                  ; Return to caller
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
0093 76F4 0649  14         dect  stack
0094 76F6 C64B  30         mov   r11,*stack            ; Save return address
0095 76F8 0649  14         dect  stack
0096 76FA C644  30         mov   tmp0,*stack           ; Push tmp0
0097 76FC 0649  14         dect  stack
0098 76FE C645  30         mov   tmp1,*stack           ; Push tmp1
0099 7700 0649  14         dect  stack
0100 7702 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 7704 0649  14         dect  stack
0102 7706 C647  30         mov   tmp3,*stack           ; Push tmp3
0103 7708 0649  14         dect  stack
0104 770A C648  30         mov   tmp4,*stack           ; Push tmp4
0105 770C 0649  14         dect  stack
0106 770E C660  46         mov   @parm1,*stack         ; Push parm1
     7710 2F20 
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 7712 C120  34         mov   @parm1,tmp0
     7714 2F20 
0111 7716 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7718 FFFF 
0112 771A 1302  14         jeq   !                     ; Yes, so skip screen off
0113 771C 06A0  32         bl    @scroff               ; Turn screen off
     771E 269C 
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7720 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7722 A012 
0118 7724 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 7726 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 7728 0224  22         ai    tmp0,tv.colorscheme.table
     772A 33E8 
0122                                                   ; Add base for color scheme data table
0123 772C C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 772E C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7730 A018 
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 7732 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 7734 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     7736 00FF 
0130 7738 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     773A A016 
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 773C C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 773E 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7740 FF00 
0136 7742 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 7744 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 7746 C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 7748 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 774A C806  38         mov   tmp2,@tv.busycolor    ; /
     774C A01C 
0142               
0143 774E 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     7750 00FF 
0144 7752 C805  38         mov   tmp1,@tv.markcolor    ; /
     7754 A01A 
0145               
0146 7756 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 7758 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 775A C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     775C A020 
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 775E C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 7760 0245  22         andi  tmp1,>000f            ; Only keep P
     7762 000F 
0154 7764 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 7766 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     7768 A01E 
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line and column indicators to SAT
0158                       ;-------------------------------------------------------
0159 776A C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 776C 0245  22         andi  tmp1,>00f0            ; Only keep O
     776E 00F0 
0161 7770 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 7772 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     7774 2F61 
0163 7776 D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     7778 2F65 
0164                       ;-------------------------------------------------------
0165                       ; Dump colors to VDP register 7 (text mode)
0166                       ;-------------------------------------------------------
0167 777A C147  18         mov   tmp3,tmp1             ; Get work copy
0168 777C 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0169 777E 0265  22         ori   tmp1,>0700
     7780 0700 
0170 7782 C105  18         mov   tmp1,tmp0
0171 7784 06A0  32         bl    @putvrx               ; Write VDP register
     7786 2342 
0172                       ;-------------------------------------------------------
0173                       ; Dump colors for frame buffer pane (TAT)
0174                       ;-------------------------------------------------------
0175 7788 C120  34         mov   @tv.ruler.visible,tmp0
     778A A010 
0176 778C 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0177 778E 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     7790 18A0 
0178                                                   ; VDP start address (frame buffer area)
0179 7792 0206  20         li    tmp2,(pane.botrow-2)*80
     7794 0870 
0180                                                   ; Number of bytes to fill
0181 7796 1004  14         jmp   pane.action.colorscheme.fbdump
0182               pane.action.colorscheme.fbdump.noruler:
0183 7798 0204  20         li    tmp0,vdp.fb.toprow.tat
     779A 1850 
0184                                                   ; VDP start address (frame buffer area)
0185 779C 0206  20         li    tmp2,(pane.botrow-1)*80
     779E 08C0 
0186                                                   ; Number of bytes to fill
0187               pane.action.colorscheme.fbdump:
0188 77A0 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0189 77A2 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0190               
0191 77A4 06A0  32         bl    @xfilv                ; Fill colors
     77A6 22A2 
0192                                                   ; i \  tmp0 = start address
0193                                                   ; i |  tmp1 = byte to fill
0194                                                   ; i /  tmp2 = number of bytes to fill
0195                       ;-------------------------------------------------------
0196                       ; Colorize marked lines
0197                       ;-------------------------------------------------------
0198 77A8 C120  34         mov   @parm2,tmp0
     77AA 2F22 
0199 77AC 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     77AE FFFF 
0200 77B0 1304  14         jeq   pane.action.colorscheme.cmdbpane
0201               
0202 77B2 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     77B4 A110 
0203 77B6 06A0  32         bl    @fb.colorlines
     77B8 7E54 
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for CMDB pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.cmdbpane:
0208 77BA C120  34         mov   @cmdb.visible,tmp0
     77BC A302 
0209 77BE 130F  14         jeq   pane.action.colorscheme.errpane
0210                                                   ; Skip if CMDB pane is hidden
0211               
0212 77C0 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     77C2 1FD0 
0213                                                   ; VDP start address (CMDB top line)
0214               
0215 77C4 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     77C6 A020 
0216 77C8 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     77CA 0050 
0217 77CC 06A0  32         bl    @xfilv                ; Fill colors
     77CE 22A2 
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for CMDB pane content (TAT)
0223                       ;-------------------------------------------------------
0224 77D0 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     77D2 2020 
0225                                                   ; VDP start address (CMDB top line + 1)
0226 77D4 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0227 77D6 0206  20         li    tmp2,3*80             ; Number of bytes to fill
     77D8 00F0 
0228 77DA 06A0  32         bl    @xfilv                ; Fill colors
     77DC 22A2 
0229                                                   ; i \  tmp0 = start address
0230                                                   ; i |  tmp1 = byte to fill
0231                                                   ; i /  tmp2 = number of bytes to fill
0232                       ;-------------------------------------------------------
0233                       ; Dump colors for error line (TAT)
0234                       ;-------------------------------------------------------
0235               pane.action.colorscheme.errpane:
0236 77DE C120  34         mov   @tv.error.visible,tmp0
     77E0 A028 
0237 77E2 130A  14         jeq   pane.action.colorscheme.statline
0238                                                   ; Skip if error line pane is hidden
0239               
0240 77E4 0205  20         li    tmp1,>00f6            ; White on dark red
     77E6 00F6 
0241 77E8 C805  38         mov   tmp1,@parm1           ; Pass color combination
     77EA 2F20 
0242               
0243 77EC 0205  20         li    tmp1,pane.botrow-1    ;
     77EE 001C 
0244 77F0 C805  38         mov   tmp1,@parm2           ; Error line on screen
     77F2 2F22 
0245               
0246 77F4 06A0  32         bl    @colors.line.set      ; Load color combination for line
     77F6 78BE 
0247                                                   ; \ i  @parm1 = Color combination
0248                                                   ; / i  @parm2 = Row on physical screen
0249                       ;-------------------------------------------------------
0250                       ; Dump colors for top line and bottom line (TAT)
0251                       ;-------------------------------------------------------
0252               pane.action.colorscheme.statline:
0253 77F8 C160  34         mov   @tv.color,tmp1
     77FA A018 
0254 77FC 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     77FE 00FF 
0255 7800 C805  38         mov   tmp1,@parm1           ; Set color combination
     7802 2F20 
0256               
0257               
0258 7804 04E0  34         clr   @parm2                ; Top row on screen
     7806 2F22 
0259 7808 06A0  32         bl    @colors.line.set      ; Load color combination for line
     780A 78BE 
0260                                                   ; \ i  @parm1 = Color combination
0261                                                   ; / i  @parm2 = Row on physical screen
0262               
0263 780C 0205  20         li    tmp1,pane.botrow
     780E 001D 
0264 7810 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     7812 2F22 
0265 7814 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7816 78BE 
0266                                                   ; \ i  @parm1 = Color combination
0267                                                   ; / i  @parm2 = Row on physical screen
0268                       ;-------------------------------------------------------
0269                       ; Dump colors for ruler if visible (TAT)
0270                       ;-------------------------------------------------------
0271 7818 C160  34         mov   @tv.ruler.visible,tmp1
     781A A010 
0272 781C 1307  14         jeq   pane.action.colorscheme.cursorcolor
0273               
0274 781E 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     7820 7E42 
0275 7822 06A0  32         bl    @cpym2v
     7824 2494 
0276 7826 1850                   data vdp.fb.toprow.tat
0277 7828 A16E                   data fb.ruler.tat
0278 782A 0050                   data 80               ; Show ruler colors
0279                       ;-------------------------------------------------------
0280                       ; Dump cursor FG color to sprite table (SAT)
0281                       ;-------------------------------------------------------
0282               pane.action.colorscheme.cursorcolor:
0283 782C C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     782E A016 
0284               
0285 7830 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7832 A022 
0286 7834 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     7836 0000 
0287 7838 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0288                                                   ; Yes, set cursor color
0289               
0290               pane.action.colorscheme.cursorcolor.cmdb:
0291 783A 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     783C 00F0 
0292 783E 0A48  56         sla   tmp4,4                ; Move to MSB
0293 7840 1003  14         jmp   !
0294               
0295               pane.action.colorscheme.cursorcolor.fb:
0296 7842 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     7844 000F 
0297 7846 0A88  56         sla   tmp4,8                ; Move to MSB
0298               
0299 7848 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     784A 2F5D 
0300 784C D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     784E A015 
0301                       ;-------------------------------------------------------
0302                       ; Exit
0303                       ;-------------------------------------------------------
0304               pane.action.colorscheme.load.exit:
0305 7850 06A0  32         bl    @scron                ; Turn screen on
     7852 26A4 
0306 7854 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7856 2F20 
0307 7858 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0308 785A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0309 785C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0310 785E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0311 7860 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0312 7862 C2F9  30         mov   *stack+,r11           ; Pop R11
0313 7864 045B  20         b     *r11                  ; Return to caller
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
0333 7866 0649  14         dect  stack
0334 7868 C64B  30         mov   r11,*stack            ; Save return address
0335 786A 0649  14         dect  stack
0336 786C C644  30         mov   tmp0,*stack           ; Push tmp0
0337                       ;------------------------------------------------------
0338                       ; Bottom line
0339                       ;------------------------------------------------------
0340 786E 0204  20         li    tmp0,pane.botrow
     7870 001D 
0341 7872 C804  38         mov   tmp0,@parm2           ; Last row on screen
     7874 2F22 
0342 7876 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7878 78BE 
0343                                                   ; \ i  @parm1 = Color combination
0344                                                   ; / i  @parm2 = Row on physical screen
0345                       ;------------------------------------------------------
0346                       ; Exit
0347                       ;------------------------------------------------------
0348               pane.action.colorscheme.statlines.exit:
0349 787A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0350 787C C2F9  30         mov   *stack+,r11           ; Pop R11
0351 787E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0175                                                      ; Colorscheme handling in panes
0176                       copy  "pane.cursor.asm"        ; Cursor utility functions
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
0020 7880 0649  14         dect  stack
0021 7882 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 7884 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7886 229C 
0026 7888 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     788A 0000 
     788C 0008 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 788E 06A0  32         bl    @clslot
     7890 2E34 
0031 7892 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 7894 06A0  32         bl    @clslot
     7896 2E34 
0034 7898 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 789A C2F9  30         mov   *stack+,r11           ; Pop R11
0040 789C 045B  20         b     *r11                  ; Return to caller
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
0060 789E 0649  14         dect  stack
0061 78A0 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 78A2 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     78A4 229C 
0066 78A6 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     78A8 0000 
     78AA 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0071               
0072 78AC 06A0  32         bl    @mkslot
     78AE 2E16 
0073 78B0 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     78B2 7536 
0074 78B4 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     78B6 75D2 
0075 78B8 FFFF                   data eol
0076               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 78BA C2F9  30         mov   *stack+,r11           ; Pop R11
0090 78BC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0177                       ;-----------------------------------------------------------------------
0178                       ; Screen panes
0179                       ;-----------------------------------------------------------------------
0180                       copy  "colors.line.set.asm"    ; Set color combination for line
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
0021 78BE 0649  14         dect  stack
0022 78C0 C64B  30         mov   r11,*stack            ; Save return address
0023 78C2 0649  14         dect  stack
0024 78C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 78C6 0649  14         dect  stack
0026 78C8 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 78CA 0649  14         dect  stack
0028 78CC C646  30         mov   tmp2,*stack           ; Push tmp2
0029 78CE 0649  14         dect  stack
0030 78D0 C660  46         mov   @parm1,*stack         ; Push parm1
     78D2 2F20 
0031 78D4 0649  14         dect  stack
0032 78D6 C660  46         mov   @parm2,*stack         ; Push parm2
     78D8 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 78DA C120  34         mov   @parm2,tmp0           ; Get target line
     78DC 2F22 
0037 78DE 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     78E0 0050 
0038 78E2 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 78E4 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 78E6 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     78E8 1800 
0042 78EA C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     78EC 2F20 
0043 78EE 0206  20         li    tmp2,80               ; Number of bytes to fill
     78F0 0050 
0044               
0045 78F2 06A0  32         bl    @xfilv                ; Fill colors
     78F4 22A2 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 78F6 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     78F8 2F22 
0054 78FA C839  50         mov   *stack+,@parm1        ; Pop @parm1
     78FC 2F20 
0055 78FE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7900 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7902 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7904 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 7906 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0181                       copy  "pane.cmdb.asm"          ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.1406079
0182                       copy  "pane.cmdb.show.asm"     ; Show command buffer pane
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
0022 7908 0649  14         dect  stack
0023 790A C64B  30         mov   r11,*stack            ; Save return address
0024 790C 0649  14         dect  stack
0025 790E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7910 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7912 832A 
     7914 A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 7916 0204  20         li    tmp0,pane.botrow
     7918 001D 
0033 791A 6120  34         s     @cmdb.scrrows,tmp0
     791C A306 
0034 791E C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7920 A11A 
0035               
0036 7922 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 7924 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7926 A30E 
0038               
0039 7928 0224  22         ai    tmp0,>0100
     792A 0100 
0040 792C C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     792E A310 
0041 7930 0584  14         inc   tmp0
0042 7932 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7934 A30A 
0043               
0044 7936 0720  34         seto  @cmdb.visible         ; Show pane
     7938 A302 
0045 793A 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     793C A318 
0046               
0047 793E 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7940 0001 
0048 7942 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7944 A022 
0049               
0050 7946 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7948 7BB6 
0051               
0052 794A 0720  34         seto  @parm1                ; Do not turn screen off while
     794C 2F20 
0053                                                   ; reloading color scheme
0054               
0055 794E 06A0  32         bl    @pane.action.colorscheme.load
     7950 76F4 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 7952 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 7954 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 7956 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0183                       copy  "pane.cmdb.hide.asm"     ; Hide command buffer pane
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
0023 7958 0649  14         dect  stack
0024 795A C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 795C C820  54         mov   @fb.scrrows.max,@fb.scrrows
     795E A11C 
     7960 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 7962 C820  54         mov   @tv.error.visible,@tv.error.visible
     7964 A028 
     7966 A028 
0033 7968 1302  14         jeq   !
0034 796A 0620  34         dec   @fb.scrrows
     796C A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 796E 06A0  32 !       bl    @hchar
     7970 27D6 
0039 7972 1900                   byte pane.botrow-4,0,32,80*3
     7974 20F0 
0040 7976 1C00                   byte pane.botrow-1,0,32,80*2
     7978 20A0 
0041 797A FFFF                   data EOL
0042                       ;------------------------------------------------------
0043                       ; Adjust frame buffer size if ruler visible
0044                       ;------------------------------------------------------
0045 797C C820  54         mov   @tv.ruler.visible,@tv.ruler.visible
     797E A010 
     7980 A010 
0046 7982 1302  14         jeq   pane.cmdb.hide.rest
0047 7984 0620  34         dec   @fb.scrrows
     7986 A11A 
0048                       ;------------------------------------------------------
0049                       ; Hide command buffer pane (rest)
0050                       ;------------------------------------------------------
0051               pane.cmdb.hide.rest:
0052 7988 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     798A A304 
     798C 832A 
0053 798E 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7990 A302 
0054 7992 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7994 A116 
0055 7996 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7998 A022 
0056                       ;------------------------------------------------------
0057                       ; Reload current color scheme
0058                       ;------------------------------------------------------
0059 799A 0720  34         seto  @parm1                ; Do not turn screen off while
     799C 2F20 
0060                                                   ; reloading color scheme
0061               
0062 799E 06A0  32         bl    @pane.action.colorscheme.load
     79A0 76F4 
0063                                                   ; Reload color scheme
0064                                                   ; i  parm1 = Skip screen off if >FFFF
0065                       ;------------------------------------------------------
0066                       ; Show cursor again
0067                       ;------------------------------------------------------
0068 79A2 06A0  32         bl    @pane.cursor.blink
     79A4 789E 
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               pane.cmdb.hide.exit:
0073 79A6 C2F9  30         mov   *stack+,r11           ; Pop r11
0074 79A8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0184                       copy  "pane.cmdb.draw.asm"     ; Draw command buffer pane contents
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
0017 79AA 0649  14         dect  stack
0018 79AC C64B  30         mov   r11,*stack            ; Save return address
0019 79AE 0649  14         dect  stack
0020 79B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79B2 0649  14         dect  stack
0022 79B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Command buffer header line
0025                       ;------------------------------------------------------
0026 79B6 C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     79B8 A31C 
     79BA 2F20 
0027 79BC 0204  20         li    tmp0,80
     79BE 0050 
0028 79C0 C804  38         mov   tmp0,@parm2           ; Set requested length
     79C2 2F22 
0029 79C4 0204  20         li    tmp0,1
     79C6 0001 
0030 79C8 C804  38         mov   tmp0,@parm3           ; Set character to fill
     79CA 2F24 
0031 79CC 0204  20         li    tmp0,rambuf
     79CE 2F6A 
0032 79D0 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     79D2 2F26 
0033               
0034 79D4 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     79D6 330C 
0035                                                   ; \ i  @parm1 = Pointer to string
0036                                                   ; | i  @parm2 = Requested length
0037                                                   ; | i  @parm3 = Fill character
0038                                                   ; | i  @parm4 = Pointer to buffer with
0039                                                   ; /             output string
0040               
0041 79D8 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     79DA A30E 
     79DC 832A 
0042 79DE C160  34         mov   @outparm1,tmp1        ; | Display pane header
     79E0 2F30 
0043 79E2 06A0  32         bl    @xutst0               ; /
     79E4 242E 
0044                       ;------------------------------------------------------
0045                       ; Check dialog id
0046                       ;------------------------------------------------------
0047 79E6 04E0  34         clr   @waux1                ; Default is show prompt
     79E8 833C 
0048               
0049 79EA C120  34         mov   @cmdb.dialog,tmp0
     79EC A31A 
0050 79EE 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     79F0 0063 
0051 79F2 121D  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0052 79F4 0720  34         seto  @waux1                ; /
     79F6 833C 
0053                       ;------------------------------------------------------
0054                       ; Show info message instead of prompt
0055                       ;------------------------------------------------------
0056 79F8 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     79FA A31E 
0057 79FC 1318  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0058               
0059 79FE C820  54         mov   @cmdb.paninfo,@parm1  ; Get string to display
     7A00 A31E 
     7A02 2F20 
0060 7A04 0204  20         li    tmp0,80
     7A06 0050 
0061 7A08 C804  38         mov   tmp0,@parm2           ; Set requested length
     7A0A 2F22 
0062 7A0C 0204  20         li    tmp0,32
     7A0E 0020 
0063 7A10 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A12 2F24 
0064 7A14 0204  20         li    tmp0,rambuf
     7A16 2F6A 
0065 7A18 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A1A 2F26 
0066               
0067 7A1C 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A1E 330C 
0068                                                   ; \ i  @parm1 = Pointer to string
0069                                                   ; | i  @parm2 = Requested length
0070                                                   ; | i  @parm3 = Fill character
0071                                                   ; | i  @parm4 = Pointer to buffer with
0072                                                   ; /             output string
0073               
0074 7A20 06A0  32         bl    @at
     7A22 26DC 
0075 7A24 1A00                   byte pane.botrow-3,0  ; Position cursor
0076               
0077 7A26 C160  34         mov   @outparm1,tmp1        ; \ Display pane header
     7A28 2F30 
0078 7A2A 06A0  32         bl    @xutst0               ; /
     7A2C 242E 
0079                       ;------------------------------------------------------
0080                       ; Clear lines after prompt in command buffer
0081                       ;------------------------------------------------------
0082               pane.cmdb.draw.clear:
0083 7A2E 06A0  32         bl    @hchar
     7A30 27D6 
0084 7A32 1B00                   byte pane.botrow-2,0,32,80
     7A34 2050 
0085 7A36 FFFF                   data EOL              ; Remove key markers
0086                       ;------------------------------------------------------
0087                       ; Show key markers ?
0088                       ;------------------------------------------------------
0089 7A38 C120  34         mov   @cmdb.panmarkers,tmp0
     7A3A A322 
0090 7A3C 1310  14         jeq   pane.cmdb.draw.hint   ; no, skip key markers
0091                       ;------------------------------------------------------
0092                       ; Loop over key marker list
0093                       ;------------------------------------------------------
0094               pane.cmdb.draw.marker.loop:
0095 7A3E D174  28         movb  *tmp0+,tmp1           ; Get X position
0096 7A40 0985  56         srl   tmp1,8                ; Right align
0097 7A42 0285  22         ci    tmp1,>00ff            ; End of list reached?
     7A44 00FF 
0098 7A46 130B  14         jeq   pane.cmdb.draw.hint   ; Yes, exit loop
0099               
0100 7A48 0265  22         ori   tmp1,(pane.botrow - 2) * 256
     7A4A 1B00 
0101                                                   ; y=bottom row - 3, x=(key marker position)
0102 7A4C C805  38         mov   tmp1,@wyx             ; Set cursor position
     7A4E 832A 
0103               
0104 7A50 0649  14         dect  stack
0105 7A52 C644  30         mov   tmp0,*stack           ; Push tmp0
0106               
0107 7A54 06A0  32         bl    @putstr
     7A56 242C 
0108 7A58 35E6                   data txt.keymarker    ; Show key marker
0109               
0110 7A5A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111                       ;------------------------------------------------------
0112                       ; Show marker
0113                       ;------------------------------------------------------
0114 7A5C 10F0  14         jmp   pane.cmdb.draw.marker.loop
0115                                                   ; Next iteration
0116               
0117               
0118                       ;------------------------------------------------------
0119                       ; Display pane hint in command buffer
0120                       ;------------------------------------------------------
0121               pane.cmdb.draw.hint:
0122 7A5E 0204  20         li    tmp0,pane.botrow - 1  ; \
     7A60 001C 
0123 7A62 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0124 7A64 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A66 2F20 
0125 7A68 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7A6A A320 
     7A6C 2F22 
0126               
0127 7A6E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A70 762C 
0128                                                   ; \ i  parm1 = Pointer to string with hint
0129                                                   ; / i  parm2 = YX position
0130                       ;------------------------------------------------------
0131                       ; Display keys in status line
0132                       ;------------------------------------------------------
0133 7A72 0204  20         li    tmp0,pane.botrow      ; \
     7A74 001D 
0134 7A76 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0135 7A78 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A7A 2F20 
0136 7A7C C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7A7E A324 
     7A80 2F22 
0137               
0138 7A82 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A84 762C 
0139                                                   ; \ i  parm1 = Pointer to string with hint
0140                                                   ; / i  parm2 = YX position
0141                       ;------------------------------------------------------
0142                       ; ALPHA-Lock key down?
0143                       ;------------------------------------------------------
0144 7A86 20A0  38         coc   @wbit10,config
     7A88 200C 
0145 7A8A 1306  14         jeq   pane.cmdb.draw.alpha.down
0146                       ;------------------------------------------------------
0147                       ; AlPHA-Lock is up
0148                       ;------------------------------------------------------
0149 7A8C 06A0  32         bl    @hchar
     7A8E 27D6 
0150 7A90 1D4E                   byte pane.botrow,78,32,2
     7A92 2002 
0151 7A94 FFFF                   data eol
0152               
0153 7A96 1004  14         jmp   pane.cmdb.draw.promptcmd
0154                       ;------------------------------------------------------
0155                       ; AlPHA-Lock is down
0156                       ;------------------------------------------------------
0157               pane.cmdb.draw.alpha.down:
0158 7A98 06A0  32         bl    @putat
     7A9A 2450 
0159 7A9C 1D4E                   byte   pane.botrow,78
0160 7A9E 35E0                   data   txt.alpha.down
0161                       ;------------------------------------------------------
0162                       ; Command buffer content
0163                       ;------------------------------------------------------
0164               pane.cmdb.draw.promptcmd:
0165 7AA0 C120  34         mov   @waux1,tmp0           ; Flag set?
     7AA2 833C 
0166 7AA4 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0167 7AA6 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7AA8 7E08 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               pane.cmdb.draw.exit:
0172 7AAA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0173 7AAC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0174 7AAE C2F9  30         mov   *stack+,r11           ; Pop r11
0175 7AB0 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0185                       copy  "pane.topline.asm"       ; Top line
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
0017 7AB2 0649  14         dect  stack
0018 7AB4 C64B  30         mov   r11,*stack            ; Save return address
0019 7AB6 0649  14         dect  stack
0020 7AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7ABA 0649  14         dect  stack
0022 7ABC C660  46         mov   @wyx,*stack           ; Push cursor position
     7ABE 832A 
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 7AC0 06A0  32         bl    @at
     7AC2 26DC 
0028 7AC4 0000                   byte 0,0              ; y=0, x=0
0029               
0030 7AC6 C820  54         mov   @edb.filename.ptr,@parm1
     7AC8 A212 
     7ACA 2F20 
0031                                                   ; Get string to display
0032 7ACC 0204  20         li    tmp0,47
     7ACE 002F 
0033 7AD0 C804  38         mov   tmp0,@parm2           ; Set requested length
     7AD2 2F22 
0034 7AD4 0204  20         li    tmp0,32
     7AD6 0020 
0035 7AD8 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7ADA 2F24 
0036 7ADC 0204  20         li    tmp0,rambuf
     7ADE 2F6A 
0037 7AE0 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7AE2 2F26 
0038               
0039               
0040 7AE4 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7AE6 330C 
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 7AE8 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7AEA 2F30 
0048 7AEC 06A0  32         bl    @xutst0               ; /
     7AEE 242E 
0049                       ;------------------------------------------------------
0050                       ; Show M1 marker
0051                       ;------------------------------------------------------
0052 7AF0 C120  34         mov   @edb.block.m1,tmp0    ; \
     7AF2 A20C 
0053 7AF4 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0054 7AF6 1326  14         jeq   pane.topline.exit     ; /
0055               
0056 7AF8 06A0  32         bl    @putat
     7AFA 2450 
0057 7AFC 0034                   byte 0,52
0058 7AFE 354C                   data txt.m1           ; Show M1 marker message
0059               
0060 7B00 C820  54         mov   @edb.block.m1,@parm1
     7B02 A20C 
     7B04 2F20 
0061 7B06 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B08 32E0 
0062                                                   ; \ i @parm1           = uint16
0063                                                   ; / o @unpacked.string = Output string
0064               
0065 7B0A 0204  20         li    tmp0,>0500
     7B0C 0500 
0066 7B0E D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B10 2F44 
0067               
0068 7B12 06A0  32         bl    @putat
     7B14 2450 
0069 7B16 0037                   byte 0,55
0070 7B18 2F44                   data unpacked.string  ; Show M1 value
0071                       ;------------------------------------------------------
0072                       ; Show M2 marker
0073                       ;------------------------------------------------------
0074 7B1A C120  34         mov   @edb.block.m2,tmp0    ; \
     7B1C A20E 
0075 7B1E 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0076 7B20 1311  14         jeq   pane.topline.exit     ; /
0077               
0078 7B22 06A0  32         bl    @putat
     7B24 2450 
0079 7B26 003E                   byte 0,62
0080 7B28 3550                   data txt.m2           ; Show M2 marker message
0081               
0082 7B2A C820  54         mov   @edb.block.m2,@parm1
     7B2C A20E 
     7B2E 2F20 
0083 7B30 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B32 32E0 
0084                                                   ; \ i @parm1           = uint16
0085                                                   ; / o @unpacked.string = Output string
0086               
0087 7B34 0204  20         li    tmp0,>0500
     7B36 0500 
0088 7B38 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B3A 2F44 
0089               
0090 7B3C 06A0  32         bl    @putat
     7B3E 2450 
0091 7B40 0041                   byte 0,65
0092 7B42 2F44                   data unpacked.string  ; Show M2 value
0093                       ;------------------------------------------------------
0094                       ; Exit
0095                       ;------------------------------------------------------
0096               pane.topline.exit:
0097 7B44 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7B46 832A 
0098 7B48 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 7B4A C2F9  30         mov   *stack+,r11           ; Pop r11
0100 7B4C 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0186                       copy  "pane.errline.asm"       ; Error line
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
0022 7B4E 0649  14         dect  stack
0023 7B50 C64B  30         mov   r11,*stack            ; Save return address
0024 7B52 0649  14         dect  stack
0025 7B54 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7B56 0649  14         dect  stack
0027 7B58 C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7B5A 0205  20         li    tmp1,>00f6            ; White on dark red
     7B5C 00F6 
0030 7B5E C805  38         mov   tmp1,@parm1
     7B60 2F20 
0031               
0032 7B62 0205  20         li    tmp1,pane.botrow-1    ;
     7B64 001C 
0033 7B66 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7B68 2F22 
0034               
0035 7B6A 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7B6C 78BE 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7B6E 0204  20         li    tmp0,tv.error.msg
     7B70 A02A 
0043 7B72 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7B74 2F20 
0044               
0045 7B76 0204  20         li    tmp0,80
     7B78 0050 
0046 7B7A C804  38         mov   tmp0,@parm2           ; Set requested length
     7B7C 2F22 
0047               
0048 7B7E 0204  20         li    tmp0,32
     7B80 0020 
0049 7B82 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7B84 2F24 
0050               
0051 7B86 0204  20         li    tmp0,rambuf
     7B88 2F6A 
0052 7B8A C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7B8C 2F26 
0053               
0054 7B8E 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B90 330C 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7B92 06A0  32         bl    @at
     7B94 26DC 
0064 7B96 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7B98 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7B9A 2F30 
0067 7B9C 06A0  32         bl    @xutst0               ; /
     7B9E 242E 
0068               
0069 7BA0 C120  34         mov   @fb.scrrows.max,tmp0
     7BA2 A11C 
0070 7BA4 0604  14         dec   tmp0
0071 7BA6 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7BA8 A11A 
0072               
0073 7BAA 0720  34         seto  @tv.error.visible     ; Error line is visible
     7BAC A028 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7BAE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7BB0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7BB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7BB4 045B  20         b     *r11                  ; Return to caller
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
0103 7BB6 0649  14         dect  stack
0104 7BB8 C64B  30         mov   r11,*stack            ; Save return address
0105 7BBA 0649  14         dect  stack
0106 7BBC C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7BBE 06A0  32         bl    @errline.init         ; Clear error line
     7BC0 3274 
0111               
0112 7BC2 C120  34         mov   @tv.color,tmp0        ; Get colors
     7BC4 A018 
0113 7BC6 0984  56         srl   tmp0,8                ; Right aligns
0114 7BC8 C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7BCA 2F20 
0115               
0116               
0117 7BCC 0205  20         li    tmp1,pane.botrow-1    ;
     7BCE 001C 
0118 7BD0 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BD2 2F22 
0119               
0120 7BD4 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BD6 78BE 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7BD8 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7BDA A028 
0125 7BDC C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7BDE A11C 
     7BE0 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7BE2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7BE4 C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7BE6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0187                       copy  "pane.botline.asm"       ; Bottom line
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
0017 7BE8 0649  14         dect  stack
0018 7BEA C64B  30         mov   r11,*stack            ; Save return address
0019 7BEC 0649  14         dect  stack
0020 7BEE C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7BF0 0649  14         dect  stack
0022 7BF2 C660  46         mov   @wyx,*stack           ; Push cursor position
     7BF4 832A 
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 7BF6 C120  34         mov   @edb.block.m2,tmp0    ; \
     7BF8 A20E 
0027 7BFA 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 7BFC 1305  14         jeq   pane.botline.show_keys
0030               
0031 7BFE 06A0  32         bl    @putat
     7C00 2450 
0032 7C02 1D00                   byte pane.botrow,0
0033 7C04 355C                   data txt.keys.block   ; Show block shortcuts
0034               
0035 7C06 1004  14         jmp   pane.botline.show_dirty
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 7C08 06A0  32         bl    @putat
     7C0A 2450 
0041 7C0C 1D00                   byte pane.botrow,0
0042 7C0E 3554                   data txt.keys.default ; Show default shortcuts
0043                       ;------------------------------------------------------
0044                       ; Show if text was changed in editor buffer
0045                       ;------------------------------------------------------
0046               pane.botline.show_dirty:
0047 7C10 C120  34         mov   @edb.dirty,tmp0
     7C12 A206 
0048 7C14 1305  14         jeq   pane.botline.nochange
0049                       ;------------------------------------------------------
0050                       ; Show "*"
0051                       ;------------------------------------------------------
0052 7C16 06A0  32         bl    @putat
     7C18 2450 
0053 7C1A 1D35                   byte pane.botrow,53   ; x=53
0054 7C1C 34B6                   data txt.star
0055 7C1E 1004  14         jmp   pane.botline.show_mode
0056                       ;------------------------------------------------------
0057                       ; Show " "
0058                       ;------------------------------------------------------
0059               pane.botline.nochange:
0060 7C20 06A0  32         bl    @putat
     7C22 2450 
0061 7C24 1D35                   byte pane.botrow,53   ; x=53
0062 7C26 35E8                   data txt.ws1          ; Single white space
0063                       ;------------------------------------------------------
0064                       ; Show text editing mode
0065                       ;------------------------------------------------------
0066               pane.botline.show_mode:
0067 7C28 C120  34         mov   @edb.insmode,tmp0
     7C2A A20A 
0068 7C2C 1605  14         jne   pane.botline.show_mode.insert
0069                       ;------------------------------------------------------
0070                       ; Overwrite mode
0071                       ;------------------------------------------------------
0072 7C2E 06A0  32         bl    @putat
     7C30 2450 
0073 7C32 1D37                   byte  pane.botrow,55
0074 7C34 34AE                   data  txt.ovrwrite
0075 7C36 1004  14         jmp   pane.botline.show_linecol
0076                       ;------------------------------------------------------
0077                       ; Insert mode
0078                       ;------------------------------------------------------
0079               pane.botline.show_mode.insert:
0080 7C38 06A0  32         bl    @putat
     7C3A 2450 
0081 7C3C 1D37                   byte  pane.botrow,55
0082 7C3E 34B2                   data  txt.insert
0083                       ;------------------------------------------------------
0084                       ; Show "line,column"
0085                       ;------------------------------------------------------
0086               pane.botline.show_linecol:
0087 7C40 C820  54         mov   @fb.row,@parm1
     7C42 A106 
     7C44 2F20 
0088 7C46 06A0  32         bl    @fb.row2line          ; Row to editor line
     7C48 6978 
0089                                                   ; \ i @fb.topline = Top line in frame buffer
0090                                                   ; | i @parm1      = Row in frame buffer
0091                                                   ; / o @outparm1   = Matching line in EB
0092               
0093 7C4A 05A0  34         inc   @outparm1             ; Add base 1
     7C4C 2F30 
0094                       ;------------------------------------------------------
0095                       ; Show line
0096                       ;------------------------------------------------------
0097 7C4E 06A0  32         bl    @putnum
     7C50 2A66 
0098 7C52 1D3B                   byte  pane.botrow,59  ; YX
0099 7C54 2F30                   data  outparm1,rambuf
     7C56 2F6A 
0100 7C58 3020                   byte  48              ; ASCII offset
0101                             byte  32              ; Padding character
0102                       ;------------------------------------------------------
0103                       ; Show comma
0104                       ;------------------------------------------------------
0105 7C5A 06A0  32         bl    @putat
     7C5C 2450 
0106 7C5E 1D40                   byte  pane.botrow,64
0107 7C60 34A6                   data  txt.delim
0108                       ;------------------------------------------------------
0109                       ; Show column
0110                       ;------------------------------------------------------
0111 7C62 06A0  32         bl    @film
     7C64 2244 
0112 7C66 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7C68 0020 
     7C6A 000C 
0113               
0114 7C6C C820  54         mov   @fb.column,@waux1
     7C6E A10C 
     7C70 833C 
0115 7C72 05A0  34         inc   @waux1                ; Offset 1
     7C74 833C 
0116               
0117 7C76 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7C78 29E8 
0118 7C7A 833C                   data  waux1,rambuf
     7C7C 2F6A 
0119 7C7E 3020                   byte  48              ; ASCII offset
0120                             byte  32              ; Fill character
0121               
0122 7C80 06A0  32         bl    @trimnum              ; Trim number to the left
     7C82 2A40 
0123 7C84 2F6A                   data  rambuf,rambuf+5,32
     7C86 2F6F 
     7C88 0020 
0124               
0125 7C8A 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7C8C 0600 
0126 7C8E D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7C90 2F6F 
0127               
0128                       ;------------------------------------------------------
0129                       ; Decide if row length is to be shown
0130                       ;------------------------------------------------------
0131 7C92 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7C94 A10C 
0132 7C96 0584  14         inc   tmp0                  ; /
0133 7C98 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7C9A A108 
0134 7C9C 1101  14         jlt   pane.botline.show_linecol.linelen
0135 7C9E 102B  14         jmp   pane.botline.show_linecol.colstring
0136                                                   ; Yes, skip showing row length
0137                       ;------------------------------------------------------
0138                       ; Add ',' delimiter and length of line to string
0139                       ;------------------------------------------------------
0140               pane.botline.show_linecol.linelen:
0141 7CA0 C120  34         mov   @fb.column,tmp0       ; \
     7CA2 A10C 
0142 7CA4 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7CA6 2F71 
0143 7CA8 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7CAA 0009 
0144 7CAC 1101  14         jlt   !                     ; | column.
0145 7CAE 0585  14         inc   tmp1                  ; /
0146               
0147 7CB0 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7CB2 2D00 
0148 7CB4 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0149               
0150 7CB6 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7CB8 833C 
0151               
0152 7CBA 06A0  32         bl    @mknum
     7CBC 29E8 
0153 7CBE A108                   data  fb.row.length,rambuf
     7CC0 2F6A 
0154 7CC2 3020                   byte  48              ; ASCII offset
0155                             byte  32              ; Padding character
0156               
0157 7CC4 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7CC6 833C 
0158               
0159 7CC8 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7CCA A108 
0160 7CCC 0284  22         ci    tmp0,10               ; /
     7CCE 000A 
0161 7CD0 110B  14         jlt   pane.botline.show_line.1digit
0162                       ;------------------------------------------------------
0163                       ; Assert
0164                       ;------------------------------------------------------
0165 7CD2 0284  22         ci    tmp0,80
     7CD4 0050 
0166 7CD6 1204  14         jle   pane.botline.show_line.2digits
0167                       ;------------------------------------------------------
0168                       ; Asserts failed
0169                       ;------------------------------------------------------
0170 7CD8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7CDA FFCE 
0171 7CDC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7CDE 2026 
0172                       ;------------------------------------------------------
0173                       ; Show length of line (2 digits)
0174                       ;------------------------------------------------------
0175               pane.botline.show_line.2digits:
0176 7CE0 0204  20         li    tmp0,rambuf+3
     7CE2 2F6D 
0177 7CE4 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0178 7CE6 1002  14         jmp   pane.botline.show_line.rest
0179                       ;------------------------------------------------------
0180                       ; Show length of line (1 digits)
0181                       ;------------------------------------------------------
0182               pane.botline.show_line.1digit:
0183 7CE8 0204  20         li    tmp0,rambuf+4
     7CEA 2F6E 
0184               pane.botline.show_line.rest:
0185 7CEC DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0186 7CEE DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CF0 2F6A 
0187 7CF2 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CF4 2F6A 
0188                       ;------------------------------------------------------
0189                       ; Show column string
0190                       ;------------------------------------------------------
0191               pane.botline.show_linecol.colstring:
0192 7CF6 06A0  32         bl    @putat
     7CF8 2450 
0193 7CFA 1D41                   byte pane.botrow,65
0194 7CFC 2F6F                   data rambuf+5         ; Show string
0195                       ;------------------------------------------------------
0196                       ; Show lines in buffer unless on last line in file
0197                       ;------------------------------------------------------
0198 7CFE C820  54         mov   @fb.row,@parm1
     7D00 A106 
     7D02 2F20 
0199 7D04 06A0  32         bl    @fb.row2line
     7D06 6978 
0200 7D08 8820  54         c     @edb.lines,@outparm1
     7D0A A204 
     7D0C 2F30 
0201 7D0E 1605  14         jne   pane.botline.show_lines_in_buffer
0202               
0203 7D10 06A0  32         bl    @putat
     7D12 2450 
0204 7D14 1D48                   byte pane.botrow,72
0205 7D16 34A8                   data txt.bottom
0206               
0207 7D18 1009  14         jmp   pane.botline.exit
0208                       ;------------------------------------------------------
0209                       ; Show lines in buffer
0210                       ;------------------------------------------------------
0211               pane.botline.show_lines_in_buffer:
0212 7D1A C820  54         mov   @edb.lines,@waux1
     7D1C A204 
     7D1E 833C 
0213               
0214 7D20 06A0  32         bl    @putnum
     7D22 2A66 
0215 7D24 1D48                   byte pane.botrow,72   ; YX
0216 7D26 833C                   data waux1,rambuf
     7D28 2F6A 
0217 7D2A 3020                   byte 48
0218                             byte 32
0219                       ;------------------------------------------------------
0220                       ; Exit
0221                       ;------------------------------------------------------
0222               pane.botline.exit:
0223 7D2C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7D2E 832A 
0224 7D30 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0225 7D32 C2F9  30         mov   *stack+,r11           ; Pop r11
0226 7D34 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1406079
0188                       ;-----------------------------------------------------------------------
0189                       ; Stubs using trampoline
0190                       ;-----------------------------------------------------------------------
0191                       copy  "rom.stubs.bank1.asm"    ; Stubs for functions in other banks
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
0010 7D36 0649  14         dect  stack
0011 7D38 C64B  30         mov   r11,*stack            ; Save return address
0012                       ;------------------------------------------------------
0013                       ; Dump VDP patterns
0014                       ;------------------------------------------------------
0015 7D3A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D3C 3008 
0016 7D3E 600A                   data bank5.rom        ; | i  p0 = bank address
0017 7D40 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0018 7D42 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0019                       ;------------------------------------------------------
0020                       ; Exit
0021                       ;------------------------------------------------------
0022 7D44 C2F9  30         mov   *stack+,r11           ; Pop r11
0023 7D46 045B  20         b     *r11                  ; Return to caller
0024               
0025               
0026               ***************************************************************
0027               * Stub for "fm.loadfile"
0028               * bank2 vec.1
0029               ********|*****|*********************|**************************
0030               fm.loadfile:
0031 7D48 0649  14         dect  stack
0032 7D4A C64B  30         mov   r11,*stack            ; Save return address
0033 7D4C 0649  14         dect  stack
0034 7D4E C644  30         mov   tmp0,*stack           ; Push tmp0
0035                       ;------------------------------------------------------
0036                       ; Call function in bank 2
0037                       ;------------------------------------------------------
0038 7D50 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D52 3008 
0039 7D54 6004                   data bank2.rom        ; | i  p0 = bank address
0040 7D56 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0041 7D58 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0042                       ;------------------------------------------------------
0043                       ; Show "Unsaved changes" dialog if editor buffer dirty
0044                       ;------------------------------------------------------
0045 7D5A C120  34         mov   @outparm1,tmp0
     7D5C 2F30 
0046 7D5E 1304  14         jeq   fm.loadfile.exit
0047               
0048 7D60 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7D62 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7D64 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D66 7DC2 
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               fm.loadfile.exit:
0055 7D68 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7D6A C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7D6C 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * Stub for "fm.savefile"
0062               * bank2 vec.2
0063               ********|*****|*********************|**************************
0064               fm.savefile:
0065 7D6E 0649  14         dect  stack
0066 7D70 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Call function in bank 2
0069                       ;------------------------------------------------------
0070 7D72 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D74 3008 
0071 7D76 6004                   data bank2.rom        ; | i  p0 = bank address
0072 7D78 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0073 7D7A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077 7D7C C2F9  30         mov   *stack+,r11           ; Pop r11
0078 7D7E 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               **************************************************************
0082               * Stub for "fm.browse.fname.suffix"
0083               * bank2 vec.3
0084               ********|*****|*********************|**************************
0085               fm.browse.fname.suffix:
0086 7D80 0649  14         dect  stack
0087 7D82 C64B  30         mov   r11,*stack            ; Save return address
0088                       ;------------------------------------------------------
0089                       ; Call function in bank 2
0090                       ;------------------------------------------------------
0091 7D84 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D86 3008 
0092 7D88 6004                   data bank2.rom        ; | i  p0 = bank address
0093 7D8A 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0094 7D8C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098 7D8E C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7D90 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               **************************************************************
0103               * Stub for "fm.fastmode"
0104               * bank2 vec.4
0105               ********|*****|*********************|**************************
0106               fm.fastmode:
0107 7D92 0649  14         dect  stack
0108 7D94 C64B  30         mov   r11,*stack            ; Save return address
0109                       ;------------------------------------------------------
0110                       ; Call function in bank 2
0111                       ;------------------------------------------------------
0112 7D96 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D98 3008 
0113 7D9A 6004                   data bank2.rom        ; | i  p0 = bank address
0114 7D9C 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0115 7D9E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119 7DA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0120 7DA2 045B  20         b     *r11                  ; Return to caller
0121               
0122               
0123               ***************************************************************
0124               * Stub for "About dialog"
0125               * bank3 vec.1
0126               ********|*****|*********************|**************************
0127               edkey.action.about:
0128 7DA4 C820  54         mov   @edkey.action.about.vector,@parm1
     7DA6 7DAC 
     7DA8 2F20 
0129 7DAA 1066  14         jmp   _trampoline.bank3     ; Show dialog
0130               edkey.action.about.vector:
0131 7DAC 7FC0             data  vec.1
0132               
0133               
0134               ***************************************************************
0135               * Stub for "Load DV80 file"
0136               * bank3 vec.2
0137               ********|*****|*********************|**************************
0138               dialog.load:
0139 7DAE C820  54         mov   @dialog.load.vector,@parm1
     7DB0 7DB6 
     7DB2 2F20 
0140 7DB4 1061  14         jmp   _trampoline.bank3     ; Show dialog
0141               dialog.load.vector:
0142 7DB6 7FC2             data  vec.2
0143               
0144               
0145               ***************************************************************
0146               * Stub for "Save DV80 file"
0147               * bank3 vec.3
0148               ********|*****|*********************|**************************
0149               dialog.save:
0150 7DB8 C820  54         mov   @dialog.save.vector,@parm1
     7DBA 7DC0 
     7DBC 2F20 
0151 7DBE 105C  14         jmp   _trampoline.bank3     ; Show dialog
0152               dialog.save.vector:
0153 7DC0 7FC4             data  vec.3
0154               
0155               
0156               ***************************************************************
0157               * Stub for "Unsaved Changes"
0158               * bank3 vec.4
0159               ********|*****|*********************|**************************
0160               dialog.unsaved:
0161 7DC2 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7DC4 A322 
0162 7DC6 C820  54         mov   @dialog.unsaved.vector,@parm1
     7DC8 7DCE 
     7DCA 2F20 
0163 7DCC 1055  14         jmp   _trampoline.bank3     ; Show dialog
0164               dialog.unsaved.vector:
0165 7DCE 7FC6             data  vec.4
0166               
0167               
0168               ***************************************************************
0169               * Stub for Dialog "File dialog"
0170               * bank3 vec.5
0171               ********|*****|*********************|**************************
0172               dialog.file:
0173 7DD0 C820  54         mov   @dialog.file.vector,@parm1
     7DD2 7DD8 
     7DD4 2F20 
0174 7DD6 1050  14         jmp   _trampoline.bank3     ; Show dialog
0175               dialog.file.vector:
0176 7DD8 7FC8             data  vec.5
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
0187 7DDA C120  34         mov   @edb.block.m2,tmp0    ; \
     7DDC A20E 
0188 7DDE 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0189                                                   ; /
0190 7DE0 1302  14         jeq   !                     : Block mode inactive, show dialog
0191                       ;------------------------------------------------------
0192                       ; Special treatment for block mode
0193                       ;------------------------------------------------------
0194 7DE2 0460  28         b     @edkey.action.block.reset
     7DE4 66DC 
0195                                                   ; Reset block mode
0196                       ;------------------------------------------------------
0197                       ; Show dialog
0198                       ;------------------------------------------------------
0199 7DE6 06A0  32 !       bl    @rom.farjump          ; \ Trampoline jump to bank
     7DE8 3008 
0200 7DEA 6006                   data bank3.rom        ; | i  p0 = bank address
0201 7DEC 7FCA                   data vec.6            ; | i  p1 = Vector with target address
0202 7DEE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0203                       ;------------------------------------------------------
0204                       ; Exit
0205                       ;------------------------------------------------------
0206 7DF0 0460  28         b     @edkey.action.cmdb.show
     7DF2 6848 
0207                                                   ; Show dialog in CMDB pane
0208               
0209               
0210               ***************************************************************
0211               * Stub for Dialog "Basic dialog"
0212               * bank3 vec.7
0213               ********|*****|*********************|**************************
0214               dialog.basic:
0215 7DF4 C820  54         mov   @dialog.basic.vector,@parm1
     7DF6 7DFC 
     7DF8 2F20 
0216 7DFA 103E  14         jmp   _trampoline.bank3     ; Show dialog
0217               dialog.basic.vector:
0218 7DFC 7FCC             data  vec.7
0219               
0220               
0221               
0222               ***************************************************************
0223               * Stub for "run.tibasic"
0224               * bank3 vec.24
0225               ********|*****|*********************|**************************
0226               run.tibasic:
0227 7DFE C820  54         mov   @run.tibasic.vector,@parm1
     7E00 7E06 
     7E02 2F20 
0228 7E04 1042  14         jmp   _trampoline.bank3.ret ; Longjump
0229               run.tibasic.vector:
0230 7E06 7FE6             data  vec.20
0231               
0232               
0233               ***************************************************************
0234               * Stub for "cmdb.refresh"
0235               * bank3 vec.24
0236               ********|*****|*********************|**************************
0237               cmdb.refresh:
0238 7E08 C820  54         mov   @cmdb.refresh.vector,@parm1
     7E0A 7E10 
     7E0C 2F20 
0239 7E0E 103D  14         jmp   _trampoline.bank3.ret ; Longjump
0240               cmdb.refresh.vector:
0241 7E10 7FEE             data  vec.24
0242               
0243               
0244               ***************************************************************
0245               * Stub for "cmdb.cmd.clear"
0246               * bank3 vec.25
0247               ********|*****|*********************|**************************
0248               cmdb.cmd.clear:
0249 7E12 C820  54         mov   @cmdb.cmd.clear.vector,@parm1
     7E14 7E1A 
     7E16 2F20 
0250 7E18 1038  14         jmp   _trampoline.bank3.ret ; Longjump
0251               cmdb.cmd.clear.vector:
0252 7E1A 7FF0             data  vec.25
0253               
0254               
0255               ***************************************************************
0256               * Stub for "cmdb.cmdb.getlength"
0257               * bank3 vec.26
0258               ********|*****|*********************|**************************
0259               cmdb.cmd.getlength:
0260 7E1C C820  54         mov   @cmdb.cmd.getlength.vector,@parm1
     7E1E 7E24 
     7E20 2F20 
0261 7E22 1033  14         jmp   _trampoline.bank3.ret ; Longjump
0262               cmdb.cmd.getlength.vector:
0263 7E24 7FF2             data  vec.26
0264               
0265               
0266               ***************************************************************
0267               * Stub for "cmdb.cmdb.addhist"
0268               * bank3 vec.27
0269               ********|*****|*********************|**************************
0270               cmdb.cmd.addhist:
0271 7E26 C820  54         mov   @cmdb.cmd.addhist.vector,@parm1
     7E28 7E2E 
     7E2A 2F20 
0272 7E2C 102E  14         jmp   _trampoline.bank3.ret ; Longjump
0273               cmdb.cmd.addhist.vector:
0274 7E2E 7FF4             data  vec.27
0275               
0276               
0277               ***************************************************************
0278               * Stub for "fb.tab.next"
0279               * bank4 vec.1
0280               ********|*****|*********************|**************************
0281               fb.tab.next:
0282 7E30 0649  14         dect  stack
0283 7E32 C64B  30         mov   r11,*stack            ; Save return address
0284                       ;------------------------------------------------------
0285                       ; Put cursor on next tab position
0286                       ;------------------------------------------------------
0287 7E34 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E36 3008 
0288 7E38 6008                   data bank4.rom        ; | i  p0 = bank address
0289 7E3A 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0290 7E3C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0291                       ;------------------------------------------------------
0292                       ; Exit
0293                       ;------------------------------------------------------
0294 7E3E C2F9  30         mov   *stack+,r11           ; Pop r11
0295 7E40 045B  20         b     *r11                  ; Return to caller
0296               
0297               
0298               ***************************************************************
0299               * Stub for "fb.ruler.init"
0300               * bank4 vec.2
0301               ********|*****|*********************|**************************
0302               fb.ruler.init:
0303 7E42 0649  14         dect  stack
0304 7E44 C64B  30         mov   r11,*stack            ; Save return address
0305                       ;------------------------------------------------------
0306                       ; Setup ruler in memory
0307                       ;------------------------------------------------------
0308 7E46 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E48 3008 
0309 7E4A 6008                   data bank4.rom        ; | i  p0 = bank address
0310 7E4C 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0311 7E4E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0312                       ;------------------------------------------------------
0313                       ; Exit
0314                       ;------------------------------------------------------
0315 7E50 C2F9  30         mov   *stack+,r11           ; Pop r11
0316 7E52 045B  20         b     *r11                  ; Return to caller
0317               
0318               
0319               ***************************************************************
0320               * Stub for "fb.colorlines"
0321               * bank4 vec.3
0322               ********|*****|*********************|**************************
0323               fb.colorlines:
0324 7E54 0649  14         dect  stack
0325 7E56 C64B  30         mov   r11,*stack            ; Save return address
0326                       ;------------------------------------------------------
0327                       ; Colorize frame buffer content
0328                       ;------------------------------------------------------
0329 7E58 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E5A 3008 
0330 7E5C 6008                   data bank4.rom        ; | i  p0 = bank address
0331 7E5E 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0332 7E60 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0333                       ;------------------------------------------------------
0334                       ; Exit
0335                       ;------------------------------------------------------
0336 7E62 C2F9  30         mov   *stack+,r11           ; Pop r11
0337 7E64 045B  20         b     *r11                  ; Return to caller
0338               
0339               
0340               ***************************************************************
0341               * Stub for "fb.vdpdump"
0342               * bank4 vec.4
0343               ********|*****|*********************|**************************
0344               fb.vdpdump:
0345 7E66 0649  14         dect  stack
0346 7E68 C64B  30         mov   r11,*stack            ; Save return address
0347                       ;------------------------------------------------------
0348                       ; Colorize frame buffer content
0349                       ;------------------------------------------------------
0350 7E6A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E6C 3008 
0351 7E6E 6008                   data bank4.rom        ; | i  p0 = bank address
0352 7E70 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0353 7E72 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0354                       ;------------------------------------------------------
0355                       ; Exit
0356                       ;------------------------------------------------------
0357 7E74 C2F9  30         mov   *stack+,r11           ; Pop r11
0358 7E76 045B  20         b     *r11                  ; Return to caller
0359               
0360               
0361               ***************************************************************
0362               * Trampoline 1 (bank 3, dialog)
0363               ********|*****|*********************|**************************
0364               _trampoline.bank3:
0365 7E78 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E7A 7880 
0366                       ;------------------------------------------------------
0367                       ; Show dialog
0368                       ;------------------------------------------------------
0369 7E7C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E7E 3008 
0370 7E80 6006                   data bank3.rom        ; | i  p0 = bank address
0371 7E82 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0372                                                   ; |         (deref @parm1)
0373 7E84 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0374                       ;------------------------------------------------------
0375                       ; Exit
0376                       ;------------------------------------------------------
0377 7E86 0460  28         b     @edkey.action.cmdb.show
     7E88 6848 
0378                                                   ; Show dialog in CMDB pane
0379               
0380               
0381               ***************************************************************
0382               * Trampoline 2 (bank 3 with return)
0383               ********|*****|*********************|**************************
0384               _trampoline.bank3.ret:
0385 7E8A 0649  14         dect  stack
0386 7E8C C64B  30         mov   r11,*stack            ; Save return address
0387                       ;------------------------------------------------------
0388                       ; Show dialog
0389                       ;------------------------------------------------------
0390 7E8E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E90 3008 
0391 7E92 6006                   data bank3.rom        ; | i  p0 = bank address
0392 7E94 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0393                                                   ; |         (deref @parm1)
0394 7E96 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0395                       ;------------------------------------------------------
0396                       ; Exit
0397                       ;------------------------------------------------------
0398 7E98 C2F9  30         mov   *stack+,r11           ; Pop r11
0399 7E9A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1406079
0192                       ;-----------------------------------------------------------------------
0193                       ; Program data
0194                       ;-----------------------------------------------------------------------
0195                       copy  "data.keymap.actions.asm"; Data segment - Keyboard actions
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
0011 7E9C 0D00             byte  key.enter, pane.focus.fb
0012 7E9E 6568             data  edkey.action.enter
0013               
0014 7EA0 0800             byte  key.fctn.s, pane.focus.fb
0015 7EA2 6190             data  edkey.action.left
0016               
0017 7EA4 0900             byte  key.fctn.d, pane.focus.fb
0018 7EA6 61AA             data  edkey.action.right
0019               
0020 7EA8 0B00             byte  key.fctn.e, pane.focus.fb
0021 7EAA 62A2             data  edkey.action.up
0022               
0023 7EAC 0A00             byte  key.fctn.x, pane.focus.fb
0024 7EAE 62AA             data  edkey.action.down
0025               
0026 7EB0 BF00             byte  key.fctn.h, pane.focus.fb
0027 7EB2 61C6             data  edkey.action.home
0028               
0029 7EB4 C000             byte  key.fctn.j, pane.focus.fb
0030 7EB6 61F0             data  edkey.action.pword
0031               
0032 7EB8 C100             byte  key.fctn.k, pane.focus.fb
0033 7EBA 6242             data  edkey.action.nword
0034               
0035 7EBC C200             byte  key.fctn.l, pane.focus.fb
0036 7EBE 61CE             data  edkey.action.end
0037               
0038 7EC0 0C00             byte  key.fctn.6, pane.focus.fb
0039 7EC2 62B2             data  edkey.action.ppage
0040               
0041 7EC4 0200             byte  key.fctn.4, pane.focus.fb
0042 7EC6 62EE             data  edkey.action.npage
0043               
0044 7EC8 8500             byte  key.ctrl.e, pane.focus.fb
0045 7ECA 62B2             data  edkey.action.ppage
0046               
0047 7ECC 9800             byte  key.ctrl.x, pane.focus.fb
0048 7ECE 62EE             data  edkey.action.npage
0049               
0050 7ED0 9400             byte  key.ctrl.t, pane.focus.fb
0051 7ED2 6328             data  edkey.action.top
0052               
0053 7ED4 8200             byte  key.ctrl.b, pane.focus.fb
0054 7ED6 6344             data  edkey.action.bot
0055                       ;-------------------------------------------------------
0056                       ; Modifier keys - Delete
0057                       ;-------------------------------------------------------
0058 7ED8 0300             byte  key.fctn.1, pane.focus.fb
0059 7EDA 63B6             data  edkey.action.del_char
0060               
0061 7EDC 0700             byte  key.fctn.3, pane.focus.fb
0062 7EDE 6468             data  edkey.action.del_line
0063               
0064 7EE0 0200             byte  key.fctn.4, pane.focus.fb
0065 7EE2 6434             data  edkey.action.del_eol
0066                       ;-------------------------------------------------------
0067                       ; Modifier keys - Insert
0068                       ;-------------------------------------------------------
0069 7EE4 0400             byte  key.fctn.2, pane.focus.fb
0070 7EE6 64CA             data  edkey.action.ins_char.ws
0071               
0072 7EE8 B900             byte  key.fctn.dot, pane.focus.fb
0073 7EEA 65E0             data  edkey.action.ins_onoff
0074               
0075 7EEC 0100             byte  key.fctn.7, pane.focus.fb
0076 7EEE 679A             data  edkey.action.fb.tab.next
0077               
0078 7EF0 0600             byte  key.fctn.8, pane.focus.fb
0079 7EF2 6560             data  edkey.action.ins_line
0080                       ;-------------------------------------------------------
0081                       ; Block marking/modifier
0082                       ;-------------------------------------------------------
0083 7EF4 9600             byte  key.ctrl.v, pane.focus.fb
0084 7EF6 66D4             data  edkey.action.block.mark
0085               
0086 7EF8 8300             byte  key.ctrl.c, pane.focus.fb
0087 7EFA 66E8             data  edkey.action.block.copy
0088               
0089 7EFC 8400             byte  key.ctrl.d, pane.focus.fb
0090 7EFE 6724             data  edkey.action.block.delete
0091               
0092 7F00 8D00             byte  key.ctrl.m, pane.focus.fb
0093 7F02 674E             data  edkey.action.block.move
0094               
0095 7F04 8700             byte  key.ctrl.g, pane.focus.fb
0096 7F06 6780             data  edkey.action.block.goto.m1
0097                       ;-------------------------------------------------------
0098                       ; Other action keys
0099                       ;-------------------------------------------------------
0100 7F08 0500             byte  key.fctn.plus, pane.focus.fb
0101 7F0A 665A             data  edkey.action.quit
0102               
0103 7F0C 9100             byte  key.ctrl.q, pane.focus.fb
0104 7F0E 665A             data  edkey.action.quit
0105               
0106 7F10 9500             byte  key.ctrl.u, pane.focus.fb
0107 7F12 6668             data  edkey.action.toggle.ruler
0108               
0109 7F14 9A00             byte  key.ctrl.z, pane.focus.fb
0110 7F16 7696             data  pane.action.colorscheme.cycle
0111               
0112 7F18 8000             byte  key.ctrl.comma, pane.focus.fb
0113 7F1A 668E             data  edkey.action.fb.fname.dec.load
0114               
0115 7F1C 9B00             byte  key.ctrl.dot, pane.focus.fb
0116 7F1E 669A             data  edkey.action.fb.fname.inc.load
0117                       ;-------------------------------------------------------
0118                       ; Dialog keys
0119                       ;-------------------------------------------------------
0120 7F20 8800             byte  key.ctrl.h, pane.focus.fb
0121 7F22 7DA4             data  edkey.action.about
0122               
0123 7F24 8600             byte  key.ctrl.f, pane.focus.fb
0124 7F26 7DD0             data  dialog.file
0125               
0126 7F28 9300             byte  key.ctrl.s, pane.focus.fb
0127 7F2A 7DB8             data  dialog.save
0128               
0129 7F2C 8F00             byte  key.ctrl.o, pane.focus.fb
0130 7F2E 7DAE             data  dialog.load
0131               
0132                       ;
0133                       ; FCTN-9 has multipe purposes, if block mode is on it
0134                       ; resets the block, otherwise show Stevie menu dialog.
0135                       ;
0136 7F30 0F00             byte  key.fctn.9, pane.focus.fb
0137 7F32 7DDA             data  dialog.menu
0138                       ;-------------------------------------------------------
0139                       ; End of list
0140                       ;-------------------------------------------------------
0141 7F34 FFFF             data  EOL                           ; EOL
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
0152 7F36 4664             byte  key.uc.f, id.dialog.menu
0153 7F38 7DD0             data  dialog.file
0154               
0155 7F3A 4264             byte  key.uc.b, id.dialog.menu
0156 7F3C 7DFE             data  run.tibasic
0157               
0158 7F3E 4864             byte  key.uc.h, id.dialog.menu
0159 7F40 7DA4             data  edkey.action.about
0160               
0161 7F42 5164             byte  key.uc.q, id.dialog.menu
0162 7F44 665A             data  edkey.action.quit
0163                       ;-------------------------------------------------------
0164                       ; Dialog: File
0165                       ;-------------------------------------------------------
0166 7F46 4E68             byte  key.uc.n, id.dialog.file
0167 7F48 685A             data  edkey.action.cmdb.file.new
0168               
0169 7F4A 5368             byte  key.uc.s, id.dialog.file
0170 7F4C 7DB8             data  dialog.save
0171               
0172 7F4E 4F68             byte  key.uc.o, id.dialog.file
0173 7F50 7DAE             data  dialog.load
0174                       ;-------------------------------------------------------
0175                       ; Dialog: Open DV80 file
0176                       ;-------------------------------------------------------
0177 7F52 0E0A             byte  key.fctn.5, id.dialog.load
0178 7F54 694C             data  edkey.action.cmdb.fastmode.toggle
0179               
0180 7F56 0D0A             byte  key.enter, id.dialog.load
0181 7F58 687E             data  edkey.action.cmdb.load
0182                       ;-------------------------------------------------------
0183                       ; Dialog: Unsaved changes
0184                       ;-------------------------------------------------------
0185 7F5A 0C65             byte  key.fctn.6, id.dialog.unsaved
0186 7F5C 6922             data  edkey.action.cmdb.proceed
0187               
0188 7F5E 0D65             byte  key.enter, id.dialog.unsaved
0189 7F60 7DB8             data  dialog.save
0190                       ;-------------------------------------------------------
0191                       ; Dialog: Save DV80 file
0192                       ;-------------------------------------------------------
0193 7F62 0D0B             byte  key.enter, id.dialog.save
0194 7F64 68C2             data  edkey.action.cmdb.save
0195               
0196 7F66 0D0C             byte  key.enter, id.dialog.saveblock
0197 7F68 68C2             data  edkey.action.cmdb.save
0198                       ;-------------------------------------------------------
0199                       ; Dialog: Basic
0200                       ;-------------------------------------------------------
0201 7F6A 4269             byte  key.uc.b, id.dialog.basic
0202 7F6C 7DFE             data  run.tibasic
0203               
0204                       ;-------------------------------------------------------
0205                       ; Dialog: About
0206                       ;-------------------------------------------------------
0207 7F6E 0F67             byte  key.fctn.9, id.dialog.about
0208 7F70 6958             data  edkey.action.cmdb.close.about
0209                       ;-------------------------------------------------------
0210                       ; Movement keys
0211                       ;-------------------------------------------------------
0212 7F72 0801             byte  key.fctn.s, pane.focus.cmdb
0213 7F74 67A8             data  edkey.action.cmdb.left
0214               
0215 7F76 0901             byte  key.fctn.d, pane.focus.cmdb
0216 7F78 67BA             data  edkey.action.cmdb.right
0217               
0218 7F7A BF01             byte  key.fctn.h, pane.focus.cmdb
0219 7F7C 67D2             data  edkey.action.cmdb.home
0220               
0221 7F7E C201             byte  key.fctn.l, pane.focus.cmdb
0222 7F80 67E6             data  edkey.action.cmdb.end
0223                       ;-------------------------------------------------------
0224                       ; Modifier keys
0225                       ;-------------------------------------------------------
0226 7F82 0701             byte  key.fctn.3, pane.focus.cmdb
0227 7F84 67FE             data  edkey.action.cmdb.clear
0228                       ;-------------------------------------------------------
0229                       ; Other action keys
0230                       ;-------------------------------------------------------
0231 7F86 0F01             byte  key.fctn.9, pane.focus.cmdb
0232 7F88 6964             data  edkey.action.cmdb.close.dialog
0233               
0234 7F8A 0501             byte  key.fctn.plus, pane.focus.cmdb
0235 7F8C 665A             data  edkey.action.quit
0236               
0237 7F8E 9A01             byte  key.ctrl.z, pane.focus.cmdb
0238 7F90 7696             data  pane.action.colorscheme.cycle
0239                       ;------------------------------------------------------
0240                       ; End of list
0241                       ;-------------------------------------------------------
0242 7F92 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.1406079
0196                       ;-----------------------------------------------------------------------
0197                       ; Bank full check
0198                       ;-----------------------------------------------------------------------
0202                       ;-----------------------------------------------------------------------
0203                       ; Vector table
0204                       ;-----------------------------------------------------------------------
0205                       aorg  >7fc0
0206                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 6D76     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0008 7FC2 6C2E     vec.2   data  idx.entry.update      ;    for index functions.
0009 7FC4 6CDC     vec.3   data  idx.entry.delete      ;
0010 7FC6 6C80     vec.4   data  idx.pointer.get       ;
0011 7FC8 2026     vec.5   data  cpu.crash             ;
0012 7FCA 2026     vec.6   data  cpu.crash             ;
0013 7FCC 2026     vec.7   data  cpu.crash             ;
0014 7FCE 2026     vec.8   data  cpu.crash             ;
0015 7FD0 2026     vec.9   data  cpu.crash             ;
0016 7FD2 6E5E     vec.10  data  edb.line.pack.fb      ;
0017 7FD4 6F56     vec.11  data  edb.line.unpack.fb    ;
0018 7FD6 2026     vec.12  data  cpu.crash             ;
0019 7FD8 2026     vec.13  data  cpu.crash             ;
0020 7FDA 2026     vec.14  data  cpu.crash             ;
0021 7FDC 6848     vec.15  data  edkey.action.cmdb.show
0022 7FDE 2026     vec.16  data  cpu.crash             ;
0023 7FE0 2026     vec.17  data  cpu.crash             ;
0024 7FE2 2026     vec.18  data  cpu.crash             ;
0025 7FE4 7E12     vec.19  data  cmdb.cmd.clear        ;
0026 7FE6 6B82     vec.20  data  fb.refresh            ;
0027 7FE8 7E66     vec.21  data  fb.vdpdump            ;
0028 7FEA 2026     vec.22  data  cpu.crash             ;
0029 7FEC 2026     vec.23  data  cpu.crash             ;
0030 7FEE 2026     vec.24  data  cpu.crash             ;
0031 7FF0 2026     vec.25  data  cpu.crash             ;
0032 7FF2 2026     vec.26  data  cpu.crash             ;
0033 7FF4 2026     vec.27  data  cpu.crash             ;
0034 7FF6 789E     vec.28  data  pane.cursor.blink     ;
0035 7FF8 7880     vec.29  data  pane.cursor.hide      ;
0036 7FFA 7B4E     vec.30  data  pane.errline.show     ;
0037 7FFC 76F4     vec.31  data  pane.action.colorscheme.load
0038 7FFE 7866     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.1406079
0207                                                   ; Vector table bank 1
0208               *--------------------------------------------------------------
0209               * Video mode configuration
0210               *--------------------------------------------------------------
0211      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0212      0004     spfbck  equ   >04                   ; Screen background color.
0213      33B0     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0214      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0215      0050     colrow  equ   80                    ; Columns per row
0216      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0217      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0218      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0219      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

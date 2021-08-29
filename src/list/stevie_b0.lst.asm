XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.asm.1400279
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 210829-1400279
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
**** **** ****     > stevie_b0.asm.1400279
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
**** **** ****     > stevie_b0.asm.1400279
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
**** **** ****     > stevie_b0.asm.1400279
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
0045 6011 ....             text  'STEVIE 1.1S'
0046                       even
0047               
0049               
**** **** ****     > stevie_b0.asm.1400279
0030               
0031               ***************************************************************
0032               * Step 1: Switch to bank 0 (uniform code accross all banks)
0033               ********|*****|*********************|**************************
0034                       aorg  kickstart.code1       ; >6040
0035 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0036               ***************************************************************
0037               * Step 2: Copy spectra2 core library from ROM to >2000 - >2fff
0038               ********|*****|*********************|**************************
0039 6044 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
     6046 609A 
0040 6048 0201  20         li    r1,>2000
     604A 2000 
0041 604C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     604E 0100 
0042 6050 06A0  32         bl    @kickstart.copy       ; Copy memory
     6052 6084 
0043               ***************************************************************
0044               * Step 3: Copy spectra2 extended library from ROM to >f000 - >ffff
0045               ********|*****|*********************|**************************
0046 6054 0200  20         li    r0,reloc.sp2ext       ; Start of code to relocate
     6056 7000 
0047 6058 0201  20         li    r1,>f000
     605A F000 
0048 605C 0202  20         li    r2,16                 ; Copy 128 bytes (16 * 16 bytes)
     605E 0010 
0049 6060 06A0  32         bl    @kickstart.copy       ; Copy memory
     6062 6084 
0050               ***************************************************************
0051               * Step 4: Copy Stevie resident modules from ROM to >3000 - >3fff
0052               ********|*****|*********************|**************************
0053 6064 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
     6066 706A 
0054 6068 0201  20         li    r1,>3000
     606A 3000 
0055 606C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     606E 0100 
0056 6070 06A0  32         bl    @kickstart.copy       ; Copy memory
     6072 6084 
0057               ***************************************************************
0058               * Step 5: Start SP2 kernel (runs in low MEMEXP)
0059               ********|*****|*********************|**************************
0060 6074 0460  28         b     @runlib               ; Start spectra2 library
     6076 2E56 
0061                       ;------------------------------------------------------
0062                       ; Assert. Should not get here! Crash and burn!
0063                       ;------------------------------------------------------
0064 6078 0200  20         li    r0,$                  ; Current location
     607A 6078 
0065 607C C800  38         mov   r0,@>ffce             ; \ Save caller address
     607E FFCE 
0066 6080 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6082 2026 
0067               ***************************************************************
0068               * Step 5: Handover from SP2 to Stevie "main" in low MEMEXP
0069               ********|*****|*********************|**************************
0070                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0071               
0072               ***************************************************************
0073               * Copy routine
0074               ********|*****|*********************|**************************
0075               kickstart.copy:
0076                       ;------------------------------------------------------
0077                       ; Copy memory to destination
0078                       ; r0 = Source CPU address
0079                       ; r1 = Target CPU address
0080                       ; r2 = Bytes to copy/16
0081                       ;------------------------------------------------------
0082 6084 CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0083 6086 CC70  46         mov   *r0+,*r1+             ; Copy word 2
0084 6088 CC70  46         mov   *r0+,*r1+             ; Copy word 3
0085 608A CC70  46         mov   *r0+,*r1+             ; Copy word 4
0086 608C CC70  46         mov   *r0+,*r1+             ; Copy word 5
0087 608E CC70  46         mov   *r0+,*r1+             ; Copy word 6
0088 6090 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0089 6092 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0090 6094 0602  14         dec   r2
0091 6096 16F6  14         jne   -!                    ; Loop until done
0092 6098 045B  20         b     *r11                  ; Return to caller
0093               
0094               
0095               ***************************************************************
0096               * Code data: Relocated code SP2 >2000 - >2f1f (3840 bytes max)
0097               ********|*****|*********************|**************************
0098               reloc.sp2:
0099                       ;------------------------------------------------------
0100                       ; spectra2 core library
0101                       ;------------------------------------------------------
0102                       xorg  >2000                 ; Relocate to >2000
0103                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0012 609A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 609C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 609E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 60A0 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 60A2 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 60A4 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 60A6 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 60A8 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 60AA 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 60AC 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 60AE 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 60B0 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 60B2 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 60B4 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 60B6 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 60B8 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 60BA 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 60BC FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 60BE D000     w$d000  data  >d000                 ; >d000
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
0038 60C0 022B  22         ai    r11,-4                ; Remove opcode offset
     60C2 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60C4 C800  38         mov   r0,@>ffe0
     60C6 FFE0 
0043 60C8 C801  38         mov   r1,@>ffe2
     60CA FFE2 
0044 60CC C802  38         mov   r2,@>ffe4
     60CE FFE4 
0045 60D0 C803  38         mov   r3,@>ffe6
     60D2 FFE6 
0046 60D4 C804  38         mov   r4,@>ffe8
     60D6 FFE8 
0047 60D8 C805  38         mov   r5,@>ffea
     60DA FFEA 
0048 60DC C806  38         mov   r6,@>ffec
     60DE FFEC 
0049 60E0 C807  38         mov   r7,@>ffee
     60E2 FFEE 
0050 60E4 C808  38         mov   r8,@>fff0
     60E6 FFF0 
0051 60E8 C809  38         mov   r9,@>fff2
     60EA FFF2 
0052 60EC C80A  38         mov   r10,@>fff4
     60EE FFF4 
0053 60F0 C80B  38         mov   r11,@>fff6
     60F2 FFF6 
0054 60F4 C80C  38         mov   r12,@>fff8
     60F6 FFF8 
0055 60F8 C80D  38         mov   r13,@>fffa
     60FA FFFA 
0056 60FC C80E  38         mov   r14,@>fffc
     60FE FFFC 
0057 6100 C80F  38         mov   r15,@>ffff
     6102 FFFF 
0058 6104 02A0  12         stwp  r0
0059 6106 C800  38         mov   r0,@>ffdc
     6108 FFDC 
0060 610A 02C0  12         stst  r0
0061 610C C800  38         mov   r0,@>ffde
     610E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 6110 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6112 8300 
0067 6114 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6116 8302 
0068 6118 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     611A 4A4A 
0069 611C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     611E 2E5A 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 6120 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6122 2306 
0078 6124 21EC                   data graph1           ; Equate selected video mode table
0079               
0080 6126 06A0  32         bl    @ldfnt
     6128 236E 
0081 612A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     612C 000C 
0082               
0083 612E 06A0  32         bl    @filv
     6130 229C 
0084 6132 0380                   data >0380,>f0,32*24  ; Load color table
     6134 00F0 
     6136 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 6138 06A0  32         bl    @putat                ; Show crash message
     613A 2450 
0089 613C 0000                   data >0000,cpu.crash.msg.crashed
     613E 2178 
0090               
0091 6140 06A0  32         bl    @puthex               ; Put hex value on screen
     6142 29DE 
0092 6144 0015                   byte 0,21             ; \ i  p0 = YX position
0093 6146 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 6148 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 614A 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 614C 06A0  32         bl    @putat                ; Show caller message
     614E 2450 
0101 6150 0100                   data >0100,cpu.crash.msg.caller
     6152 218E 
0102               
0103 6154 06A0  32         bl    @puthex               ; Put hex value on screen
     6156 29DE 
0104 6158 0115                   byte 1,21             ; \ i  p0 = YX position
0105 615A FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 615C 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 615E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 6160 06A0  32         bl    @putat
     6162 2450 
0113 6164 0300                   byte 3,0
0114 6166 21AA                   data cpu.crash.msg.wp
0115 6168 06A0  32         bl    @putat
     616A 2450 
0116 616C 0400                   byte 4,0
0117 616E 21B0                   data cpu.crash.msg.st
0118 6170 06A0  32         bl    @putat
     6172 2450 
0119 6174 1600                   byte 22,0
0120 6176 21B6                   data cpu.crash.msg.source
0121 6178 06A0  32         bl    @putat
     617A 2450 
0122 617C 1700                   byte 23,0
0123 617E 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 6180 06A0  32         bl    @at                   ; Put cursor at YX
     6182 26DC 
0128 6184 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6186 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6188 FFDC 
0132 618A 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 618C C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 618E 0649  14         dect  stack
0138 6190 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 6192 0649  14         dect  stack
0140 6194 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6196 0649  14         dect  stack
0142 6198 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 619A C046  18         mov   tmp2,r1               ; Save register number
0148 619C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     619E 0001 
0149 61A0 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 61A2 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 61A4 06A0  32         bl    @mknum
     61A6 29E8 
0154 61A8 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 61AA 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 61AC 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 61AE 06A0  32         bl    @setx                 ; Set cursor X position
     61B0 26F2 
0160 61B2 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 61B4 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61B6 242C 
0164 61B8 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 61BA 06A0  32         bl    @setx                 ; Set cursor X position
     61BC 26F2 
0168 61BE 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 61C0 0281  22         ci    r1,10
     61C2 000A 
0172 61C4 1102  14         jlt   !
0173 61C6 0620  34         dec   @wyx                  ; x=x-1
     61C8 832A 
0174               
0175 61CA 06A0  32 !       bl    @putstr
     61CC 242C 
0176 61CE 21A4                   data cpu.crash.msg.r
0177               
0178 61D0 06A0  32         bl    @mknum
     61D2 29E8 
0179 61D4 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 61D6 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 61D8 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 61DA 06A0  32         bl    @mkhex                ; Convert hex word to string
     61DC 295A 
0188 61DE 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 61E0 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 61E2 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 61E4 06A0  32         bl    @setx                 ; Set cursor X position
     61E6 26F2 
0194 61E8 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 61EA 06A0  32         bl    @putstr               ; Put '  >'
     61EC 242C 
0198 61EE 21A6                   data cpu.crash.msg.marker
0199               
0200 61F0 06A0  32         bl    @setx                 ; Set cursor X position
     61F2 26F2 
0201 61F4 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61F6 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61F8 242C 
0205 61FA 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61FC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61FE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 6200 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 6202 06A0  32         bl    @down                 ; y=y+1
     6204 26E2 
0213               
0214 6206 0586  14         inc   tmp2
0215 6208 0286  22         ci    tmp2,17
     620A 0011 
0216 620C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 620E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     6210 2D58 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 6212 1553             byte  21
0225 6213 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 6228 1543             byte  21
0230 6229 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 623E 0152             byte  1
0235 623F ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 6240 0320             byte  3
0240 6241 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 6244 042A             byte  4
0245 6245 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 624A 042A             byte  4
0250 624B ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 6250 1B53             byte  27
0255 6251 ....             text  'Source    stevie_b0.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 626C 1842             byte  24
0260 626D ....             text  'Build-ID  210829-1400279'
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
0007 6286 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6288 000E 
     628A 0106 
     628C 0204 
     628E 0020 
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
0033 6290 00E2     tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
     6292 000C 
     6294 0006 
     6296 0004 
     6298 0020 
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
0060 629A 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     629C 000E 
     629E 0106 
     62A0 00F4 
     62A2 0028 
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
0086 62A4 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     62A6 003F 
     62A8 0240 
     62AA 03F4 
     62AC 0050 
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
0112 62AE 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     62B0 003F 
     62B2 0240 
     62B4 03F4 
     62B6 0050 
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
0013 62B8 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 62BA 16FD             data  >16fd                 ; |         jne   mcloop
0015 62BC 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 62BE D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 62C0 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 62C2 0201  20         li    r1,mccode             ; Machinecode to patch
     62C4 221E 
0037 62C6 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     62C8 8322 
0038 62CA CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62CC CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62CE CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62D0 045B  20         b     *r11                  ; Return to caller
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
0056 62D2 C0F9  30 popr3   mov   *stack+,r3
0057 62D4 C0B9  30 popr2   mov   *stack+,r2
0058 62D6 C079  30 popr1   mov   *stack+,r1
0059 62D8 C039  30 popr0   mov   *stack+,r0
0060 62DA C2F9  30 poprt   mov   *stack+,r11
0061 62DC 045B  20         b     *r11
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
0085 62DE C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 62E0 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 62E2 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 62E4 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 62E6 1604  14         jne   filchk                ; No, continue checking
0093               
0094 62E8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62EA FFCE 
0095 62EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62EE 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62F0 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62F2 830B 
     62F4 830A 
0100               
0101 62F6 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62F8 0001 
0102 62FA 1602  14         jne   filchk2
0103 62FC DD05  32         movb  tmp1,*tmp0+
0104 62FE 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 6300 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6302 0002 
0109 6304 1603  14         jne   filchk3
0110 6306 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 6308 DD05  32         movb  tmp1,*tmp0+
0112 630A 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 630C C1C4  18 filchk3 mov   tmp0,tmp3
0117 630E 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6310 0001 
0118 6312 1305  14         jeq   fil16b
0119 6314 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 6316 0606  14         dec   tmp2
0121 6318 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     631A 0002 
0122 631C 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 631E C1C6  18 fil16b  mov   tmp2,tmp3
0127 6320 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6322 0001 
0128 6324 1301  14         jeq   dofill
0129 6326 0606  14         dec   tmp2                  ; Make TMP2 even
0130 6328 CD05  34 dofill  mov   tmp1,*tmp0+
0131 632A 0646  14         dect  tmp2
0132 632C 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 632E C1C7  18         mov   tmp3,tmp3
0137 6330 1301  14         jeq   fil.exit
0138 6332 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 6334 045B  20         b     *r11
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
0159 6336 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 6338 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 633A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 633C 0264  22 xfilv   ori   tmp0,>4000
     633E 4000 
0166 6340 06C4  14         swpb  tmp0
0167 6342 D804  38         movb  tmp0,@vdpa
     6344 8C02 
0168 6346 06C4  14         swpb  tmp0
0169 6348 D804  38         movb  tmp0,@vdpa
     634A 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 634C 020F  20         li    r15,vdpw              ; Set VDP write address
     634E 8C00 
0174 6350 06C5  14         swpb  tmp1
0175 6352 C820  54         mov   @filzz,@mcloop        ; Setup move command
     6354 22C2 
     6356 8320 
0176 6358 0460  28         b     @mcloop               ; Write data to VDP
     635A 8320 
0177               *--------------------------------------------------------------
0181 635C D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 635E 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6360 4000 
0202 6362 06C4  14 vdra    swpb  tmp0
0203 6364 D804  38         movb  tmp0,@vdpa
     6366 8C02 
0204 6368 06C4  14         swpb  tmp0
0205 636A D804  38         movb  tmp0,@vdpa            ; Set VDP address
     636C 8C02 
0206 636E 045B  20         b     *r11                  ; Exit
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
0217 6370 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6372 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 6374 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6376 4000 
0223 6378 06C4  14         swpb  tmp0                  ; \
0224 637A D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     637C 8C02 
0225 637E 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6380 D804  38         movb  tmp0,@vdpa            ; /
     6382 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 6384 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6386 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 6388 045B  20         b     *r11                  ; Exit
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
0251 638A C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 638C 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 638E D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6390 8C02 
0257 6392 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 6394 D804  38         movb  tmp0,@vdpa            ; /
     6396 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 6398 D120  34         movb  @vdpr,tmp0            ; Read byte
     639A 8800 
0263 639C 0984  56         srl   tmp0,8                ; Right align
0264 639E 045B  20         b     *r11                  ; Exit
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
0283 63A0 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 63A2 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 63A4 C144  18         mov   tmp0,tmp1
0289 63A6 05C5  14         inct  tmp1
0290 63A8 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 63AA 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     63AC FF00 
0292 63AE 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 63B0 C805  38         mov   tmp1,@wbase           ; Store calculated base
     63B2 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 63B4 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     63B6 8000 
0298 63B8 0206  20         li    tmp2,8
     63BA 0008 
0299 63BC D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     63BE 830B 
0300 63C0 06C5  14         swpb  tmp1
0301 63C2 D805  38         movb  tmp1,@vdpa
     63C4 8C02 
0302 63C6 06C5  14         swpb  tmp1
0303 63C8 D805  38         movb  tmp1,@vdpa
     63CA 8C02 
0304 63CC 0225  22         ai    tmp1,>0100
     63CE 0100 
0305 63D0 0606  14         dec   tmp2
0306 63D2 16F4  14         jne   vidta1                ; Next register
0307 63D4 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     63D6 833A 
0308 63D8 045B  20         b     *r11
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
0325 63DA C13B  30 putvr   mov   *r11+,tmp0
0326 63DC 0264  22 putvrx  ori   tmp0,>8000
     63DE 8000 
0327 63E0 06C4  14         swpb  tmp0
0328 63E2 D804  38         movb  tmp0,@vdpa
     63E4 8C02 
0329 63E6 06C4  14         swpb  tmp0
0330 63E8 D804  38         movb  tmp0,@vdpa
     63EA 8C02 
0331 63EC 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 63EE C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63F0 C10E  18         mov   r14,tmp0
0341 63F2 0984  56         srl   tmp0,8
0342 63F4 06A0  32         bl    @putvrx               ; Write VR#0
     63F6 2342 
0343 63F8 0204  20         li    tmp0,>0100
     63FA 0100 
0344 63FC D820  54         movb  @r14lb,@tmp0lb
     63FE 831D 
     6400 8309 
0345 6402 06A0  32         bl    @putvrx               ; Write VR#1
     6404 2342 
0346 6406 0458  20         b     *tmp4                 ; Exit
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
0360 6408 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 640A 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 640C C11B  26         mov   *r11,tmp0             ; Get P0
0363 640E 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6410 7FFF 
0364 6412 2120  38         coc   @wbit0,tmp0
     6414 2020 
0365 6416 1604  14         jne   ldfnt1
0366 6418 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     641A 8000 
0367 641C 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     641E 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 6420 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6422 23F0 
0372 6424 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6426 9C02 
0373 6428 06C4  14         swpb  tmp0
0374 642A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     642C 9C02 
0375 642E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6430 9800 
0376 6432 06C5  14         swpb  tmp1
0377 6434 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6436 9800 
0378 6438 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 643A D805  38         movb  tmp1,@grmwa
     643C 9C02 
0383 643E 06C5  14         swpb  tmp1
0384 6440 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6442 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 6444 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 6446 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     6448 22C4 
0390 644A 05C8  14         inct  tmp4                  ; R11=R11+2
0391 644C C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 644E 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6450 7FFF 
0393 6452 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6454 23F2 
0394 6456 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6458 23F4 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 645A 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 645C 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 645E D120  34         movb  @grmrd,tmp0
     6460 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 6462 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6464 2020 
0405 6466 1603  14         jne   ldfnt3                ; No, so skip
0406 6468 D1C4  18         movb  tmp0,tmp3
0407 646A 0917  56         srl   tmp3,1
0408 646C E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 646E D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6470 8C00 
0413 6472 0606  14         dec   tmp2
0414 6474 16F2  14         jne   ldfnt2
0415 6476 05C8  14         inct  tmp4                  ; R11=R11+2
0416 6478 020F  20         li    r15,vdpw              ; Set VDP write address
     647A 8C00 
0417 647C 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     647E 7FFF 
0418 6480 0458  20         b     *tmp4                 ; Exit
0419 6482 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6484 2000 
     6486 8C00 
0420 6488 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 648A 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     648C 0200 
     648E 0000 
0425 6490 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6492 01C0 
     6494 0101 
0426 6496 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6498 02A0 
     649A 0101 
0427 649C 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     649E 00E0 
     64A0 0101 
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
0445 64A2 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 64A4 C3A0  34         mov   @wyx,r14              ; Get YX
     64A6 832A 
0447 64A8 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 64AA 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     64AC 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 64AE C3A0  34         mov   @wyx,r14              ; Get YX
     64B0 832A 
0454 64B2 024E  22         andi  r14,>00ff             ; Remove Y
     64B4 00FF 
0455 64B6 A3CE  18         a     r14,r15               ; pos = pos + X
0456 64B8 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     64BA 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 64BC C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 64BE C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 64C0 020F  20         li    r15,vdpw              ; VDP write address
     64C2 8C00 
0463 64C4 045B  20         b     *r11
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
0481 64C6 C17B  30 putstr  mov   *r11+,tmp1
0482 64C8 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 64CA C1CB  18 xutstr  mov   r11,tmp3
0484 64CC 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64CE 2408 
0485 64D0 C2C7  18         mov   tmp3,r11
0486 64D2 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 64D4 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 64D6 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 64D8 0286  22         ci    tmp2,255              ; Length > 255 ?
     64DA 00FF 
0494 64DC 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 64DE 0460  28         b     @xpym2v               ; Display string
     64E0 249A 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 64E2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64E4 FFCE 
0501 64E6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64E8 2026 
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
0517 64EA C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64EC 832A 
0518 64EE 0460  28         b     @putstr
     64F0 242C 
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
0539 64F2 0649  14         dect  stack
0540 64F4 C64B  30         mov   r11,*stack            ; Save return address
0541 64F6 0649  14         dect  stack
0542 64F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64FA D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64FC 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64FE 0649  14         dect  stack
0551 6500 C645  30         mov   tmp1,*stack           ; Push tmp1
0552 6502 0649  14         dect  stack
0553 6504 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 6506 0649  14         dect  stack
0555 6508 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 650A 06A0  32         bl    @xutst0               ; Display string
     650C 242E 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 650E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 6510 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 6512 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 6514 06A0  32         bl    @down                 ; Move cursor down
     6516 26E2 
0566               
0567 6518 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 651A 0585  14         inc   tmp1                  ; Consider length byte
0569 651C 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     651E 2002 
0570 6520 1301  14         jeq   !                     ; Yes, skip adjustment
0571 6522 0585  14         inc   tmp1                  ; Make address even
0572 6524 0606  14 !       dec   tmp2
0573 6526 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 6528 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 652A C2F9  30         mov   *stack+,r11           ; Pop r11
0580 652C 045B  20         b     *r11                  ; Return
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
0020 652E C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6530 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6532 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 6534 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 6536 1604  14         jne   !                     ; No, continue
0028               
0029 6538 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     653A FFCE 
0030 653C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     653E 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 6540 0264  22 !       ori   tmp0,>4000
     6542 4000 
0035 6544 06C4  14         swpb  tmp0
0036 6546 D804  38         movb  tmp0,@vdpa
     6548 8C02 
0037 654A 06C4  14         swpb  tmp0
0038 654C D804  38         movb  tmp0,@vdpa
     654E 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 6550 020F  20         li    r15,vdpw              ; Set VDP write address
     6552 8C00 
0043 6554 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6556 24C4 
     6558 8320 
0044 655A 0460  28         b     @mcloop               ; Write data to VDP and return
     655C 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 655E D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6560 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6562 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6564 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6566 06C4  14 xpyv2m  swpb  tmp0
0027 6568 D804  38         movb  tmp0,@vdpa
     656A 8C02 
0028 656C 06C4  14         swpb  tmp0
0029 656E D804  38         movb  tmp0,@vdpa
     6570 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6572 020F  20         li    r15,vdpr              ; Set VDP read address
     6574 8800 
0034 6576 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6578 24E6 
     657A 8320 
0035 657C 0460  28         b     @mcloop               ; Read data from VDP
     657E 8320 
0036 6580 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6582 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6584 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6586 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6588 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 658A 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 658C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     658E FFCE 
0034 6590 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6592 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6594 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6596 0001 
0039 6598 1603  14         jne   cpym0                 ; No, continue checking
0040 659A DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 659C 04C6  14         clr   tmp2                  ; Reset counter
0042 659E 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 65A0 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     65A2 7FFF 
0047 65A4 C1C4  18         mov   tmp0,tmp3
0048 65A6 0247  22         andi  tmp3,1
     65A8 0001 
0049 65AA 1618  14         jne   cpyodd                ; Odd source address handling
0050 65AC C1C5  18 cpym1   mov   tmp1,tmp3
0051 65AE 0247  22         andi  tmp3,1
     65B0 0001 
0052 65B2 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 65B4 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     65B6 2020 
0057 65B8 1605  14         jne   cpym3
0058 65BA C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     65BC 2548 
     65BE 8320 
0059 65C0 0460  28         b     @mcloop               ; Copy memory and exit
     65C2 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 65C4 C1C6  18 cpym3   mov   tmp2,tmp3
0064 65C6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     65C8 0001 
0065 65CA 1301  14         jeq   cpym4
0066 65CC 0606  14         dec   tmp2                  ; Make TMP2 even
0067 65CE CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 65D0 0646  14         dect  tmp2
0069 65D2 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 65D4 C1C7  18         mov   tmp3,tmp3
0074 65D6 1301  14         jeq   cpymz
0075 65D8 D554  38         movb  *tmp0,*tmp1
0076 65DA 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 65DC 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     65DE 8000 
0081 65E0 10E9  14         jmp   cpym2
0082 65E2 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 65E4 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 65E6 0649  14         dect  stack
0065 65E8 C64B  30         mov   r11,*stack            ; Push return address
0066 65EA 0649  14         dect  stack
0067 65EC C640  30         mov   r0,*stack             ; Push r0
0068 65EE 0649  14         dect  stack
0069 65F0 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 65F2 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 65F4 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65F6 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65F8 4000 
0077 65FA C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65FC 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65FE 020C  20         li    r12,>1e00             ; SAMS CRU address
     6600 1E00 
0082 6602 04C0  14         clr   r0
0083 6604 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 6606 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 6608 D100  18         movb  r0,tmp0
0086 660A 0984  56         srl   tmp0,8                ; Right align
0087 660C C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     660E 833C 
0088 6610 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 6612 C339  30         mov   *stack+,r12           ; Pop r12
0094 6614 C039  30         mov   *stack+,r0            ; Pop r0
0095 6616 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 6618 045B  20         b     *r11                  ; Return to caller
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
0131 661A C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 661C C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 661E 0649  14         dect  stack
0135 6620 C64B  30         mov   r11,*stack            ; Push return address
0136 6622 0649  14         dect  stack
0137 6624 C640  30         mov   r0,*stack             ; Push r0
0138 6626 0649  14         dect  stack
0139 6628 C64C  30         mov   r12,*stack            ; Push r12
0140 662A 0649  14         dect  stack
0141 662C C644  30         mov   tmp0,*stack           ; Push tmp0
0142 662E 0649  14         dect  stack
0143 6630 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6632 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 6634 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 6636 0284  22         ci    tmp0,255              ; Crash if page > 255
     6638 00FF 
0153 663A 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 663C 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     663E 001E 
0158 6640 150A  14         jgt   !
0159 6642 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     6644 0004 
0160 6646 1107  14         jlt   !
0161 6648 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     664A 0012 
0162 664C 1508  14         jgt   sams.page.set.switch_page
0163 664E 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6650 0006 
0164 6652 1501  14         jgt   !
0165 6654 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 6656 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6658 FFCE 
0170 665A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     665C 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 665E 020C  20         li    r12,>1e00             ; SAMS CRU address
     6660 1E00 
0176 6662 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 6664 06C0  14         swpb  r0                    ; LSB to MSB
0178 6666 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6668 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     666A 4000 
0180 666C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 666E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6670 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6672 C339  30         mov   *stack+,r12           ; Pop r12
0188 6674 C039  30         mov   *stack+,r0            ; Pop r0
0189 6676 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 6678 045B  20         b     *r11                  ; Return to caller
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
0204 667A 020C  20         li    r12,>1e00             ; SAMS CRU address
     667C 1E00 
0205 667E 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6680 045B  20         b     *r11                  ; Return to caller
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
0227 6682 020C  20         li    r12,>1e00             ; SAMS CRU address
     6684 1E00 
0228 6686 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6688 045B  20         b     *r11                  ; Return to caller
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
0260 668A C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 668C 0649  14         dect  stack
0263 668E C64B  30         mov   r11,*stack            ; Save return address
0264 6690 0649  14         dect  stack
0265 6692 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 6694 0649  14         dect  stack
0267 6696 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6698 0649  14         dect  stack
0269 669A C646  30         mov   tmp2,*stack           ; Save tmp2
0270 669C 0649  14         dect  stack
0271 669E C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 66A0 0206  20         li    tmp2,8                ; Set loop counter
     66A2 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 66A4 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 66A6 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 66A8 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     66AA 2584 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 66AC 0606  14         dec   tmp2                  ; Next iteration
0288 66AE 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 66B0 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     66B2 25E0 
0294                                                   ; / activating changes.
0295               
0296 66B4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 66B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 66B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 66BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 66BC C2F9  30         mov   *stack+,r11           ; Pop r11
0301 66BE 045B  20         b     *r11                  ; Return to caller
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
0318 66C0 0649  14         dect  stack
0319 66C2 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 66C4 06A0  32         bl    @sams.layout
     66C6 25F0 
0324 66C8 2634                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 66CA C2F9  30         mov   *stack+,r11           ; Pop r11
0330 66CC 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 66CE 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     66D0 0002 
0336 66D2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     66D4 0003 
0337 66D6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     66D8 000A 
0338 66DA B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     66DC 000B 
0339 66DE C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     66E0 000C 
0340 66E2 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     66E4 000D 
0341 66E6 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     66E8 000E 
0342 66EA F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     66EC 000F 
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
0363 66EE C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 66F0 0649  14         dect  stack
0366 66F2 C64B  30         mov   r11,*stack            ; Push return address
0367 66F4 0649  14         dect  stack
0368 66F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66F8 0649  14         dect  stack
0370 66FA C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66FC 0649  14         dect  stack
0372 66FE C646  30         mov   tmp2,*stack           ; Push tmp2
0373 6700 0649  14         dect  stack
0374 6702 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 6704 0205  20         li    tmp1,sams.layout.copy.data
     6706 268C 
0379 6708 0206  20         li    tmp2,8                ; Set loop counter
     670A 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 670C C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 670E 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     6710 254C 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 6712 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     6714 833C 
0390               
0391 6716 0606  14         dec   tmp2                  ; Next iteration
0392 6718 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 671A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 671C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 671E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 6720 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 6722 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 6724 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 6726 2000             data  >2000                 ; >2000-2fff
0408 6728 3000             data  >3000                 ; >3000-3fff
0409 672A A000             data  >a000                 ; >a000-afff
0410 672C B000             data  >b000                 ; >b000-bfff
0411 672E C000             data  >c000                 ; >c000-cfff
0412 6730 D000             data  >d000                 ; >d000-dfff
0413 6732 E000             data  >e000                 ; >e000-efff
0414 6734 F000             data  >f000                 ; >f000-ffff
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
0009 6736 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6738 FFBF 
0010 673A 0460  28         b     @putv01
     673C 2354 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 673E 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6740 0040 
0018 6742 0460  28         b     @putv01
     6744 2354 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 6746 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6748 FFDF 
0026 674A 0460  28         b     @putv01
     674C 2354 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 674E 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6750 0020 
0034 6752 0460  28         b     @putv01
     6754 2354 
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
0010 6756 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6758 FFFE 
0011 675A 0460  28         b     @putv01
     675C 2354 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 675E 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6760 0001 
0019 6762 0460  28         b     @putv01
     6764 2354 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6766 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6768 FFFD 
0027 676A 0460  28         b     @putv01
     676C 2354 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 676E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6770 0002 
0035 6772 0460  28         b     @putv01
     6774 2354 
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
0018 6776 C83B  50 at      mov   *r11+,@wyx
     6778 832A 
0019 677A 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 677C B820  54 down    ab    @hb$01,@wyx
     677E 2012 
     6780 832A 
0028 6782 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6784 7820  54 up      sb    @hb$01,@wyx
     6786 2012 
     6788 832A 
0037 678A 045B  20         b     *r11
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
0049 678C C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 678E D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6790 832A 
0051 6792 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6794 832A 
0052 6796 045B  20         b     *r11
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
0021 6798 C120  34 yx2px   mov   @wyx,tmp0
     679A 832A 
0022 679C C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 679E 06C4  14         swpb  tmp0                  ; Y<->X
0024 67A0 04C5  14         clr   tmp1                  ; Clear before copy
0025 67A2 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 67A4 20A0  38         coc   @wbit1,config         ; f18a present ?
     67A6 201E 
0030 67A8 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 67AA 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     67AC 833A 
     67AE 273E 
0032 67B0 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 67B2 0A15  56         sla   tmp1,1                ; X = X * 2
0035 67B4 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 67B6 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     67B8 0500 
0037 67BA 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 67BC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 67BE 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 67C0 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 67C2 D105  18         movb  tmp1,tmp0
0051 67C4 06C4  14         swpb  tmp0                  ; X<->Y
0052 67C6 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     67C8 2020 
0053 67CA 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 67CC 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     67CE 2012 
0059 67D0 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     67D2 2024 
0060 67D4 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 67D6 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 67D8 0050            data   80
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
0013 67DA C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 67DC 06A0  32         bl    @putvr                ; Write once
     67DE 2340 
0015 67E0 391C             data  >391c                 ; VR1/57, value 00011100
0016 67E2 06A0  32         bl    @putvr                ; Write twice
     67E4 2340 
0017 67E6 391C             data  >391c                 ; VR1/57, value 00011100
0018 67E8 06A0  32         bl    @putvr
     67EA 2340 
0019 67EC 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 67EE 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 67F0 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 67F2 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67F4 2340 
0030 67F6 3900             data  >3900
0031 67F8 0458  20         b     *tmp4                 ; Exit
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
0043 67FA C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 67FC 06A0  32         bl    @cpym2v
     67FE 2494 
0045 6800 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6802 27A4 
     6804 0006 
0046 6806 06A0  32         bl    @putvr
     6808 2340 
0047 680A 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 680C 06A0  32         bl    @putvr
     680E 2340 
0049 6810 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 6812 0204  20         li    tmp0,>3f00
     6814 3F00 
0055 6816 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6818 22C8 
0056 681A D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     681C 8800 
0057 681E 0984  56         srl   tmp0,8
0058 6820 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6822 8800 
0059 6824 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 6826 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 6828 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     682A BFFF 
0063 682C 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 682E 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6830 4000 
0066               f18chk_exit:
0067 6832 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     6834 229C 
0068 6836 3F00             data  >3f00,>00,6
     6838 0000 
     683A 0006 
0069 683C 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 683E 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 6840 3F00             data  >3f00                 ; 3f02 / 3f00
0076 6842 0340             data  >0340                 ; 3f04   0340  idle
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
0097 6844 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 6846 06A0  32         bl    @putvr
     6848 2340 
0102 684A 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 684C 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     684E 2340 
0105 6850 3900             data  >3900                 ; Lock the F18a
0106 6852 0458  20         b     *tmp4                 ; Exit
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
0125 6854 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 6856 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6858 201E 
0127 685A 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 685C C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     685E 8802 
0132 6860 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6862 2340 
0133 6864 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 6866 04C4  14         clr   tmp0
0135 6868 D120  34         movb  @vdps,tmp0
     686A 8802 
0136 686C 0984  56         srl   tmp0,8
0137 686E 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6870 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6872 832A 
0018 6874 D17B  28         movb  *r11+,tmp1
0019 6876 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6878 D1BB  28         movb  *r11+,tmp2
0021 687A 0986  56         srl   tmp2,8                ; Repeat count
0022 687C C1CB  18         mov   r11,tmp3
0023 687E 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6880 2408 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6882 020B  20         li    r11,hchar1
     6884 27F0 
0028 6886 0460  28         b     @xfilv                ; Draw
     6888 22A2 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 688A 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     688C 2022 
0033 688E 1302  14         jeq   hchar2                ; Yes, exit
0034 6890 C2C7  18         mov   tmp3,r11
0035 6892 10EE  14         jmp   hchar                 ; Next one
0036 6894 05C7  14 hchar2  inct  tmp3
0037 6896 0457  20         b     *tmp3                 ; Exit
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
0016 6898 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     689A 2020 
0017 689C 020C  20         li    r12,>0024
     689E 0024 
0018 68A0 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     68A2 289A 
0019 68A4 04C6  14         clr   tmp2
0020 68A6 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 68A8 04CC  14         clr   r12
0025 68AA 1F08  20         tb    >0008                 ; Shift-key ?
0026 68AC 1302  14         jeq   realk1                ; No
0027 68AE 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     68B0 28CA 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 68B2 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 68B4 1302  14         jeq   realk2                ; No
0033 68B6 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     68B8 28FA 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 68BA 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 68BC 1302  14         jeq   realk3                ; No
0039 68BE 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     68C0 292A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 68C2 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     68C4 200C 
0044 68C6 1E15  20         sbz   >0015                 ; Set P5
0045 68C8 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 68CA 1302  14         jeq   realk4                ; No
0047 68CC E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     68CE 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 68D0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 68D2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     68D4 0006 
0053 68D6 0606  14 realk5  dec   tmp2
0054 68D8 020C  20         li    r12,>24               ; CRU address for P2-P4
     68DA 0024 
0055 68DC 06C6  14         swpb  tmp2
0056 68DE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 68E0 06C6  14         swpb  tmp2
0058 68E2 020C  20         li    r12,6                 ; CRU read address
     68E4 0006 
0059 68E6 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 68E8 0547  14         inv   tmp3                  ;
0061 68EA 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     68EC FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 68EE 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 68F0 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 68F2 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 68F4 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 68F6 0285  22         ci    tmp1,8
     68F8 0008 
0070 68FA 1AFA  14         jl    realk6
0071 68FC C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 68FE 1BEB  14         jh    realk5                ; No, next column
0073 6900 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 6902 C206  18 realk8  mov   tmp2,tmp4
0078 6904 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 6906 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 6908 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 690A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 690C 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 690E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 6910 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     6912 200C 
0089 6914 1608  14         jne   realka                ; No, continue saving key
0090 6916 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6918 28C4 
0091 691A 1A05  14         jl    realka
0092 691C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     691E 28C2 
0093 6920 1B02  14         jh    realka                ; No, continue
0094 6922 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     6924 E000 
0095 6926 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6928 833C 
0096 692A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     692C 200A 
0097 692E 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     6930 8C00 
0098                                                   ; / using R15 as temp storage
0099 6932 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 6934 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6936 0000 
     6938 FF0D 
     693A 203D 
0102 693C ....             text  'xws29ol.'
0103 6944 ....             text  'ced38ik,'
0104 694C ....             text  'vrf47ujm'
0105 6954 ....             text  'btg56yhn'
0106 695C ....             text  'zqa10p;/'
0107 6964 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6966 0000 
     6968 FF0D 
     696A 202B 
0108 696C ....             text  'XWS@(OL>'
0109 6974 ....             text  'CED#*IK<'
0110 697C ....             text  'VRF$&UJM'
0111 6984 ....             text  'BTG%^YHN'
0112 698C ....             text  'ZQA!)P:-'
0113 6994 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6996 0000 
     6998 FF0D 
     699A 2005 
0114 699C 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     699E 0804 
     69A0 0F27 
     69A2 C2B9 
0115 69A4 600B             data  >600b,>0907,>063f,>c1B8
     69A6 0907 
     69A8 063F 
     69AA C1B8 
0116 69AC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     69AE 7B02 
     69B0 015F 
     69B2 C0C3 
0117 69B4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     69B6 7D0E 
     69B8 0CC6 
     69BA BFC4 
0118 69BC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     69BE 7C03 
     69C0 BC22 
     69C2 BDBA 
0119 69C4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     69C6 0000 
     69C8 FF0D 
     69CA 209D 
0120 69CC 9897             data  >9897,>93b2,>9f8f,>8c9B
     69CE 93B2 
     69D0 9F8F 
     69D2 8C9B 
0121 69D4 8385             data  >8385,>84b3,>9e89,>8b80
     69D6 84B3 
     69D8 9E89 
     69DA 8B80 
0122 69DC 9692             data  >9692,>86b4,>b795,>8a8D
     69DE 86B4 
     69E0 B795 
     69E2 8A8D 
0123 69E4 8294             data  >8294,>87b5,>b698,>888E
     69E6 87B5 
     69E8 B698 
     69EA 888E 
0124 69EC 9A91             data  >9a91,>81b1,>b090,>9cBB
     69EE 81B1 
     69F0 B090 
     69F2 9CBB 
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
0023 69F4 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 69F6 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     69F8 8340 
0025 69FA 04E0  34         clr   @waux1
     69FC 833C 
0026 69FE 04E0  34         clr   @waux2
     6A00 833E 
0027 6A02 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6A04 833C 
0028 6A06 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6A08 0205  20         li    tmp1,4                ; 4 nibbles
     6A0A 0004 
0033 6A0C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6A0E 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6A10 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6A12 0286  22         ci    tmp2,>000a
     6A14 000A 
0039 6A16 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6A18 C21B  26         mov   *r11,tmp4
0045 6A1A 0988  56         srl   tmp4,8                ; Right justify
0046 6A1C 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6A1E FFF6 
0047 6A20 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6A22 C21B  26         mov   *r11,tmp4
0054 6A24 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6A26 00FF 
0055               
0056 6A28 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6A2A 06C6  14         swpb  tmp2
0058 6A2C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6A2E 0944  56         srl   tmp0,4                ; Next nibble
0060 6A30 0605  14         dec   tmp1
0061 6A32 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6A34 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6A36 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6A38 C160  34         mov   @waux3,tmp1           ; Get pointer
     6A3A 8340 
0067 6A3C 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6A3E 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6A40 C120  34         mov   @waux2,tmp0
     6A42 833E 
0070 6A44 06C4  14         swpb  tmp0
0071 6A46 DD44  32         movb  tmp0,*tmp1+
0072 6A48 06C4  14         swpb  tmp0
0073 6A4A DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6A4C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6A4E 8340 
0078 6A50 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6A52 2016 
0079 6A54 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6A56 C120  34         mov   @waux1,tmp0
     6A58 833C 
0084 6A5A 06C4  14         swpb  tmp0
0085 6A5C DD44  32         movb  tmp0,*tmp1+
0086 6A5E 06C4  14         swpb  tmp0
0087 6A60 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6A62 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A64 2020 
0092 6A66 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6A68 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6A6A 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6A6C 7FFF 
0098 6A6E C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A70 8340 
0099 6A72 0460  28         b     @xutst0               ; Display string
     6A74 242E 
0100 6A76 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A78 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A7A 832A 
0122 6A7C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A7E 8000 
0123 6A80 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6A82 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A84 0005 
0020 6A86 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A88 C155  26         mov   *tmp1,tmp1            ; /
0022 6A8A C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A8C 0228  22         ai    tmp4,4                ; Get end of buffer
     6A8E 0004 
0024 6A90 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A92 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A94 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A96 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A98 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A9A B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A9C D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A9E C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6AA0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6AA2 0607  14         dec   tmp3                  ; Decrease counter
0036 6AA4 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6AA6 0207  20         li    tmp3,4                ; Check first 4 digits
     6AA8 0004 
0041 6AAA 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6AAC C11B  26         mov   *r11,tmp0
0043 6AAE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6AB0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6AB2 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6AB4 05CB  14 mknum3  inct  r11
0047 6AB6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6AB8 2020 
0048 6ABA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6ABC 045B  20         b     *r11                  ; Exit
0050 6ABE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6AC0 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6AC2 13F8  14         jeq   mknum3                ; Yes, exit
0053 6AC4 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6AC6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6AC8 7FFF 
0058 6ACA C10B  18         mov   r11,tmp0
0059 6ACC 0224  22         ai    tmp0,-4
     6ACE FFFC 
0060 6AD0 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6AD2 0206  20         li    tmp2,>0500            ; String length = 5
     6AD4 0500 
0062 6AD6 0460  28         b     @xutstr               ; Display string
     6AD8 2430 
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
0093 6ADA C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6ADC C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6ADE C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6AE0 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6AE2 0207  20         li    tmp3,5                ; Set counter
     6AE4 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6AE6 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6AE8 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6AEA 0584  14         inc   tmp0                  ; Next character
0105 6AEC 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6AEE 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6AF0 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6AF2 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6AF4 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6AF6 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6AF8 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6AFA 0607  14         dec   tmp3                  ; Last character ?
0121 6AFC 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6AFE 045B  20         b     *r11                  ; Return
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
0139 6B00 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6B02 832A 
0140 6B04 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B06 8000 
0141 6B08 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6B0A 0649  14         dect  stack
0023 6B0C C64B  30         mov   r11,*stack            ; Save return address
0024 6B0E 0649  14         dect  stack
0025 6B10 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6B12 0649  14         dect  stack
0027 6B14 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6B16 0649  14         dect  stack
0029 6B18 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6B1A 0649  14         dect  stack
0031 6B1C C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6B1E C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6B20 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6B22 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6B24 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6B26 0649  14         dect  stack
0044 6B28 C64B  30         mov   r11,*stack            ; Save return address
0045 6B2A 0649  14         dect  stack
0046 6B2C C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6B2E 0649  14         dect  stack
0048 6B30 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6B32 0649  14         dect  stack
0050 6B34 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6B36 0649  14         dect  stack
0052 6B38 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6B3A C1D4  26 !       mov   *tmp0,tmp3
0057 6B3C 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6B3E 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6B40 00FF 
0059 6B42 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6B44 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6B46 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6B48 0584  14         inc   tmp0                  ; Next byte
0067 6B4A 0607  14         dec   tmp3                  ; Shorten string length
0068 6B4C 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6B4E 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6B50 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6B52 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6B54 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6B56 C187  18         mov   tmp3,tmp2
0078 6B58 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6B5A DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6B5C 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6B5E 24EE 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6B60 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6B62 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B64 FFCE 
0090 6B66 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B68 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6B6A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6B6C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B6E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B70 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B72 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B74 045B  20         b     *r11                  ; Return to caller
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
0123 6B76 0649  14         dect  stack
0124 6B78 C64B  30         mov   r11,*stack            ; Save return address
0125 6B7A 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B7C 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B7E 0649  14         dect  stack
0128 6B80 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B82 0649  14         dect  stack
0130 6B84 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B86 0649  14         dect  stack
0132 6B88 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B8A C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B8C C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B8E 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B90 0649  14         dect  stack
0144 6B92 C64B  30         mov   r11,*stack            ; Save return address
0145 6B94 0649  14         dect  stack
0146 6B96 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B98 0649  14         dect  stack
0148 6B9A C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B9C 0649  14         dect  stack
0150 6B9E C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6BA0 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6BA2 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6BA4 0586  14         inc   tmp2
0161 6BA6 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6BA8 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6BAA 0286  22         ci    tmp2,255
     6BAC 00FF 
0167 6BAE 1505  14         jgt   string.getlenc.panic
0168 6BB0 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6BB2 0606  14         dec   tmp2                  ; One time adjustment
0174 6BB4 C806  38         mov   tmp2,@waux1           ; Store length
     6BB6 833C 
0175 6BB8 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6BBA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BBC FFCE 
0181 6BBE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BC0 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6BC2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6BC4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6BC6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6BC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6BCA 045B  20         b     *r11                  ; Return to caller
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
0056 6BCC A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6BCE 2B36             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6BD0 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6BD2 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6BD4 A428 
0064 6BD6 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6BD8 201C 
0065 6BDA C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6BDC 8356 
0066 6BDE C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6BE0 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6BE2 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6BE4 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6BE6 A434 
0073                       ;---------------------------; Inline VSBR start
0074 6BE8 06C0  14         swpb  r0                    ;
0075 6BEA D800  38         movb  r0,@vdpa              ; Send low byte
     6BEC 8C02 
0076 6BEE 06C0  14         swpb  r0                    ;
0077 6BF0 D800  38         movb  r0,@vdpa              ; Send high byte
     6BF2 8C02 
0078 6BF4 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6BF6 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6BF8 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6BFA 0704  14         seto  r4                    ; Init counter
0086 6BFC 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6BFE A420 
0087 6C00 0580  14 !       inc   r0                    ; Point to next char of name
0088 6C02 0584  14         inc   r4                    ; Increment char counter
0089 6C04 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6C06 0007 
0090 6C08 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6C0A 80C4  18         c     r4,r3                 ; End of name?
0093 6C0C 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6C0E 06C0  14         swpb  r0                    ;
0098 6C10 D800  38         movb  r0,@vdpa              ; Send low byte
     6C12 8C02 
0099 6C14 06C0  14         swpb  r0                    ;
0100 6C16 D800  38         movb  r0,@vdpa              ; Send high byte
     6C18 8C02 
0101 6C1A D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6C1C 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6C1E DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6C20 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6C22 2C9E 
0109 6C24 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6C26 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6C28 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6C2A 04E0  34         clr   @>83d0
     6C2C 83D0 
0118 6C2E C804  38         mov   r4,@>8354             ; Save name length for search (length
     6C30 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6C32 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6C34 A432 
0121               
0122 6C36 0584  14         inc   r4                    ; Adjust for dot
0123 6C38 A804  38         a     r4,@>8356             ; Point to position after name
     6C3A 8356 
0124 6C3C C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6C3E 8356 
     6C40 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6C42 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6C44 83E0 
0130 6C46 04C1  14         clr   r1                    ; Version found of dsr
0131 6C48 020C  20         li    r12,>0f00             ; Init cru address
     6C4A 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6C4C C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6C4E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6C50 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6C52 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6C54 0100 
0145 6C56 04E0  34         clr   @>83d0                ; Clear in case we are done
     6C58 83D0 
0146 6C5A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6C5C 2000 
0147 6C5E 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6C60 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6C62 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6C64 1D00  20         sbo   0                     ; Turn on ROM
0154 6C66 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6C68 4000 
0155 6C6A 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6C6C 2C9A 
0156 6C6E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6C70 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6C72 A40A 
0166 6C74 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6C76 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C78 83D2 
0172                                                   ; subprogram
0173               
0174 6C7A 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6C7C C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6C7E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6C80 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C82 83D2 
0183                                                   ; subprogram
0184               
0185 6C84 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6C86 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6C88 04C5  14         clr   r5                    ; Remove any old stuff
0194 6C8A D160  34         movb  @>8355,r5             ; Get length as counter
     6C8C 8355 
0195 6C8E 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6C90 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6C92 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6C94 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6C96 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C98 A420 
0206 6C9A 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6C9C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6C9E 0605  14         dec   r5                    ; Update loop counter
0211 6CA0 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6CA2 0581  14         inc   r1                    ; Next version found
0217 6CA4 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6CA6 A42A 
0218 6CA8 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6CAA A42C 
0219 6CAC C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6CAE A430 
0220               
0221 6CB0 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6CB2 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6CB4 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6CB6 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6CB8 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6CBA 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6CBC A400 
0233 6CBE C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6CC0 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6CC2 A428 
0239                                                   ; (8 or >a)
0240 6CC4 0281  22         ci    r1,8                  ; was it 8?
     6CC6 0008 
0241 6CC8 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6CCA D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6CCC 8350 
0243                                                   ; Get error byte from @>8350
0244 6CCE 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6CD0 06C0  14         swpb  r0                    ;
0252 6CD2 D800  38         movb  r0,@vdpa              ; send low byte
     6CD4 8C02 
0253 6CD6 06C0  14         swpb  r0                    ;
0254 6CD8 D800  38         movb  r0,@vdpa              ; send high byte
     6CDA 8C02 
0255 6CDC D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6CDE 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6CE0 09D1  56         srl   r1,13                 ; just keep error bits
0263 6CE2 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6CE4 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6CE6 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6CE8 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6CEA A400 
0275               dsrlnk.error.devicename_invalid:
0276 6CEC 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6CEE 06C1  14         swpb  r1                    ; put error in hi byte
0279 6CF0 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6CF2 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6CF4 201C 
0281                                                   ; / to indicate error
0282 6CF6 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6CF8 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6CFA 2C62             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6CFC 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6CFE 83E0 
0316               
0317 6D00 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6D02 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6D04 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6D06 A42A 
0322 6D08 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6D0A C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6D0C C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6D0E 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6D10 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6D12 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6D14 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6D16 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6D18 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6D1A 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6D1C 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6D1E 4000 
     6D20 2C9A 
0337 6D22 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6D24 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6D26 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6D28 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6D2A 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6D2C A400 
0355 6D2E C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6D30 A434 
0356               
0357 6D32 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6D34 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6D36 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6D38 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6D3A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6D3C C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6D3E 0649  14         dect  stack
0052 6D40 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6D42 0204  20         li    tmp0,dsrlnk.savcru
     6D44 A42A 
0057 6D46 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6D48 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6D4A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6D4C 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6D4E 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6D50 37D7 
0065 6D52 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6D54 8370 
0066                                                   ; / location
0067 6D56 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6D58 A44C 
0068 6D5A 04C5  14         clr   tmp1                  ; io.op.open
0069 6D5C 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6D5E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6D60 0649  14         dect  stack
0097 6D62 C64B  30         mov   r11,*stack            ; Save return address
0098 6D64 0205  20         li    tmp1,io.op.close      ; io.op.close
     6D66 0001 
0099 6D68 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6D6A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6D6C 0649  14         dect  stack
0125 6D6E C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6D70 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D72 0002 
0128 6D74 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6D76 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6D78 0649  14         dect  stack
0155 6D7A C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6D7C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6D7E 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6D80 0005 
0159               
0160 6D82 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6D84 A43E 
0161               
0162 6D86 06A0  32         bl    @xvputb               ; Write character count to PAB
     6D88 22DA 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6D8A 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D8C 0003 
0167 6D8E 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6D90 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6D92 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6D94 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6D96 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6D98 1000  14         nop
0189               
0190               
0191               file.status:
0192 6D9A 1000  14         nop
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
0227 6D9C C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6D9E A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6DA0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6DA2 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6DA4 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6DA6 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6DA8 22DA 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6DAA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6DAC 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6DAE C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6DB0 A44C 
0246               
0247 6DB2 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6DB4 22DA 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6DB6 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6DB8 0009 
0254 6DBA C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DBC 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6DBE C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6DC0 8322 
     6DC2 833C 
0259               
0260 6DC4 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6DC6 A42A 
0261 6DC8 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6DCA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DCC 2B32 
0268 6DCE 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6DD0 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6DD2 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6DD4 2C5E 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6DD6 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6DD8 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6DDA 833C 
     6DDC 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6DDE C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6DE0 A436 
0292 6DE2 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6DE4 0005 
0293 6DE6 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6DE8 22F2 
0294 6DEA C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6DEC C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6DEE C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6DF0 045B  20         b     *r11                  ; Return to caller
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
0020 6DF2 0300  24 tmgr    limi  0                     ; No interrupt processing
     6DF4 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6DF6 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6DF8 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6DFA 2360  38         coc   @wbit2,r13            ; C flag on ?
     6DFC 201C 
0029 6DFE 1602  14         jne   tmgr1a                ; No, so move on
0030 6E00 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6E02 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6E04 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6E06 2020 
0035 6E08 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6E0A 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6E0C 2010 
0048 6E0E 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6E10 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6E12 200E 
0050 6E14 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6E16 0460  28         b     @kthread              ; Run kernel thread
     6E18 2DF6 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6E1A 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6E1C 2014 
0056 6E1E 13EB  14         jeq   tmgr1
0057 6E20 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6E22 2012 
0058 6E24 16E8  14         jne   tmgr1
0059 6E26 C120  34         mov   @wtiusr,tmp0
     6E28 832E 
0060 6E2A 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6E2C 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6E2E 2DF4 
0065 6E30 C10A  18         mov   r10,tmp0
0066 6E32 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6E34 00FF 
0067 6E36 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6E38 201C 
0068 6E3A 1303  14         jeq   tmgr5
0069 6E3C 0284  22         ci    tmp0,60               ; 1 second reached ?
     6E3E 003C 
0070 6E40 1002  14         jmp   tmgr6
0071 6E42 0284  22 tmgr5   ci    tmp0,50
     6E44 0032 
0072 6E46 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6E48 1001  14         jmp   tmgr8
0074 6E4A 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6E4C C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6E4E 832C 
0079 6E50 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6E52 FF00 
0080 6E54 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6E56 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6E58 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6E5A 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6E5C C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6E5E 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6E60 830C 
     6E62 830D 
0089 6E64 1608  14         jne   tmgr10                ; No, get next slot
0090 6E66 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6E68 FF00 
0091 6E6A C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6E6C C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E6E 8330 
0096 6E70 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6E72 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6E74 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6E76 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6E78 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6E7A 8315 
     6E7C 8314 
0103 6E7E 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6E80 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6E82 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6E84 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6E86 10F7  14         jmp   tmgr10                ; Process next slot
0108 6E88 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6E8A FF00 
0109 6E8C 10B4  14         jmp   tmgr1
0110 6E8E 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6E90 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E92 2010 
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
0041 6E94 06A0  32         bl    @realkb               ; Scan full keyboard
     6E96 27FE 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E98 0460  28         b     @tmgr3                ; Exit
     6E9A 2D80 
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
0017 6E9C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E9E 832E 
0018 6EA0 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6EA2 2012 
0019 6EA4 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D5C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6EA6 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6EA8 832E 
0029 6EAA 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6EAC FEFF 
0030 6EAE 045B  20         b     *r11                  ; Return
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
0017 6EB0 C13B  30 mkslot  mov   *r11+,tmp0
0018 6EB2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6EB4 C184  18         mov   tmp0,tmp2
0023 6EB6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6EB8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6EBA 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6EBC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6EBE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6EC0 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6EC2 881B  46         c     *r11,@w$ffff          ; End of list ?
     6EC4 2022 
0035 6EC6 1301  14         jeq   mkslo1                ; Yes, exit
0036 6EC8 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6ECA 05CB  14 mkslo1  inct  r11
0041 6ECC 045B  20         b     *r11                  ; Exit
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
0052 6ECE C13B  30 clslot  mov   *r11+,tmp0
0053 6ED0 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6ED2 A120  34         a     @wtitab,tmp0          ; Add table base
     6ED4 832C 
0055 6ED6 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6ED8 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6EDA 045B  20         b     *r11                  ; Exit
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
0068 6EDC C13B  30 rsslot  mov   *r11+,tmp0
0069 6EDE 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6EE0 A120  34         a     @wtitab,tmp0          ; Add table base
     6EE2 832C 
0071 6EE4 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6EE6 C154  26         mov   *tmp0,tmp1
0073 6EE8 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6EEA FF00 
0074 6EEC C505  30         mov   tmp1,*tmp0
0075 6EEE 045B  20         b     *r11                  ; Exit
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
0261 6EF0 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6EF2 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 6EF4 0300  24 runli1  limi  0                     ; Turn off interrupts
     6EF6 0000 
0267 6EF8 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6EFA 8300 
0268 6EFC C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6EFE 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 6F00 0202  20 runli2  li    r2,>8308
     6F02 8308 
0273 6F04 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 6F06 0282  22         ci    r2,>8400
     6F08 8400 
0275 6F0A 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 6F0C 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6F0E FFFF 
0280 6F10 1602  14         jne   runli4                ; No, continue
0281 6F12 0420  54         blwp  @0                    ; Yes, bye bye
     6F14 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 6F16 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6F18 833C 
0286 6F1A 04C1  14         clr   r1                    ; Reset counter
0287 6F1C 0202  20         li    r2,10                 ; We test 10 times
     6F1E 000A 
0288 6F20 C0E0  34 runli5  mov   @vdps,r3
     6F22 8802 
0289 6F24 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6F26 2020 
0290 6F28 1302  14         jeq   runli6
0291 6F2A 0581  14         inc   r1                    ; Increase counter
0292 6F2C 10F9  14         jmp   runli5
0293 6F2E 0602  14 runli6  dec   r2                    ; Next test
0294 6F30 16F7  14         jne   runli5
0295 6F32 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6F34 1250 
0296 6F36 1202  14         jle   runli7                ; No, so it must be NTSC
0297 6F38 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6F3A 201C 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 6F3C 06A0  32 runli7  bl    @loadmc
     6F3E 2228 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 6F40 04C1  14 runli9  clr   r1
0306 6F42 04C2  14         clr   r2
0307 6F44 04C3  14         clr   r3
0308 6F46 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6F48 3000 
0309 6F4A 020F  20         li    r15,vdpw              ; Set VDP write address
     6F4C 8C00 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 6F4E 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6F50 4A4A 
0318 6F52 1605  14         jne   runlia
0319 6F54 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6F56 229C 
0320 6F58 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     6F5A 0000 
     6F5C 3000 
0325 6F5E 06A0  32 runlia  bl    @filv
     6F60 229C 
0326 6F62 0FC0             data  pctadr,spfclr,16      ; Load color table
     6F64 00F4 
     6F66 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 6F68 06A0  32         bl    @f18unl               ; Unlock the F18A
     6F6A 2740 
0334 6F6C 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F6E 2760 
0335 6F70 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F72 2756 
0336               
0337 6F74 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6F76 2340 
0338 6F78 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 6F7A 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F7C 2306 
0352 6F7E 33B0             data  spvmod                ; Equate selected video mode table
0353 6F80 0204  20         li    tmp0,spfont           ; Get font option
     6F82 000C 
0354 6F84 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 6F86 1304  14         jeq   runlid                ; Yes, skip it
0356 6F88 06A0  32         bl    @ldfnt
     6F8A 236E 
0357 6F8C 1100             data  fntadr,spfont         ; Load specified font
     6F8E 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 6F90 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F92 4A4A 
0362 6F94 1602  14         jne   runlie                ; No, continue
0363 6F96 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F98 2086 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 6F9A 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F9C 0040 
0368 6F9E 0460  28         b     @main                 ; Give control to main program
     6FA0 3000 
**** **** ****     > stevie_b0.asm.1400279
0104                                                   ; Spectra 2
0105                       ;------------------------------------------------------
0106                       ; Memory full check
0107                       ;------------------------------------------------------
0109               
0113                       ;------------------------------------------------------
0114                       ; spectra2 extended library (handle yourself)
0115                       ;------------------------------------------------------
0116               reloc.sp2ext:
0117                       aorg  >7000                 ; >7000 in cartridge space
0118                       xorg  >f000                 ; Relocate to >f000
0119               
0120                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/modules/cpu_scrpad_backrest.asm"
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
0023 7000 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     7002 7E00 
0024 7004 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     7006 7E02 
0025 7008 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     700A 7E04 
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 700C 0200  20         li    r0,>8306              ; Scratchpad source address
     700E 8306 
0030 7010 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     7012 7E06 
0031 7014 0202  20         li    r2,62                 ; Loop counter
     7016 003E 
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 7018 CC70  46         mov   *r0+,*r1+
0037 701A CC70  46         mov   *r0+,*r1+
0038 701C 0642  14         dect  r2
0039 701E 16FC  14         jne   cpu.scrpad.backup.copy
0040 7020 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     7022 83FE 
     7024 7EFE 
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 7026 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     7028 7E00 
0046 702A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     702C 7E02 
0047 702E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     7030 7E04 
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 7032 045B  20         b     *r11                  ; Return to caller
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
0069 7034 C80B  38         mov   r11,@rambuf           ; Backup return address
     7036 2F6A 
0070                       ;------------------------------------------------------
0071                       ; Prepare for copy loop, WS
0072                       ;------------------------------------------------------
0073 7038 0200  20         li    r0,cpu.scrpad.tgt + 6
     703A 7E06 
0074 703C 0201  20         li    r1,>8306
     703E 8306 
0075 7040 0202  20         li    r2,62
     7042 003E 
0076                       ;------------------------------------------------------
0077                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 7044 CC70  46         mov   *r0+,*r1+
0081 7046 CC70  46         mov   *r0+,*r1+
0082 7048 0642  14         dect  r2
0083 704A 16FC  14         jne   cpu.scrpad.restore.copy
0084 704C C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     704E 7EFE 
     7050 83FE 
0085                                                   ; Copy last word
0086                       ;------------------------------------------------------
0087                       ; Restore scratchpad >8300 - >8304
0088                       ;------------------------------------------------------
0089 7052 C820  54         mov   @cpu.scrpad.tgt,@>8300       ; r0
     7054 7E00 
     7056 8300 
0090 7058 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302   ; r1
     705A 7E02 
     705C 8302 
0091 705E C820  54         mov   @cpu.scrpad.tgt + 4,@>8304   ; r2
     7060 7E04 
     7062 8304 
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095               cpu.scrpad.restore.exit:
0096 7064 C2E0  34         mov   @rambuf,r11           ; Restore return address
     7066 2F6A 
0097 7068 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b0.asm.1400279
0121                                                   ; Spectra 2 extended
0122               
0123               
0124               ***************************************************************
0125               * Code data: Relocated Stevie modules >3000 - >3fff (4K max)
0126               ********|*****|*********************|**************************
0127               reloc.stevie:
0128                       xorg  >3000                 ; Relocate Stevie modules to >3000
0129                       ;------------------------------------------------------
0130                       ; Activate bank 1 and branch to >6046
0131                       ;------------------------------------------------------
0132               main:
0133 706A 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     706C 6002 
0134               
0138               
0139 706E 0460  28         b     @kickstart.code2      ; Jump to entry routine
     7070 6046 
0140                       ;------------------------------------------------------
0141                       ; Resident Stevie modules: >3000 - >3fff
0142                       ;------------------------------------------------------
0143                       copy  "ram.resident.3000.asm"
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
0021 7072 C13B  30         mov   *r11+,tmp0            ; P0
0022 7074 C17B  30         mov   *r11+,tmp1            ; P1
0023 7076 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 7078 0649  14         dect  stack
0029 707A C644  30         mov   tmp0,*stack           ; Push tmp0
0030 707C 0649  14         dect  stack
0031 707E C645  30         mov   tmp1,*stack           ; Push tmp1
0032 7080 0649  14         dect  stack
0033 7082 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 7084 0649  14         dect  stack
0035 7086 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 7088 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     708A 6000 
0040 708C 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 708E C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     7090 A026 
0044 7092 0647  14         dect  tmp3
0045 7094 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 7096 0647  14         dect  tmp3
0047 7098 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 709A C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     709C A026 
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 709E 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 70A0 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 70A2 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 70A4 0224  22         ai    tmp0,>0800
     70A6 0800 
0066 70A8 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @parm1 if >ffff
0073                       ;------------------------------------------------------
0074 70AA 0285  22         ci    tmp1,>ffff
     70AC FFFF 
0075 70AE 1602  14         jne   !
0076 70B0 C160  34         mov   @parm1,tmp1
     70B2 2F20 
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 70B4 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 70B6 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084               
0085 70B8 1004  14         jmp   rom.farjump.bankswitch.call
0086                                                   ; Call function in target bank
0087                       ;------------------------------------------------------
0088                       ; Assert 1 failed before bank-switch
0089                       ;------------------------------------------------------
0090               rom.farjump.bankswitch.failed1:
0091 70BA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70BC FFCE 
0092 70BE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70C0 2026 
0093                       ;------------------------------------------------------
0094                       ; Call function in target bank
0095                       ;------------------------------------------------------
0096               rom.farjump.bankswitch.call:
0097 70C2 0694  24         bl    *tmp0                 ; Call function
0098                       ;------------------------------------------------------
0099                       ; Bankswitch back to source bank
0100                       ;------------------------------------------------------
0101               rom.farjump.return:
0102 70C4 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     70C6 A026 
0103 70C8 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0104 70CA 1312  14         jeq   rom.farjump.bankswitch.failed2
0105                                                   ; Crash if null-pointer in address
0106               
0107 70CC 04F4  30         clr   *tmp0+                ; Remove bank write address from
0108                                                   ; farjump stack
0109               
0110 70CE C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0111               
0112 70D0 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0113                                                   ; farjump stack
0114               
0115 70D2 028B  22         ci    r11,>6000
     70D4 6000 
0116 70D6 110C  14         jlt   rom.farjump.bankswitch.failed2
0117 70D8 028B  22         ci    r11,>7fff
     70DA 7FFF 
0118 70DC 1509  14         jgt   rom.farjump.bankswitch.failed2
0119               
0120 70DE C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     70E0 A026 
0121               
0125               
0126                       ;------------------------------------------------------
0127                       ; Bankswitch to source 8K ROM bank
0128                       ;------------------------------------------------------
0129               rom.farjump.bankswitch.src.rom8k:
0130 70E2 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0131 70E4 1009  14         jmp   rom.farjump.exit
0132                       ;------------------------------------------------------
0133                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0134                       ;------------------------------------------------------
0135               rom.farjump.bankswitch.src.advfg99:
0136 70E6 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0137 70E8 0225  22         ai    tmp1,>0800
     70EA 0800 
0138 70EC 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0139 70EE 1004  14         jmp   rom.farjump.exit
0140                       ;------------------------------------------------------
0141                       ; Assert 2 failed after bank-switch
0142                       ;------------------------------------------------------
0143               rom.farjump.bankswitch.failed2:
0144 70F0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70F2 FFCE 
0145 70F4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70F6 2026 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               rom.farjump.exit:
0150 70F8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0151 70FA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0152 70FC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0153 70FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0154 7100 045B  20         b     *r11                  ; Return to caller
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
0020 7102 0649  14         dect  stack
0021 7104 C64B  30         mov   r11,*stack            ; Save return address
0022 7106 0649  14         dect  stack
0023 7108 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 710A 0649  14         dect  stack
0025 710C C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 710E 0204  20         li    tmp0,fb.top
     7110 A600 
0030 7112 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     7114 A100 
0031 7116 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     7118 A104 
0032 711A 04E0  34         clr   @fb.row               ; Current row=0
     711C A106 
0033 711E 04E0  34         clr   @fb.column            ; Current column=0
     7120 A10C 
0034               
0035 7122 0204  20         li    tmp0,colrow
     7124 0050 
0036 7126 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7128 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 712A C160  34         mov   @tv.ruler.visible,tmp1
     712C A010 
0041 712E 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 7130 0204  20         li    tmp0,pane.botrow-2
     7132 001B 
0043 7134 1002  14         jmp   fb.init.cont
0044 7136 0204  20 !       li    tmp0,pane.botrow-1
     7138 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 713A C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     713C A11A 
0050 713E C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     7140 A11C 
0051               
0052 7142 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     7144 A022 
0053 7146 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     7148 A110 
0054 714A 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     714C A116 
0055 714E 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     7150 A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 7152 06A0  32         bl    @film
     7154 2244 
0060 7156 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     7158 0000 
     715A 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 715C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 715E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 7160 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 7162 045B  20         b     *r11                  ; Return to caller
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
0046 7164 0649  14         dect  stack
0047 7166 C64B  30         mov   r11,*stack            ; Save return address
0048 7168 0649  14         dect  stack
0049 716A C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 716C 0204  20         li    tmp0,idx.top
     716E B000 
0054 7170 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7172 A202 
0055               
0056 7174 C120  34         mov   @tv.sams.b000,tmp0
     7176 A006 
0057 7178 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     717A A500 
0058 717C C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     717E A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 7180 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     7182 0004 
0063 7184 C804  38         mov   tmp0,@idx.sams.hipage ; /
     7186 A504 
0064               
0065 7188 06A0  32         bl    @_idx.sams.mapcolumn.on
     718A 313C 
0066                                                   ; Index in continuous memory region
0067               
0068 718C 06A0  32         bl    @film
     718E 2244 
0069 7190 B000                   data idx.top,>00,idx.size * 5
     7192 0000 
     7194 5000 
0070                                                   ; Clear index
0071               
0072 7196 06A0  32         bl    @_idx.sams.mapcolumn.off
     7198 3170 
0073                                                   ; Restore memory window layout
0074               
0075 719A C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     719C A502 
     719E A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 71A0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 71A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 71A4 045B  20         b     *r11                  ; Return to caller
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
0096 71A6 0649  14         dect  stack
0097 71A8 C64B  30         mov   r11,*stack            ; Push return address
0098 71AA 0649  14         dect  stack
0099 71AC C644  30         mov   tmp0,*stack           ; Push tmp0
0100 71AE 0649  14         dect  stack
0101 71B0 C645  30         mov   tmp1,*stack           ; Push tmp1
0102 71B2 0649  14         dect  stack
0103 71B4 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 71B6 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     71B8 A502 
0108 71BA 0205  20         li    tmp1,idx.top
     71BC B000 
0109 71BE 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     71C0 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 71C2 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     71C4 2584 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 71C6 0584  14         inc   tmp0                  ; Next SAMS index page
0118 71C8 0225  22         ai    tmp1,>1000            ; Next memory region
     71CA 1000 
0119 71CC 0606  14         dec   tmp2                  ; Update loop counter
0120 71CE 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 71D0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 71D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 71D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 71D6 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 71D8 045B  20         b     *r11                  ; Return to caller
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
0145 71DA 0649  14         dect  stack
0146 71DC C64B  30         mov   r11,*stack            ; Push return address
0147 71DE 0649  14         dect  stack
0148 71E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0149 71E2 0649  14         dect  stack
0150 71E4 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 71E6 0649  14         dect  stack
0152 71E8 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 71EA 0649  14         dect  stack
0154 71EC C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 71EE 0205  20         li    tmp1,idx.top
     71F0 B000 
0159 71F2 0206  20         li    tmp2,5                ; Always 5 pages
     71F4 0005 
0160 71F6 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     71F8 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 71FA C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 71FC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     71FE 2584 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 7200 0225  22         ai    tmp1,>1000            ; Next memory region
     7202 1000 
0171 7204 0606  14         dec   tmp2                  ; Update loop counter
0172 7206 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 7208 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 720A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 720C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 720E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 7210 C2F9  30         mov   *stack+,r11           ; Pop return address
0182 7212 045B  20         b     *r11                  ; Return to caller
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
0206 7214 0649  14         dect  stack
0207 7216 C64B  30         mov   r11,*stack            ; Save return address
0208 7218 0649  14         dect  stack
0209 721A C644  30         mov   tmp0,*stack           ; Push tmp0
0210 721C 0649  14         dect  stack
0211 721E C645  30         mov   tmp1,*stack           ; Push tmp1
0212 7220 0649  14         dect  stack
0213 7222 C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 7224 C184  18         mov   tmp0,tmp2             ; Line number
0218 7226 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 7228 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     722A 0800 
0220               
0221 722C 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 722E 0A16  56         sla   tmp2,1                ; line number * 2
0226 7230 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     7232 2F30 
0227               
0228 7234 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     7236 A502 
0229 7238 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     723A A500 
0230               
0231 723C 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 723E C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     7240 A500 
0237 7242 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     7244 A006 
0238               
0239 7246 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 7248 0205  20         li    tmp1,>b000            ; Memory window for index page
     724A B000 
0241               
0242 724C 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     724E 2584 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 7250 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     7252 A504 
0249 7254 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 7256 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     7258 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 725A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 725C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 725E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 7260 C2F9  30         mov   *stack+,r11           ; Pop r11
0260 7262 045B  20         b     *r11                  ; Return to caller
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
0022 7264 0649  14         dect  stack
0023 7266 C64B  30         mov   r11,*stack            ; Save return address
0024 7268 0649  14         dect  stack
0025 726A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 726C 0204  20         li    tmp0,edb.top          ; \
     726E C000 
0030 7270 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     7272 A200 
0031 7274 C804  38         mov   tmp0,@edb.next_free.ptr
     7276 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 7278 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     727A A20A 
0035               
0036 727C 0204  20         li    tmp0,1
     727E 0001 
0037 7280 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     7282 A204 
0038               
0039 7284 0720  34         seto  @edb.block.m1         ; Reset block start line
     7286 A20C 
0040 7288 0720  34         seto  @edb.block.m2         ; Reset block end line
     728A A20E 
0041               
0042 728C 0204  20         li    tmp0,txt.newfile      ; "New file"
     728E 353A 
0043 7290 C804  38         mov   tmp0,@edb.filename.ptr
     7292 A212 
0044               
0045 7294 0204  20         li    tmp0,txt.filetype.none
     7296 35F2 
0046 7298 C804  38         mov   tmp0,@edb.filetype.ptr
     729A A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 729C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 729E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 72A0 045B  20         b     *r11                  ; Return to caller
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
0022 72A2 0649  14         dect  stack
0023 72A4 C64B  30         mov   r11,*stack            ; Save return address
0024 72A6 0649  14         dect  stack
0025 72A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72AA 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     72AC D000 
0030 72AE C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     72B0 A300 
0031               
0032 72B2 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     72B4 A302 
0033 72B6 0204  20         li    tmp0,4
     72B8 0004 
0034 72BA C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     72BC A306 
0035 72BE C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     72C0 A308 
0036               
0037 72C2 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     72C4 A316 
0038 72C6 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     72C8 A318 
0039 72CA 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     72CC A326 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 72CE 06A0  32         bl    @film
     72D0 2244 
0044 72D2 D000             data  cmdb.top,>00,cmdb.size
     72D4 0000 
     72D6 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 72D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 72DA C2F9  30         mov   *stack+,r11           ; Pop r11
0052 72DC 045B  20         b     *r11                  ; Return to caller
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
0022 72DE 0649  14         dect  stack
0023 72E0 C64B  30         mov   r11,*stack            ; Save return address
0024 72E2 0649  14         dect  stack
0025 72E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72E6 04E0  34         clr   @tv.error.visible     ; Set to hidden
     72E8 A028 
0030               
0031 72EA 06A0  32         bl    @film
     72EC 2244 
0032 72EE A02A                   data tv.error.msg,0,160
     72F0 0000 
     72F2 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 72F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 72F6 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 72F8 045B  20         b     *r11                  ; Return to caller
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
0022 72FA 0649  14         dect  stack
0023 72FC C64B  30         mov   r11,*stack            ; Save return address
0024 72FE 0649  14         dect  stack
0025 7300 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7302 0204  20         li    tmp0,1                ; \ Set default color scheme
     7304 0001 
0030 7306 C804  38         mov   tmp0,@tv.colorscheme  ; /
     7308 A012 
0031               
0032 730A 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     730C A024 
0033 730E E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     7310 200C 
0034               
0035 7312 0204  20         li    tmp0,fj.bottom
     7314 F000 
0036 7316 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     7318 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 731A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 731C C2F9  30         mov   *stack+,r11           ; Pop R11
0043 731E 045B  20         b     *r11                  ; Return to caller
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
0065 7320 0649  14         dect  stack
0066 7322 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 7324 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     7326 3238 
0071 7328 06A0  32         bl    @edb.init             ; Initialize editor buffer
     732A 31FA 
0072 732C 06A0  32         bl    @idx.init             ; Initialize index
     732E 30FA 
0073 7330 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7332 3098 
0074 7334 06A0  32         bl    @errline.init         ; Initialize error line
     7336 3274 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 7338 06A0  32         bl    @hchar
     733A 27D6 
0079 733C 0034                   byte 0,52,32,18           ; Remove markers
     733E 2012 
0080 7340 1D00                   byte pane.botrow,0,32,51  ; Remove block shortcuts
     7342 2033 
0081 7344 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 7346 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 7348 045B  20         b     *r11                  ; Return to caller
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
0020 734A 0649  14         dect  stack
0021 734C C64B  30         mov   r11,*stack            ; Save return address
0022 734E 0649  14         dect  stack
0023 7350 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 7352 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7354 29E8 
0028 7356 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 7358 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 735A 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 735C 0204  20         li    tmp0,unpacked.string
     735E 2F44 
0034 7360 04F4  30         clr   *tmp0+                ; Clear string 01
0035 7362 04F4  30         clr   *tmp0+                ; Clear string 23
0036 7364 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 7366 06A0  32         bl    @trimnum              ; Trim unsigned number string
     7368 2A40 
0039 736A 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 736C 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 736E 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 7370 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 7372 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 7374 045B  20         b     *r11                  ; Return to caller
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
0073 7376 0649  14         dect  stack
0074 7378 C64B  30         mov   r11,*stack            ; Push return address
0075 737A 0649  14         dect  stack
0076 737C C644  30         mov   tmp0,*stack           ; Push tmp0
0077 737E 0649  14         dect  stack
0078 7380 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 7382 0649  14         dect  stack
0080 7384 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 7386 0649  14         dect  stack
0082 7388 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 738A C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     738C 2F20 
0087 738E D194  26         movb  *tmp0,tmp2            ; /
0088 7390 0986  56         srl   tmp2,8                ; Right align
0089 7392 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 7394 8806  38         c     tmp2,@parm2           ; String length > requested length?
     7396 2F22 
0092 7398 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 739A C120  34         mov   @parm1,tmp0           ; Get source address
     739C 2F20 
0097 739E C160  34         mov   @parm4,tmp1           ; Get destination address
     73A0 2F26 
0098 73A2 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 73A4 0649  14         dect  stack
0101 73A6 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 73A8 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     73AA 24EE 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 73AC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 73AE C120  34         mov   @parm2,tmp0           ; Get requested length
     73B0 2F22 
0113 73B2 0A84  56         sla   tmp0,8                ; Left align
0114 73B4 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     73B6 2F26 
0115 73B8 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 73BA A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 73BC 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 73BE C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     73C0 2F22 
0122 73C2 6187  18         s     tmp3,tmp2             ; |
0123 73C4 0586  14         inc   tmp2                  ; /
0124               
0125 73C6 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     73C8 2F24 
0126 73CA 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 73CC DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 73CE 0606  14         dec   tmp2                  ; Update loop counter
0133 73D0 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 73D2 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     73D4 2F26 
     73D6 2F30 
0136 73D8 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 73DA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     73DC FFCE 
0142 73DE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     73E0 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 73E2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 73E4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 73E6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 73E8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 73EA C2F9  30         mov   *stack+,r11           ; Pop r11
0152 73EC 045B  20         b     *r11                  ; Return to caller
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
0174 73EE 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     73F0 27AA 
0175                       ;-------------------------------------------------------
0176                       ; Activate bank 0 and exit
0177                       ;-------------------------------------------------------
0178 73F2 04E0  34         clr   @bank0.rom            ; Activate bank 0
     73F4 6000 
0179 73F6 0420  54         blwp  @0                    ; Reset to monitor
     73F8 0000 
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
0017 73FA 0649  14         dect  stack
0018 73FC C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 73FE 06A0  32         bl    @sams.layout
     7400 25F0 
0023 7402 33C8                   data mem.sams.layout.data
0024               
0025 7404 06A0  32         bl    @sams.layout.copy
     7406 2654 
0026 7408 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 740A C820  54         mov   @tv.sams.c000,@edb.sams.page
     740C A008 
     740E A216 
0029 7410 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     7412 A216 
     7414 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 7416 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 7418 045B  20         b     *r11                  ; Return to caller
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
0033 741A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     741C 003F 
     741E 0243 
     7420 05F4 
     7422 0050 
0034               
0035               romsat:
0036 7424 0000             data  >0000,>0201             ; Cursor YX, initial shape and colour
     7426 0201 
0037 7428 0000             data  >0000,>0301             ; Current line indicator
     742A 0301 
0038 742C 0820             data  >0820,>0401             ; Current line indicator
     742E 0401 
0039               nosprite:
0040 7430 D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 7432 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7434 0002 
0048 7436 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7438 0003 
0049 743A A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     743C 000A 
0050               
0051 743E B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     7440 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 7442 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     7444 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 7446 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7448 000D 
0060 744A E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     744C 000E 
0061 744E F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     7450 000F 
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
0117 7452 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     7454 F171 
     7456 1B1F 
     7458 71B1 
0118 745A A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     745C F0FF 
     745E 1F1A 
     7460 F1FF 
0119 7462 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     7464 F0FF 
     7466 1F12 
     7468 F1F6 
0120 746A F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     746C 1E11 
     746E 1A17 
     7470 1E11 
0121 7472 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     7474 E1FF 
     7476 1F1E 
     7478 E1FF 
0122 747A 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     747C 1016 
     747E 1B71 
     7480 1711 
0123 7482 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     7484 1011 
     7486 F1F1 
     7488 1F11 
0124 748A 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     748C A1FF 
     748E 1F1F 
     7490 F11F 
0125 7492 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     7494 12FF 
     7496 1B12 
     7498 12FF 
0126 749A F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     749C E1FF 
     749E 1B1F 
     74A0 F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 74A2 0007             byte  0,7,12,25               ; \   Default tab positions as used
     74A4 0C19 
0131 74A6 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     74A8 3B4F 
0132 74AA FF00             byte  >ff,0,0,0               ; |
     74AC 0000 
0133 74AE 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     74B0 0000 
0134 74B2 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     74B4 0000 
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
0012 74B6 0B53             byte  11
0013 74B7 ....             text  'STEVIE 1.1S'
0014                       even
0015               
0016               txt.about.build
0017 74C2 4C42             byte  76
0018 74C3 ....             text  'Build: 210829-1400279 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 7510 012C             byte  1
0024 7511 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 7512 0520             byte  5
0029 7513 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 7518 034F             byte  3
0034 7519 ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 751C 0349             byte  3
0039 751D ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 7520 012A             byte  1
0044 7521 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 7522 0A4C             byte  10
0049 7523 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 752E 0A53             byte  10
0054 752F ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 753A 1244             byte  18
0059 753B ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 754E 1143             byte  17
0064 754F ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 7560 104D             byte  16
0069 7561 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 7572 1D53             byte  29
0074 7573 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 7590 0846             byte  8
0079 7591 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 759A 026B             byte  2
0084 759B ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 759E 054C             byte  5
0089 759F ....             text  'Lines'
0090                       even
0091               
0092               txt.newfile
0093 75A4 0A5B             byte  10
0094 75A5 ....             text  '[New file]'
0095                       even
0096               
0097               txt.filetype.dv80
0098 75B0 0444             byte  4
0099 75B1 ....             text  'DV80'
0100                       even
0101               
0102               txt.m1
0103 75B6 034D             byte  3
0104 75B7 ....             text  'M1='
0105                       even
0106               
0107               txt.m2
0108 75BA 034D             byte  3
0109 75BB ....             text  'M2='
0110                       even
0111               
0112               txt.keys.default
0113 75BE 0746             byte  7
0114 75BF ....             text  'F9=Menu'
0115                       even
0116               
0117               txt.keys.block
0118 75C6 3342             byte  51
0119 75C7 ....             text  'Block: F9=Back  ^Del  ^Copy  ^Move  ^Goto M1  ^Save'
0120                       even
0121               
0122 75FA ....     txt.ruler          text    '.........'
0123                                  byte    18
0124 7604 ....                        text    '.........'
0125                                  byte    19
0126 760E ....                        text    '.........'
0127                                  byte    20
0128 7618 ....                        text    '.........'
0129                                  byte    21
0130 7622 ....                        text    '.........'
0131                                  byte    22
0132 762C ....                        text    '.........'
0133                                  byte    23
0134 7636 ....                        text    '.........'
0135                                  byte    24
0136 7640 ....                        text    '.........'
0137                                  byte    25
0138                                  even
0139 764A 020E     txt.alpha.down     data >020e,>0f00
     764C 0F00 
0140 764E 0110     txt.vertline       data >0110
0141 7650 011C     txt.keymarker      byte 1,28
0142               
0143               txt.ws1
0144 7652 0120             byte  1
0145 7653 ....             text  ' '
0146                       even
0147               
0148               txt.ws2
0149 7654 0220             byte  2
0150 7655 ....             text  '  '
0151                       even
0152               
0153               txt.ws3
0154 7658 0320             byte  3
0155 7659 ....             text  '   '
0156                       even
0157               
0158               txt.ws4
0159 765C 0420             byte  4
0160 765D ....             text  '    '
0161                       even
0162               
0163               txt.ws5
0164 7662 0520             byte  5
0165 7663 ....             text  '     '
0166                       even
0167               
0168      35F2     txt.filetype.none  equ txt.ws4
0169               
0170               
0171               ;--------------------------------------------------------------
0172               ; Dialog Load DV 80 file
0173               ;--------------------------------------------------------------
0174 7668 1301     txt.head.load      byte 19,1,3
     766A 0320 
0175 766B ....                        text ' Open DV80 file '
0176                                  byte 2
0177               txt.hint.load
0178 767C 3D53             byte  61
0179 767D ....             text  'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'
0180                       even
0181               
0182               
0183 76BA 3146     txt.keys.load      byte 49
0184 76BB ....                        text 'F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End'
0185               
0186 76EC 3246     txt.keys.load2     byte 50
0187 76ED ....                        text 'F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End'
0188               
0189               ;--------------------------------------------------------------
0190               ; Dialog Save DV 80 file
0191               ;--------------------------------------------------------------
0192 7720 0103     txt.head.save      byte 19,1,3
0193 7722 ....                        text ' Save DV80 file '
0194 7732 0223                        byte 2
0195 7734 0103     txt.head.save2     byte 35,1,3,32
     7736 2053 
0196 7737 ....                        text 'Save marked block to DV80 file '
0197 7756 0201                        byte 2
0198               txt.hint.save
0199                       byte  1
0200 7758 ....             text  ' '
0201                       even
0202               
0203               
0204 775A 2446     txt.keys.save      byte 36
0205 775B ....                        text 'F9=Back  F3=Clear  F-H=Home  F-L=End'
0206               
0207               ;--------------------------------------------------------------
0208               ; Dialog "Unsaved changes"
0209               ;--------------------------------------------------------------
0210 7780 0103     txt.head.unsaved   byte 20,1,3
0211 7782 ....                        text ' Unsaved changes '
0212                                  byte 2
0213               txt.info.unsaved
0214 7794 2157             byte  33
0215 7795 ....             text  'Warning! Unsaved changes in file.'
0216                       even
0217               
0218               txt.hint.unsaved
0219 77B6 2A50             byte  42
0220 77B7 ....             text  'Press F6 to proceed or ENTER to save file.'
0221                       even
0222               
0223               txt.keys.unsaved
0224 77E2 2843             byte  40
0225 77E3 ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0226                       even
0227               
0228               
0229               ;--------------------------------------------------------------
0230               ; Dialog "About"
0231               ;--------------------------------------------------------------
0232 780C 0A01     txt.head.about     byte 10,1,3
     780E 0320 
0233 780F ....                        text ' About '
0234 7816 0200                        byte 2
0235               
0236               txt.info.about
0237                       byte  0
0238 7818 ....             text
0239                       even
0240               
0241               txt.hint.about
0242 7818 1D50             byte  29
0243 7819 ....             text  'Press F9 to return to editor.'
0244                       even
0245               
0246 7836 2148     txt.keys.about     byte 33
0247 7837 ....                        text 'Help: F9=Back  '
0248 7846 0E0F                        byte 14,15
0249 7848 ....                        text '=Alpha Lock down'
0250               
0251               
0252               ;--------------------------------------------------------------
0253               ; Dialog "Menu"
0254               ;--------------------------------------------------------------
0255 7858 1001     txt.head.menu      byte 16,1,3
     785A 0320 
0256 785B ....                        text ' Stevie 1.1R '
0257 7868 021A                        byte 2
0258               
0259               txt.info.menu
0260                       byte  26
0261 786A ....             text  'File / Basic / Help / Quit'
0262                       even
0263               
0264 7884 0007     pos.info.menu      byte 0,7,15,22,>ff
     7886 0F16 
     7888 FF28 
0265               txt.hint.menu
0266                       byte  40
0267 788A ....             text  'Press F,B,H,Q or F9 to return to editor.'
0268                       even
0269               
0270               txt.keys.menu
0271 78B2 0746             byte  7
0272 78B3 ....             text  'F9=Back'
0273                       even
0274               
0275               
0276               
0277               ;--------------------------------------------------------------
0278               ; Dialog "File"
0279               ;--------------------------------------------------------------
0280 78BA 0901     txt.head.file      byte 9,1,3
     78BC 0320 
0281 78BD ....                        text ' File '
0282                                  byte 2
0283               
0284               txt.info.file
0285 78C4 114E             byte  17
0286 78C5 ....             text  'New / Open / Save'
0287                       even
0288               
0289 78D6 0006     pos.info.file      byte 0,6,13,>ff
     78D8 0DFF 
0290               txt.hint.file
0291 78DA 2650             byte  38
0292 78DB ....             text  'Press N,O,S or F9 to return to editor.'
0293                       even
0294               
0295               txt.keys.file
0296 7902 0746             byte  7
0297 7903 ....             text  'F9=Back'
0298                       even
0299               
0300               
0301               ;--------------------------------------------------------------
0302               ; Dialog "Basic"
0303               ;--------------------------------------------------------------
0304 790A 0E01     txt.head.basic     byte 14,1,3
     790C 0320 
0305 790D ....                        text ' Run basic '
0306 7918 021C                        byte 2
0307               
0308               txt.info.basic
0309                       byte  28
0310 791A ....             text  'TI Basic / TI Extended Basic'
0311                       even
0312               
0313 7936 030E     pos.info.basic     byte 3,14,>ff
     7938 FF3E 
0314               txt.hint.basic
0315                       byte  62
0316 793A ....             text  'Press B,E for running basic dialect or F9 to return to editor.'
0317                       even
0318               
0319               txt.keys.basic
0320 7978 0746             byte  7
0321 7979 ....             text  'F9=Back'
0322                       even
0323               
0324               
0325               
0326               ;--------------------------------------------------------------
0327               ; Strings for error line pane
0328               ;--------------------------------------------------------------
0329               txt.ioerr.load
0330 7980 2049             byte  32
0331 7981 ....             text  'I/O error. Failed loading file: '
0332                       even
0333               
0334               txt.ioerr.save
0335 79A2 2049             byte  32
0336 79A3 ....             text  'I/O error. Failed saving file:  '
0337                       even
0338               
0339               txt.memfull.load
0340 79C4 4049             byte  64
0341 79C5 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0342                       even
0343               
0344               txt.io.nofile
0345 7A06 2149             byte  33
0346 7A07 ....             text  'I/O error. No filename specified.'
0347                       even
0348               
0349               txt.block.inside
0350 7A28 3445             byte  52
0351 7A29 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0352                       even
0353               
0354               
0355               ;--------------------------------------------------------------
0356               ; Strings for command buffer
0357               ;--------------------------------------------------------------
0358               txt.cmdb.prompt
0359 7A5E 013E             byte  1
0360 7A5F ....             text  '>'
0361                       even
0362               
0363               txt.colorscheme
0364 7A60 0D43             byte  13
0365 7A61 ....             text  'Color scheme:'
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
0022 7A6E DEAD             data  >dead,>beef,>dead,>beef
     7A70 BEEF 
     7A72 DEAD 
     7A74 BEEF 
**** **** ****     > stevie_b0.asm.1400279
0144               
0148 7A76 3A0C                   data $                ; Bank 0 ROM size OK.
0150                       ;------------------------------------------------------
0151                       ; Bank full check
0152                       ;------------------------------------------------------
0156 7A78 3A0E                   data $                ; Bank 0 ROM size OK.
0158               
0159               *--------------------------------------------------------------
0160               * Video mode configuration for SP2
0161               *--------------------------------------------------------------
0162      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0163      0004     spfbck  equ   >04                   ; Screen background color.
0164      33B0     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0165      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0166      0050     colrow  equ   80                    ; Columns per row
0167      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0168      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0169      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0170      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
0171               

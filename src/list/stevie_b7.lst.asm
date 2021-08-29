XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b7.asm.1355431
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b7.asm               ; Version 210829-1355431
0010               *
0011               * Bank 7 "Jonas"
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
**** **** ****     > stevie_b7.asm.1355431
0015                       copy  "rom.order.asm"       ; ROM ban k order "non-inverted"
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
0013      600C     bank6.rom                 equ  >600c   ; Jenny
0014      600E     bank7.rom                 equ  >600e   ; Jonas
0015               *--------------------------------------------------------------
0016               * RAM 4K banks (Only valid in advance mode FG99)
0017               *--------------------------------------------------------------
0018      6800     bank0.ram                 equ  >6800   ; Jill
0019      6802     bank1.ram                 equ  >6802   ; James
0020      6804     bank2.ram                 equ  >6804   ; Jacky
0021      6806     bank3.ram                 equ  >6806   ; John
0022      6808     bank4.ram                 equ  >6808   ; Janine
0023      680A     bank5.ram                 equ  >680a   ; Jumbo
0024      680C     bank6.ram                 equ  >680c   ; Jenny
0025      680E     bank7.ram                 equ  >680e   ; Jonas
**** **** ****     > stevie_b7.asm.1355431
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
0055               *     6000-7f9b    8128       0   SP2 library, code to RAM, resident modules
0056               *     ..............................................................
0057               *     6000-603f      64       1   Vector table (32 vectors)
0058               *     6040-7fff    8128       1   Stevie program code
0059               *     ..............................................................
0060               *     6000-603f      64       2   Vector table (32 vectors)
0061               *     6040-7fff    8128       2   Stevie program code
0062               *     ..............................................................
0063               *     6000-603f      64       3   Vector table (32 vectors)
0064               *     6040-7fff    8128       3   Stevie program code
0065               *     ..............................................................
0066               *     6000-603f      64       4   Vector table (32 vectors)
0067               *     6040-7fff    8128       4   Stevie program code
0068               *     ..............................................................
0069               *     6000-603f      64       5   Vector table (32 vectors)
0070               *     6040-7fff    8128       5   Stevie program code
0071               *     ..............................................................
0072               *
0073               *
0074               * VDP RAM F18a (0000-47ff)
0075               *
0076               *     Mem range   Bytes    Hex    Purpose
0077               *     =========   =====   =====   =================================
0078               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0079               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0080               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0081               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0082               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0083               *                                      (Position based colors F18a, 80 colums)
0084               *     2180                        SAT: Sprite Attribute Table
0085               *                                      (Cursor in F18a, 80 cols mode)
0086               *     2800                        SPT: Sprite Pattern Table
0087               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0088               *===============================================================================
0089               
0090               *--------------------------------------------------------------
0091               * Graphics mode selection
0092               *--------------------------------------------------------------
0094               
0095      001D     pane.botrow               equ  29      ; Bottom row on screen
0096               
0102               *--------------------------------------------------------------
0103               * Stevie Dialog / Pane specific equates
0104               *--------------------------------------------------------------
0105      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0106      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0107               ;-----------------------------------------------------------------
0108               ;   Dialog ID's >= 100 indicate that command prompt should be
0109               ;   hidden and no characters added to CMDB keyboard buffer
0110               ;-----------------------------------------------------------------
0111      000A     id.dialog.load            equ  10      ; "Load DV80 file"
0112      000B     id.dialog.save            equ  11      ; "Save DV80 file"
0113      000C     id.dialog.saveblock       equ  12      ; "Save codeblock to DV80 file"
0114      0064     id.dialog.menu            equ  100     ; "Stevie Menu"
0115      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0116      0066     id.dialog.block           equ  102     ; "Block move/copy/delete"
0117      0067     id.dialog.about           equ  103     ; "About"
0118      0068     id.dialog.file            equ  104     ; "File"
0119      0069     id.dialog.basic           equ  105     ; "Basic"
0120               *--------------------------------------------------------------
0121               * Stevie specific equates
0122               *--------------------------------------------------------------
0123      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0124      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0125      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0126      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0127      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0128      1FD0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0129                                                      ; VDP TAT address of 1st CMDB row
0130      0960     vdp.sit.size              equ  (pane.botrow + 1) * 80
0131                                                      ; VDP SIT size 80 columns, 24/30 rows
0132      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0133      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0134               *--------------------------------------------------------------
0135               * SPECTRA2 / Stevie startup options
0136               *--------------------------------------------------------------
0137      0001     debug                     equ  1       ; Turn on spectra2 debugging
0138      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0139      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0140      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0141      7E00     cpu.scrpad.tgt            equ  >7e00   ; Scratchpad dump of OS Monitor in bank3
0142               *--------------------------------------------------------------
0143               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0144               *--------------------------------------------------------------
0145      2F20     parm1             equ  >2f20           ; Function parameter 1
0146      2F22     parm2             equ  >2f22           ; Function parameter 2
0147      2F24     parm3             equ  >2f24           ; Function parameter 3
0148      2F26     parm4             equ  >2f26           ; Function parameter 4
0149      2F28     parm5             equ  >2f28           ; Function parameter 5
0150      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0151      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0152      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0153      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0154      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0155      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0156      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0157      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0158      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0159      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0160      2F3E     keyrptcnt         equ  >2f3e           ; Key repeat-count (auto-repeat function)
0161      2F40     keycode1          equ  >2f40           ; Current key scanned
0162      2F42     keycode2          equ  >2f42           ; Previous key scanned
0163      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0164      2F4A     timers            equ  >2f4a           ; Timer table
0165      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0166      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0167               *--------------------------------------------------------------
0168               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0169               *--------------------------------------------------------------
0170      A000     tv.top            equ  >a000           ; Structure begin
0171      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0172      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0173      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0174      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0175      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0176      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0177      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0178      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0179      A010     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0180      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0181      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0182      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0183      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0184      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0185      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0186      A01E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0187      A020     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0188      A022     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0189      A024     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0190      A026     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0191      A028     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0192      A02A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0193      A0CA     tv.free           equ  tv.top + 202    ; End of structure
0194               *--------------------------------------------------------------
0195               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0196               *--------------------------------------------------------------
0197      A100     fb.struct         equ  >a100           ; Structure begin
0198      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0199      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0200      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0201                                                      ; line X in editor buffer).
0202      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0203                                                      ; (offset 0 .. @fb.scrrows)
0204      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0205      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0206      A10C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0207      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0208      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0209      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0210      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0211      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0212      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0213      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0214      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0215      A11E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0216      A16E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0217      A1BE     fb.free           equ  fb.struct + 190 ; End of structure
0218               *--------------------------------------------------------------
0219               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0220               *--------------------------------------------------------------
0221      A200     edb.struct        equ  >a200           ; Begin structure
0222      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0223      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0224      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0225      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0226      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0227      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0228      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0229      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0230      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0231      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0232                                                      ; with current filename.
0233      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0234                                                      ; with current file type.
0235      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0236      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0237      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0238                                                      ; for filename, but not always used.
0239      A269     edb.free          equ  edb.struct + 105; End of structure
0240               *--------------------------------------------------------------
0241               * Command buffer structure            @>a300-a3ff   (256 bytes)
0242               *--------------------------------------------------------------
0243      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0244      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0245      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0246      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0247      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0248      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0249      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0250      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0251      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0252      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0253      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0254      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0255      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0256      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0257      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0258      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0259      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0260      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0261      A322     cmdb.panmarkers   equ  cmdb.struct + 34; Pointer to key marker list  (3rd line)
0262      A324     cmdb.pankeys      equ  cmdb.struct + 36; Pointer to string pane keys (stat line)
0263      A326     cmdb.action.ptr   equ  cmdb.struct + 38; Pointer to function to execute
0264      A328     cmdb.cmdlen       equ  cmdb.struct + 40; Length of current command (MSB byte!)
0265      A329     cmdb.cmd          equ  cmdb.struct + 41; Current command (80 bytes max.)
0266      A379     cmdb.free         equ  cmdb.struct +121; End of structure
0267               *--------------------------------------------------------------
0268               * File handle structure               @>a400-a4ff   (256 bytes)
0269               *--------------------------------------------------------------
0270      A400     fh.struct         equ  >a400           ; stevie file handling structures
0271               ;***********************************************************************
0272               ; ATTENTION
0273               ; The dsrlnk variables must form a continuous memory block and keep
0274               ; their order!
0275               ;***********************************************************************
0276      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0277      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0278      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0279      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0280      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0281      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0282      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0283      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0284      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0285      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0286      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0287      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0288      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0289      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0290      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0291      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0292      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0293      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0294      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0295      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0296      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0297      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0298      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0299      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0300      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0301      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0302      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0303      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0304      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0305      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0306      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0307      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0308               *--------------------------------------------------------------
0309               * Index structure                     @>a500-a5ff   (256 bytes)
0310               *--------------------------------------------------------------
0311      A500     idx.struct        equ  >a500           ; stevie index structure
0312      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0313      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0314      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0315               *--------------------------------------------------------------
0316               * Frame buffer                        @>a600-afff  (2560 bytes)
0317               *--------------------------------------------------------------
0318      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0319      0960     fb.size           equ  80*30           ; Frame buffer size
0320               *--------------------------------------------------------------
0321               * Index                               @>b000-bfff  (4096 bytes)
0322               *--------------------------------------------------------------
0323      B000     idx.top           equ  >b000           ; Top of index
0324      1000     idx.size          equ  4096            ; Index size
0325               *--------------------------------------------------------------
0326               * Editor buffer                       @>c000-cfff  (4096 bytes)
0327               *--------------------------------------------------------------
0328      C000     edb.top           equ  >c000           ; Editor buffer high memory
0329      1000     edb.size          equ  4096            ; Editor buffer size
0330               *--------------------------------------------------------------
0331               * Command history buffer              @>d000-dfff  (4096 bytes)
0332               *--------------------------------------------------------------
0333      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0334      1000     cmdb.size         equ  4096            ; Command buffer size
0335               *--------------------------------------------------------------
0336               * Heap                                @>e000-ebff  (3072 bytes)
0337               *--------------------------------------------------------------
0338      E000     heap.top          equ  >e000           ; Top of heap
0339               *--------------------------------------------------------------
0340               * Farjump return stack                @>ec00-efff  (1024 bytes)
0341               *--------------------------------------------------------------
0342      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b7.asm.1355431
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0022                                                   ; grows downwards to >2000
0023               ***************************************************************
0024               * BANK 5
0025               ********|*****|*********************|**************************
0026      600E     bankid  equ   bank7.rom             ; Set bank identifier to current bank
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
0045 6011 ....             text  'STEVIE 1.1R'
0046                       even
0047               
0049               
**** **** ****     > stevie_b7.asm.1355431
0030               
0031               
0032               ***************************************************************
0033               * Step 1: Switch to bank 0 (uniform code accross all banks)
0034               ********|*****|*********************|**************************
0035                       aorg  kickstart.code1       ; >6040
0036 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000 
0037               ***************************************************************
0038               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0039               ********|*****|*********************|**************************
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
0034      6044     hb$00   equ   w$0000                ; >0000
0035      6056     hb$01   equ   w$0100                ; >0100
0036      6058     hb$02   equ   w$0200                ; >0200
0037      605A     hb$04   equ   w$0400                ; >0400
0038      605C     hb$08   equ   w$0800                ; >0800
0039      605E     hb$10   equ   w$1000                ; >1000
0040      6060     hb$20   equ   w$2000                ; >2000
0041      6062     hb$40   equ   w$4000                ; >4000
0042      6064     hb$80   equ   w$8000                ; >8000
0043      6068     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      6044     lb$00   equ   w$0000                ; >0000
0048      6046     lb$01   equ   w$0001                ; >0001
0049      6048     lb$02   equ   w$0002                ; >0002
0050      604A     lb$04   equ   w$0004                ; >0004
0051      604C     lb$08   equ   w$0008                ; >0008
0052      604E     lb$10   equ   w$0010                ; >0010
0053      6050     lb$20   equ   w$0020                ; >0020
0054      6052     lb$40   equ   w$0040                ; >0040
0055      6054     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      6046     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      6048     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      604A     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      604C     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      604E     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      6050     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      6052     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      6054     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      6056     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      6058     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      605A     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      605C     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      605E     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      6060     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      6062     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      6064     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      6060     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6056     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6052     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      604E     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
     60C8 6E9E 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 60CA 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     60CC 634A 
0078 60CE 6230                   data graph1           ; Equate selected video mode table
0079               
0080 60D0 06A0  32         bl    @ldfnt
     60D2 63B2 
0081 60D4 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     60D6 000C 
0082               
0083 60D8 06A0  32         bl    @filv
     60DA 62E0 
0084 60DC 0380                   data >0380,>f0,32*24  ; Load color table
     60DE 00F0 
     60E0 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 60E2 06A0  32         bl    @putat                ; Show crash message
     60E4 6494 
0089 60E6 0000                   data >0000,cpu.crash.msg.crashed
     60E8 61BC 
0090               
0091 60EA 06A0  32         bl    @puthex               ; Put hex value on screen
     60EC 6A22 
0092 60EE 0015                   byte 0,21             ; \ i  p0 = YX position
0093 60F0 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 60F2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 60F4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 60F6 06A0  32         bl    @putat                ; Show caller message
     60F8 6494 
0101 60FA 0100                   data >0100,cpu.crash.msg.caller
     60FC 61D2 
0102               
0103 60FE 06A0  32         bl    @puthex               ; Put hex value on screen
     6100 6A22 
0104 6102 0115                   byte 1,21             ; \ i  p0 = YX position
0105 6104 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6106 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 6108 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 610A 06A0  32         bl    @putat
     610C 6494 
0113 610E 0300                   byte 3,0
0114 6110 61EE                   data cpu.crash.msg.wp
0115 6112 06A0  32         bl    @putat
     6114 6494 
0116 6116 0400                   byte 4,0
0117 6118 61F4                   data cpu.crash.msg.st
0118 611A 06A0  32         bl    @putat
     611C 6494 
0119 611E 1600                   byte 22,0
0120 6120 61FA                   data cpu.crash.msg.source
0121 6122 06A0  32         bl    @putat
     6124 6494 
0122 6126 1700                   byte 23,0
0123 6128 6216                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 612A 06A0  32         bl    @at                   ; Put cursor at YX
     612C 6720 
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
     6150 6A2C 
0154 6152 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 6154 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 6156 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 6158 06A0  32         bl    @setx                 ; Set cursor X position
     615A 6736 
0160 615C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 615E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6160 6470 
0164 6162 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 6164 06A0  32         bl    @setx                 ; Set cursor X position
     6166 6736 
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
     6176 6470 
0176 6178 61E8                   data cpu.crash.msg.r
0177               
0178 617A 06A0  32         bl    @mknum
     617C 6A2C 
0179 617E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 6180 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 6182 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 6184 06A0  32         bl    @mkhex                ; Convert hex word to string
     6186 699E 
0188 6188 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 618A 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 618C 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 618E 06A0  32         bl    @setx                 ; Set cursor X position
     6190 6736 
0194 6192 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 6194 06A0  32         bl    @putstr               ; Put '  >'
     6196 6470 
0198 6198 61EA                   data cpu.crash.msg.marker
0199               
0200 619A 06A0  32         bl    @setx                 ; Set cursor X position
     619C 6736 
0201 619E 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61A0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A2 6470 
0205 61A4 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61AC 06A0  32         bl    @down                 ; y=y+1
     61AE 6726 
0213               
0214 61B0 0586  14         inc   tmp2
0215 61B2 0286  22         ci    tmp2,17
     61B4 0011 
0216 61B6 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61B8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61BA 6D9C 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61BC 1553             byte  21
0225 61BD ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 61D2 1543             byte  21
0230 61D3 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 61E8 0152             byte  1
0235 61E9 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 61EA 0320             byte  3
0240 61EB ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 61EE 042A             byte  4
0245 61EF ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 61F4 042A             byte  4
0250 61F5 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 61FA 1B53             byte  27
0255 61FB ....             text  'Source    stevie_b7.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 6216 1842             byte  24
0260 6217 ....             text  'Build-ID  210829-1355431'
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
0029               
0030               ***************************************************************
0031               * TI Basic mode 1 (32 columns/24 rows)
0032               *--------------------------------------------------------------
0033 623A 00E2     tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
     623C 000C 
     623E 0006 
     6240 0004 
     6242 0020 
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
0060 6244 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6246 000E 
     6248 0106 
     624A 00F4 
     624C 0028 
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
0086 624E 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6250 003F 
     6252 0240 
     6254 03F4 
     6256 0050 
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
0112 6258 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     625A 003F 
     625C 0240 
     625E 03F4 
     6260 0050 
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
0013 6262 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6264 16FD             data  >16fd                 ; |         jne   mcloop
0015 6266 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6268 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 626A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 626C 0201  20         li    r1,mccode             ; Machinecode to patch
     626E 6262 
0037 6270 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6272 8322 
0038 6274 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 6276 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 6278 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 627A 045B  20         b     *r11                  ; Return to caller
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
0056 627C C0F9  30 popr3   mov   *stack+,r3
0057 627E C0B9  30 popr2   mov   *stack+,r2
0058 6280 C079  30 popr1   mov   *stack+,r1
0059 6282 C039  30 popr0   mov   *stack+,r0
0060 6284 C2F9  30 poprt   mov   *stack+,r11
0061 6286 045B  20         b     *r11
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
0085 6288 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 628A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 628C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 628E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 6290 1604  14         jne   filchk                ; No, continue checking
0093               
0094 6292 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6294 FFCE 
0095 6296 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6298 606A 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 629A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     629C 830B 
     629E 830A 
0100               
0101 62A0 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62A2 0001 
0102 62A4 1602  14         jne   filchk2
0103 62A6 DD05  32         movb  tmp1,*tmp0+
0104 62A8 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62AA 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62AC 0002 
0109 62AE 1603  14         jne   filchk3
0110 62B0 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62B2 DD05  32         movb  tmp1,*tmp0+
0112 62B4 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62B6 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62B8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62BA 0001 
0118 62BC 1305  14         jeq   fil16b
0119 62BE DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62C0 0606  14         dec   tmp2
0121 62C2 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62C4 0002 
0122 62C6 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62C8 C1C6  18 fil16b  mov   tmp2,tmp3
0127 62CA 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62CC 0001 
0128 62CE 1301  14         jeq   dofill
0129 62D0 0606  14         dec   tmp2                  ; Make TMP2 even
0130 62D2 CD05  34 dofill  mov   tmp1,*tmp0+
0131 62D4 0646  14         dect  tmp2
0132 62D6 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 62D8 C1C7  18         mov   tmp3,tmp3
0137 62DA 1301  14         jeq   fil.exit
0138 62DC DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 62DE 045B  20         b     *r11
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
0159 62E0 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 62E2 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 62E4 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 62E6 0264  22 xfilv   ori   tmp0,>4000
     62E8 4000 
0166 62EA 06C4  14         swpb  tmp0
0167 62EC D804  38         movb  tmp0,@vdpa
     62EE 8C02 
0168 62F0 06C4  14         swpb  tmp0
0169 62F2 D804  38         movb  tmp0,@vdpa
     62F4 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 62F6 020F  20         li    r15,vdpw              ; Set VDP write address
     62F8 8C00 
0174 62FA 06C5  14         swpb  tmp1
0175 62FC C820  54         mov   @filzz,@mcloop        ; Setup move command
     62FE 6306 
     6300 8320 
0176 6302 0460  28         b     @mcloop               ; Write data to VDP
     6304 8320 
0177               *--------------------------------------------------------------
0181 6306 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6308 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     630A 4000 
0202 630C 06C4  14 vdra    swpb  tmp0
0203 630E D804  38         movb  tmp0,@vdpa
     6310 8C02 
0204 6312 06C4  14         swpb  tmp0
0205 6314 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6316 8C02 
0206 6318 045B  20         b     *r11                  ; Exit
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
0217 631A C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 631C C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 631E 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6320 4000 
0223 6322 06C4  14         swpb  tmp0                  ; \
0224 6324 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6326 8C02 
0225 6328 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 632A D804  38         movb  tmp0,@vdpa            ; /
     632C 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 632E 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6330 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 6332 045B  20         b     *r11                  ; Exit
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
0251 6334 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6336 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6338 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     633A 8C02 
0257 633C 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 633E D804  38         movb  tmp0,@vdpa            ; /
     6340 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 6342 D120  34         movb  @vdpr,tmp0            ; Read byte
     6344 8800 
0263 6346 0984  56         srl   tmp0,8                ; Right align
0264 6348 045B  20         b     *r11                  ; Exit
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
0283 634A C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 634C C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 634E C144  18         mov   tmp0,tmp1
0289 6350 05C5  14         inct  tmp1
0290 6352 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 6354 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6356 FF00 
0292 6358 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 635A C805  38         mov   tmp1,@wbase           ; Store calculated base
     635C 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 635E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6360 8000 
0298 6362 0206  20         li    tmp2,8
     6364 0008 
0299 6366 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6368 830B 
0300 636A 06C5  14         swpb  tmp1
0301 636C D805  38         movb  tmp1,@vdpa
     636E 8C02 
0302 6370 06C5  14         swpb  tmp1
0303 6372 D805  38         movb  tmp1,@vdpa
     6374 8C02 
0304 6376 0225  22         ai    tmp1,>0100
     6378 0100 
0305 637A 0606  14         dec   tmp2
0306 637C 16F4  14         jne   vidta1                ; Next register
0307 637E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6380 833A 
0308 6382 045B  20         b     *r11
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
0325 6384 C13B  30 putvr   mov   *r11+,tmp0
0326 6386 0264  22 putvrx  ori   tmp0,>8000
     6388 8000 
0327 638A 06C4  14         swpb  tmp0
0328 638C D804  38         movb  tmp0,@vdpa
     638E 8C02 
0329 6390 06C4  14         swpb  tmp0
0330 6392 D804  38         movb  tmp0,@vdpa
     6394 8C02 
0331 6396 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 6398 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 639A C10E  18         mov   r14,tmp0
0341 639C 0984  56         srl   tmp0,8
0342 639E 06A0  32         bl    @putvrx               ; Write VR#0
     63A0 6386 
0343 63A2 0204  20         li    tmp0,>0100
     63A4 0100 
0344 63A6 D820  54         movb  @r14lb,@tmp0lb
     63A8 831D 
     63AA 8309 
0345 63AC 06A0  32         bl    @putvrx               ; Write VR#1
     63AE 6386 
0346 63B0 0458  20         b     *tmp4                 ; Exit
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
0360 63B2 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63B4 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63B6 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63B8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63BA 7FFF 
0364 63BC 2120  38         coc   @wbit0,tmp0
     63BE 6064 
0365 63C0 1604  14         jne   ldfnt1
0366 63C2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63C4 8000 
0367 63C6 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63C8 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63CA C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63CC 6434 
0372 63CE D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63D0 9C02 
0373 63D2 06C4  14         swpb  tmp0
0374 63D4 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     63D6 9C02 
0375 63D8 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     63DA 9800 
0376 63DC 06C5  14         swpb  tmp1
0377 63DE D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     63E0 9800 
0378 63E2 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 63E4 D805  38         movb  tmp1,@grmwa
     63E6 9C02 
0383 63E8 06C5  14         swpb  tmp1
0384 63EA D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     63EC 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 63EE C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 63F0 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     63F2 6308 
0390 63F4 05C8  14         inct  tmp4                  ; R11=R11+2
0391 63F6 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 63F8 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63FA 7FFF 
0393 63FC C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63FE 6436 
0394 6400 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6402 6438 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 6404 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6406 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6408 D120  34         movb  @grmrd,tmp0
     640A 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 640C 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     640E 6064 
0405 6410 1603  14         jne   ldfnt3                ; No, so skip
0406 6412 D1C4  18         movb  tmp0,tmp3
0407 6414 0917  56         srl   tmp3,1
0408 6416 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6418 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     641A 8C00 
0413 641C 0606  14         dec   tmp2
0414 641E 16F2  14         jne   ldfnt2
0415 6420 05C8  14         inct  tmp4                  ; R11=R11+2
0416 6422 020F  20         li    r15,vdpw              ; Set VDP write address
     6424 8C00 
0417 6426 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6428 7FFF 
0418 642A 0458  20         b     *tmp4                 ; Exit
0419 642C D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     642E 6044 
     6430 8C00 
0420 6432 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 6434 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6436 0200 
     6438 0000 
0425 643A 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     643C 01C0 
     643E 0101 
0426 6440 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6442 02A0 
     6444 0101 
0427 6446 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6448 00E0 
     644A 0101 
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
0445 644C C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 644E C3A0  34         mov   @wyx,r14              ; Get YX
     6450 832A 
0447 6452 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 6454 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6456 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6458 C3A0  34         mov   @wyx,r14              ; Get YX
     645A 832A 
0454 645C 024E  22         andi  r14,>00ff             ; Remove Y
     645E 00FF 
0455 6460 A3CE  18         a     r14,r15               ; pos = pos + X
0456 6462 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6464 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 6466 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 6468 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 646A 020F  20         li    r15,vdpw              ; VDP write address
     646C 8C00 
0463 646E 045B  20         b     *r11
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
0481 6470 C17B  30 putstr  mov   *r11+,tmp1
0482 6472 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 6474 C1CB  18 xutstr  mov   r11,tmp3
0484 6476 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6478 644C 
0485 647A C2C7  18         mov   tmp3,r11
0486 647C 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 647E C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 6480 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 6482 0286  22         ci    tmp2,255              ; Length > 255 ?
     6484 00FF 
0494 6486 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 6488 0460  28         b     @xpym2v               ; Display string
     648A 64DE 
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 648C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     648E FFCE 
0501 6490 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6492 606A 
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
0517 6494 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6496 832A 
0518 6498 0460  28         b     @putstr
     649A 6470 
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
0539 649C 0649  14         dect  stack
0540 649E C64B  30         mov   r11,*stack            ; Save return address
0541 64A0 0649  14         dect  stack
0542 64A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 64A4 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 64A6 0987  56         srl   tmp3,8                ; Right align
0549               
0550 64A8 0649  14         dect  stack
0551 64AA C645  30         mov   tmp1,*stack           ; Push tmp1
0552 64AC 0649  14         dect  stack
0553 64AE C646  30         mov   tmp2,*stack           ; Push tmp2
0554 64B0 0649  14         dect  stack
0555 64B2 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 64B4 06A0  32         bl    @xutst0               ; Display string
     64B6 6472 
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 64B8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 64BA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 64BC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 64BE 06A0  32         bl    @down                 ; Move cursor down
     64C0 6726 
0566               
0567 64C2 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 64C4 0585  14         inc   tmp1                  ; Consider length byte
0569 64C6 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     64C8 6046 
0570 64CA 1301  14         jeq   !                     ; Yes, skip adjustment
0571 64CC 0585  14         inc   tmp1                  ; Make address even
0572 64CE 0606  14 !       dec   tmp2
0573 64D0 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 64D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 64D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 64D6 045B  20         b     *r11                  ; Return
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
0020 64D8 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64DA C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64DC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 64DE C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64E0 1604  14         jne   !                     ; No, continue
0028               
0029 64E2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64E4 FFCE 
0030 64E6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64E8 606A 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64EA 0264  22 !       ori   tmp0,>4000
     64EC 4000 
0035 64EE 06C4  14         swpb  tmp0
0036 64F0 D804  38         movb  tmp0,@vdpa
     64F2 8C02 
0037 64F4 06C4  14         swpb  tmp0
0038 64F6 D804  38         movb  tmp0,@vdpa
     64F8 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 64FA 020F  20         li    r15,vdpw              ; Set VDP write address
     64FC 8C00 
0043 64FE C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6500 6508 
     6502 8320 
0044 6504 0460  28         b     @mcloop               ; Write data to VDP and return
     6506 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 6508 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 650A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 650C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 650E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6510 06C4  14 xpyv2m  swpb  tmp0
0027 6512 D804  38         movb  tmp0,@vdpa
     6514 8C02 
0028 6516 06C4  14         swpb  tmp0
0029 6518 D804  38         movb  tmp0,@vdpa
     651A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 651C 020F  20         li    r15,vdpr              ; Set VDP read address
     651E 8800 
0034 6520 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6522 652A 
     6524 8320 
0035 6526 0460  28         b     @mcloop               ; Read data from VDP
     6528 8320 
0036 652A DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 652C C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 652E C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6530 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6532 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6534 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6536 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6538 FFCE 
0034 653A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     653C 606A 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 653E 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6540 0001 
0039 6542 1603  14         jne   cpym0                 ; No, continue checking
0040 6544 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6546 04C6  14         clr   tmp2                  ; Reset counter
0042 6548 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 654A 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     654C 7FFF 
0047 654E C1C4  18         mov   tmp0,tmp3
0048 6550 0247  22         andi  tmp3,1
     6552 0001 
0049 6554 1618  14         jne   cpyodd                ; Odd source address handling
0050 6556 C1C5  18 cpym1   mov   tmp1,tmp3
0051 6558 0247  22         andi  tmp3,1
     655A 0001 
0052 655C 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 655E 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6560 6064 
0057 6562 1605  14         jne   cpym3
0058 6564 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     6566 658C 
     6568 8320 
0059 656A 0460  28         b     @mcloop               ; Copy memory and exit
     656C 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 656E C1C6  18 cpym3   mov   tmp2,tmp3
0064 6570 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6572 0001 
0065 6574 1301  14         jeq   cpym4
0066 6576 0606  14         dec   tmp2                  ; Make TMP2 even
0067 6578 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 657A 0646  14         dect  tmp2
0069 657C 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 657E C1C7  18         mov   tmp3,tmp3
0074 6580 1301  14         jeq   cpymz
0075 6582 D554  38         movb  *tmp0,*tmp1
0076 6584 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 6586 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     6588 8000 
0081 658A 10E9  14         jmp   cpym2
0082 658C DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 658E C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6590 0649  14         dect  stack
0065 6592 C64B  30         mov   r11,*stack            ; Push return address
0066 6594 0649  14         dect  stack
0067 6596 C640  30         mov   r0,*stack             ; Push r0
0068 6598 0649  14         dect  stack
0069 659A C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 659C 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 659E 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 65A0 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     65A2 4000 
0077 65A4 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     65A6 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 65A8 020C  20         li    r12,>1e00             ; SAMS CRU address
     65AA 1E00 
0082 65AC 04C0  14         clr   r0
0083 65AE 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65B0 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65B2 D100  18         movb  r0,tmp0
0086 65B4 0984  56         srl   tmp0,8                ; Right align
0087 65B6 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65B8 833C 
0088 65BA 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65BC C339  30         mov   *stack+,r12           ; Pop r12
0094 65BE C039  30         mov   *stack+,r0            ; Pop r0
0095 65C0 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65C2 045B  20         b     *r11                  ; Return to caller
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
0131 65C4 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65C6 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65C8 0649  14         dect  stack
0135 65CA C64B  30         mov   r11,*stack            ; Push return address
0136 65CC 0649  14         dect  stack
0137 65CE C640  30         mov   r0,*stack             ; Push r0
0138 65D0 0649  14         dect  stack
0139 65D2 C64C  30         mov   r12,*stack            ; Push r12
0140 65D4 0649  14         dect  stack
0141 65D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65D8 0649  14         dect  stack
0143 65DA C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65DC 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65DE 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 65E0 0284  22         ci    tmp0,255              ; Crash if page > 255
     65E2 00FF 
0153 65E4 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 65E6 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65E8 001E 
0158 65EA 150A  14         jgt   !
0159 65EC 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65EE 0004 
0160 65F0 1107  14         jlt   !
0161 65F2 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65F4 0012 
0162 65F6 1508  14         jgt   sams.page.set.switch_page
0163 65F8 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65FA 0006 
0164 65FC 1501  14         jgt   !
0165 65FE 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 6600 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6602 FFCE 
0170 6604 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6606 606A 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 6608 020C  20         li    r12,>1e00             ; SAMS CRU address
     660A 1E00 
0176 660C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 660E 06C0  14         swpb  r0                    ; LSB to MSB
0178 6610 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6612 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6614 4000 
0180 6616 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6618 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 661A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 661C C339  30         mov   *stack+,r12           ; Pop r12
0188 661E C039  30         mov   *stack+,r0            ; Pop r0
0189 6620 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 6622 045B  20         b     *r11                  ; Return to caller
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
0204 6624 020C  20         li    r12,>1e00             ; SAMS CRU address
     6626 1E00 
0205 6628 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 662A 045B  20         b     *r11                  ; Return to caller
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
0227 662C 020C  20         li    r12,>1e00             ; SAMS CRU address
     662E 1E00 
0228 6630 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6632 045B  20         b     *r11                  ; Return to caller
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
0260 6634 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 6636 0649  14         dect  stack
0263 6638 C64B  30         mov   r11,*stack            ; Save return address
0264 663A 0649  14         dect  stack
0265 663C C644  30         mov   tmp0,*stack           ; Save tmp0
0266 663E 0649  14         dect  stack
0267 6640 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6642 0649  14         dect  stack
0269 6644 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 6646 0649  14         dect  stack
0271 6648 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 664A 0206  20         li    tmp2,8                ; Set loop counter
     664C 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 664E C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6650 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 6652 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6654 65C8 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 6656 0606  14         dec   tmp2                  ; Next iteration
0288 6658 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 665A 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     665C 6624 
0294                                                   ; / activating changes.
0295               
0296 665E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 6660 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 6662 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 6664 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 6666 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 6668 045B  20         b     *r11                  ; Return to caller
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
0318 666A 0649  14         dect  stack
0319 666C C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 666E 06A0  32         bl    @sams.layout
     6670 6634 
0324 6672 6678                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 6674 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 6676 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 6678 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     667A 0002 
0336 667C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     667E 0003 
0337 6680 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6682 000A 
0338 6684 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     6686 000B 
0339 6688 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     668A 000C 
0340 668C D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     668E 000D 
0341 6690 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6692 000E 
0342 6694 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     6696 000F 
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
0363 6698 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 669A 0649  14         dect  stack
0366 669C C64B  30         mov   r11,*stack            ; Push return address
0367 669E 0649  14         dect  stack
0368 66A0 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 66A2 0649  14         dect  stack
0370 66A4 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 66A6 0649  14         dect  stack
0372 66A8 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66AA 0649  14         dect  stack
0374 66AC C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66AE 0205  20         li    tmp1,sams.layout.copy.data
     66B0 66D0 
0379 66B2 0206  20         li    tmp2,8                ; Set loop counter
     66B4 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66B6 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66B8 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66BA 6590 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66BC CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66BE 833C 
0390               
0391 66C0 0606  14         dec   tmp2                  ; Next iteration
0392 66C2 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66C4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66C6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66C8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66CC C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66CE 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66D0 2000             data  >2000                 ; >2000-2fff
0408 66D2 3000             data  >3000                 ; >3000-3fff
0409 66D4 A000             data  >a000                 ; >a000-afff
0410 66D6 B000             data  >b000                 ; >b000-bfff
0411 66D8 C000             data  >c000                 ; >c000-cfff
0412 66DA D000             data  >d000                 ; >d000-dfff
0413 66DC E000             data  >e000                 ; >e000-efff
0414 66DE F000             data  >f000                 ; >f000-ffff
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
0009 66E0 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66E2 FFBF 
0010 66E4 0460  28         b     @putv01
     66E6 6398 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66E8 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66EA 0040 
0018 66EC 0460  28         b     @putv01
     66EE 6398 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66F0 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66F2 FFDF 
0026 66F4 0460  28         b     @putv01
     66F6 6398 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66F8 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66FA 0020 
0034 66FC 0460  28         b     @putv01
     66FE 6398 
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
0010 6700 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6702 FFFE 
0011 6704 0460  28         b     @putv01
     6706 6398 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6708 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     670A 0001 
0019 670C 0460  28         b     @putv01
     670E 6398 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6710 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6712 FFFD 
0027 6714 0460  28         b     @putv01
     6716 6398 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6718 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     671A 0002 
0035 671C 0460  28         b     @putv01
     671E 6398 
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
0018 6720 C83B  50 at      mov   *r11+,@wyx
     6722 832A 
0019 6724 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6726 B820  54 down    ab    @hb$01,@wyx
     6728 6056 
     672A 832A 
0028 672C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 672E 7820  54 up      sb    @hb$01,@wyx
     6730 6056 
     6732 832A 
0037 6734 045B  20         b     *r11
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
0049 6736 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6738 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     673A 832A 
0051 673C C804  38         mov   tmp0,@wyx             ; Save as new YX position
     673E 832A 
0052 6740 045B  20         b     *r11
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
0021 6742 C120  34 yx2px   mov   @wyx,tmp0
     6744 832A 
0022 6746 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6748 06C4  14         swpb  tmp0                  ; Y<->X
0024 674A 04C5  14         clr   tmp1                  ; Clear before copy
0025 674C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 674E 20A0  38         coc   @wbit1,config         ; f18a present ?
     6750 6062 
0030 6752 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6754 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6756 833A 
     6758 6782 
0032 675A 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 675C 0A15  56         sla   tmp1,1                ; X = X * 2
0035 675E B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6760 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6762 0500 
0037 6764 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6766 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6768 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 676A 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 676C D105  18         movb  tmp1,tmp0
0051 676E 06C4  14         swpb  tmp0                  ; X<->Y
0052 6770 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6772 6064 
0053 6774 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6776 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6778 6056 
0059 677A 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     677C 6068 
0060 677E 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6780 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6782 0050            data   80
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
0013 6784 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6786 06A0  32         bl    @putvr                ; Write once
     6788 6384 
0015 678A 391C             data  >391c                 ; VR1/57, value 00011100
0016 678C 06A0  32         bl    @putvr                ; Write twice
     678E 6384 
0017 6790 391C             data  >391c                 ; VR1/57, value 00011100
0018 6792 06A0  32         bl    @putvr
     6794 6384 
0019 6796 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 6798 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 679A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 679C 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     679E 6384 
0030 67A0 3900             data  >3900
0031 67A2 0458  20         b     *tmp4                 ; Exit
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
0043 67A4 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0044 67A6 06A0  32         bl    @cpym2v
     67A8 64D8 
0045 67AA 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     67AC 67E8 
     67AE 0006 
0046 67B0 06A0  32         bl    @putvr
     67B2 6384 
0047 67B4 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0048 67B6 06A0  32         bl    @putvr
     67B8 6384 
0049 67BA 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0050                                                   ; GPU code should run now
0051               ***************************************************************
0052               * VDP @>3f00 == 0 ? F18A present : F18a not present
0053               ***************************************************************
0054 67BC 0204  20         li    tmp0,>3f00
     67BE 3F00 
0055 67C0 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67C2 630C 
0056 67C4 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67C6 8800 
0057 67C8 0984  56         srl   tmp0,8
0058 67CA D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67CC 8800 
0059 67CE C104  18         mov   tmp0,tmp0             ; For comparing with 0
0060 67D0 1303  14         jeq   f18chk_yes
0061               f18chk_no:
0062 67D2 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67D4 BFFF 
0063 67D6 1002  14         jmp   f18chk_exit
0064               f18chk_yes:
0065 67D8 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67DA 4000 
0066               f18chk_exit:
0067 67DC 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     67DE 62E0 
0068 67E0 3F00             data  >3f00,>00,6
     67E2 0000 
     67E4 0006 
0069 67E6 0458  20         b     *tmp4                 ; Exit
0070               ***************************************************************
0071               * GPU code
0072               ********|*****|*********************|**************************
0073               f18chk_gpu
0074 67E8 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0075 67EA 3F00             data  >3f00                 ; 3f02 / 3f00
0076 67EC 0340             data  >0340                 ; 3f04   0340  idle
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
0097 67EE C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0098                       ;------------------------------------------------------
0099                       ; Reset all F18a VDP registers to power-on defaults
0100                       ;------------------------------------------------------
0101 67F0 06A0  32         bl    @putvr
     67F2 6384 
0102 67F4 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0103               
0104 67F6 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     67F8 6384 
0105 67FA 3900             data  >3900                 ; Lock the F18a
0106 67FC 0458  20         b     *tmp4                 ; Exit
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
0125 67FE C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0126 6800 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6802 6062 
0127 6804 1609  14         jne   f18fw1
0128               ***************************************************************
0129               * Read F18A major/minor version
0130               ***************************************************************
0131 6806 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6808 8802 
0132 680A 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     680C 6384 
0133 680E 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0134 6810 04C4  14         clr   tmp0
0135 6812 D120  34         movb  @vdps,tmp0
     6814 8802 
0136 6816 0984  56         srl   tmp0,8
0137 6818 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 681A C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     681C 832A 
0018 681E D17B  28         movb  *r11+,tmp1
0019 6820 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6822 D1BB  28         movb  *r11+,tmp2
0021 6824 0986  56         srl   tmp2,8                ; Repeat count
0022 6826 C1CB  18         mov   r11,tmp3
0023 6828 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     682A 644C 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 682C 020B  20         li    r11,hchar1
     682E 6834 
0028 6830 0460  28         b     @xfilv                ; Draw
     6832 62E6 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6834 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6836 6066 
0033 6838 1302  14         jeq   hchar2                ; Yes, exit
0034 683A C2C7  18         mov   tmp3,r11
0035 683C 10EE  14         jmp   hchar                 ; Next one
0036 683E 05C7  14 hchar2  inct  tmp3
0037 6840 0457  20         b     *tmp3                 ; Exit
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
0016 6842 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6844 6064 
0017 6846 020C  20         li    r12,>0024
     6848 0024 
0018 684A 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     684C 68DE 
0019 684E 04C6  14         clr   tmp2
0020 6850 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6852 04CC  14         clr   r12
0025 6854 1F08  20         tb    >0008                 ; Shift-key ?
0026 6856 1302  14         jeq   realk1                ; No
0027 6858 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     685A 690E 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 685C 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 685E 1302  14         jeq   realk2                ; No
0033 6860 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6862 693E 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6864 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6866 1302  14         jeq   realk3                ; No
0039 6868 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     686A 696E 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 686C 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     686E 6050 
0044 6870 1E15  20         sbz   >0015                 ; Set P5
0045 6872 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 6874 1302  14         jeq   realk4                ; No
0047 6876 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     6878 6050 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 687A 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 687C 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     687E 0006 
0053 6880 0606  14 realk5  dec   tmp2
0054 6882 020C  20         li    r12,>24               ; CRU address for P2-P4
     6884 0024 
0055 6886 06C6  14         swpb  tmp2
0056 6888 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 688A 06C6  14         swpb  tmp2
0058 688C 020C  20         li    r12,6                 ; CRU read address
     688E 0006 
0059 6890 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 6892 0547  14         inv   tmp3                  ;
0061 6894 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6896 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 6898 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 689A 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 689C 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 689E 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 68A0 0285  22         ci    tmp1,8
     68A2 0008 
0070 68A4 1AFA  14         jl    realk6
0071 68A6 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 68A8 1BEB  14         jh    realk5                ; No, next column
0073 68AA 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 68AC C206  18 realk8  mov   tmp2,tmp4
0078 68AE 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 68B0 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 68B2 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 68B4 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 68B6 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 68B8 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 68BA 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     68BC 6050 
0089 68BE 1608  14         jne   realka                ; No, continue saving key
0090 68C0 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     68C2 6908 
0091 68C4 1A05  14         jl    realka
0092 68C6 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     68C8 6906 
0093 68CA 1B02  14         jh    realka                ; No, continue
0094 68CC 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     68CE E000 
0095 68D0 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     68D2 833C 
0096 68D4 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     68D6 604E 
0097 68D8 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     68DA 8C00 
0098                                                   ; / using R15 as temp storage
0099 68DC 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 68DE FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     68E0 0000 
     68E2 FF0D 
     68E4 203D 
0102 68E6 ....             text  'xws29ol.'
0103 68EE ....             text  'ced38ik,'
0104 68F6 ....             text  'vrf47ujm'
0105 68FE ....             text  'btg56yhn'
0106 6906 ....             text  'zqa10p;/'
0107 690E FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6910 0000 
     6912 FF0D 
     6914 202B 
0108 6916 ....             text  'XWS@(OL>'
0109 691E ....             text  'CED#*IK<'
0110 6926 ....             text  'VRF$&UJM'
0111 692E ....             text  'BTG%^YHN'
0112 6936 ....             text  'ZQA!)P:-'
0113 693E FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6940 0000 
     6942 FF0D 
     6944 2005 
0114 6946 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6948 0804 
     694A 0F27 
     694C C2B9 
0115 694E 600B             data  >600b,>0907,>063f,>c1B8
     6950 0907 
     6952 063F 
     6954 C1B8 
0116 6956 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6958 7B02 
     695A 015F 
     695C C0C3 
0117 695E BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6960 7D0E 
     6962 0CC6 
     6964 BFC4 
0118 6966 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6968 7C03 
     696A BC22 
     696C BDBA 
0119 696E FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6970 0000 
     6972 FF0D 
     6974 209D 
0120 6976 9897             data  >9897,>93b2,>9f8f,>8c9B
     6978 93B2 
     697A 9F8F 
     697C 8C9B 
0121 697E 8385             data  >8385,>84b3,>9e89,>8b80
     6980 84B3 
     6982 9E89 
     6984 8B80 
0122 6986 9692             data  >9692,>86b4,>b795,>8a8D
     6988 86B4 
     698A B795 
     698C 8A8D 
0123 698E 8294             data  >8294,>87b5,>b698,>888E
     6990 87B5 
     6992 B698 
     6994 888E 
0124 6996 9A91             data  >9a91,>81b1,>b090,>9cBB
     6998 81B1 
     699A B090 
     699C 9CBB 
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
0023 699E C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 69A0 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     69A2 8340 
0025 69A4 04E0  34         clr   @waux1
     69A6 833C 
0026 69A8 04E0  34         clr   @waux2
     69AA 833E 
0027 69AC 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     69AE 833C 
0028 69B0 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 69B2 0205  20         li    tmp1,4                ; 4 nibbles
     69B4 0004 
0033 69B6 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 69B8 0246  22         andi  tmp2,>000f            ; Only keep LSN
     69BA 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 69BC 0286  22         ci    tmp2,>000a
     69BE 000A 
0039 69C0 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 69C2 C21B  26         mov   *r11,tmp4
0045 69C4 0988  56         srl   tmp4,8                ; Right justify
0046 69C6 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     69C8 FFF6 
0047 69CA 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 69CC C21B  26         mov   *r11,tmp4
0054 69CE 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     69D0 00FF 
0055               
0056 69D2 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 69D4 06C6  14         swpb  tmp2
0058 69D6 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 69D8 0944  56         srl   tmp0,4                ; Next nibble
0060 69DA 0605  14         dec   tmp1
0061 69DC 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 69DE 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     69E0 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 69E2 C160  34         mov   @waux3,tmp1           ; Get pointer
     69E4 8340 
0067 69E6 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 69E8 0585  14         inc   tmp1                  ; Next byte, not word!
0069 69EA C120  34         mov   @waux2,tmp0
     69EC 833E 
0070 69EE 06C4  14         swpb  tmp0
0071 69F0 DD44  32         movb  tmp0,*tmp1+
0072 69F2 06C4  14         swpb  tmp0
0073 69F4 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 69F6 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     69F8 8340 
0078 69FA D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     69FC 605A 
0079 69FE 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6A00 C120  34         mov   @waux1,tmp0
     6A02 833C 
0084 6A04 06C4  14         swpb  tmp0
0085 6A06 DD44  32         movb  tmp0,*tmp1+
0086 6A08 06C4  14         swpb  tmp0
0087 6A0A DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6A0C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A0E 6064 
0092 6A10 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6A12 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6A14 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6A16 7FFF 
0098 6A18 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A1A 8340 
0099 6A1C 0460  28         b     @xutst0               ; Display string
     6A1E 6472 
0100 6A20 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A22 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A24 832A 
0122 6A26 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A28 8000 
0123 6A2A 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6A2C 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A2E 0005 
0020 6A30 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A32 C155  26         mov   *tmp1,tmp1            ; /
0022 6A34 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A36 0228  22         ai    tmp4,4                ; Get end of buffer
     6A38 0004 
0024 6A3A 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A3C 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A3E 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A40 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A42 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A44 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A46 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A48 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6A4A 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A4C 0607  14         dec   tmp3                  ; Decrease counter
0036 6A4E 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A50 0207  20         li    tmp3,4                ; Check first 4 digits
     6A52 0004 
0041 6A54 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A56 C11B  26         mov   *r11,tmp0
0043 6A58 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6A5A 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6A5C 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6A5E 05CB  14 mknum3  inct  r11
0047 6A60 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A62 6064 
0048 6A64 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6A66 045B  20         b     *r11                  ; Exit
0050 6A68 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6A6A 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6A6C 13F8  14         jeq   mknum3                ; Yes, exit
0053 6A6E 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6A70 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6A72 7FFF 
0058 6A74 C10B  18         mov   r11,tmp0
0059 6A76 0224  22         ai    tmp0,-4
     6A78 FFFC 
0060 6A7A C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6A7C 0206  20         li    tmp2,>0500            ; String length = 5
     6A7E 0500 
0062 6A80 0460  28         b     @xutstr               ; Display string
     6A82 6474 
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
0093 6A84 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6A86 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6A88 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6A8A 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6A8C 0207  20         li    tmp3,5                ; Set counter
     6A8E 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6A90 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6A92 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6A94 0584  14         inc   tmp0                  ; Next character
0105 6A96 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6A98 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6A9A 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6A9C 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6A9E DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6AA0 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6AA2 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6AA4 0607  14         dec   tmp3                  ; Last character ?
0121 6AA6 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6AA8 045B  20         b     *r11                  ; Return
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
0139 6AAA C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6AAC 832A 
0140 6AAE 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AB0 8000 
0141 6AB2 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6AB4 0649  14         dect  stack
0023 6AB6 C64B  30         mov   r11,*stack            ; Save return address
0024 6AB8 0649  14         dect  stack
0025 6ABA C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6ABC 0649  14         dect  stack
0027 6ABE C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6AC0 0649  14         dect  stack
0029 6AC2 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6AC4 0649  14         dect  stack
0031 6AC6 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6AC8 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6ACA C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6ACC C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6ACE 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6AD0 0649  14         dect  stack
0044 6AD2 C64B  30         mov   r11,*stack            ; Save return address
0045 6AD4 0649  14         dect  stack
0046 6AD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6AD8 0649  14         dect  stack
0048 6ADA C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6ADC 0649  14         dect  stack
0050 6ADE C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6AE0 0649  14         dect  stack
0052 6AE2 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6AE4 C1D4  26 !       mov   *tmp0,tmp3
0057 6AE6 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6AE8 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6AEA 00FF 
0059 6AEC 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6AEE 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6AF0 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6AF2 0584  14         inc   tmp0                  ; Next byte
0067 6AF4 0607  14         dec   tmp3                  ; Shorten string length
0068 6AF6 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6AF8 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6AFA 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6AFC C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6AFE 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6B00 C187  18         mov   tmp3,tmp2
0078 6B02 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6B04 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6B06 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6B08 6532 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6B0A 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6B0C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B0E FFCE 
0090 6B10 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B12 606A 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6B14 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6B16 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B18 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B1C C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B1E 045B  20         b     *r11                  ; Return to caller
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
0123 6B20 0649  14         dect  stack
0124 6B22 C64B  30         mov   r11,*stack            ; Save return address
0125 6B24 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B26 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B28 0649  14         dect  stack
0128 6B2A C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B2C 0649  14         dect  stack
0130 6B2E C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B30 0649  14         dect  stack
0132 6B32 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B34 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B36 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B38 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B3A 0649  14         dect  stack
0144 6B3C C64B  30         mov   r11,*stack            ; Save return address
0145 6B3E 0649  14         dect  stack
0146 6B40 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B42 0649  14         dect  stack
0148 6B44 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B46 0649  14         dect  stack
0150 6B48 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B4A 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B4C 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B4E 0586  14         inc   tmp2
0161 6B50 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B52 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6B54 0286  22         ci    tmp2,255
     6B56 00FF 
0167 6B58 1505  14         jgt   string.getlenc.panic
0168 6B5A 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6B5C 0606  14         dec   tmp2                  ; One time adjustment
0174 6B5E C806  38         mov   tmp2,@waux1           ; Store length
     6B60 833C 
0175 6B62 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6B64 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B66 FFCE 
0181 6B68 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B6A 606A 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6B6C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6B6E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6B70 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6B72 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6B74 045B  20         b     *r11                  ; Return to caller
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
0056 6B76 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6B78 6B7A             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6B7A C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6B7C C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6B7E A428 
0064 6B80 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6B82 6060 
0065 6B84 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6B86 8356 
0066 6B88 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6B8A 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6B8C FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6B8E C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6B90 A434 
0073                       ;---------------------------; Inline VSBR start
0074 6B92 06C0  14         swpb  r0                    ;
0075 6B94 D800  38         movb  r0,@vdpa              ; Send low byte
     6B96 8C02 
0076 6B98 06C0  14         swpb  r0                    ;
0077 6B9A D800  38         movb  r0,@vdpa              ; Send high byte
     6B9C 8C02 
0078 6B9E D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6BA0 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6BA2 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6BA4 0704  14         seto  r4                    ; Init counter
0086 6BA6 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6BA8 A420 
0087 6BAA 0580  14 !       inc   r0                    ; Point to next char of name
0088 6BAC 0584  14         inc   r4                    ; Increment char counter
0089 6BAE 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6BB0 0007 
0090 6BB2 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6BB4 80C4  18         c     r4,r3                 ; End of name?
0093 6BB6 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6BB8 06C0  14         swpb  r0                    ;
0098 6BBA D800  38         movb  r0,@vdpa              ; Send low byte
     6BBC 8C02 
0099 6BBE 06C0  14         swpb  r0                    ;
0100 6BC0 D800  38         movb  r0,@vdpa              ; Send high byte
     6BC2 8C02 
0101 6BC4 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6BC6 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6BC8 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6BCA 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6BCC 6CE2 
0109 6BCE 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6BD0 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6BD2 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6BD4 04E0  34         clr   @>83d0
     6BD6 83D0 
0118 6BD8 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6BDA 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6BDC C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6BDE A432 
0121               
0122 6BE0 0584  14         inc   r4                    ; Adjust for dot
0123 6BE2 A804  38         a     r4,@>8356             ; Point to position after name
     6BE4 8356 
0124 6BE6 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6BE8 8356 
     6BEA A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6BEC 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6BEE 83E0 
0130 6BF0 04C1  14         clr   r1                    ; Version found of dsr
0131 6BF2 020C  20         li    r12,>0f00             ; Init cru address
     6BF4 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6BF6 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6BF8 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6BFA 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6BFC 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6BFE 0100 
0145 6C00 04E0  34         clr   @>83d0                ; Clear in case we are done
     6C02 83D0 
0146 6C04 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6C06 2000 
0147 6C08 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6C0A C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6C0C 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6C0E 1D00  20         sbo   0                     ; Turn on ROM
0154 6C10 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6C12 4000 
0155 6C14 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6C16 6CDE 
0156 6C18 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6C1A A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6C1C A40A 
0166 6C1E 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6C20 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C22 83D2 
0172                                                   ; subprogram
0173               
0174 6C24 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6C26 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6C28 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6C2A C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C2C 83D2 
0183                                                   ; subprogram
0184               
0185 6C2E 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6C30 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6C32 04C5  14         clr   r5                    ; Remove any old stuff
0194 6C34 D160  34         movb  @>8355,r5             ; Get length as counter
     6C36 8355 
0195 6C38 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6C3A 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6C3C 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6C3E 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6C40 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C42 A420 
0206 6C44 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6C46 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6C48 0605  14         dec   r5                    ; Update loop counter
0211 6C4A 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6C4C 0581  14         inc   r1                    ; Next version found
0217 6C4E C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6C50 A42A 
0218 6C52 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6C54 A42C 
0219 6C56 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6C58 A430 
0220               
0221 6C5A 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6C5C 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6C5E 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6C60 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6C62 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6C64 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6C66 A400 
0233 6C68 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6C6A C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6C6C A428 
0239                                                   ; (8 or >a)
0240 6C6E 0281  22         ci    r1,8                  ; was it 8?
     6C70 0008 
0241 6C72 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6C74 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6C76 8350 
0243                                                   ; Get error byte from @>8350
0244 6C78 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6C7A 06C0  14         swpb  r0                    ;
0252 6C7C D800  38         movb  r0,@vdpa              ; send low byte
     6C7E 8C02 
0253 6C80 06C0  14         swpb  r0                    ;
0254 6C82 D800  38         movb  r0,@vdpa              ; send high byte
     6C84 8C02 
0255 6C86 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6C88 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6C8A 09D1  56         srl   r1,13                 ; just keep error bits
0263 6C8C 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6C8E 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6C90 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6C92 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6C94 A400 
0275               dsrlnk.error.devicename_invalid:
0276 6C96 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6C98 06C1  14         swpb  r1                    ; put error in hi byte
0279 6C9A D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6C9C F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6C9E 6060 
0281                                                   ; / to indicate error
0282 6CA0 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6CA2 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6CA4 6CA6             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6CA6 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6CA8 83E0 
0316               
0317 6CAA 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6CAC 6060 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6CAE 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6CB0 A42A 
0322 6CB2 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6CB4 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6CB6 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6CB8 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6CBA C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6CBC C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6CBE 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6CC0 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6CC2 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6CC4 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6CC6 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6CC8 4000 
     6CCA 6CDE 
0337 6CCC 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6CCE 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6CD0 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6CD2 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6CD4 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6CD6 A400 
0355 6CD8 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6CDA A434 
0356               
0357 6CDC 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6CDE AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6CE0 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6CE2 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6CE4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6CE6 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6CE8 0649  14         dect  stack
0052 6CEA C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6CEC 0204  20         li    tmp0,dsrlnk.savcru
     6CEE A42A 
0057 6CF0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6CF2 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6CF4 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6CF6 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6CF8 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6CFA 37D7 
0065 6CFC C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6CFE 8370 
0066                                                   ; / location
0067 6D00 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6D02 A44C 
0068 6D04 04C5  14         clr   tmp1                  ; io.op.open
0069 6D06 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6D08 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6D0A 0649  14         dect  stack
0097 6D0C C64B  30         mov   r11,*stack            ; Save return address
0098 6D0E 0205  20         li    tmp1,io.op.close      ; io.op.close
     6D10 0001 
0099 6D12 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6D14 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6D16 0649  14         dect  stack
0125 6D18 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6D1A 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D1C 0002 
0128 6D1E 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6D20 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6D22 0649  14         dect  stack
0155 6D24 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6D26 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6D28 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6D2A 0005 
0159               
0160 6D2C C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6D2E A43E 
0161               
0162 6D30 06A0  32         bl    @xvputb               ; Write character count to PAB
     6D32 631E 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6D34 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D36 0003 
0167 6D38 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6D3A 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6D3C 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6D3E 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6D40 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6D42 1000  14         nop
0189               
0190               
0191               file.status:
0192 6D44 1000  14         nop
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
0227 6D46 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6D48 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6D4A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6D4C A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6D4E A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6D50 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6D52 631E 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6D54 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6D56 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6D58 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6D5A A44C 
0246               
0247 6D5C 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6D5E 631E 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6D60 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6D62 0009 
0254 6D64 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6D66 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6D68 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6D6A 8322 
     6D6C 833C 
0259               
0260 6D6E C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6D70 A42A 
0261 6D72 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6D74 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6D76 6B76 
0268 6D78 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6D7A 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6D7C 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6D7E 6CA2 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6D80 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6D82 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6D84 833C 
     6D86 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6D88 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6D8A A436 
0292 6D8C 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6D8E 0005 
0293 6D90 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6D92 6336 
0294 6D94 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6D96 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6D98 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6D9A 045B  20         b     *r11                  ; Return to caller
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
0020 6D9C 0300  24 tmgr    limi  0                     ; No interrupt processing
     6D9E 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6DA0 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6DA2 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6DA4 2360  38         coc   @wbit2,r13            ; C flag on ?
     6DA6 6060 
0029 6DA8 1602  14         jne   tmgr1a                ; No, so move on
0030 6DAA E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6DAC 604C 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6DAE 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6DB0 6064 
0035 6DB2 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6DB4 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6DB6 6054 
0048 6DB8 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6DBA 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6DBC 6052 
0050 6DBE 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6DC0 0460  28         b     @kthread              ; Run kernel thread
     6DC2 6E3A 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6DC4 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6DC6 6058 
0056 6DC8 13EB  14         jeq   tmgr1
0057 6DCA 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6DCC 6056 
0058 6DCE 16E8  14         jne   tmgr1
0059 6DD0 C120  34         mov   @wtiusr,tmp0
     6DD2 832E 
0060 6DD4 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6DD6 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6DD8 6E38 
0065 6DDA C10A  18         mov   r10,tmp0
0066 6DDC 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6DDE 00FF 
0067 6DE0 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6DE2 6060 
0068 6DE4 1303  14         jeq   tmgr5
0069 6DE6 0284  22         ci    tmp0,60               ; 1 second reached ?
     6DE8 003C 
0070 6DEA 1002  14         jmp   tmgr6
0071 6DEC 0284  22 tmgr5   ci    tmp0,50
     6DEE 0032 
0072 6DF0 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6DF2 1001  14         jmp   tmgr8
0074 6DF4 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6DF6 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6DF8 832C 
0079 6DFA 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6DFC FF00 
0080 6DFE C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6E00 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6E02 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6E04 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6E06 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6E08 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6E0A 830C 
     6E0C 830D 
0089 6E0E 1608  14         jne   tmgr10                ; No, get next slot
0090 6E10 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6E12 FF00 
0091 6E14 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6E16 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E18 8330 
0096 6E1A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6E1C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6E1E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6E20 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6E22 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6E24 8315 
     6E26 8314 
0103 6E28 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6E2A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6E2C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6E2E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6E30 10F7  14         jmp   tmgr10                ; Process next slot
0108 6E32 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6E34 FF00 
0109 6E36 10B4  14         jmp   tmgr1
0110 6E38 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6E3A E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E3C 6054 
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
0041 6E3E 06A0  32         bl    @realkb               ; Scan full keyboard
     6E40 6842 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E42 0460  28         b     @tmgr3                ; Exit
     6E44 6DC4 
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
0017 6E46 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E48 832E 
0018 6E4A E0A0  34         soc   @wbit7,config         ; Enable user hook
     6E4C 6056 
0019 6E4E 045B  20 mkhoo1  b     *r11                  ; Return
0020      6DA0     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6E50 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6E52 832E 
0029 6E54 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E56 FEFF 
0030 6E58 045B  20         b     *r11                  ; Return
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
0017 6E5A C13B  30 mkslot  mov   *r11+,tmp0
0018 6E5C C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6E5E C184  18         mov   tmp0,tmp2
0023 6E60 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6E62 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6E64 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6E66 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6E68 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6E6A C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6E6C 881B  46         c     *r11,@w$ffff          ; End of list ?
     6E6E 6066 
0035 6E70 1301  14         jeq   mkslo1                ; Yes, exit
0036 6E72 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6E74 05CB  14 mkslo1  inct  r11
0041 6E76 045B  20         b     *r11                  ; Exit
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
0052 6E78 C13B  30 clslot  mov   *r11+,tmp0
0053 6E7A 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6E7C A120  34         a     @wtitab,tmp0          ; Add table base
     6E7E 832C 
0055 6E80 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6E82 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6E84 045B  20         b     *r11                  ; Exit
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
0068 6E86 C13B  30 rsslot  mov   *r11+,tmp0
0069 6E88 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6E8A A120  34         a     @wtitab,tmp0          ; Add table base
     6E8C 832C 
0071 6E8E 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6E90 C154  26         mov   *tmp0,tmp1
0073 6E92 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6E94 FF00 
0074 6E96 C505  30         mov   tmp1,*tmp0
0075 6E98 045B  20         b     *r11                  ; Exit
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
0261 6E9A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6E9C 8302 
0263               *--------------------------------------------------------------
0264               * Alternative entry point
0265               *--------------------------------------------------------------
0266 6E9E 0300  24 runli1  limi  0                     ; Turn off interrupts
     6EA0 0000 
0267 6EA2 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6EA4 8300 
0268 6EA6 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6EA8 83C0 
0269               *--------------------------------------------------------------
0270               * Clear scratch-pad memory from R4 upwards
0271               *--------------------------------------------------------------
0272 6EAA 0202  20 runli2  li    r2,>8308
     6EAC 8308 
0273 6EAE 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0274 6EB0 0282  22         ci    r2,>8400
     6EB2 8400 
0275 6EB4 16FC  14         jne   runli3
0276               *--------------------------------------------------------------
0277               * Exit to TI-99/4A title screen ?
0278               *--------------------------------------------------------------
0279 6EB6 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6EB8 FFFF 
0280 6EBA 1602  14         jne   runli4                ; No, continue
0281 6EBC 0420  54         blwp  @0                    ; Yes, bye bye
     6EBE 0000 
0282               *--------------------------------------------------------------
0283               * Determine if VDP is PAL or NTSC
0284               *--------------------------------------------------------------
0285 6EC0 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6EC2 833C 
0286 6EC4 04C1  14         clr   r1                    ; Reset counter
0287 6EC6 0202  20         li    r2,10                 ; We test 10 times
     6EC8 000A 
0288 6ECA C0E0  34 runli5  mov   @vdps,r3
     6ECC 8802 
0289 6ECE 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6ED0 6064 
0290 6ED2 1302  14         jeq   runli6
0291 6ED4 0581  14         inc   r1                    ; Increase counter
0292 6ED6 10F9  14         jmp   runli5
0293 6ED8 0602  14 runli6  dec   r2                    ; Next test
0294 6EDA 16F7  14         jne   runli5
0295 6EDC 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6EDE 1250 
0296 6EE0 1202  14         jle   runli7                ; No, so it must be NTSC
0297 6EE2 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6EE4 6060 
0298               *--------------------------------------------------------------
0299               * Copy machine code to scratchpad (prepare tight loop)
0300               *--------------------------------------------------------------
0301 6EE6 06A0  32 runli7  bl    @loadmc
     6EE8 626C 
0302               *--------------------------------------------------------------
0303               * Initialize registers, memory, ...
0304               *--------------------------------------------------------------
0305 6EEA 04C1  14 runli9  clr   r1
0306 6EEC 04C2  14         clr   r2
0307 6EEE 04C3  14         clr   r3
0308 6EF0 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6EF2 3000 
0309 6EF4 020F  20         li    r15,vdpw              ; Set VDP write address
     6EF6 8C00 
0313               *--------------------------------------------------------------
0314               * Setup video memory
0315               *--------------------------------------------------------------
0317 6EF8 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6EFA 4A4A 
0318 6EFC 1605  14         jne   runlia
0319 6EFE 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6F00 62E0 
0320 6F02 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     6F04 0000 
     6F06 3000 
0325 6F08 06A0  32 runlia  bl    @filv
     6F0A 62E0 
0326 6F0C 0FC0             data  pctadr,spfclr,16      ; Load color table
     6F0E 00F4 
     6F10 0010 
0327               *--------------------------------------------------------------
0328               * Check if there is a F18A present
0329               *--------------------------------------------------------------
0333 6F12 06A0  32         bl    @f18unl               ; Unlock the F18A
     6F14 6784 
0334 6F16 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F18 67A4 
0335 6F1A 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F1C 679A 
0336               
0337 6F1E 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6F20 6384 
0338 6F22 3201                   data >3201            ; F18a VR50 (>32), bit 1
0340               *--------------------------------------------------------------
0341               * Check if there is a speech synthesizer attached
0342               *--------------------------------------------------------------
0344               *       <<skipped>>
0348               *--------------------------------------------------------------
0349               * Load video mode table & font
0350               *--------------------------------------------------------------
0351 6F24 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F26 634A 
0352 6F28 33B0             data  spvmod                ; Equate selected video mode table
0353 6F2A 0204  20         li    tmp0,spfont           ; Get font option
     6F2C 000C 
0354 6F2E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0355 6F30 1304  14         jeq   runlid                ; Yes, skip it
0356 6F32 06A0  32         bl    @ldfnt
     6F34 63B2 
0357 6F36 1100             data  fntadr,spfont         ; Load specified font
     6F38 000C 
0358               *--------------------------------------------------------------
0359               * Did a system crash occur before runlib was called?
0360               *--------------------------------------------------------------
0361 6F3A 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F3C 4A4A 
0362 6F3E 1602  14         jne   runlie                ; No, continue
0363 6F40 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F42 60CA 
0364               *--------------------------------------------------------------
0365               * Branch to main program
0366               *--------------------------------------------------------------
0367 6F44 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F46 0040 
0368 6F48 0460  28         b     @main                 ; Give control to main program
     6F4A 6046 
**** **** ****     > stevie_b7.asm.1355431
0041                                                   ; Relocated spectra2 in low MEMEXP, was
0042                                                   ; copied to >2000 from ROM in bank 0
0043                       ;------------------------------------------------------
0044                       ; End of File marker
0045                       ;------------------------------------------------------
0046 6F4C DEAD             data >dead,>beef,>dead,>beef
     6F4E BEEF 
     6F50 DEAD 
     6F52 BEEF 
0048               ***************************************************************
0049               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0050               ********|*****|*********************|**************************
0051                       aorg  >3000
0052                       ;------------------------------------------------------
0053                       ; Activate bank 1 and branch to >6046
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
     3056 606A 
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
     308C 606A 
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
     30EA 6288 
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
     3124 6288 
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
     315A 65C8 
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
     3194 65C8 
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
     31E4 65C8 
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
     3266 6288 
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
     3282 6288 
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
     32A6 6050 
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
     32D0 681A 
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
     32EA 6A2C 
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
     32FE 6A84 
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
     3340 6532 
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
     3376 606A 
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
     3386 67EE 
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
     3396 6634 
0023 3398 33C8                   data mem.sams.layout.data
0024               
0025 339A 06A0  32         bl    @sams.layout.copy
     339C 6698 
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
0013 344D ....             text  'STEVIE 1.1R'
0014                       even
0015               
0016               txt.about.build
0017 3458 4C42             byte  76
0018 3459 ....             text  'Build: 210829-1355431 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
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
0183 3650 3C46     txt.keys.load      byte 60
0184 3651 ....                        text 'File'
0185                                  byte 27
0186 3656 ....                        text 'Open: F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End '
0187               
0188 368E 3D46     txt.keys.load2     byte 61
0189 368F ....                        text 'File'
0190                                  byte 27
0191 3694 ....                        text 'Open: F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End '
0192               
0193               ;--------------------------------------------------------------
0194               ; Dialog Save DV 80 file
0195               ;--------------------------------------------------------------
0196 36CE 0103     txt.head.save      byte 19,1,3
0197 36D0 ....                        text ' Save DV80 file '
0198 36E0 0223                        byte 2
0199 36E2 0103     txt.head.save2     byte 35,1,3,32
     36E4 2053 
0200 36E5 ....                        text 'Save marked block to DV80 file '
0201 3704 0201                        byte 2
0202               txt.hint.save
0203                       byte  1
0204 3706 ....             text  ' '
0205                       even
0206               
0207               
0208 3708 2F46     txt.keys.save      byte 47
0209 3709 ....                        text 'File'
0210                                  byte 27
0211 370E ....                        text 'Save: F9=Back  F3=Clear  F-H=Home  F-L=End'
0212               
0213               ;--------------------------------------------------------------
0214               ; Dialog "Unsaved changes"
0215               ;--------------------------------------------------------------
0216 3738 1401     txt.head.unsaved   byte 20,1,3
     373A 0320 
0217 373B ....                        text ' Unsaved changes '
0218 374C 0221                        byte 2
0219               txt.info.unsaved
0220                       byte  33
0221 374E ....             text  'Warning! Unsaved changes in file.'
0222                       even
0223               
0224               txt.hint.unsaved
0225 3770 2A50             byte  42
0226 3771 ....             text  'Press F6 to proceed or ENTER to save file.'
0227                       even
0228               
0229               txt.keys.unsaved
0230 379C 2843             byte  40
0231 379D ....             text  'Confirm: F9=Back  F6=Proceed  ENTER=Save'
0232                       even
0233               
0234               
0235               ;--------------------------------------------------------------
0236               ; Dialog "About"
0237               ;--------------------------------------------------------------
0238 37C6 0A01     txt.head.about     byte 10,1,3
     37C8 0320 
0239 37C9 ....                        text ' About '
0240 37D0 0200                        byte 2
0241               
0242               txt.info.about
0243                       byte  0
0244 37D2 ....             text
0245                       even
0246               
0247               txt.hint.about
0248 37D2 1D50             byte  29
0249 37D3 ....             text  'Press F9 to return to editor.'
0250                       even
0251               
0252 37F0 2148     txt.keys.about     byte 33
0253 37F1 ....                        text 'Help: F9=Back  '
0254 3800 0E0F                        byte 14,15
0255 3802 ....                        text '=Alpha Lock down'
0256               
0257               
0258               ;--------------------------------------------------------------
0259               ; Dialog "Menu"
0260               ;--------------------------------------------------------------
0261 3812 1001     txt.head.menu      byte 16,1,3
     3814 0320 
0262 3815 ....                        text ' Stevie 1.1R '
0263 3822 0217                        byte 2
0264               
0265               txt.info.menu
0266                       byte  23
0267 3824 ....             text  'File  Basic  Help  Quit'
0268                       even
0269               
0270 383C 0006     pos.info.menu      byte 0,6,13,19,>ff
     383E 0D13 
     3840 FF28 
0271               txt.hint.menu
0272                       byte  40
0273 3842 ....             text  'Press F,B,H,Q or F9 to return to editor.'
0274                       even
0275               
0276               txt.keys.menu
0277 386A 0D4D             byte  13
0278 386B ....             text  'Menu: F9=Back'
0279                       even
0280               
0281               
0282               
0283               ;--------------------------------------------------------------
0284               ; Dialog "File"
0285               ;--------------------------------------------------------------
0286 3878 0901     txt.head.file      byte 9,1,3
     387A 0320 
0287 387B ....                        text ' File '
0288                                  byte 2
0289               
0290               txt.info.file
0291 3882 0F4E             byte  15
0292 3883 ....             text  'New  Open  Save'
0293                       even
0294               
0295 3892 0005     pos.info.file      byte 0,5,11,>ff
     3894 0BFF 
0296               txt.hint.file
0297 3896 2650             byte  38
0298 3897 ....             text  'Press N,O,S or F9 to return to editor.'
0299                       even
0300               
0301               txt.keys.file
0302 38BE 0D46             byte  13
0303 38BF ....             text  'File: F9=Back'
0304                       even
0305               
0306               
0307               ;--------------------------------------------------------------
0308               ; Dialog "Basic"
0309               ;--------------------------------------------------------------
0310 38CC 0E01     txt.head.basic     byte 14,1,3
     38CE 0320 
0311 38CF ....                        text ' Run basic '
0312 38DA 021C                        byte 2
0313               
0314               txt.info.basic
0315                       byte  28
0316 38DC ....             text  'TI Basic / TI Extended Basic'
0317                       even
0318               
0319 38F8 030E     pos.info.basic     byte 3,14,>ff
     38FA FF3E 
0320               txt.hint.basic
0321                       byte  62
0322 38FC ....             text  'Press B,E for running basic dialect or F9 to return to editor.'
0323                       even
0324               
0325               txt.keys.basic
0326 393A 1252             byte  18
0327 393B ....             text  'Run Basic: F9=Back'
0328                       even
0329               
0330               
0331               
0332               ;--------------------------------------------------------------
0333               ; Strings for error line pane
0334               ;--------------------------------------------------------------
0335               txt.ioerr.load
0336 394E 2049             byte  32
0337 394F ....             text  'I/O error. Failed loading file: '
0338                       even
0339               
0340               txt.ioerr.save
0341 3970 2049             byte  32
0342 3971 ....             text  'I/O error. Failed saving file:  '
0343                       even
0344               
0345               txt.memfull.load
0346 3992 4049             byte  64
0347 3993 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0348                       even
0349               
0350               txt.io.nofile
0351 39D4 2149             byte  33
0352 39D5 ....             text  'I/O error. No filename specified.'
0353                       even
0354               
0355               txt.block.inside
0356 39F6 3445             byte  52
0357 39F7 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0358                       even
0359               
0360               
0361               ;--------------------------------------------------------------
0362               ; Strings for command buffer
0363               ;--------------------------------------------------------------
0364               txt.cmdb.prompt
0365 3A2C 013E             byte  1
0366 3A2D ....             text  '>'
0367                       even
0368               
0369               txt.colorscheme
0370 3A2E 0D43             byte  13
0371 3A2F ....             text  'Color scheme:'
0372                       even
0373               
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
0022 3A3C DEAD             data  >dead,>beef,>dead,>beef
     3A3E BEEF 
     3A40 DEAD 
     3A42 BEEF 
**** **** ****     > stevie_b7.asm.1355431
0066               ***************************************************************
0067               * Step 4: Satisfy assembler, must know SP2 EXT in high MeMEXP
0068               ********|*****|*********************|**************************
0069                       aorg  >f000
0070                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/modules/cpu_scrpad_backrest.asm"
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
**** **** ****     > stevie_b7.asm.1355431
0071                                                   ; Spectra 2 extended
0072               ***************************************************************
0073               * Step 5: Include main editor modules
0074               ********|*****|*********************|**************************
0075               main:
0076                       aorg  kickstart.code2       ; >6046
0077 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 606A 
0078                       ;-----------------------------------------------------------------------
0079                       ; Stubs using trampoline
0080                       ;-----------------------------------------------------------------------
0081                       copy  "rom.stubs.bank7.asm" ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank7.asm
0001               * FILE......: rom.stubs.bank7.asm
0002               * Purpose...: Bank 7 stubs for functions in other banks
**** **** ****     > stevie_b7.asm.1355431
0082                       ;-----------------------------------------------------------------------
0083                       ; Bank full check
0084                       ;-----------------------------------------------------------------------
0088                       ;-----------------------------------------------------------------------
0089                       ; Vector table
0090                       ;-----------------------------------------------------------------------
0091                       aorg  >7fc0
0092                       copy  "rom.vectors.bank7.asm"
**** **** ****     > rom.vectors.bank7.asm
0001               * FILE......: rom.vectors.bank7.asm
0002               * Purpose...: Bank 7 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * Vector table for trampoline functions
0006               *--------------------------------------------------------------
0007 7FC0 606A     vec.1   data  cpu.crash             ;
0008 7FC2 606A     vec.2   data  cpu.crash             ;
0009 7FC4 606A     vec.3   data  cpu.crash             ;
0010 7FC6 606A     vec.4   data  cpu.crash             ;
0011 7FC8 606A     vec.5   data  cpu.crash             ;
0012 7FCA 606A     vec.6   data  cpu.crash             ;
0013 7FCC 606A     vec.7   data  cpu.crash             ;
0014 7FCE 606A     vec.8   data  cpu.crash             ;
0015 7FD0 606A     vec.9   data  cpu.crash             ;
0016 7FD2 606A     vec.10  data  cpu.crash             ;
0017 7FD4 606A     vec.11  data  cpu.crash             ;
0018 7FD6 606A     vec.12  data  cpu.crash             ;
0019 7FD8 606A     vec.13  data  cpu.crash             ;
0020 7FDA 606A     vec.14  data  cpu.crash             ;
0021 7FDC 606A     vec.15  data  cpu.crash             ;
0022 7FDE 606A     vec.16  data  cpu.crash             ;
0023 7FE0 606A     vec.17  data  cpu.crash             ;
0024 7FE2 606A     vec.18  data  cpu.crash             ;
0025 7FE4 606A     vec.19  data  cpu.crash             ;
0026 7FE6 606A     vec.20  data  cpu.crash             ;
0027 7FE8 606A     vec.21  data  cpu.crash             ;
0028 7FEA 606A     vec.22  data  cpu.crash             ;
0029 7FEC 606A     vec.23  data  cpu.crash             ;
0030 7FEE 606A     vec.24  data  cpu.crash             ;
0031 7FF0 606A     vec.25  data  cpu.crash             ;
0032 7FF2 606A     vec.26  data  cpu.crash             ;
0033 7FF4 606A     vec.27  data  cpu.crash             ;
0034 7FF6 606A     vec.28  data  cpu.crash             ;
0035 7FF8 606A     vec.29  data  cpu.crash             ;
0036 7FFA 606A     vec.30  data  cpu.crash             ;
0037 7FFC 606A     vec.31  data  cpu.crash             ;
0038 7FFE 606A     vec.32  data  cpu.crash             ;
**** **** ****     > stevie_b7.asm.1355431
0093                                                   ; Vector table bank 7
0094               
0095               *--------------------------------------------------------------
0096               * Video mode configuration
0097               *--------------------------------------------------------------
0098      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0099      0004     spfbck  equ   >04                   ; Screen background color.
0100      33B0     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0101      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0102      0050     colrow  equ   80                    ; Columns per row
0103      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0104      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0105      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0106      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

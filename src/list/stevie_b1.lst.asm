XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.1930724
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210408-1930724
0010               *
0011               * Bank 1 "James"
0012               *
0013               ***************************************************************
0014                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
**** **** ****     > rom.order.asm
0001               * FILE......: rom.order.asm
0002               * Purpose...: Equates with CPU write addresses for switching banks
0003               
0004               *--------------------------------------------------------------
0005               * Bank order (non-inverted)
0006               *--------------------------------------------------------------
0007      6000     bank0                     equ  >6000   ; Jill
0008      6002     bank1                     equ  >6002   ; James
0009      6004     bank2                     equ  >6004   ; Jacky
0010      6006     bank3                     equ  >6006   ; John
0011      6008     bank4                     equ  >6008   ; Janine
**** **** ****     > stevie_b1.asm.1930724
0015                       copy  "equates.asm"         ; Equates Stevie configuration
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
0013               *     2000-2eff    3840           SP2 library
0014               *     2f00-2f1f      32           **RESERVED**
0015               *     2f20-2f3f      32           Function input/output parameters
0016               *     2f40-2f43       4           Keyboard
0017               *     2f4a-2f59      16           Timer tasks table
0018               *     2f5a-2f69      16           Sprite attribute table in RAM
0019               *     2f6a-2f9f      54           RAM buffer
0020               *     2fa0-2fff      96           Value/Return stack (grows downwards from 2fff)
0021               *
0022               *
0023               * LOW MEMORY EXPANSION (3000-3fff)
0024               *
0025               *     Mem range   Bytes    SAMS   Purpose
0026               *     =========   =====    ====   ==================================
0027               *     3000-3fff    4096           Resident Stevie Modules
0028               *
0029               *
0030               * HIGH MEMORY EXPANSION (a000-ffff)
0031               *
0032               *     Mem range   Bytes    SAMS   Purpose
0033               *     =========   =====    ====   ==================================
0034               *     a000-a0ff     256           Stevie Editor shared structure
0035               *     a100-a1ff     256           Framebuffer structure
0036               *     a200-a2ff     256           Editor buffer structure
0037               *     a300-a3ff     256           Command buffer structure
0038               *     a400-a4ff     256           File handle structure
0039               *     a500-a5ff     256           Index structure
0040               *     a600-af5f    2400           Frame buffer
0041               *     af60-afff     ???           *FREE*
0042               *
0043               *     b000-bfff    4096           Index buffer page
0044               *     c000-cfff    4096           Editor buffer page
0045               *     d000-dfff    4096           CMDB history / Editor buffer page (temporary)
0046               *     e000-ebff    3072           Heap
0047               *     ec00-efff    1024           Farjump return stack (trampolines)
0048               *     f000-ffff    4096           *FREE*
0049               *
0050               *
0051               * CARTRIDGE SPACE (6000-7fff)
0052               *
0053               *     Mem range   Bytes    BANK   Purpose
0054               *     =========   =====    ====   ==================================
0055               *     6000-7f9b    8128       0   SP2 library, code to RAM, resident modules
0056               *     7f9c-7fff      64       0   Vector table (32 vectors)
0057               *     ..............................................................
0058               *     6000-7f9b    8128       1   Stevie program code
0059               *     7f9c-7fff      64       1   Vector table (32 vectors)
0060               *     ..............................................................
0061               *     6000-7f9b    8128       2   Stevie program code
0062               *     7f9c-7fff      64       2   Vector table (32 vectors)
0063               *     ..............................................................
0064               *     6000-7f9b    8128       3   Stevie program code
0065               *     7f9c-7fff      64       3   Vector table (32 vectors)
0066               *
0067               *
0068               * VDP RAM F18a (0000-47ff)
0069               *
0070               *     Mem range   Bytes    Hex    Purpose
0071               *     =========   =====   =====   =================================
0072               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0073               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0074               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0075               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0076               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0077               *                                      (Position based colors F18a, 80 colums)
0078               *     2180                        SAT: Sprite Attribute Table
0079               *                                      (Cursor in F18a, 80 cols mode)
0080               *     2800                        SPT: Sprite Pattern Table
0081               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0082               *===============================================================================
0083               
0084               *--------------------------------------------------------------
0085               * Skip unused spectra2 code modules for reduced code size
0086               *--------------------------------------------------------------
0087      0001     skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
0088      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0089      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0090      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0091      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0092      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0093      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0094      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0095      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0096      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0097      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0098      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0099      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0100      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0101      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0102      0001     skip_random_generator     equ  1       ; Skip random functions
0103      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0104      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0105               *--------------------------------------------------------------
0106               * Stevie specific equates
0107               *--------------------------------------------------------------
0108      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0109      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0110      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0111      0960     vdp.sit.size.80x30        equ  80*30   ; VDP SIT size when 80 columns, 30 rows
0112      0780     vdp.sit.size.80x24        equ  80*24   ; VDP SIT size when 80 columns, 24 rows
0113      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0114      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0115      1FD0     vdp.cmdb.toprow.tat       equ  >1fd0   ; VDP TAT address of 1st CMDB row
0116      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0117      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0118               *--------------------------------------------------------------
0119               * Stevie Dialog / Pane specific equates
0120               *--------------------------------------------------------------
0121      001D     pane.botrow               equ  29      ; Bottom row on screen
0122      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0123      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0124               ;-----------------------------------------------------------------
0125               ;   Dialog ID's >= 100 indicate that command prompt should be
0126               ;   hidden and no characters added to CMDB keyboard buffer
0127               ;-----------------------------------------------------------------
0128      000A     id.dialog.load            equ  10      ; ID dialog "Load DV80 file"
0129      000B     id.dialog.save            equ  11      ; ID dialog "Save DV80 file"
0130      000C     id.dialog.saveblock       equ  12      ; ID dialog "Save codeblock to DV80 file"
0131      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0132      0066     id.dialog.block           equ  102     ; ID dialog "Block move/copy/delete"
0133      0067     id.dialog.about           equ  103     ; ID dialog "About"
0134               *--------------------------------------------------------------
0135               * SPECTRA2 / Stevie startup options
0136               *--------------------------------------------------------------
0137      0001     debug                     equ  1       ; Turn on spectra2 debugging
0138      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0139      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0140      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0141               *--------------------------------------------------------------
0142               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0143               *--------------------------------------------------------------
0144      2F20     parm1             equ  >2f20           ; Function parameter 1
0145      2F22     parm2             equ  >2f22           ; Function parameter 2
0146      2F24     parm3             equ  >2f24           ; Function parameter 3
0147      2F26     parm4             equ  >2f26           ; Function parameter 4
0148      2F28     parm5             equ  >2f28           ; Function parameter 5
0149      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0150      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0151      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0152      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0153      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0154      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0155      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0156      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0157      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0158      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0159      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0160      2F40     keycode1          equ  >2f40           ; Current key scanned
0161      2F42     keycode2          equ  >2f42           ; Previous key scanned
0162      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0163      2F4A     timers            equ  >2f4a           ; Timer table
0164      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0165      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0166               *--------------------------------------------------------------
0167               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0168               *--------------------------------------------------------------
0169      A000     tv.top            equ  >a000           ; Structure begin
0170      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0171      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0172      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0173      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0174      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0175      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0176      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0177      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0178      A010     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0179      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0180      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0181      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0182      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0183      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0184      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0185      A01E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0186      A020     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0187      A022     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0188      A024     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0189      A026     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0190      A028     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0191      A02A     tv.error.msg      equ  tv.top + 42     ; Error message (max. 160 characters)
0192      A0CA     tv.free           equ  tv.top + 202    ; End of structure
0193               *--------------------------------------------------------------
0194               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0195               *--------------------------------------------------------------
0196      A100     fb.struct         equ  >a100           ; Structure begin
0197      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0198      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0199      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0200                                                      ; line X in editor buffer).
0201      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0202                                                      ; (offset 0 .. @fb.scrrows)
0203      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0204      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0205      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0206      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0207      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0208      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0209      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0210      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0211      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0212      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0213      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0214      A11E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0215      A16E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0216      A1BE     fb.free           equ  fb.struct + 190 ; End of structure
0217               *--------------------------------------------------------------
0218               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0219               *--------------------------------------------------------------
0220      A200     edb.struct        equ  >a200           ; Begin structure
0221      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0222      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0223      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0224      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0225      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0226      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0227      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0228      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0229      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0230      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0231                                                      ; with current filename.
0232      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0233                                                      ; with current file type.
0234      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0235      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0236      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0237                                                      ; for filename, but not always used.
0238      A269     edb.free          equ  edb.struct + 105; End of structure
0239               *--------------------------------------------------------------
0240               * Command buffer structure            @>a300-a3ff   (256 bytes)
0241               *--------------------------------------------------------------
0242      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0243      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0244      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0245      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0246      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0247      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0248      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0249      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0250      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0251      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0252      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0253      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0254      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0255      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0256      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0257      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0258      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0259      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0260      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0261      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0262      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0263      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0264      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0265               *--------------------------------------------------------------
0266               * File handle structure               @>a400-a4ff   (256 bytes)
0267               *--------------------------------------------------------------
0268      A400     fh.struct         equ  >a400           ; stevie file handling structures
0269               ;***********************************************************************
0270               ; ATTENTION
0271               ; The dsrlnk variables must form a continuous memory block and keep
0272               ; their order!
0273               ;***********************************************************************
0274      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0275      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0276      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0277      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0278      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0279      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0280      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0281      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0282      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0283      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0284      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0285      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0286      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0287      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0288      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0289      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0290      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0291      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0292      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0293      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0294      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0295      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0296      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0297      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0298      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0299      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0300      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0301      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0302      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0303      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0304      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0305      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0306               *--------------------------------------------------------------
0307               * Index structure                     @>a500-a5ff   (256 bytes)
0308               *--------------------------------------------------------------
0309      A500     idx.struct        equ  >a500           ; stevie index structure
0310      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0311      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0312      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0313               *--------------------------------------------------------------
0314               * Frame buffer                        @>a600-afff  (2560 bytes)
0315               *--------------------------------------------------------------
0316      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0317      0960     fb.size           equ  80*30           ; Frame buffer size
0318               *--------------------------------------------------------------
0319               * Index                               @>b000-bfff  (4096 bytes)
0320               *--------------------------------------------------------------
0321      B000     idx.top           equ  >b000           ; Top of index
0322      1000     idx.size          equ  4096            ; Index size
0323               *--------------------------------------------------------------
0324               * Editor buffer                       @>c000-cfff  (4096 bytes)
0325               *--------------------------------------------------------------
0326      C000     edb.top           equ  >c000           ; Editor buffer high memory
0327      1000     edb.size          equ  4096            ; Editor buffer size
0328               *--------------------------------------------------------------
0329               * Command history buffer              @>d000-dfff  (4096 bytes)
0330               *--------------------------------------------------------------
0331      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0332      1000     cmdb.size         equ  4096            ; Command buffer size
0333               *--------------------------------------------------------------
0334               * Heap                                @>e000-ebff  (3072 bytes)
0335               *--------------------------------------------------------------
0336      E000     heap.top          equ  >e000           ; Top of heap
0337               *--------------------------------------------------------------
0338               * Farjump return stack                @>ec00-efff  (1024 bytes)
0339               *--------------------------------------------------------------
0340      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b1.asm.1930724
0016               
0017               ***************************************************************
0018               * Spectra2 core configuration
0019               ********|*****|*********************|**************************
0020      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0021                                                   ; grows downwards to >2000
0022               ***************************************************************
0023               * BANK 1
0024               ********|*****|*********************|**************************
0025      6002     bankid  equ   bank1                 ; Set bank identifier to current bank
0026                       aorg  >6000
0027                       save  >6000,>7fff           ; Save bank
0028                       copy  "rom.header.asm"      ; Include cartridge header
**** **** ****     > rom.header.asm
0001               * FILE......: rom.header.asm
0002               * Purpose...: Cartridge header
0003               
0004               *--------------------------------------------------------------
0005               * Cartridge header
0006               ********|*****|*********************|**************************
0007 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0008 6006 6010             data  $+10
0009 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0010 6010 0000             data  0                     ; No more items following
0011 6012 6030             data  kickstart.code1
0012               
0014               
0015 6014 0B53             byte  11
0016 6015 ....             text  'STEVIE 1.1E'
0017                       even
0018               
**** **** ****     > stevie_b1.asm.1930724
0029               
0030               ***************************************************************
0031               * Step 1: Switch to bank 0 (uniform code accross all banks)
0032               ********|*****|*********************|**************************
0033                       aorg  kickstart.code1       ; >6030
0034 6030 04E0  34         clr   @bank0                ; Switch to bank 0 "Jill"
     6032 6000 
0035               ***************************************************************
0036               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0037               ********|*****|*********************|**************************
0038                       aorg  >2000
0039                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     2084 2E0E 
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
     20A8 2992 
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
     20BC 2992 
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
     20E8 2696 
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
     210C 299C 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26AC 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2422 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26AC 
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
     2138 299C 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 290E 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26AC 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2422 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26AC 
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
     216A 269C 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D0C 
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
0260 21D3 ....             text  'Build-ID  210408-1930724'
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
0477               ********|*****|*********************|**************************
0478 2422 C17B  30 putstr  mov   *r11+,tmp1
0479 2424 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 2426 C1CB  18 xutstr  mov   r11,tmp3
0481 2428 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     242A 23FE 
0482 242C C2C7  18         mov   tmp3,r11
0483 242E 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 2430 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 2432 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 2434 0286  22         ci    tmp2,255              ; Length > 255 ?
     2436 00FF 
0491 2438 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 243A 0460  28         b     @xpym2v               ; Display string
     243C 2454 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 243E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2440 FFCE 
0498 2442 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2444 2026 
0499               
0500               
0501               
0502               ***************************************************************
0503               * Put length-byte prefixed string at YX
0504               ***************************************************************
0505               *  BL   @PUTAT
0506               *  DATA P0,P1
0507               *
0508               *  P0 = YX position
0509               *  P1 = Pointer to string
0510               *--------------------------------------------------------------
0511               *  REMARKS
0512               *  First byte of string must contain length
0513               ********|*****|*********************|**************************
0514 2446 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2448 832A 
0515 244A 0460  28         b     @putstr
     244C 2422 
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
0020 244E C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2450 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2452 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 2454 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2456 1604  14         jne   !                     ; No, continue
0028               
0029 2458 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     245A FFCE 
0030 245C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     245E 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 2460 0264  22 !       ori   tmp0,>4000
     2462 4000 
0035 2464 06C4  14         swpb  tmp0
0036 2466 D804  38         movb  tmp0,@vdpa
     2468 8C02 
0037 246A 06C4  14         swpb  tmp0
0038 246C D804  38         movb  tmp0,@vdpa
     246E 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 2470 020F  20         li    r15,vdpw              ; Set VDP write address
     2472 8C00 
0043 2474 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2476 247E 
     2478 8320 
0044 247A 0460  28         b     @mcloop               ; Write data to VDP and return
     247C 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 247E D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 2480 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2482 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2484 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2486 06C4  14 xpyv2m  swpb  tmp0
0027 2488 D804  38         movb  tmp0,@vdpa
     248A 8C02 
0028 248C 06C4  14         swpb  tmp0
0029 248E D804  38         movb  tmp0,@vdpa
     2490 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2492 020F  20         li    r15,vdpr              ; Set VDP read address
     2494 8800 
0034 2496 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2498 24A0 
     249A 8320 
0035 249C 0460  28         b     @mcloop               ; Read data from VDP
     249E 8320 
0036 24A0 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24A2 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24A4 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24A6 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24A8 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24AA 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24AC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24AE FFCE 
0034 24B0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24B2 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24B4 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24B6 0001 
0039 24B8 1603  14         jne   cpym0                 ; No, continue checking
0040 24BA DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24BC 04C6  14         clr   tmp2                  ; Reset counter
0042 24BE 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24C0 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24C2 7FFF 
0047 24C4 C1C4  18         mov   tmp0,tmp3
0048 24C6 0247  22         andi  tmp3,1
     24C8 0001 
0049 24CA 1618  14         jne   cpyodd                ; Odd source address handling
0050 24CC C1C5  18 cpym1   mov   tmp1,tmp3
0051 24CE 0247  22         andi  tmp3,1
     24D0 0001 
0052 24D2 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24D4 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24D6 2020 
0057 24D8 1605  14         jne   cpym3
0058 24DA C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24DC 2502 
     24DE 8320 
0059 24E0 0460  28         b     @mcloop               ; Copy memory and exit
     24E2 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24E4 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24E6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24E8 0001 
0065 24EA 1301  14         jeq   cpym4
0066 24EC 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24EE CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24F0 0646  14         dect  tmp2
0069 24F2 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24F4 C1C7  18         mov   tmp3,tmp3
0074 24F6 1301  14         jeq   cpymz
0075 24F8 D554  38         movb  *tmp0,*tmp1
0076 24FA 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24FC 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24FE 8000 
0081 2500 10E9  14         jmp   cpym2
0082 2502 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 2504 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2506 0649  14         dect  stack
0065 2508 C64B  30         mov   r11,*stack            ; Push return address
0066 250A 0649  14         dect  stack
0067 250C C640  30         mov   r0,*stack             ; Push r0
0068 250E 0649  14         dect  stack
0069 2510 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 2512 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2514 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2516 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2518 4000 
0077 251A C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     251C 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 251E 020C  20         li    r12,>1e00             ; SAMS CRU address
     2520 1E00 
0082 2522 04C0  14         clr   r0
0083 2524 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2526 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2528 D100  18         movb  r0,tmp0
0086 252A 0984  56         srl   tmp0,8                ; Right align
0087 252C C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     252E 833C 
0088 2530 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 2532 C339  30         mov   *stack+,r12           ; Pop r12
0094 2534 C039  30         mov   *stack+,r0            ; Pop r0
0095 2536 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2538 045B  20         b     *r11                  ; Return to caller
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
0131 253A C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 253C C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 253E 0649  14         dect  stack
0135 2540 C64B  30         mov   r11,*stack            ; Push return address
0136 2542 0649  14         dect  stack
0137 2544 C640  30         mov   r0,*stack             ; Push r0
0138 2546 0649  14         dect  stack
0139 2548 C64C  30         mov   r12,*stack            ; Push r12
0140 254A 0649  14         dect  stack
0141 254C C644  30         mov   tmp0,*stack           ; Push tmp0
0142 254E 0649  14         dect  stack
0143 2550 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2552 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2554 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 2556 0284  22         ci    tmp0,255              ; Crash if page > 255
     2558 00FF 
0153 255A 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 255C 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     255E 001E 
0158 2560 150A  14         jgt   !
0159 2562 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     2564 0004 
0160 2566 1107  14         jlt   !
0161 2568 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     256A 0012 
0162 256C 1508  14         jgt   sams.page.set.switch_page
0163 256E 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2570 0006 
0164 2572 1501  14         jgt   !
0165 2574 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2576 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2578 FFCE 
0170 257A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     257C 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 257E 020C  20         li    r12,>1e00             ; SAMS CRU address
     2580 1E00 
0176 2582 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 2584 06C0  14         swpb  r0                    ; LSB to MSB
0178 2586 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2588 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     258A 4000 
0180 258C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 258E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 2590 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 2592 C339  30         mov   *stack+,r12           ; Pop r12
0188 2594 C039  30         mov   *stack+,r0            ; Pop r0
0189 2596 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 2598 045B  20         b     *r11                  ; Return to caller
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
0204 259A 020C  20         li    r12,>1e00             ; SAMS CRU address
     259C 1E00 
0205 259E 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25A0 045B  20         b     *r11                  ; Return to caller
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
0227 25A2 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A4 1E00 
0228 25A6 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25A8 045B  20         b     *r11                  ; Return to caller
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
0260 25AA C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25AC 0649  14         dect  stack
0263 25AE C64B  30         mov   r11,*stack            ; Save return address
0264 25B0 0649  14         dect  stack
0265 25B2 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25B4 0649  14         dect  stack
0267 25B6 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25B8 0649  14         dect  stack
0269 25BA C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25BC 0649  14         dect  stack
0271 25BE C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25C0 0206  20         li    tmp2,8                ; Set loop counter
     25C2 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25C4 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25C6 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25C8 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25CA 253E 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25CC 0606  14         dec   tmp2                  ; Next iteration
0288 25CE 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25D0 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25D2 259A 
0294                                                   ; / activating changes.
0295               
0296 25D4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25D6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25D8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25DC C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25DE 045B  20         b     *r11                  ; Return to caller
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
0318 25E0 0649  14         dect  stack
0319 25E2 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25E4 06A0  32         bl    @sams.layout
     25E6 25AA 
0324 25E8 25EE                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25EA C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25EC 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25EE 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25F0 0002 
0336 25F2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25F4 0003 
0337 25F6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25F8 000A 
0338 25FA B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25FC 000B 
0339 25FE C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     2600 000C 
0340 2602 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2604 000D 
0341 2606 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2608 000E 
0342 260A F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     260C 000F 
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
0363 260E C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 2610 0649  14         dect  stack
0366 2612 C64B  30         mov   r11,*stack            ; Push return address
0367 2614 0649  14         dect  stack
0368 2616 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2618 0649  14         dect  stack
0370 261A C645  30         mov   tmp1,*stack           ; Push tmp1
0371 261C 0649  14         dect  stack
0372 261E C646  30         mov   tmp2,*stack           ; Push tmp2
0373 2620 0649  14         dect  stack
0374 2622 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2624 0205  20         li    tmp1,sams.layout.copy.data
     2626 2646 
0379 2628 0206  20         li    tmp2,8                ; Set loop counter
     262A 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 262C C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 262E 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2630 2506 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 2632 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2634 833C 
0390               
0391 2636 0606  14         dec   tmp2                  ; Next iteration
0392 2638 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 263A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 263C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 263E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 2640 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 2642 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2644 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2646 2000             data  >2000                 ; >2000-2fff
0408 2648 3000             data  >3000                 ; >3000-3fff
0409 264A A000             data  >a000                 ; >a000-afff
0410 264C B000             data  >b000                 ; >b000-bfff
0411 264E C000             data  >c000                 ; >c000-cfff
0412 2650 D000             data  >d000                 ; >d000-dfff
0413 2652 E000             data  >e000                 ; >e000-efff
0414 2654 F000             data  >f000                 ; >f000-ffff
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
0009 2656 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2658 FFBF 
0010 265A 0460  28         b     @putv01
     265C 234A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 265E 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2660 0040 
0018 2662 0460  28         b     @putv01
     2664 234A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2666 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2668 FFDF 
0026 266A 0460  28         b     @putv01
     266C 234A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 266E 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2670 0020 
0034 2672 0460  28         b     @putv01
     2674 234A 
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
0010 2676 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2678 FFFE 
0011 267A 0460  28         b     @putv01
     267C 234A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 267E 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2680 0001 
0019 2682 0460  28         b     @putv01
     2684 234A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2686 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2688 FFFD 
0027 268A 0460  28         b     @putv01
     268C 234A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 268E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2690 0002 
0035 2692 0460  28         b     @putv01
     2694 234A 
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
0018 2696 C83B  50 at      mov   *r11+,@wyx
     2698 832A 
0019 269A 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 269C B820  54 down    ab    @hb$01,@wyx
     269E 2012 
     26A0 832A 
0028 26A2 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26A4 7820  54 up      sb    @hb$01,@wyx
     26A6 2012 
     26A8 832A 
0037 26AA 045B  20         b     *r11
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
0049 26AC C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26AE D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26B0 832A 
0051 26B2 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26B4 832A 
0052 26B6 045B  20         b     *r11
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
0021 26B8 C120  34 yx2px   mov   @wyx,tmp0
     26BA 832A 
0022 26BC C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26BE 06C4  14         swpb  tmp0                  ; Y<->X
0024 26C0 04C5  14         clr   tmp1                  ; Clear before copy
0025 26C2 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26C4 20A0  38         coc   @wbit1,config         ; f18a present ?
     26C6 201E 
0030 26C8 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26CA 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26CC 833A 
     26CE 26F8 
0032 26D0 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26D2 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26D4 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26D6 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26D8 0500 
0037 26DA 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26DC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26DE 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26E0 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26E2 D105  18         movb  tmp1,tmp0
0051 26E4 06C4  14         swpb  tmp0                  ; X<->Y
0052 26E6 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26E8 2020 
0053 26EA 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26EC 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26EE 2012 
0059 26F0 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26F2 2024 
0060 26F4 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26F6 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26F8 0050            data   80
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
0013 26FA C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26FC 06A0  32         bl    @putvr                ; Write once
     26FE 2336 
0015 2700 391C             data  >391c                 ; VR1/57, value 00011100
0016 2702 06A0  32         bl    @putvr                ; Write twice
     2704 2336 
0017 2706 391C             data  >391c                 ; VR1/57, value 00011100
0018 2708 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 270A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 270C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     270E 2336 
0028 2710 391C             data  >391c
0029 2712 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********|*****|*********************|**************************
0040 2714 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2716 06A0  32         bl    @cpym2v
     2718 244E 
0042 271A 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     271C 2758 
     271E 0006 
0043 2720 06A0  32         bl    @putvr
     2722 2336 
0044 2724 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2726 06A0  32         bl    @putvr
     2728 2336 
0046 272A 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 272C 0204  20         li    tmp0,>3f00
     272E 3F00 
0052 2730 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     2732 22BE 
0053 2734 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2736 8800 
0054 2738 0984  56         srl   tmp0,8
0055 273A D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     273C 8800 
0056 273E C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 2740 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 2742 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2744 BFFF 
0060 2746 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2748 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     274A 4000 
0063               f18chk_exit:
0064 274C 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     274E 2292 
0065 2750 3F00             data  >3f00,>00,6
     2752 0000 
     2754 0006 
0066 2756 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2758 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 275A 3F00             data  >3f00                 ; 3f02 / 3f00
0073 275C 0340             data  >0340                 ; 3f04   0340  idle
0074               
0075               
0076               ***************************************************************
0077               * f18rst - Reset f18a into standard settings
0078               ***************************************************************
0079               *  bl   @f18rst
0080               *--------------------------------------------------------------
0081               *  REMARKS
0082               *  This is used to leave the F18A mode and revert all settings
0083               *  that could lead to corruption when doing BLWP @0
0084               *
0085               *  There are some F18a settings that stay on when doing blwp @0
0086               *  and the TI title screen cannot recover from that.
0087               *
0088               *  It is your responsibility to set video mode tables should
0089               *  you want to continue instead of doing blwp @0 after your
0090               *  program cleanup
0091               ********|*****|*********************|**************************
0092 275E C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2760 06A0  32         bl    @putvr
     2762 2336 
0097 2764 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2766 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2768 2336 
0100 276A 391C             data  >391c                 ; Lock the F18a
0101 276C 0458  20         b     *tmp4                 ; Exit
0102               
0103               
0104               
0105               ***************************************************************
0106               * f18fwv - Get F18A Firmware Version
0107               ***************************************************************
0108               *  bl   @f18fwv
0109               *--------------------------------------------------------------
0110               *  REMARKS
0111               *  Successfully tested with F18A v1.8, note that this does not
0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
0113               *  firmware to begin with.
0114               *--------------------------------------------------------------
0115               *  TMP0 High nibble = major version
0116               *  TMP0 Low nibble  = minor version
0117               *
0118               *  Example: >0018     F18a Firmware v1.8
0119               ********|*****|*********************|**************************
0120 276E C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2770 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     2772 201E 
0122 2774 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2776 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2778 8802 
0127 277A 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     277C 2336 
0128 277E 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2780 04C4  14         clr   tmp0
0130 2782 D120  34         movb  @vdps,tmp0
     2784 8802 
0131 2786 0984  56         srl   tmp0,8
0132 2788 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 278A C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     278C 832A 
0018 278E D17B  28         movb  *r11+,tmp1
0019 2790 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 2792 D1BB  28         movb  *r11+,tmp2
0021 2794 0986  56         srl   tmp2,8                ; Repeat count
0022 2796 C1CB  18         mov   r11,tmp3
0023 2798 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     279A 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 279C 020B  20         li    r11,hchar1
     279E 27A4 
0028 27A0 0460  28         b     @xfilv                ; Draw
     27A2 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27A4 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27A6 2022 
0033 27A8 1302  14         jeq   hchar2                ; Yes, exit
0034 27AA C2C7  18         mov   tmp3,r11
0035 27AC 10EE  14         jmp   hchar                 ; Next one
0036 27AE 05C7  14 hchar2  inct  tmp3
0037 27B0 0457  20         b     *tmp3                 ; Exit
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
0016 27B2 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27B4 2020 
0017 27B6 020C  20         li    r12,>0024
     27B8 0024 
0018 27BA 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27BC 284E 
0019 27BE 04C6  14         clr   tmp2
0020 27C0 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27C2 04CC  14         clr   r12
0025 27C4 1F08  20         tb    >0008                 ; Shift-key ?
0026 27C6 1302  14         jeq   realk1                ; No
0027 27C8 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27CA 287E 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27CC 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27CE 1302  14         jeq   realk2                ; No
0033 27D0 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27D2 28AE 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27D4 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27D6 1302  14         jeq   realk3                ; No
0039 27D8 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27DA 28DE 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27DC 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27DE 200C 
0044 27E0 1E15  20         sbz   >0015                 ; Set P5
0045 27E2 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27E4 1302  14         jeq   realk4                ; No
0047 27E6 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27E8 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27EA 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27EC 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27EE 0006 
0053 27F0 0606  14 realk5  dec   tmp2
0054 27F2 020C  20         li    r12,>24               ; CRU address for P2-P4
     27F4 0024 
0055 27F6 06C6  14         swpb  tmp2
0056 27F8 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 27FA 06C6  14         swpb  tmp2
0058 27FC 020C  20         li    r12,6                 ; CRU read address
     27FE 0006 
0059 2800 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2802 0547  14         inv   tmp3                  ;
0061 2804 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2806 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2808 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 280A 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 280C 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 280E 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2810 0285  22         ci    tmp1,8
     2812 0008 
0070 2814 1AFA  14         jl    realk6
0071 2816 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2818 1BEB  14         jh    realk5                ; No, next column
0073 281A 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 281C C206  18 realk8  mov   tmp2,tmp4
0078 281E 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2820 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2822 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2824 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2826 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2828 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 282A 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     282C 200C 
0089 282E 1608  14         jne   realka                ; No, continue saving key
0090 2830 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2832 2878 
0091 2834 1A05  14         jl    realka
0092 2836 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2838 2876 
0093 283A 1B02  14         jh    realka                ; No, continue
0094 283C 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     283E E000 
0095 2840 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2842 833C 
0096 2844 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2846 200A 
0097 2848 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     284A 8C00 
0098                                                   ; / using R15 as temp storage
0099 284C 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 284E FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2850 0000 
     2852 FF0D 
     2854 203D 
0102 2856 ....             text  'xws29ol.'
0103 285E ....             text  'ced38ik,'
0104 2866 ....             text  'vrf47ujm'
0105 286E ....             text  'btg56yhn'
0106 2876 ....             text  'zqa10p;/'
0107 287E FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2880 0000 
     2882 FF0D 
     2884 202B 
0108 2886 ....             text  'XWS@(OL>'
0109 288E ....             text  'CED#*IK<'
0110 2896 ....             text  'VRF$&UJM'
0111 289E ....             text  'BTG%^YHN'
0112 28A6 ....             text  'ZQA!)P:-'
0113 28AE FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B0 0000 
     28B2 FF0D 
     28B4 2005 
0114 28B6 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28B8 0804 
     28BA 0F27 
     28BC C2B9 
0115 28BE 600B             data  >600b,>0907,>063f,>c1B8
     28C0 0907 
     28C2 063F 
     28C4 C1B8 
0116 28C6 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28C8 7B02 
     28CA 015F 
     28CC C0C3 
0117 28CE BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D0 7D0E 
     28D2 0CC6 
     28D4 BFC4 
0118 28D6 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28D8 7C03 
     28DA BC22 
     28DC BDBA 
0119 28DE FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E0 0000 
     28E2 FF0D 
     28E4 209D 
0120 28E6 9897             data  >9897,>93b2,>9f8f,>8c9B
     28E8 93B2 
     28EA 9F8F 
     28EC 8C9B 
0121 28EE 8385             data  >8385,>84b3,>9e89,>8b80
     28F0 84B3 
     28F2 9E89 
     28F4 8B80 
0122 28F6 9692             data  >9692,>86b4,>b795,>8a8D
     28F8 86B4 
     28FA B795 
     28FC 8A8D 
0123 28FE 8294             data  >8294,>87b5,>b698,>888E
     2900 87B5 
     2902 B698 
     2904 888E 
0124 2906 9A91             data  >9a91,>81b1,>b090,>9cBB
     2908 81B1 
     290A B090 
     290C 9CBB 
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
0023 290E C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2910 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2912 8340 
0025 2914 04E0  34         clr   @waux1
     2916 833C 
0026 2918 04E0  34         clr   @waux2
     291A 833E 
0027 291C 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     291E 833C 
0028 2920 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2922 0205  20         li    tmp1,4                ; 4 nibbles
     2924 0004 
0033 2926 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2928 0246  22         andi  tmp2,>000f            ; Only keep LSN
     292A 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 292C 0286  22         ci    tmp2,>000a
     292E 000A 
0039 2930 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2932 C21B  26         mov   *r11,tmp4
0045 2934 0988  56         srl   tmp4,8                ; Right justify
0046 2936 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2938 FFF6 
0047 293A 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 293C C21B  26         mov   *r11,tmp4
0054 293E 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2940 00FF 
0055               
0056 2942 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2944 06C6  14         swpb  tmp2
0058 2946 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2948 0944  56         srl   tmp0,4                ; Next nibble
0060 294A 0605  14         dec   tmp1
0061 294C 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 294E 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2950 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2952 C160  34         mov   @waux3,tmp1           ; Get pointer
     2954 8340 
0067 2956 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2958 0585  14         inc   tmp1                  ; Next byte, not word!
0069 295A C120  34         mov   @waux2,tmp0
     295C 833E 
0070 295E 06C4  14         swpb  tmp0
0071 2960 DD44  32         movb  tmp0,*tmp1+
0072 2962 06C4  14         swpb  tmp0
0073 2964 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2966 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2968 8340 
0078 296A D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     296C 2016 
0079 296E 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2970 C120  34         mov   @waux1,tmp0
     2972 833C 
0084 2974 06C4  14         swpb  tmp0
0085 2976 DD44  32         movb  tmp0,*tmp1+
0086 2978 06C4  14         swpb  tmp0
0087 297A DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 297C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     297E 2020 
0092 2980 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2982 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2984 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2986 7FFF 
0098 2988 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     298A 8340 
0099 298C 0460  28         b     @xutst0               ; Display string
     298E 2424 
0100 2990 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2992 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2994 832A 
0122 2996 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2998 8000 
0123 299A 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 299C 0207  20 mknum   li    tmp3,5                ; Digit counter
     299E 0005 
0020 29A0 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A2 C155  26         mov   *tmp1,tmp1            ; /
0022 29A4 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29A6 0228  22         ai    tmp4,4                ; Get end of buffer
     29A8 0004 
0024 29AA 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29AC 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29AE 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B0 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B2 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29B4 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29B6 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29B8 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29BA 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29BC 0607  14         dec   tmp3                  ; Decrease counter
0036 29BE 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C0 0207  20         li    tmp3,4                ; Check first 4 digits
     29C2 0004 
0041 29C4 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29C6 C11B  26         mov   *r11,tmp0
0043 29C8 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29CA 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29CC 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29CE 05CB  14 mknum3  inct  r11
0047 29D0 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D2 2020 
0048 29D4 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29D6 045B  20         b     *r11                  ; Exit
0050 29D8 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29DA 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29DC 13F8  14         jeq   mknum3                ; Yes, exit
0053 29DE 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E0 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E2 7FFF 
0058 29E4 C10B  18         mov   r11,tmp0
0059 29E6 0224  22         ai    tmp0,-4
     29E8 FFFC 
0060 29EA C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29EC 0206  20         li    tmp2,>0500            ; String length = 5
     29EE 0500 
0062 29F0 0460  28         b     @xutstr               ; Display string
     29F2 2426 
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
0093 29F4 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 29F6 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 29F8 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 29FA 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 29FC 0207  20         li    tmp3,5                ; Set counter
     29FE 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A00 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A02 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A04 0584  14         inc   tmp0                  ; Next character
0105 2A06 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A08 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A0A 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A0C 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A0E DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A10 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A12 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A14 0607  14         dec   tmp3                  ; Last character ?
0121 2A16 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A18 045B  20         b     *r11                  ; Return
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
0139 2A1A C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A1C 832A 
0140 2A1E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A20 8000 
0141 2A22 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A24 0649  14         dect  stack
0023 2A26 C64B  30         mov   r11,*stack            ; Save return address
0024 2A28 0649  14         dect  stack
0025 2A2A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A2C 0649  14         dect  stack
0027 2A2E C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A30 0649  14         dect  stack
0029 2A32 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A34 0649  14         dect  stack
0031 2A36 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A38 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A3A C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A3C C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A3E 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A40 0649  14         dect  stack
0044 2A42 C64B  30         mov   r11,*stack            ; Save return address
0045 2A44 0649  14         dect  stack
0046 2A46 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A48 0649  14         dect  stack
0048 2A4A C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A4C 0649  14         dect  stack
0050 2A4E C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A50 0649  14         dect  stack
0052 2A52 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A54 C1D4  26 !       mov   *tmp0,tmp3
0057 2A56 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A58 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A5A 00FF 
0059 2A5C 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A5E 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A60 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A62 0584  14         inc   tmp0                  ; Next byte
0067 2A64 0607  14         dec   tmp3                  ; Shorten string length
0068 2A66 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A68 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A6A 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A6C C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A6E 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A70 C187  18         mov   tmp3,tmp2
0078 2A72 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A74 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A76 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A78 24A8 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A7A 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A7C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A7E FFCE 
0090 2A80 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A82 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A84 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A86 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A88 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A8A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A8C C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A8E 045B  20         b     *r11                  ; Return to caller
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
0123 2A90 0649  14         dect  stack
0124 2A92 C64B  30         mov   r11,*stack            ; Save return address
0125 2A94 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A96 05D9  26         inct  *stack                ; Skip "data P1"
0127 2A98 0649  14         dect  stack
0128 2A9A C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2A9C 0649  14         dect  stack
0130 2A9E C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AA0 0649  14         dect  stack
0132 2AA2 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AA4 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AA6 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AA8 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AAA 0649  14         dect  stack
0144 2AAC C64B  30         mov   r11,*stack            ; Save return address
0145 2AAE 0649  14         dect  stack
0146 2AB0 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AB2 0649  14         dect  stack
0148 2AB4 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AB6 0649  14         dect  stack
0150 2AB8 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2ABA 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2ABC 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2ABE 0586  14         inc   tmp2
0161 2AC0 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AC2 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2AC4 0286  22         ci    tmp2,255
     2AC6 00FF 
0167 2AC8 1505  14         jgt   string.getlenc.panic
0168 2ACA 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2ACC 0606  14         dec   tmp2                  ; One time adjustment
0174 2ACE C806  38         mov   tmp2,@waux1           ; Store length
     2AD0 833C 
0175 2AD2 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AD4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AD6 FFCE 
0181 2AD8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2ADA 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2ADC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2ADE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AE0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AE2 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AE4 045B  20         b     *r11                  ; Return to caller
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
0056 2AE6 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AE8 2AEA             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AEA C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AEC C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AEE A428 
0064 2AF0 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AF2 201C 
0065 2AF4 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2AF6 8356 
0066 2AF8 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2AFA 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2AFC FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2AFE C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B00 A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B02 06C0  14         swpb  r0                    ;
0075 2B04 D800  38         movb  r0,@vdpa              ; Send low byte
     2B06 8C02 
0076 2B08 06C0  14         swpb  r0                    ;
0077 2B0A D800  38         movb  r0,@vdpa              ; Send high byte
     2B0C 8C02 
0078 2B0E D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B10 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B12 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B14 0704  14         seto  r4                    ; Init counter
0086 2B16 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B18 A420 
0087 2B1A 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B1C 0584  14         inc   r4                    ; Increment char counter
0089 2B1E 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B20 0007 
0090 2B22 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B24 80C4  18         c     r4,r3                 ; End of name?
0093 2B26 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B28 06C0  14         swpb  r0                    ;
0098 2B2A D800  38         movb  r0,@vdpa              ; Send low byte
     2B2C 8C02 
0099 2B2E 06C0  14         swpb  r0                    ;
0100 2B30 D800  38         movb  r0,@vdpa              ; Send high byte
     2B32 8C02 
0101 2B34 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B36 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B38 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B3A 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B3C 2C52 
0109 2B3E 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B40 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B42 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B44 04E0  34         clr   @>83d0
     2B46 83D0 
0118 2B48 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B4A 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B4C C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B4E A432 
0121               
0122 2B50 0584  14         inc   r4                    ; Adjust for dot
0123 2B52 A804  38         a     r4,@>8356             ; Point to position after name
     2B54 8356 
0124 2B56 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B58 8356 
     2B5A A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B5C 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B5E 83E0 
0130 2B60 04C1  14         clr   r1                    ; Version found of dsr
0131 2B62 020C  20         li    r12,>0f00             ; Init cru address
     2B64 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B66 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B68 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B6A 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B6C 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B6E 0100 
0145 2B70 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B72 83D0 
0146 2B74 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B76 2000 
0147 2B78 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B7A C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B7C 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B7E 1D00  20         sbo   0                     ; Turn on ROM
0154 2B80 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B82 4000 
0155 2B84 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B86 2C4E 
0156 2B88 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B8A A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B8C A40A 
0166 2B8E 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B90 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B92 83D2 
0172                                                   ; subprogram
0173               
0174 2B94 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2B96 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2B98 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2B9A C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B9C 83D2 
0183                                                   ; subprogram
0184               
0185 2B9E 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BA0 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BA2 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BA4 D160  34         movb  @>8355,r5             ; Get length as counter
     2BA6 8355 
0195 2BA8 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BAA 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BAC 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BAE 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BB0 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BB2 A420 
0206 2BB4 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BB6 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BB8 0605  14         dec   r5                    ; Update loop counter
0211 2BBA 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BBC 0581  14         inc   r1                    ; Next version found
0217 2BBE C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BC0 A42A 
0218 2BC2 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BC4 A42C 
0219 2BC6 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BC8 A430 
0220               
0221 2BCA 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BCC 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BCE 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BD0 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BD2 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BD4 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BD6 A400 
0233 2BD8 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BDA C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BDC A428 
0239                                                   ; (8 or >a)
0240 2BDE 0281  22         ci    r1,8                  ; was it 8?
     2BE0 0008 
0241 2BE2 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BE4 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BE6 8350 
0243                                                   ; Get error byte from @>8350
0244 2BE8 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BEA 06C0  14         swpb  r0                    ;
0252 2BEC D800  38         movb  r0,@vdpa              ; send low byte
     2BEE 8C02 
0253 2BF0 06C0  14         swpb  r0                    ;
0254 2BF2 D800  38         movb  r0,@vdpa              ; send high byte
     2BF4 8C02 
0255 2BF6 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BF8 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2BFA 09D1  56         srl   r1,13                 ; just keep error bits
0263 2BFC 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2BFE 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C00 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C02 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C04 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C06 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C08 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C0A D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C0C F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C0E 201C 
0281                                                   ; / to indicate error
0282 2C10 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C12 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C14 2C16             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C16 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C18 83E0 
0316               
0317 2C1A 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C1C 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C1E 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C20 A42A 
0322 2C22 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C24 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C26 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C28 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C2A C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C2C C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C2E 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C30 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C32 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C34 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C36 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C38 4000 
     2C3A 2C4E 
0337 2C3C 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C3E 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C40 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C42 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C44 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C46 A400 
0355 2C48 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C4A A434 
0356               
0357 2C4C 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C4E AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C50 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C52 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C54 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C56 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C58 0649  14         dect  stack
0052 2C5A C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C5C 0204  20         li    tmp0,dsrlnk.savcru
     2C5E A42A 
0057 2C60 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C62 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C64 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C66 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C68 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C6A 37D7 
0065 2C6C C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C6E 8370 
0066                                                   ; / location
0067 2C70 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C72 A44C 
0068 2C74 04C5  14         clr   tmp1                  ; io.op.open
0069 2C76 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2C78 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C7A 0649  14         dect  stack
0097 2C7C C64B  30         mov   r11,*stack            ; Save return address
0098 2C7E 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C80 0001 
0099 2C82 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2C84 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C86 0649  14         dect  stack
0125 2C88 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C8A 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C8C 0002 
0128 2C8E 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2C90 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C92 0649  14         dect  stack
0155 2C94 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2C96 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2C98 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2C9A 0005 
0159               
0160 2C9C C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2C9E A43E 
0161               
0162 2CA0 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CA2 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CA4 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CA6 0003 
0167 2CA8 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CAA 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CAC 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CAE 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CB0 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CB2 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CB4 1000  14         nop
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
0227 2CB6 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CB8 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CBA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CBC A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CBE A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CC0 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CC2 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CC4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CC6 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CC8 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CCA A44C 
0246               
0247 2CCC 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CCE 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CD0 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CD2 0009 
0254 2CD4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CD6 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CD8 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CDA 8322 
     2CDC 833C 
0259               
0260 2CDE C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CE0 A42A 
0261 2CE2 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CE4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CE6 2AE6 
0268 2CE8 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CEA 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CEC 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CEE 2C12 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CF0 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CF2 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2CF4 833C 
     2CF6 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2CF8 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2CFA A436 
0292 2CFC 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2CFE 0005 
0293 2D00 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D02 22E8 
0294 2D04 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D06 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D08 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D0A 045B  20         b     *r11                  ; Return to caller
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
0020 2D0C 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D0E 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D10 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D12 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D14 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D16 201C 
0029 2D18 1602  14         jne   tmgr1a                ; No, so move on
0030 2D1A E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D1C 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D1E 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D20 2020 
0035 2D22 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D24 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D26 2010 
0048 2D28 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D2A 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D2C 200E 
0050 2D2E 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D30 0460  28         b     @kthread              ; Run kernel thread
     2D32 2DAA 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D34 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D36 2014 
0056 2D38 13EB  14         jeq   tmgr1
0057 2D3A 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D3C 2012 
0058 2D3E 16E8  14         jne   tmgr1
0059 2D40 C120  34         mov   @wtiusr,tmp0
     2D42 832E 
0060 2D44 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D46 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D48 2DA8 
0065 2D4A C10A  18         mov   r10,tmp0
0066 2D4C 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D4E 00FF 
0067 2D50 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D52 201C 
0068 2D54 1303  14         jeq   tmgr5
0069 2D56 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D58 003C 
0070 2D5A 1002  14         jmp   tmgr6
0071 2D5C 0284  22 tmgr5   ci    tmp0,50
     2D5E 0032 
0072 2D60 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D62 1001  14         jmp   tmgr8
0074 2D64 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D66 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D68 832C 
0079 2D6A 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D6C FF00 
0080 2D6E C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D70 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D72 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D74 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D76 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D78 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D7A 830C 
     2D7C 830D 
0089 2D7E 1608  14         jne   tmgr10                ; No, get next slot
0090 2D80 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D82 FF00 
0091 2D84 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D86 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D88 8330 
0096 2D8A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D8C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D8E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D90 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D92 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D94 8315 
     2D96 8314 
0103 2D98 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D9A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D9C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D9E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DA0 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DA2 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DA4 FF00 
0109 2DA6 10B4  14         jmp   tmgr1
0110 2DA8 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DAA E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DAC 2010 
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
0041 2DAE 06A0  32         bl    @realkb               ; Scan full keyboard
     2DB0 27B2 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DB2 0460  28         b     @tmgr3                ; Exit
     2DB4 2D34 
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
0017 2DB6 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DB8 832E 
0018 2DBA E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DBC 2012 
0019 2DBE 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D10     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DC0 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DC2 832E 
0029 2DC4 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DC6 FEFF 
0030 2DC8 045B  20         b     *r11                  ; Return
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
0017 2DCA C13B  30 mkslot  mov   *r11+,tmp0
0018 2DCC C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DCE C184  18         mov   tmp0,tmp2
0023 2DD0 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DD2 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DD4 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DD6 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DD8 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DDA C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DDC 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DDE 2022 
0035 2DE0 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DE2 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DE4 05CB  14 mkslo1  inct  r11
0041 2DE6 045B  20         b     *r11                  ; Exit
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
0052 2DE8 C13B  30 clslot  mov   *r11+,tmp0
0053 2DEA 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DEC A120  34         a     @wtitab,tmp0          ; Add table base
     2DEE 832C 
0055 2DF0 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DF2 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DF4 045B  20         b     *r11                  ; Exit
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
0068 2DF6 C13B  30 rsslot  mov   *r11+,tmp0
0069 2DF8 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2DFA A120  34         a     @wtitab,tmp0          ; Add table base
     2DFC 832C 
0071 2DFE 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E00 C154  26         mov   *tmp0,tmp1
0073 2E02 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E04 FF00 
0074 2E06 C505  30         mov   tmp1,*tmp0
0075 2E08 045B  20         b     *r11                  ; Exit
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
0260 2E0A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E0C 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E0E 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E10 0000 
0266 2E12 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E14 8300 
0267 2E16 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E18 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E1A 0202  20 runli2  li    r2,>8308
     2E1C 8308 
0272 2E1E 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E20 0282  22         ci    r2,>8400
     2E22 8400 
0274 2E24 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E26 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E28 FFFF 
0279 2E2A 1602  14         jne   runli4                ; No, continue
0280 2E2C 0420  54         blwp  @0                    ; Yes, bye bye
     2E2E 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E30 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E32 833C 
0285 2E34 04C1  14         clr   r1                    ; Reset counter
0286 2E36 0202  20         li    r2,10                 ; We test 10 times
     2E38 000A 
0287 2E3A C0E0  34 runli5  mov   @vdps,r3
     2E3C 8802 
0288 2E3E 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E40 2020 
0289 2E42 1302  14         jeq   runli6
0290 2E44 0581  14         inc   r1                    ; Increase counter
0291 2E46 10F9  14         jmp   runli5
0292 2E48 0602  14 runli6  dec   r2                    ; Next test
0293 2E4A 16F7  14         jne   runli5
0294 2E4C 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E4E 1250 
0295 2E50 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E52 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E54 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E56 06A0  32 runli7  bl    @loadmc
     2E58 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E5A 04C1  14 runli9  clr   r1
0305 2E5C 04C2  14         clr   r2
0306 2E5E 04C3  14         clr   r3
0307 2E60 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E62 3000 
0308 2E64 020F  20         li    r15,vdpw              ; Set VDP write address
     2E66 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E68 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E6A 4A4A 
0317 2E6C 1605  14         jne   runlia
0318 2E6E 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E70 2292 
0319 2E72 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E74 0000 
     2E76 3000 
0324 2E78 06A0  32 runlia  bl    @filv
     2E7A 2292 
0325 2E7C 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E7E 00F4 
     2E80 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E82 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E84 26FA 
0333 2E86 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E88 2714 
0334 2E8A 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E8C 270A 
0335               
0336 2E8E 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E90 2336 
0337 2E92 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E94 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E96 22FC 
0351 2E98 338A             data  spvmod                ; Equate selected video mode table
0352 2E9A 0204  20         li    tmp0,spfont           ; Get font option
     2E9C 000C 
0353 2E9E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EA0 1304  14         jeq   runlid                ; Yes, skip it
0355 2EA2 06A0  32         bl    @ldfnt
     2EA4 2364 
0356 2EA6 1100             data  fntadr,spfont         ; Load specified font
     2EA8 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EAA 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EAC 4A4A 
0361 2EAE 1602  14         jne   runlie                ; No, continue
0362 2EB0 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EB2 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EB4 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EB6 0040 
0367 2EB8 0460  28         b     @main                 ; Give control to main program
     2EBA 6036 
**** **** ****     > stevie_b1.asm.1930724
0040                                                   ; Relocated spectra2 in low MEMEXP, was
0041                                                   ; copied to >2000 from ROM in bank 0
0042                       ;------------------------------------------------------
0043                       ; End of File marker
0044                       ;------------------------------------------------------
0045 2EBC DEAD             data >dead,>beef,>dead,>beef
     2EBE BEEF 
     2EC0 DEAD 
     2EC2 BEEF 
0047               ***************************************************************
0048               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0049               ********|*****|*********************|**************************
0050                       aorg  >3000
0051                       ;------------------------------------------------------
0052                       ; Activate bank 1 and branch to  >6036
0053                       ;------------------------------------------------------
0054 3000 04E0  34         clr   @bank1                ; Activate bank 1 "James"
     3002 6002 
0055 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0056                       ;------------------------------------------------------
0057                       ; Resident Stevie modules: >3000 - >3fff
0058                       ;------------------------------------------------------
0059                       copy  "ram.resident.3000.asm"
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
0004               
0005               ***************************************************************
0006               * rom.farjump - Jump to routine in specified bank
0007               ***************************************************************
0008               *  bl   @rom.farjump
0009               *       data p0,p1
0010               *--------------------------------------------------------------
0011               *  p0 = Write address of target ROM bank
0012               *  p1 = Vector address with target address to jump to
0013               *  p2 = Write address of source ROM bank
0014               *--------------------------------------------------------------
0015               *  bl @xrom.farjump
0016               *
0017               *  tmp0 = Write address of target ROM bank
0018               *  tmp1 = Vector address with target address to jump to
0019               *  tmp2 = Write address of source ROM bank
0020               ********|*****|*********************|**************************
0021               rom.farjump:
0022 3008 C13B  30         mov   *r11+,tmp0            ; P0
0023 300A C17B  30         mov   *r11+,tmp1            ; P1
0024 300C C1BB  30         mov   *r11+,tmp2            ; P2
0025                       ;------------------------------------------------------
0026                       ; Push registers to value stack (but not r11!)
0027                       ;------------------------------------------------------
0028               xrom.farjump:
0029 300E 0649  14         dect  stack
0030 3010 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 3012 0649  14         dect  stack
0032 3014 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 3016 0649  14         dect  stack
0034 3018 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 301A 0649  14         dect  stack
0036 301C C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Push to farjump return stack
0039                       ;------------------------------------------------------
0040 301E 0284  22         ci    tmp0,>6002            ; Invalid bank write address?
     3020 6002 
0041 3022 110C  14         jlt   rom.farjump.bankswitch.failed1
0042                                                   ; Crash if null value in bank write address
0043               
0044 3024 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     3026 A026 
0045 3028 0647  14         dect  tmp3
0046 302A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0047 302C 0647  14         dect  tmp3
0048 302E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0049 3030 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3032 A026 
0050                       ;------------------------------------------------------
0051                       ; Bankswitch to target bank
0052                       ;------------------------------------------------------
0053               rom.farjump.bankswitch:
0054 3034 04D4  26         clr   *tmp0                 ; Switch to target ROM bank
0055 3036 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0056 3038 1301  14         jeq   rom.farjump.bankswitch.failed1
0057                                                   ; Crash if null-pointer in vector
0058 303A 1004  14         jmp   rom.farjump.bankswitch.call
0059                                                   ; Call function in target bank
0060                       ;------------------------------------------------------
0061                       ; Assert 1 failed before bank-switch
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.failed1:
0064 303C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     303E FFCE 
0065 3040 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3042 2026 
0066                       ;------------------------------------------------------
0067                       ; Call function in target bank
0068                       ;------------------------------------------------------
0069               rom.farjump.bankswitch.call:
0070 3044 0694  24         bl    *tmp0                 ; Call function
0071                       ;------------------------------------------------------
0072                       ; Bankswitch back to source bank
0073                       ;------------------------------------------------------
0074               rom.farjump.return:
0075 3046 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     3048 A026 
0076 304A C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0077 304C 130D  14         jeq   rom.farjump.bankswitch.failed2
0078                                                   ; Crash if null-pointer in address
0079               
0080 304E 04F4  30         clr   *tmp0+                ; Remove bank write address from
0081                                                   ; farjump stack
0082               
0083 3050 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0084               
0085 3052 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0086                                                   ; farjump stack
0087               
0088 3054 028B  22         ci    r11,>6000
     3056 6000 
0089 3058 1107  14         jlt   rom.farjump.bankswitch.failed2
0090 305A 028B  22         ci    r11,>7fff
     305C 7FFF 
0091 305E 1504  14         jgt   rom.farjump.bankswitch.failed2
0092               
0093 3060 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3062 A026 
0094 3064 04D5  26         clr   *tmp1                 ; Switch to bank of caller
0095 3066 1004  14         jmp   rom.farjump.exit
0096                       ;------------------------------------------------------
0097                       ; Assert 2 failed after bank-switch
0098                       ;------------------------------------------------------
0099               rom.farjump.bankswitch.failed2:
0100 3068 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     306A FFCE 
0101 306C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     306E 2026 
0102                       ;-------------------------------------------------------
0103                       ; Exit
0104                       ;-------------------------------------------------------
0105               rom.farjump.exit:
0106 3070 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0107 3072 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0108 3074 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0109 3076 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0110 3078 045B  20         b     *r11                  ; Return to caller
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
0020 307A 0649  14         dect  stack
0021 307C C64B  30         mov   r11,*stack            ; Save return address
0022 307E 0649  14         dect  stack
0023 3080 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3082 0649  14         dect  stack
0025 3084 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3086 0204  20         li    tmp0,fb.top
     3088 A600 
0030 308A C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     308C A100 
0031 308E 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3090 A104 
0032 3092 04E0  34         clr   @fb.row               ; Current row=0
     3094 A106 
0033 3096 04E0  34         clr   @fb.column            ; Current column=0
     3098 A10C 
0034               
0035 309A 0204  20         li    tmp0,colrow
     309C 0050 
0036 309E C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     30A0 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 30A2 C160  34         mov   @tv.ruler.visible,tmp1
     30A4 A010 
0041 30A6 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 30A8 0204  20         li    tmp0,pane.botrow-2
     30AA 001B 
0043 30AC 1002  14         jmp   fb.init.cont
0044 30AE 0204  20 !       li    tmp0,pane.botrow-1
     30B0 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 30B2 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     30B4 A11A 
0050 30B6 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30B8 A11C 
0051               
0052 30BA 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30BC A022 
0053 30BE 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30C0 A110 
0054 30C2 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30C4 A116 
0055 30C6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30C8 A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 30CA 06A0  32         bl    @film
     30CC 223A 
0060 30CE A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30D0 0000 
     30D2 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 30D4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 30D6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 30D8 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 30DA 045B  20         b     *r11                  ; Return to caller
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
0046 30DC 0649  14         dect  stack
0047 30DE C64B  30         mov   r11,*stack            ; Save return address
0048 30E0 0649  14         dect  stack
0049 30E2 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30E4 0204  20         li    tmp0,idx.top
     30E6 B000 
0054 30E8 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30EA A202 
0055               
0056 30EC C120  34         mov   @tv.sams.b000,tmp0
     30EE A006 
0057 30F0 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     30F2 A500 
0058 30F4 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     30F6 A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 30F8 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     30FA 0004 
0063 30FC C804  38         mov   tmp0,@idx.sams.hipage ; /
     30FE A504 
0064               
0065 3100 06A0  32         bl    @_idx.sams.mapcolumn.on
     3102 311E 
0066                                                   ; Index in continuous memory region
0067               
0068 3104 06A0  32         bl    @film
     3106 223A 
0069 3108 B000                   data idx.top,>00,idx.size * 5
     310A 0000 
     310C 5000 
0070                                                   ; Clear index
0071               
0072 310E 06A0  32         bl    @_idx.sams.mapcolumn.off
     3110 3152 
0073                                                   ; Restore memory window layout
0074               
0075 3112 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     3114 A502 
     3116 A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 3118 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 311A C2F9  30         mov   *stack+,r11           ; Pop r11
0083 311C 045B  20         b     *r11                  ; Return to caller
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
0096 311E 0649  14         dect  stack
0097 3120 C64B  30         mov   r11,*stack            ; Push return address
0098 3122 0649  14         dect  stack
0099 3124 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 3126 0649  14         dect  stack
0101 3128 C645  30         mov   tmp1,*stack           ; Push tmp1
0102 312A 0649  14         dect  stack
0103 312C C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 312E C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3130 A502 
0108 3132 0205  20         li    tmp1,idx.top
     3134 B000 
0109 3136 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3138 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 313A 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     313C 253E 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 313E 0584  14         inc   tmp0                  ; Next SAMS index page
0118 3140 0225  22         ai    tmp1,>1000            ; Next memory region
     3142 1000 
0119 3144 0606  14         dec   tmp2                  ; Update loop counter
0120 3146 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 3148 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 314A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 314C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 314E C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3150 045B  20         b     *r11                  ; Return to caller
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
0145 3152 0649  14         dect  stack
0146 3154 C64B  30         mov   r11,*stack            ; Push return address
0147 3156 0649  14         dect  stack
0148 3158 C644  30         mov   tmp0,*stack           ; Push tmp0
0149 315A 0649  14         dect  stack
0150 315C C645  30         mov   tmp1,*stack           ; Push tmp1
0151 315E 0649  14         dect  stack
0152 3160 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 3162 0649  14         dect  stack
0154 3164 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 3166 0205  20         li    tmp1,idx.top
     3168 B000 
0159 316A 0206  20         li    tmp2,5                ; Always 5 pages
     316C 0005 
0160 316E 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3170 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 3172 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 3174 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3176 253E 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 3178 0225  22         ai    tmp1,>1000            ; Next memory region
     317A 1000 
0171 317C 0606  14         dec   tmp2                  ; Update loop counter
0172 317E 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3180 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 3182 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 3184 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 3186 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 3188 C2F9  30         mov   *stack+,r11           ; Pop return address
0182 318A 045B  20         b     *r11                  ; Return to caller
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
0206 318C 0649  14         dect  stack
0207 318E C64B  30         mov   r11,*stack            ; Save return address
0208 3190 0649  14         dect  stack
0209 3192 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 3194 0649  14         dect  stack
0211 3196 C645  30         mov   tmp1,*stack           ; Push tmp1
0212 3198 0649  14         dect  stack
0213 319A C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 319C C184  18         mov   tmp0,tmp2             ; Line number
0218 319E 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 31A0 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     31A2 0800 
0220               
0221 31A4 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 31A6 0A16  56         sla   tmp2,1                ; line number * 2
0226 31A8 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     31AA 2F30 
0227               
0228 31AC A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     31AE A502 
0229 31B0 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     31B2 A500 
0230               
0231 31B4 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 31B6 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31B8 A500 
0237 31BA C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31BC A006 
0238               
0239 31BE C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31C0 0205  20         li    tmp1,>b000            ; Memory window for index page
     31C2 B000 
0241               
0242 31C4 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31C6 253E 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31C8 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31CA A504 
0249 31CC 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31CE C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31D0 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31D2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31D4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31D6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31D8 C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31DA 045B  20         b     *r11                  ; Return to caller
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
0022 31DC 0649  14         dect  stack
0023 31DE C64B  30         mov   r11,*stack            ; Save return address
0024 31E0 0649  14         dect  stack
0025 31E2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31E4 0204  20         li    tmp0,edb.top          ; \
     31E6 C000 
0030 31E8 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31EA A200 
0031 31EC C804  38         mov   tmp0,@edb.next_free.ptr
     31EE A208 
0032                                                   ; Set pointer to next free line
0033               
0034 31F0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31F2 A20A 
0035               
0036 31F4 0204  20         li    tmp0,1
     31F6 0001 
0037 31F8 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31FA A204 
0038               
0039 31FC 0720  34         seto  @edb.block.m1         ; Reset block start line
     31FE A20C 
0040 3200 0720  34         seto  @edb.block.m2         ; Reset block end line
     3202 A20E 
0041               
0042 3204 0204  20         li    tmp0,txt.newfile      ; "New file"
     3206 35B0 
0043 3208 C804  38         mov   tmp0,@edb.filename.ptr
     320A A212 
0044               
0045 320C 0204  20         li    tmp0,txt.filetype.none
     320E 3670 
0046 3210 C804  38         mov   tmp0,@edb.filetype.ptr
     3212 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 3214 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 3216 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 3218 045B  20         b     *r11                  ; Return to caller
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
0022 321A 0649  14         dect  stack
0023 321C C64B  30         mov   r11,*stack            ; Save return address
0024 321E 0649  14         dect  stack
0025 3220 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3222 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3224 D000 
0030 3226 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3228 A300 
0031               
0032 322A 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     322C A302 
0033 322E 0204  20         li    tmp0,4
     3230 0004 
0034 3232 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3234 A306 
0035 3236 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3238 A308 
0036               
0037 323A 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     323C A316 
0038 323E 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3240 A318 
0039 3242 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3244 A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 3246 06A0  32         bl    @film
     3248 223A 
0044 324A D000             data  cmdb.top,>00,cmdb.size
     324C 0000 
     324E 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3250 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3252 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3254 045B  20         b     *r11                  ; Return to caller
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
0022 3256 0649  14         dect  stack
0023 3258 C64B  30         mov   r11,*stack            ; Save return address
0024 325A 0649  14         dect  stack
0025 325C C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 325E 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3260 A028 
0030               
0031 3262 06A0  32         bl    @film
     3264 223A 
0032 3266 A02A                   data tv.error.msg,0,160
     3268 0000 
     326A 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 326C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 326E C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3270 045B  20         b     *r11                  ; Return to caller
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
0022 3272 0649  14         dect  stack
0023 3274 C64B  30         mov   r11,*stack            ; Save return address
0024 3276 0649  14         dect  stack
0025 3278 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 327A 0204  20         li    tmp0,1                ; \ Set default color scheme
     327C 0001 
0030 327E C804  38         mov   tmp0,@tv.colorscheme  ; /
     3280 A012 
0031               
0032 3282 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3284 A024 
0033 3286 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3288 200C 
0034               
0035 328A 0204  20         li    tmp0,fj.bottom
     328C F000 
0036 328E C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3290 A026 
0037               
0038 3292 0720  34         seto  @tv.ruler.visible
     3294 A010 
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               tv.init.exit:
0043 3296 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0044 3298 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 329A 045B  20         b     *r11                  ; Return to caller
0046               
0047               
0048               
0049               ***************************************************************
0050               * tv.reset
0051               * Reset editor (clear buffer)
0052               ***************************************************************
0053               * bl @tv.reset
0054               *--------------------------------------------------------------
0055               * INPUT
0056               * none
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * none
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * r11
0063               *--------------------------------------------------------------
0064               * Notes
0065               ***************************************************************
0066               tv.reset:
0067 329C 0649  14         dect  stack
0068 329E C64B  30         mov   r11,*stack            ; Save return address
0069                       ;------------------------------------------------------
0070                       ; Reset editor
0071                       ;------------------------------------------------------
0072 32A0 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32A2 321A 
0073 32A4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32A6 31DC 
0074 32A8 06A0  32         bl    @idx.init             ; Initialize index
     32AA 30DC 
0075 32AC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32AE 307A 
0076 32B0 06A0  32         bl    @errline.init         ; Initialize error line
     32B2 3256 
0077                       ;------------------------------------------------------
0078                       ; Remove markers and shortcuts
0079                       ;------------------------------------------------------
0080 32B4 06A0  32         bl    @hchar
     32B6 278A 
0081 32B8 0034                   byte 0,52,32,18           ; Remove markers
     32BA 2012 
0082 32BC 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     32BE 2032 
0083 32C0 FFFF                   data eol
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               tv.reset.exit:
0088 32C2 C2F9  30         mov   *stack+,r11           ; Pop R11
0089 32C4 045B  20         b     *r11                  ; Return to caller
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
0020 32C6 0649  14         dect  stack
0021 32C8 C64B  30         mov   r11,*stack            ; Save return address
0022 32CA 0649  14         dect  stack
0023 32CC C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32CE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32D0 299C 
0028 32D2 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32D4 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32D6 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32D8 0204  20         li    tmp0,unpacked.string
     32DA 2F44 
0034 32DC 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32DE 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32E0 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32E2 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32E4 29F4 
0039 32E6 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32E8 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32EA 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32EE C2F9  30         mov   *stack+,r11           ; Pop r11
0048 32F0 045B  20         b     *r11                  ; Return to caller
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
0073 32F2 0649  14         dect  stack
0074 32F4 C64B  30         mov   r11,*stack            ; Push return address
0075 32F6 0649  14         dect  stack
0076 32F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 32FA 0649  14         dect  stack
0078 32FC C645  30         mov   tmp1,*stack           ; Push tmp1
0079 32FE 0649  14         dect  stack
0080 3300 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 3302 0649  14         dect  stack
0082 3304 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 3306 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     3308 2F20 
0087 330A D194  26         movb  *tmp0,tmp2            ; /
0088 330C 0986  56         srl   tmp2,8                ; Right align
0089 330E C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 3310 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3312 2F22 
0092 3314 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 3316 C120  34         mov   @parm1,tmp0           ; Get source address
     3318 2F20 
0097 331A C160  34         mov   @parm4,tmp1           ; Get destination address
     331C 2F26 
0098 331E 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3320 0649  14         dect  stack
0101 3322 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 3324 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3326 24A8 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 3328 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 332A C120  34         mov   @parm2,tmp0           ; Get requested length
     332C 2F22 
0113 332E 0A84  56         sla   tmp0,8                ; Left align
0114 3330 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3332 2F26 
0115 3334 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 3336 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 3338 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 333A C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     333C 2F22 
0122 333E 6187  18         s     tmp3,tmp2             ; |
0123 3340 0586  14         inc   tmp2                  ; /
0124               
0125 3342 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3344 2F24 
0126 3346 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 3348 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 334A 0606  14         dec   tmp2                  ; Update loop counter
0133 334C 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 334E C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3350 2F26 
     3352 2F30 
0136 3354 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 3356 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3358 FFCE 
0142 335A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     335C 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 335E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3360 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3362 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3364 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 3366 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 3368 045B  20         b     *r11                  ; Return to caller
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
0017 336A 0649  14         dect  stack
0018 336C C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 336E 06A0  32         bl    @sams.layout
     3370 25AA 
0023 3372 3446                   data mem.sams.layout.data
0024               
0025 3374 06A0  32         bl    @sams.layout.copy
     3376 260E 
0026 3378 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 337A C820  54         mov   @tv.sams.c000,@edb.sams.page
     337C A008 
     337E A216 
0029 3380 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3382 A216 
     3384 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 3386 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 3388 045B  20         b     *r11                  ; Return to caller
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
0033 338A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     338C 003F 
     338E 0243 
     3390 05F4 
     3392 0050 
0034               
0035               romsat:
0036 3394 0000             data  >0000,>0001             ; Cursor YX, initial shape and colour
     3396 0001 
0037 3398 0000             data  >0000,>0301             ; Current line indicator
     339A 0301 
0038 339C D000             data  >d000                   ; End-of-Sprites list
0039               
0040               cursors:
0041 339E 0000             byte  >00,>00,>00,>00,>00,>00,>00,>1c ; Cursor 1 - Insert mode
     33A0 0000 
     33A2 0000 
     33A4 001C 
0042 33A6 1010             byte  >10,>10,>10,>10,>10,>10,>10,>00 ; Cursor 2 - Insert mode
     33A8 1010 
     33AA 1010 
     33AC 1000 
0043 33AE 1C1C             byte  >1c,>1c,>1c,>1c,>1c,>1c,>1c,>00 ; Cursor 3 - Overwrite mode
     33B0 1C1C 
     33B2 1C1C 
     33B4 1C00 
0044 33B6 1030             byte  >10,>30,>7f,>ff,>7f,>30,>10,>00 ; Current line indicator
     33B8 7FFF 
     33BA 7F30 
     33BC 1000 
0045               
0046               patterns:
0047 33BE 0000             data  >0000,>0000,>ff00,>0000 ; 01. Single line
     33C0 0000 
     33C2 FF00 
     33C4 0000 
0048 33C6 8080             data  >8080,>8080,>ff80,>8080 ; 02. Connector |-
     33C8 8080 
     33CA FF80 
     33CC 8080 
0049 33CE 0404             data  >0404,>0404,>ff04,>0404 ; 03. Connector -|
     33D0 0404 
     33D2 FF04 
     33D4 0404 
0050               
0051               patterns.box:
0052 33D6 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     33D8 0000 
     33DA FF80 
     33DC BFA0 
0053 33DE 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     33E0 0000 
     33E2 FC04 
     33E4 F414 
0054 33E6 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     33E8 A0A0 
     33EA A0A0 
     33EC A0A0 
0055 33EE 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     33F0 1414 
     33F2 1414 
     33F4 1414 
0056 33F6 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     33F8 A0A0 
     33FA BF80 
     33FC FF00 
0057 33FE 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     3400 1414 
     3402 F404 
     3404 FC00 
0058 3406 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     3408 C0C0 
     340A C0C0 
     340C 0080 
0059 340E 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     3410 0F0F 
     3412 0F0F 
     3414 0000 
0060               
0061               
0062               patterns.cr:
0063 3416 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     3418 6C48 
     341A 4800 
     341C 7C00 
0064 341E 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     3420 64FC 
     3422 6020 
     3424 0000 
0065               
0066               
0067               alphalock:
0068 3426 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     3428 00E0 
     342A E0E0 
     342C E0E0 
0069 342E 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     3430 E0E0 
     3432 E0E0 
     3434 0000 
0070               
0071               
0072               vertline:
0073 3436 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     3438 1010 
     343A 1010 
     343C 1010 
0074               
0075               tabindicator:
0076 343E 0000             data  >0000,>0000,>0030,>3030 ; 17. Tab indicator
     3440 0000 
     3442 0030 
     3444 3030 
0077               
0078               
0079               
0080               
0081               ***************************************************************
0082               * SAMS page layout table for Stevie (16 words)
0083               *--------------------------------------------------------------
0084               mem.sams.layout.data:
0085 3446 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     3448 0002 
0086 344A 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     344C 0003 
0087 344E A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     3450 000A 
0088               
0089 3452 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     3454 0010 
0090                                                   ; \ The index can allocate
0091                                                   ; / pages >10 to >2f.
0092               
0093 3456 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     3458 0030 
0094                                                   ; \ Editor buffer can allocate
0095                                                   ; / pages >30 to >ff.
0096               
0097 345A D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     345C 000D 
0098 345E E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     3460 000E 
0099 3462 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     3464 000F 
0100               
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * Stevie color schemes table
0107               *--------------------------------------------------------------
0108               * Word 1
0109               * A  MSB  high-nibble    Foreground color text line in frame buffer
0110               * B  MSB  low-nibble     Background color text line in frame buffer
0111               * C  LSB  high-nibble    Foreground color top/bottom line
0112               * D  LSB  low-nibble     Background color top/bottom line
0113               *
0114               * Word 2
0115               * E  MSB  high-nibble    Foreground color cmdb pane
0116               * F  MSB  low-nibble     Background color cmdb pane
0117               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0118               * H  LSB  low-nibble     Cursor foreground color frame buffer
0119               *
0120               * Word 3
0121               * I  MSB  high-nibble    Foreground color busy top/bottom line
0122               * J  MSB  low-nibble     Background color busy top/bottom line
0123               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0124               * L  LSB  low-nibble     Background color marked line in frame buffer
0125               *
0126               * Word 4
0127               * M  MSB  high-nibble    Foreground color command buffer header line
0128               * N  MSB  low-nibble     Background color command buffer header line
0129               * O  LSB  high-nibble    Foreground color line indicator frame buffer
0130               * P  LSB  low-nibble     Foreground color ruler frame buffer
0131               *
0132               * Colors
0133               * 0  Transparant
0134               * 1  black
0135               * 2  Green
0136               * 3  Light Green
0137               * 4  Blue
0138               * 5  Light Blue
0139               * 6  Dark Red
0140               * 7  Cyan
0141               * 8  Red
0142               * 9  Light Red
0143               * A  Yellow
0144               * B  Light Yellow
0145               * C  Dark Green
0146               * D  Magenta
0147               * E  Grey
0148               * F  White
0149               *--------------------------------------------------------------
0150      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0151               
0152               tv.colorscheme.table:
0153                       ;                             ; #
0154                       ;      ABCD  EFGH  IJKL  MNOP ; -
0155 3466 F417             data  >f417,>f171,>1b1f,>7111 ; 1  White on blue with cyan touch
     3468 F171 
     346A 1B1F 
     346C 7111 
0156 346E A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     3470 F0FF 
     3472 1F1A 
     3474 F1FF 
0157 3476 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     3478 F0FF 
     347A 1F12 
     347C F1F6 
0158 347E F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3480 1E11 
     3482 1A17 
     3484 1E11 
0159 3486 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     3488 E1FF 
     348A 1F1E 
     348C E1FF 
0160 348E 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3490 1016 
     3492 1B71 
     3494 1711 
0161 3496 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3498 1011 
     349A F1F1 
     349C 1F11 
0162 349E 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     34A0 A1FF 
     34A2 1F1F 
     34A4 F11F 
0163 34A6 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     34A8 12FF 
     34AA 1B12 
     34AC 12FF 
0164 34AE F5F1             data  >f5f1,>e1ff,>1b1f,>f1f1 ; 10 White on light blue
     34B0 E1FF 
     34B2 1B1F 
     34B4 F1F1 
0165                       even
0166               
0167               tv.tabs.table:
0168 34B6 0007             byte  0,7,12,25               ; \   Default tab positions as used
     34B8 0C19 
0169 34BA 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     34BC 3B4F 
0170 34BE FF00             byte  >ff,0,0,0               ; |
     34C0 0000 
0171 34C2 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     34C4 0000 
0172 34C6 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     34C8 0000 
0173                       even
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
0009               ; Strings for welcome pane
0010               ;--------------------------------------------------------------
0011               txt.about.build
0012 34CA 4C42             byte  76
0013 34CB ....             text  'Build: 210408-1930724 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0014                       even
0015               
0016               ;--------------------------------------------------------------
0017               ; Strings for status line pane
0018               ;--------------------------------------------------------------
0019               txt.delim
0020 3518 012C             byte  1
0021 3519 ....             text  ','
0022                       even
0023               
0024               txt.bottom
0025 351A 0520             byte  5
0026 351B ....             text  '  BOT'
0027                       even
0028               
0029               txt.ovrwrite
0030 3520 034F             byte  3
0031 3521 ....             text  'OVR'
0032                       even
0033               
0034               txt.insert
0035 3524 0349             byte  3
0036 3525 ....             text  'INS'
0037                       even
0038               
0039               txt.star
0040 3528 012A             byte  1
0041 3529 ....             text  '*'
0042                       even
0043               
0044               txt.loading
0045 352A 0A4C             byte  10
0046 352B ....             text  'Loading...'
0047                       even
0048               
0049               txt.saving
0050 3536 0A53             byte  10
0051 3537 ....             text  'Saving....'
0052                       even
0053               
0054               txt.block.del
0055 3542 1244             byte  18
0056 3543 ....             text  'Deleting block....'
0057                       even
0058               
0059               txt.block.copy
0060 3556 1143             byte  17
0061 3557 ....             text  'Copying block....'
0062                       even
0063               
0064               txt.block.move
0065 3568 104D             byte  16
0066 3569 ....             text  'Moving block....'
0067                       even
0068               
0069               txt.block.save
0070 357A 1D53             byte  29
0071 357B ....             text  'Saving block to DV80 file....'
0072                       even
0073               
0074               txt.fastmode
0075 3598 0846             byte  8
0076 3599 ....             text  'Fastmode'
0077                       even
0078               
0079               txt.kb
0080 35A2 026B             byte  2
0081 35A3 ....             text  'kb'
0082                       even
0083               
0084               txt.lines
0085 35A6 054C             byte  5
0086 35A7 ....             text  'Lines'
0087                       even
0088               
0089               txt.bufnum
0090 35AC 0323             byte  3
0091 35AD ....             text  '#1 '
0092                       even
0093               
0094               txt.newfile
0095 35B0 0A5B             byte  10
0096 35B1 ....             text  '[New file]'
0097                       even
0098               
0099               txt.filetype.dv80
0100 35BC 0444             byte  4
0101 35BD ....             text  'DV80'
0102                       even
0103               
0104               txt.m1
0105 35C2 034D             byte  3
0106 35C3 ....             text  'M1='
0107                       even
0108               
0109               txt.m2
0110 35C6 034D             byte  3
0111 35C7 ....             text  'M2='
0112                       even
0113               
0114               txt.stevie
0115 35CA 0D53             byte  13
0116 35CB ....             text  'STEVIE 1.1E  '
0117                       even
0118               
0119               txt.keys.default
0120 35D8 1546             byte  21
0121 35D9 ....             text  'F0=Help  ^Open  ^Save'
0122                       even
0123               
0124               txt.keys.block
0125 35EE 2B5E             byte  43
0126 35EF ....             text  '^Del  ^Copy  ^Move  ^Goto M1  ^Reset  ^Save'
0127                       even
0128               
0129 361A ....     txt.ruler          text    '.........1.........2.........3.........4.........5.........6.........7.........8'
0130                                  even
0131               
0132               
0133 366A 010F     txt.alpha.up       data >010f
0134 366C 010E     txt.alpha.down     data >010e
0135 366E 0110     txt.vertline       data >0110
0136               
0137               txt.clear
0138 3670 0420             byte  4
0139 3671 ....             text  '    '
0140                       even
0141               
0142      3670     txt.filetype.none  equ txt.clear
0143               
0144               
0145               ;--------------------------------------------------------------
0146               ; Dialog Load DV 80 file
0147               ;--------------------------------------------------------------
0148 3676 1301     txt.head.load      byte 19,1,3,32
     3678 0320 
0149 367A ....                        text 'Open DV80 file '
0150                                  byte 2
0151               txt.hint.load
0152 368A 4746             byte  71
0153 368B ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0154                       even
0155               
0156               txt.keys.load
0157 36D2 3946             byte  57
0158 36D3 ....             text  'F9=Back    F3=Clear    F5=Fastmode    F-H=Home    F-L=End'
0159                       even
0160               
0161               txt.keys.load2
0162 370C 3946             byte  57
0163 370D ....             text  'F9=Back    F3=Clear   *F5=Fastmode    F-H=Home    F-L=End'
0164                       even
0165               
0166               
0167               ;--------------------------------------------------------------
0168               ; Dialog Save DV 80 file
0169               ;--------------------------------------------------------------
0170 3746 1301     txt.head.save      byte 19,1,3,32
     3748 0320 
0171 374A ....                        text 'Save DV80 file '
0172                                  byte 2
0173 375A 2301     txt.head.save2     byte 35,1,3,32
     375C 0320 
0174 375E ....                        text 'Save marked block to DV80 file '
0175                                  byte 2
0176               txt.hint.save
0177 377E 0120             byte  1
0178 377F ....             text  ' '
0179                       even
0180               
0181               txt.keys.save
0182 3780 2A46             byte  42
0183 3781 ....             text  'F9=Back    F3=Clear    F-H=Home    F-L=End'
0184                       even
0185               
0186               
0187               ;--------------------------------------------------------------
0188               ; Dialog "Unsaved changes"
0189               ;--------------------------------------------------------------
0190 37AC 1401     txt.head.unsaved   byte 20,1,3,32
     37AE 0320 
0191 37B0 ....                        text 'Unsaved changes '
0192 37C0 0232                        byte 2
0193               txt.info.unsaved
0194                       byte  50
0195 37C2 ....             text  'You are about to lose changes to the current file!'
0196                       even
0197               
0198               txt.hint.unsaved
0199 37F4 3950             byte  57
0200 37F5 ....             text  'Press F6 to proceed without saving or ENTER to save file.'
0201                       even
0202               
0203               txt.keys.unsaved
0204 382E 2846             byte  40
0205 382F ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0206                       even
0207               
0208               
0209               ;--------------------------------------------------------------
0210               ; Dialog "About"
0211               ;--------------------------------------------------------------
0212 3858 0A01     txt.head.about     byte 10,1,3,32
     385A 0320 
0213 385C ....                        text 'About '
0214 3862 0200                        byte 2
0215               
0216               txt.info.about
0217                       byte  0
0218 3864 ....             text
0219                       even
0220               
0221               txt.hint.about
0222 3864 2650             byte  38
0223 3865 ....             text  'Press F9 or ENTER to return to editor.'
0224                       even
0225               
0226 388C 3D46     txt.keys.about     byte 61
0227 388D ....                        text 'F9=Back    ENTER=Back   ALPHA LOCK Up= '
0228 38B4 0F20                        byte 15
0229 38B5 ....                        text '   ALPHA LOCK Down= '
0230                                  byte 14
0231               
0232               ;--------------------------------------------------------------
0233               ; Strings for error line pane
0234               ;--------------------------------------------------------------
0235               txt.ioerr.load
0236 38CA 2049             byte  32
0237 38CB ....             text  'I/O error. Failed loading file: '
0238                       even
0239               
0240               txt.ioerr.save
0241 38EC 2049             byte  32
0242 38ED ....             text  'I/O error. Failed saving file:  '
0243                       even
0244               
0245               txt.memfull.load
0246 390E 4049             byte  64
0247 390F ....             text  'Index memory full. Could not fully load file into editor buffer.'
0248                       even
0249               
0250               txt.io.nofile
0251 3950 2149             byte  33
0252 3951 ....             text  'I/O error. No filename specified.'
0253                       even
0254               
0255               txt.block.inside
0256 3972 3445             byte  52
0257 3973 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0258                       even
0259               
0260               
0261               
0262               ;--------------------------------------------------------------
0263               ; Strings for command buffer
0264               ;--------------------------------------------------------------
0265               txt.cmdb.prompt
0266 39A8 013E             byte  1
0267 39A9 ....             text  '>'
0268                       even
0269               
0270               txt.colorscheme
0271 39AA 0D43             byte  13
0272 39AB ....             text  'Color scheme:'
0273                       even
0274               
**** **** ****     > ram.resident.3000.asm
0018                       copy  "data.keymap.keys.asm"   ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      BC00     key.fctn.0    equ >bc00             ; fctn + 0
0008      0300     key.fctn.1    equ >0300             ; fctn + 1
0009      0400     key.fctn.2    equ >0400             ; fctn + 2
0010      0700     key.fctn.3    equ >0700             ; fctn + 3
0011      0200     key.fctn.4    equ >0200             ; fctn + 4
0012      0E00     key.fctn.5    equ >0e00             ; fctn + 5
0013      0C00     key.fctn.6    equ >0c00             ; fctn + 6
0014      0100     key.fctn.7    equ >0100             ; fctn + 7
0015      0600     key.fctn.8    equ >0600             ; fctn + 8
0016      0F00     key.fctn.9    equ >0f00             ; fctn + 9
0017      0000     key.fctn.a    equ >0000             ; fctn + a
0018      BE00     key.fctn.b    equ >be00             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      BF00     key.fctn.h    equ >bf00             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      C000     key.fctn.j    equ >c000             ; fctn + j
0027      C100     key.fctn.k    equ >c100             ; fctn + k
0028      C200     key.fctn.l    equ >c200             ; fctn + l
0029      C300     key.fctn.m    equ >c300             ; fctn + m
0030      C400     key.fctn.n    equ >c400             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      C500     key.fctn.q    equ >c500             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      7F00     key.fctn.v    equ >7f00             ; fctn + v
0039      7E00     key.fctn.w    equ >7e00             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      C600     key.fctn.y    equ >c600             ; fctn + y
0042      0000     key.fctn.z    equ >0000             ; fctn + z
0043               *---------------------------------------------------------------
0044               * Keyboard scancodes - Function keys extra
0045               *---------------------------------------------------------------
0046      B900     key.fctn.dot    equ >b900           ; fctn + .
0047      B800     key.fctn.comma  equ >b800           ; fctn + ,
0048      0500     key.fctn.plus   equ >0500           ; fctn + +
0049               *---------------------------------------------------------------
0050               * Keyboard scancodes - control keys
0051               *-------------|---------------------|---------------------------
0052      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0053      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0054      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0055      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0056      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0057      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0058      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0059      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0060      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0061      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0062      8100     key.ctrl.a    equ >8100             ; ctrl + a
0063      8200     key.ctrl.b    equ >8200             ; ctrl + b
0064      8300     key.ctrl.c    equ >8300             ; ctrl + c
0065      8400     key.ctrl.d    equ >8400             ; ctrl + d
0066      8500     key.ctrl.e    equ >8500             ; ctrl + e
0067      8600     key.ctrl.f    equ >8600             ; ctrl + f
0068      8700     key.ctrl.g    equ >8700             ; ctrl + g
0069      8800     key.ctrl.h    equ >8800             ; ctrl + h
0070      8900     key.ctrl.i    equ >8900             ; ctrl + i
0071      8A00     key.ctrl.j    equ >8a00             ; ctrl + j
0072      8B00     key.ctrl.k    equ >8b00             ; ctrl + k
0073      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0074      8D00     key.ctrl.m    equ >8d00             ; ctrl + m
0075      8E00     key.ctrl.n    equ >8e00             ; ctrl + n
0076      8F00     key.ctrl.o    equ >8f00             ; ctrl + o
0077      9000     key.ctrl.p    equ >9000             ; ctrl + p
0078      9100     key.ctrl.q    equ >9100             ; ctrl + q
0079      9200     key.ctrl.r    equ >9200             ; ctrl + r
0080      9300     key.ctrl.s    equ >9300             ; ctrl + s
0081      9400     key.ctrl.t    equ >9400             ; ctrl + t
0082      9500     key.ctrl.u    equ >9500             ; ctrl + u
0083      9600     key.ctrl.v    equ >9600             ; ctrl + v
0084      9700     key.ctrl.w    equ >9700             ; ctrl + w
0085      9800     key.ctrl.x    equ >9800             ; ctrl + x
0086      9900     key.ctrl.y    equ >9900             ; ctrl + y
0087      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0088               *---------------------------------------------------------------
0089               * Keyboard scancodes - control keys extra
0090               *---------------------------------------------------------------
0091      9B00     key.ctrl.dot    equ >9b00           ; ctrl + .
0092      8000     key.ctrl.comma  equ >8000           ; ctrl + ,
0093      9D00     key.ctrl.plus   equ >9d00           ; ctrl + +
0094               *---------------------------------------------------------------
0095               * Special keys
0096               *---------------------------------------------------------------
0097      0D00     key.enter     equ >0d00             ; enter
**** **** ****     > ram.resident.3000.asm
0019                       ;------------------------------------------------------
0020                       ; End of File marker
0021                       ;------------------------------------------------------
0022 39B8 DEAD             data  >dead,>beef,>dead,>beef
     39BA BEEF 
     39BC DEAD 
     39BE BEEF 
**** **** ****     > stevie_b1.asm.1930724
0060               ***************************************************************
0061               * Step 4: Include main editor modules
0062               ********|*****|*********************|**************************
0063               main:
0064                       aorg  kickstart.code2       ; >6036
0065 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0066                       ;-----------------------------------------------------------------------
0067                       ; Include files
0068                       ;-----------------------------------------------------------------------
0069                       copy  "main.asm"            ; Main file (entrypoint)
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
0028 603A 20A0  38         coc   @wbit1,config         ; F18a detected?
     603C 201E 
0029 603E 1302  14         jeq   main.continue
0030 6040 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6042 0000 
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6044 06A0  32         bl    @scroff               ; Turn screen off
     6046 2656 
0037               
0038 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 26FA 
0039 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 2336 
0040 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0041               
0042 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 2336 
0043 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0044               
0045 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 2336 
0046 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0047                       ;------------------------------------------------------
0048                       ; Clear screen (VDP SIT)
0049                       ;------------------------------------------------------
0050 605E 06A0  32         bl    @filv
     6060 2292 
0051 6062 0000                   data >0000,32,vdp.sit.size.80x30
     6064 0020 
     6066 0960 
0052                                                   ; Clear screen
0053                       ;------------------------------------------------------
0054                       ; Initialize high memory expansion
0055                       ;------------------------------------------------------
0056 6068 06A0  32         bl    @film
     606A 223A 
0057 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0058                       ;------------------------------------------------------
0059                       ; Setup SAMS windows
0060                       ;------------------------------------------------------
0061 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 336A 
0062                       ;------------------------------------------------------
0063                       ; Setup cursor, screen, etc.
0064                       ;------------------------------------------------------
0065 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 2676 
0066 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2686 
0067               
0068 607E 06A0  32         bl    @cpym2m
     6080 24A2 
0069 6082 3394                   data romsat,ramsat,10 ; Load sprite SAT
     6084 2F5A 
     6086 000A 
0070               
0071 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3396 
     608C A014 
0072                                                   ; Save cursor shape & color
0073               
0074 608E 06A0  32         bl    @cpym2v
     6090 244E 
0075 6092 2800                   data sprpdt,cursors,4*8
     6094 339E 
     6096 0020 
0076                                                   ; Load sprite cursor patterns
0077               
0078 6098 06A0  32         bl    @cpym2v
     609A 244E 
0079 609C 1008                   data >1008,patterns,17*8
     609E 33BE 
     60A0 0088 
0080                                                   ; Load character patterns
0081               *--------------------------------------------------------------
0082               * Initialize
0083               *--------------------------------------------------------------
0084 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 3272 
0085 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 329C 
0086                       ;------------------------------------------------------
0087                       ; Load colorscheme amd turn on screen
0088                       ;------------------------------------------------------
0089 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 7746 
0090                                                   ; Load color scheme and turn on screen
0091                       ;-------------------------------------------------------
0092                       ; Setup editor tasks & hook
0093                       ;-------------------------------------------------------
0094 60AE 0204  20         li    tmp0,>0300
     60B0 0300 
0095 60B2 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60B4 8314 
0096               
0097 60B6 06A0  32         bl    @at
     60B8 2696 
0098 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0099               
0100 60BC 0204  20         li    tmp0,timers
     60BE 2F4A 
0101 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0102               
0103 60C4 06A0  32         bl    @mkslot
     60C6 2DCA 
0104 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 74CE 
0105 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60CE 755A 
0106 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D2 75C4 
0107 60D4 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D6 7614 
0108 60D8 FFFF                   data eol
0109               
0110 60DA 06A0  32         bl    @mkhook
     60DC 2DB6 
0111 60DE 7490                   data hook.keyscan     ; Setup user hook
0112               
0113 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D0C 
**** **** ****     > stevie_b1.asm.1930724
0070                       ;-----------------------------------------------------------------------
0071                       ; Keyboard actions
0072                       ;-----------------------------------------------------------------------
0073                       copy  "edkey.key.process.asm"    ; Process keyboard actions
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 60E4 C160  34         mov   @waux1,tmp1           ; Get key value
     60E6 833C 
0009 60E8 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     60EA FF00 
0010 60EC 0707  14         seto  tmp3                  ; EOL marker
0011                       ;-------------------------------------------------------
0012                       ; Process key depending on pane with focus
0013                       ;-------------------------------------------------------
0014 60EE C1A0  34         mov   @tv.pane.focus,tmp2
     60F0 A022 
0015 60F2 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60F4 0000 
0016 60F6 1307  14         jeq   edkey.key.process.loadmap.editor
0017                                                   ; Yes, so load editor keymap
0018               
0019 60F8 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     60FA 0001 
0020 60FC 1307  14         jeq   edkey.key.process.loadmap.cmdb
0021                                                   ; Yes, so load CMDB keymap
0022                       ;-------------------------------------------------------
0023                       ; Pane without focus, crash
0024                       ;-------------------------------------------------------
0025 60FE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6100 FFCE 
0026 6102 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6104 2026 
0027                       ;-------------------------------------------------------
0028                       ; Load Editor keyboard map
0029                       ;-------------------------------------------------------
0030               edkey.key.process.loadmap.editor:
0031 6106 0206  20         li    tmp2,keymap_actions.editor
     6108 7E1C 
0032 610A 1003  14         jmp   edkey.key.check.next
0033                       ;-------------------------------------------------------
0034                       ; Load CMDB keyboard map
0035                       ;-------------------------------------------------------
0036               edkey.key.process.loadmap.cmdb:
0037 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7EE4 
0038 6110 1600  14         jne   edkey.key.check.next
0039                       ;-------------------------------------------------------
0040                       ; Iterate over keyboard map for matching action key
0041                       ;-------------------------------------------------------
0042               edkey.key.check.next:
0043 6112 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0044 6114 1319  14         jeq   edkey.key.process.addbuffer
0045                                                   ; Yes, means no action key pressed, so
0046                                                   ; add character to buffer
0047                       ;-------------------------------------------------------
0048                       ; Check for action key match
0049                       ;-------------------------------------------------------
0050 6116 8585  30         c     tmp1,*tmp2            ; Action key matched?
0051 6118 1303  14         jeq   edkey.key.check.scope
0052                                                   ; Yes, check scope
0053 611A 0226  22         ai    tmp2,6                ; Skip current entry
     611C 0006 
0054 611E 10F9  14         jmp   edkey.key.check.next  ; Check next entry
0055                       ;-------------------------------------------------------
0056                       ; Check scope of key
0057                       ;-------------------------------------------------------
0058               edkey.key.check.scope:
0059 6120 05C6  14         inct  tmp2                  ; Move to scope
0060 6122 8816  46         c     *tmp2,@tv.pane.focus  ; (1) Process key if scope matches pane
     6124 A022 
0061 6126 1306  14         jeq   edkey.key.process.action
0062               
0063 6128 8816  46         c     *tmp2,@cmdb.dialog    ; (2) Process key if scope matches dialog
     612A A31A 
0064 612C 1303  14         jeq   edkey.key.process.action
0065                       ;-------------------------------------------------------
0066                       ; Key pressed outside valid scope, ignore action entry
0067                       ;-------------------------------------------------------
0068 612E 0226  22         ai    tmp2,4                ; Skip current entry
     6130 0004 
0069 6132 10EF  14         jmp   edkey.key.check.next  ; Process next action entry
0070                       ;-------------------------------------------------------
0071                       ; Trigger keyboard action
0072                       ;-------------------------------------------------------
0073               edkey.key.process.action:
0074 6134 05C6  14         inct  tmp2                  ; Move to action address
0075 6136 C196  26         mov   *tmp2,tmp2            ; Get action address
0076               
0077 6138 0204  20         li    tmp0,id.dialog.unsaved
     613A 0065 
0078 613C 8120  34         c     @cmdb.dialog,tmp0
     613E A31A 
0079 6140 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0080               
0081 6142 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6144 A324 
0082 6146 0456  20 !       b     *tmp2                 ; Process key action
0083                       ;-------------------------------------------------------
0084                       ; Add character to editor or cmdb buffer
0085                       ;-------------------------------------------------------
0086               edkey.key.process.addbuffer:
0087 6148 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     614A A022 
0088 614C 1602  14         jne   !                     ; No, skip frame buffer
0089 614E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6150 66FA 
0090                       ;-------------------------------------------------------
0091                       ; CMDB buffer
0092                       ;-------------------------------------------------------
0093 6152 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6154 0001 
0094 6156 1607  14         jne   edkey.key.process.crash
0095                                                   ; No, crash
0096                       ;-------------------------------------------------------
0097                       ; Don't add character if dialog has ID > 100
0098                       ;-------------------------------------------------------
0099 6158 C120  34         mov   @cmdb.dialog,tmp0
     615A A31A 
0100 615C 0284  22         ci    tmp0,100
     615E 0064 
0101 6160 1506  14         jgt   edkey.key.process.exit
0102                       ;-------------------------------------------------------
0103                       ; Add character to CMDB
0104                       ;-------------------------------------------------------
0105 6162 0460  28         b     @edkey.action.cmdb.char
     6164 68F0 
0106                                                   ; Add character to CMDB buffer
0107                       ;-------------------------------------------------------
0108                       ; Crash
0109                       ;-------------------------------------------------------
0110               edkey.key.process.crash:
0111 6166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6168 FFCE 
0112 616A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     616C 2026 
0113                       ;-------------------------------------------------------
0114                       ; Exit
0115                       ;-------------------------------------------------------
0116               edkey.key.process.exit:
0117 616E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6170 74C2 
**** **** ****     > stevie_b1.asm.1930724
0074                       ;-----------------------------------------------------------------------
0075                       ; Keyboard actions - Framebuffer (1)
0076                       ;-----------------------------------------------------------------------
0077                       copy  "edkey.fb.mov.leftright.asm"
**** **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 6172 C120  34         mov   @fb.column,tmp0
     6174 A10C 
0009 6176 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6178 0620  34         dec   @fb.column            ; Column-- in screen buffer
     617A A10C 
0014 617C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     617E 832A 
0015 6180 0620  34         dec   @fb.current
     6182 A102 
0016 6184 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6186 A118 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6188 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     618A 74C2 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 618C 8820  54         c     @fb.column,@fb.row.length
     618E A10C 
     6190 A108 
0028 6192 1408  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6194 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6196 A10C 
0033 6198 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     619A 832A 
0034 619C 05A0  34         inc   @fb.current
     619E A102 
0035 61A0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61A2 A118 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039 61A4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61A6 74C2 
0040               
0041               
0042               *---------------------------------------------------------------
0043               * Cursor beginning of line
0044               *---------------------------------------------------------------
0045               edkey.action.home:
0046 61A8 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61AA A118 
0047 61AC C120  34         mov   @wyx,tmp0
     61AE 832A 
0048 61B0 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     61B2 FF00 
0049 61B4 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     61B6 832A 
0050 61B8 04E0  34         clr   @fb.column
     61BA A10C 
0051 61BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61BE 6A54 
0052 61C0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C2 A118 
0053                       ;-------------------------------------------------------
0054                       ; Exit
0055                       ;-------------------------------------------------------
0056 61C4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C6 74C2 
0057               
0058               
0059               *---------------------------------------------------------------
0060               * Cursor end of line
0061               *---------------------------------------------------------------
0062               edkey.action.end:
0063 61C8 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61CA A118 
0064 61CC C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61CE A108 
0065 61D0 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61D2 0050 
0066 61D4 1102  14         jlt   !                     ; | is right of last character on line,
0067 61D6 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61D8 004F 
0068                       ;-------------------------------------------------------
0069                       ; Set cursor X position
0070                       ;-------------------------------------------------------
0071 61DA C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61DC A10C 
0072 61DE 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61E0 26AE 
0073 61E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61E4 6A54 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077 61E6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61E8 74C2 
**** **** ****     > stevie_b1.asm.1930724
0078                                                        ; Move left / right / home / end
0079                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61EA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61EC A118 
0009 61EE C120  34         mov   @fb.column,tmp0
     61F0 A10C 
0010 61F2 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61F4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61F6 A102 
0015 61F8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 61FA 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 61FC 0605  14         dec   tmp1
0022 61FE 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 6200 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 6202 D195  26         movb  *tmp1,tmp2            ; Get character
0030 6204 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 6206 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 6208 0986  56         srl   tmp2,8                ; Right justify
0033 620A 0286  22         ci    tmp2,32               ; Space character found?
     620C 0020 
0034 620E 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 6210 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6212 2020 
0040 6214 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 6216 0287  22         ci    tmp3,>20ff            ; First character is space
     6218 20FF 
0043 621A 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 621C C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     621E A10C 
0048 6220 61C4  18         s     tmp0,tmp3
0049 6222 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6224 0002 
0050 6226 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 6228 0585  14         inc   tmp1
0056 622A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 622C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     622E A10C 
0062 6230 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6232 26AE 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 6234 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6236 6A54 
0068 6238 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     623A 74C2 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 623C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     623E A118 
0077 6240 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 6242 C120  34         mov   @fb.column,tmp0
     6244 A10C 
0079 6246 8804  38         c     tmp0,@fb.row.length
     6248 A108 
0080 624A 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 624C C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     624E A102 
0085 6250 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6252 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 6254 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 6256 0585  14         inc   tmp1
0097 6258 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 625A 8804  38         c     tmp0,@fb.row.length
     625C A108 
0099 625E 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6260 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6262 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 6264 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 6266 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6268 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     626A FFFF 
0111 626C 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 626E 0286  22         ci    tmp2,32
     6270 0020 
0117 6272 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 6274 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 6276 0286  22         ci    tmp2,32               ; Space character found?
     6278 0020 
0125 627A 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 627C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     627E 2020 
0131 6280 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 6282 0287  22         ci    tmp3,>20ff            ; First characer is space?
     6284 20FF 
0134 6286 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 6288 0585  14         inc   tmp1
0139 628A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 628C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     628E A10C 
0145 6290 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6292 26AE 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 6294 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6296 6A54 
0151 6298 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     629A 74C2 
0152               
0153               
**** **** ****     > stevie_b1.asm.1930724
0080                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 629C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     629E A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 62A0 8820  54         c     @fb.row.dirty,@w$ffff
     62A2 A10A 
     62A4 2022 
0013 62A6 1604  14         jne   edkey.action.up.cursor
0014 62A8 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62AA 6DF0 
0015 62AC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62AE A10A 
0016                       ;-------------------------------------------------------
0017                       ; Move cursor
0018                       ;-------------------------------------------------------
0019               edkey.action.up.cursor:
0020 62B0 C120  34         mov   @fb.row,tmp0
     62B2 A106 
0021 62B4 150B  14         jgt   edkey.action.up.cursor_up
0022                                                   ; Move cursor up if fb.row > 0
0023 62B6 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     62B8 A104 
0024 62BA 130C  14         jeq   edkey.action.up.set_cursorx
0025                                                   ; At top, only position cursor X
0026                       ;-------------------------------------------------------
0027                       ; Scroll 1 line
0028                       ;-------------------------------------------------------
0029 62BC 0604  14         dec   tmp0                  ; fb.topline--
0030 62BE C804  38         mov   tmp0,@parm1           ; Scroll one line up
     62C0 2F20 
0031               
0032 62C2 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     62C4 6AC4 
0033                                                   ; | i  @parm1 = Line to start with
0034                                                   ; /             (becomes @fb.topline)
0035               
0036 62C6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62C8 A110 
0037 62CA 1004  14         jmp   edkey.action.up.set_cursorx
0038                       ;-------------------------------------------------------
0039                       ; Move cursor up
0040                       ;-------------------------------------------------------
0041               edkey.action.up.cursor_up:
0042 62CC 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62CE A106 
0043 62D0 06A0  32         bl    @up                   ; Row-- VDP cursor
     62D2 26A4 
0044                       ;-------------------------------------------------------
0045                       ; Check line length and position cursor
0046                       ;-------------------------------------------------------
0047               edkey.action.up.set_cursorx:
0048 62D4 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62D6 6FE6 
0049                                                   ; | i  @fb.row        = Row in frame buffer
0050                                                   ; / o  @fb.row.length = Length of row
0051               
0052 62D8 8820  54         c     @fb.column,@fb.row.length
     62DA A10C 
     62DC A108 
0053 62DE 1207  14         jle   edkey.action.up.exit
0054                       ;-------------------------------------------------------
0055                       ; Adjust cursor column position
0056                       ;-------------------------------------------------------
0057 62E0 C820  54         mov   @fb.row.length,@fb.column
     62E2 A108 
     62E4 A10C 
0058 62E6 C120  34         mov   @fb.column,tmp0
     62E8 A10C 
0059 62EA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62EC 26AE 
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.up.exit:
0064 62EE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62F0 6A54 
0065 62F2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62F4 74C2 
0066               
0067               
0068               
0069               *---------------------------------------------------------------
0070               * Cursor down
0071               *---------------------------------------------------------------
0072               edkey.action.down:
0073 62F6 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     62F8 A106 
     62FA A204 
0074 62FC 1332  14         jeq   edkey.action.down.exit
0075                                                   ; Yes, skip further processing
0076 62FE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6300 A118 
0077                       ;-------------------------------------------------------
0078                       ; Crunch current row if dirty
0079                       ;-------------------------------------------------------
0080 6302 8820  54         c     @fb.row.dirty,@w$ffff
     6304 A10A 
     6306 2022 
0081 6308 1604  14         jne   edkey.action.down.move
0082 630A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     630C 6DF0 
0083 630E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6310 A10A 
0084                       ;-------------------------------------------------------
0085                       ; Move cursor
0086                       ;-------------------------------------------------------
0087               edkey.action.down.move:
0088                       ;-------------------------------------------------------
0089                       ; EOF reached?
0090                       ;-------------------------------------------------------
0091 6312 C120  34         mov   @fb.topline,tmp0
     6314 A104 
0092 6316 A120  34         a     @fb.row,tmp0
     6318 A106 
0093 631A 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     631C A204 
0094 631E 1314  14         jeq   edkey.action.down.set_cursorx
0095                                                   ; Yes, only position cursor X
0096                       ;-------------------------------------------------------
0097                       ; Check if scrolling required
0098                       ;-------------------------------------------------------
0099 6320 C120  34         mov   @fb.scrrows,tmp0
     6322 A11A 
0100 6324 0604  14         dec   tmp0
0101 6326 8120  34         c     @fb.row,tmp0
     6328 A106 
0102 632A 110A  14         jlt   edkey.action.down.cursor
0103                       ;-------------------------------------------------------
0104                       ; Scroll 1 line
0105                       ;-------------------------------------------------------
0106 632C C820  54         mov   @fb.topline,@parm1
     632E A104 
     6330 2F20 
0107 6332 05A0  34         inc   @parm1
     6334 2F20 
0108               
0109 6336 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6338 6AC4 
0110                                                   ; | i  @parm1 = Line to start with
0111                                                   ; /             (becomes @fb.topline)
0112               
0113 633A 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     633C A110 
0114 633E 1004  14         jmp   edkey.action.down.set_cursorx
0115                       ;-------------------------------------------------------
0116                       ; Move cursor down a row, there are still rows left
0117                       ;-------------------------------------------------------
0118               edkey.action.down.cursor:
0119 6340 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6342 A106 
0120 6344 06A0  32         bl    @down                 ; Row++ VDP cursor
     6346 269C 
0121                       ;-------------------------------------------------------
0122                       ; Check line length and position cursor
0123                       ;-------------------------------------------------------
0124               edkey.action.down.set_cursorx:
0125 6348 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     634A 6FE6 
0126                                                   ; | i  @fb.row        = Row in frame buffer
0127                                                   ; / o  @fb.row.length = Length of row
0128               
0129 634C 8820  54         c     @fb.column,@fb.row.length
     634E A10C 
     6350 A108 
0130 6352 1207  14         jle   edkey.action.down.exit
0131                                                   ; Exit
0132                       ;-------------------------------------------------------
0133                       ; Adjust cursor column position
0134                       ;-------------------------------------------------------
0135 6354 C820  54         mov   @fb.row.length,@fb.column
     6356 A108 
     6358 A10C 
0136 635A C120  34         mov   @fb.column,tmp0
     635C A10C 
0137 635E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6360 26AE 
0138                       ;-------------------------------------------------------
0139                       ; Exit
0140                       ;-------------------------------------------------------
0141               edkey.action.down.exit:
0142 6362 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6364 6A54 
0143 6366 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6368 74C2 
**** **** ****     > stevie_b1.asm.1930724
0081                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 636A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     636C A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 636E 8820  54         c     @fb.row.dirty,@w$ffff
     6370 A10A 
     6372 2022 
0013 6374 1604  14         jne   edkey.action.ppage.sanity
0014 6376 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6378 6DF0 
0015 637A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     637C A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 637E C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6380 A104 
0021 6382 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 6384 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     6386 A11A 
0026 6388 1503  14         jgt   edkey.action.ppage.topline
0027 638A 04E0  34         clr   @fb.topline           ; topline = 0
     638C A104 
0028 638E 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6390 6820  54         s     @fb.scrrows,@fb.topline
     6392 A11A 
     6394 A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 6396 C820  54         mov   @fb.topline,@parm1
     6398 A104 
     639A 2F20 
0039 639C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     639E A110 
0040               
0041 63A0 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 63A2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63A4 74C2 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 63A6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63A8 A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 63AA 8820  54         c     @fb.row.dirty,@w$ffff
     63AC A10A 
     63AE 2022 
0061 63B0 1604  14         jne   edkey.action.npage.sanity
0062 63B2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63B4 6DF0 
0063 63B6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63B8 A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 63BA C120  34         mov   @fb.topline,tmp0
     63BC A104 
0069 63BE A120  34         a     @fb.scrrows,tmp0
     63C0 A11A 
0070 63C2 0584  14         inc   tmp0                  ; Base 1 offset !
0071 63C4 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     63C6 A204 
0072 63C8 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 63CA A820  54         a     @fb.scrrows,@fb.topline
     63CC A11A 
     63CE A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 63D0 C820  54         mov   @fb.topline,@parm1
     63D2 A104 
     63D4 2F20 
0083 63D6 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63D8 A110 
0084               
0085 63DA 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 63DC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63DE 74C2 
**** **** ****     > stevie_b1.asm.1930724
0082                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
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
0011 63E0 8820  54         c     @fb.row.dirty,@w$ffff
     63E2 A10A 
     63E4 2022 
0012 63E6 1604  14         jne   edkey.action.top.refresh
0013 63E8 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63EA 6DF0 
0014 63EC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63EE A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 63F0 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63F2 2F20 
0020 63F4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63F6 A110 
0021               
0022 63F8 0460  28         b     @ _edkey.goto.fb.toprow
     63FA 642C 
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
0035 63FC 8820  54         c     @fb.row.dirty,@w$ffff
     63FE A10A 
     6400 2022 
0036 6402 1604  14         jne   edkey.action.bot.refresh
0037 6404 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6406 6DF0 
0038 6408 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     640A A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 640C 8820  54         c     @edb.lines,@fb.scrrows
     640E A204 
     6410 A11A 
0044 6412 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 6414 C120  34         mov   @edb.lines,tmp0
     6416 A204 
0047 6418 6120  34         s     @fb.scrrows,tmp0
     641A A11A 
0048 641C C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     641E 2F20 
0049 6420 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6422 A110 
0050               
0051 6424 0460  28         b     @ _edkey.goto.fb.toprow
     6426 642C 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 6428 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     642A 74C2 
**** **** ****     > stevie_b1.asm.1930724
0083                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
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
0026 642C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     642E A118 
0027               
0028 6430 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6432 6AC4 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 6434 04E0  34         clr   @fb.row               ; Frame buffer line 0
     6436 A106 
0033 6438 04E0  34         clr   @fb.column            ; Frame buffer column 0
     643A A10C 
0034 643C 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     643E 832A 
0035               
0036 6440 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6442 6A54 
0037               
0038 6444 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6446 6FE6 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6448 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     644A 74C2 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 644C 8820  54         c     @fb.row.dirty,@w$ffff
     644E A10A 
     6450 2022 
0053 6452 1609  14         jne   edkey.action.goto.refresh
0054               
0055 6454 0649  14         dect  stack
0056 6456 C660  46         mov   @parm1,*stack         ; Push parm1
     6458 2F20 
0057 645A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     645C 6DF0 
0058 645E C839  50         mov   *stack+,@parm1        ; Pop parm1
     6460 2F20 
0059               
0060 6462 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6464 A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 6466 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6468 A110 
0066               
0067 646A 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     646C 642C 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.1930724
0084                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 646E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6470 A206 
0009 6472 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6474 6A54 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 6476 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6478 A108 
0015 647A 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 647C C120  34         mov   @fb.current,tmp0      ; Get pointer
     647E A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6480 C1C6  18         mov   tmp2,tmp3             ; \
0024 6482 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 6484 81E0  34         c     @fb.column,tmp3
     6486 A10C 
0026 6488 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 648A 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 648C D505  30         movb  tmp1,*tmp0            ; /
0033 648E C820  54         mov   @fb.column,@fb.row.length
     6490 A10C 
     6492 A108 
0034                                                   ; Row length - 1
0035 6494 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6496 A10A 
0036 6498 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     649A A116 
0037 649C 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 649E 0286  22         ci    tmp2,colrow
     64A0 0050 
0043 64A2 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 64A4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64A6 FFCE 
0049 64A8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64AA 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 64AC C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 64AE 61E0  34         s     @fb.column,tmp3
     64B0 A10C 
0056 64B2 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 64B4 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 64B6 C144  18         mov   tmp0,tmp1
0059 64B8 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 64BA 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64BC A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 64BE C120  34         mov   @fb.current,tmp0      ; Get pointer
     64C0 A102 
0065 64C2 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 64C4 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 64C6 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 64C8 0606  14         dec   tmp2
0073 64CA 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 64CC 0206  20         li    tmp2,colrow
     64CE 0050 
0078 64D0 81A0  34         c     @fb.row.length,tmp2
     64D2 A108 
0079 64D4 1603  14         jne   edkey.action.del_char.save
0080 64D6 0604  14         dec   tmp0                  ; One time adjustment
0081 64D8 04C5  14         clr   tmp1
0082 64DA D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 64DC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64DE A10A 
0088 64E0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64E2 A116 
0089 64E4 0620  34         dec   @fb.row.length        ; @fb.row.length--
     64E6 A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 64E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64EA 74C2 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 64EC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64EE A206 
0102 64F0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64F2 6A54 
0103 64F4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64F6 A108 
0104 64F8 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 64FA C120  34         mov   @fb.current,tmp0      ; Get pointer
     64FC A102 
0110 64FE C1A0  34         mov   @fb.colsline,tmp2
     6500 A10E 
0111 6502 61A0  34         s     @fb.column,tmp2
     6504 A10C 
0112 6506 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 6508 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 650A 0606  14         dec   tmp2
0119 650C 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 650E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6510 A10A 
0124 6512 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6514 A116 
0125               
0126 6516 C820  54         mov   @fb.column,@fb.row.length
     6518 A10C 
     651A A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 651C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     651E 74C2 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 6520 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6522 6A54 
0143 6524 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6526 A10A 
0144               
0145 6528 C820  54         mov   @fb.topline,@parm1    ; \
     652A A104 
     652C 2F20 
0146 652E A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     6530 A106 
     6532 2F20 
0147 6534 05A0  34         inc   @parm1                ; /
     6536 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6538 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     653A 2F20 
     653C A204 
0153 653E 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 6540 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6542 A104 
     6544 2F20 
0157 6546 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6548 6AC4 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 654A 0460  28         b     @edkey.action.up      ; Move cursor one line up
     654C 629C 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 654E 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6550 70EC 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 6552 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     6554 2F20 
     6556 A204 
0170 6558 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 655A 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     655C 6FE6 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 655E C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6560 A104 
     6562 2F20 
0183               
0184 6564 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6566 6AC4 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 6568 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     656A A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 656C C120  34         mov   @fb.topline,tmp0
     656E A104 
0193 6570 A120  34         a     @fb.row,tmp0
     6572 A106 
0194               
0195 6574 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6576 A204 
0196 6578 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 657A 0460  28         b     @edkey.action.up      ; Move cursor one line up
     657C 629C 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 657E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6580 61A8 
**** **** ****     > stevie_b1.asm.1930724
0085                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0010 6582 0204  20         li    tmp0,>2000            ; White space
     6584 2000 
0011 6586 C804  38         mov   tmp0,@parm1
     6588 2F20 
0012               edkey.action.ins_char:
0013 658A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     658C A206 
0014 658E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6590 6A54 
0015                       ;-------------------------------------------------------
0016                       ; Assert 1 - Empty line
0017                       ;-------------------------------------------------------
0018 6592 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6594 A102 
0019 6596 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6598 A108 
0020 659A 132C  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Assert 2 - EOL
0024                       ;-------------------------------------------------------
0025 659C 8820  54         c     @fb.column,@fb.row.length
     659E A10C 
     65A0 A108 
0026 65A2 1328  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Assert 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 65A4 C160  34         mov   @fb.column,tmp1
     65A6 A10C 
0032 65A8 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     65AA 004F 
0033 65AC 1102  14         jlt   !
0034 65AE 0460  28         b     @edkey.action.char.overwrite
     65B0 6720 
0035                       ;-------------------------------------------------------
0036                       ; Assert 4 - 80 characters maximum
0037                       ;-------------------------------------------------------
0038 65B2 C160  34 !       mov   @fb.row.length,tmp1
     65B4 A108 
0039 65B6 0285  22         ci    tmp1,colrow
     65B8 0050 
0040 65BA 1101  14         jlt   edkey.action.ins_char.prep
0041 65BC 101D  14         jmp   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Calculate number of characters to move
0044                       ;-------------------------------------------------------
0045               edkey.action.ins_char.prep:
0046 65BE C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 65C0 61E0  34         s     @fb.column,tmp3
     65C2 A10C 
0048 65C4 0607  14         dec   tmp3                  ; Remove base 1 offset
0049 65C6 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0050 65C8 C144  18         mov   tmp0,tmp1
0051 65CA 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0052 65CC 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     65CE A10C 
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 65D0 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 65D2 0604  14         dec   tmp0
0059 65D4 0605  14         dec   tmp1
0060 65D6 0606  14         dec   tmp2
0061 65D8 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Insert specified character at current position
0064                       ;-------------------------------------------------------
0065 65DA D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     65DC 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 65DE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65E0 A10A 
0070 65E2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65E4 A116 
0071 65E6 05A0  34         inc   @fb.column
     65E8 A10C 
0072 65EA 05A0  34         inc   @wyx
     65EC 832A 
0073 65EE 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65F0 A108 
0074 65F2 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 65F4 0460  28         b     @edkey.action.char.overwrite
     65F6 6720 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 65F8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65FA 74C2 
0085               
0086               
0087               
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Insert new line
0093               *---------------------------------------------------------------
0094               edkey.action.ins_line:
0095 65FC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65FE A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 6600 8820  54         c     @fb.row.dirty,@w$ffff
     6602 A10A 
     6604 2022 
0100 6606 1604  14         jne   edkey.action.ins_line.insert
0101 6608 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     660A 6DF0 
0102 660C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     660E A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 6610 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6612 6A54 
0108 6614 C820  54         mov   @fb.topline,@parm1
     6616 A104 
     6618 2F20 
0109 661A A820  54         a     @fb.row,@parm1        ; Line number to insert
     661C A106 
     661E 2F20 
0110 6620 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6622 A204 
     6624 2F22 
0111               
0112 6626 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6628 6D08 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 662A 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     662C A204 
0117                       ;-------------------------------------------------------
0118                       ; Check/Adjust marker M1
0119                       ;-------------------------------------------------------
0120               edkey.action.ins_line.m1:
0121 662E 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6630 A20C 
     6632 2022 
0122 6634 1308  14         jeq   edkey.action.ins_line.m2
0123                                                   ; Yes, skip to M2 check
0124               
0125 6636 8820  54         c     @parm1,@edb.block.m1
     6638 2F20 
     663A A20C 
0126 663C 1504  14         jgt   edkey.action.ins_line.m2
0127 663E 05A0  34         inc   @edb.block.m1         ; M1++
     6640 A20C 
0128 6642 0720  34         seto  @fb.colorize          ; Set colorize flag
     6644 A110 
0129                       ;-------------------------------------------------------
0130                       ; Check/Adjust marker M2
0131                       ;-------------------------------------------------------
0132               edkey.action.ins_line.m2:
0133 6646 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6648 A20E 
     664A 2022 
0134 664C 1308  14         jeq   edkey.action.ins_line.refresh
0135                                                   ; Yes, skip to refresh frame buffer
0136               
0137 664E 8820  54         c     @parm1,@edb.block.m2
     6650 2F20 
     6652 A20E 
0138 6654 1504  14         jgt   edkey.action.ins_line.refresh
0139 6656 05A0  34         inc   @edb.block.m2         ; M2++
     6658 A20E 
0140 665A 0720  34         seto  @fb.colorize          ; Set colorize flag
     665C A110 
0141                       ;-------------------------------------------------------
0142                       ; Refresh frame buffer and physical screen
0143                       ;-------------------------------------------------------
0144               edkey.action.ins_line.refresh:
0145 665E C820  54         mov   @fb.topline,@parm1
     6660 A104 
     6662 2F20 
0146               
0147 6664 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6666 6AC4 
0148                                                   ; | i  @parm1 = Line to start with
0149                                                   ; /             (becomes @fb.topline)
0150               
0151 6668 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     666A A116 
0152                       ;-------------------------------------------------------
0153                       ; Exit
0154                       ;-------------------------------------------------------
0155               edkey.action.ins_line.exit:
0156 666C 0460  28         b     @edkey.action.home    ; Position cursor at home
     666E 61A8 
0157               
**** **** ****     > stevie_b1.asm.1930724
0086                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 6670 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6672 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 6674 8820  54         c     @fb.row.dirty,@w$ffff
     6676 A10A 
     6678 2022 
0013 667A 1606  14         jne   edkey.action.enter.upd_counter
0014 667C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     667E A206 
0015 6680 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6682 6DF0 
0016 6684 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6686 A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6688 C120  34         mov   @fb.topline,tmp0
     668A A104 
0022 668C A120  34         a     @fb.row,tmp0
     668E A106 
0023 6690 0584  14         inc   tmp0
0024 6692 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6694 A204 
0025 6696 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6698 05A0  34         inc   @edb.lines            ; Total lines++
     669A A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 669C C120  34         mov   @fb.scrrows,tmp0
     669E A11A 
0035 66A0 0604  14         dec   tmp0
0036 66A2 8120  34         c     @fb.row,tmp0
     66A4 A106 
0037 66A6 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 66A8 C120  34         mov   @fb.scrrows,tmp0
     66AA A11A 
0042 66AC C820  54         mov   @fb.topline,@parm1
     66AE A104 
     66B0 2F20 
0043 66B2 05A0  34         inc   @parm1
     66B4 2F20 
0044 66B6 06A0  32         bl    @fb.refresh
     66B8 6AC4 
0045 66BA 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     66BC A110 
0046 66BE 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 66C0 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     66C2 A106 
0052 66C4 06A0  32         bl    @down                 ; Row++ VDP cursor
     66C6 269C 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 66C8 06A0  32         bl    @fb.get.firstnonblank
     66CA 6A7C 
0058 66CC C120  34         mov   @outparm1,tmp0
     66CE 2F30 
0059 66D0 C804  38         mov   tmp0,@fb.column
     66D2 A10C 
0060 66D4 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     66D6 26AE 
0061 66D8 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     66DA 6FE6 
0062 66DC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66DE 6A54 
0063 66E0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66E2 A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 66E4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66E6 74C2 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 66E8 0649  14         dect  stack
0078 66EA C64B  30         mov   r11,*stack            ; Save return address
0079               
0080 66EC 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66EE A118 
0081 66F0 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     66F2 A20A 
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.ins_onoff.exit:
0086 66F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 66F6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66F8 74C2 
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Add character (frame buffer)
0093               *---------------------------------------------------------------
0094               edkey.action.char:
0095 66FA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66FC A118 
0096                       ;-------------------------------------------------------
0097                       ; Asserts
0098                       ;-------------------------------------------------------
0099 66FE D105  18         movb  tmp1,tmp0             ; Get keycode
0100 6700 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 6702 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6704 0020 
0103 6706 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 6708 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     670A 007E 
0107 670C 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 670E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6710 A206 
0113 6712 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6714 2F20 
0114 6716 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6718 A20A 
0115 671A 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 671C 0460  28         b     @edkey.action.ins_char
     671E 658A 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6720 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6722 6A54 
0126 6724 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6726 A102 
0127               
0128 6728 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     672A 2F20 
0129 672C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     672E A10A 
0130 6730 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6732 A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 6734 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6736 A10C 
0135 6738 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     673A 004F 
0136 673C 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 673E 0205  20         li    tmp1,colrow           ; \
     6740 0050 
0140 6742 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     6744 A108 
0141 6746 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 6748 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     674A A10C 
0147 674C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     674E 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 6750 8820  54         c     @fb.column,@fb.row.length
     6752 A10C 
     6754 A108 
0152                                                   ; column < line length ?
0153 6756 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 6758 C820  54         mov   @fb.column,@fb.row.length
     675A A10C 
     675C A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 675E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6760 74C2 
**** **** ****     > stevie_b1.asm.1930724
0087                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 6762 C120  34         mov   @edb.dirty,tmp0
     6764 A206 
0012 6766 1302  14         jeq   !
0013 6768 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     676A 7DC2 
0014                       ;-------------------------------------------------------
0015                       ; Reset and lock F18a
0016                       ;-------------------------------------------------------
0017 676C 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     676E 275E 
0018 6770 0420  54         blwp  @0                    ; Exit
     6772 0000 
**** **** ****     > stevie_b1.asm.1930724
0088                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 6774 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6776 A444 
     6778 2F20 
0018 677A 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     677C 2F22 
0019 677E 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 6780 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6782 A444 
     6784 2F20 
0023 6786 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6788 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 678A C120  34         mov   @parm1,tmp0
     678C 2F20 
0030 678E 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 6790 C120  34         mov   @edb.dirty,tmp0
     6792 A206 
0036 6794 1302  14         jeq   !
0037 6796 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6798 7DC2 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 679A 06A0  32 !       bl    @fm.browse.fname.suffix
     679C 7D68 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 679E 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67A0 E000 
0047 67A2 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     67A4 7D30 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 67A6 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     67A8 63E0 
**** **** ****     > stevie_b1.asm.1930724
0089                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 67AA 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     67AC 717C 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 67AE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67B0 74C2 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 67B2 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     67B4 71A4 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 67B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67B8 74C2 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 67BA 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     67BC 71CC 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 67BE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67C0 74C2 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 67C2 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67C4 7B98 
0043 67C6 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67C8 7208 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 67CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67CC 74C2 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 67CE 0649  14         dect  stack
0055 67D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 67D2 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67D4 A20E 
     67D6 2022 
0060 67D8 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 67DA C120  34         mov   @wyx,tmp0             ; Get cursor position
     67DC 832A 
0066 67DE 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67E0 FF00 
0067 67E2 C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67E4 A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 67E6 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67E8 7B98 
0072               
0073 67EA 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     67EC 2F20 
0074 67EE 06A0  32         bl    @edb.block.copy       ; Copy code block
     67F0 724E 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 67F2 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     67F4 2F30 
     67F6 2000 
0079 67F8 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 67FA C820  54         mov   @fb.yxsave,@parm1
     67FC A114 
     67FE 2F20 
0083 6800 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     6802 6B84 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 6804 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6806 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6808 74C2 
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
0103 680A 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     680C A20E 
     680E 2022 
0104 6810 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 6812 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6814 7B98 
0110               
0111 6816 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     6818 2F20 
0112 681A 06A0  32         bl    @edb.block.delete     ; Delete code block
     681C 7344 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 681E 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6820 2F30 
     6822 2000 
0119 6824 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 6826 C820  54         mov   @fb.topline,@parm1
     6828 A104 
     682A 2F20 
0123 682C 0460  28         b     @_edkey.goto.fb.toprow
     682E 642C 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 6830 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6832 74C2 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 6834 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6836 A20E 
     6838 2022 
0142 683A 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 683C 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     683E 7B98 
0148               
0149 6840 0720  34         seto  @parm1                ; Set message to "Moving block..."
     6842 2F20 
0150 6844 06A0  32         bl    @edb.block.copy       ; Copy code block
     6846 724E 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6848 0720  34         seto  @parm1                ; Don't display delete message
     684A 2F20 
0155 684C 06A0  32         bl    @edb.block.delete     ; Delete code block
     684E 7344 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 6850 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     6852 2F30 
     6854 2000 
0162 6856 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6858 C820  54         mov   @fb.topline,@parm1
     685A A104 
     685C 2F20 
0166 685E 0460  28         b     @_edkey.goto.fb.toprow
     6860 642C 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 6862 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6864 74C2 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 6866 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6868 A20C 
     686A 2022 
0182 686C 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 686E C820  54         mov   @edb.block.m1,@parm1
     6870 A20C 
     6872 2F20 
0188 6874 0620  34         dec   @parm1                ; Base 0 offset
     6876 2F20 
0189               
0190 6878 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     687A 644C 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 687C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     687E 74C2 
**** **** ****     > stevie_b1.asm.1930724
0090                       copy  "edkey.fb.tabs.asm"        ; tab-key related actions
**** **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 6880 0649  14         dect  stack
0009 6882 C64B  30         mov   r11,*stack            ; Save return address
0010 6884 06A0  32         bl  @fb.tab.next            ; Jump to next tab position on line
     6886 7DE6 
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 6888 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 688A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     688C 74C2 
**** **** ****     > stevie_b1.asm.1930724
0091                       ;-----------------------------------------------------------------------
0092                       ; Keyboard actions - Command Buffer
0093                       ;-----------------------------------------------------------------------
0094                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 688E C120  34         mov   @cmdb.column,tmp0
     6890 A312 
0009 6892 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6894 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6896 A312 
0014 6898 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     689A A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 689C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     689E 74C2 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 68A0 06A0  32         bl    @cmdb.cmd.getlength
     68A2 7462 
0026 68A4 8820  54         c     @cmdb.column,@outparm1
     68A6 A312 
     68A8 2F30 
0027 68AA 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 68AC 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     68AE A312 
0032 68B0 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     68B2 A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 68B4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68B6 74C2 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 68B8 04C4  14         clr   tmp0
0045 68BA C804  38         mov   tmp0,@cmdb.column      ; First column
     68BC A312 
0046 68BE 0584  14         inc   tmp0
0047 68C0 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     68C2 A30A 
0048 68C4 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     68C6 A30A 
0049               
0050 68C8 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68CA 74C2 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 68CC D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     68CE A326 
0057 68D0 0984  56         srl   tmp0,8                 ; Right justify
0058 68D2 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     68D4 A312 
0059 68D6 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 68D8 0224  22         ai    tmp0,>1a00             ; Y=26
     68DA 1A00 
0061 68DC C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     68DE A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 68E0 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68E2 74C2 
**** **** ****     > stevie_b1.asm.1930724
0095                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 68E4 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     68E6 7430 
0026 68E8 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68EA A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 68EC 0460  28         b     @edkey.action.cmdb.home
     68EE 68B8 
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
0060 68F0 D105  18         movb  tmp1,tmp0             ; Get keycode
0061 68F2 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 68F4 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     68F6 0020 
0064 68F8 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 68FA 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     68FC 007E 
0068 68FE 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 6900 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6902 A318 
0074               
0075 6904 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6906 A327 
0076 6908 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     690A A312 
0077 690C D505  30         movb  tmp1,*tmp0            ; Add character
0078 690E 05A0  34         inc   @cmdb.column          ; Next column
     6910 A312 
0079 6912 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6914 A30A 
0080               
0081 6916 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6918 7462 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 691A C120  34         mov   @outparm1,tmp0
     691C 2F30 
0088 691E 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 6920 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6922 A326 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 6924 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6926 74C2 
**** **** ****     > stevie_b1.asm.1930724
0096                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6928 C120  34         mov   @cmdb.visible,tmp0
     692A A302 
0009 692C 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 692E 04E0  34         clr   @cmdb.column          ; Column = 0
     6930 A312 
0015 6932 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6934 7908 
0016 6936 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6938 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     693A 7958 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 693C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     693E 74C2 
**** **** ****     > stevie_b1.asm.1930724
0097                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
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
0011 6940 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6942 7958 
0012               
0013 6944 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6946 7462 
0014 6948 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     694A 2F30 
0015 694C 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 694E 06A0  32         bl    @pane.errline.show    ; Show error line
     6950 7B30 
0020               
0021 6952 06A0  32         bl    @pane.show_hint
     6954 7696 
0022 6956 1C00                   byte pane.botrow-1,0
0023 6958 3950                   data txt.io.nofile
0024               
0025 695A 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 695C 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 695E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6960 A326 
0031               
0032 6962 06A0  32         bl    @cpym2m
     6964 24A2 
0033 6966 A326                   data cmdb.cmdlen,heap.top,80
     6968 E000 
     696A 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 696C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     696E E000 
0039 6970 C804  38         mov   tmp0,@parm1
     6972 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 6974 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6976 E000 
0045 6978 C804  38         mov   tmp0,@parm1
     697A 2F20 
0046               
0047 697C 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     697E 7D30 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 6980 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6982 63E0 
**** **** ****     > stevie_b1.asm.1930724
0098                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
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
0011 6984 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6986 7958 
0012               
0013 6988 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     698A 7462 
0014 698C C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     698E 2F30 
0015 6990 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6992 06A0  32         bl    @pane.errline.show    ; Show error line
     6994 7B30 
0020               
0021 6996 06A0  32         bl    @pane.show_hint
     6998 7696 
0022 699A 1C00                   byte pane.botrow-1,0
0023 699C 3950                   data txt.io.nofile
0024               
0025 699E 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 69A0 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 69A2 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69A4 A326 
0031               
0032 69A6 06A0  32         bl    @cpym2m
     69A8 24A2 
0033 69AA A326                   data cmdb.cmdlen,heap.top,80
     69AC E000 
     69AE 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 69B0 0204  20         li    tmp0,heap.top         ; 1st line in heap
     69B2 E000 
0039 69B4 C804  38         mov   tmp0,@parm1
     69B6 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 69B8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     69BA A20E 
     69BC 2022 
0044 69BE 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; Yes, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 69C0 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     69C2 A20C 
     69C4 2F22 
0050 69C6 0620  34         dec   @parm2                ; /
     69C8 2F22 
0051               
0052 69CA C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     69CC A20E 
     69CE 2F24 
0053               
0054 69D0 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 69D2 04E0  34         clr   @parm2                ; First line to save
     69D4 2F22 
0060 69D6 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     69D8 A204 
     69DA 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 69DC 06A0  32         bl    @fm.savefile          ; Save DV80 file
     69DE 7D56 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 69E0 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     69E2 63E0 
**** **** ****     > stevie_b1.asm.1930724
0099                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0020 69E4 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     69E6 A206 
0021 69E8 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     69EA 76C8 
0022 69EC 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     69EE 7430 
0023 69F0 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     69F2 A324 
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 69F4 0284  22         ci    tmp0,>2000
     69F6 2000 
0028 69F8 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 69FA 0284  22         ci    tmp0,>7fff
     69FC 7FFF 
0031 69FE 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6A00 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6A02 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6A04 FFCE 
0040 6A06 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A08 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6A0A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A0C 74C2 
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * edkey.action.cmdb.fastmode.toggle
0052               * Toggle fastmode on/off
0053               ***************************************************************
0054               * b   @edkey.action.cmdb.proceed
0055               *--------------------------------------------------------------
0056               * INPUT
0057               * none
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * none
0061               ********|*****|*********************|**************************
0062               edkey.action.cmdb.fastmode.toggle:
0063 6A0E 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6A10 7D7A 
0064 6A12 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6A14 A318 
0065 6A16 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6A18 74C2 
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
0086 6A1A 06A0  32         bl    @hchar
     6A1C 278A 
0087 6A1E 0000                   byte 0,0,32,80*2
     6A20 20A0 
0088 6A22 FFFF                   data EOL
0089 6A24 1000  14         jmp   edkey.action.cmdb.close.dialog
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
0108 6A26 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6A28 A31A 
0109 6A2A 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A2C 76C8 
0110 6A2E 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A30 7958 
0111 6A32 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6A34 A118 
0112                       ;-------------------------------------------------------
0113                       ; Exit
0114                       ;-------------------------------------------------------
0115               edkey.action.cmdb.close.dialog.exit:
0116 6A36 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A38 74C2 
**** **** ****     > stevie_b1.asm.1930724
0100                       ;-----------------------------------------------------------------------
0101                       ; Logic for Framebuffer (1)
0102                       ;-----------------------------------------------------------------------
0103                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 6A3A 0649  14         dect  stack
0025 6A3C C64B  30         mov   r11,*stack            ; Save return address
0026 6A3E 0649  14         dect  stack
0027 6A40 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6A42 C120  34         mov   @parm1,tmp0
     6A44 2F20 
0032 6A46 A120  34         a     @fb.topline,tmp0
     6A48 A104 
0033 6A4A C804  38         mov   tmp0,@outparm1
     6A4C 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6A4E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6A50 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6A52 045B  20         b     *r11                  ; Return to caller
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
0068 6A54 0649  14         dect  stack
0069 6A56 C64B  30         mov   r11,*stack            ; Save return address
0070 6A58 0649  14         dect  stack
0071 6A5A C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A5C 0649  14         dect  stack
0073 6A5E C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A60 C120  34         mov   @fb.row,tmp0
     6A62 A106 
0078 6A64 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A66 A10E 
0079 6A68 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6A6A A10C 
0080 6A6C A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6A6E A100 
0081 6A70 C805  38         mov   tmp1,@fb.current
     6A72 A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6A74 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6A76 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6A78 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6A7A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0104                       copy  "fb.get.firstnonblank.asm"
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
0015 6A7C 0649  14         dect  stack
0016 6A7E C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6A80 04E0  34         clr   @fb.column
     6A82 A10C 
0021 6A84 06A0  32         bl    @fb.calc_pointer
     6A86 6A54 
0022 6A88 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6A8A 6FE6 
0023 6A8C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6A8E A108 
0024 6A90 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6A92 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6A94 A102 
0027 6A96 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6A98 D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6A9A 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6A9C 0285  22         ci    tmp1,>2000            ; Whitespace?
     6A9E 2000 
0036 6AA0 1503  14         jgt   fb.get.firstnonblank.match
0037 6AA2 0606  14         dec   tmp2                  ; Counter--
0038 6AA4 16F9  14         jne   fb.get.firstnonblank.loop
0039 6AA6 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6AA8 6120  34         s     @fb.current,tmp0      ; Calculate column
     6AAA A102 
0045 6AAC 0604  14         dec   tmp0
0046 6AAE C804  38         mov   tmp0,@outparm1        ; Save column
     6AB0 2F30 
0047 6AB2 D805  38         movb  tmp1,@outparm2        ; Save character
     6AB4 2F32 
0048 6AB6 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6AB8 04E0  34         clr   @outparm1             ; X=0
     6ABA 2F30 
0054 6ABC 04E0  34         clr   @outparm2             ; Null
     6ABE 2F32 
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6AC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6AC2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0105                                                   ; Get column of first non-blank character
0106                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6AC4 0649  14         dect  stack
0021 6AC6 C64B  30         mov   r11,*stack            ; Push return address
0022 6AC8 0649  14         dect  stack
0023 6ACA C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6ACC 0649  14         dect  stack
0025 6ACE C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6AD0 0649  14         dect  stack
0027 6AD2 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6AD4 C820  54         mov   @parm1,@fb.topline
     6AD6 2F20 
     6AD8 A104 
0032 6ADA 04E0  34         clr   @parm2                ; Target row in frame buffer
     6ADC 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6ADE 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6AE0 2F20 
     6AE2 A204 
0037 6AE4 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6AE6 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6AE8 6EE8 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6AEA 05A0  34         inc   @parm1                ; Next line in editor buffer
     6AEC 2F20 
0048 6AEE 05A0  34         inc   @parm2                ; Next row in frame buffer
     6AF0 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6AF2 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6AF4 2F20 
     6AF6 A204 
0053 6AF8 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6AFA 8820  54         c     @parm2,@fb.scrrows
     6AFC 2F22 
     6AFE A11A 
0056 6B00 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6B02 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6B04 C120  34         mov   @parm2,tmp0           ; Current row
     6B06 2F22 
0064 6B08 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6B0A A11A 
0065 6B0C 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6B0E 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6B10 A10E 
0067               
0068 6B12 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6B14 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6B16 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6B18 A10E 
0072 6B1A A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6B1C A100 
0073               
0074 6B1E C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6B20 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6B22 06A0  32         bl    @xfilm                ; \ Fill memory
     6B24 2240 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6B26 0720  34         seto  @fb.dirty             ; Refresh screen
     6B28 A116 
0086 6B2A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6B2C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6B2E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6B30 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6B32 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0107                       copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT
**** **** ****     > fb.vdpdump.asm
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
0021 6B34 0649  14         dect  stack
0022 6B36 C64B  30         mov   r11,*stack            ; Save return address
0023 6B38 0649  14         dect  stack
0024 6B3A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6B3C 0649  14         dect  stack
0026 6B3E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6B40 0649  14         dect  stack
0028 6B42 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Assert
0031                       ;------------------------------------------------------
0032 6B44 C160  34         mov   @parm1,tmp1
     6B46 2F20 
0033 6B48 0285  22         ci    tmp1,80*30
     6B4A 0960 
0034 6B4C 1204  14         jle   !
0035                       ;------------------------------------------------------
0036                       ; Crash the system
0037                       ;------------------------------------------------------
0038 6B4E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B50 FFCE 
0039 6B52 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B54 2026 
0040                       ;------------------------------------------------------
0041                       ; Setup start position in VDP memory
0042                       ;------------------------------------------------------
0043 6B56 0204  20 !       li    tmp0,vdp.fb.toprow.sit
     6B58 0050 
0044                                                   ; VDP target address (Xth line on screen!)
0045 6B5A C1A0  34         mov   @tv.ruler.visible,tmp2
     6B5C A010 
0046                                                   ; Is ruler visible on screen?
0047 6B5E 1302  14         jeq   fb.vdpdump.calc       ; No, continue with calculation
0048 6B60 A120  34         a     @fb.colsline,tmp0     ; Yes, add 2nd line offset
     6B62 A10E 
0049                       ;------------------------------------------------------
0050                       ; Refresh VDP content with framebuffer
0051                       ;------------------------------------------------------
0052               fb.vdpdump.calc:
0053 6B64 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * number of rows in parm1
     6B66 A10E 
0054                                                   ; 16 bit part is in tmp2!
0055 6B68 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     6B6A A100 
0056               
0057 6B6C 0286  22         ci    tmp2,0                ; \ Exit early if nothing to copy
     6B6E 0000 
0058 6B70 1304  14         jeq   fb.vdpdump.exit       ; /
0059               
0060 6B72 06A0  32         bl    @xpym2v               ; Copy to VDP
     6B74 2454 
0061                                                   ; \ i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = RAM source address
0063                                                   ; / i  tmp2 = Bytes to copy
0064               
0065 6B76 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     6B78 A116 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               fb.vdpdump.exit:
0070 6B7A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0071 6B7C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0072 6B7E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0073 6B80 C2F9  30         mov   *stack+,r11           ; Pop r11
0074 6B82 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0108                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6B84 0649  14         dect  stack
0022 6B86 C64B  30         mov   r11,*stack            ; Save return address
0023 6B88 0649  14         dect  stack
0024 6B8A C660  46         mov   @parm1,*stack         ; Push @parm1
     6B8C 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6B8E C820  54         mov   @fb.topline,@parm1
     6B90 A104 
     6B92 2F20 
0029 6B94 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6B96 6AC4 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6B98 0720  34         seto  @parm1                ; Skip Asserts
     6B9A 2F20 
0035 6B9C 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6B9E 7E0A 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6BA0 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6BA2 A018 
     6BA4 2F20 
0042 6BA6 06A0  32         bl    @pane.action.colorscheme.statlines
     6BA8 78A4 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6BAA 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6BAC A118 
0050               
0051 6BAE 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6BB0 76C8 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6BB2 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6BB4 2F20 
0057 6BB6 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6BB8 2F20 
     6BBA 832A 
0058 6BBC C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6BBE 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1930724
0109                       ;-----------------------------------------------------------------------
0110                       ; Logic for Index management
0111                       ;-----------------------------------------------------------------------
0112                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6BC0 0649  14         dect  stack
0023 6BC2 C64B  30         mov   r11,*stack            ; Save return address
0024 6BC4 0649  14         dect  stack
0025 6BC6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6BC8 0649  14         dect  stack
0027 6BCA C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6BCC C120  34         mov   @parm1,tmp0           ; Get line number
     6BCE 2F20 
0032 6BD0 C160  34         mov   @parm2,tmp1           ; Get pointer
     6BD2 2F22 
0033 6BD4 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6BD6 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6BD8 0FFF 
0039 6BDA 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6BDC 06E0  34         swpb  @parm3
     6BDE 2F24 
0044 6BE0 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6BE2 2F24 
0045 6BE4 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6BE6 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6BE8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BEA 318C 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6BEC C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6BEE 2F30 
0056 6BF0 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6BF2 B000 
0057 6BF4 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6BF6 2F30 
0058 6BF8 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6BFA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BFC 318C 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6BFE C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C00 2F30 
0068 6C02 04E4  34         clr   @idx.top(tmp0)        ; /
     6C04 B000 
0069 6C06 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C08 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C0A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C0C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C0E C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C10 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0113                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6C12 0649  14         dect  stack
0022 6C14 C64B  30         mov   r11,*stack            ; Save return address
0023 6C16 0649  14         dect  stack
0024 6C18 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C1A 0649  14         dect  stack
0026 6C1C C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C1E 0649  14         dect  stack
0028 6C20 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C22 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C24 2F20 
0033               
0034 6C26 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C28 318C 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C2A C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C2C 2F30 
0039 6C2E C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6C30 B000 
0040               
0041 6C32 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6C34 C185  18         mov   tmp1,tmp2             ; \
0047 6C36 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6C38 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6C3A 00FF 
0052 6C3C 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6C3E 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6C40 C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6C42 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6C44 2F30 
0059 6C46 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6C48 2F32 
0060 6C4A 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6C4C 04E0  34         clr   @outparm1
     6C4E 2F30 
0066 6C50 04E0  34         clr   @outparm2
     6C52 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6C54 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6C56 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6C58 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6C5A C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6C5C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0114                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6C5E 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C60 B000 
0018 6C62 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6C64 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6C66 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6C68 0606  14         dec   tmp2                  ; tmp2--
0026 6C6A 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6C6C 045B  20         b     *r11                  ; Return to caller
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
0046 6C6E 0649  14         dect  stack
0047 6C70 C64B  30         mov   r11,*stack            ; Save return address
0048 6C72 0649  14         dect  stack
0049 6C74 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6C76 0649  14         dect  stack
0051 6C78 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6C7A 0649  14         dect  stack
0053 6C7C C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6C7E 0649  14         dect  stack
0055 6C80 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6C82 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C84 2F20 
0060               
0061 6C86 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C88 318C 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6C8A C120  34         mov   @outparm1,tmp0        ; Index offset
     6C8C 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6C8E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6C90 2F22 
0070 6C92 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6C94 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6C96 2F20 
0074 6C98 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6C9A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C9C B000 
0081 6C9E 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6CA0 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6CA2 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6CA4 2F22 
0088 6CA6 0287  22         ci    tmp3,2048
     6CA8 0800 
0089 6CAA 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6CAC 06A0  32         bl    @_idx.sams.mapcolumn.on
     6CAE 311E 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6CB0 C120  34         mov   @parm1,tmp0           ; Restore line number
     6CB2 2F20 
0103 6CB4 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6CB6 06A0  32         bl    @_idx.entry.delete.reorg
     6CB8 6C5E 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6CBA 06A0  32         bl    @_idx.sams.mapcolumn.off
     6CBC 3152 
0111                                                   ; Restore memory window layout
0112               
0113 6CBE 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6CC0 06A0  32         bl    @_idx.entry.delete.reorg
     6CC2 6C5E 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6CC4 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6CC6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6CC8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6CCA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6CCC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6CCE C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6CD0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0115                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 6CD2 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6CD4 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6CD6 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6CD8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CDA FFCE 
0026 6CDC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CDE 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6CE0 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6CE2 B000 
0031 6CE4 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6CE6 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6CE8 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6CEA C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6CEC 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6CEE 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6CF0 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6CF2 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6CF4 AFFE 
0042 6CF6 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6CF8 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6CFA 0644  14         dect  tmp0                  ; Move pointer up
0050 6CFC 0645  14         dect  tmp1                  ; Move pointer up
0051 6CFE 0606  14         dec   tmp2                  ; Next index entry
0052 6D00 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D02 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D04 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D06 045B  20         b     *r11                  ; Return to caller
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
0082 6D08 0649  14         dect  stack
0083 6D0A C64B  30         mov   r11,*stack            ; Save return address
0084 6D0C 0649  14         dect  stack
0085 6D0E C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D10 0649  14         dect  stack
0087 6D12 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D14 0649  14         dect  stack
0089 6D16 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D18 0649  14         dect  stack
0091 6D1A C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D1C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D1E 2F22 
0096 6D20 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D22 2F20 
0097 6D24 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D26 C1E0  34         mov   @parm2,tmp3
     6D28 2F22 
0104 6D2A 0287  22         ci    tmp3,2048
     6D2C 0800 
0105 6D2E 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6D30 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D32 311E 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6D34 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D36 2F22 
0117 6D38 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6D3A 06A0  32         bl    @_idx.entry.insert.reorg
     6D3C 6CD2 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6D3E 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D40 3152 
0125                                                   ; Restore memory window layout
0126               
0127 6D42 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6D44 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D46 2F22 
0133               
0134 6D48 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D4A 318C 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6D4C C120  34         mov   @outparm1,tmp0        ; Index offset
     6D4E 2F30 
0139               
0140 6D50 06A0  32         bl    @_idx.entry.insert.reorg
     6D52 6CD2 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6D54 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6D56 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6D58 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6D5A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6D5C C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6D5E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0116                       ;-----------------------------------------------------------------------
0117                       ; Logic for Editor Buffer
0118                       ;-----------------------------------------------------------------------
0119                       copy  "edb.utils.asm"          ; Editor buffer utilities
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
0020 6D60 0649  14         dect  stack
0021 6D62 C64B  30         mov   r11,*stack            ; Save return address
0022 6D64 0649  14         dect  stack
0023 6D66 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6D68 0649  14         dect  stack
0025 6D6A C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6D6C C120  34         mov   @edb.next_free.ptr,tmp0
     6D6E A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6D70 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6D72 0FFF 
0035 6D74 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6D76 0052 
0036 6D78 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D7A 0FF0 
0037 6D7C 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6D7E 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6D80 A218 
0043 6D82 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6D84 A200 
     6D86 A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6D88 C120  34         mov   @edb.sams.hipage,tmp0
     6D8A A218 
0050 6D8C C160  34         mov   @edb.top.ptr,tmp1
     6D8E A200 
0051 6D90 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D92 253E 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6D94 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6D96 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D98 FFCE 
0061 6D9A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D9C 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6D9E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6DA0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6DA2 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6DA4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0120                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6DA6 0649  14         dect  stack
0022 6DA8 C64B  30         mov   r11,*stack            ; Push return address
0023 6DAA 0649  14         dect  stack
0024 6DAC C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6DAE 0649  14         dect  stack
0026 6DB0 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6DB2 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6DB4 A204 
0031 6DB6 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6DB8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DBA FFCE 
0037 6DBC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DBE 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6DC0 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6DC2 2F20 
0043               
0044 6DC4 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6DC6 6C12 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6DC8 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6DCA 2F32 
0050 6DCC C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6DCE 2F30 
0051 6DD0 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6DD2 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6DD4 A008 
0057 6DD6 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6DD8 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6DDA 253E 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6DDC C820  54         mov   @outparm2,@tv.sams.c000
     6DDE 2F32 
     6DE0 A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6DE2 C820  54         mov   @outparm2,@edb.sams.page
     6DE4 2F32 
     6DE6 A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6DE8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6DEA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6DEC C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6DEE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0121                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6DF0 0649  14         dect  stack
0028 6DF2 C64B  30         mov   r11,*stack            ; Save return address
0029 6DF4 0649  14         dect  stack
0030 6DF6 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6DF8 0649  14         dect  stack
0032 6DFA C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6DFC 0649  14         dect  stack
0034 6DFE C646  30         mov   tmp2,*stack           ; Push tmp2
0035 6E00 0649  14         dect  stack
0036 6E02 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 6E04 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E06 A10C 
     6E08 2F6A 
0041 6E0A 04E0  34         clr   @fb.column
     6E0C A10C 
0042 6E0E 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E10 6A54 
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 6E12 04C4  14         clr   tmp0                  ; Counter
0047 6E14 04C7  14         clr   tmp3                  ; Counter for whitespace
0048 6E16 C160  34         mov   @fb.current,tmp1      ; Get position
     6E18 A102 
0049 6E1A C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E1C 2F6C 
0050                       ;------------------------------------------------------
0051                       ; Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 6E1E D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 6E20 0986  56         srl   tmp2,8                ; Right justify
0056 6E22 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 6E24 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 6E26 0286  22         ci    tmp2,32               ; Was it a space character?
     6E28 0020 
0063 6E2A 1301  14         jeq   edb.line.pack.fb.check80
0064 6E2C C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 6E2E 0284  22         ci    tmp0,colrow
     6E30 0050 
0070 6E32 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 6E34 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 6E36 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E38 FFCE 
0078 6E3A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E3C 2026 
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 6E3E 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 6E40 1103  14         jlt   edb.line.pack.fb.rtrim
0085 6E42 C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     6E44 2F6E 
0086 6E46 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 6E48 C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     6E4A 2F6E 
0092               
0093 6E4C 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 6E4E C184  18         mov   tmp0,tmp2             ; \
0096 6E50 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 6E52 0586  14         inc   tmp2                  ; /
0098               
0099 6E54 C107  18         mov   tmp3,tmp0             ; \
0100 6E56 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     6E58 2F6C 
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 6E5A DD05  32         movb  tmp1,*tmp0+
0104 6E5C 0606  14         dec   tmp2
0105 6E5E 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 6E60 06A0  32 !       bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6E62 6D60 
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; Step 2: Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 6E64 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6E66 A104 
     6E68 2F20 
0117 6E6A A820  54         a     @fb.row,@parm1        ; /
     6E6C A106 
     6E6E 2F20 
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 6E70 C820  54         mov   @edb.next_free.ptr,@parm2
     6E72 A208 
     6E74 2F22 
0123                                                   ; Pointer to new line
0124 6E76 C820  54         mov   @edb.sams.hipage,@parm3
     6E78 A218 
     6E7A 2F24 
0125                                                   ; SAMS page to use
0126               
0127 6E7C 06A0  32         bl    @idx.entry.update     ; Update index
     6E7E 6BC0 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 6E80 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6E82 2F6C 
0136 6E84 C160  34         mov   @edb.next_free.ptr,tmp1
     6E86 A208 
0137                                                   ; Address of line in editor buffer
0138               
0139 6E88 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6E8A A208 
0140               
0141 6E8C C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6E8E 2F6E 
0142 6E90 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 6E92 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 6E94 0286  22         ci    tmp2,2
     6E96 0002 
0150 6E98 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 6E9A DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 6E9C DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 6E9E 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 6EA0 0286  22         ci    tmp2,1
     6EA2 0001 
0157 6EA4 1602  14         jne   edb.line.pack.fb.copyline.block
0158 6EA6 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 6EA8 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 6EAA 06A0  32         bl    @xpym2m               ; Copy memory block
     6EAC 24A8 
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 6EAE A820  54         a     @rambuf+4,@edb.next_free.ptr
     6EB0 2F6E 
     6EB2 A208 
0171                                                      ; Add length of line
0172               
0173 6EB4 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6EB6 A208 
0174 6EB8 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 6EBA 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6EBC 000F 
0176 6EBE A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6EC0 A208 
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 6EC2 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6EC4 2F6A 
     6EC6 A10C 
0182               
0183 6EC8 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6ECA A218 
     6ECC A216 
0184 6ECE 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 6ED0 C120  34         mov   @edb.sams.page,tmp0
     6ED2 A216 
0187 6ED4 C160  34         mov   @edb.top.ptr,tmp1
     6ED6 A200 
0188 6ED8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6EDA 253E 
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 6EDC C1B9  30         mov   *stack+,tmp2          ; Pop tmp3
0196 6EDE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 6EE0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 6EE2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 6EE4 C2F9  30         mov   *stack+,r11           ; Pop R11
0200 6EE6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0122                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0028 6EE8 0649  14         dect  stack
0029 6EEA C64B  30         mov   r11,*stack            ; Save return address
0030 6EEC 0649  14         dect  stack
0031 6EEE C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6EF0 0649  14         dect  stack
0033 6EF2 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6EF4 0649  14         dect  stack
0035 6EF6 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6EF8 C820  54         mov   @parm1,@rambuf
     6EFA 2F20 
     6EFC 2F6A 
0040 6EFE C820  54         mov   @parm2,@rambuf+2
     6F00 2F22 
     6F02 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6F04 C120  34         mov   @fb.colsline,tmp0
     6F06 A10E 
0045 6F08 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6F0A 2F22 
0046 6F0C C1A0  34         mov   @fb.top.ptr,tmp2
     6F0E A100 
0047 6F10 A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6F12 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F14 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6F16 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6F18 2F20 
     6F1A A204 
0053 6F1C 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6F1E 04E0  34         clr   @rambuf+8             ; Set length=0
     6F20 2F72 
0056 6F22 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6F24 C120  34 !       mov   @parm1,tmp0
     6F26 2F20 
0061 6F28 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F2A 6DA6 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6F2C C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F2E 2F30 
0069 6F30 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6F32 04E0  34         clr   @rambuf+8             ; Set length=0
     6F34 2F72 
0073 6F36 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6F38 C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6F3A C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6F3C 2F6E 
0080 6F3E C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6F40 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6F42 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6F44 0050 
0085                                                   ; /
0086 6F46 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6F48 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F4A FFCE 
0091 6F4C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F4E 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6F50 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6F52 2F70 
0097 6F54 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6F56 2F72 
0098               
0099 6F58 04C5  14         clr   tmp1                  ; Fill with >00
0100 6F5A C1A0  34         mov   @fb.colsline,tmp2
     6F5C A10E 
0101 6F5E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6F60 2F72 
0102 6F62 0586  14         inc   tmp2
0103               
0104 6F64 06A0  32         bl    @xfilm                ; Fill CPU memory
     6F66 2240 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6F68 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6F6A 2F72 
0113 6F6C 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6F6E C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6F70 2F6E 
0116 6F72 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6F74 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6F76 0286  22         ci    tmp2,80               ; Check line length
     6F78 0050 
0122 6F7A 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6F7C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F7E FFCE 
0127 6F80 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F82 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6F84 C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6F86 2F30 
0133               
0134 6F88 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6F8A 24A8 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6F8C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6F8E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6F90 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 6F92 C2F9  30         mov   *stack+,r11           ; Pop r11
0146 6F94 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0123                       copy  "edb.line.getlen.asm"    ; Get line length
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
0021 6F96 0649  14         dect  stack
0022 6F98 C64B  30         mov   r11,*stack            ; Push return address
0023 6F9A 0649  14         dect  stack
0024 6F9C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6F9E 0649  14         dect  stack
0026 6FA0 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6FA2 04E0  34         clr   @outparm1             ; Reset length
     6FA4 2F30 
0031 6FA6 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6FA8 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 6FAA C120  34         mov   @parm1,tmp0           ; \
     6FAC 2F20 
0036 6FAE 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 6FB0 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     6FB2 A204 
0039 6FB4 1101  14         jlt   !                     ; No, continue processing
0040 6FB6 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 6FB8 C120  34 !       mov   @parm1,tmp0           ; Get line
     6FBA 2F20 
0046               
0047 6FBC 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6FBE 6DA6 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 6FC0 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6FC2 2F30 
0053 6FC4 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 6FC6 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 6FC8 C805  38         mov   tmp1,@outparm1        ; Save length
     6FCA 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 6FCC 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6FCE 0050 
0064 6FD0 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 6FD2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FD4 FFCE 
0070 6FD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FD8 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 6FDA 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     6FDC 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 6FDE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 6FE0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 6FE2 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 6FE4 045B  20         b     *r11                  ; Return to caller
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
0103 6FE6 0649  14         dect  stack
0104 6FE8 C64B  30         mov   r11,*stack            ; Save return address
0105 6FEA 0649  14         dect  stack
0106 6FEC C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 6FEE C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6FF0 A104 
0111 6FF2 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6FF4 A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 6FF6 C804  38         mov   tmp0,@parm1
     6FF8 2F20 
0116 6FFA 06A0  32         bl    @edb.line.getlength
     6FFC 6F96 
0117 6FFE C820  54         mov   @outparm1,@fb.row.length
     7000 2F30 
     7002 A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 7004 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 7006 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 7008 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0124                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 700A 0649  14         dect  stack
0032 700C C64B  30         mov   r11,*stack            ; Save return address
0033 700E 0649  14         dect  stack
0034 7010 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 7012 0649  14         dect  stack
0036 7014 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 7016 0649  14         dect  stack
0038 7018 C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 701A 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     701C 2F20 
     701E A204 
0043 7020 1204  14         jle   !
0044 7022 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7024 FFCE 
0045 7026 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7028 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 702A C120  34 !       mov   @parm2,tmp0           ; Get target line number
     702C 2F22 
0050 702E 0604  14         dec   tmp0                  ; Base 0
0051 7030 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     7032 2F6C 
0052 7034 04E0  34         clr   @rambuf               ; Set source line length=0
     7036 2F6A 
0053 7038 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     703A 2F6E 
0054 703C 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     703E 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 7040 C120  34         mov   @parm1,tmp0           ; Get source line number
     7042 2F20 
0059 7044 0604  14         dec   tmp0                  ; Base 0
0060               
0061 7046 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7048 6DA6 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 704A C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     704C 2F30 
0069 704E 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 7050 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 7052 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 7054 C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     7056 2F6A 
0077 7058 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     705A 2F6A 
0078 705C C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     705E 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 7060 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     7062 0050 
0083 7064 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 7066 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7068 FFCE 
0088 706A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     706C 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 706E A820  54         a     @w$1000,@edb.top.ptr
     7070 201A 
     7072 A200 
0094 7074 A820  54         a     @w$1000,@edb.next_free.ptr
     7076 201A 
     7078 A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 707A 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     707C 6D60 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 707E C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     7080 2F6E 
0111 7082 C160  34         mov   @edb.next_free.ptr,tmp1
     7084 A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 7086 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     7088 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 708A 06A0  32         bl    @xpym2m               ; Copy memory block
     708C 24A8 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 708E 6820  54         s     @w$1000,@edb.top.ptr
     7090 201A 
     7092 A200 
0127 7094 6820  54         s     @w$1000,@edb.next_free.ptr
     7096 201A 
     7098 A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 709A C820  54         mov   @edb.next_free.ptr,@rambuf+6
     709C A208 
     709E 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 70A0 C120  34         mov   @edb.sams.page,tmp0
     70A2 A216 
0138 70A4 C160  34         mov   @edb.top.ptr,tmp1
     70A6 A200 
0139 70A8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70AA 253E 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 70AC C120  34         mov   @tv.sams.d000,tmp0
     70AE A00A 
0146 70B0 0205  20         li    tmp1,>d000
     70B2 D000 
0147 70B4 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70B6 253E 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 70B8 A820  54         a     @rambuf,@edb.next_free.ptr
     70BA 2F6A 
     70BC A208 
0154                                                      ; Add length of line
0155               
0156 70BE C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     70C0 A208 
0157 70C2 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 70C4 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     70C6 000F 
0159 70C8 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     70CA A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 70CC C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     70CE 2F6C 
     70D0 2F20 
0165 70D2 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     70D4 2F70 
     70D6 2F22 
0166 70D8 C820  54         mov   @edb.sams.hipage,@parm3
     70DA A218 
     70DC 2F24 
0167                                                   ; SAMS page to use
0168               
0169 70DE 06A0  32         bl    @idx.entry.update     ; Update index
     70E0 6BC0 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 70E2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 70E4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 70E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 70E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0182 70EA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0125                       copy  "edb.line.del.asm"       ; Delete line
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
0024 70EC 0649  14         dect  stack
0025 70EE C64B  30         mov   r11,*stack            ; Save return address
0026 70F0 0649  14         dect  stack
0027 70F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 70F4 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     70F6 2F20 
     70F8 A204 
0032 70FA 1204  14         jle   !
0033 70FC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70FE FFCE 
0034 7100 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7102 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 7104 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7106 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 7108 C120  34          mov   @edb.lines,tmp0      ; \
     710A A204 
0043 710C 0284  22          ci    tmp0,1               ; | Only single line?
     710E 0001 
0044 7110 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 7112 0620  34         dec   @parm1                ; Base 0
     7114 2F20 
0049 7116 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7118 A204 
     711A 2F22 
0050               
0051 711C 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     711E 6C6E 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 7120 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7122 A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 7124 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7126 A20C 
     7128 2022 
0061 712A 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 712C 8820  54         c     @parm1,@edb.block.m1  ; \
     712E 2F20 
     7130 A20C 
0064 7132 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 7134 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 7136 8820  54         c     @edb.block.m1,@w$0001 ; \
     7138 A20C 
     713A 2002 
0068 713C 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 713E 0620  34         dec   @edb.block.m1         ; M1--
     7140 A20C 
0071 7142 0720  34         seto  @fb.colorize          ; Set colorize flag
     7144 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 7146 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     7148 A20E 
     714A 2022 
0077 714C 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 714E 8820  54         c     @parm1,@edb.block.m2  ; \
     7150 2F20 
     7152 A20E 
0080 7154 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 7156 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 7158 8820  54         c     @edb.block.m2,@w$0001 ; \
     715A A20E 
     715C 2002 
0084 715E 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 7160 0620  34         dec   @edb.block.m2         ; M2--
     7162 A20E 
0087 7164 0720  34         seto  @fb.colorize          ; Set colorize flag
     7166 A110 
0088 7168 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 716A 04E0  34         clr   @parm1                ; 1st line
     716C 2F20 
0094 716E 04E0  34         clr   @parm2                ; 1st line
     7170 2F22 
0095               
0096 7172 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7174 6C6E 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 7176 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 7178 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 717A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0126                       copy  "edb.block.mark.asm"     ; Mark code block
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
0020 717C 0649  14         dect  stack
0021 717E C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 7180 C820  54         mov   @fb.row,@parm1
     7182 A106 
     7184 2F20 
0026 7186 06A0  32         bl    @fb.row2line          ; Row to editor line
     7188 6A3A 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 718A 05A0  34         inc   @outparm1             ; Add base 1
     718C 2F30 
0032               
0033 718E C820  54         mov   @outparm1,@edb.block.m1
     7190 2F30 
     7192 A20C 
0034                                                   ; Set block marker M1
0035 7194 0720  34         seto  @fb.colorize          ; Set colorize flag
     7196 A110 
0036 7198 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     719A A116 
0037 719C 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     719E A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 71A0 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 71A2 045B  20         b     *r11                  ; Return to caller
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
0062 71A4 0649  14         dect  stack
0063 71A6 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 71A8 C820  54         mov   @fb.row,@parm1
     71AA A106 
     71AC 2F20 
0068 71AE 06A0  32         bl    @fb.row2line          ; Row to editor line
     71B0 6A3A 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 71B2 05A0  34         inc   @outparm1             ; Add base 1
     71B4 2F30 
0074               
0075 71B6 C820  54         mov   @outparm1,@edb.block.m2
     71B8 2F30 
     71BA A20E 
0076                                                   ; Set block marker M2
0077               
0078 71BC 0720  34         seto  @fb.colorize          ; Set colorize flag
     71BE A110 
0079 71C0 0720  34         seto  @fb.dirty             ; Trigger refresh
     71C2 A116 
0080 71C4 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71C6 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 71C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 71CA 045B  20         b     *r11                  ; Return to caller
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
0106 71CC 0649  14         dect  stack
0107 71CE C64B  30         mov   r11,*stack            ; Push return address
0108 71D0 0649  14         dect  stack
0109 71D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 71D4 0649  14         dect  stack
0111 71D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 71D8 C820  54         mov   @fb.row,@parm1
     71DA A106 
     71DC 2F20 
0116 71DE 06A0  32         bl    @fb.row2line          ; Row to editor line
     71E0 6A3A 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 71E2 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     71E4 2F30 
0122 71E6 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 71E8 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     71EA A20C 
0127 71EC 0584  14         inc   tmp0                  ; /
0128 71EE 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 71F0 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     71F2 717C 
0135 71F4 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 71F6 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     71F8 A20C 
0141 71FA 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 71FC 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     71FE 71A4 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 7200 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 7202 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 7204 C2F9  30         mov   *stack+,r11           ; Pop r11
0154 7206 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0127                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 7208 0649  14         dect  stack
0018 720A C64B  30         mov   r11,*stack            ; Push return address
0019 720C 0649  14         dect  stack
0020 720E C660  46         mov   @wyx,*stack           ; Push cursor position
     7210 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 7212 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     7214 A20C 
0025 7216 0720  34         seto  @edb.block.m2         ; /
     7218 A20E 
0026               
0027 721A 0720  34         seto  @fb.colorize          ; Set colorize flag
     721C A110 
0028 721E 0720  34         seto  @fb.dirty             ; Trigger refresh
     7220 A116 
0029 7222 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7224 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 7226 0720  34         seto  @parm1
     7228 2F20 
0034 722A 06A0  32         bl    @pane.action.colorscheme.load
     722C 7746 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 722E C820  54         mov   @tv.color,@parm1      ; Set normal color
     7230 A018 
     7232 2F20 
0042 7234 06A0  32         bl    @pane.action.colorscheme.statlines
     7236 78A4 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 7238 06A0  32         bl    @hchar
     723A 278A 
0048 723C 0034                   byte 0,52,32,18           ; Remove markers
     723E 2012 
0049 7240 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     7242 2032 
0050 7244 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 7246 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7248 832A 
0056 724A C2F9  30         mov   *stack+,r11           ; Pop r11
0057 724C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0128                       copy  "edb.block.copy.asm"     ; Copy code block
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
0027 724E 0649  14         dect  stack
0028 7250 C64B  30         mov   r11,*stack            ; Save return address
0029 7252 0649  14         dect  stack
0030 7254 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7256 0649  14         dect  stack
0032 7258 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 725A 0649  14         dect  stack
0034 725C C646  30         mov   tmp2,*stack           ; Push tmp2
0035 725E 0649  14         dect  stack
0036 7260 C660  46         mov   @parm1,*stack         ; Push parm1
     7262 2F20 
0037 7264 04E0  34         clr   @outparm1             ; No action (>0000)
     7266 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 7268 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     726A A20C 
     726C 2022 
0042 726E 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 7270 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     7272 A20E 
     7274 2022 
0045 7276 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 7278 8820  54         c     @edb.block.m1,@edb.block.m2
     727A A20C 
     727C A20E 
0048                                                   ; M1 > M2 ?
0049 727E 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 7280 C820  54         mov   @fb.row,@parm1
     7282 A106 
     7284 2F20 
0054 7286 06A0  32         bl    @fb.row2line          ; Row to editor line
     7288 6A3A 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 728A C120  34         mov   @outparm1,tmp0        ; \
     728C 2F30 
0060 728E 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 7290 C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     7292 A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 7294 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7296 2F30 
0066 7298 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 729A 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     729C 2F30 
0069 729E 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 72A0 06A0  32         bl    @cpym2m
     72A2 24A2 
0072 72A4 3972                   data txt.block.inside,tv.error.msg,53
     72A6 A02A 
     72A8 0035 
0073               
0074 72AA 06A0  32         bl    @pane.errline.show    ; Show error line
     72AC 7B30 
0075               
0076 72AE 04E0  34         clr   @outparm1             ; No action (>0000)
     72B0 2F30 
0077 72B2 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 72B4 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     72B6 A01C 
     72B8 2F20 
0082 72BA 06A0  32         bl    @pane.action.colorscheme.statlines
     72BC 78A4 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 72BE 06A0  32         bl    @hchar
     72C0 278A 
0088 72C2 1D00                   byte pane.botrow,0,32,50
     72C4 2032 
0089 72C6 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 72C8 C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 72CA 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 72CC 06A0  32         bl    @putat
     72CE 2446 
0098 72D0 1D00                   byte pane.botrow,0
0099 72D2 3556                   data txt.block.copy   ; Display "Copying block...."
0100 72D4 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 72D6 06A0  32         bl    @putat
     72D8 2446 
0104 72DA 1D00                   byte pane.botrow,0
0105 72DC 3568                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 72DE C120  34         mov   @edb.block.m1,tmp0    ; M1
     72E0 A20C 
0111 72E2 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     72E4 A20E 
0112 72E6 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 72E8 0586  14         inc   tmp2                  ; /
0114               
0115 72EA C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     72EC A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 72EE C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     72F0 2F20 
0121 72F2 0620  34         dec   @parm1                ; Base 0 offset for index required
     72F4 2F20 
0122 72F6 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72F8 A204 
     72FA 2F22 
0123               
0124 72FC 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     72FE 6D08 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 7300 8805  38         c     tmp1,@edb.block.m1
     7302 A20C 
0131 7304 1506  14         jgt   edb.block.copy.loop.docopy
0132 7306 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 7308 05A0  34         inc   @edb.block.m1         ; M1++
     730A A20C 
0135 730C 05A0  34         inc   @edb.block.m2         ; M2++
     730E A20E 
0136 7310 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 7312 C804  38         mov   tmp0,@parm1           ; Source line for copy
     7314 2F20 
0142 7316 C805  38         mov   tmp1,@parm2           ; Target line for copy
     7318 2F22 
0143               
0144 731A 06A0  32         bl    @edb.line.copy        ; Copy line
     731C 700A 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 731E 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     7320 A204 
0151 7322 0584  14         inc   tmp0                  ; Next source line
0152 7324 0585  14         inc   tmp1                  ; Next target line
0153 7326 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 7328 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 732A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     732C A206 
0159 732E 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     7330 A116 
0160 7332 0720  34         seto  @outparm1             ; Copy completed
     7334 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 7336 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7338 2F20 
0166 733A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 733C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 733E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 7340 C2F9  30         mov   *stack+,r11           ; Pop R11
0170 7342 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0129                       copy  "edb.block.del.asm"      ; Delete code block
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
0027 7344 0649  14         dect  stack
0028 7346 C64B  30         mov   r11,*stack            ; Save return address
0029 7348 0649  14         dect  stack
0030 734A C644  30         mov   tmp0,*stack           ; Push tmp0
0031 734C 0649  14         dect  stack
0032 734E C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7350 0649  14         dect  stack
0034 7352 C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 7354 04E0  34         clr   @outparm1             ; No action (>0000)
     7356 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 7358 C120  34         mov   @edb.block.m1,tmp0    ; \
     735A A20C 
0041 735C 0584  14         inc   tmp0                  ; | M1 unset?
0042 735E 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 7360 C160  34         mov   @edb.block.m2,tmp1    ; \
     7362 A20E 
0045 7364 0584  14         inc   tmp0                  ; | M2 unset?
0046 7366 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 7368 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     736A 2F20 
0051 736C 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 736E C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     7370 A01C 
     7372 2F20 
0056               
0057 7374 06A0  32         bl    @pane.action.colorscheme.statlines
     7376 78A4 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 7378 06A0  32         bl    @hchar
     737A 278A 
0063 737C 1D00                   byte pane.botrow,0,32,50
     737E 2032 
0064 7380 FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 7382 06A0  32         bl    @putat
     7384 2446 
0067 7386 1D00                   byte pane.botrow,0
0068 7388 3542                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 738A C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     738C A20C 
0074 738E 0604  14         dec   tmp0                  ; Base 0
0075               
0076 7390 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     7392 A20E 
0077 7394 0605  14         dec   tmp1                  ; Base 0
0078               
0079 7396 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     7398 2F20 
0080 739A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     739C A204 
     739E 2F22 
0081 73A0 0620  34         dec   @parm2                ; Base 0
     73A2 2F22 
0082               
0083 73A4 C185  18         mov   tmp1,tmp2             ; \
0084 73A6 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 73A8 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 73AA 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     73AC 6C6E 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 73AE 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     73B0 A204 
0095 73B2 0620  34         dec   @parm2                ; /
     73B4 2F22 
0096               
0097 73B6 0606  14         dec   tmp2
0098 73B8 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 73BA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     73BC A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 73BE 8820  54         c     @fb.topline,@edb.lines
     73C0 A104 
     73C2 A204 
0104                                                   ; Beyond editor buffer?
0105 73C4 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 73C6 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     73C8 A104 
     73CA 2F20 
0108 73CC 1002  14         jmp   edb.block.delete.fb.refresh
0109 73CE 04E0  34 !       clr   @parm1                ; Set line to start with
     73D0 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 73D2 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     73D4 6AC4 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 73D6 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     73D8 7208 
0119               
0120 73DA 0720  34         seto  @outparm1             ; Delete completed
     73DC 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 73DE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 73E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 73E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 73E4 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.1930724
0130                       ;-----------------------------------------------------------------------
0131                       ; Command buffer handling
0132                       ;-----------------------------------------------------------------------
0133                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 73E6 0649  14         dect  stack
0023 73E8 C64B  30         mov   r11,*stack            ; Save return address
0024 73EA 0649  14         dect  stack
0025 73EC C644  30         mov   tmp0,*stack           ; Push tmp0
0026 73EE 0649  14         dect  stack
0027 73F0 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 73F2 0649  14         dect  stack
0029 73F4 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 73F6 0649  14         dect  stack
0031 73F8 C660  46         mov   @wyx,*stack           ; Push cursor position
     73FA 832A 
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 73FC C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     73FE A310 
     7400 832A 
0036               
0037 7402 05A0  34         inc   @wyx                  ; X +1 for prompt
     7404 832A 
0038               
0039 7406 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7408 23FE 
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 740A 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     740C A327 
0044 740E 0206  20         li    tmp2,1*79             ; Command length
     7410 004F 
0045               
0046 7412 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     7414 2454 
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 7416 C820  54         mov   @cmdb.yxprompt,@wyx
     7418 A310 
     741A 832A 
0054 741C 06A0  32         bl    @putstr
     741E 2422 
0055 7420 39A8                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 7422 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7424 832A 
0061 7426 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 7428 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 742A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 742C C2F9  30         mov   *stack+,r11           ; Pop r11
0065 742E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0134                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 7430 0649  14         dect  stack
0023 7432 C64B  30         mov   r11,*stack            ; Save return address
0024 7434 0649  14         dect  stack
0025 7436 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7438 0649  14         dect  stack
0027 743A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 743C 0649  14         dect  stack
0029 743E C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 7440 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     7442 A326 
0034 7444 06A0  32         bl    @film                 ; Clear command
     7446 223A 
0035 7448 A327                   data  cmdb.cmd,>00,80
     744A 0000 
     744C 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 744E C120  34         mov   @cmdb.yxprompt,tmp0
     7450 A310 
0040 7452 0584  14         inc   tmp0
0041 7454 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     7456 A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 7458 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 745A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 745C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 745E C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7460 045B  20         b     *r11                  ; Return to caller
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
0075 7462 0649  14         dect  stack
0076 7464 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 7466 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     7468 2A90 
0081 746A A327                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     746C 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 746E C820  54         mov   @waux1,@outparm1     ; Save length of string
     7470 833C 
     7472 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 7474 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 7476 045B  20         b     *r11                  ; Return to caller
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
0115 7478 0649  14         dect  stack
0116 747A C64B  30         mov   r11,*stack            ; Save return address
0117 747C 0649  14         dect  stack
0118 747E C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 7480 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     7482 7462 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Assert
0125                       ;------------------------------------------------------
0126 7484 C120  34         mov   @outparm1,tmp0        ; Check length
     7486 2F30 
0127 7488 1300  14         jeq   cmdb.cmd.history.add.exit
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
0139 748A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 748C C2F9  30         mov   *stack+,r11           ; Pop r11
0141 748E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0135                       ;-----------------------------------------------------------------------
0136                       ; User hook, background tasks
0137                       ;-----------------------------------------------------------------------
0138                       copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 7490 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7492 200A 
0009 7494 1612  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 7496 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7498 833C 
     749A 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 749C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     749E 200A 
0016 74A0 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     74A2 2F40 
     74A4 2F42 
0017 74A6 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0018               *--------------------------------------------------------------
0019               * New key pressed
0020               *--------------------------------------------------------------
0021 74A8 0204  20         li    tmp0,250              ; \
     74AA 00FA 
0022 74AC 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0023 74AE 16FE  14         jne   -!                    ; /
0024 74B0 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     74B2 2F40 
     74B4 2F42 
0025 74B6 0460  28         b     @edkey.key.process    ; Process key
     74B8 60E4 
0026               *--------------------------------------------------------------
0027               * Clear keyboard buffer if no key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.clear_kbbuffer:
0030 74BA 04E0  34         clr   @keycode1
     74BC 2F40 
0031 74BE 04E0  34         clr   @keycode2
     74C0 2F42 
0032               *--------------------------------------------------------------
0033               * Delay to avoid key bouncing
0034               *--------------------------------------------------------------
0035               hook.keyscan.bounce:
0036 74C2 0204  20         li    tmp0,2000             ; Avoid key bouncing
     74C4 07D0 
0037                       ;------------------------------------------------------
0038                       ; Delay loop
0039                       ;------------------------------------------------------
0040               hook.keyscan.bounce.loop:
0041 74C6 0604  14         dec   tmp0
0042 74C8 16FE  14         jne   hook.keyscan.bounce.loop
0043 74CA 0460  28         b     @hookok               ; Return
     74CC 2D10 
0044               
**** **** ****     > stevie_b1.asm.1930724
0139                       copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 74CE 0649  14         dect  stack
0009 74D0 C64B  30         mov   r11,*stack            ; Save return address
0010 74D2 0649  14         dect  stack
0011 74D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 74D6 0649  14         dect  stack
0013 74D8 C660  46         mov   @wyx,*stack           ; Push cursor position
     74DA 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 74DC 20A0  38         coc   @wbit10,config
     74DE 200C 
0019 74E0 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 74E2 06A0  32         bl    @putat
     74E4 2446 
0024 74E6 1D4F                   byte   pane.botrow,79
0025 74E8 366A                   data   txt.alpha.up
0026 74EA 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 74EC 06A0  32         bl    @putat
     74EE 2446 
0032 74F0 1D4F                   byte   pane.botrow,79
0033 74F2 366C                   data   txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 74F4 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     74F6 A302 
0039 74F8 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 74FA C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     74FC A318 
0045 74FE 1327  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 7500 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     7502 799A 
0048 7504 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7506 A318 
0049 7508 1022  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 750A C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     750C A116 
0054 750E 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056               
0057 7510 C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     7512 A11A 
     7514 2F20 
0058 7516 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7518 6B34 
0059                                                   ; \ i  @parm1 = number of lines to dump
0060                                                   ; /
0061                       ;------------------------------------------------------
0062                       ; Color the lines in the framebuffer (TAT)
0063                       ;------------------------------------------------------
0064 751A C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     751C A110 
0065 751E 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0066               
0067 7520 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     7522 7E0A 
0068                       ;-------------------------------------------------------
0069                       ; Finished with frame buffer
0070                       ;-------------------------------------------------------
0071               task.vdp.panes.dumped:
0072 7524 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7526 A116 
0073 7528 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     752A A118 
0074                       ;-------------------------------------------------------
0075                       ; Refresh top and bottom line
0076                       ;-------------------------------------------------------
0077               task.vdp.panes.statlines:
0078 752C C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     752E A118 
0079 7530 130E  14         jeq   task.vdp.panes.exit   ; No, skip update
0080               
0081 7532 06A0  32         bl    @pane.topline         ; Draw top line
     7534 7A7E 
0082 7536 06A0  32         bl    @pane.botline         ; Draw bottom line
     7538 7BCA 
0083 753A 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     753C A118 
0084                       ;------------------------------------------------------
0085                       ; Show ruler with tab positions
0086                       ;------------------------------------------------------
0087 753E C120  34         mov   @tv.ruler.visible,tmp0
     7540 A010 
0088                                                   ; Should ruler be visible?
0089 7542 1305  14         jeq   task.vdp.panes.exit   ; No, so exit
0090               
0091 7544 06A0  32         bl    @cpym2v
     7546 244E 
0092 7548 0050                   data vdp.fb.toprow.sit
0093 754A A11E                   data fb.ruler.sit
0094 754C 0050                   data 80               ; Show ruler
0095                       ;------------------------------------------------------
0096                       ; Exit task
0097                       ;------------------------------------------------------
0098               task.vdp.panes.exit:
0099 754E C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7550 832A 
0100 7552 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0101 7554 C2F9  30         mov   *stack+,r11           ; Pop r11
0102 7556 0460  28         b     @slotok
     7558 2D8C 
**** **** ****     > stevie_b1.asm.1930724
0140                       copy  "task.vdp.cursor.sat.asm"    ; Copy cursor SAT to VDP
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 755A 0649  14         dect  stack
0009 755C C64B  30         mov   r11,*stack            ; Save return address
0010 755E 0649  14         dect  stack
0011 7560 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7562 0649  14         dect  stack
0013 7564 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7566 0649  14         dect  stack
0015 7568 C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 756A C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     756C A022 
0020               
0021 756E 0284  22         ci    tmp0,pane.focus.fb
     7570 0000 
0022 7572 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7574 0284  22         ci    tmp0,pane.focus.cmdb
     7576 0001 
0025 7578 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 757A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     757C FFCE 
0031 757E 06A0  32         bl    @cpu.crash            ; / Halt system.
     7580 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7582 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7584 A30A 
     7586 832A 
0037 7588 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     758A 2020 
0038 758C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     758E 26B8 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 7590 1006  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 7592 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7594 2020 
0048 7596 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7598 26B8 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052                       ;ai    tmp0,>0800           ; Adjust VDP cursor because of topline
0053 759A 0224  22         ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
     759C 1000 
0054                       ;------------------------------------------------------
0055                       ; Dump sprite attribute table
0056                       ;------------------------------------------------------
0057               task.vdp.copy.sat.write:
0058 759E C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     75A0 2F5A 
0059 75A2 0244  22         andi  tmp0,>ff00            ; Clear X position
     75A4 FF00 
0060 75A6 0264  22         ori   tmp0,240
     75A8 00F0 
0061 75AA C804  38         mov   tmp0,@ramsat+4        ; Set line indicator YX
     75AC 2F5E 
0062               
0063 75AE 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     75B0 244E 
0064 75B2 2180                   data sprsat,ramsat,10 ; \ i  tmp0 = VDP destination
     75B4 2F5A 
     75B6 000A 
0065                                                   ; | i  tmp1 = ROM/RAM source
0066                                                   ; / i  tmp2 = Number of bytes to write
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               task.vdp.copy.sat.exit:
0071 75B8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 75BA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 75BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 75BE C2F9  30         mov   *stack+,r11           ; Pop r11
0075 75C0 0460  28         b     @slotok               ; Exit task
     75C2 2D8C 
**** **** ****     > stevie_b1.asm.1930724
0141                       copy  "task.vdp.cursor.blink.asm"  ; Set cursor shape in VDP (blink)
**** **** ****     > task.vdp.cursor.blink.asm
0001               * FILE......: task.vdp.cursor.blink.asm
0002               * Purpose...: VDP sprite cursor shape
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 75C4 0649  14         dect  stack
0009 75C6 C64B  30         mov   r11,*stack            ; Save return address
0010 75C8 0649  14         dect  stack
0011 75CA C644  30         mov   tmp0,*stack           ; Push tmp0
0012               
0013 75CC 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     75CE A112 
0014 75D0 1303  14         jeq   task.vdp.cursor.visible
0015 75D2 04E0  34         clr   @ramsat+2             ; Hide cursor
     75D4 2F5C 
0016 75D6 1015  14         jmp   task.vdp.cursor.copy.sat
0017                                                   ; Update VDP SAT and exit task
0018               task.vdp.cursor.visible:
0019 75D8 C120  34         mov   @edb.insmode,tmp0     ; Get Editor buffer insert mode
     75DA A20A 
0020 75DC 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0021                       ;------------------------------------------------------
0022                       ; Cursor in insert mode
0023                       ;------------------------------------------------------
0024               task.vdp.cursor.visible.insert_mode:
0025 75DE C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     75E0 A022 
0026 75E2 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0027                                                   ; Framebuffer has focus
0028 75E4 0284  22         ci    tmp0,pane.focus.cmdb
     75E6 0001 
0029 75E8 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0030                       ;------------------------------------------------------
0031                       ; Editor cursor (insert mode)
0032                       ;------------------------------------------------------
0033               task.vdp.cursor.visible.insert_mode.fb:
0034 75EA 04C4  14         clr   tmp0                  ; Cursor FB insert mode
0035 75EC 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0036                       ;------------------------------------------------------
0037                       ; Command buffer cursor (insert mode)
0038                       ;------------------------------------------------------
0039               task.vdp.cursor.visible.insert_mode.cmdb:
0040 75EE 0204  20         li    tmp0,>0100            ; Cursor CMDB insert mode
     75F0 0100 
0041 75F2 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0042                       ;------------------------------------------------------
0043                       ; Cursor in overwrite mode
0044                       ;------------------------------------------------------
0045               task.vdp.cursor.visible.overwrite_mode:
0046 75F4 0204  20         li    tmp0,>0200            ; Cursor overwrite mode
     75F6 0200 
0047                       ;------------------------------------------------------
0048                       ; Set cursor shape
0049                       ;------------------------------------------------------
0050               task.vdp.cursor.visible.cursorshape:
0051 75F8 D804  38         movb  tmp0,@tv.curshape     ; Save cursor shape
     75FA A014 
0052 75FC C820  54         mov   @tv.curshape,@ramsat+2
     75FE A014 
     7600 2F5C 
0053                                                   ; Get cursor shape and color
0054                       ;------------------------------------------------------
0055                       ; Copy SAT
0056                       ;------------------------------------------------------
0057               task.vdp.cursor.copy.sat:
0058 7602 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7604 244E 
0059 7606 2180                   data sprsat,ramsat,4  ; \ i  p0 = VDP destination
     7608 2F5A 
     760A 0004 
0060                                                   ; | i  p1 = ROM/RAM source
0061                                                   ; / i  p2 = Number of bytes to write
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               task.vdp.cursor.exit:
0066 760C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 760E C2F9  30         mov   *stack+,r11           ; Pop r11
0068 7610 0460  28         b     @slotok               ; Exit task
     7612 2D8C 
**** **** ****     > stevie_b1.asm.1930724
0142                       copy  "task.oneshot.asm"           ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7614 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7616 A024 
0010 7618 1301  14         jeq   task.oneshot.exit
0011               
0012 761A 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 761C 0460  28         b     @slotok                ; Exit task
     761E 2D8C 
**** **** ****     > stevie_b1.asm.1930724
0143                       ;-----------------------------------------------------------------------
0144                       ; Screen pane utilities
0145                       ;-----------------------------------------------------------------------
0146                       copy  "pane.utils.asm"             ; Pane utility functions
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
0020 7620 0649  14         dect  stack
0021 7622 C64B  30         mov   r11,*stack            ; Push return address
0022 7624 0649  14         dect  stack
0023 7626 C660  46         mov   @wyx,*stack           ; Push cursor position
     7628 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 762A 06A0  32         bl    @hchar
     762C 278A 
0028 762E 0034                   byte 0,52,32,18
     7630 2012 
0029 7632 FFFF                   data EOL              ; Clear message
0030               
0031 7634 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7636 A024 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 7638 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     763A 832A 
0037 763C C2F9  30         mov   *stack+,r11           ; Pop R11
0038 763E 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.1930724
0147                       copy  "pane.utils.hint.asm"        ; Show hint in pane
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
0021 7640 0649  14         dect  stack
0022 7642 C64B  30         mov   r11,*stack            ; Save return address
0023 7644 0649  14         dect  stack
0024 7646 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7648 0649  14         dect  stack
0026 764A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 764C 0649  14         dect  stack
0028 764E C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7650 0649  14         dect  stack
0030 7652 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 7654 C820  54         mov   @parm1,@wyx           ; Set cursor
     7656 2F20 
     7658 832A 
0035 765A C160  34         mov   @parm2,tmp1           ; Get string to display
     765C 2F22 
0036 765E 06A0  32         bl    @xutst0               ; Display string
     7660 2424 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 7662 C120  34         mov   @parm2,tmp0
     7664 2F22 
0041 7666 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 7668 0984  56         srl   tmp0,8                ; Right justify
0043 766A C184  18         mov   tmp0,tmp2
0044 766C C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 766E 0506  16         neg   tmp2
0046 7670 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7672 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 7674 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7676 2F20 
0051 7678 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 767A C804  38         mov   tmp0,@wyx             ; / Set cursor
     767C 832A 
0053               
0054 767E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7680 23FE 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 7682 0205  20         li    tmp1,32               ; Byte to fill
     7684 0020 
0059               
0060 7686 06A0  32         bl    @xfilv                ; Clear line
     7688 2298 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 768A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 768C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 768E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 7690 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 7692 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 7694 045B  20         b     *r11                  ; Return to caller
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
0095 7696 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7698 2F20 
0096 769A C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     769C 2F22 
0097 769E 0649  14         dect  stack
0098 76A0 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 76A2 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     76A4 7640 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 76A6 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 76A8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0148                       copy  "pane.utils.cursor.asm"      ; Cursor utility functions
**** **** ****     > pane.utils.cursor.asm
0001               * FILE......: pane.utils.cursor.asm
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
0020 76AA 0649  14         dect  stack
0021 76AC C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 76AE 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     76B0 2292 
0026 76B2 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     76B4 0000 
     76B6 0008 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 76B8 06A0  32         bl    @clslot
     76BA 2DE8 
0031 76BC 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 76BE 06A0  32         bl    @clslot
     76C0 2DE8 
0034 76C2 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 76C4 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 76C6 045B  20         b     *r11                  ; Return to caller
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
0060 76C8 0649  14         dect  stack
0061 76CA C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 76CC 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     76CE 2292 
0066 76D0 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     76D2 0000 
     76D4 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0070 76D6 06A0  32         bl    @mkslot
     76D8 2DCA 
0071 76DA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     76DC 755A 
0072 76DE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     76E0 75C4 
0073 76E2 FFFF                   data eol
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077               pane.cursor.blink.exit:
0078 76E4 C2F9  30         mov   *stack+,r11           ; Pop R11
0079 76E6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0149                       copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes
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
0017 76E8 0649  14         dect  stack
0018 76EA C64B  30         mov   r11,*stack            ; Push return address
0019 76EC 0649  14         dect  stack
0020 76EE C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 76F0 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     76F2 A012 
0023 76F4 0284  22         ci    tmp0,tv.colorscheme.entries
     76F6 000A 
0024                                                   ; Last entry reached?
0025 76F8 1103  14         jlt   !
0026 76FA 0204  20         li    tmp0,1                ; Reset color scheme index
     76FC 0001 
0027 76FE 1001  14         jmp   pane.action.colorscheme.switch
0028 7700 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 7702 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7704 A012 
0034               
0035 7706 06A0  32         bl    @pane.action.colorscheme.load
     7708 7746 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 770A C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     770C 832A 
     770E 833C 
0041               
0042 7710 06A0  32         bl    @putnum
     7712 2A1A 
0043 7714 003E                   byte 0,62
0044 7716 A012                   data tv.colorscheme,rambuf,>3020
     7718 2F6A 
     771A 3020 
0045               
0046 771C 06A0  32         bl    @putat
     771E 2446 
0047 7720 0034                   byte 0,52
0048 7722 39AA                   data txt.colorscheme  ; Show color palette message
0049               
0050 7724 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     7726 833C 
     7728 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 772A 0204  20         li    tmp0,12000
     772C 2EE0 
0055 772E 0604  14 !       dec   tmp0
0056 7730 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 7732 0204  20         li    tmp0,pane.clearmsg.task.callback
     7734 7620 
0061 7736 C804  38         mov   tmp0,@tv.task.oneshot
     7738 A024 
0062               
0063 773A 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     773C 2DF6 
0064 773E 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 7740 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7742 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 7744 045B  20         b     *r11                  ; Return to caller
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
0093 7746 0649  14         dect  stack
0094 7748 C64B  30         mov   r11,*stack            ; Save return address
0095 774A 0649  14         dect  stack
0096 774C C644  30         mov   tmp0,*stack           ; Push tmp0
0097 774E 0649  14         dect  stack
0098 7750 C645  30         mov   tmp1,*stack           ; Push tmp1
0099 7752 0649  14         dect  stack
0100 7754 C646  30         mov   tmp2,*stack           ; Push tmp2
0101 7756 0649  14         dect  stack
0102 7758 C647  30         mov   tmp3,*stack           ; Push tmp3
0103 775A 0649  14         dect  stack
0104 775C C648  30         mov   tmp4,*stack           ; Push tmp4
0105 775E 0649  14         dect  stack
0106 7760 C660  46         mov   @parm1,*stack         ; Push parm1
     7762 2F20 
0107                       ;-------------------------------------------------------
0108                       ; Turn screen of
0109                       ;-------------------------------------------------------
0110 7764 C120  34         mov   @parm1,tmp0
     7766 2F20 
0111 7768 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     776A FFFF 
0112 776C 1302  14         jeq   !                     ; Yes, so skip screen off
0113 776E 06A0  32         bl    @scroff               ; Turn screen off
     7770 2656 
0114                       ;-------------------------------------------------------
0115                       ; Get FG/BG colors framebuffer text
0116                       ;-------------------------------------------------------
0117 7772 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7774 A012 
0118 7776 0604  14         dec   tmp0                  ; Internally work with base 0
0119               
0120 7778 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0121 777A 0224  22         ai    tmp0,tv.colorscheme.table
     777C 3466 
0122                                                   ; Add base for color scheme data table
0123 777E C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0124 7780 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7782 A018 
0125                       ;-------------------------------------------------------
0126                       ; Get and save cursor color
0127                       ;-------------------------------------------------------
0128 7784 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0129 7786 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     7788 00FF 
0130 778A C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     778C A016 
0131                       ;-------------------------------------------------------
0132                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0133                       ;-------------------------------------------------------
0134 778E C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0135 7790 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7792 FF00 
0136 7794 0988  56         srl   tmp4,8                ; MSB to LSB
0137               
0138 7796 C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0139 7798 C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0140 779A 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0141 779C C806  38         mov   tmp2,@tv.busycolor    ; /
     779E A01C 
0142               
0143 77A0 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     77A2 00FF 
0144 77A4 C805  38         mov   tmp1,@tv.markcolor    ; /
     77A6 A01A 
0145               
0146 77A8 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0147 77AA 0985  56         srl   tmp1,8                ; \ Right align MN and
0148 77AC C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     77AE A020 
0149                       ;-------------------------------------------------------
0150                       ; Get FG color for ruler
0151                       ;-------------------------------------------------------
0152 77B0 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0153 77B2 0245  22         andi  tmp1,>000f            ; Only keep P
     77B4 000F 
0154 77B6 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0155 77B8 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     77BA A01E 
0156                       ;-------------------------------------------------------
0157                       ; Write sprite color of line indicator to SAT
0158                       ;-------------------------------------------------------
0159 77BC C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0160 77BE 0245  22         andi  tmp1,>00f0            ; Only keep O
     77C0 00F0 
0161 77C2 0A45  56         sla   tmp1,4                ; Move O to MSB
0162 77C4 D805  38         movb  tmp1,@ramsat+7        ; Write sprite color to SAT
     77C6 2F61 
0163                       ;-------------------------------------------------------
0164                       ; Dump colors to VDP register 7 (text mode)
0165                       ;-------------------------------------------------------
0166 77C8 C147  18         mov   tmp3,tmp1             ; Get work copy
0167 77CA 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0168 77CC 0265  22         ori   tmp1,>0700
     77CE 0700 
0169 77D0 C105  18         mov   tmp1,tmp0
0170 77D2 06A0  32         bl    @putvrx               ; Write VDP register
     77D4 2338 
0171                       ;-------------------------------------------------------
0172                       ; Dump colors for frame buffer pane (TAT)
0173                       ;-------------------------------------------------------
0174 77D6 0204  20         li    tmp0,vdp.fb.toprow.tat
     77D8 1850 
0175                                                   ; VDP start address (frame buffer area)
0176 77DA C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0177 77DC 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0178 77DE 0206  20         li    tmp2,(pane.botrow-1)*80
     77E0 08C0 
0179                                                   ; Number of bytes to fill
0180 77E2 06A0  32         bl    @xfilv                ; Fill colors
     77E4 2298 
0181                                                   ; i \  tmp0 = start address
0182                                                   ; i |  tmp1 = byte to fill
0183                                                   ; i /  tmp2 = number of bytes to fill
0184                       ;-------------------------------------------------------
0185                       ; Colorize marked lines
0186                       ;-------------------------------------------------------
0187 77E6 C120  34         mov   @parm2,tmp0
     77E8 2F22 
0188 77EA 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     77EC FFFF 
0189 77EE 1304  14         jeq   pane.action.colorscheme.cmdbpane
0190               
0191 77F0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     77F2 A110 
0192 77F4 06A0  32         bl    @fb.colorlines
     77F6 7E0A 
0193                       ;-------------------------------------------------------
0194                       ; Dump colors for CMDB pane (TAT)
0195                       ;-------------------------------------------------------
0196               pane.action.colorscheme.cmdbpane:
0197 77F8 C120  34         mov   @cmdb.visible,tmp0
     77FA A302 
0198 77FC 130F  14         jeq   pane.action.colorscheme.errpane
0199                                                   ; Skip if CMDB pane is hidden
0200               
0201 77FE 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     7800 1FD0 
0202                                                   ; VDP start address (CMDB top line)
0203               
0204 7802 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     7804 A020 
0205 7806 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7808 0050 
0206 780A 06A0  32         bl    @xfilv                ; Fill colors
     780C 2298 
0207                                                   ; i \  tmp0 = start address
0208                                                   ; i |  tmp1 = byte to fill
0209                                                   ; i /  tmp2 = number of bytes to fill
0210                       ;-------------------------------------------------------
0211                       ; Dump colors for CMDB pane content (TAT)
0212                       ;-------------------------------------------------------
0213 780E 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     7810 2020 
0214                                                   ; VDP start address (CMDB top line + 1)
0215 7812 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0216 7814 0206  20         li    tmp2,3*80             ; Number of bytes to fill
     7816 00F0 
0217 7818 06A0  32         bl    @xfilv                ; Fill colors
     781A 2298 
0218                                                   ; i \  tmp0 = start address
0219                                                   ; i |  tmp1 = byte to fill
0220                                                   ; i /  tmp2 = number of bytes to fill
0221                       ;-------------------------------------------------------
0222                       ; Dump colors for error line (TAT)
0223                       ;-------------------------------------------------------
0224               pane.action.colorscheme.errpane:
0225 781C C120  34         mov   @tv.error.visible,tmp0
     781E A028 
0226 7820 130A  14         jeq   pane.action.colorscheme.statline
0227                                                   ; Skip if error line pane is hidden
0228               
0229 7822 0205  20         li    tmp1,>00f6            ; White on dark red
     7824 00F6 
0230 7826 C805  38         mov   tmp1,@parm1           ; Pass color combination
     7828 2F20 
0231               
0232 782A 0205  20         li    tmp1,pane.botrow-1    ;
     782C 001C 
0233 782E C805  38         mov   tmp1,@parm2           ; Error line on screen
     7830 2F22 
0234               
0235 7832 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7834 78BE 
0236                                                   ; \ i  @parm1 = Color combination
0237                                                   ; / i  @parm2 = Row on physical screen
0238                       ;-------------------------------------------------------
0239                       ; Dump colors for top line and bottom line (TAT)
0240                       ;-------------------------------------------------------
0241               pane.action.colorscheme.statline:
0242 7836 C160  34         mov   @tv.color,tmp1
     7838 A018 
0243 783A 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     783C 00FF 
0244 783E C805  38         mov   tmp1,@parm1           ; Set color combination
     7840 2F20 
0245               
0246               
0247 7842 04E0  34         clr   @parm2                ; Top row on screen
     7844 2F22 
0248 7846 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7848 78BE 
0249                                                   ; \ i  @parm1 = Color combination
0250                                                   ; / i  @parm2 = Row on physical screen
0251               
0252 784A 0205  20         li    tmp1,pane.botrow
     784C 001D 
0253 784E C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     7850 2F22 
0254 7852 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7854 78BE 
0255                                                   ; \ i  @parm1 = Color combination
0256                                                   ; / i  @parm2 = Row on physical screen
0257                       ;-------------------------------------------------------
0258                       ; Dump colors for ruler if visible (TAT)
0259                       ;-------------------------------------------------------
0260 7856 C160  34         mov   @tv.ruler.visible,tmp1
     7858 A010 
0261 785A 1307  14         jeq   pane.action.colorscheme.cursorcolor
0262               
0263 785C 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     785E 7DF8 
0264 7860 06A0  32         bl    @cpym2v
     7862 244E 
0265 7864 1850                   data vdp.fb.toprow.tat
0266 7866 A16E                   data fb.ruler.tat
0267 7868 0050                   data 80               ; Show ruler colors
0268                       ;-------------------------------------------------------
0269                       ; Dump cursor FG color to sprite table (SAT)
0270                       ;-------------------------------------------------------
0271               pane.action.colorscheme.cursorcolor:
0272 786A C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     786C A016 
0273               
0274 786E C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7870 A022 
0275 7872 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     7874 0000 
0276 7876 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0277                                                   ; Yes, set cursor color
0278               
0279               pane.action.colorscheme.cursorcolor.cmdb:
0280 7878 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     787A 00F0 
0281 787C 0A48  56         sla   tmp4,4                ; Move to MSB
0282 787E 1003  14         jmp   !
0283               
0284               pane.action.colorscheme.cursorcolor.fb:
0285 7880 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     7882 000F 
0286 7884 0A88  56         sla   tmp4,8                ; Move to MSB
0287               
0288 7886 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7888 2F5D 
0289 788A D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     788C A015 
0290                       ;-------------------------------------------------------
0291                       ; Exit
0292                       ;-------------------------------------------------------
0293               pane.action.colorscheme.load.exit:
0294 788E 06A0  32         bl    @scron                ; Turn screen on
     7890 265E 
0295 7892 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7894 2F20 
0296 7896 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0297 7898 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0298 789A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0299 789C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0300 789E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0301 78A0 C2F9  30         mov   *stack+,r11           ; Pop R11
0302 78A2 045B  20         b     *r11                  ; Return to caller
0303               
0304               
0305               
0306               ***************************************************************
0307               * pane.action.colorscheme.statline
0308               * Set color combination for bottom status line
0309               ***************************************************************
0310               * bl @pane.action.colorscheme.statlines
0311               *--------------------------------------------------------------
0312               * INPUT
0313               * @parm1 = Color combination to set
0314               *--------------------------------------------------------------
0315               * OUTPUT
0316               * none
0317               *--------------------------------------------------------------
0318               * Register usage
0319               * tmp0, tmp1, tmp2
0320               ********|*****|*********************|**************************
0321               pane.action.colorscheme.statlines:
0322 78A4 0649  14         dect  stack
0323 78A6 C64B  30         mov   r11,*stack            ; Save return address
0324 78A8 0649  14         dect  stack
0325 78AA C644  30         mov   tmp0,*stack           ; Push tmp0
0326                       ;------------------------------------------------------
0327                       ; Bottom line
0328                       ;------------------------------------------------------
0329 78AC 0204  20         li    tmp0,pane.botrow
     78AE 001D 
0330 78B0 C804  38         mov   tmp0,@parm2           ; Last row on screen
     78B2 2F22 
0331 78B4 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78B6 78BE 
0332                                                   ; \ i  @parm1 = Color combination
0333                                                   ; / i  @parm2 = Row on physical screen
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337               pane.action.colorscheme.statlines.exit:
0338 78B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0339 78BA C2F9  30         mov   *stack+,r11           ; Pop R11
0340 78BC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0150                       ;-----------------------------------------------------------------------
0151                       ; Screen panes
0152                       ;-----------------------------------------------------------------------
0153                       copy  "colors.line.set.asm"        ; Set color combination for line
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
     78F4 2298 
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
**** **** ****     > stevie_b1.asm.1930724
0154                       copy  "pane.cmdb.asm"              ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.1930724
0155                       copy  "pane.cmdb.show.asm"         ; Show command buffer pane
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
     7948 7B98 
0051               
0052 794A 0720  34         seto  @parm1                ; Do not turn screen off while
     794C 2F20 
0053                                                   ; reloading color scheme
0054               
0055 794E 06A0  32         bl    @pane.action.colorscheme.load
     7950 7746 
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
**** **** ****     > stevie_b1.asm.1930724
0156                       copy  "pane.cmdb.hide.asm"         ; Hide command buffer pane
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
     7970 278A 
0039 7972 1C00                   byte pane.botrow-1,0,32,80*2
     7974 20A0 
0040 7976 FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Hide command buffer pane (rest)
0043                       ;------------------------------------------------------
0044 7978 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     797A A304 
     797C 832A 
0045 797E 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7980 A302 
0046 7982 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7984 A116 
0047 7986 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7988 A022 
0048                       ;------------------------------------------------------
0049                       ; Reload current color scheme
0050                       ;------------------------------------------------------
0051 798A 0720  34         seto  @parm1                ; Do not turn screen off while
     798C 2F20 
0052                                                   ; reloading color scheme
0053               
0054 798E 06A0  32         bl    @pane.action.colorscheme.load
     7990 7746 
0055                                                   ; Reload color scheme
0056                                                   ; i  parm1 = Skip screen off if >FFFF
0057                       ;------------------------------------------------------
0058                       ; Show cursor again
0059                       ;------------------------------------------------------
0060 7992 06A0  32         bl    @pane.cursor.blink
     7994 76C8 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               pane.cmdb.hide.exit:
0065 7996 C2F9  30         mov   *stack+,r11           ; Pop r11
0066 7998 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0157                       copy  "pane.cmdb.draw.asm"         ; Draw command buffer pane contents
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
0017 799A 0649  14         dect  stack
0018 799C C64B  30         mov   r11,*stack            ; Save return address
0019 799E 0649  14         dect  stack
0020 79A0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79A2 0649  14         dect  stack
0022 79A4 C645  30         mov   tmp1,*stack           ; Push tmp1
0023 79A6 0649  14         dect  stack
0024 79A8 C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;------------------------------------------------------
0026                       ; Command buffer header line
0027                       ;------------------------------------------------------
0028 79AA C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     79AC A31C 
     79AE 2F20 
0029 79B0 0204  20         li    tmp0,80
     79B2 0050 
0030 79B4 C804  38         mov   tmp0,@parm2           ; Set requested length
     79B6 2F22 
0031 79B8 0204  20         li    tmp0,1
     79BA 0001 
0032 79BC C804  38         mov   tmp0,@parm3           ; Set character to fill
     79BE 2F24 
0033 79C0 0204  20         li    tmp0,rambuf
     79C2 2F6A 
0034 79C4 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     79C6 2F26 
0035               
0036               
0037 79C8 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     79CA 32F2 
0038                                                   ; \ i  @parm1 = Pointer to string
0039                                                   ; | i  @parm2 = Requested length
0040                                                   ; | i  @parm3 = Fill character
0041                                                   ; | i  @parm4 = Pointer to buffer with
0042                                                   ; /             output string
0043               
0044 79CC C820  54         mov   @cmdb.yxtop,@wyx      ; \
     79CE A30E 
     79D0 832A 
0045 79D2 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     79D4 2F30 
0046 79D6 06A0  32         bl    @xutst0               ; /
     79D8 2424 
0047                       ;------------------------------------------------------
0048                       ; Check dialog id
0049                       ;------------------------------------------------------
0050 79DA 04E0  34         clr   @waux1                ; Default is show prompt
     79DC 833C 
0051               
0052 79DE C120  34         mov   @cmdb.dialog,tmp0
     79E0 A31A 
0053 79E2 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     79E4 0063 
0054 79E6 120E  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0055 79E8 0720  34         seto  @waux1                ; /
     79EA 833C 
0056                       ;------------------------------------------------------
0057                       ; Show info message instead of prompt
0058                       ;------------------------------------------------------
0059 79EC C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     79EE A31E 
0060 79F0 1309  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0061               
0062 79F2 06A0  32         bl    @at
     79F4 2696 
0063 79F6 1A00                   byte pane.botrow-3,0  ; Position cursor
0064               
0065 79F8 D815  46         movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
     79FA A326 
0066 79FC D195  26         movb  *tmp1,tmp2            ; |
0067 79FE 0986  56         srl   tmp2,8                ; |
0068 7A00 06A0  32         bl    @xutst0               ; /  Display info message
     7A02 2424 
0069                       ;------------------------------------------------------
0070                       ; Clear lines after prompt in command buffer
0071                       ;------------------------------------------------------
0072               pane.cmdb.draw.clear:
0073 7A04 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7A06 A326 
0074 7A08 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0075 7A0A A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7A0C A310 
0076 7A0E C804  38         mov   tmp0,@wyx             ; /
     7A10 832A 
0077               
0078 7A12 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7A14 23FE 
0079                                                   ; \ i  @wyx = Cursor position
0080                                                   ; / o  tmp0 = VDP target address
0081               
0082 7A16 0205  20         li    tmp1,32
     7A18 0020 
0083               
0084 7A1A C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7A1C A326 
0085 7A1E 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0086 7A20 0506  16         neg   tmp2                  ; | Based on command & prompt length
0087 7A22 0226  22         ai    tmp2,2*80 - 1         ; /
     7A24 009F 
0088               
0089 7A26 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7A28 2298 
0090                                                   ; | i  tmp0 = VDP target address
0091                                                   ; | i  tmp1 = Byte to fill
0092                                                   ; / i  tmp2 = Number of bytes to fill
0093                       ;------------------------------------------------------
0094                       ; Display pane hint in command buffer
0095                       ;------------------------------------------------------
0096               pane.cmdb.draw.hint:
0097 7A2A 0204  20         li    tmp0,pane.botrow - 1  ; \
     7A2C 001C 
0098 7A2E 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0099 7A30 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A32 2F20 
0100 7A34 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7A36 A320 
     7A38 2F22 
0101               
0102 7A3A 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A3C 7640 
0103                                                   ; \ i  parm1 = Pointer to string with hint
0104                                                   ; / i  parm2 = YX position
0105                       ;------------------------------------------------------
0106                       ; Display keys in status line
0107                       ;------------------------------------------------------
0108 7A3E 0204  20         li    tmp0,pane.botrow      ; \
     7A40 001D 
0109 7A42 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0110 7A44 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A46 2F20 
0111 7A48 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7A4A A322 
     7A4C 2F22 
0112               
0113 7A4E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A50 7640 
0114                                                   ; \ i  parm1 = Pointer to string with hint
0115                                                   ; / i  parm2 = YX position
0116                       ;------------------------------------------------------
0117                       ; ALPHA-Lock key down?
0118                       ;------------------------------------------------------
0119 7A52 20A0  38         coc   @wbit10,config
     7A54 200C 
0120 7A56 1305  14         jeq   pane.cmdb.draw.alpha.down
0121                       ;------------------------------------------------------
0122                       ; AlPHA-Lock is up
0123                       ;------------------------------------------------------
0124 7A58 06A0  32         bl    @putat
     7A5A 2446 
0125 7A5C 1D4F                   byte   pane.botrow,79
0126 7A5E 366A                   data   txt.alpha.up
0127               
0128 7A60 1004  14         jmp   pane.cmdb.draw.promptcmd
0129                       ;------------------------------------------------------
0130                       ; AlPHA-Lock is down
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.alpha.down:
0133 7A62 06A0  32         bl    @putat
     7A64 2446 
0134 7A66 1D4F                   byte   pane.botrow,79
0135 7A68 366C                   data   txt.alpha.down
0136                       ;------------------------------------------------------
0137                       ; Command buffer content
0138                       ;------------------------------------------------------
0139               pane.cmdb.draw.promptcmd:
0140 7A6A C120  34         mov   @waux1,tmp0           ; Flag set?
     7A6C 833C 
0141 7A6E 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0142 7A70 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7A72 73E6 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               pane.cmdb.draw.exit:
0147 7A74 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0148 7A76 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0149 7A78 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0150 7A7A C2F9  30         mov   *stack+,r11           ; Pop r11
0151 7A7C 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1930724
0158               
0159                       copy  "pane.topline.asm"           ; Top line
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
0017 7A7E 0649  14         dect  stack
0018 7A80 C64B  30         mov   r11,*stack            ; Save return address
0019 7A82 0649  14         dect  stack
0020 7A84 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7A86 0649  14         dect  stack
0022 7A88 C660  46         mov   @wyx,*stack           ; Push cursor position
     7A8A 832A 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7A8C 06A0  32         bl    @hchar
     7A8E 278A 
0027 7A90 0032                   byte 0,50,16,1        ; Vertical line 1
     7A92 1001 
0028 7A94 0046                   byte 0,70,16,1        ; Vertical line 2
     7A96 1001 
0029 7A98 FFFF                   data eol
0030                       ;------------------------------------------------------
0031                       ; Show buffer number
0032                       ;------------------------------------------------------
0033 7A9A 06A0  32         bl    @putat
     7A9C 2446 
0034 7A9E 0000                   byte  0,0
0035 7AA0 35AC                   data  txt.bufnum
0036                       ;------------------------------------------------------
0037                       ; Show current file
0038                       ;------------------------------------------------------
0039 7AA2 C820  54         mov   @edb.filename.ptr,@parm1
     7AA4 A212 
     7AA6 2F20 
0040                                                   ; Get string to display
0041 7AA8 0204  20         li    tmp0,47
     7AAA 002F 
0042 7AAC C804  38         mov   tmp0,@parm2           ; Set requested length
     7AAE 2F22 
0043 7AB0 0204  20         li    tmp0,32
     7AB2 0020 
0044 7AB4 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7AB6 2F24 
0045 7AB8 0204  20         li    tmp0,rambuf
     7ABA 2F6A 
0046 7ABC C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7ABE 2F26 
0047               
0048               
0049 7AC0 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7AC2 32F2 
0050                                                   ; \ i  @parm1 = Pointer to string
0051                                                   ; | i  @parm2 = Requested length
0052                                                   ; | i  @parm3 = Fill characgter
0053                                                   ; | i  @parm4 = Pointer to buffer with
0054                                                   ; /             output string
0055               
0056 7AC4 06A0  32         bl    @setx
     7AC6 26AC 
0057 7AC8 0003                   data 3                ; Position cursor
0058               
0059 7ACA C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7ACC 2F30 
0060 7ACE 06A0  32         bl    @xutst0               ; /
     7AD0 2424 
0061                       ;------------------------------------------------------
0062                       ; Show M1 marker
0063                       ;------------------------------------------------------
0064 7AD2 C120  34         mov   @edb.block.m1,tmp0    ; \
     7AD4 A20C 
0065 7AD6 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0066 7AD8 1326  14         jeq   pane.topline.exit     ; /
0067               
0068 7ADA 06A0  32         bl    @putat
     7ADC 2446 
0069 7ADE 0034                   byte 0,52
0070 7AE0 35C2                   data txt.m1           ; Show M1 marker message
0071               
0072 7AE2 C820  54         mov   @edb.block.m1,@parm1
     7AE4 A20C 
     7AE6 2F20 
0073 7AE8 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7AEA 32C6 
0074                                                   ; \ i @parm1           = uint16
0075                                                   ; / o @unpacked.string = Output string
0076               
0077 7AEC 0204  20         li    tmp0,>0500
     7AEE 0500 
0078 7AF0 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7AF2 2F44 
0079               
0080 7AF4 06A0  32         bl    @putat
     7AF6 2446 
0081 7AF8 0037                   byte 0,55
0082 7AFA 2F44                   data unpacked.string  ; Show M1 value
0083                       ;------------------------------------------------------
0084                       ; Show M2 marker
0085                       ;------------------------------------------------------
0086 7AFC C120  34         mov   @edb.block.m2,tmp0    ; \
     7AFE A20E 
0087 7B00 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0088 7B02 1311  14         jeq   pane.topline.exit     ; /
0089               
0090 7B04 06A0  32         bl    @putat
     7B06 2446 
0091 7B08 003E                   byte 0,62
0092 7B0A 35C6                   data txt.m2           ; Show M2 marker message
0093               
0094 7B0C C820  54         mov   @edb.block.m2,@parm1
     7B0E A20E 
     7B10 2F20 
0095 7B12 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B14 32C6 
0096                                                   ; \ i @parm1           = uint16
0097                                                   ; / o @unpacked.string = Output string
0098               
0099 7B16 0204  20         li    tmp0,>0500
     7B18 0500 
0100 7B1A D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B1C 2F44 
0101               
0102 7B1E 06A0  32         bl    @putat
     7B20 2446 
0103 7B22 0041                   byte 0,65
0104 7B24 2F44                   data unpacked.string  ; Show M2 value
0105                       ;------------------------------------------------------
0106                       ; Exit
0107                       ;------------------------------------------------------
0108               pane.topline.exit:
0109 7B26 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7B28 832A 
0110 7B2A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111 7B2C C2F9  30         mov   *stack+,r11           ; Pop r11
0112 7B2E 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1930724
0160                       copy  "pane.errline.asm"           ; Error line
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
0022 7B30 0649  14         dect  stack
0023 7B32 C64B  30         mov   r11,*stack            ; Save return address
0024 7B34 0649  14         dect  stack
0025 7B36 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7B38 0649  14         dect  stack
0027 7B3A C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7B3C 0205  20         li    tmp1,>00f6            ; White on dark red
     7B3E 00F6 
0030 7B40 C805  38         mov   tmp1,@parm1
     7B42 2F20 
0031               
0032 7B44 0205  20         li    tmp1,pane.botrow-1    ;
     7B46 001C 
0033 7B48 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7B4A 2F22 
0034               
0035 7B4C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7B4E 78BE 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7B50 0204  20         li    tmp0,tv.error.msg
     7B52 A02A 
0043 7B54 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7B56 2F20 
0044               
0045 7B58 0204  20         li    tmp0,80
     7B5A 0050 
0046 7B5C C804  38         mov   tmp0,@parm2           ; Set requested length
     7B5E 2F22 
0047               
0048 7B60 0204  20         li    tmp0,32
     7B62 0020 
0049 7B64 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7B66 2F24 
0050               
0051 7B68 0204  20         li    tmp0,rambuf
     7B6A 2F6A 
0052 7B6C C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7B6E 2F26 
0053               
0054 7B70 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B72 32F2 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7B74 06A0  32         bl    @at
     7B76 2696 
0064 7B78 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7B7A C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7B7C 2F30 
0067 7B7E 06A0  32         bl    @xutst0               ; /
     7B80 2424 
0068               
0069 7B82 C120  34         mov   @fb.scrrows.max,tmp0
     7B84 A11C 
0070 7B86 0604  14         dec   tmp0
0071 7B88 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7B8A A11A 
0072               
0073 7B8C 0720  34         seto  @tv.error.visible     ; Error line is visible
     7B8E A028 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7B90 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7B92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7B94 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7B96 045B  20         b     *r11                  ; Return to caller
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
0103 7B98 0649  14         dect  stack
0104 7B9A C64B  30         mov   r11,*stack            ; Save return address
0105 7B9C 0649  14         dect  stack
0106 7B9E C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7BA0 06A0  32         bl    @errline.init         ; Clear error line
     7BA2 3256 
0111               
0112 7BA4 C120  34         mov   @tv.color,tmp0        ; Get colors
     7BA6 A018 
0113 7BA8 0984  56         srl   tmp0,8                ; Right aligns
0114 7BAA C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7BAC 2F20 
0115               
0116               
0117 7BAE 0205  20         li    tmp1,pane.botrow-1    ;
     7BB0 001C 
0118 7BB2 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BB4 2F22 
0119               
0120 7BB6 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BB8 78BE 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7BBA 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7BBC A028 
0125 7BBE C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7BC0 A11C 
     7BC2 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7BC4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7BC6 C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7BC8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0161                       copy  "pane.botline.asm"           ; Bottom line
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
0017 7BCA 0649  14         dect  stack
0018 7BCC C64B  30         mov   r11,*stack            ; Save return address
0019 7BCE 0649  14         dect  stack
0020 7BD0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7BD2 0649  14         dect  stack
0022 7BD4 C660  46         mov   @wyx,*stack           ; Push cursor position
     7BD6 832A 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7BD8 06A0  32         bl    @hchar
     7BDA 278A 
0027 7BDC 1D32                   byte pane.botrow,50,16,1       ; Vertical line 1
     7BDE 1001 
0028 7BE0 1D47                   byte pane.botrow,71,16,1       ; Vertical line 2
     7BE2 1001 
0029 7BE4 FFFF                   data eol
0030                       ;------------------------------------------------------
0031                       ; Show block shortcuts if set
0032                       ;------------------------------------------------------
0033 7BE6 C120  34         mov   @edb.block.m2,tmp0    ; \
     7BE8 A20E 
0034 7BEA 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0035                                                   ; /
0036 7BEC 1305  14         jeq   pane.botline.show_keys
0037               
0038 7BEE 06A0  32         bl    @putat
     7BF0 2446 
0039 7BF2 1D00                   byte pane.botrow,0
0040 7BF4 35EE                   data txt.keys.block   ; Show block shortcuts
0041               
0042 7BF6 100D  14         jmp   pane.botline.show_mode
0043                       ;------------------------------------------------------
0044                       ; Show default message
0045                       ;------------------------------------------------------
0046               pane.botline.show_keys:
0047 7BF8 06A0  32         bl    @putat
     7BFA 2446 
0048 7BFC 1D00                   byte pane.botrow,0
0049 7BFE 35CA                   data txt.stevie       ; Show stevie version
0050               
0051 7C00 06A0  32         bl    @hchar
     7C02 278A 
0052 7C04 1D0E                   byte pane.botrow,14,16,1
     7C06 1001 
0053 7C08 FFFF                   data eol              ; Vertical line 3
0054               
0055 7C0A 06A0  32         bl    @putat
     7C0C 2446 
0056 7C0E 1D10                   byte pane.botrow,16
0057 7C10 35D8                   data txt.keys.default ; Show default shortcuts
0058                       ;------------------------------------------------------
0059                       ; Show text editing mode
0060                       ;------------------------------------------------------
0061               pane.botline.show_mode:
0062 7C12 C120  34         mov   @edb.insmode,tmp0
     7C14 A20A 
0063 7C16 1605  14         jne   pane.botline.show_mode.insert
0064                       ;------------------------------------------------------
0065                       ; Overwrite mode
0066                       ;------------------------------------------------------
0067 7C18 06A0  32         bl    @putat
     7C1A 2446 
0068 7C1C 1D34                   byte  pane.botrow,52
0069 7C1E 3520                   data  txt.ovrwrite
0070 7C20 1004  14         jmp   pane.botline.show_changed
0071                       ;------------------------------------------------------
0072                       ; Insert  mode
0073                       ;------------------------------------------------------
0074               pane.botline.show_mode.insert:
0075 7C22 06A0  32         bl    @putat
     7C24 2446 
0076 7C26 1D34                   byte  pane.botrow,52
0077 7C28 3524                   data  txt.insert
0078                       ;------------------------------------------------------
0079                       ; Show if text was changed in editor buffer
0080                       ;------------------------------------------------------
0081               pane.botline.show_changed:
0082 7C2A C120  34         mov   @edb.dirty,tmp0
     7C2C A206 
0083 7C2E 1305  14         jeq   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "*"
0086                       ;------------------------------------------------------
0087 7C30 06A0  32         bl    @putat
     7C32 2446 
0088 7C34 1D38                   byte pane.botrow,56
0089 7C36 3528                   data txt.star
0090 7C38 1000  14         jmp   pane.botline.show_linecol
0091                       ;------------------------------------------------------
0092                       ; Show "line,column"
0093                       ;------------------------------------------------------
0094               pane.botline.show_linecol:
0095 7C3A C820  54         mov   @fb.row,@parm1
     7C3C A106 
     7C3E 2F20 
0096 7C40 06A0  32         bl    @fb.row2line          ; Row to editor line
     7C42 6A3A 
0097                                                   ; \ i @fb.topline = Top line in frame buffer
0098                                                   ; | i @parm1      = Row in frame buffer
0099                                                   ; / o @outparm1   = Matching line in EB
0100               
0101 7C44 05A0  34         inc   @outparm1             ; Add base 1
     7C46 2F30 
0102                       ;------------------------------------------------------
0103                       ; Show line
0104                       ;------------------------------------------------------
0105 7C48 06A0  32         bl    @putnum
     7C4A 2A1A 
0106 7C4C 1D3B                   byte  pane.botrow,59  ; YX
0107 7C4E 2F30                   data  outparm1,rambuf
     7C50 2F6A 
0108 7C52 3020                   byte  48              ; ASCII offset
0109                             byte  32              ; Padding character
0110                       ;------------------------------------------------------
0111                       ; Show comma
0112                       ;------------------------------------------------------
0113 7C54 06A0  32         bl    @putat
     7C56 2446 
0114 7C58 1D40                   byte  pane.botrow,64
0115 7C5A 3518                   data  txt.delim
0116                       ;------------------------------------------------------
0117                       ; Show column
0118                       ;------------------------------------------------------
0119 7C5C 06A0  32         bl    @film
     7C5E 223A 
0120 7C60 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7C62 0020 
     7C64 000C 
0121               
0122 7C66 C820  54         mov   @fb.column,@waux1
     7C68 A10C 
     7C6A 833C 
0123 7C6C 05A0  34         inc   @waux1                ; Offset 1
     7C6E 833C 
0124               
0125 7C70 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7C72 299C 
0126 7C74 833C                   data  waux1,rambuf
     7C76 2F6A 
0127 7C78 3020                   byte  48              ; ASCII offset
0128                             byte  32              ; Fill character
0129               
0130 7C7A 06A0  32         bl    @trimnum              ; Trim number to the left
     7C7C 29F4 
0131 7C7E 2F6A                   data  rambuf,rambuf+5,32
     7C80 2F6F 
     7C82 0020 
0132               
0133 7C84 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7C86 0600 
0134 7C88 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7C8A 2F6F 
0135               
0136                       ;------------------------------------------------------
0137                       ; Decide if row length is to be shown
0138                       ;------------------------------------------------------
0139 7C8C C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7C8E A10C 
0140 7C90 0584  14         inc   tmp0                  ; /
0141 7C92 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7C94 A108 
0142 7C96 1101  14         jlt   pane.botline.show_linecol.linelen
0143 7C98 102B  14         jmp   pane.botline.show_linecol.colstring
0144                                                   ; Yes, skip showing row length
0145                       ;------------------------------------------------------
0146                       ; Add '/' delimiter and length of line to string
0147                       ;------------------------------------------------------
0148               pane.botline.show_linecol.linelen:
0149 7C9A C120  34         mov   @fb.column,tmp0       ; \
     7C9C A10C 
0150 7C9E 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7CA0 2F71 
0151 7CA2 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7CA4 0009 
0152 7CA6 1101  14         jlt   !                     ; | column.
0153 7CA8 0585  14         inc   tmp1                  ; /
0154               
0155 7CAA 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7CAC 2D00 
0156 7CAE DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0157               
0158 7CB0 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7CB2 833C 
0159               
0160 7CB4 06A0  32         bl    @mknum
     7CB6 299C 
0161 7CB8 A108                   data  fb.row.length,rambuf
     7CBA 2F6A 
0162 7CBC 3020                   byte  48              ; ASCII offset
0163                             byte  32              ; Padding character
0164               
0165 7CBE C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7CC0 833C 
0166               
0167 7CC2 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7CC4 A108 
0168 7CC6 0284  22         ci    tmp0,10               ; /
     7CC8 000A 
0169 7CCA 110B  14         jlt   pane.botline.show_line.1digit
0170                       ;------------------------------------------------------
0171                       ; Assert
0172                       ;------------------------------------------------------
0173 7CCC 0284  22         ci    tmp0,80
     7CCE 0050 
0174 7CD0 1204  14         jle   pane.botline.show_line.2digits
0175                       ;------------------------------------------------------
0176                       ; Asserts failed
0177                       ;------------------------------------------------------
0178 7CD2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7CD4 FFCE 
0179 7CD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7CD8 2026 
0180                       ;------------------------------------------------------
0181                       ; Show length of line (2 digits)
0182                       ;------------------------------------------------------
0183               pane.botline.show_line.2digits:
0184 7CDA 0204  20         li    tmp0,rambuf+3
     7CDC 2F6D 
0185 7CDE DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0186 7CE0 1002  14         jmp   pane.botline.show_line.rest
0187                       ;------------------------------------------------------
0188                       ; Show length of line (1 digits)
0189                       ;------------------------------------------------------
0190               pane.botline.show_line.1digit:
0191 7CE2 0204  20         li    tmp0,rambuf+4
     7CE4 2F6E 
0192               pane.botline.show_line.rest:
0193 7CE6 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0194 7CE8 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CEA 2F6A 
0195 7CEC DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7CEE 2F6A 
0196                       ;------------------------------------------------------
0197                       ; Show column string
0198                       ;------------------------------------------------------
0199               pane.botline.show_linecol.colstring:
0200 7CF0 06A0  32         bl    @putat
     7CF2 2446 
0201 7CF4 1D41                   byte pane.botrow,65
0202 7CF6 2F6F                   data rambuf+5         ; Show string
0203                       ;------------------------------------------------------
0204                       ; Show lines in buffer unless on last line in file
0205                       ;------------------------------------------------------
0206 7CF8 C820  54         mov   @fb.row,@parm1
     7CFA A106 
     7CFC 2F20 
0207 7CFE 06A0  32         bl    @fb.row2line
     7D00 6A3A 
0208 7D02 8820  54         c     @edb.lines,@outparm1
     7D04 A204 
     7D06 2F30 
0209 7D08 1605  14         jne   pane.botline.show_lines_in_buffer
0210               
0211 7D0A 06A0  32         bl    @putat
     7D0C 2446 
0212 7D0E 1D49                   byte pane.botrow,73
0213 7D10 351A                   data txt.bottom
0214               
0215 7D12 1009  14         jmp   pane.botline.exit
0216                       ;------------------------------------------------------
0217                       ; Show lines in buffer
0218                       ;------------------------------------------------------
0219               pane.botline.show_lines_in_buffer:
0220 7D14 C820  54         mov   @edb.lines,@waux1
     7D16 A204 
     7D18 833C 
0221               
0222 7D1A 06A0  32         bl    @putnum
     7D1C 2A1A 
0223 7D1E 1D49                   byte pane.botrow,73   ; YX
0224 7D20 833C                   data waux1,rambuf
     7D22 2F6A 
0225 7D24 3020                   byte 48
0226                             byte 32
0227                       ;------------------------------------------------------
0228                       ; Exit
0229                       ;------------------------------------------------------
0230               pane.botline.exit:
0231 7D26 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7D28 832A 
0232 7D2A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0233 7D2C C2F9  30         mov   *stack+,r11           ; Pop r11
0234 7D2E 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.1930724
0162                       ;-----------------------------------------------------------------------
0163                       ; Stubs using trampoline
0164                       ;-----------------------------------------------------------------------
0165                       copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "fm.loadfile"
0006               * bank2 vec.1
0007               ********|*****|*********************|**************************
0008               fm.loadfile:
0009 7D30 0649  14         dect  stack
0010 7D32 C64B  30         mov   r11,*stack            ; Save return address
0011 7D34 0649  14         dect  stack
0012 7D36 C644  30         mov   tmp0,*stack           ; Push tmp0
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 2
0015                       ;------------------------------------------------------
0016 7D38 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D3A 3008 
0017 7D3C 6004                   data bank2            ; | i  p0 = bank address
0018 7D3E 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0019 7D40 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Show "Unsaved changes" dialog if editor buffer dirty
0022                       ;------------------------------------------------------
0023 7D42 C120  34         mov   @outparm1,tmp0
     7D44 2F30 
0024 7D46 1304  14         jeq   fm.loadfile.exit
0025               
0026 7D48 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0027 7D4A C2F9  30         mov   *stack+,r11           ; Pop r11
0028 7D4C 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D4E 7DC2 
0029                       ;------------------------------------------------------
0030                       ; Exit
0031                       ;------------------------------------------------------
0032               fm.loadfile.exit:
0033 7D50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 7D52 C2F9  30         mov   *stack+,r11           ; Pop r11
0035 7D54 045B  20         b     *r11                  ; Return to caller
0036               
0037               
0038               ***************************************************************
0039               * Stub for "fm.savefile"
0040               * bank2 vec.2
0041               ********|*****|*********************|**************************
0042               fm.savefile:
0043 7D56 0649  14         dect  stack
0044 7D58 C64B  30         mov   r11,*stack            ; Save return address
0045                       ;------------------------------------------------------
0046                       ; Call function in bank 2
0047                       ;------------------------------------------------------
0048 7D5A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D5C 3008 
0049 7D5E 6004                   data bank2            ; | i  p0 = bank address
0050 7D60 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0051 7D62 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 7D64 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 7D66 045B  20         b     *r11                  ; Return to caller
0057               
0058               
0059               **************************************************************
0060               * Stub for "fm.browse.fname.suffix"
0061               * bank2 vec.3
0062               ********|*****|*********************|**************************
0063               fm.browse.fname.suffix:
0064 7D68 0649  14         dect  stack
0065 7D6A C64B  30         mov   r11,*stack            ; Save return address
0066                       ;------------------------------------------------------
0067                       ; Call function in bank 2
0068                       ;------------------------------------------------------
0069 7D6C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D6E 3008 
0070 7D70 6004                   data bank2            ; | i  p0 = bank address
0071 7D72 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0072 7D74 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0073                       ;------------------------------------------------------
0074                       ; Exit
0075                       ;------------------------------------------------------
0076 7D76 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 7D78 045B  20         b     *r11                  ; Return to caller
0078               
0079               
0080               **************************************************************
0081               * Stub for "fm.fastmode"
0082               * bank2 vec.4
0083               ********|*****|*********************|**************************
0084               fm.fastmode:
0085 7D7A 0649  14         dect  stack
0086 7D7C C64B  30         mov   r11,*stack            ; Save return address
0087                       ;------------------------------------------------------
0088                       ; Call function in bank 2
0089                       ;------------------------------------------------------
0090 7D7E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D80 3008 
0091 7D82 6004                   data bank2            ; | i  p0 = bank address
0092 7D84 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0093 7D86 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097 7D88 C2F9  30         mov   *stack+,r11           ; Pop r11
0098 7D8A 045B  20         b     *r11                  ; Return to caller
0099               
0100               
0101               
0102               
0103               
0104               ***************************************************************
0105               * Stub for "About dialog"
0106               * bank3 vec.1
0107               ********|*****|*********************|**************************
0108               edkey.action.about:
0109 7D8C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D8E 76AA 
0110                       ;------------------------------------------------------
0111                       ; Show dialog
0112                       ;------------------------------------------------------
0113 7D90 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D92 3008 
0114 7D94 6006                   data bank3            ; | i  p0 = bank address
0115 7D96 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0116 7D98 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0117                       ;------------------------------------------------------
0118                       ; Exit
0119                       ;------------------------------------------------------
0120 7D9A 0460  28         b     @edkey.action.cmdb.show
     7D9C 692E 
0121                                                   ; Show dialog in CMDB pane
0122               
0123               
0124               ***************************************************************
0125               * Stub for "Load DV80 file"
0126               * bank3 vec.2
0127               ********|*****|*********************|**************************
0128               dialog.load:
0129 7D9E 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DA0 76AA 
0130                       ;------------------------------------------------------
0131                       ; Show dialog
0132                       ;------------------------------------------------------
0133 7DA2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DA4 3008 
0134 7DA6 6006                   data bank3            ; | i  p0 = bank address
0135 7DA8 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0136 7DAA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0137                       ;------------------------------------------------------
0138                       ; Exit
0139                       ;------------------------------------------------------
0140 7DAC 0460  28         b     @edkey.action.cmdb.show
     7DAE 692E 
0141                                                   ; Show dialog in CMDB pane
0142               
0143               
0144               ***************************************************************
0145               * Stub for "Save DV80 file"
0146               * bank3 vec.3
0147               ********|*****|*********************|**************************
0148               dialog.save:
0149 7DB0 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DB2 76AA 
0150                       ;------------------------------------------------------
0151                       ; Show dialog
0152                       ;------------------------------------------------------
0153 7DB4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DB6 3008 
0154 7DB8 6006                   data bank3            ; | i  p0 = bank address
0155 7DBA 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0156 7DBC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160 7DBE 0460  28         b     @edkey.action.cmdb.show
     7DC0 692E 
0161                                                   ; Show dialog in CMDB pane
0162               
0163               
0164               ***************************************************************
0165               * Stub for "Unsaved Changes"
0166               * bank3 vec.4
0167               ********|*****|*********************|**************************
0168               dialog.unsaved:
0169 7DC2 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DC4 76AA 
0170                       ;------------------------------------------------------
0171                       ; Show dialog
0172                       ;------------------------------------------------------
0173 7DC6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DC8 3008 
0174 7DCA 6006                   data bank3            ; | i  p0 = bank address
0175 7DCC 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0176 7DCE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0177                       ;------------------------------------------------------
0178                       ; Exit
0179                       ;------------------------------------------------------
0180 7DD0 0460  28         b     @edkey.action.cmdb.show
     7DD2 692E 
0181                                                   ; Show dialog in CMDB pane
0182               
0183               
0184               
0185               
0186               ***************************************************************
0187               * Stub for Dialog "Move/Copy/Delete block"
0188               * bank3 vec.5
0189               ********|*****|*********************|**************************
0190               dialog.block:
0191 7DD4 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DD6 76AA 
0192                       ;------------------------------------------------------
0193                       ; Show dialog
0194                       ;------------------------------------------------------
0195 7DD8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DDA 3008 
0196 7DDC 6006                   data bank3            ; | i  p0 = bank address
0197 7DDE 7FA4                   data vec.5            ; | i  p1 = Vector with target address
0198 7DE0 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202 7DE2 0460  28         b     @edkey.action.cmdb.show
     7DE4 692E 
0203                                                   ; Show dialog in CMDB pane
0204               
0205               
0206               ***************************************************************
0207               * Stub for "fb.tab.next"
0208               * bank4 vec.1
0209               ********|*****|*********************|**************************
0210               fb.tab.next:
0211 7DE6 0649  14         dect  stack
0212 7DE8 C64B  30         mov   r11,*stack            ; Save return address
0213                       ;------------------------------------------------------
0214                       ; Put cursor on next tab position
0215                       ;------------------------------------------------------
0216 7DEA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DEC 3008 
0217 7DEE 6008                   data bank4            ; | i  p0 = bank address
0218 7DF0 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0219 7DF2 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0220                       ;------------------------------------------------------
0221                       ; Exit
0222                       ;------------------------------------------------------
0223 7DF4 C2F9  30         mov   *stack+,r11           ; Pop r11
0224 7DF6 045B  20         b     *r11                  ; Return to caller
0225               
0226               
0227               ***************************************************************
0228               * Stub for "fb.ruler.init"
0229               * bank4 vec.2
0230               ********|*****|*********************|**************************
0231               fb.ruler.init:
0232 7DF8 0649  14         dect  stack
0233 7DFA C64B  30         mov   r11,*stack            ; Save return address
0234                       ;------------------------------------------------------
0235                       ; Setup ruler in memory
0236                       ;------------------------------------------------------
0237 7DFC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DFE 3008 
0238 7E00 6008                   data bank4            ; | i  p0 = bank address
0239 7E02 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0240 7E04 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0241                       ;------------------------------------------------------
0242                       ; Exit
0243                       ;------------------------------------------------------
0244 7E06 C2F9  30         mov   *stack+,r11           ; Pop r11
0245 7E08 045B  20         b     *r11                  ; Return to caller
0246               
0247               
0248               ***************************************************************
0249               * Stub for "fb.colorlines"
0250               * bank4 vec.3
0251               ********|*****|*********************|**************************
0252               fb.colorlines:
0253 7E0A 0649  14         dect  stack
0254 7E0C C64B  30         mov   r11,*stack            ; Save return address
0255                       ;------------------------------------------------------
0256                       ; Colorize frame buffer content
0257                       ;------------------------------------------------------
0258 7E0E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E10 3008 
0259 7E12 6008                   data bank4            ; | i  p0 = bank address
0260 7E14 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0261 7E16 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0262                       ;------------------------------------------------------
0263                       ; Exit
0264                       ;------------------------------------------------------
0265 7E18 C2F9  30         mov   *stack+,r11           ; Pop r11
0266 7E1A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.1930724
0166                       ;-----------------------------------------------------------------------
0167                       ; Program data
0168                       ;-----------------------------------------------------------------------
0169                       copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
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
0011 7E1C 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7E1E 0000 
     7E20 6670 
0012 7E22 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7E24 0000 
     7E26 6172 
0013 7E28 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7E2A 0000 
     7E2C 618C 
0014 7E2E 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7E30 0000 
     7E32 629C 
0015 7E34 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7E36 0000 
     7E38 62F6 
0016 7E3A BF00             data  key.fctn.h, pane.focus.fb, edkey.action.home
     7E3C 0000 
     7E3E 61A8 
0017 7E40 C000             data  key.fctn.j, pane.focus.fb, edkey.action.pword
     7E42 0000 
     7E44 61EA 
0018 7E46 C100             data  key.fctn.k, pane.focus.fb, edkey.action.nword
     7E48 0000 
     7E4A 623C 
0019 7E4C C200             data  key.fctn.l, pane.focus.fb, edkey.action.end
     7E4E 0000 
     7E50 61C8 
0020 7E52 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7E54 0000 
     7E56 636A 
0021 7E58 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7E5A 0000 
     7E5C 63A6 
0022 7E5E 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7E60 0000 
     7E62 63E0 
0023 7E64 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7E66 0000 
     7E68 63FC 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7E6A 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7E6C 0000 
     7E6E 646E 
0028 7E70 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7E72 0000 
     7E74 6520 
0029 7E76 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7E78 0000 
     7E7A 64EC 
0030                       ;-------------------------------------------------------
0031                       ; Modifier keys - Insert
0032                       ;-------------------------------------------------------
0033 7E7C 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7E7E 0000 
     7E80 6582 
0034 7E82 B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7E84 0000 
     7E86 66E8 
0035 7E88 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7E8A 0000 
     7E8C 65FC 
0036 7E8E 0100             data  key.fctn.7, pane.focus.fb, edkey.action.fb.tab.next
     7E90 0000 
     7E92 6880 
0037                       ;-------------------------------------------------------
0038                       ; Block marking/modifier
0039                       ;-------------------------------------------------------
0040 7E94 9600             data  key.ctrl.v, pane.focus.fb, edkey.action.block.mark
     7E96 0000 
     7E98 67BA 
0041 7E9A 9200             data  key.ctrl.r, pane.focus.fb, edkey.action.block.reset
     7E9C 0000 
     7E9E 67C2 
0042 7EA0 8300             data  key.ctrl.c, pane.focus.fb, edkey.action.block.copy
     7EA2 0000 
     7EA4 67CE 
0043 7EA6 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.block.delete
     7EA8 0000 
     7EAA 680A 
0044 7EAC 8D00             data  key.ctrl.m, pane.focus.fb, edkey.action.block.move
     7EAE 0000 
     7EB0 6834 
0045 7EB2 8700             data  key.ctrl.g, pane.focus.fb, edkey.action.block.goto.m1
     7EB4 0000 
     7EB6 6866 
0046                       ;-------------------------------------------------------
0047                       ; Other action keys
0048                       ;-------------------------------------------------------
0049 7EB8 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7EBA 0000 
     7EBC 6762 
0050 7EBE 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7EC0 0000 
     7EC2 76E8 
0051                       ;-------------------------------------------------------
0052                       ; Dialog keys
0053                       ;-------------------------------------------------------
0054 7EC4 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7EC6 0000 
     7EC8 6774 
0055 7ECA 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7ECC 0000 
     7ECE 6780 
0056 7ED0 BC00             data  key.fctn.0, pane.focus.fb, edkey.action.about
     7ED2 0000 
     7ED4 7D8C 
0057 7ED6 9300             data  key.ctrl.s, pane.focus.fb, dialog.save
     7ED8 0000 
     7EDA 7DB0 
0058 7EDC 8F00             data  key.ctrl.o, pane.focus.fb, dialog.load
     7EDE 0000 
     7EE0 7D9E 
0059                       ;-------------------------------------------------------
0060                       ; End of list
0061                       ;-------------------------------------------------------
0062 7EE2 FFFF             data  EOL                           ; EOL
0063               
0064               
0065               
0066               
0067               *---------------------------------------------------------------
0068               * Action keys mapping table: Command Buffer (CMDB)
0069               *---------------------------------------------------------------
0070               keymap_actions.cmdb:
0071                       ;-------------------------------------------------------
0072                       ; Dialog specific: File load
0073                       ;-------------------------------------------------------
0074 7EE4 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7EE6 000A 
     7EE8 6A0E 
0075 7EEA 0D00             data  key.enter, id.dialog.load, edkey.action.cmdb.load
     7EEC 000A 
     7EEE 6940 
0076                       ;-------------------------------------------------------
0077                       ; Dialog specific: Unsaved changes
0078                       ;-------------------------------------------------------
0079 7EF0 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7EF2 0065 
     7EF4 69E4 
0080 7EF6 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7EF8 0065 
     7EFA 7DB0 
0081                       ;-------------------------------------------------------
0082                       ; Dialog specific: File save
0083                       ;-------------------------------------------------------
0084 7EFC 0D00             data  key.enter, id.dialog.save, edkey.action.cmdb.save
     7EFE 000B 
     7F00 6984 
0085 7F02 0D00             data  key.enter, id.dialog.saveblock, edkey.action.cmdb.save
     7F04 000C 
     7F06 6984 
0086                       ;-------------------------------------------------------
0087                       ; Dialog specific: About
0088                       ;-------------------------------------------------------
0089 7F08 0F00             data  key.fctn.9, id.dialog.about, edkey.action.cmdb.close.about
     7F0A 0067 
     7F0C 6A1A 
0090 7F0E 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.about
     7F10 0067 
     7F12 6A1A 
0091                       ;-------------------------------------------------------
0092                       ; Movement keys
0093                       ;-------------------------------------------------------
0094 7F14 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7F16 0001 
     7F18 688E 
0095 7F1A 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7F1C 0001 
     7F1E 68A0 
0096 7F20 BF00             data  key.fctn.h, pane.focus.cmdb, edkey.action.cmdb.home
     7F22 0001 
     7F24 68B8 
0097 7F26 C200             data  key.fctn.l, pane.focus.cmdb, edkey.action.cmdb.end
     7F28 0001 
     7F2A 68CC 
0098                       ;-------------------------------------------------------
0099                       ; Modifier keys
0100                       ;-------------------------------------------------------
0101 7F2C 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7F2E 0001 
     7F30 68E4 
0102                       ;-------------------------------------------------------
0103                       ; Other action keys
0104                       ;-------------------------------------------------------
0105 7F32 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7F34 0001 
     7F36 6A26 
0106 7F38 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7F3A 0001 
     7F3C 6762 
0107 7F3E 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7F40 0001 
     7F42 76E8 
0108                       ;------------------------------------------------------
0109                       ; End of list
0110                       ;-------------------------------------------------------
0111 7F44 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.1930724
0170                       ;-----------------------------------------------------------------------
0171                       ; Bank specific vector table
0172                       ;-----------------------------------------------------------------------
0176 7F46 7F46                   data $                ; Bank 1 ROM size OK.
0178                       ;-------------------------------------------------------
0179                       ; Vector table bank 1: >7f9c - >7fff
0180                       ;-------------------------------------------------------
0181                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 6D08     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0010 7F9E 6BC0     vec.2   data  idx.entry.update      ;    for index functions.
0011 7FA0 6C6E     vec.3   data  idx.entry.delete      ;
0012 7FA2 6C12     vec.4   data  idx.pointer.get       ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 6DF0     vec.10  data  edb.line.pack.fb      ;
0019 7FB0 6EE8     vec.11  data  edb.line.unpack.fb    ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 692E     vec.15  data  edkey.action.cmdb.show
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 7430     vec.19  data  cmdb.cmd.clear        ;
0028 7FC2 6AC4     vec.20  data  fb.refresh            ;
0029 7FC4 6B34     vec.21  data  fb.vdpdump            ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 76C8     vec.28  data  pane.cursor.blink     ;
0037 7FD4 76AA     vec.29  data  pane.cursor.hide      ;
0038 7FD6 7B30     vec.30  data  pane.errline.show     ;
0039 7FD8 7746     vec.31  data  pane.action.colorscheme.load
0040 7FDA 78A4     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.1930724
0182               
0183               
0184               
0185               
0186               *--------------------------------------------------------------
0187               * Video mode configuration
0188               *--------------------------------------------------------------
0189      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0190      0004     spfbck  equ   >04                   ; Screen background color.
0191      338A     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0192      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0193      0050     colrow  equ   80                    ; Columns per row
0194      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0195      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0196      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0197      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

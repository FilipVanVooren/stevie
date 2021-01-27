XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.464228
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210127-464228
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
**** **** ****     > stevie_b1.asm.464228
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
0112      0960     vdp.sit.size.80x24        equ  80*30   ; VDP SIT size when 80 columns, 24 rows
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
0178      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0179      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0180      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0181      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0182      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0183      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0184      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0185      A01E     tv.pane.focus     equ  tv.top + 30     ; Identify pane that has focus
0186      A020     tv.task.oneshot   equ  tv.top + 32     ; Pointer to one-shot routine
0187      A022     tv.fj.stackpnt    equ  tv.top + 34     ; Pointer to farjump return stack
0188      A024     tv.error.visible  equ  tv.top + 36     ; Error pane visible
0189      A026     tv.error.msg      equ  tv.top + 38     ; Error message (max. 160 characters)
0190      A0C6     tv.free           equ  tv.top + 198    ; End of structure
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
0212      A11E     fb.free           equ  fb.struct + 30  ; End of structure
0213               *--------------------------------------------------------------
0214               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0215               *--------------------------------------------------------------
0216      A200     edb.struct        equ  >a200           ; Begin structure
0217      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0218      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0219      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0220      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0221      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0222      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0223      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0224      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0225      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0226      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0227                                                      ; with current filename.
0228      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0229                                                      ; with current file type.
0230      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0231      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0232      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0233                                                      ; for filename, but not always used.
0234      A269     edb.free          equ  edb.struct + 105; End of structure
0235               *--------------------------------------------------------------
0236               * Command buffer structure            @>a300-a3ff   (256 bytes)
0237               *--------------------------------------------------------------
0238      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0239      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0240      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0241      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0242      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0243      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0244      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0245      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0246      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0247      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0248      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0249      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0250      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0251      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0252      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0253      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0254      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0255      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0256      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0257      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0258      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0259      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0260      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0261               *--------------------------------------------------------------
0262               * File handle structure               @>a400-a4ff   (256 bytes)
0263               *--------------------------------------------------------------
0264      A400     fh.struct         equ  >a400           ; stevie file handling structures
0265               ;***********************************************************************
0266               ; ATTENTION
0267               ; The dsrlnk variables must form a continuous memory block and keep
0268               ; their order!
0269               ;***********************************************************************
0270      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0271      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0272      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0273      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0274      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0275      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0276      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0277      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0278      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0279      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0280      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0281      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0282      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0283      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0284      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0285      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0286      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0287      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0288      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0289      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0290      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0291      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0292      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0293      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0294      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0295      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0296      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0297      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0298      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0299      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0300      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0301      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0302               *--------------------------------------------------------------
0303               * Index structure                     @>a500-a5ff   (256 bytes)
0304               *--------------------------------------------------------------
0305      A500     idx.struct        equ  >a500           ; stevie index structure
0306      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0307      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0308      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0309               *--------------------------------------------------------------
0310               * Frame buffer                        @>a600-afff  (2560 bytes)
0311               *--------------------------------------------------------------
0312      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0313      0960     fb.size           equ  80*30           ; Frame buffer size
0314               *--------------------------------------------------------------
0315               * Index                               @>b000-bfff  (4096 bytes)
0316               *--------------------------------------------------------------
0317      B000     idx.top           equ  >b000           ; Top of index
0318      1000     idx.size          equ  4096            ; Index size
0319               *--------------------------------------------------------------
0320               * Editor buffer                       @>c000-cfff  (4096 bytes)
0321               *--------------------------------------------------------------
0322      C000     edb.top           equ  >c000           ; Editor buffer high memory
0323      1000     edb.size          equ  4096            ; Editor buffer size
0324               *--------------------------------------------------------------
0325               * Command history buffer              @>d000-dfff  (4096 bytes)
0326               *--------------------------------------------------------------
0327      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0328      1000     cmdb.size         equ  4096            ; Command buffer size
0329               *--------------------------------------------------------------
0330               * Heap                                @>e000-ebff  (3072 bytes)
0331               *--------------------------------------------------------------
0332      E000     heap.top          equ  >e000           ; Top of heap
0333               *--------------------------------------------------------------
0334               * Farjump return stack                @>ec00-efff  (1024 bytes)
0335               *--------------------------------------------------------------
0336      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b1.asm.464228
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
0015 6014 1353             byte  19
0016 6015 ....             text  'STEVIE 1.0 (BETA 2)'
0017                       even
0018               
**** **** ****     > stevie_b1.asm.464228
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
     2084 2E0C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 22FA 
0078 208A 21EA                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 2362 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 2290 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2444 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 2990 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2444 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 2990 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2444 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2444 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2444 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2444 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 2694 
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
     210C 299A 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26AA 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2420 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26AA 
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
     2132 2420 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 299A 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 290C 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26AA 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2420 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26AA 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 2420 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 269A 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D0A 
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
0259 21D2 1742             byte  23
0260 21D3 ....             text  'Build-ID  210127-464228'
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
0029               ***************************************************************
0030               * Textmode (40 columns/24 rows)
0031               *--------------------------------------------------------------
0032 21F4 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21F6 000E 
     21F8 0106 
     21FA 00F4 
     21FC 0028 
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
0058 21FE 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2200 003F 
     2202 0240 
     2204 03F4 
     2206 0050 
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
0084 2208 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220A 003F 
     220C 0240 
     220E 03F4 
     2210 0050 
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
0013 2212 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2214 16FD             data  >16fd                 ; |         jne   mcloop
0015 2216 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2218 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 221A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 221C 0201  20         li    r1,mccode             ; Machinecode to patch
     221E 2212 
0037 2220 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2222 8322 
0038 2224 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2226 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2228 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 222A 045B  20         b     *r11                  ; Return to caller
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
0056 222C C0F9  30 popr3   mov   *stack+,r3
0057 222E C0B9  30 popr2   mov   *stack+,r2
0058 2230 C079  30 popr1   mov   *stack+,r1
0059 2232 C039  30 popr0   mov   *stack+,r0
0060 2234 C2F9  30 poprt   mov   *stack+,r11
0061 2236 045B  20         b     *r11
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
0085 2238 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 223A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 223C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 223E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2240 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2242 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2244 FFCE 
0095 2246 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2248 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 224A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     224C 830B 
     224E 830A 
0100               
0101 2250 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2252 0001 
0102 2254 1602  14         jne   filchk2
0103 2256 DD05  32         movb  tmp1,*tmp0+
0104 2258 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 225A 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     225C 0002 
0109 225E 1603  14         jne   filchk3
0110 2260 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2262 DD05  32         movb  tmp1,*tmp0+
0112 2264 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2266 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2268 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     226A 0001 
0118 226C 1605  14         jne   fil16b
0119 226E DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2270 0606  14         dec   tmp2
0121 2272 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2274 0002 
0122 2276 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2278 C1C6  18 fil16b  mov   tmp2,tmp3
0127 227A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227C 0001 
0128 227E 1301  14         jeq   dofill
0129 2280 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2282 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2284 0646  14         dect  tmp2
0132 2286 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2288 C1C7  18         mov   tmp3,tmp3
0137 228A 1301  14         jeq   fil.exit
0138 228C DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 228E 045B  20         b     *r11
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
0159 2290 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 2292 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 2294 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 2296 0264  22 xfilv   ori   tmp0,>4000
     2298 4000 
0166 229A 06C4  14         swpb  tmp0
0167 229C D804  38         movb  tmp0,@vdpa
     229E 8C02 
0168 22A0 06C4  14         swpb  tmp0
0169 22A2 D804  38         movb  tmp0,@vdpa
     22A4 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22A6 020F  20         li    r15,vdpw              ; Set VDP write address
     22A8 8C00 
0174 22AA 06C5  14         swpb  tmp1
0175 22AC C820  54         mov   @filzz,@mcloop        ; Setup move command
     22AE 22B6 
     22B0 8320 
0176 22B2 0460  28         b     @mcloop               ; Write data to VDP
     22B4 8320 
0177               *--------------------------------------------------------------
0181 22B6 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22B8 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22BA 4000 
0202 22BC 06C4  14 vdra    swpb  tmp0
0203 22BE D804  38         movb  tmp0,@vdpa
     22C0 8C02 
0204 22C2 06C4  14         swpb  tmp0
0205 22C4 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22C6 8C02 
0206 22C8 045B  20         b     *r11                  ; Exit
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
0217 22CA C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22CC C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22CE 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D0 4000 
0223 22D2 06C4  14         swpb  tmp0                  ; \
0224 22D4 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22D6 8C02 
0225 22D8 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22DA D804  38         movb  tmp0,@vdpa            ; /
     22DC 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22DE 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E0 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22E2 045B  20         b     *r11                  ; Exit
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
0251 22E4 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22E6 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22E8 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22EA 8C02 
0257 22EC 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22EE D804  38         movb  tmp0,@vdpa            ; /
     22F0 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22F2 D120  34         movb  @vdpr,tmp0            ; Read byte
     22F4 8800 
0263 22F6 0984  56         srl   tmp0,8                ; Right align
0264 22F8 045B  20         b     *r11                  ; Exit
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
0283 22FA C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 22FC C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 22FE C144  18         mov   tmp0,tmp1
0289 2300 05C5  14         inct  tmp1
0290 2302 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2304 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2306 FF00 
0292 2308 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 230A C805  38         mov   tmp1,@wbase           ; Store calculated base
     230C 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 230E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2310 8000 
0298 2312 0206  20         li    tmp2,8
     2314 0008 
0299 2316 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2318 830B 
0300 231A 06C5  14         swpb  tmp1
0301 231C D805  38         movb  tmp1,@vdpa
     231E 8C02 
0302 2320 06C5  14         swpb  tmp1
0303 2322 D805  38         movb  tmp1,@vdpa
     2324 8C02 
0304 2326 0225  22         ai    tmp1,>0100
     2328 0100 
0305 232A 0606  14         dec   tmp2
0306 232C 16F4  14         jne   vidta1                ; Next register
0307 232E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2330 833A 
0308 2332 045B  20         b     *r11
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
0325 2334 C13B  30 putvr   mov   *r11+,tmp0
0326 2336 0264  22 putvrx  ori   tmp0,>8000
     2338 8000 
0327 233A 06C4  14         swpb  tmp0
0328 233C D804  38         movb  tmp0,@vdpa
     233E 8C02 
0329 2340 06C4  14         swpb  tmp0
0330 2342 D804  38         movb  tmp0,@vdpa
     2344 8C02 
0331 2346 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2348 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 234A C10E  18         mov   r14,tmp0
0341 234C 0984  56         srl   tmp0,8
0342 234E 06A0  32         bl    @putvrx               ; Write VR#0
     2350 2336 
0343 2352 0204  20         li    tmp0,>0100
     2354 0100 
0344 2356 D820  54         movb  @r14lb,@tmp0lb
     2358 831D 
     235A 8309 
0345 235C 06A0  32         bl    @putvrx               ; Write VR#1
     235E 2336 
0346 2360 0458  20         b     *tmp4                 ; Exit
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
0360 2362 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2364 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2366 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2368 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     236A 7FFF 
0364 236C 2120  38         coc   @wbit0,tmp0
     236E 2020 
0365 2370 1604  14         jne   ldfnt1
0366 2372 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2374 8000 
0367 2376 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2378 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 237A C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     237C 23E4 
0372 237E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2380 9C02 
0373 2382 06C4  14         swpb  tmp0
0374 2384 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2386 9C02 
0375 2388 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     238A 9800 
0376 238C 06C5  14         swpb  tmp1
0377 238E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2390 9800 
0378 2392 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 2394 D805  38         movb  tmp1,@grmwa
     2396 9C02 
0383 2398 06C5  14         swpb  tmp1
0384 239A D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     239C 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 239E C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A0 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23A2 22B8 
0390 23A4 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23A6 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23A8 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23AA 7FFF 
0393 23AC C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23AE 23E6 
0394 23B0 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23B2 23E8 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23B4 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23B6 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23B8 D120  34         movb  @grmrd,tmp0
     23BA 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23BC 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23BE 2020 
0405 23C0 1603  14         jne   ldfnt3                ; No, so skip
0406 23C2 D1C4  18         movb  tmp0,tmp3
0407 23C4 0917  56         srl   tmp3,1
0408 23C6 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23C8 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23CA 8C00 
0413 23CC 0606  14         dec   tmp2
0414 23CE 16F2  14         jne   ldfnt2
0415 23D0 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23D2 020F  20         li    r15,vdpw              ; Set VDP write address
     23D4 8C00 
0417 23D6 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23D8 7FFF 
0418 23DA 0458  20         b     *tmp4                 ; Exit
0419 23DC D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23DE 2000 
     23E0 8C00 
0420 23E2 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23E4 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23E6 0200 
     23E8 0000 
0425 23EA 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23EC 01C0 
     23EE 0101 
0426 23F0 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23F2 02A0 
     23F4 0101 
0427 23F6 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23F8 00E0 
     23FA 0101 
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
0445 23FC C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 23FE C3A0  34         mov   @wyx,r14              ; Get YX
     2400 832A 
0447 2402 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2404 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2406 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2408 C3A0  34         mov   @wyx,r14              ; Get YX
     240A 832A 
0454 240C 024E  22         andi  r14,>00ff             ; Remove Y
     240E 00FF 
0455 2410 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2412 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2414 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2416 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2418 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 241A 020F  20         li    r15,vdpw              ; VDP write address
     241C 8C00 
0463 241E 045B  20         b     *r11
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
0478 2420 C17B  30 putstr  mov   *r11+,tmp1
0479 2422 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 2424 C1CB  18 xutstr  mov   r11,tmp3
0481 2426 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2428 23FC 
0482 242A C2C7  18         mov   tmp3,r11
0483 242C 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 242E C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 2430 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 2432 0286  22         ci    tmp2,255              ; Length > 255 ?
     2434 00FF 
0491 2436 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2438 0460  28         b     @xpym2v               ; Display string
     243A 2452 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 243C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     243E FFCE 
0498 2440 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2442 2026 
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
0514 2444 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2446 832A 
0515 2448 0460  28         b     @putstr
     244A 2420 
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
0020 244C C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 244E C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2450 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 2452 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2454 1604  14         jne   !                     ; No, continue
0028               
0029 2456 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2458 FFCE 
0030 245A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     245C 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 245E 0264  22 !       ori   tmp0,>4000
     2460 4000 
0035 2462 06C4  14         swpb  tmp0
0036 2464 D804  38         movb  tmp0,@vdpa
     2466 8C02 
0037 2468 06C4  14         swpb  tmp0
0038 246A D804  38         movb  tmp0,@vdpa
     246C 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 246E 020F  20         li    r15,vdpw              ; Set VDP write address
     2470 8C00 
0043 2472 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2474 247C 
     2476 8320 
0044 2478 0460  28         b     @mcloop               ; Write data to VDP and return
     247A 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 247C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 247E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2480 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2482 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2484 06C4  14 xpyv2m  swpb  tmp0
0027 2486 D804  38         movb  tmp0,@vdpa
     2488 8C02 
0028 248A 06C4  14         swpb  tmp0
0029 248C D804  38         movb  tmp0,@vdpa
     248E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2490 020F  20         li    r15,vdpr              ; Set VDP read address
     2492 8800 
0034 2494 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2496 249E 
     2498 8320 
0035 249A 0460  28         b     @mcloop               ; Read data from VDP
     249C 8320 
0036 249E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24A0 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24A2 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24A4 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24A6 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24A8 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24AA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24AC FFCE 
0034 24AE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24B0 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24B2 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24B4 0001 
0039 24B6 1603  14         jne   cpym0                 ; No, continue checking
0040 24B8 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24BA 04C6  14         clr   tmp2                  ; Reset counter
0042 24BC 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24BE 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24C0 7FFF 
0047 24C2 C1C4  18         mov   tmp0,tmp3
0048 24C4 0247  22         andi  tmp3,1
     24C6 0001 
0049 24C8 1618  14         jne   cpyodd                ; Odd source address handling
0050 24CA C1C5  18 cpym1   mov   tmp1,tmp3
0051 24CC 0247  22         andi  tmp3,1
     24CE 0001 
0052 24D0 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24D2 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24D4 2020 
0057 24D6 1605  14         jne   cpym3
0058 24D8 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24DA 2500 
     24DC 8320 
0059 24DE 0460  28         b     @mcloop               ; Copy memory and exit
     24E0 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24E2 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24E4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24E6 0001 
0065 24E8 1301  14         jeq   cpym4
0066 24EA 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24EC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24EE 0646  14         dect  tmp2
0069 24F0 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24F2 C1C7  18         mov   tmp3,tmp3
0074 24F4 1301  14         jeq   cpymz
0075 24F6 D554  38         movb  *tmp0,*tmp1
0076 24F8 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24FA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24FC 8000 
0081 24FE 10E9  14         jmp   cpym2
0082 2500 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 2502 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2504 0649  14         dect  stack
0065 2506 C64B  30         mov   r11,*stack            ; Push return address
0066 2508 0649  14         dect  stack
0067 250A C640  30         mov   r0,*stack             ; Push r0
0068 250C 0649  14         dect  stack
0069 250E C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 2510 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2512 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2514 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2516 4000 
0077 2518 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     251A 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 251C 020C  20         li    r12,>1e00             ; SAMS CRU address
     251E 1E00 
0082 2520 04C0  14         clr   r0
0083 2522 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2524 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2526 D100  18         movb  r0,tmp0
0086 2528 0984  56         srl   tmp0,8                ; Right align
0087 252A C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     252C 833C 
0088 252E 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 2530 C339  30         mov   *stack+,r12           ; Pop r12
0094 2532 C039  30         mov   *stack+,r0            ; Pop r0
0095 2534 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2536 045B  20         b     *r11                  ; Return to caller
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
0131 2538 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 253A C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 253C 0649  14         dect  stack
0135 253E C64B  30         mov   r11,*stack            ; Push return address
0136 2540 0649  14         dect  stack
0137 2542 C640  30         mov   r0,*stack             ; Push r0
0138 2544 0649  14         dect  stack
0139 2546 C64C  30         mov   r12,*stack            ; Push r12
0140 2548 0649  14         dect  stack
0141 254A C644  30         mov   tmp0,*stack           ; Push tmp0
0142 254C 0649  14         dect  stack
0143 254E C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2550 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2552 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 2554 0284  22         ci    tmp0,255              ; Crash if page > 255
     2556 00FF 
0153 2558 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 255A 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     255C 001E 
0158 255E 150A  14         jgt   !
0159 2560 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     2562 0004 
0160 2564 1107  14         jlt   !
0161 2566 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2568 0012 
0162 256A 1508  14         jgt   sams.page.set.switch_page
0163 256C 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     256E 0006 
0164 2570 1501  14         jgt   !
0165 2572 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2574 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2576 FFCE 
0170 2578 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     257A 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 257C 020C  20         li    r12,>1e00             ; SAMS CRU address
     257E 1E00 
0176 2580 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 2582 06C0  14         swpb  r0                    ; LSB to MSB
0178 2584 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2586 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2588 4000 
0180 258A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 258C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 258E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 2590 C339  30         mov   *stack+,r12           ; Pop r12
0188 2592 C039  30         mov   *stack+,r0            ; Pop r0
0189 2594 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 2596 045B  20         b     *r11                  ; Return to caller
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
0204 2598 020C  20         li    r12,>1e00             ; SAMS CRU address
     259A 1E00 
0205 259C 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 259E 045B  20         b     *r11                  ; Return to caller
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
0227 25A0 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A2 1E00 
0228 25A4 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25A6 045B  20         b     *r11                  ; Return to caller
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
0260 25A8 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25AA 0649  14         dect  stack
0263 25AC C64B  30         mov   r11,*stack            ; Save return address
0264 25AE 0649  14         dect  stack
0265 25B0 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25B2 0649  14         dect  stack
0267 25B4 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25B6 0649  14         dect  stack
0269 25B8 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25BA 0649  14         dect  stack
0271 25BC C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25BE 0206  20         li    tmp2,8                ; Set loop counter
     25C0 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25C2 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25C4 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25C6 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25C8 253C 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25CA 0606  14         dec   tmp2                  ; Next iteration
0288 25CC 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25CE 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25D0 2598 
0294                                                   ; / activating changes.
0295               
0296 25D2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25DA C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25DC 045B  20         b     *r11                  ; Return to caller
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
0318 25DE 0649  14         dect  stack
0319 25E0 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25E2 06A0  32         bl    @sams.layout
     25E4 25A8 
0324 25E6 25EC                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25EA 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25EC 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25EE 0002 
0336 25F0 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25F2 0003 
0337 25F4 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25F6 000A 
0338 25F8 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25FA 000B 
0339 25FC C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25FE 000C 
0340 2600 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2602 000D 
0341 2604 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2606 000E 
0342 2608 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     260A 000F 
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
0363 260C C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 260E 0649  14         dect  stack
0366 2610 C64B  30         mov   r11,*stack            ; Push return address
0367 2612 0649  14         dect  stack
0368 2614 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2616 0649  14         dect  stack
0370 2618 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 261A 0649  14         dect  stack
0372 261C C646  30         mov   tmp2,*stack           ; Push tmp2
0373 261E 0649  14         dect  stack
0374 2620 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2622 0205  20         li    tmp1,sams.layout.copy.data
     2624 2644 
0379 2626 0206  20         li    tmp2,8                ; Set loop counter
     2628 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 262A C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 262C 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     262E 2504 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 2630 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2632 833C 
0390               
0391 2634 0606  14         dec   tmp2                  ; Next iteration
0392 2636 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2638 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 263A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 263C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 263E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 2640 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2642 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2644 2000             data  >2000                 ; >2000-2fff
0408 2646 3000             data  >3000                 ; >3000-3fff
0409 2648 A000             data  >a000                 ; >a000-afff
0410 264A B000             data  >b000                 ; >b000-bfff
0411 264C C000             data  >c000                 ; >c000-cfff
0412 264E D000             data  >d000                 ; >d000-dfff
0413 2650 E000             data  >e000                 ; >e000-efff
0414 2652 F000             data  >f000                 ; >f000-ffff
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
0009 2654 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2656 FFBF 
0010 2658 0460  28         b     @putv01
     265A 2348 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 265C 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     265E 0040 
0018 2660 0460  28         b     @putv01
     2662 2348 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2664 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2666 FFDF 
0026 2668 0460  28         b     @putv01
     266A 2348 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 266C 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     266E 0020 
0034 2670 0460  28         b     @putv01
     2672 2348 
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
0010 2674 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2676 FFFE 
0011 2678 0460  28         b     @putv01
     267A 2348 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 267C 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     267E 0001 
0019 2680 0460  28         b     @putv01
     2682 2348 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2684 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2686 FFFD 
0027 2688 0460  28         b     @putv01
     268A 2348 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 268C 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     268E 0002 
0035 2690 0460  28         b     @putv01
     2692 2348 
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
0018 2694 C83B  50 at      mov   *r11+,@wyx
     2696 832A 
0019 2698 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 269A B820  54 down    ab    @hb$01,@wyx
     269C 2012 
     269E 832A 
0028 26A0 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26A2 7820  54 up      sb    @hb$01,@wyx
     26A4 2012 
     26A6 832A 
0037 26A8 045B  20         b     *r11
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
0049 26AA C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26AC D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26AE 832A 
0051 26B0 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26B2 832A 
0052 26B4 045B  20         b     *r11
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
0021 26B6 C120  34 yx2px   mov   @wyx,tmp0
     26B8 832A 
0022 26BA C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26BC 06C4  14         swpb  tmp0                  ; Y<->X
0024 26BE 04C5  14         clr   tmp1                  ; Clear before copy
0025 26C0 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26C2 20A0  38         coc   @wbit1,config         ; f18a present ?
     26C4 201E 
0030 26C6 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26C8 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26CA 833A 
     26CC 26F6 
0032 26CE 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26D0 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26D2 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26D4 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26D6 0500 
0037 26D8 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26DA D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26DC 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26DE 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26E0 D105  18         movb  tmp1,tmp0
0051 26E2 06C4  14         swpb  tmp0                  ; X<->Y
0052 26E4 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26E6 2020 
0053 26E8 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26EA 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26EC 2012 
0059 26EE 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26F0 2024 
0060 26F2 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26F4 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26F6 0050            data   80
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
0013 26F8 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26FA 06A0  32         bl    @putvr                ; Write once
     26FC 2334 
0015 26FE 391C             data  >391c                 ; VR1/57, value 00011100
0016 2700 06A0  32         bl    @putvr                ; Write twice
     2702 2334 
0017 2704 391C             data  >391c                 ; VR1/57, value 00011100
0018 2706 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2708 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 270A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     270C 2334 
0028 270E 391C             data  >391c
0029 2710 0458  20         b     *tmp4                 ; Exit
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
0040 2712 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2714 06A0  32         bl    @cpym2v
     2716 244C 
0042 2718 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     271A 2756 
     271C 0006 
0043 271E 06A0  32         bl    @putvr
     2720 2334 
0044 2722 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2724 06A0  32         bl    @putvr
     2726 2334 
0046 2728 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 272A 0204  20         li    tmp0,>3f00
     272C 3F00 
0052 272E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     2730 22BC 
0053 2732 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2734 8800 
0054 2736 0984  56         srl   tmp0,8
0055 2738 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     273A 8800 
0056 273C C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 273E 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 2740 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2742 BFFF 
0060 2744 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2746 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2748 4000 
0063               f18chk_exit:
0064 274A 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     274C 2290 
0065 274E 3F00             data  >3f00,>00,6
     2750 0000 
     2752 0006 
0066 2754 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2756 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2758 3F00             data  >3f00                 ; 3f02 / 3f00
0073 275A 0340             data  >0340                 ; 3f04   0340  idle
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
0092 275C C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 275E 06A0  32         bl    @putvr
     2760 2334 
0097 2762 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2764 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2766 2334 
0100 2768 391C             data  >391c                 ; Lock the F18a
0101 276A 0458  20         b     *tmp4                 ; Exit
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
0120 276C C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 276E 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     2770 201E 
0122 2772 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2774 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2776 8802 
0127 2778 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     277A 2334 
0128 277C 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 277E 04C4  14         clr   tmp0
0130 2780 D120  34         movb  @vdps,tmp0
     2782 8802 
0131 2784 0984  56         srl   tmp0,8
0132 2786 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2788 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     278A 832A 
0018 278C D17B  28         movb  *r11+,tmp1
0019 278E 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 2790 D1BB  28         movb  *r11+,tmp2
0021 2792 0986  56         srl   tmp2,8                ; Repeat count
0022 2794 C1CB  18         mov   r11,tmp3
0023 2796 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2798 23FC 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 279A 020B  20         li    r11,hchar1
     279C 27A2 
0028 279E 0460  28         b     @xfilv                ; Draw
     27A0 2296 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27A2 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27A4 2022 
0033 27A6 1302  14         jeq   hchar2                ; Yes, exit
0034 27A8 C2C7  18         mov   tmp3,r11
0035 27AA 10EE  14         jmp   hchar                 ; Next one
0036 27AC 05C7  14 hchar2  inct  tmp3
0037 27AE 0457  20         b     *tmp3                 ; Exit
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
0016 27B0 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27B2 2020 
0017 27B4 020C  20         li    r12,>0024
     27B6 0024 
0018 27B8 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27BA 284C 
0019 27BC 04C6  14         clr   tmp2
0020 27BE 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27C0 04CC  14         clr   r12
0025 27C2 1F08  20         tb    >0008                 ; Shift-key ?
0026 27C4 1302  14         jeq   realk1                ; No
0027 27C6 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27C8 287C 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27CA 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27CC 1302  14         jeq   realk2                ; No
0033 27CE 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27D0 28AC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27D2 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27D4 1302  14         jeq   realk3                ; No
0039 27D6 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27D8 28DC 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27DA 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27DC 200C 
0044 27DE 1E15  20         sbz   >0015                 ; Set P5
0045 27E0 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27E2 1302  14         jeq   realk4                ; No
0047 27E4 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27E6 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27E8 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27EA 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27EC 0006 
0053 27EE 0606  14 realk5  dec   tmp2
0054 27F0 020C  20         li    r12,>24               ; CRU address for P2-P4
     27F2 0024 
0055 27F4 06C6  14         swpb  tmp2
0056 27F6 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 27F8 06C6  14         swpb  tmp2
0058 27FA 020C  20         li    r12,6                 ; CRU read address
     27FC 0006 
0059 27FE 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2800 0547  14         inv   tmp3                  ;
0061 2802 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2804 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2806 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2808 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 280A 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 280C 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 280E 0285  22         ci    tmp1,8
     2810 0008 
0070 2812 1AFA  14         jl    realk6
0071 2814 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2816 1BEB  14         jh    realk5                ; No, next column
0073 2818 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 281A C206  18 realk8  mov   tmp2,tmp4
0078 281C 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 281E A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2820 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2822 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2824 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2826 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2828 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     282A 200C 
0089 282C 1608  14         jne   realka                ; No, continue saving key
0090 282E 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2830 2876 
0091 2832 1A05  14         jl    realka
0092 2834 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2836 2874 
0093 2838 1B02  14         jh    realka                ; No, continue
0094 283A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     283C E000 
0095 283E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2840 833C 
0096 2842 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2844 200A 
0097 2846 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2848 8C00 
0098                                                   ; / using R15 as temp storage
0099 284A 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 284C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     284E 0000 
     2850 FF0D 
     2852 203D 
0102 2854 ....             text  'xws29ol.'
0103 285C ....             text  'ced38ik,'
0104 2864 ....             text  'vrf47ujm'
0105 286C ....             text  'btg56yhn'
0106 2874 ....             text  'zqa10p;/'
0107 287C FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     287E 0000 
     2880 FF0D 
     2882 202B 
0108 2884 ....             text  'XWS@(OL>'
0109 288C ....             text  'CED#*IK<'
0110 2894 ....             text  'VRF$&UJM'
0111 289C ....             text  'BTG%^YHN'
0112 28A4 ....             text  'ZQA!)P:-'
0113 28AC FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28AE 0000 
     28B0 FF0D 
     28B2 2005 
0114 28B4 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28B6 0804 
     28B8 0F27 
     28BA C2B9 
0115 28BC 600B             data  >600b,>0907,>063f,>c1B8
     28BE 0907 
     28C0 063F 
     28C2 C1B8 
0116 28C4 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28C6 7B02 
     28C8 015F 
     28CA C0C3 
0117 28CC BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28CE 7D0E 
     28D0 0CC6 
     28D2 BFC4 
0118 28D4 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28D6 7C03 
     28D8 BC22 
     28DA BDBA 
0119 28DC FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28DE 0000 
     28E0 FF0D 
     28E2 209D 
0120 28E4 9897             data  >9897,>93b2,>9f8f,>8c9B
     28E6 93B2 
     28E8 9F8F 
     28EA 8C9B 
0121 28EC 8385             data  >8385,>84b3,>9e89,>8b80
     28EE 84B3 
     28F0 9E89 
     28F2 8B80 
0122 28F4 9692             data  >9692,>86b4,>b795,>8a8D
     28F6 86B4 
     28F8 B795 
     28FA 8A8D 
0123 28FC 8294             data  >8294,>87b5,>b698,>888E
     28FE 87B5 
     2900 B698 
     2902 888E 
0124 2904 9A91             data  >9a91,>81b1,>b090,>9cBB
     2906 81B1 
     2908 B090 
     290A 9CBB 
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
0023 290C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 290E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2910 8340 
0025 2912 04E0  34         clr   @waux1
     2914 833C 
0026 2916 04E0  34         clr   @waux2
     2918 833E 
0027 291A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     291C 833C 
0028 291E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2920 0205  20         li    tmp1,4                ; 4 nibbles
     2922 0004 
0033 2924 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2926 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2928 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 292A 0286  22         ci    tmp2,>000a
     292C 000A 
0039 292E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2930 C21B  26         mov   *r11,tmp4
0045 2932 0988  56         srl   tmp4,8                ; Right justify
0046 2934 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2936 FFF6 
0047 2938 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 293A C21B  26         mov   *r11,tmp4
0054 293C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     293E 00FF 
0055               
0056 2940 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2942 06C6  14         swpb  tmp2
0058 2944 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2946 0944  56         srl   tmp0,4                ; Next nibble
0060 2948 0605  14         dec   tmp1
0061 294A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 294C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     294E BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2950 C160  34         mov   @waux3,tmp1           ; Get pointer
     2952 8340 
0067 2954 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2956 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2958 C120  34         mov   @waux2,tmp0
     295A 833E 
0070 295C 06C4  14         swpb  tmp0
0071 295E DD44  32         movb  tmp0,*tmp1+
0072 2960 06C4  14         swpb  tmp0
0073 2962 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2964 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2966 8340 
0078 2968 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     296A 2016 
0079 296C 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 296E C120  34         mov   @waux1,tmp0
     2970 833C 
0084 2972 06C4  14         swpb  tmp0
0085 2974 DD44  32         movb  tmp0,*tmp1+
0086 2976 06C4  14         swpb  tmp0
0087 2978 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 297A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     297C 2020 
0092 297E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2980 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2982 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2984 7FFF 
0098 2986 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2988 8340 
0099 298A 0460  28         b     @xutst0               ; Display string
     298C 2422 
0100 298E 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2990 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2992 832A 
0122 2994 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2996 8000 
0123 2998 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 299A 0207  20 mknum   li    tmp3,5                ; Digit counter
     299C 0005 
0020 299E C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A0 C155  26         mov   *tmp1,tmp1            ; /
0022 29A2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29A4 0228  22         ai    tmp4,4                ; Get end of buffer
     29A6 0004 
0024 29A8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29AA 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29AC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29AE 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29B2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29B4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29B6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29B8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29BA 0607  14         dec   tmp3                  ; Decrease counter
0036 29BC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29BE 0207  20         li    tmp3,4                ; Check first 4 digits
     29C0 0004 
0041 29C2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29C4 C11B  26         mov   *r11,tmp0
0043 29C6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29C8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29CA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29CC 05CB  14 mknum3  inct  r11
0047 29CE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D0 2020 
0048 29D2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29D4 045B  20         b     *r11                  ; Exit
0050 29D6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29D8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29DA 13F8  14         jeq   mknum3                ; Yes, exit
0053 29DC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29DE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E0 7FFF 
0058 29E2 C10B  18         mov   r11,tmp0
0059 29E4 0224  22         ai    tmp0,-4
     29E6 FFFC 
0060 29E8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29EA 0206  20         li    tmp2,>0500            ; String length = 5
     29EC 0500 
0062 29EE 0460  28         b     @xutstr               ; Display string
     29F0 2424 
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
0093 29F2 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 29F4 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 29F6 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 29F8 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 29FA 0207  20         li    tmp3,5                ; Set counter
     29FC 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 29FE 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A00 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A02 0584  14         inc   tmp0                  ; Next character
0105 2A04 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A06 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A08 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A0A 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A0C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A0E 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A10 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A12 0607  14         dec   tmp3                  ; Last character ?
0121 2A14 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A16 045B  20         b     *r11                  ; Return
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
0139 2A18 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A1A 832A 
0140 2A1C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A1E 8000 
0141 2A20 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A22 0649  14         dect  stack
0023 2A24 C64B  30         mov   r11,*stack            ; Save return address
0024 2A26 0649  14         dect  stack
0025 2A28 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A2A 0649  14         dect  stack
0027 2A2C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A2E 0649  14         dect  stack
0029 2A30 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A32 0649  14         dect  stack
0031 2A34 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A36 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A38 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A3A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A3C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A3E 0649  14         dect  stack
0044 2A40 C64B  30         mov   r11,*stack            ; Save return address
0045 2A42 0649  14         dect  stack
0046 2A44 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A46 0649  14         dect  stack
0048 2A48 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A4A 0649  14         dect  stack
0050 2A4C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A4E 0649  14         dect  stack
0052 2A50 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A52 C1D4  26 !       mov   *tmp0,tmp3
0057 2A54 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A56 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A58 00FF 
0059 2A5A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A5C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A5E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A60 0584  14         inc   tmp0                  ; Next byte
0067 2A62 0607  14         dec   tmp3                  ; Shorten string length
0068 2A64 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A66 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A68 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A6A C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A6C 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A6E C187  18         mov   tmp3,tmp2
0078 2A70 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A72 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A74 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A76 24A6 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A78 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A7A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A7C FFCE 
0090 2A7E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A80 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A82 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A84 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A86 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A8A C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A8C 045B  20         b     *r11                  ; Return to caller
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
0123 2A8E 0649  14         dect  stack
0124 2A90 C64B  30         mov   r11,*stack            ; Save return address
0125 2A92 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A94 05D9  26         inct  *stack                ; Skip "data P1"
0127 2A96 0649  14         dect  stack
0128 2A98 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2A9A 0649  14         dect  stack
0130 2A9C C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2A9E 0649  14         dect  stack
0132 2AA0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AA2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AA4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AA6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AA8 0649  14         dect  stack
0144 2AAA C64B  30         mov   r11,*stack            ; Save return address
0145 2AAC 0649  14         dect  stack
0146 2AAE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AB0 0649  14         dect  stack
0148 2AB2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AB4 0649  14         dect  stack
0150 2AB6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AB8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2ABA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2ABC 0586  14         inc   tmp2
0161 2ABE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AC0 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2AC2 0286  22         ci    tmp2,255
     2AC4 00FF 
0167 2AC6 1505  14         jgt   string.getlenc.panic
0168 2AC8 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2ACA 0606  14         dec   tmp2                  ; One time adjustment
0174 2ACC C806  38         mov   tmp2,@waux1           ; Store length
     2ACE 833C 
0175 2AD0 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AD2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AD4 FFCE 
0181 2AD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AD8 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2ADA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2ADC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2ADE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AE0 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AE2 045B  20         b     *r11                  ; Return to caller
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
0056 2AE4 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AE6 2AE8             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AE8 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AEA C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AEC A428 
0064 2AEE 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AF0 201C 
0065 2AF2 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2AF4 8356 
0066 2AF6 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2AF8 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2AFA FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2AFC C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2AFE A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B00 06C0  14         swpb  r0                    ;
0075 2B02 D800  38         movb  r0,@vdpa              ; Send low byte
     2B04 8C02 
0076 2B06 06C0  14         swpb  r0                    ;
0077 2B08 D800  38         movb  r0,@vdpa              ; Send high byte
     2B0A 8C02 
0078 2B0C D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B0E 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B10 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B12 0704  14         seto  r4                    ; Init counter
0086 2B14 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B16 A420 
0087 2B18 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B1A 0584  14         inc   r4                    ; Increment char counter
0089 2B1C 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B1E 0007 
0090 2B20 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B22 80C4  18         c     r4,r3                 ; End of name?
0093 2B24 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B26 06C0  14         swpb  r0                    ;
0098 2B28 D800  38         movb  r0,@vdpa              ; Send low byte
     2B2A 8C02 
0099 2B2C 06C0  14         swpb  r0                    ;
0100 2B2E D800  38         movb  r0,@vdpa              ; Send high byte
     2B30 8C02 
0101 2B32 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B34 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B36 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B38 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B3A 2C50 
0109 2B3C 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B3E C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B40 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B42 04E0  34         clr   @>83d0
     2B44 83D0 
0118 2B46 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B48 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B4A C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B4C A432 
0121               
0122 2B4E 0584  14         inc   r4                    ; Adjust for dot
0123 2B50 A804  38         a     r4,@>8356             ; Point to position after name
     2B52 8356 
0124 2B54 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B56 8356 
     2B58 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B5A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B5C 83E0 
0130 2B5E 04C1  14         clr   r1                    ; Version found of dsr
0131 2B60 020C  20         li    r12,>0f00             ; Init cru address
     2B62 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B64 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B66 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B68 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B6A 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B6C 0100 
0145 2B6E 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B70 83D0 
0146 2B72 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B74 2000 
0147 2B76 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B78 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B7A 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B7C 1D00  20         sbo   0                     ; Turn on ROM
0154 2B7E 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B80 4000 
0155 2B82 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B84 2C4C 
0156 2B86 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B88 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B8A A40A 
0166 2B8C 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B8E C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B90 83D2 
0172                                                   ; subprogram
0173               
0174 2B92 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2B94 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2B96 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2B98 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B9A 83D2 
0183                                                   ; subprogram
0184               
0185 2B9C 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2B9E C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BA0 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BA2 D160  34         movb  @>8355,r5             ; Get length as counter
     2BA4 8355 
0195 2BA6 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BA8 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BAA 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BAC 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BAE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BB0 A420 
0206 2BB2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BB4 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BB6 0605  14         dec   r5                    ; Update loop counter
0211 2BB8 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BBA 0581  14         inc   r1                    ; Next version found
0217 2BBC C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BBE A42A 
0218 2BC0 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BC2 A42C 
0219 2BC4 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BC6 A430 
0220               
0221 2BC8 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BCA 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BCC 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BCE 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BD0 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BD2 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BD4 A400 
0233 2BD6 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BD8 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BDA A428 
0239                                                   ; (8 or >a)
0240 2BDC 0281  22         ci    r1,8                  ; was it 8?
     2BDE 0008 
0241 2BE0 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BE2 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BE4 8350 
0243                                                   ; Get error byte from @>8350
0244 2BE6 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BE8 06C0  14         swpb  r0                    ;
0252 2BEA D800  38         movb  r0,@vdpa              ; send low byte
     2BEC 8C02 
0253 2BEE 06C0  14         swpb  r0                    ;
0254 2BF0 D800  38         movb  r0,@vdpa              ; send high byte
     2BF2 8C02 
0255 2BF4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BF6 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2BF8 09D1  56         srl   r1,13                 ; just keep error bits
0263 2BFA 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2BFC 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2BFE 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C00 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C02 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C04 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C06 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C08 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C0A F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C0C 201C 
0281                                                   ; / to indicate error
0282 2C0E 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C10 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C12 2C14             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C14 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C16 83E0 
0316               
0317 2C18 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C1A 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C1C 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C1E A42A 
0322 2C20 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C22 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C24 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C26 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C28 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C2A C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C2C 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C2E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C30 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C32 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C34 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C36 4000 
     2C38 2C4C 
0337 2C3A 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C3C 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C3E 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C40 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C42 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C44 A400 
0355 2C46 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C48 A434 
0356               
0357 2C4A 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C4C AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C4E 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C50 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C52 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C54 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C56 0649  14         dect  stack
0052 2C58 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C5A 0204  20         li    tmp0,dsrlnk.savcru
     2C5C A42A 
0057 2C5E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C60 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C62 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C64 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C66 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C68 37D7 
0065 2C6A C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C6C 8370 
0066                                                   ; / location
0067 2C6E C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C70 A44C 
0068 2C72 04C5  14         clr   tmp1                  ; io.op.open
0069 2C74 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2C76 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C78 0649  14         dect  stack
0097 2C7A C64B  30         mov   r11,*stack            ; Save return address
0098 2C7C 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C7E 0001 
0099 2C80 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2C82 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C84 0649  14         dect  stack
0125 2C86 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C88 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C8A 0002 
0128 2C8C 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2C8E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C90 0649  14         dect  stack
0155 2C92 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2C94 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2C96 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2C98 0005 
0159               
0160 2C9A C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2C9C A43E 
0161               
0162 2C9E 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CA0 22CE 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CA2 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CA4 0003 
0167 2CA6 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CA8 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CAA 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CAC 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CAE 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CB0 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CB2 1000  14         nop
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
0227 2CB4 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CB6 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CB8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CBA A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CBC A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CBE 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CC0 22CE 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CC4 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CC6 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CC8 A44C 
0246               
0247 2CCA 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CCC 22CE 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CCE 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CD0 0009 
0254 2CD2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CD4 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CD6 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CD8 8322 
     2CDA 833C 
0259               
0260 2CDC C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CDE A42A 
0261 2CE0 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CE2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CE4 2AE4 
0268 2CE6 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CE8 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CEA 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CEC 2C10 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CEE 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CF0 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2CF2 833C 
     2CF4 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2CF6 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2CF8 A436 
0292 2CFA 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2CFC 0005 
0293 2CFE 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D00 22E6 
0294 2D02 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D04 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D06 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D08 045B  20         b     *r11                  ; Return to caller
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
0020 2D0A 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D0C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D0E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D10 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D12 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D14 201C 
0029 2D16 1602  14         jne   tmgr1a                ; No, so move on
0030 2D18 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D1A 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D1C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D1E 2020 
0035 2D20 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D22 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D24 2010 
0048 2D26 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D28 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D2A 200E 
0050 2D2C 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D2E 0460  28         b     @kthread              ; Run kernel thread
     2D30 2DA8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D32 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D34 2014 
0056 2D36 13EB  14         jeq   tmgr1
0057 2D38 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D3A 2012 
0058 2D3C 16E8  14         jne   tmgr1
0059 2D3E C120  34         mov   @wtiusr,tmp0
     2D40 832E 
0060 2D42 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D44 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D46 2DA6 
0065 2D48 C10A  18         mov   r10,tmp0
0066 2D4A 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D4C 00FF 
0067 2D4E 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D50 201C 
0068 2D52 1303  14         jeq   tmgr5
0069 2D54 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D56 003C 
0070 2D58 1002  14         jmp   tmgr6
0071 2D5A 0284  22 tmgr5   ci    tmp0,50
     2D5C 0032 
0072 2D5E 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D60 1001  14         jmp   tmgr8
0074 2D62 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D64 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D66 832C 
0079 2D68 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D6A FF00 
0080 2D6C C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D6E 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D70 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D72 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D74 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D76 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D78 830C 
     2D7A 830D 
0089 2D7C 1608  14         jne   tmgr10                ; No, get next slot
0090 2D7E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D80 FF00 
0091 2D82 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D84 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D86 8330 
0096 2D88 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D8A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D8C 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D8E 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D90 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D92 8315 
     2D94 8314 
0103 2D96 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D98 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D9A 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D9C 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D9E 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DA0 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DA2 FF00 
0109 2DA4 10B4  14         jmp   tmgr1
0110 2DA6 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DA8 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DAA 2010 
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
0041 2DAC 06A0  32         bl    @realkb               ; Scan full keyboard
     2DAE 27B0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DB0 0460  28         b     @tmgr3                ; Exit
     2DB2 2D32 
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
0017 2DB4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DB6 832E 
0018 2DB8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DBA 2012 
0019 2DBC 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D0E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DBE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DC0 832E 
0029 2DC2 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DC4 FEFF 
0030 2DC6 045B  20         b     *r11                  ; Return
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
0017 2DC8 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DCA C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DCC C184  18         mov   tmp0,tmp2
0023 2DCE 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DD0 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DD2 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DD4 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DD6 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DD8 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DDA 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DDC 2022 
0035 2DDE 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DE0 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DE2 05CB  14 mkslo1  inct  r11
0041 2DE4 045B  20         b     *r11                  ; Exit
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
0052 2DE6 C13B  30 clslot  mov   *r11+,tmp0
0053 2DE8 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DEA A120  34         a     @wtitab,tmp0          ; Add table base
     2DEC 832C 
0055 2DEE 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DF0 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DF2 045B  20         b     *r11                  ; Exit
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
0068 2DF4 C13B  30 rsslot  mov   *r11+,tmp0
0069 2DF6 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2DF8 A120  34         a     @wtitab,tmp0          ; Add table base
     2DFA 832C 
0071 2DFC 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2DFE C154  26         mov   *tmp0,tmp1
0073 2E00 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E02 FF00 
0074 2E04 C505  30         mov   tmp1,*tmp0
0075 2E06 045B  20         b     *r11                  ; Exit
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
0260 2E08 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E0A 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E0C 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E0E 0000 
0266 2E10 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E12 8300 
0267 2E14 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E16 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E18 0202  20 runli2  li    r2,>8308
     2E1A 8308 
0272 2E1C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E1E 0282  22         ci    r2,>8400
     2E20 8400 
0274 2E22 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E24 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E26 FFFF 
0279 2E28 1602  14         jne   runli4                ; No, continue
0280 2E2A 0420  54         blwp  @0                    ; Yes, bye bye
     2E2C 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E2E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E30 833C 
0285 2E32 04C1  14         clr   r1                    ; Reset counter
0286 2E34 0202  20         li    r2,10                 ; We test 10 times
     2E36 000A 
0287 2E38 C0E0  34 runli5  mov   @vdps,r3
     2E3A 8802 
0288 2E3C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E3E 2020 
0289 2E40 1302  14         jeq   runli6
0290 2E42 0581  14         inc   r1                    ; Increase counter
0291 2E44 10F9  14         jmp   runli5
0292 2E46 0602  14 runli6  dec   r2                    ; Next test
0293 2E48 16F7  14         jne   runli5
0294 2E4A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E4C 1250 
0295 2E4E 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E50 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E52 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E54 06A0  32 runli7  bl    @loadmc
     2E56 221C 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E58 04C1  14 runli9  clr   r1
0305 2E5A 04C2  14         clr   r2
0306 2E5C 04C3  14         clr   r3
0307 2E5E 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E60 3000 
0308 2E62 020F  20         li    r15,vdpw              ; Set VDP write address
     2E64 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E66 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E68 4A4A 
0317 2E6A 1605  14         jne   runlia
0318 2E6C 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E6E 2290 
0319 2E70 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E72 0000 
     2E74 3000 
0324 2E76 06A0  32 runlia  bl    @filv
     2E78 2290 
0325 2E7A 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E7C 00F4 
     2E7E 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E80 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E82 26F8 
0333 2E84 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E86 2712 
0334 2E88 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E8A 2708 
0335               
0336 2E8C 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E8E 2334 
0337 2E90 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E92 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E94 22FA 
0351 2E96 336E             data  spvmod                ; Equate selected video mode table
0352 2E98 0204  20         li    tmp0,spfont           ; Get font option
     2E9A 000C 
0353 2E9C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2E9E 1304  14         jeq   runlid                ; Yes, skip it
0355 2EA0 06A0  32         bl    @ldfnt
     2EA2 2362 
0356 2EA4 1100             data  fntadr,spfont         ; Load specified font
     2EA6 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EA8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EAA 4A4A 
0361 2EAC 1602  14         jne   runlie                ; No, continue
0362 2EAE 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EB0 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EB2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EB4 0040 
0367 2EB6 0460  28         b     @main                 ; Give control to main program
     2EB8 6036 
**** **** ****     > stevie_b1.asm.464228
0040                                                   ; Relocated spectra2 in low MEMEXP, was
0041                                                   ; copied to >2000 from ROM in bank 0
0042                       ;------------------------------------------------------
0043                       ; End of File marker
0044                       ;------------------------------------------------------
0045 2EBA DEAD             data >dead,>beef,>dead,>beef
     2EBC BEEF 
     2EBE DEAD 
     2EC0 BEEF 
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
     3026 A022 
0045 3028 0647  14         dect  tmp3
0046 302A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0047 302C 0647  14         dect  tmp3
0048 302E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0049 3030 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3032 A022 
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
     3048 A022 
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
     3062 A022 
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
0022                       ;------------------------------------------------------
0023                       ; Initialize
0024                       ;------------------------------------------------------
0025 307E 0204  20         li    tmp0,fb.top
     3080 A600 
0026 3082 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3084 A100 
0027 3086 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3088 A104 
0028 308A 04E0  34         clr   @fb.row               ; Current row=0
     308C A106 
0029 308E 04E0  34         clr   @fb.column            ; Current column=0
     3090 A10C 
0030               
0031 3092 0204  20         li    tmp0,colrow
     3094 0050 
0032 3096 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     3098 A10E 
0033               
0034 309A 0204  20         li    tmp0,28
     309C 001C 
0035 309E C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 28
     30A0 A11A 
0036 30A2 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30A4 A11C 
0037               
0038 30A6 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30A8 A01E 
0039 30AA 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30AC A110 
0040 30AE 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30B0 A116 
0041 30B2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30B4 A118 
0042                       ;------------------------------------------------------
0043                       ; Clear frame buffer
0044                       ;------------------------------------------------------
0045 30B6 06A0  32         bl    @film
     30B8 2238 
0046 30BA A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30BC 0000 
     30BE 0960 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               fb.init.exit:
0051 30C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 30C2 045B  20         b     *r11                  ; Return to caller
0053               
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
0046 30C4 0649  14         dect  stack
0047 30C6 C64B  30         mov   r11,*stack            ; Save return address
0048 30C8 0649  14         dect  stack
0049 30CA C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30CC 0204  20         li    tmp0,idx.top
     30CE B000 
0054 30D0 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30D2 A202 
0055               
0056 30D4 C120  34         mov   @tv.sams.b000,tmp0
     30D6 A006 
0057 30D8 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     30DA A500 
0058 30DC C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     30DE A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 30E0 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     30E2 0004 
0063 30E4 C804  38         mov   tmp0,@idx.sams.hipage ; /
     30E6 A504 
0064               
0065 30E8 06A0  32         bl    @_idx.sams.mapcolumn.on
     30EA 3106 
0066                                                   ; Index in continuous memory region
0067               
0068 30EC 06A0  32         bl    @film
     30EE 2238 
0069 30F0 B000                   data idx.top,>00,idx.size * 5
     30F2 0000 
     30F4 5000 
0070                                                   ; Clear index
0071               
0072 30F6 06A0  32         bl    @_idx.sams.mapcolumn.off
     30F8 313A 
0073                                                   ; Restore memory window layout
0074               
0075 30FA C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     30FC A502 
     30FE A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 3100 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 3102 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 3104 045B  20         b     *r11                  ; Return to caller
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
0096 3106 0649  14         dect  stack
0097 3108 C64B  30         mov   r11,*stack            ; Push return address
0098 310A 0649  14         dect  stack
0099 310C C644  30         mov   tmp0,*stack           ; Push tmp0
0100 310E 0649  14         dect  stack
0101 3110 C645  30         mov   tmp1,*stack           ; Push tmp1
0102 3112 0649  14         dect  stack
0103 3114 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 3116 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3118 A502 
0108 311A 0205  20         li    tmp1,idx.top
     311C B000 
0109 311E 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3120 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 3122 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3124 253C 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 3126 0584  14         inc   tmp0                  ; Next SAMS index page
0118 3128 0225  22         ai    tmp1,>1000            ; Next memory region
     312A 1000 
0119 312C 0606  14         dec   tmp2                  ; Update loop counter
0120 312E 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 3130 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 3132 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 3134 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 3136 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3138 045B  20         b     *r11                  ; Return to caller
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
0145 313A 0649  14         dect  stack
0146 313C C64B  30         mov   r11,*stack            ; Push return address
0147 313E 0649  14         dect  stack
0148 3140 C644  30         mov   tmp0,*stack           ; Push tmp0
0149 3142 0649  14         dect  stack
0150 3144 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 3146 0649  14         dect  stack
0152 3148 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 314A 0649  14         dect  stack
0154 314C C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 314E 0205  20         li    tmp1,idx.top
     3150 B000 
0159 3152 0206  20         li    tmp2,5                ; Always 5 pages
     3154 0005 
0160 3156 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3158 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 315A C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 315C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     315E 253C 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 3160 0225  22         ai    tmp1,>1000            ; Next memory region
     3162 1000 
0171 3164 0606  14         dec   tmp2                  ; Update loop counter
0172 3166 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3168 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 316A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 316C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 316E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 3170 C2F9  30         mov   *stack+,r11           ; Pop return address
0182 3172 045B  20         b     *r11                  ; Return to caller
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
0206 3174 0649  14         dect  stack
0207 3176 C64B  30         mov   r11,*stack            ; Save return address
0208 3178 0649  14         dect  stack
0209 317A C644  30         mov   tmp0,*stack           ; Push tmp0
0210 317C 0649  14         dect  stack
0211 317E C645  30         mov   tmp1,*stack           ; Push tmp1
0212 3180 0649  14         dect  stack
0213 3182 C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 3184 C184  18         mov   tmp0,tmp2             ; Line number
0218 3186 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 3188 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     318A 0800 
0220               
0221 318C 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 318E 0A16  56         sla   tmp2,1                ; line number * 2
0226 3190 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3192 2F30 
0227               
0228 3194 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3196 A502 
0229 3198 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     319A A500 
0230               
0231 319C 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 319E C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31A0 A500 
0237 31A2 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31A4 A006 
0238               
0239 31A6 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31A8 0205  20         li    tmp1,>b000            ; Memory window for index page
     31AA B000 
0241               
0242 31AC 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31AE 253C 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31B0 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31B2 A504 
0249 31B4 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31B6 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31B8 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31BA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31BC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31C2 045B  20         b     *r11                  ; Return to caller
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
0022 31C4 0649  14         dect  stack
0023 31C6 C64B  30         mov   r11,*stack            ; Save return address
0024 31C8 0649  14         dect  stack
0025 31CA C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31CC 0204  20         li    tmp0,edb.top          ; \
     31CE C000 
0030 31D0 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31D2 A200 
0031 31D4 C804  38         mov   tmp0,@edb.next_free.ptr
     31D6 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 31D8 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31DA A20A 
0035               
0036 31DC 0204  20         li    tmp0,1
     31DE 0001 
0037 31E0 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31E2 A204 
0038               
0039 31E4 0720  34         seto  @edb.block.m1         ; Reset block start line
     31E6 A20C 
0040 31E8 0720  34         seto  @edb.block.m2         ; Reset block end line
     31EA A20E 
0041               
0042 31EC 0204  20         li    tmp0,txt.newfile      ; "New file"
     31EE 369A 
0043 31F0 C804  38         mov   tmp0,@edb.filename.ptr
     31F2 A212 
0044               
0045 31F4 0204  20         li    tmp0,txt.filetype.none
     31F6 36E6 
0046 31F8 C804  38         mov   tmp0,@edb.filetype.ptr
     31FA A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 31FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 31FE C2F9  30         mov   *stack+,r11           ; Pop r11
0054 3200 045B  20         b     *r11                  ; Return to caller
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
0022 3202 0649  14         dect  stack
0023 3204 C64B  30         mov   r11,*stack            ; Save return address
0024 3206 0649  14         dect  stack
0025 3208 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 320A 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     320C D000 
0030 320E C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3210 A300 
0031               
0032 3212 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3214 A302 
0033 3216 0204  20         li    tmp0,4
     3218 0004 
0034 321A C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     321C A306 
0035 321E C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3220 A308 
0036               
0037 3222 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3224 A316 
0038 3226 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3228 A318 
0039 322A 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     322C A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 322E 06A0  32         bl    @film
     3230 2238 
0044 3232 D000             data  cmdb.top,>00,cmdb.size
     3234 0000 
     3236 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3238 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 323A C2F9  30         mov   *stack+,r11           ; Pop r11
0052 323C 045B  20         b     *r11                  ; Return to caller
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
0022 323E 0649  14         dect  stack
0023 3240 C64B  30         mov   r11,*stack            ; Save return address
0024 3242 0649  14         dect  stack
0025 3244 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3246 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3248 A024 
0030               
0031 324A 06A0  32         bl    @film
     324C 2238 
0032 324E A026                   data tv.error.msg,0,160
     3250 0000 
     3252 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3254 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3256 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3258 045B  20         b     *r11                  ; Return to caller
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
0022 325A 0649  14         dect  stack
0023 325C C64B  30         mov   r11,*stack            ; Save return address
0024 325E 0649  14         dect  stack
0025 3260 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3262 0204  20         li    tmp0,1                ; \ Set default color scheme
     3264 0001 
0030 3266 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3268 A012 
0031               
0032 326A 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     326C A020 
0033 326E E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3270 200C 
0034               
0035 3272 0204  20         li    tmp0,fj.bottom
     3274 F000 
0036 3276 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3278 A022 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 327A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 327C C2F9  30         mov   *stack+,r11           ; Pop R11
0043 327E 045B  20         b     *r11                  ; Return to caller
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
0065 3280 0649  14         dect  stack
0066 3282 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 3284 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3286 3202 
0071 3288 06A0  32         bl    @edb.init             ; Initialize editor buffer
     328A 31C4 
0072 328C 06A0  32         bl    @idx.init             ; Initialize index
     328E 30C4 
0073 3290 06A0  32         bl    @fb.init              ; Initialize framebuffer
     3292 307A 
0074 3294 06A0  32         bl    @errline.init         ; Initialize error line
     3296 323E 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 3298 06A0  32         bl    @hchar
     329A 2788 
0079 329C 0034                   byte 0,52,32,18           ; Remove markers
     329E 2012 
0080 32A0 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     32A2 2032 
0081 32A4 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32A6 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32A8 045B  20         b     *r11                  ; Return to caller
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
0020 32AA 0649  14         dect  stack
0021 32AC C64B  30         mov   r11,*stack            ; Save return address
0022 32AE 0649  14         dect  stack
0023 32B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32B2 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32B4 299A 
0028 32B6 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32B8 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32BA 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32BC 0204  20         li    tmp0,unpacked.string
     32BE 2F44 
0034 32C0 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32C2 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32C4 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32C6 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32C8 29F2 
0039 32CA 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32CC 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32CE 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32D0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32D2 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 32D4 045B  20         b     *r11                  ; Return to caller
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
0073 32D6 0649  14         dect  stack
0074 32D8 C64B  30         mov   r11,*stack            ; Push return address
0075 32DA 0649  14         dect  stack
0076 32DC C644  30         mov   tmp0,*stack           ; Push tmp0
0077 32DE 0649  14         dect  stack
0078 32E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 32E2 0649  14         dect  stack
0080 32E4 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 32E6 0649  14         dect  stack
0082 32E8 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 32EA C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     32EC 2F20 
0087 32EE D194  26         movb  *tmp0,tmp2            ; /
0088 32F0 0986  56         srl   tmp2,8                ; Right align
0089 32F2 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 32F4 8806  38         c     tmp2,@parm2           ; String length > requested length?
     32F6 2F22 
0092 32F8 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 32FA C120  34         mov   @parm1,tmp0           ; Get source address
     32FC 2F20 
0097 32FE C160  34         mov   @parm4,tmp1           ; Get destination address
     3300 2F26 
0098 3302 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3304 0649  14         dect  stack
0101 3306 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 3308 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     330A 24A6 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 330C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 330E C120  34         mov   @parm2,tmp0           ; Get requested length
     3310 2F22 
0113 3312 0A84  56         sla   tmp0,8                ; Left align
0114 3314 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3316 2F26 
0115 3318 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 331A A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 331C 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 331E C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3320 2F22 
0122 3322 6187  18         s     tmp3,tmp2             ; |
0123 3324 0586  14         inc   tmp2                  ; /
0124               
0125 3326 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3328 2F24 
0126 332A 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 332C DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 332E 0606  14         dec   tmp2                  ; Update loop counter
0133 3330 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 3332 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3334 2F26 
     3336 2F30 
0136 3338 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 333A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     333C FFCE 
0142 333E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3340 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 3342 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3344 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3346 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3348 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 334A C2F9  30         mov   *stack+,r11           ; Pop r11
0152 334C 045B  20         b     *r11                  ; Return to caller
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
0017 334E 0649  14         dect  stack
0018 3350 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 3352 06A0  32         bl    @sams.layout
     3354 25A8 
0023 3356 3414                   data mem.sams.layout.data
0024               
0025 3358 06A0  32         bl    @sams.layout.copy
     335A 260C 
0026 335C A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 335E C820  54         mov   @tv.sams.c000,@edb.sams.page
     3360 A008 
     3362 A216 
0029 3364 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3366 A216 
     3368 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 336A C2F9  30         mov   *stack+,r11           ; Pop r11
0036 336C 045B  20         b     *r11                  ; Return to caller
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
0033 336E 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3370 003F 
     3372 0243 
     3374 05F4 
     3376 0050 
0034               
0035               romsat:
0036 3378 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     337A 0001 
0037               
0038               cursors:
0039 337C 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     337E 0000 
     3380 0000 
     3382 001C 
0040 3384 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     3386 1010 
     3388 1010 
     338A 1000 
0041 338C 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     338E 1C1C 
     3390 1C1C 
     3392 1C00 
0042               
0043               patterns:
0044 3394 0000             data  >0000,>0000,>ff00,>0000 ; 01. Single line
     3396 0000 
     3398 FF00 
     339A 0000 
0045 339C 8080             data  >8080,>8080,>ff80,>8080 ; 02. Connector |-
     339E 8080 
     33A0 FF80 
     33A2 8080 
0046 33A4 0404             data  >0404,>0404,>ff04,>0404 ; 03. Connector -|
     33A6 0404 
     33A8 FF04 
     33AA 0404 
0047               
0048               patterns.box:
0049 33AC 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     33AE 0000 
     33B0 FF80 
     33B2 BFA0 
0050 33B4 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     33B6 0000 
     33B8 FC04 
     33BA F414 
0051 33BC A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     33BE A0A0 
     33C0 A0A0 
     33C2 A0A0 
0052 33C4 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     33C6 1414 
     33C8 1414 
     33CA 1414 
0053 33CC A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     33CE A0A0 
     33D0 BF80 
     33D2 FF00 
0054 33D4 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     33D6 1414 
     33D8 F404 
     33DA FC00 
0055 33DC 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     33DE C0C0 
     33E0 C0C0 
     33E2 0080 
0056 33E4 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     33E6 0F0F 
     33E8 0F0F 
     33EA 0000 
0057               
0058               
0059               patterns.cr:
0060 33EC 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     33EE 6C48 
     33F0 4800 
     33F2 7C00 
0061 33F4 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     33F6 64FC 
     33F8 6020 
     33FA 0000 
0062               
0063               
0064               alphalock:
0065 33FC 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     33FE 00E0 
     3400 E0E0 
     3402 E0E0 
0066 3404 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     3406 E0E0 
     3408 E0E0 
     340A 0000 
0067               
0068               
0069               vertline:
0070 340C 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     340E 1010 
     3410 1010 
     3412 1010 
0071               
0072               
0073               ***************************************************************
0074               * SAMS page layout table for Stevie (16 words)
0075               *--------------------------------------------------------------
0076               mem.sams.layout.data:
0077 3414 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     3416 0002 
0078 3418 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     341A 0003 
0079 341C A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     341E 000A 
0080               
0081 3420 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     3422 0010 
0082                                                   ; \ The index can allocate
0083                                                   ; / pages >10 to >2f.
0084               
0085 3424 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     3426 0030 
0086                                                   ; \ Editor buffer can allocate
0087                                                   ; / pages >30 to >ff.
0088               
0089 3428 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     342A 000D 
0090 342C E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     342E 000E 
0091 3430 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     3432 000F 
0092               
0093               
0094               
0095               
0096               
0097               ***************************************************************
0098               * Stevie color schemes table
0099               *--------------------------------------------------------------
0100               * Word 1
0101               * A  MSB  high-nibble    Foreground color text line in frame buffer
0102               * B  MSB  low-nibble     Background color text line in frame buffer
0103               * C  LSB  high-nibble    Foreground color top/bottom line
0104               * D  LSB  low-nibble     Background color top/bottom line
0105               *
0106               * Word 2
0107               * E  MSB  high-nibble    Foreground color cmdb pane
0108               * F  MSB  low-nibble     Background color cmdb pane
0109               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0110               * H  LSB  low-nibble     Cursor foreground color frame buffer
0111               *
0112               * Word 3
0113               * I  MSB  high-nibble    Foreground color busy top/bottom line
0114               * J  MSB  low-nibble     Background color busy top/bottom line
0115               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0116               * L  LSB  low-nibble     Background color marked line in frame buffer
0117               *
0118               * Word 4
0119               * M  MSB  high-nibble    0
0120               * N  MSB  low-nibble     0
0121               * O  LSB  high-nibble    0
0122               * P  LSB  low-nibble     0
0123               *
0124               * Colors
0125               * 0  Transparant
0126               * 1  black
0127               * 2  Green
0128               * 3  Light Green
0129               * 4  Blue
0130               * 5  Light Blue
0131               * 6  Dark Red
0132               * 7  Cyan
0133               * 8  Red
0134               * 9  Light Red
0135               * A  Yellow
0136               * B  Light Yellow
0137               * C  Dark Green
0138               * D  Magenta
0139               * E  Grey
0140               * F  White
0141               *--------------------------------------------------------------
0142      0009     tv.colorscheme.entries   equ 9 ; Entries in table
0143               
0144               tv.colorscheme.table:
0145               ;                              ; #
0146               ;       ABCD  EFGH  IJKL  MNOP ; -
0147 3434 F417      data  >f417,>f171,>1b1f,>0000 ; 1  White on blue with inversed cyan border
     3436 F171 
     3438 1B1F 
     343A 0000 
0148 343C F41F      data  >f41f,>f011,>1a17,>0000 ; 2  White on blue with inversed white border
     343E F011 
     3440 1A17 
     3442 0000 
0149 3444 A11A      data  >a11a,>f0ff,>1f1a,>0000 ; 3  Dark yellow on black with inversed border
     3446 F0FF 
     3448 1F1A 
     344A 0000 
0150 344C 2112      data  >2112,>f0ff,>1b12,>0000 ; 4  Dark green on black with inversed border
     344E F0FF 
     3450 1B12 
     3452 0000 
0151 3454 E11E      data  >e11e,>f00f,>1b1e,>0000 ; 5  Grey on black with inversed grey border
     3456 F00F 
     3458 1B1E 
     345A 0000 
0152 345C 1771      data  >1771,>1006,>1b71,>0000 ; 6  Black on cyan with inversed black border
     345E 1006 
     3460 1B71 
     3462 0000 
0153 3464 1FF1      data  >1ff1,>1001,>1bf1,>0000 ; 7  Black on white with inversed black border
     3466 1001 
     3468 1BF1 
     346A 0000 
0154 346C A1F0      data  >a1f0,>1a0f,>1b1a,>0000 ; 8  Dark yellow on black with white border
     346E 1A0F 
     3470 1B1A 
     3472 0000 
0155 3474 21F0      data  >21f0,>f20f,>1b12,>0000 ; 9  Dark green on black with white border
     3476 F20F 
     3478 1B12 
     347A 0000 
0156               
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
0011               txt.about.program
0012 347C 1453             byte  20
0013 347D ....             text  'Stevie v1.0 (beta 2)'
0014                       even
0015               
0016                                  even
0017               txt.about.purpose
0018 3492 2350             byte  35
0019 3493 ....             text  'Programming Editor for the TI-99/4a'
0020                       even
0021               
0022               txt.about.author
0023 34B6 1D32             byte  29
0024 34B7 ....             text  '2018-2021 by Filip Van Vooren'
0025                       even
0026               
0027               txt.about.website
0028 34D4 1B68             byte  27
0029 34D5 ....             text  'https://stevie.oratronik.de'
0030                       even
0031               
0032               txt.about.build
0033 34F0 1442             byte  20
0034 34F1 ....             text  'Build: 210127-464228'
0035                       even
0036               
0037               
0038               txt.about.msg1
0039 3506 2466             byte  36
0040 3507 ....             text  'fctn-7 (F7)   Help, shortcuts, about'
0041                       even
0042               
0043               txt.about.msg2
0044 352C 2266             byte  34
0045 352D ....             text  'fctn-9 (F9)   Toggle edit/cmd mode'
0046                       even
0047               
0048               txt.about.msg3
0049 3550 1966             byte  25
0050 3551 ....             text  'fctn-+        Quit Stevie'
0051                       even
0052               
0053               txt.about.msg4
0054 356A 1C43             byte  28
0055 356B ....             text  'CTRL-O (^O)   Open DV80 file'
0056                       even
0057               
0058               txt.about.msg5
0059 3588 1C43             byte  28
0060 3589 ....             text  'CTRL-S (^S)   Save DV80 file'
0061                       even
0062               
0063               txt.about.msg6
0064 35A6 1A43             byte  26
0065 35A7 ....             text  'CTRL-Z (^Z)   Cycle colors'
0066                       even
0067               
0068               
0069 35C2 380F     txt.about.msg7     byte    56,15
0070 35C4 ....                        text    ' ALPHA LOCK up     '
0071                                  byte    14
0072 35D8 ....                        text    ' ALPHA LOCK down   '
0073 35EB ....                        text    '  * Text changed'
0074               
0075               
0076               ;--------------------------------------------------------------
0077               ; Strings for status line pane
0078               ;--------------------------------------------------------------
0079               txt.delim
0080                       byte  1
0081 35FC ....             text  ','
0082                       even
0083               
0084               txt.marker
0085 35FE 052A             byte  5
0086 35FF ....             text  '*EOF*'
0087                       even
0088               
0089               txt.bottom
0090 3604 0520             byte  5
0091 3605 ....             text  '  BOT'
0092                       even
0093               
0094               txt.ovrwrite
0095 360A 034F             byte  3
0096 360B ....             text  'OVR'
0097                       even
0098               
0099               txt.insert
0100 360E 0349             byte  3
0101 360F ....             text  'INS'
0102                       even
0103               
0104               txt.star
0105 3612 012A             byte  1
0106 3613 ....             text  '*'
0107                       even
0108               
0109               txt.loading
0110 3614 0A4C             byte  10
0111 3615 ....             text  'Loading...'
0112                       even
0113               
0114               txt.saving
0115 3620 0A53             byte  10
0116 3621 ....             text  'Saving....'
0117                       even
0118               
0119               txt.block.del
0120 362C 1244             byte  18
0121 362D ....             text  'Deleting block....'
0122                       even
0123               
0124               txt.block.copy
0125 3640 1143             byte  17
0126 3641 ....             text  'Copying block....'
0127                       even
0128               
0129               txt.block.move
0130 3652 104D             byte  16
0131 3653 ....             text  'Moving block....'
0132                       even
0133               
0134               txt.block.save
0135 3664 1D53             byte  29
0136 3665 ....             text  'Saving block to DV80 file....'
0137                       even
0138               
0139               txt.fastmode
0140 3682 0846             byte  8
0141 3683 ....             text  'Fastmode'
0142                       even
0143               
0144               txt.kb
0145 368C 026B             byte  2
0146 368D ....             text  'kb'
0147                       even
0148               
0149               txt.lines
0150 3690 054C             byte  5
0151 3691 ....             text  'Lines'
0152                       even
0153               
0154               txt.bufnum
0155 3696 0323             byte  3
0156 3697 ....             text  '#1 '
0157                       even
0158               
0159               txt.newfile
0160 369A 0A5B             byte  10
0161 369B ....             text  '[New file]'
0162                       even
0163               
0164               txt.filetype.dv80
0165 36A6 0444             byte  4
0166 36A7 ....             text  'DV80'
0167                       even
0168               
0169               txt.m1
0170 36AC 034D             byte  3
0171 36AD ....             text  'M1='
0172                       even
0173               
0174               txt.m2
0175 36B0 034D             byte  3
0176 36B1 ....             text  'M2='
0177                       even
0178               
0179               
0180 36B4 2B5E     txt.keys.block     byte    43
0181 36B5 ....                        text    '^Del  ^Copy  ^Move  ^Goto M1  ^Reset  ^Save'
0182               
0183 36E0 010F     txt.alpha.up       data >010f
0184 36E2 010E     txt.alpha.down     data >010e
0185 36E4 0110     txt.vertline       data >0110
0186               
0187               txt.clear
0188 36E6 0420             byte  4
0189 36E7 ....             text  '    '
0190                       even
0191               
0192      36E6     txt.filetype.none  equ txt.clear
0193               
0194               
0195               ;--------------------------------------------------------------
0196               ; Dialog Load DV 80 file
0197               ;--------------------------------------------------------------
0198 36EC 1301     txt.head.load      byte 19,1,3,32
     36EE 0320 
0199 36F0 ....                        text 'Open DV80 file '
0200                                  byte 2
0201               txt.hint.load
0202 3700 4746             byte  71
0203 3701 ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0204                       even
0205               
0206               txt.keys.load
0207 3748 3946             byte  57
0208 3749 ....             text  'F9=Back    F3=Clear    F5=Fastmode    F-H=Home    F-L=End'
0209                       even
0210               
0211               txt.keys.load2
0212 3782 3946             byte  57
0213 3783 ....             text  'F9=Back    F3=Clear   *F5=Fastmode    F-H=Home    F-L=End'
0214                       even
0215               
0216               
0217               ;--------------------------------------------------------------
0218               ; Dialog Save DV 80 file
0219               ;--------------------------------------------------------------
0220 37BC 1301     txt.head.save      byte 19,1,3,32
     37BE 0320 
0221 37C0 ....                        text 'Save DV80 file '
0222                                  byte 2
0223 37D0 2301     txt.head.save2     byte 35,1,3,32
     37D2 0320 
0224 37D4 ....                        text 'Save marked block to DV80 file '
0225                                  byte 2
0226               txt.hint.save
0227 37F4 0120             byte  1
0228 37F5 ....             text  ' '
0229                       even
0230               
0231               txt.keys.save
0232 37F6 2A46             byte  42
0233 37F7 ....             text  'F9=Back    F3=Clear    F-H=Home    F-L=End'
0234                       even
0235               
0236               
0237               ;--------------------------------------------------------------
0238               ; Dialog "Unsaved changes"
0239               ;--------------------------------------------------------------
0240 3822 1401     txt.head.unsaved   byte 20,1,3,32
     3824 0320 
0241 3826 ....                        text 'Unsaved changes '
0242 3836 0232                        byte 2
0243               txt.info.unsaved
0244                       byte  50
0245 3838 ....             text  'You are about to lose changes to the current file!'
0246                       even
0247               
0248               txt.hint.unsaved
0249 386A 3950             byte  57
0250 386B ....             text  'Press F6 to proceed without saving or ENTER to save file.'
0251                       even
0252               
0253               txt.keys.unsaved
0254 38A4 2846             byte  40
0255 38A5 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0256                       even
0257               
0258               
0259               ;--------------------------------------------------------------
0260               ; Dialog "About"
0261               ;--------------------------------------------------------------
0262 38CE 0A01     txt.head.about     byte 10,1,3,32
     38D0 0320 
0263 38D2 ....                        text 'About '
0264 38D8 0226                        byte 2
0265               txt.hint.about
0266                       byte  38
0267 38DA ....             text  'Press F9 or ENTER to return to editor.'
0268                       even
0269               
0270               txt.keys.about
0271 3900 1546             byte  21
0272 3901 ....             text  'F9=Back    ENTER=Back'
0273                       even
0274               
0275               
0276               ;--------------------------------------------------------------
0277               ; Strings for error line pane
0278               ;--------------------------------------------------------------
0279               txt.ioerr.load
0280 3916 2049             byte  32
0281 3917 ....             text  'I/O error. Failed loading file: '
0282                       even
0283               
0284               txt.ioerr.save
0285 3938 1F49             byte  31
0286 3939 ....             text  'I/O error. Failed saving file: '
0287                       even
0288               
0289               txt.memfull.load
0290 3958 4049             byte  64
0291 3959 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0292                       even
0293               
0294               txt.io.nofile
0295 399A 2149             byte  33
0296 399B ....             text  'I/O error. No filename specified.'
0297                       even
0298               
0299               txt.block.inside
0300 39BC 3445             byte  52
0301 39BD ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0302                       even
0303               
0304               
0305               
0306               ;--------------------------------------------------------------
0307               ; Strings for command buffer
0308               ;--------------------------------------------------------------
0309               txt.cmdb.title
0310 39F2 0E43             byte  14
0311 39F3 ....             text  'Command buffer'
0312                       even
0313               
0314               txt.cmdb.prompt
0315 3A02 013E             byte  1
0316 3A03 ....             text  '>'
0317                       even
0318               
0319               
0320 3A04 0C0A     txt.stevie         byte    12
0321                                  byte    10
0322 3A06 ....                        text    'Stevie v1.0 (beta 2)'
0323 3A1A 0B00                        byte    11
0324                                  even
0325               
0326               txt.colorscheme
0327 3A1C 0D43             byte  13
0328 3A1D ....             text  'Color scheme:'
0329                       even
0330               
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
0022 3A2A DEAD             data  >dead,>beef,>dead,>beef
     3A2C BEEF 
     3A2E DEAD 
     3A30 BEEF 
**** **** ****     > stevie_b1.asm.464228
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
     6046 2654 
0037               
0038 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 26F8 
0039 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 2334 
0040 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0041               
0042 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 2334 
0043 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0044               
0045 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 2334 
0046 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0047                       ;------------------------------------------------------
0048                       ; Clear screen (VDP SIT)
0049                       ;------------------------------------------------------
0050 605E 06A0  32         bl    @filv
     6060 2290 
0051 6062 0000                   data >0000,32,vdp.sit.size.80x30
     6064 0020 
     6066 0960 
0052                                                   ; Clear screen
0053                       ;------------------------------------------------------
0054                       ; Initialize high memory expansion
0055                       ;------------------------------------------------------
0056 6068 06A0  32         bl    @film
     606A 2238 
0057 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0058                       ;------------------------------------------------------
0059                       ; Setup SAMS windows
0060                       ;------------------------------------------------------
0061 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 334E 
0062                       ;------------------------------------------------------
0063                       ; Setup cursor, screen, etc.
0064                       ;------------------------------------------------------
0065 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 2674 
0066 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2684 
0067               
0068 607E 06A0  32         bl    @cpym2m
     6080 24A0 
0069 6082 3378                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F5A 
     6086 0004 
0070               
0071 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 337A 
     608C A014 
0072                                                   ; Save cursor shape & color
0073               
0074 608E 06A0  32         bl    @cpym2v
     6090 244C 
0075 6092 2800                   data sprpdt,cursors,3*8
     6094 337C 
     6096 0018 
0076                                                   ; Load sprite cursor patterns
0077               
0078 6098 06A0  32         bl    @cpym2v
     609A 244C 
0079 609C 1008                   data >1008,patterns,16*8
     609E 3394 
     60A0 0080 
0080                                                   ; Load character patterns
0081               *--------------------------------------------------------------
0082               * Initialize
0083               *--------------------------------------------------------------
0084 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 325A 
0085 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 3280 
0086                       ;------------------------------------------------------
0087                       ; Load colorscheme amd turn on screen
0088                       ;------------------------------------------------------
0089 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 780C 
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
     60B8 2694 
0098 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0099               
0100 60BC 0204  20         li    tmp0,timers
     60BE 2F4A 
0101 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0102               
0103 60C4 06A0  32         bl    @mkslot
     60C6 2DC8 
0104 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 75BC 
0105 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60CE 7638 
0106 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D2 7696 
0107 60D4 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D6 76DA 
0108 60D8 FFFF                   data eol
0109               
0110 60DA 06A0  32         bl    @mkhook
     60DC 2DB4 
0111 60DE 757E                   data hook.keyscan     ; Setup user hook
0112               
0113 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D0A 
**** **** ****     > stevie_b1.asm.464228
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
     60F0 A01E 
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
     6108 7E3C 
0032 610A 1003  14         jmp   edkey.key.check.next
0033                       ;-------------------------------------------------------
0034                       ; Load CMDB keyboard map
0035                       ;-------------------------------------------------------
0036               edkey.key.process.loadmap.cmdb:
0037 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7EFE 
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
     6124 A01E 
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
     614A A01E 
0088 614C 1602  14         jne   !                     ; No, skip frame buffer
0089 614E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6150 6704 
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
     6164 68EC 
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
     6170 75B0 
**** **** ****     > stevie_b1.asm.464228
0074                       ;-----------------------------------------------------------------------
0075                       ; Keyboard actions - Framebuffer
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
     618A 75B0 
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
     61A6 75B0 
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
     61BE 6A44 
0052 61C0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C2 A118 
0053                       ;-------------------------------------------------------
0054                       ; Exit
0055                       ;-------------------------------------------------------
0056 61C4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C6 75B0 
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
     61E0 26AC 
0073 61E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61E4 6A44 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077 61E6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61E8 75B0 
**** **** ****     > stevie_b1.asm.464228
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
0010 61F2 1324  14         jeq   !                     ; column=0 ? Skip further processing
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
0061 622C C805  38         mov   tmp1,@fb.current
     622E A102 
0062 6230 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6232 A10C 
0063 6234 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6236 26AC 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.pword.exit:
0068 6238 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     623A 6A44 
0069 623C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     623E 75B0 
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Cursor next word
0075               *---------------------------------------------------------------
0076               edkey.action.nword:
0077 6240 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6242 A118 
0078 6244 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0079 6246 C120  34         mov   @fb.column,tmp0
     6248 A10C 
0080 624A 8804  38         c     tmp0,@fb.row.length
     624C A108 
0081 624E 1428  14         jhe   !                     ; column=last char ? Skip further processing
0082                       ;-------------------------------------------------------
0083                       ; Prepare 2 char buffer
0084                       ;-------------------------------------------------------
0085 6250 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6252 A102 
0086 6254 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0087 6256 1006  14         jmp   edkey.action.nword_scan_char
0088                       ;-------------------------------------------------------
0089                       ; Multiple spaces mode
0090                       ;-------------------------------------------------------
0091               edkey.action.nword_ms:
0092 6258 0708  14         seto  tmp4                  ; Set multiple spaces mode
0093                       ;-------------------------------------------------------
0094                       ; Scan forward to first character following space
0095                       ;-------------------------------------------------------
0096               edkey.action.nword_scan
0097 625A 0585  14         inc   tmp1
0098 625C 0584  14         inc   tmp0                  ; Column++ in screen buffer
0099 625E 8804  38         c     tmp0,@fb.row.length
     6260 A108 
0100 6262 1316  14         jeq   edkey.action.nword_done
0101                                                   ; Column=last char ? Skip further processing
0102                       ;-------------------------------------------------------
0103                       ; Check character
0104                       ;-------------------------------------------------------
0105               edkey.action.nword_scan_char
0106 6264 D195  26         movb  *tmp1,tmp2            ; Get character
0107 6266 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0108 6268 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0109 626A 0986  56         srl   tmp2,8                ; Right justify
0110               
0111 626C 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     626E FFFF 
0112 6270 1604  14         jne   edkey.action.nword_scan_char_other
0113                       ;-------------------------------------------------------
0114                       ; Special handling if multiple spaces found
0115                       ;-------------------------------------------------------
0116               edkey.action.nword_scan_char_ms:
0117 6272 0286  22         ci    tmp2,32
     6274 0020 
0118 6276 160C  14         jne   edkey.action.nword_done
0119                                                   ; Exit if non-space found
0120 6278 10F0  14         jmp   edkey.action.nword_scan
0121                       ;-------------------------------------------------------
0122                       ; Normal handling
0123                       ;-------------------------------------------------------
0124               edkey.action.nword_scan_char_other:
0125 627A 0286  22         ci    tmp2,32               ; Space character found?
     627C 0020 
0126 627E 16ED  14         jne   edkey.action.nword_scan
0127                                                   ; No space found, try again
0128                       ;-------------------------------------------------------
0129                       ; Space found, now look closer
0130                       ;-------------------------------------------------------
0131 6280 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6282 2020 
0132 6284 13E9  14         jeq   edkey.action.nword_ms
0133                                                   ; Yes, so continue scanning
0134 6286 0287  22         ci    tmp3,>20ff            ; First characer is space?
     6288 20FF 
0135 628A 13E7  14         jeq   edkey.action.nword_scan
0136                       ;--------------------------------------------------------
0137                       ; Set cursor following space
0138                       ;--------------------------------------------------------
0139 628C 0585  14         inc   tmp1
0140 628E 0584  14         inc   tmp0                  ; Column++ in screen buffer
0141                       ;-------------------------------------------------------
0142                       ; Save position and position hardware cursor
0143                       ;-------------------------------------------------------
0144               edkey.action.nword_done:
0145 6290 C805  38         mov   tmp1,@fb.current
     6292 A102 
0146 6294 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6296 A10C 
0147 6298 06A0  32         bl    @xsetx                ; Set VDP cursor X
     629A 26AC 
0148                       ;-------------------------------------------------------
0149                       ; Exit
0150                       ;-------------------------------------------------------
0151               edkey.action.nword.exit:
0152 629C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     629E 6A44 
0153 62A0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62A2 75B0 
0154               
0155               
**** **** ****     > stevie_b1.asm.464228
0080                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 62A4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62A6 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 62A8 8820  54         c     @fb.row.dirty,@w$ffff
     62AA A10A 
     62AC 2022 
0013 62AE 1604  14         jne   edkey.action.up.cursor
0014 62B0 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     62B2 6E58 
0015 62B4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62B6 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Move cursor
0018                       ;-------------------------------------------------------
0019               edkey.action.up.cursor:
0020 62B8 C120  34         mov   @fb.row,tmp0
     62BA A106 
0021 62BC 150B  14         jgt   edkey.action.up.cursor_up
0022                                                   ; Move cursor up if fb.row > 0
0023 62BE C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     62C0 A104 
0024 62C2 130C  14         jeq   edkey.action.up.set_cursorx
0025                                                   ; At top, only position cursor X
0026                       ;-------------------------------------------------------
0027                       ; Scroll 1 line
0028                       ;-------------------------------------------------------
0029 62C4 0604  14         dec   tmp0                  ; fb.topline--
0030 62C6 C804  38         mov   tmp0,@parm1           ; Scroll one line up
     62C8 2F20 
0031               
0032 62CA 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     62CC 6AB4 
0033                                                   ; | i  @parm1 = Line to start with
0034                                                   ; /             (becomes @fb.topline)
0035               
0036 62CE 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     62D0 A110 
0037 62D2 1004  14         jmp   edkey.action.up.set_cursorx
0038                       ;-------------------------------------------------------
0039                       ; Move cursor up
0040                       ;-------------------------------------------------------
0041               edkey.action.up.cursor_up:
0042 62D4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62D6 A106 
0043 62D8 06A0  32         bl    @up                   ; Row-- VDP cursor
     62DA 26A2 
0044                       ;-------------------------------------------------------
0045                       ; Check line length and position cursor
0046                       ;-------------------------------------------------------
0047               edkey.action.up.set_cursorx:
0048 62DC 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62DE 7020 
0049                                                   ; | i  @fb.row        = Row in frame buffer
0050                                                   ; / o  @fb.row.length = Length of row
0051               
0052 62E0 8820  54         c     @fb.column,@fb.row.length
     62E2 A10C 
     62E4 A108 
0053 62E6 1207  14         jle   edkey.action.up.exit
0054                       ;-------------------------------------------------------
0055                       ; Adjust cursor column position
0056                       ;-------------------------------------------------------
0057 62E8 C820  54         mov   @fb.row.length,@fb.column
     62EA A108 
     62EC A10C 
0058 62EE C120  34         mov   @fb.column,tmp0
     62F0 A10C 
0059 62F2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62F4 26AC 
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.up.exit:
0064 62F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62F8 6A44 
0065 62FA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62FC 75B0 
0066               
0067               
0068               
0069               *---------------------------------------------------------------
0070               * Cursor down
0071               *---------------------------------------------------------------
0072               edkey.action.down:
0073 62FE 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6300 A106 
     6302 A204 
0074 6304 1332  14         jeq   edkey.action.down.exit
0075                                                   ; Yes, skip further processing
0076 6306 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6308 A118 
0077                       ;-------------------------------------------------------
0078                       ; Crunch current row if dirty
0079                       ;-------------------------------------------------------
0080 630A 8820  54         c     @fb.row.dirty,@w$ffff
     630C A10A 
     630E 2022 
0081 6310 1604  14         jne   edkey.action.down.move
0082 6312 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6314 6E58 
0083 6316 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6318 A10A 
0084                       ;-------------------------------------------------------
0085                       ; Move cursor
0086                       ;-------------------------------------------------------
0087               edkey.action.down.move:
0088                       ;-------------------------------------------------------
0089                       ; EOF reached?
0090                       ;-------------------------------------------------------
0091 631A C120  34         mov   @fb.topline,tmp0
     631C A104 
0092 631E A120  34         a     @fb.row,tmp0
     6320 A106 
0093 6322 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6324 A204 
0094 6326 1314  14         jeq   edkey.action.down.set_cursorx
0095                                                   ; Yes, only position cursor X
0096                       ;-------------------------------------------------------
0097                       ; Check if scrolling required
0098                       ;-------------------------------------------------------
0099 6328 C120  34         mov   @fb.scrrows,tmp0
     632A A11A 
0100 632C 0604  14         dec   tmp0
0101 632E 8120  34         c     @fb.row,tmp0
     6330 A106 
0102 6332 110A  14         jlt   edkey.action.down.cursor
0103                       ;-------------------------------------------------------
0104                       ; Scroll 1 line
0105                       ;-------------------------------------------------------
0106 6334 C820  54         mov   @fb.topline,@parm1
     6336 A104 
     6338 2F20 
0107 633A 05A0  34         inc   @parm1
     633C 2F20 
0108               
0109 633E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6340 6AB4 
0110                                                   ; | i  @parm1 = Line to start with
0111                                                   ; /             (becomes @fb.topline)
0112               
0113 6342 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6344 A110 
0114 6346 1004  14         jmp   edkey.action.down.set_cursorx
0115                       ;-------------------------------------------------------
0116                       ; Move cursor down a row, there are still rows left
0117                       ;-------------------------------------------------------
0118               edkey.action.down.cursor:
0119 6348 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     634A A106 
0120 634C 06A0  32         bl    @down                 ; Row++ VDP cursor
     634E 269A 
0121                       ;-------------------------------------------------------
0122                       ; Check line length and position cursor
0123                       ;-------------------------------------------------------
0124               edkey.action.down.set_cursorx:
0125 6350 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6352 7020 
0126                                                   ; | i  @fb.row        = Row in frame buffer
0127                                                   ; / o  @fb.row.length = Length of row
0128               
0129 6354 8820  54         c     @fb.column,@fb.row.length
     6356 A10C 
     6358 A108 
0130 635A 1207  14         jle   edkey.action.down.exit
0131                                                   ; Exit
0132                       ;-------------------------------------------------------
0133                       ; Adjust cursor column position
0134                       ;-------------------------------------------------------
0135 635C C820  54         mov   @fb.row.length,@fb.column
     635E A108 
     6360 A10C 
0136 6362 C120  34         mov   @fb.column,tmp0
     6364 A10C 
0137 6366 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6368 26AC 
0138                       ;-------------------------------------------------------
0139                       ; Exit
0140                       ;-------------------------------------------------------
0141               edkey.action.down.exit:
0142 636A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     636C 6A44 
0143 636E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6370 75B0 
**** **** ****     > stevie_b1.asm.464228
0081                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 6372 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6374 A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 6376 8820  54         c     @fb.row.dirty,@w$ffff
     6378 A10A 
     637A 2022 
0013 637C 1604  14         jne   edkey.action.ppage.sanity
0014 637E 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6380 6E58 
0015 6382 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6384 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 6386 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6388 A104 
0021 638A 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 638C 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     638E A11A 
0026 6390 1503  14         jgt   edkey.action.ppage.topline
0027 6392 04E0  34         clr   @fb.topline           ; topline = 0
     6394 A104 
0028 6396 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6398 6820  54         s     @fb.scrrows,@fb.topline
     639A A11A 
     639C A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 639E C820  54         mov   @fb.topline,@parm1
     63A0 A104 
     63A2 2F20 
0039 63A4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63A6 A110 
0040               
0041 63A8 1045  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 63AA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63AC 75B0 
0048               
0049               
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Next page
0054               *---------------------------------------------------------------
0055               edkey.action.npage:
0056 63AE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63B0 A118 
0057                       ;-------------------------------------------------------
0058                       ; Crunch current row if dirty
0059                       ;-------------------------------------------------------
0060 63B2 8820  54         c     @fb.row.dirty,@w$ffff
     63B4 A10A 
     63B6 2022 
0061 63B8 1604  14         jne   edkey.action.npage.sanity
0062 63BA 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63BC 6E58 
0063 63BE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63C0 A10A 
0064                       ;-------------------------------------------------------
0065                       ; Assert
0066                       ;-------------------------------------------------------
0067               edkey.action.npage.sanity:
0068 63C2 C120  34         mov   @fb.topline,tmp0
     63C4 A104 
0069 63C6 A120  34         a     @fb.scrrows,tmp0
     63C8 A11A 
0070 63CA 0584  14         inc   tmp0                  ; Base 1 offset !
0071 63CC 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     63CE A204 
0072 63D0 1509  14         jgt   edkey.action.npage.exit
0073                       ;-------------------------------------------------------
0074                       ; Adjust topline
0075                       ;-------------------------------------------------------
0076               edkey.action.npage.topline:
0077 63D2 A820  54         a     @fb.scrrows,@fb.topline
     63D4 A11A 
     63D6 A104 
0078                       ;-------------------------------------------------------
0079                       ; Refresh page
0080                       ;-------------------------------------------------------
0081               edkey.action.npage.refresh:
0082 63D8 C820  54         mov   @fb.topline,@parm1
     63DA A104 
     63DC 2F20 
0083 63DE 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63E0 A110 
0084               
0085 63E2 1028  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0086                                                   ; / i  @parm1 = Line in editor buffer
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.npage.exit:
0091 63E4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63E6 75B0 
**** **** ****     > stevie_b1.asm.464228
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
0011 63E8 8820  54         c     @fb.row.dirty,@w$ffff
     63EA A10A 
     63EC 2022 
0012 63EE 1604  14         jne   edkey.action.top.refresh
0013 63F0 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63F2 6E58 
0014 63F4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63F6 A10A 
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 63F8 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63FA 2F20 
0020 63FC 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63FE A110 
0021               
0022 6400 0460  28         b     @ _edkey.goto.fb.toprow
     6402 6434 
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
0035 6404 8820  54         c     @fb.row.dirty,@w$ffff
     6406 A10A 
     6408 2022 
0036 640A 1604  14         jne   edkey.action.bot.refresh
0037 640C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     640E 6E58 
0038 6410 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6412 A10A 
0039                       ;-------------------------------------------------------
0040                       ; Refresh page
0041                       ;-------------------------------------------------------
0042               edkey.action.bot.refresh:
0043 6414 8820  54         c     @edb.lines,@fb.scrrows
     6416 A204 
     6418 A11A 
0044 641A 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0045               
0046 641C C120  34         mov   @edb.lines,tmp0
     641E A204 
0047 6420 6120  34         s     @fb.scrrows,tmp0
     6422 A11A 
0048 6424 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6426 2F20 
0049 6428 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     642A A110 
0050               
0051 642C 0460  28         b     @ _edkey.goto.fb.toprow
     642E 6434 
0052                                                   ; \ Position cursor and exit
0053                                                   ; / i  @parm1 = Line in editor buffer
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.bot.exit:
0058 6430 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6432 75B0 
**** **** ****     > stevie_b1.asm.464228
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
0026 6434 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6436 A118 
0027               
0028 6438 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     643A 6AB4 
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031               
0032 643C 04E0  34         clr   @fb.row               ; Frame buffer line 0
     643E A106 
0033 6440 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6442 A10C 
0034 6444 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     6446 832A 
0035               
0036 6448 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     644A 6A44 
0037               
0038 644C 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     644E 7020 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6450 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6452 75B0 
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Goto specified line (@parm1) in editor buffer
0047               *---------------------------------------------------------------
0048               edkey.action.goto:
0049                       ;-------------------------------------------------------
0050                       ; Crunch current row if dirty
0051                       ;-------------------------------------------------------
0052 6454 8820  54         c     @fb.row.dirty,@w$ffff
     6456 A10A 
     6458 2022 
0053 645A 1609  14         jne   edkey.action.goto.refresh
0054               
0055 645C 0649  14         dect  stack
0056 645E C660  46         mov   @parm1,*stack         ; Push parm1
     6460 2F20 
0057 6462 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6464 6E58 
0058 6466 C839  50         mov   *stack+,@parm1        ; Pop parm1
     6468 2F20 
0059               
0060 646A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     646C A10A 
0061                       ;-------------------------------------------------------
0062                       ; Refresh page
0063                       ;-------------------------------------------------------
0064               edkey.action.goto.refresh:
0065 646E 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6470 A110 
0066               
0067 6472 0460  28         b     @_edkey.goto.fb.toprow ; Position cursor and exit
     6474 6434 
0068                                                    ; \ i  @parm1 = Line in editor buffer
0069                                                    ; /
**** **** ****     > stevie_b1.asm.464228
0084                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 6476 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6478 A206 
0009 647A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     647C 6A44 
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 647E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6480 A108 
0015 6482 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 6484 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6486 A102 
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6488 C1C6  18         mov   tmp2,tmp3             ; \
0024 648A 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 648C 81E0  34         c     @fb.column,tmp3
     648E A10C 
0026 6490 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 6492 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 6494 D505  30         movb  tmp1,*tmp0            ; /
0033 6496 C820  54         mov   @fb.column,@fb.row.length
     6498 A10C 
     649A A108 
0034                                                   ; Row length - 1
0035 649C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     649E A10A 
0036 64A0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64A2 A116 
0037 64A4 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 64A6 0286  22         ci    tmp2,colrow
     64A8 0050 
0043 64AA 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 64AC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64AE FFCE 
0049 64B0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64B2 2026 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 64B4 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 64B6 61E0  34         s     @fb.column,tmp3
     64B8 A10C 
0056 64BA 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 64BC A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 64BE C144  18         mov   tmp0,tmp1
0059 64C0 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 64C2 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64C4 A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 64C6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64C8 A102 
0065 64CA C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 64CC 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 64CE DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 64D0 0606  14         dec   tmp2
0073 64D2 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 64D4 0206  20         li    tmp2,colrow
     64D6 0050 
0078 64D8 81A0  34         c     @fb.row.length,tmp2
     64DA A108 
0079 64DC 1603  14         jne   edkey.action.del_char.save
0080 64DE 0604  14         dec   tmp0                  ; One time adjustment
0081 64E0 04C5  14         clr   tmp1
0082 64E2 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 64E4 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64E6 A10A 
0088 64E8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64EA A116 
0089 64EC 0620  34         dec   @fb.row.length        ; @fb.row.length--
     64EE A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 64F0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64F2 75B0 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 64F4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64F6 A206 
0102 64F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64FA 6A44 
0103 64FC C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64FE A108 
0104 6500 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 6502 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6504 A102 
0110 6506 C1A0  34         mov   @fb.colsline,tmp2
     6508 A10E 
0111 650A 61A0  34         s     @fb.column,tmp2
     650C A10C 
0112 650E 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 6510 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 6512 0606  14         dec   tmp2
0119 6514 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 6516 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6518 A10A 
0124 651A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     651C A116 
0125               
0126 651E C820  54         mov   @fb.column,@fb.row.length
     6520 A10C 
     6522 A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 6524 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6526 75B0 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 6528 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     652A 6A44 
0143 652C 04E0  34         clr   @fb.row.dirty         ; Discard current line
     652E A10A 
0144               
0145 6530 C820  54         mov   @fb.topline,@parm1    ; \
     6532 A104 
     6534 2F20 
0146 6536 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     6538 A106 
     653A 2F20 
0147 653C 05A0  34         inc   @parm1                ; /
     653E 2F20 
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 6540 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     6542 2F20 
     6544 A204 
0153 6546 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 6548 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     654A A104 
     654C 2F20 
0157 654E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6550 6AB4 
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 6552 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6554 62A4 
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 6556 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6558 7126 
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 655A 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     655C 2F20 
     655E A204 
0170 6560 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 6562 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     6564 7020 
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 6566 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     6568 A104 
     656A 2F20 
0183               
0184 656C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     656E 6AB4 
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 6570 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6572 A206 
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 6574 C120  34         mov   @fb.topline,tmp0
     6576 A104 
0193 6578 A120  34         a     @fb.row,tmp0
     657A A106 
0194               
0195 657C 8804  38         c     tmp0,@edb.lines       ; Was last line?
     657E A204 
0196 6580 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 6582 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6584 62A4 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 6586 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6588 61A8 
**** **** ****     > stevie_b1.asm.464228
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
0010 658A 0204  20         li    tmp0,>2000            ; White space
     658C 2000 
0011 658E C804  38         mov   tmp0,@parm1
     6590 2F20 
0012               edkey.action.ins_char:
0013 6592 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6594 A206 
0014 6596 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6598 6A44 
0015                       ;-------------------------------------------------------
0016                       ; Assert 1 - Empty line
0017                       ;-------------------------------------------------------
0018 659A C120  34         mov   @fb.current,tmp0      ; Get pointer
     659C A102 
0019 659E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     65A0 A108 
0020 65A2 132C  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Assert 2 - EOL
0024                       ;-------------------------------------------------------
0025 65A4 8820  54         c     @fb.column,@fb.row.length
     65A6 A10C 
     65A8 A108 
0026 65AA 1328  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Assert 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 65AC C160  34         mov   @fb.column,tmp1
     65AE A10C 
0032 65B0 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     65B2 004F 
0033 65B4 1102  14         jlt   !
0034 65B6 0460  28         b     @edkey.action.char.overwrite
     65B8 672A 
0035                       ;-------------------------------------------------------
0036                       ; Assert 4 - 80 characters maximum
0037                       ;-------------------------------------------------------
0038 65BA C160  34 !       mov   @fb.row.length,tmp1
     65BC A108 
0039 65BE 0285  22         ci    tmp1,colrow
     65C0 0050 
0040 65C2 1101  14         jlt   edkey.action.ins_char.prep
0041 65C4 101D  14         jmp   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Calculate number of characters to move
0044                       ;-------------------------------------------------------
0045               edkey.action.ins_char.prep:
0046 65C6 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 65C8 61E0  34         s     @fb.column,tmp3
     65CA A10C 
0048 65CC 0607  14         dec   tmp3                  ; Remove base 1 offset
0049 65CE A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0050 65D0 C144  18         mov   tmp0,tmp1
0051 65D2 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0052 65D4 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     65D6 A10C 
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 65D8 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 65DA 0604  14         dec   tmp0
0059 65DC 0605  14         dec   tmp1
0060 65DE 0606  14         dec   tmp2
0061 65E0 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Insert specified character at current position
0064                       ;-------------------------------------------------------
0065 65E2 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     65E4 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 65E6 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65E8 A10A 
0070 65EA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65EC A116 
0071 65EE 05A0  34         inc   @fb.column
     65F0 A10C 
0072 65F2 05A0  34         inc   @wyx
     65F4 832A 
0073 65F6 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65F8 A108 
0074 65FA 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 65FC 0460  28         b     @edkey.action.char.overwrite
     65FE 672A 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 6600 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6602 75B0 
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
0095 6604 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6606 A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 6608 8820  54         c     @fb.row.dirty,@w$ffff
     660A A10A 
     660C 2022 
0100 660E 1604  14         jne   edkey.action.ins_line.insert
0101 6610 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6612 6E58 
0102 6614 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6616 A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 6618 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     661A 6A44 
0108 661C C820  54         mov   @fb.topline,@parm1
     661E A104 
     6620 2F20 
0109 6622 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6624 A106 
     6626 2F20 
0110 6628 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     662A A204 
     662C 2F22 
0111               
0112 662E 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6630 6D70 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 6632 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6634 A204 
0117                       ;-------------------------------------------------------
0118                       ; Check/Adjust marker M1
0119                       ;-------------------------------------------------------
0120               edkey.action.ins_line.m1:
0121 6636 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6638 A20C 
     663A 2022 
0122 663C 1308  14         jeq   edkey.action.ins_line.m2
0123                                                   ; Yes, skip to M2 check
0124               
0125 663E 8820  54         c     @parm1,@edb.block.m1
     6640 2F20 
     6642 A20C 
0126 6644 1504  14         jgt   edkey.action.ins_line.m2
0127 6646 05A0  34         inc   @edb.block.m1         ; M1++
     6648 A20C 
0128 664A 0720  34         seto  @fb.colorize          ; Set colorize flag
     664C A110 
0129                       ;-------------------------------------------------------
0130                       ; Check/Adjust marker M2
0131                       ;-------------------------------------------------------
0132               edkey.action.ins_line.m2:
0133 664E 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6650 A20E 
     6652 2022 
0134 6654 1308  14         jeq   edkey.action.ins_line.refresh
0135                                                   ; Yes, skip to refresh frame buffer
0136               
0137 6656 8820  54         c     @parm1,@edb.block.m2
     6658 2F20 
     665A A20E 
0138 665C 1504  14         jgt   edkey.action.ins_line.refresh
0139 665E 05A0  34         inc   @edb.block.m2         ; M2++
     6660 A20E 
0140 6662 0720  34         seto  @fb.colorize          ; Set colorize flag
     6664 A110 
0141                       ;-------------------------------------------------------
0142                       ; Refresh frame buffer and physical screen
0143                       ;-------------------------------------------------------
0144               edkey.action.ins_line.refresh:
0145 6666 C820  54         mov   @fb.topline,@parm1
     6668 A104 
     666A 2F20 
0146               
0147 666C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     666E 6AB4 
0148                                                   ; | i  @parm1 = Line to start with
0149                                                   ; /             (becomes @fb.topline)
0150               
0151 6670 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6672 A116 
0152                       ;-------------------------------------------------------
0153                       ; Exit
0154                       ;-------------------------------------------------------
0155               edkey.action.ins_line.exit:
0156 6674 0460  28         b     @edkey.action.home    ; Position cursor at home
     6676 61A8 
0157               
**** **** ****     > stevie_b1.asm.464228
0086                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 6678 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     667A A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 667C 8820  54         c     @fb.row.dirty,@w$ffff
     667E A10A 
     6680 2022 
0013 6682 1606  14         jne   edkey.action.enter.upd_counter
0014 6684 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6686 A206 
0015 6688 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     668A 6E58 
0016 668C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     668E A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6690 C120  34         mov   @fb.topline,tmp0
     6692 A104 
0022 6694 A120  34         a     @fb.row,tmp0
     6696 A106 
0023 6698 0584  14         inc   tmp0
0024 669A 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     669C A204 
0025 669E 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 66A0 05A0  34         inc   @edb.lines            ; Total lines++
     66A2 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 66A4 C120  34         mov   @fb.scrrows,tmp0
     66A6 A11A 
0035 66A8 0604  14         dec   tmp0
0036 66AA 8120  34         c     @fb.row,tmp0
     66AC A106 
0037 66AE 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 66B0 C120  34         mov   @fb.scrrows,tmp0
     66B2 A11A 
0042 66B4 C820  54         mov   @fb.topline,@parm1
     66B6 A104 
     66B8 2F20 
0043 66BA 05A0  34         inc   @parm1
     66BC 2F20 
0044 66BE 06A0  32         bl    @fb.refresh
     66C0 6AB4 
0045 66C2 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     66C4 A110 
0046 66C6 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 66C8 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     66CA A106 
0052 66CC 06A0  32         bl    @down                 ; Row++ VDP cursor
     66CE 269A 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 66D0 06A0  32         bl    @fb.get.firstnonblank
     66D2 6A6C 
0058 66D4 C120  34         mov   @outparm1,tmp0
     66D6 2F30 
0059 66D8 C804  38         mov   tmp0,@fb.column
     66DA A10C 
0060 66DC 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     66DE 26AC 
0061 66E0 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     66E2 7020 
0062 66E4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66E6 6A44 
0063 66E8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66EA A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 66EC 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66EE 75B0 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 66F0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66F2 A118 
0078 66F4 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     66F6 A20A 
0079                       ;-------------------------------------------------------
0080                       ; Delay
0081                       ;-------------------------------------------------------
0082 66F8 0204  20         li    tmp0,2000
     66FA 07D0 
0083               edkey.action.ins_onoff.loop:
0084 66FC 0604  14         dec   tmp0
0085 66FE 16FE  14         jne   edkey.action.ins_onoff.loop
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.ins_onoff.exit:
0090 6700 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     6702 7696 
0091               
0092               
0093               
0094               
0095               *---------------------------------------------------------------
0096               * Add character (frame buffer)
0097               *---------------------------------------------------------------
0098               edkey.action.char:
0099 6704 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6706 A118 
0100                       ;-------------------------------------------------------
0101                       ; Asserts
0102                       ;-------------------------------------------------------
0103 6708 D105  18         movb  tmp1,tmp0             ; Get keycode
0104 670A 0984  56         srl   tmp0,8                ; MSB to LSB
0105               
0106 670C 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     670E 0020 
0107 6710 112B  14         jlt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109               
0110 6712 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6714 007E 
0111 6716 1528  14         jgt   edkey.action.char.exit
0112                                                   ; Yes, skip
0113                       ;-------------------------------------------------------
0114                       ; Setup
0115                       ;-------------------------------------------------------
0116 6718 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     671A A206 
0117 671C D805  38         movb  tmp1,@parm1           ; Store character for insert
     671E 2F20 
0118 6720 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6722 A20A 
0119 6724 1302  14         jeq   edkey.action.char.overwrite
0120                       ;-------------------------------------------------------
0121                       ; Insert mode
0122                       ;-------------------------------------------------------
0123               edkey.action.char.insert:
0124 6726 0460  28         b     @edkey.action.ins_char
     6728 6592 
0125                       ;-------------------------------------------------------
0126                       ; Overwrite mode - Write character
0127                       ;-------------------------------------------------------
0128               edkey.action.char.overwrite:
0129 672A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     672C 6A44 
0130 672E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6730 A102 
0131               
0132 6732 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6734 2F20 
0133 6736 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6738 A10A 
0134 673A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     673C A116 
0135                       ;-------------------------------------------------------
0136                       ; Last column on screen reached?
0137                       ;-------------------------------------------------------
0138 673E C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6740 A10C 
0139 6742 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     6744 004F 
0140 6746 1105  14         jlt   edkey.action.char.overwrite.incx
0141                                                   ; No, increase X position
0142               
0143 6748 0205  20         li    tmp1,colrow           ; \
     674A 0050 
0144 674C C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     674E A108 
0145 6750 100B  14         jmp   edkey.action.char.exit
0146                       ;-------------------------------------------------------
0147                       ; Increase column
0148                       ;-------------------------------------------------------
0149               edkey.action.char.overwrite.incx:
0150 6752 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6754 A10C 
0151 6756 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6758 832A 
0152                       ;-------------------------------------------------------
0153                       ; Update line length in frame buffer
0154                       ;-------------------------------------------------------
0155 675A 8820  54         c     @fb.column,@fb.row.length
     675C A10C 
     675E A108 
0156                                                   ; column < line length ?
0157 6760 1103  14         jlt   edkey.action.char.exit
0158                                                   ; Yes, don't update row length
0159 6762 C820  54         mov   @fb.column,@fb.row.length
     6764 A10C 
     6766 A108 
0160                                                   ; Set row length
0161                       ;-------------------------------------------------------
0162                       ; Exit
0163                       ;-------------------------------------------------------
0164               edkey.action.char.exit:
0165 6768 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     676A 75B0 
**** **** ****     > stevie_b1.asm.464228
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
0011 676C C120  34         mov   @edb.dirty,tmp0
     676E A206 
0012 6770 1302  14         jeq   !
0013 6772 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6774 7E18 
0014                       ;-------------------------------------------------------
0015                       ; Reset and lock F18a
0016                       ;-------------------------------------------------------
0017 6776 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     6778 275C 
0018 677A 0420  54         blwp  @0                    ; Exit
     677C 0000 
**** **** ****     > stevie_b1.asm.464228
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
0017 677E C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6780 A444 
     6782 2F20 
0018 6784 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6786 2F22 
0019 6788 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 678A C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     678C A444 
     678E 2F20 
0023 6790 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6792 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Assert
0028                       ;------------------------------------------------------
0029 6794 C120  34         mov   @parm1,tmp0
     6796 2F20 
0030 6798 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 679A C120  34         mov   @edb.dirty,tmp0
     679C A206 
0036 679E 1302  14         jeq   !
0037 67A0 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     67A2 7E18 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 67A4 06A0  32 !       bl    @fm.browse.fname.suffix.incdec
     67A6 74CA 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 67A8 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67AA E000 
0047 67AC 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     67AE 7DAA 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 67B0 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     67B2 63E8 
**** **** ****     > stevie_b1.asm.464228
0089                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 67B4 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     67B6 71B6 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 67B8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67BA 75B0 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 67BC 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     67BE 71DE 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 67C0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67C2 75B0 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 67C4 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     67C6 7206 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 67C8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67CA 75B0 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 67CC 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67CE 7C2E 
0043 67D0 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67D2 7242 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 67D4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67D6 75B0 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054 67D8 0649  14         dect  stack
0055 67DA C644  30         mov   tmp0,*stack           ; Push tmp0
0056                       ;-------------------------------------------------------
0057                       ; Exit early if nothing to do
0058                       ;-------------------------------------------------------
0059 67DC 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67DE A20E 
     67E0 2022 
0060 67E2 1315  14         jeq   edkey.action.block.copy.exit
0061                                                   ; Yes, exit early
0062                       ;-------------------------------------------------------
0063                       ; Init
0064                       ;-------------------------------------------------------
0065 67E4 C120  34         mov   @wyx,tmp0             ; Get cursor position
     67E6 832A 
0066 67E8 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67EA FF00 
0067 67EC C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67EE A114 
0068                       ;-------------------------------------------------------
0069                       ; Copy
0070                       ;-------------------------------------------------------
0071 67F0 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67F2 7C2E 
0072               
0073 67F4 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     67F6 2F20 
0074 67F8 06A0  32         bl    @edb.block.copy       ; Copy code block
     67FA 7288 
0075                                                   ; \ i  @parm1    = Message flag
0076                                                   ; / o  @outparm1 = >ffff if success
0077               
0078 67FC 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     67FE 2F30 
     6800 2000 
0079 6802 1305  14         jeq   edkey.action.block.copy.exit
0080                                                   ; If yes, exit early
0081               
0082 6804 C820  54         mov   @fb.yxsave,@parm1
     6806 A114 
     6808 2F20 
0083 680A 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     680C 6BEC 
0084                                                   ; \ i  @parm1 = cursor YX position
0085                                                   ; /
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.block.copy.exit:
0090 680E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 6810 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6812 75B0 
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
0103 6814 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6816 A20E 
     6818 2022 
0104 681A 130F  14         jeq   edkey.action.block.delete.exit
0105                                                   ; Yes, exit early
0106                       ;-------------------------------------------------------
0107                       ; Delete
0108                       ;-------------------------------------------------------
0109 681C 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     681E 7C2E 
0110               
0111 6820 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     6822 2F20 
0112 6824 06A0  32         bl    @edb.block.delete     ; Delete code block
     6826 737E 
0113                                                   ; \ i  @parm1    = Display message Yes/No
0114                                                   ; / o  @outparm1 = >ffff if success
0115                       ;-------------------------------------------------------
0116                       ; Reposition in frame buffer
0117                       ;-------------------------------------------------------
0118 6828 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     682A 2F30 
     682C 2000 
0119 682E 1305  14         jeq   edkey.action.block.delete.exit
0120                                                   ; If yes, exit early
0121               
0122 6830 C820  54         mov   @fb.topline,@parm1
     6832 A104 
     6834 2F20 
0123 6836 0460  28         b     @_edkey.goto.fb.toprow
     6838 6434 
0124                                                   ; Position on top row in frame buffer
0125                                                   ; \ i  @parm1 = Line to display as top row
0126                                                   ; /
0127                       ;-------------------------------------------------------
0128                       ; Exit
0129                       ;-------------------------------------------------------
0130               edkey.action.block.delete.exit:
0131 683A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     683C 75B0 
0132               
0133               
0134               *---------------------------------------------------------------
0135               * Move code block
0136               ********|*****|*********************|**************************
0137               edkey.action.block.move:
0138                       ;-------------------------------------------------------
0139                       ; Exit early if nothing to do
0140                       ;-------------------------------------------------------
0141 683E 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6840 A20E 
     6842 2022 
0142 6844 1313  14         jeq   edkey.action.block.move.exit
0143                                                   ; Yes, exit early
0144                       ;-------------------------------------------------------
0145                       ; Delete
0146                       ;-------------------------------------------------------
0147 6846 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     6848 7C2E 
0148               
0149 684A 0720  34         seto  @parm1                ; Set message to "Moving block..."
     684C 2F20 
0150 684E 06A0  32         bl    @edb.block.copy       ; Copy code block
     6850 7288 
0151                                                   ; \ i  @parm1    = Message flag
0152                                                   ; / o  @outparm1 = >ffff if success
0153               
0154 6852 0720  34         seto  @parm1                ; Don't display delete message
     6854 2F20 
0155 6856 06A0  32         bl    @edb.block.delete     ; Delete code block
     6858 737E 
0156                                                   ; \ i  @parm1    = Display message Yes/No
0157                                                   ; / o  @outparm1 = >ffff if success
0158                       ;-------------------------------------------------------
0159                       ; Reposition in frame buffer
0160                       ;-------------------------------------------------------
0161 685A 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     685C 2F30 
     685E 2000 
0162 6860 13EC  14         jeq   edkey.action.block.delete.exit
0163                                                   ; If yes, exit early
0164               
0165 6862 C820  54         mov   @fb.topline,@parm1
     6864 A104 
     6866 2F20 
0166 6868 0460  28         b     @_edkey.goto.fb.toprow
     686A 6434 
0167                                                   ; Position on top row in frame buffer
0168                                                   ; \ i  @parm1 = Line to display as top row
0169                                                   ; /
0170                       ;-------------------------------------------------------
0171                       ; Exit
0172                       ;-------------------------------------------------------
0173               edkey.action.block.move.exit:
0174 686C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     686E 75B0 
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Goto marker M1
0179               ********|*****|*********************|**************************
0180               edkey.action.block.goto.m1:
0181 6870 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6872 A20C 
     6874 2022 
0182 6876 1307  14         jeq   edkey.action.block.goto.m1.exit
0183                                                   ; Yes, exit early
0184                       ;-------------------------------------------------------
0185                       ; Goto marker M1
0186                       ;-------------------------------------------------------
0187 6878 C820  54         mov   @edb.block.m1,@parm1
     687A A20C 
     687C 2F20 
0188 687E 0620  34         dec   @parm1                ; Base 0 offset
     6880 2F20 
0189               
0190 6882 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6884 6454 
0191                                                   ; \ i @parm1 = Target line in EB
0192                                                   ; /
0193                       ;-------------------------------------------------------
0194                       ; Exit
0195                       ;-------------------------------------------------------
0196               edkey.action.block.goto.m1.exit:
0197 6886 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6888 75B0 
**** **** ****     > stevie_b1.asm.464228
0090                       ;-----------------------------------------------------------------------
0091                       ; Keyboard actions - Command Buffer
0092                       ;-----------------------------------------------------------------------
0093                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 688A C120  34         mov   @cmdb.column,tmp0
     688C A312 
0009 688E 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6890 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6892 A312 
0014 6894 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6896 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 6898 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     689A 75B0 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 689C 06A0  32         bl    @cmdb.cmd.getlength
     689E 749C 
0026 68A0 8820  54         c     @cmdb.column,@outparm1
     68A2 A312 
     68A4 2F30 
0027 68A6 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 68A8 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     68AA A312 
0032 68AC 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     68AE A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 68B0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     68B2 75B0 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 68B4 04C4  14         clr   tmp0
0045 68B6 C804  38         mov   tmp0,@cmdb.column      ; First column
     68B8 A312 
0046 68BA 0584  14         inc   tmp0
0047 68BC D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     68BE A30A 
0048 68C0 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     68C2 A30A 
0049               
0050 68C4 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68C6 75B0 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 68C8 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     68CA A326 
0057 68CC 0984  56         srl   tmp0,8                 ; Right justify
0058 68CE C804  38         mov   tmp0,@cmdb.column      ; Save column position
     68D0 A312 
0059 68D2 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 68D4 0224  22         ai    tmp0,>1a00             ; Y=26
     68D6 1A00 
0061 68D8 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     68DA A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 68DC 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     68DE 75B0 
**** **** ****     > stevie_b1.asm.464228
0094                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 68E0 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     68E2 746A 
0026 68E4 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68E6 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 68E8 0460  28         b     @edkey.action.cmdb.home
     68EA 68B4 
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
0060 68EC D105  18         movb  tmp1,tmp0             ; Get keycode
0061 68EE 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 68F0 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     68F2 0020 
0064 68F4 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 68F6 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     68F8 007E 
0068 68FA 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 68FC 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     68FE A318 
0074               
0075 6900 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6902 A327 
0076 6904 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6906 A312 
0077 6908 D505  30         movb  tmp1,*tmp0            ; Add character
0078 690A 05A0  34         inc   @cmdb.column          ; Next column
     690C A312 
0079 690E 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6910 A30A 
0080               
0081 6912 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6914 749C 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 6916 C120  34         mov   @outparm1,tmp0
     6918 2F30 
0088 691A 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 691C D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     691E A326 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 6920 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6922 75B0 
**** **** ****     > stevie_b1.asm.464228
0095                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6924 C120  34         mov   @cmdb.visible,tmp0
     6926 A302 
0009 6928 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 692A 04E0  34         clr   @cmdb.column          ; Column = 0
     692C A312 
0015 692E 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6930 799E 
0016 6932 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6934 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6936 79EE 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6938 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     693A 75B0 
**** **** ****     > stevie_b1.asm.464228
0096                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
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
     693E 79EE 
0012               
0013 6940 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6942 749C 
0014 6944 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6946 2F30 
0015 6948 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 694A 06A0  32         bl    @pane.errline.show    ; Show error line
     694C 7BC6 
0020               
0021 694E 06A0  32         bl    @pane.show_hint
     6950 775C 
0022 6952 1C00                   byte pane.botrow-1,0
0023 6954 399A                   data txt.io.nofile
0024               
0025 6956 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 6958 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 695A D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     695C A326 
0031               
0032 695E 06A0  32         bl    @cpym2m
     6960 24A0 
0033 6962 A326                   data cmdb.cmdlen,heap.top,80
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
     697A 7DAA 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 697C 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     697E 63E8 
**** **** ****     > stevie_b1.asm.464228
0097                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
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
     6982 79EE 
0012               
0013 6984 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6986 749C 
0014 6988 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     698A 2F30 
0015 698C 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 698E 06A0  32         bl    @pane.errline.show    ; Show error line
     6990 7BC6 
0020               
0021 6992 06A0  32         bl    @pane.show_hint
     6994 775C 
0022 6996 1C00                   byte pane.botrow-1,0
0023 6998 399A                   data txt.io.nofile
0024               
0025 699A 1020  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 699C 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 699E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     69A0 A326 
0031               
0032 69A2 06A0  32         bl    @cpym2m
     69A4 24A0 
0033 69A6 A326                   data cmdb.cmdlen,heap.top,80
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
     69DA 7DD0 
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
     69DE 63E8 
**** **** ****     > stevie_b1.asm.464228
0098                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
     69E6 778E 
0022 69E8 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     69EA 746A 
0023 69EC C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     69EE A324 
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
     6A08 75B0 
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
0063 6A0A 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6A0C 754C 
0064 6A0E 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6A10 A318 
0065 6A12 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6A14 75B0 
0066               
0067               
0068               
0069               
0070               ***************************************************************
0071               * dialog.close
0072               * Close dialog
0073               ***************************************************************
0074               * b   @edkey.action.cmdb.close.dialog
0075               *--------------------------------------------------------------
0076               * OUTPUT
0077               * none
0078               *--------------------------------------------------------------
0079               * Register usage
0080               * none
0081               ********|*****|*********************|**************************
0082               edkey.action.cmdb.close.dialog:
0083                       ;------------------------------------------------------
0084                       ; Close dialog
0085                       ;------------------------------------------------------
0086 6A16 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6A18 A31A 
0087 6A1A 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6A1C 778E 
0088 6A1E 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A20 79EE 
0089 6A22 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6A24 A118 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.close.dialog.exit:
0094 6A26 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6A28 75B0 
**** **** ****     > stevie_b1.asm.464228
0099                       ;-----------------------------------------------------------------------
0100                       ; Logic for Framebuffer
0101                       ;-----------------------------------------------------------------------
0102                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 6A2A 0649  14         dect  stack
0025 6A2C C64B  30         mov   r11,*stack            ; Save return address
0026 6A2E 0649  14         dect  stack
0027 6A30 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 6A32 C120  34         mov   @parm1,tmp0
     6A34 2F20 
0032 6A36 A120  34         a     @fb.topline,tmp0
     6A38 A104 
0033 6A3A C804  38         mov   tmp0,@outparm1
     6A3C 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 6A3E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 6A40 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 6A42 045B  20         b     *r11                  ; Return to caller
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
0068 6A44 0649  14         dect  stack
0069 6A46 C64B  30         mov   r11,*stack            ; Save return address
0070 6A48 0649  14         dect  stack
0071 6A4A C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A4C 0649  14         dect  stack
0073 6A4E C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A50 C120  34         mov   @fb.row,tmp0
     6A52 A106 
0078 6A54 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A56 A10E 
0079 6A58 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6A5A A10C 
0080 6A5C A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6A5E A100 
0081 6A60 C805  38         mov   tmp1,@fb.current
     6A62 A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6A64 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6A66 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6A68 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6A6A 045B  20         b     *r11                  ; Return to caller
0090               
0091               
0092               
0093               
0094               
0095               
0096               
0097               ***************************************************************
0098               * fb.get.firstnonblank
0099               * Get column of first non-blank character in specified line
0100               ***************************************************************
0101               * bl @fb.get.firstnonblank
0102               *--------------------------------------------------------------
0103               * OUTPUT
0104               * @outparm1 = Column containing first non-blank character
0105               * @outparm2 = Character
0106               ********|*****|*********************|**************************
0107               fb.get.firstnonblank:
0108 6A6C 0649  14         dect  stack
0109 6A6E C64B  30         mov   r11,*stack            ; Save return address
0110                       ;------------------------------------------------------
0111                       ; Prepare for scanning
0112                       ;------------------------------------------------------
0113 6A70 04E0  34         clr   @fb.column
     6A72 A10C 
0114 6A74 06A0  32         bl    @fb.calc_pointer
     6A76 6A44 
0115 6A78 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6A7A 7020 
0116 6A7C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6A7E A108 
0117 6A80 1313  14         jeq   fb.get.firstnonblank.nomatch
0118                                                   ; Exit if empty line
0119 6A82 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6A84 A102 
0120 6A86 04C5  14         clr   tmp1
0121                       ;------------------------------------------------------
0122                       ; Scan line for non-blank character
0123                       ;------------------------------------------------------
0124               fb.get.firstnonblank.loop:
0125 6A88 D174  28         movb  *tmp0+,tmp1           ; Get character
0126 6A8A 130E  14         jeq   fb.get.firstnonblank.nomatch
0127                                                   ; Exit if empty line
0128 6A8C 0285  22         ci    tmp1,>2000            ; Whitespace?
     6A8E 2000 
0129 6A90 1503  14         jgt   fb.get.firstnonblank.match
0130 6A92 0606  14         dec   tmp2                  ; Counter--
0131 6A94 16F9  14         jne   fb.get.firstnonblank.loop
0132 6A96 1008  14         jmp   fb.get.firstnonblank.nomatch
0133                       ;------------------------------------------------------
0134                       ; Non-blank character found
0135                       ;------------------------------------------------------
0136               fb.get.firstnonblank.match:
0137 6A98 6120  34         s     @fb.current,tmp0      ; Calculate column
     6A9A A102 
0138 6A9C 0604  14         dec   tmp0
0139 6A9E C804  38         mov   tmp0,@outparm1        ; Save column
     6AA0 2F30 
0140 6AA2 D805  38         movb  tmp1,@outparm2        ; Save character
     6AA4 2F32 
0141 6AA6 1004  14         jmp   fb.get.firstnonblank.exit
0142                       ;------------------------------------------------------
0143                       ; No non-blank character found
0144                       ;------------------------------------------------------
0145               fb.get.firstnonblank.nomatch:
0146 6AA8 04E0  34         clr   @outparm1             ; X=0
     6AAA 2F30 
0147 6AAC 04E0  34         clr   @outparm2             ; Null
     6AAE 2F32 
0148                       ;------------------------------------------------------
0149                       ; Exit
0150                       ;------------------------------------------------------
0151               fb.get.firstnonblank.exit:
0152 6AB0 C2F9  30         mov   *stack+,r11           ; Pop r11
0153 6AB2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0103                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6AB4 0649  14         dect  stack
0021 6AB6 C64B  30         mov   r11,*stack            ; Push return address
0022 6AB8 0649  14         dect  stack
0023 6ABA C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6ABC 0649  14         dect  stack
0025 6ABE C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6AC0 0649  14         dect  stack
0027 6AC2 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6AC4 C820  54         mov   @parm1,@fb.topline
     6AC6 2F20 
     6AC8 A104 
0032 6ACA 04E0  34         clr   @parm2                ; Target row in frame buffer
     6ACC 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6ACE 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6AD0 2F20 
     6AD2 A204 
0037 6AD4 130F  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6AD6 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6AD8 6F22 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6ADA 05A0  34         inc   @parm1                ; Next line in editor buffer
     6ADC 2F20 
0048 6ADE 05A0  34         inc   @parm2                ; Next row in frame buffer
     6AE0 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6AE2 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6AE4 2F20 
     6AE6 A204 
0053 6AE8 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0054               
0055 6AEA 8820  54         c     @parm2,@fb.scrrows
     6AEC 2F22 
     6AEE A11A 
0056 6AF0 11F2  14         jlt   fb.refresh.unpack_line
0057                                                   ; No, unpack next line
0058 6AF2 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0059                       ;------------------------------------------------------
0060                       ; Erase until end of frame buffer
0061                       ;------------------------------------------------------
0062               fb.refresh.erase_eob:
0063 6AF4 C120  34         mov   @parm2,tmp0           ; Current row
     6AF6 2F22 
0064 6AF8 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6AFA A11A 
0065 6AFC 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0066 6AFE 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6B00 A10E 
0067               
0068 6B02 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0069 6B04 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0070               
0071 6B06 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6B08 A10E 
0072 6B0A A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6B0C A100 
0073               
0074 6B0E C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0075 6B10 04C5  14         clr   tmp1                  ; Clear with >00 character
0076               
0077 6B12 06A0  32         bl    @xfilm                ; \ Fill memory
     6B14 223E 
0078                                                   ; | i  tmp0 = Memory start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = Number of bytes to fill
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.refresh.exit:
0085 6B16 0720  34         seto  @fb.dirty             ; Refresh screen
     6B18 A116 
0086 6B1A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0087 6B1C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 6B1E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 6B20 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6B22 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0104                       copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT
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
0021 6B24 0649  14         dect  stack
0022 6B26 C64B  30         mov   r11,*stack            ; Save return address
0023 6B28 0649  14         dect  stack
0024 6B2A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6B2C 0649  14         dect  stack
0026 6B2E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6B30 0649  14         dect  stack
0028 6B32 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Assert
0031                       ;------------------------------------------------------
0032 6B34 C160  34         mov   @parm1,tmp1
     6B36 2F20 
0033 6B38 0285  22         ci    tmp1,80*30
     6B3A 0960 
0034 6B3C 1204  14         jle   !
0035                       ;------------------------------------------------------
0036                       ; Crash the system
0037                       ;------------------------------------------------------
0038 6B3E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B40 FFCE 
0039 6B42 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B44 2026 
0040                       ;------------------------------------------------------
0041                       ; Refresh VDP content with framebuffer
0042                       ;------------------------------------------------------
0043 6B46 0204  20 !       li    tmp0,vdp.fb.toprow.sit
     6B48 0050 
0044                                                   ; VDP target address (2nd line on screen!)
0045               
0046 6B4A 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * number of rows in parm1
     6B4C A10E 
0047                                                   ; 16 bit part is in tmp2!
0048 6B4E C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     6B50 A100 
0049               
0050 6B52 0286  22         ci    tmp2,0                ; \ Exit early if nothing to copy
     6B54 0000 
0051 6B56 1304  14         jeq   fb.vdpdump.exit       ; /
0052               
0053 6B58 06A0  32         bl    @xpym2v               ; Copy to VDP
     6B5A 2452 
0054                                                   ; \ i  tmp0 = VDP target address
0055                                                   ; | i  tmp1 = RAM source address
0056                                                   ; / i  tmp2 = Bytes to copy
0057               
0058 6B5C 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     6B5E A116 
0059                       ;------------------------------------------------------
0060                       ; Exit
0061                       ;------------------------------------------------------
0062               fb.vdpdump.exit:
0063 6B60 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6B62 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0065 6B64 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0066 6B66 C2F9  30         mov   *stack+,r11           ; Pop r11
0067 6B68 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0105                       copy  "fb.colorlines.asm"   ; Colorize lines in framebuffer
**** **** ****     > fb.colorlines.asm
0001               * FILE......: fb.colorlines.asm
0002               * Purpose...: Colorize frame buffer content
0003               
0004               ***************************************************************
0005               * fb.colorlines
0006               * Colorize frame buffer content
0007               ***************************************************************
0008               * bl @fb.colorlines
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Force refresh if >ffff
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2,tmp3,tmp4
0018               ********|*****|*********************|**************************
0019               fb.colorlines:
0020 6B6A 0649  14         dect  stack
0021 6B6C C64B  30         mov   r11,*stack            ; Save return address
0022 6B6E 0649  14         dect  stack
0023 6B70 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B72 0649  14         dect  stack
0025 6B74 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6B76 0649  14         dect  stack
0027 6B78 C646  30         mov   tmp2,*stack           ; Push tmp2
0028 6B7A 0649  14         dect  stack
0029 6B7C C647  30         mov   tmp3,*stack           ; Push tmp3
0030 6B7E 0649  14         dect  stack
0031 6B80 C648  30         mov   tmp4,*stack           ; Push tmp4
0032                       ;------------------------------------------------------
0033                       ; Force refresh flag set
0034                       ;------------------------------------------------------
0035 6B82 C120  34         mov   @parm1,tmp0           ; \ Force refresh flag set?
     6B84 2F20 
0036 6B86 0284  22         ci    tmp0,>ffff            ; /
     6B88 FFFF 
0037 6B8A 1309  14         jeq   !                     ; Yes, so skip Asserts
0038                       ;------------------------------------------------------
0039                       ; Assert
0040                       ;------------------------------------------------------
0041 6B8C C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     6B8E A110 
0042 6B90 1324  14         jeq   fb.colorlines.exit    ; Exit if nothing to do.
0043                       ;------------------------------------------------------
0044                       ; Speedup screen refresh dramatically
0045                       ;------------------------------------------------------
0046 6B92 C120  34         mov   @edb.block.m1,tmp0
     6B94 A20C 
0047 6B96 1321  14         jeq   fb.colorlines.exit    ; Exit if marker M1 unset
0048 6B98 C120  34         mov   @edb.block.m2,tmp0
     6B9A A20E 
0049 6B9C 131E  14         jeq   fb.colorlines.exit    ; Exit if marker M2 unset
0050                       ;------------------------------------------------------
0051                       ; Color the lines in the framebuffer (TAT)
0052                       ;------------------------------------------------------
0053 6B9E 0204  20 !       li    tmp0,vdp.fb.toprow.tat
     6BA0 1850 
0054                                                   ; VDP start address
0055 6BA2 C1E0  34         mov   @fb.scrrows,tmp3      ; Set loop counter
     6BA4 A11A 
0056 6BA6 C220  34         mov   @fb.topline,tmp4      ; Position in editor buffer
     6BA8 A104 
0057 6BAA 0588  14         inc   tmp4                  ; M1/M2 use base 1 offset
0058                       ;------------------------------------------------------
0059                       ; 1. Set color for each line in framebuffer
0060                       ;------------------------------------------------------
0061               fb.colorlines.loop:
0062 6BAC C1A0  34         mov   @edb.block.m1,tmp2
     6BAE A20C 
0063 6BB0 8206  18         c     tmp2,tmp4             ; M1 > current line
0064 6BB2 1507  14         jgt   fb.colorlines.normal  ; Yes, skip marking color
0065               
0066 6BB4 C1A0  34         mov   @edb.block.m2,tmp2
     6BB6 A20E 
0067 6BB8 8206  18         c     tmp2,tmp4             ; M2 < current line
0068 6BBA 1103  14         jlt   fb.colorlines.normal  ; Yes, skip marking color
0069                       ;------------------------------------------------------
0070                       ; 1a. Set marking color
0071                       ;------------------------------------------------------
0072 6BBC C160  34         mov   @tv.markcolor,tmp1
     6BBE A01A 
0073 6BC0 1003  14         jmp   fb.colorlines.fill
0074                       ;------------------------------------------------------
0075                       ; 1b. Set normal text color
0076                       ;------------------------------------------------------
0077               fb.colorlines.normal:
0078 6BC2 C160  34         mov   @tv.color,tmp1
     6BC4 A018 
0079 6BC6 0985  56         srl   tmp1,8
0080                       ;------------------------------------------------------
0081                       ; 1c. Fill line with selected color
0082                       ;------------------------------------------------------
0083               fb.colorlines.fill:
0084 6BC8 0206  20         li    tmp2,80               ; 80 characters to fill
     6BCA 0050 
0085               
0086 6BCC 06A0  32         bl    @xfilv                ; Fill VDP VRAM
     6BCE 2296 
0087                                                   ; \ i  tmp0 = VDP start address
0088                                                   ; | i  tmp1 = Byte to fill
0089                                                   ; / i  tmp2 = count
0090               
0091 6BD0 0224  22         ai    tmp0,80               ; Next line
     6BD2 0050 
0092 6BD4 0588  14         inc   tmp4
0093 6BD6 0607  14         dec   tmp3                  ; Update loop counter
0094 6BD8 15E9  14         jgt   fb.colorlines.loop    ; Back to (1)
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               fb.colorlines.exit
0099 6BDA 04E0  34         clr   @fb.colorize          ; Reset colorize flag
     6BDC A110 
0100 6BDE C239  30         mov   *stack+,tmp4          ; Pop tmp4
0101 6BE0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0102 6BE2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0103 6BE4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 6BE6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 6BE8 C2F9  30         mov   *stack+,r11           ; Pop r11
0106 6BEA 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.464228
0106                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6BEC 0649  14         dect  stack
0022 6BEE C64B  30         mov   r11,*stack            ; Save return address
0023 6BF0 0649  14         dect  stack
0024 6BF2 C660  46         mov   @parm1,*stack         ; Push @parm1
     6BF4 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6BF6 C820  54         mov   @fb.topline,@parm1
     6BF8 A104 
     6BFA 2F20 
0029 6BFC 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6BFE 6AB4 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6C00 0720  34         seto  @parm1                ; Skip Asserts
     6C02 2F20 
0035 6C04 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6C06 6B6A 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6C08 C820  54         mov   @tv.color,@parm1      ; Set normal color
     6C0A A018 
     6C0C 2F20 
0042 6C0E 06A0  32         bl    @pane.action.colorscheme.statlines
     6C10 793A 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6C12 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6C14 A118 
0050               
0051 6C16 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6C18 778E 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6C1A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6C1C 2F20 
0057 6C1E C820  54         mov   @parm1,@wyx           ; Set cursor position
     6C20 2F20 
     6C22 832A 
0058 6C24 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6C26 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.464228
0107                       ;-----------------------------------------------------------------------
0108                       ; Logic for Index management
0109                       ;-----------------------------------------------------------------------
0110                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6C28 0649  14         dect  stack
0023 6C2A C64B  30         mov   r11,*stack            ; Save return address
0024 6C2C 0649  14         dect  stack
0025 6C2E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6C30 0649  14         dect  stack
0027 6C32 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6C34 C120  34         mov   @parm1,tmp0           ; Get line number
     6C36 2F20 
0032 6C38 C160  34         mov   @parm2,tmp1           ; Get pointer
     6C3A 2F22 
0033 6C3C 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6C3E 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6C40 0FFF 
0039 6C42 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6C44 06E0  34         swpb  @parm3
     6C46 2F24 
0044 6C48 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6C4A 2F24 
0045 6C4C 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6C4E 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6C50 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C52 3174 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6C54 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6C56 2F30 
0056 6C58 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6C5A B000 
0057 6C5C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C5E 2F30 
0058 6C60 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6C62 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C64 3174 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6C66 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C68 2F30 
0068 6C6A 04E4  34         clr   @idx.top(tmp0)        ; /
     6C6C B000 
0069 6C6E C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C70 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C72 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C74 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C76 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C78 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0111                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6C7A 0649  14         dect  stack
0022 6C7C C64B  30         mov   r11,*stack            ; Save return address
0023 6C7E 0649  14         dect  stack
0024 6C80 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C82 0649  14         dect  stack
0026 6C84 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C86 0649  14         dect  stack
0028 6C88 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C8A C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C8C 2F20 
0033               
0034 6C8E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C90 3174 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C92 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C94 2F30 
0039 6C96 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6C98 B000 
0040               
0041 6C9A 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6C9C C185  18         mov   tmp1,tmp2             ; \
0047 6C9E 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6CA0 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6CA2 00FF 
0052 6CA4 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6CA6 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6CA8 C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6CAA C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6CAC 2F30 
0059 6CAE C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6CB0 2F32 
0060 6CB2 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6CB4 04E0  34         clr   @outparm1
     6CB6 2F30 
0066 6CB8 04E0  34         clr   @outparm2
     6CBA 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6CBC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6CBE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6CC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6CC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6CC4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0112                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6CC6 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6CC8 B000 
0018 6CCA C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6CCC 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6CCE CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6CD0 0606  14         dec   tmp2                  ; tmp2--
0026 6CD2 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6CD4 045B  20         b     *r11                  ; Return to caller
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
0046 6CD6 0649  14         dect  stack
0047 6CD8 C64B  30         mov   r11,*stack            ; Save return address
0048 6CDA 0649  14         dect  stack
0049 6CDC C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6CDE 0649  14         dect  stack
0051 6CE0 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6CE2 0649  14         dect  stack
0053 6CE4 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6CE6 0649  14         dect  stack
0055 6CE8 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6CEA C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6CEC 2F20 
0060               
0061 6CEE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6CF0 3174 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6CF2 C120  34         mov   @outparm1,tmp0        ; Index offset
     6CF4 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6CF6 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6CF8 2F22 
0070 6CFA 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6CFC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6CFE 2F20 
0074 6D00 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6D02 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6D04 B000 
0081 6D06 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6D08 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6D0A C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6D0C 2F22 
0088 6D0E 0287  22         ci    tmp3,2048
     6D10 0800 
0089 6D12 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6D14 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D16 3106 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6D18 C120  34         mov   @parm1,tmp0           ; Restore line number
     6D1A 2F20 
0103 6D1C 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6D1E 06A0  32         bl    @_idx.entry.delete.reorg
     6D20 6CC6 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6D22 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D24 313A 
0111                                                   ; Restore memory window layout
0112               
0113 6D26 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6D28 06A0  32         bl    @_idx.entry.delete.reorg
     6D2A 6CC6 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6D2C 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6D2E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6D30 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6D32 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6D34 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6D36 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6D38 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0113                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0017 6D3A 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6D3C 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6D3E 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6D40 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D42 FFCE 
0026 6D44 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D46 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6D48 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6D4A B000 
0031 6D4C C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6D4E 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6D50 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Assert 2
0036                       ;------------------------------------------------------
0037 6D52 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6D54 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6D56 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6D58 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6D5A 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6D5C AFFE 
0042 6D5E 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6D60 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6D62 0644  14         dect  tmp0                  ; Move pointer up
0050 6D64 0645  14         dect  tmp1                  ; Move pointer up
0051 6D66 0606  14         dec   tmp2                  ; Next index entry
0052 6D68 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D6A 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D6C 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D6E 045B  20         b     *r11                  ; Return to caller
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
0082 6D70 0649  14         dect  stack
0083 6D72 C64B  30         mov   r11,*stack            ; Save return address
0084 6D74 0649  14         dect  stack
0085 6D76 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D78 0649  14         dect  stack
0087 6D7A C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D7C 0649  14         dect  stack
0089 6D7E C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D80 0649  14         dect  stack
0091 6D82 C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D84 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D86 2F22 
0096 6D88 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D8A 2F20 
0097 6D8C 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D8E C1E0  34         mov   @parm2,tmp3
     6D90 2F22 
0104 6D92 0287  22         ci    tmp3,2048
     6D94 0800 
0105 6D96 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6D98 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D9A 3106 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6D9C C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D9E 2F22 
0117 6DA0 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6DA2 06A0  32         bl    @_idx.entry.insert.reorg
     6DA4 6D3A 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6DA6 06A0  32         bl    @_idx.sams.mapcolumn.off
     6DA8 313A 
0125                                                   ; Restore memory window layout
0126               
0127 6DAA 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6DAC C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6DAE 2F22 
0133               
0134 6DB0 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6DB2 3174 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6DB4 C120  34         mov   @outparm1,tmp0        ; Index offset
     6DB6 2F30 
0139               
0140 6DB8 06A0  32         bl    @_idx.entry.insert.reorg
     6DBA 6D3A 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6DBC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6DBE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6DC0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6DC2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6DC4 C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6DC6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0114                       ;-----------------------------------------------------------------------
0115                       ; Logic for Editor Buffer
0116                       ;-----------------------------------------------------------------------
0117                       copy  "edb.utils.asm"          ; Editor buffer utilities
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
0020 6DC8 0649  14         dect  stack
0021 6DCA C64B  30         mov   r11,*stack            ; Save return address
0022 6DCC 0649  14         dect  stack
0023 6DCE C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6DD0 0649  14         dect  stack
0025 6DD2 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6DD4 C120  34         mov   @edb.next_free.ptr,tmp0
     6DD6 A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6DD8 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6DDA 0FFF 
0035 6DDC 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6DDE 0052 
0036 6DE0 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6DE2 0FF0 
0037 6DE4 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6DE6 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6DE8 A218 
0043 6DEA C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6DEC A200 
     6DEE A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6DF0 C120  34         mov   @edb.sams.hipage,tmp0
     6DF2 A218 
0050 6DF4 C160  34         mov   @edb.top.ptr,tmp1
     6DF6 A200 
0051 6DF8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6DFA 253C 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6DFC 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6DFE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E00 FFCE 
0061 6E02 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E04 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6E06 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6E08 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6E0A C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6E0C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0118                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6E0E 0649  14         dect  stack
0022 6E10 C64B  30         mov   r11,*stack            ; Push return address
0023 6E12 0649  14         dect  stack
0024 6E14 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6E16 0649  14         dect  stack
0026 6E18 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 6E1A 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6E1C A204 
0031 6E1E 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 6E20 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E22 FFCE 
0037 6E24 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E26 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6E28 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6E2A 2F20 
0043               
0044 6E2C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6E2E 6C7A 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6E30 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6E32 2F32 
0050 6E34 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6E36 2F30 
0051 6E38 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6E3A 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6E3C A008 
0057 6E3E 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6E40 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6E42 253C 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6E44 C820  54         mov   @outparm2,@tv.sams.c000
     6E46 2F32 
     6E48 A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6E4A C820  54         mov   @outparm2,@edb.sams.page
     6E4C 2F32 
     6E4E A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6E50 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6E52 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6E54 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6E56 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0119                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6E58 0649  14         dect  stack
0028 6E5A C64B  30         mov   r11,*stack            ; Save return address
0029 6E5C 0649  14         dect  stack
0030 6E5E C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6E60 0649  14         dect  stack
0032 6E62 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6E64 0649  14         dect  stack
0034 6E66 C646  30         mov   tmp2,*stack           ; Push tmp2
0035                       ;------------------------------------------------------
0036                       ; Get values
0037                       ;------------------------------------------------------
0038 6E68 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E6A A10C 
     6E6C 2F6A 
0039 6E6E 04E0  34         clr   @fb.column
     6E70 A10C 
0040 6E72 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E74 6A44 
0041                       ;------------------------------------------------------
0042                       ; Prepare scan
0043                       ;------------------------------------------------------
0044 6E76 04C4  14         clr   tmp0                  ; Counter
0045 6E78 C160  34         mov   @fb.current,tmp1      ; Get position
     6E7A A102 
0046 6E7C C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E7E 2F6C 
0047                       ;------------------------------------------------------
0048                       ; Scan line for >00 byte termination
0049                       ;------------------------------------------------------
0050               edb.line.pack.fb.scan:
0051 6E80 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0052 6E82 0986  56         srl   tmp2,8                ; Right justify
0053 6E84 1309  14         jeq   edb.line.pack.fb.check_setpage
0054                                                   ; Stop scan if >00 found
0055 6E86 0584  14         inc   tmp0                  ; Increase string length
0056                       ;------------------------------------------------------
0057                       ; Not more than 80 characters
0058                       ;------------------------------------------------------
0059 6E88 0284  22         ci    tmp0,colrow
     6E8A 0050 
0060 6E8C 1305  14         jeq   edb.line.pack.fb.check_setpage
0061                                                   ; Stop scan if 80 characters processed
0062 6E8E 10F8  14         jmp   edb.line.pack.fb.scan ; Next character
0063                       ;------------------------------------------------------
0064                       ; Check failed, crash CPU!
0065                       ;------------------------------------------------------
0066               edb.line.pack.fb.crash:
0067 6E90 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E92 FFCE 
0068 6E94 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E96 2026 
0069                       ;------------------------------------------------------
0070                       ; Check if highest SAMS page needs to be increased
0071                       ;------------------------------------------------------
0072               edb.line.pack.fb.check_setpage:
0073 6E98 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6E9A 2F6E 
0074               
0075 6E9C 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6E9E 6DC8 
0076                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0077                                                   ; /                         free line
0078                       ;------------------------------------------------------
0079                       ; Step 2: Prepare for storing line
0080                       ;------------------------------------------------------
0081               edb.line.pack.fb.prepare:
0082 6EA0 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6EA2 A104 
     6EA4 2F20 
0083 6EA6 A820  54         a     @fb.row,@parm1        ; /
     6EA8 A106 
     6EAA 2F20 
0084                       ;------------------------------------------------------
0085                       ; 2a. Update index
0086                       ;------------------------------------------------------
0087               edb.line.pack.fb.update_index:
0088 6EAC C820  54         mov   @edb.next_free.ptr,@parm2
     6EAE A208 
     6EB0 2F22 
0089                                                   ; Pointer to new line
0090 6EB2 C820  54         mov   @edb.sams.hipage,@parm3
     6EB4 A218 
     6EB6 2F24 
0091                                                   ; SAMS page to use
0092               
0093 6EB8 06A0  32         bl    @idx.entry.update     ; Update index
     6EBA 6C28 
0094                                                   ; \ i  parm1 = Line number in editor buffer
0095                                                   ; | i  parm2 = pointer to line in
0096                                                   ; |            editor buffer
0097                                                   ; / i  parm3 = SAMS page
0098                       ;------------------------------------------------------
0099                       ; 3. Set line prefix in editor buffer
0100                       ;------------------------------------------------------
0101 6EBC C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6EBE 2F6C 
0102 6EC0 C160  34         mov   @edb.next_free.ptr,tmp1
     6EC2 A208 
0103                                                   ; Address of line in editor buffer
0104               
0105 6EC4 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6EC6 A208 
0106               
0107 6EC8 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6ECA 2F6E 
0108 6ECC CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0109 6ECE 1317  14         jeq   edb.line.pack.fb.prepexit
0110                                                   ; Nothing to copy if empty line
0111                       ;------------------------------------------------------
0112                       ; 4. Copy line from framebuffer to editor buffer
0113                       ;------------------------------------------------------
0114               edb.line.pack.fb.copyline:
0115 6ED0 0286  22         ci    tmp2,2
     6ED2 0002 
0116 6ED4 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0117 6ED6 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0118 6ED8 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0119 6EDA 1007  14         jmp   edb.line.pack.fb.copyline.align16
0120               
0121               edb.line.pack.fb.copyline.checkbyte:
0122 6EDC 0286  22         ci    tmp2,1
     6EDE 0001 
0123 6EE0 1602  14         jne   edb.line.pack.fb.copyline.block
0124 6EE2 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0125 6EE4 1002  14         jmp   edb.line.pack.fb.copyline.align16
0126               
0127               edb.line.pack.fb.copyline.block:
0128 6EE6 06A0  32         bl    @xpym2m               ; Copy memory block
     6EE8 24A6 
0129                                                   ; \ i  tmp0 = source
0130                                                   ; | i  tmp1 = destination
0131                                                   ; / i  tmp2 = bytes to copy
0132                       ;------------------------------------------------------
0133                       ; 5: Align pointer to multiple of 16 memory address
0134                       ;------------------------------------------------------
0135               edb.line.pack.fb.copyline.align16:
0136 6EEA A820  54         a     @rambuf+4,@edb.next_free.ptr
     6EEC 2F6E 
     6EEE A208 
0137                                                      ; Add length of line
0138               
0139 6EF0 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6EF2 A208 
0140 6EF4 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0141 6EF6 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6EF8 000F 
0142 6EFA A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6EFC A208 
0143                       ;------------------------------------------------------
0144                       ; 6: Restore SAMS page and prepare for exit
0145                       ;------------------------------------------------------
0146               edb.line.pack.fb.prepexit:
0147 6EFE C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6F00 2F6A 
     6F02 A10C 
0148               
0149 6F04 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6F06 A218 
     6F08 A216 
0150 6F0A 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0151               
0152 6F0C C120  34         mov   @edb.sams.page,tmp0
     6F0E A216 
0153 6F10 C160  34         mov   @edb.top.ptr,tmp1
     6F12 A200 
0154 6F14 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6F16 253C 
0155                                                   ; \ i  tmp0 = SAMS page number
0156                                                   ; / i  tmp1 = Memory address
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160               edb.line.pack.fb.exit:
0161 6F18 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0162 6F1A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0163 6F1C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0164 6F1E C2F9  30         mov   *stack+,r11           ; Pop R11
0165 6F20 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0120                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0028 6F22 0649  14         dect  stack
0029 6F24 C64B  30         mov   r11,*stack            ; Save return address
0030 6F26 0649  14         dect  stack
0031 6F28 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6F2A 0649  14         dect  stack
0033 6F2C C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6F2E 0649  14         dect  stack
0035 6F30 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Save parameters
0038                       ;------------------------------------------------------
0039 6F32 C820  54         mov   @parm1,@rambuf
     6F34 2F20 
     6F36 2F6A 
0040 6F38 C820  54         mov   @parm2,@rambuf+2
     6F3A 2F22 
     6F3C 2F6C 
0041                       ;------------------------------------------------------
0042                       ; Calculate offset in frame buffer
0043                       ;------------------------------------------------------
0044 6F3E C120  34         mov   @fb.colsline,tmp0
     6F40 A10E 
0045 6F42 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6F44 2F22 
0046 6F46 C1A0  34         mov   @fb.top.ptr,tmp2
     6F48 A100 
0047 6F4A A146  18         a     tmp2,tmp1             ; Add base to offset
0048 6F4C C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F4E 2F70 
0049                       ;------------------------------------------------------
0050                       ; Return empty row if requested line beyond editor buffer
0051                       ;------------------------------------------------------
0052 6F50 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     6F52 2F20 
     6F54 A204 
0053 6F56 1103  14         jlt   !                     ; No, continue processing
0054               
0055 6F58 04E0  34         clr   @rambuf+8             ; Set length=0
     6F5A 2F72 
0056 6F5C 1016  14         jmp   edb.line.unpack.fb.clear
0057                       ;------------------------------------------------------
0058                       ; Get pointer to line & page-in editor buffer page
0059                       ;------------------------------------------------------
0060 6F5E C120  34 !       mov   @parm1,tmp0
     6F60 2F20 
0061 6F62 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F64 6E0E 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6F66 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F68 2F30 
0069 6F6A 1603  14         jne   edb.line.unpack.fb.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6F6C 04E0  34         clr   @rambuf+8             ; Set length=0
     6F6E 2F72 
0073 6F70 100C  14         jmp   edb.line.unpack.fb.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.fb.getlen:
0078 6F72 C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6F74 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6F76 2F6E 
0080 6F78 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6F7A 2F72 
0081                       ;------------------------------------------------------
0082                       ; Assert on line length
0083                       ;------------------------------------------------------
0084 6F7C 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6F7E 0050 
0085                                                   ; /
0086 6F80 1204  14         jle   edb.line.unpack.fb.clear
0087                       ;------------------------------------------------------
0088                       ; Crash the system
0089                       ;------------------------------------------------------
0090 6F82 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F84 FFCE 
0091 6F86 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F88 2026 
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 6F8A C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6F8C 2F70 
0097 6F8E A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6F90 2F72 
0098               
0099 6F92 04C5  14         clr   tmp1                  ; Fill with >00
0100 6F94 C1A0  34         mov   @fb.colsline,tmp2
     6F96 A10E 
0101 6F98 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6F9A 2F72 
0102 6F9C 0586  14         inc   tmp2
0103               
0104 6F9E 06A0  32         bl    @xfilm                ; Fill CPU memory
     6FA0 223E 
0105                                                   ; \ i  tmp0 = Target address
0106                                                   ; | i  tmp1 = Byte to fill
0107                                                   ; / i  tmp2 = Repeat count
0108                       ;------------------------------------------------------
0109                       ; Prepare for unpacking data
0110                       ;------------------------------------------------------
0111               edb.line.unpack.fb.prepare:
0112 6FA2 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6FA4 2F72 
0113 6FA6 130F  14         jeq   edb.line.unpack.fb.exit
0114                                                   ; Exit if length = 0
0115 6FA8 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6FAA 2F6E 
0116 6FAC C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6FAE 2F70 
0117                       ;------------------------------------------------------
0118                       ; Assert on line length
0119                       ;------------------------------------------------------
0120               edb.line.unpack.fb.copy:
0121 6FB0 0286  22         ci    tmp2,80               ; Check line length
     6FB2 0050 
0122 6FB4 1204  14         jle   edb.line.unpack.fb.copy.doit
0123                       ;------------------------------------------------------
0124                       ; Crash the system
0125                       ;------------------------------------------------------
0126 6FB6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FB8 FFCE 
0127 6FBA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FBC 2026 
0128                       ;------------------------------------------------------
0129                       ; Copy memory block
0130                       ;------------------------------------------------------
0131               edb.line.unpack.fb.copy.doit:
0132 6FBE C806  38         mov   tmp2,@outparm1        ; Length of unpacked line
     6FC0 2F30 
0133               
0134 6FC2 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6FC4 24A6 
0135                                                   ; \ i  tmp0 = Source address
0136                                                   ; | i  tmp1 = Target address
0137                                                   ; / i  tmp2 = Bytes to copy
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               edb.line.unpack.fb.exit:
0142 6FC6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0143 6FC8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0144 6FCA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0145 6FCC C2F9  30         mov   *stack+,r11           ; Pop r11
0146 6FCE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0121                       copy  "edb.line.getlen.asm"    ; Get line length
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
0021 6FD0 0649  14         dect  stack
0022 6FD2 C64B  30         mov   r11,*stack            ; Push return address
0023 6FD4 0649  14         dect  stack
0024 6FD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6FD8 0649  14         dect  stack
0026 6FDA C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6FDC 04E0  34         clr   @outparm1             ; Reset length
     6FDE 2F30 
0031 6FE0 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6FE2 2F32 
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 6FE4 C120  34         mov   @parm1,tmp0           ; \
     6FE6 2F20 
0036 6FE8 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 6FEA 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     6FEC A204 
0039 6FEE 1101  14         jlt   !                     ; No, continue processing
0040 6FF0 1011  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 6FF2 C120  34 !       mov   @parm1,tmp0           ; Get line
     6FF4 2F20 
0046               
0047 6FF6 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6FF8 6E0E 
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 6FFA C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6FFC 2F30 
0053 6FFE 130A  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 7000 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 7002 C805  38         mov   tmp1,@outparm1        ; Save length
     7004 2F30 
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 7006 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     7008 0050 
0064 700A 1206  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system
0068                       ;------------------------------------------------------
0069 700C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     700E FFCE 
0070 7010 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7012 2026 
0071                       ;------------------------------------------------------
0072                       ; Set length to 0 if null-pointer
0073                       ;------------------------------------------------------
0074               edb.line.getlength.null:
0075 7014 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     7016 2F30 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               edb.line.getlength.exit:
0080 7018 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0081 701A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 701C C2F9  30         mov   *stack+,r11           ; Pop r11
0083 701E 045B  20         b     *r11                  ; Return to caller
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
0103 7020 0649  14         dect  stack
0104 7022 C64B  30         mov   r11,*stack            ; Save return address
0105 7024 0649  14         dect  stack
0106 7026 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Calculate line in editor buffer
0109                       ;------------------------------------------------------
0110 7028 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     702A A104 
0111 702C A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     702E A106 
0112                       ;------------------------------------------------------
0113                       ; Get length
0114                       ;------------------------------------------------------
0115 7030 C804  38         mov   tmp0,@parm1
     7032 2F20 
0116 7034 06A0  32         bl    @edb.line.getlength
     7036 6FD0 
0117 7038 C820  54         mov   @outparm1,@fb.row.length
     703A 2F30 
     703C A108 
0118                                                   ; Save row length
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               edb.line.getlength2.exit:
0123 703E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 7040 C2F9  30         mov   *stack+,r11           ; Pop R11
0125 7042 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0122                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 7044 0649  14         dect  stack
0032 7046 C64B  30         mov   r11,*stack            ; Save return address
0033 7048 0649  14         dect  stack
0034 704A C644  30         mov   tmp0,*stack           ; Push tmp0
0035 704C 0649  14         dect  stack
0036 704E C645  30         mov   tmp1,*stack           ; Push tmp1
0037 7050 0649  14         dect  stack
0038 7052 C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Assert
0041                       ;------------------------------------------------------
0042 7054 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     7056 2F20 
     7058 A204 
0043 705A 1204  14         jle   !
0044 705C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     705E FFCE 
0045 7060 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7062 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 7064 C120  34 !       mov   @parm2,tmp0           ; Get target line number
     7066 2F22 
0050 7068 0604  14         dec   tmp0                  ; Base 0
0051 706A C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     706C 2F6C 
0052 706E 04E0  34         clr   @rambuf               ; Set source line length=0
     7070 2F6A 
0053 7072 04E0  34         clr   @rambuf+4             ; Null-pointer source line
     7074 2F6E 
0054 7076 04E0  34         clr   @rambuf+6             ; Null-pointer target line
     7078 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 707A C120  34         mov   @parm1,tmp0           ; Get source line number
     707C 2F20 
0059 707E 0604  14         dec   tmp0                  ; Base 0
0060               
0061 7080 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     7082 6E0E 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 7084 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     7086 2F30 
0069 7088 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 708A 103D  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 708C C154  26         mov   *tmp0,tmp1            ; Get line length
0076 708E C805  38         mov   tmp1,@rambuf          ; \ Save length of line
     7090 2F6A 
0077 7092 05E0  34         inct  @rambuf               ; / Consider length of line prefix too
     7094 2F6A 
0078 7096 C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     7098 2F6E 
0079                       ;------------------------------------------------------
0080                       ; Assert on line length
0081                       ;------------------------------------------------------
0082 709A 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     709C 0050 
0083 709E 1204  14         jle   edb.line.copy.prepare ; /
0084                       ;------------------------------------------------------
0085                       ; Crash the system
0086                       ;------------------------------------------------------
0087 70A0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70A2 FFCE 
0088 70A4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70A6 2026 
0089                       ;------------------------------------------------------
0090                       ; 1: Prepare pointers for editor buffer in d000-dfff
0091                       ;------------------------------------------------------
0092               edb.line.copy.prepare:
0093 70A8 A820  54         a     @w$1000,@edb.top.ptr
     70AA 201A 
     70AC A200 
0094 70AE A820  54         a     @w$1000,@edb.next_free.ptr
     70B0 201A 
     70B2 A208 
0095                                                   ; The editor buffer SAMS page for the target
0096                                                   ; line will be mapped into memory region
0097                                                   ; d000-dfff (instead of usual c000-cfff)
0098                                                   ;
0099                                                   ; This allows normal memory copy routine
0100                                                   ; to copy source line to target line.
0101                       ;------------------------------------------------------
0102                       ; 2: Check if highest SAMS page needs to be increased
0103                       ;------------------------------------------------------
0104 70B4 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     70B6 6DC8 
0105                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0106                                                   ; /                         free line
0107                       ;------------------------------------------------------
0108                       ; 3: Set parameters for copy line
0109                       ;------------------------------------------------------
0110 70B8 C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     70BA 2F6E 
0111 70BC C160  34         mov   @edb.next_free.ptr,tmp1
     70BE A208 
0112                                                   ; Pointer to space for new target line
0113               
0114 70C0 C1A0  34         mov   @rambuf,tmp2          ; Set number of bytes to copy
     70C2 2F6A 
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 70C4 06A0  32         bl    @xpym2m               ; Copy memory block
     70C6 24A6 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 70C8 6820  54         s     @w$1000,@edb.top.ptr
     70CA 201A 
     70CC A200 
0127 70CE 6820  54         s     @w$1000,@edb.next_free.ptr
     70D0 201A 
     70D2 A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 70D4 C820  54         mov   @edb.next_free.ptr,@rambuf+6
     70D6 A208 
     70D8 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 70DA C120  34         mov   @edb.sams.page,tmp0
     70DC A216 
0138 70DE C160  34         mov   @edb.top.ptr,tmp1
     70E0 A200 
0139 70E2 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70E4 253C 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 70E6 C120  34         mov   @tv.sams.d000,tmp0
     70E8 A00A 
0146 70EA 0205  20         li    tmp1,>d000
     70EC D000 
0147 70EE 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70F0 253C 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 70F2 A820  54         a     @rambuf,@edb.next_free.ptr
     70F4 2F6A 
     70F6 A208 
0154                                                      ; Add length of line
0155               
0156 70F8 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     70FA A208 
0157 70FC 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 70FE 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7100 000F 
0159 7102 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7104 A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 7106 C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     7108 2F6C 
     710A 2F20 
0165 710C C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     710E 2F70 
     7110 2F22 
0166 7112 C820  54         mov   @edb.sams.hipage,@parm3
     7114 A218 
     7116 2F24 
0167                                                   ; SAMS page to use
0168               
0169 7118 06A0  32         bl    @idx.entry.update     ; Update index
     711A 6C28 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 711C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 711E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 7120 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 7122 C2F9  30         mov   *stack+,r11           ; Pop r11
0182 7124 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0123                       copy  "edb.line.del.asm"       ; Delete line
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
0024 7126 0649  14         dect  stack
0025 7128 C64B  30         mov   r11,*stack            ; Save return address
0026 712A 0649  14         dect  stack
0027 712C C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Assert
0030                       ;------------------------------------------------------
0031 712E 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     7130 2F20 
     7132 A204 
0032 7134 1204  14         jle   !
0033 7136 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7138 FFCE 
0034 713A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     713C 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 713E 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7140 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 7142 C120  34          mov   @edb.lines,tmp0      ; \
     7144 A204 
0043 7146 0284  22          ci    tmp0,1               ; | Only single line?
     7148 0001 
0044 714A 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 714C 0620  34         dec   @parm1                ; Base 0
     714E 2F20 
0049 7150 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7152 A204 
     7154 2F22 
0050               
0051 7156 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7158 6CD6 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 715A 0620  34         dec   @edb.lines            ; One line less in editor buffer
     715C A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 715E 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     7160 A20C 
     7162 2022 
0061 7164 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 7166 8820  54         c     @parm1,@edb.block.m1  ; \
     7168 2F20 
     716A A20C 
0064 716C 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 716E 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 7170 8820  54         c     @edb.block.m1,@w$0001 ; \
     7172 A20C 
     7174 2002 
0068 7176 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 7178 0620  34         dec   @edb.block.m1         ; M1--
     717A A20C 
0071 717C 0720  34         seto  @fb.colorize          ; Set colorize flag
     717E A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 7180 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     7182 A20E 
     7184 2022 
0077 7186 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 7188 8820  54         c     @parm1,@edb.block.m2  ; \
     718A 2F20 
     718C A20E 
0080 718E 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 7190 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 7192 8820  54         c     @edb.block.m2,@w$0001 ; \
     7194 A20E 
     7196 2002 
0084 7198 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 719A 0620  34         dec   @edb.block.m2         ; M2--
     719C A20E 
0087 719E 0720  34         seto  @fb.colorize          ; Set colorize flag
     71A0 A110 
0088 71A2 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 71A4 04E0  34         clr   @parm1                ; 1st line
     71A6 2F20 
0094 71A8 04E0  34         clr   @parm2                ; 1st line
     71AA 2F22 
0095               
0096 71AC 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     71AE 6CD6 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 71B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 71B2 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 71B4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0124                       copy  "edb.block.mark.asm"     ; Mark code block
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
0020 71B6 0649  14         dect  stack
0021 71B8 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 71BA C820  54         mov   @fb.row,@parm1
     71BC A106 
     71BE 2F20 
0026 71C0 06A0  32         bl    @fb.row2line          ; Row to editor line
     71C2 6A2A 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 71C4 05A0  34         inc   @outparm1             ; Add base 1
     71C6 2F30 
0032               
0033 71C8 C820  54         mov   @outparm1,@edb.block.m1
     71CA 2F30 
     71CC A20C 
0034                                                   ; Set block marker M1
0035 71CE 0720  34         seto  @fb.colorize          ; Set colorize flag
     71D0 A110 
0036 71D2 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     71D4 A116 
0037 71D6 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71D8 A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 71DA C2F9  30         mov   *stack+,r11           ; Pop r11
0043 71DC 045B  20         b     *r11                  ; Return to caller
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
0062 71DE 0649  14         dect  stack
0063 71E0 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 71E2 C820  54         mov   @fb.row,@parm1
     71E4 A106 
     71E6 2F20 
0068 71E8 06A0  32         bl    @fb.row2line          ; Row to editor line
     71EA 6A2A 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 71EC 05A0  34         inc   @outparm1             ; Add base 1
     71EE 2F30 
0074               
0075 71F0 C820  54         mov   @outparm1,@edb.block.m2
     71F2 2F30 
     71F4 A20E 
0076                                                   ; Set block marker M2
0077               
0078 71F6 0720  34         seto  @fb.colorize          ; Set colorize flag
     71F8 A110 
0079 71FA 0720  34         seto  @fb.dirty             ; Trigger refresh
     71FC A116 
0080 71FE 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7200 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 7202 C2F9  30         mov   *stack+,r11           ; Pop r11
0086 7204 045B  20         b     *r11                  ; Return to caller
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
0106 7206 0649  14         dect  stack
0107 7208 C64B  30         mov   r11,*stack            ; Push return address
0108 720A 0649  14         dect  stack
0109 720C C644  30         mov   tmp0,*stack           ; Push tmp0
0110 720E 0649  14         dect  stack
0111 7210 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 7212 C820  54         mov   @fb.row,@parm1
     7214 A106 
     7216 2F20 
0116 7218 06A0  32         bl    @fb.row2line          ; Row to editor line
     721A 6A2A 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 721C C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     721E 2F30 
0122 7220 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 7222 C120  34         mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
     7224 A20C 
0127 7226 0584  14         inc   tmp0                  ; /
0128 7228 1603  14         jne   edb.block.mark.is_line_m1
0129                                                   ; No, skip to update M1
0130                       ;------------------------------------------------------
0131                       ; Set M1 and exit
0132                       ;------------------------------------------------------
0133               _edb.block.mark.m1.set:
0134 722A 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     722C 71B6 
0135 722E 1005  14         jmp   edb.block.mark.exit   ; Exit now
0136                       ;------------------------------------------------------
0137                       ; Update M1 if current line < M1
0138                       ;------------------------------------------------------
0139               edb.block.mark.is_line_m1:
0140 7230 8160  34         c     @edb.block.m1,tmp1    ; M1 > current line ?
     7232 A20C 
0141 7234 15FA  14         jgt   _edb.block.mark.m1.set
0142                                                   ; Set M1 to current line and exit
0143                       ;------------------------------------------------------
0144                       ; Set M2 and exit
0145                       ;------------------------------------------------------
0146 7236 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     7238 71DE 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               edb.block.mark.exit:
0151 723A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 723C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 723E C2F9  30         mov   *stack+,r11           ; Pop r11
0154 7240 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0125                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 7242 0649  14         dect  stack
0018 7244 C64B  30         mov   r11,*stack            ; Push return address
0019 7246 0649  14         dect  stack
0020 7248 C660  46         mov   @wyx,*stack           ; Push cursor position
     724A 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 724C 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     724E A20C 
0025 7250 0720  34         seto  @edb.block.m2         ; /
     7252 A20E 
0026               
0027 7254 0720  34         seto  @fb.colorize          ; Set colorize flag
     7256 A110 
0028 7258 0720  34         seto  @fb.dirty             ; Trigger refresh
     725A A116 
0029 725C 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     725E A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 7260 0720  34         seto  @parm1
     7262 2F20 
0034 7264 06A0  32         bl    @pane.action.colorscheme.load
     7266 780C 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 7268 C820  54         mov   @tv.color,@parm1      ; Set normal color
     726A A018 
     726C 2F20 
0042 726E 06A0  32         bl    @pane.action.colorscheme.statlines
     7270 793A 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 7272 06A0  32         bl    @hchar
     7274 2788 
0048 7276 0034                   byte 0,52,32,18           ; Remove markers
     7278 2012 
0049 727A 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     727C 2032 
0050 727E FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 7280 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7282 832A 
0056 7284 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 7286 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0126                       copy  "edb.block.copy.asm"     ; Copy code block
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
0027 7288 0649  14         dect  stack
0028 728A C64B  30         mov   r11,*stack            ; Save return address
0029 728C 0649  14         dect  stack
0030 728E C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7290 0649  14         dect  stack
0032 7292 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7294 0649  14         dect  stack
0034 7296 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 7298 0649  14         dect  stack
0036 729A C660  46         mov   @parm1,*stack         ; Push parm1
     729C 2F20 
0037 729E 04E0  34         clr   @outparm1             ; No action (>0000)
     72A0 2F30 
0038                       ;------------------------------------------------------
0039                       ; Asserts
0040                       ;------------------------------------------------------
0041 72A2 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     72A4 A20C 
     72A6 2022 
0042 72A8 1363  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 72AA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     72AC A20E 
     72AE 2022 
0045 72B0 135F  14         jeq   edb.block.copy.exit   ; Yes, exit early
0046               
0047 72B2 8820  54         c     @edb.block.m1,@edb.block.m2
     72B4 A20C 
     72B6 A20E 
0048                                                   ; M1 > M2 ?
0049 72B8 155B  14         jgt   edb.block.copy.exit   ; Yes, exit early
0050                       ;------------------------------------------------------
0051                       ; Get current line position in editor buffer
0052                       ;------------------------------------------------------
0053 72BA C820  54         mov   @fb.row,@parm1
     72BC A106 
     72BE 2F20 
0054 72C0 06A0  32         bl    @fb.row2line          ; Row to editor line
     72C2 6A2A 
0055                                                   ; \ i @fb.topline = Top line in frame buffer
0056                                                   ; | i @parm1      = Row in frame buffer
0057                                                   ; / o @outparm1   = Matching line in EB
0058               
0059 72C4 C120  34         mov   @outparm1,tmp0        ; \
     72C6 2F30 
0060 72C8 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0061 72CA C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     72CC A210 
0062                       ;------------------------------------------------------
0063                       ; Show error and exit if M1 < current line < M2
0064                       ;------------------------------------------------------
0065 72CE 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     72D0 2F30 
0066 72D2 110D  14         jlt   !                     ; Yes, skip check
0067               
0068 72D4 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     72D6 2F30 
0069 72D8 150A  14         jgt   !                     ; Yes, skip check
0070               
0071 72DA 06A0  32         bl    @cpym2m
     72DC 24A0 
0072 72DE 39BC                   data txt.block.inside,tv.error.msg,53
     72E0 A026 
     72E2 0035 
0073               
0074 72E4 06A0  32         bl    @pane.errline.show    ; Show error line
     72E6 7BC6 
0075               
0076 72E8 04E0  34         clr   @outparm1             ; No action (>0000)
     72EA 2F30 
0077 72EC 1041  14         jmp   edb.block.copy.exit   ; Exit early
0078                       ;------------------------------------------------------
0079                       ; Display message Copy/Move
0080                       ;------------------------------------------------------
0081 72EE C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     72F0 A01C 
     72F2 2F20 
0082 72F4 06A0  32         bl    @pane.action.colorscheme.statlines
     72F6 793A 
0083                                                   ; Set color combination for status lines
0084                                                   ; \ i  @parm1 = Color combination
0085                                                   ; /
0086               
0087 72F8 06A0  32         bl    @hchar
     72FA 2788 
0088 72FC 1D00                   byte pane.botrow,0,32,50
     72FE 2032 
0089 7300 FFFF                   data eol              ; Remove markers and block shortcuts
0090                       ;------------------------------------------------------
0091                       ; Check message to display
0092                       ;------------------------------------------------------
0093 7302 C119  26         mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
0094                                                   ; / @parm1 = >0000 ?
0095 7304 1605  14         jne   edb.block.copy.msg2   ; Yes, display "Moving" message
0096               
0097 7306 06A0  32         bl    @putat
     7308 2444 
0098 730A 1D00                   byte pane.botrow,0
0099 730C 3640                   data txt.block.copy   ; Display "Copying block...."
0100 730E 1004  14         jmp   edb.block.copy.prep
0101               
0102               edb.block.copy.msg2:
0103 7310 06A0  32         bl    @putat
     7312 2444 
0104 7314 1D00                   byte pane.botrow,0
0105 7316 3652                   data txt.block.move   ; Display "Moving block...."
0106                       ;------------------------------------------------------
0107                       ; Prepare for copy
0108                       ;------------------------------------------------------
0109               edb.block.copy.prep:
0110 7318 C120  34         mov   @edb.block.m1,tmp0    ; M1
     731A A20C 
0111 731C C1A0  34         mov   @edb.block.m2,tmp2    ; \
     731E A20E 
0112 7320 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0113 7322 0586  14         inc   tmp2                  ; /
0114               
0115 7324 C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     7326 A210 
0116                       ;------------------------------------------------------
0117                       ; Copy code block
0118                       ;------------------------------------------------------
0119               edb.block.copy.loop:
0120 7328 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     732A 2F20 
0121 732C 0620  34         dec   @parm1                ; Base 0 offset for index required
     732E 2F20 
0122 7330 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7332 A204 
     7334 2F22 
0123               
0124 7336 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     7338 6D70 
0125                                                   ; \ i  @parm1 = Line for insert
0126                                                   ; / i  @parm2 = Last line to reorg
0127                       ;------------------------------------------------------
0128                       ; Increase M1-M2 block if target line before M1
0129                       ;------------------------------------------------------
0130 733A 8805  38         c     tmp1,@edb.block.m1
     733C A20C 
0131 733E 1506  14         jgt   edb.block.copy.loop.docopy
0132 7340 1305  14         jeq   edb.block.copy.loop.docopy
0133               
0134 7342 05A0  34         inc   @edb.block.m1         ; M1++
     7344 A20C 
0135 7346 05A0  34         inc   @edb.block.m2         ; M2++
     7348 A20E 
0136 734A 0584  14         inc   tmp0                  ; Increase source line number too!
0137                       ;------------------------------------------------------
0138                       ; Copy line
0139                       ;------------------------------------------------------
0140               edb.block.copy.loop.docopy:
0141 734C C804  38         mov   tmp0,@parm1           ; Source line for copy
     734E 2F20 
0142 7350 C805  38         mov   tmp1,@parm2           ; Target line for copy
     7352 2F22 
0143               
0144 7354 06A0  32         bl    @edb.line.copy        ; Copy line
     7356 7044 
0145                                                   ; \ i  @parm1 = Source line in editor buffer
0146                                                   ; / i  @parm2 = Target line in editor buffer
0147                       ;------------------------------------------------------
0148                       ; Housekeeping for next copy
0149                       ;------------------------------------------------------
0150 7358 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     735A A204 
0151 735C 0584  14         inc   tmp0                  ; Next source line
0152 735E 0585  14         inc   tmp1                  ; Next target line
0153 7360 0606  14         dec   tmp2                  ; Update ĺoop counter
0154 7362 15E2  14         jgt   edb.block.copy.loop   ; Next line
0155                       ;------------------------------------------------------
0156                       ; Copy loop completed
0157                       ;------------------------------------------------------
0158 7364 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7366 A206 
0159 7368 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     736A A116 
0160 736C 0720  34         seto  @outparm1             ; Copy completed
     736E 2F30 
0161                       ;------------------------------------------------------
0162                       ; Exit
0163                       ;------------------------------------------------------
0164               edb.block.copy.exit:
0165 7370 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7372 2F20 
0166 7374 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0167 7376 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0168 7378 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0169 737A C2F9  30         mov   *stack+,r11           ; Pop R11
0170 737C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0127                       copy  "edb.block.del.asm"      ; Delete code block
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
0027 737E 0649  14         dect  stack
0028 7380 C64B  30         mov   r11,*stack            ; Save return address
0029 7382 0649  14         dect  stack
0030 7384 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7386 0649  14         dect  stack
0032 7388 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 738A 0649  14         dect  stack
0034 738C C646  30         mov   tmp2,*stack           ; Push tmp2
0035               
0036 738E 04E0  34         clr   @outparm1             ; No action (>0000)
     7390 2F30 
0037                       ;------------------------------------------------------
0038                       ; Asserts
0039                       ;------------------------------------------------------
0040 7392 C120  34         mov   @edb.block.m1,tmp0    ; \
     7394 A20C 
0041 7396 0584  14         inc   tmp0                  ; | M1 unset?
0042 7398 133F  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043               
0044 739A C160  34         mov   @edb.block.m2,tmp1    ; \
     739C A20E 
0045 739E 0584  14         inc   tmp0                  ; | M2 unset?
0046 73A0 133B  14         jeq   edb.block.delete.exit ; / Yes, exit early
0047                       ;------------------------------------------------------
0048                       ; Check message to display
0049                       ;------------------------------------------------------
0050 73A2 C120  34         mov   @parm1,tmp0           ; Message flag cleared?
     73A4 2F20 
0051 73A6 160E  14         jne   edb.block.delete.prep ; No, skip message display
0052                       ;------------------------------------------------------
0053                       ; Display "Deleting...."
0054                       ;------------------------------------------------------
0055 73A8 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     73AA A01C 
     73AC 2F20 
0056               
0057 73AE 06A0  32         bl    @pane.action.colorscheme.statlines
     73B0 793A 
0058                                                   ; Set color combination for status lines
0059                                                   ; \ i  @parm1 = Color combination
0060                                                   ; /
0061               
0062 73B2 06A0  32         bl    @hchar
     73B4 2788 
0063 73B6 1D00                   byte pane.botrow,0,32,50
     73B8 2032 
0064 73BA FFFF                   data eol              ; Remove markers and block shortcuts
0065               
0066 73BC 06A0  32         bl    @putat
     73BE 2444 
0067 73C0 1D00                   byte pane.botrow,0
0068 73C2 362C                   data txt.block.del    ; Display "Deleting block...."
0069                       ;------------------------------------------------------
0070                       ; Prepare for delete
0071                       ;------------------------------------------------------
0072               edb.block.delete.prep:
0073 73C4 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     73C6 A20C 
0074 73C8 0604  14         dec   tmp0                  ; Base 0
0075               
0076 73CA C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     73CC A20E 
0077 73CE 0605  14         dec   tmp1                  ; Base 0
0078               
0079 73D0 C804  38         mov   tmp0,@parm1           ; Delete line on M1
     73D2 2F20 
0080 73D4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     73D6 A204 
     73D8 2F22 
0081 73DA 0620  34         dec   @parm2                ; Base 0
     73DC 2F22 
0082               
0083 73DE C185  18         mov   tmp1,tmp2             ; \
0084 73E0 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0085 73E2 0586  14         inc   tmp2                  ; /
0086                       ;------------------------------------------------------
0087                       ; Delete block
0088                       ;------------------------------------------------------
0089               edb.block.delete.loop:
0090 73E4 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     73E6 6CD6 
0091                                                   ; \ i  @parm1 = Line in editor buffer
0092                                                   ; / i  @parm2 = Last line for index reorg
0093               
0094 73E8 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     73EA A204 
0095 73EC 0620  34         dec   @parm2                ; /
     73EE 2F22 
0096               
0097 73F0 0606  14         dec   tmp2
0098 73F2 15F8  14         jgt   edb.block.delete.loop ; Next line
0099 73F4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     73F6 A206 
0100                       ;------------------------------------------------------
0101                       ; Set topline for framebuffer refresh
0102                       ;------------------------------------------------------
0103 73F8 8820  54         c     @fb.topline,@edb.lines
     73FA A104 
     73FC A204 
0104                                                   ; Beyond editor buffer?
0105 73FE 1504  14         jgt   !                     ; Yes, goto line 1
0106               
0107 7400 C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     7402 A104 
     7404 2F20 
0108 7406 1002  14         jmp   edb.block.delete.fb.refresh
0109 7408 04E0  34 !       clr   @parm1                ; Set line to start with
     740A 2F20 
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer and reset block markers
0112                       ;------------------------------------------------------
0113               edb.block.delete.fb.refresh:
0114 740C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     740E 6AB4 
0115                                                   ; | i  @parm1 = Line to start with
0116                                                   ; /             (becomes @fb.topline)
0117               
0118 7410 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     7412 7242 
0119               
0120 7414 0720  34         seto  @outparm1             ; Delete completed
     7416 2F30 
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               edb.block.delete.exit:
0125 7418 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 741A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 741C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 741E C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.464228
0128                       ;-----------------------------------------------------------------------
0129                       ; Command buffer handling
0130                       ;-----------------------------------------------------------------------
0131                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 7420 0649  14         dect  stack
0023 7422 C64B  30         mov   r11,*stack            ; Save return address
0024 7424 0649  14         dect  stack
0025 7426 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7428 0649  14         dect  stack
0027 742A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 742C 0649  14         dect  stack
0029 742E C646  30         mov   tmp2,*stack           ; Push tmp2
0030 7430 0649  14         dect  stack
0031 7432 C660  46         mov   @wyx,*stack           ; Push cursor position
     7434 832A 
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 7436 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     7438 A310 
     743A 832A 
0036               
0037 743C 05A0  34         inc   @wyx                  ; X +1 for prompt
     743E 832A 
0038               
0039 7440 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7442 23FC 
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 7444 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     7446 A327 
0044 7448 0206  20         li    tmp2,1*79             ; Command length
     744A 004F 
0045               
0046 744C 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     744E 2452 
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 7450 C820  54         mov   @cmdb.yxprompt,@wyx
     7452 A310 
     7454 832A 
0054 7456 06A0  32         bl    @putstr
     7458 2420 
0055 745A 3A02                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 745C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     745E 832A 
0061 7460 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 7462 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 7464 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 7466 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 7468 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0132                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 746A 0649  14         dect  stack
0023 746C C64B  30         mov   r11,*stack            ; Save return address
0024 746E 0649  14         dect  stack
0025 7470 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7472 0649  14         dect  stack
0027 7474 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 7476 0649  14         dect  stack
0029 7478 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 747A 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     747C A326 
0034 747E 06A0  32         bl    @film                 ; Clear command
     7480 2238 
0035 7482 A327                   data  cmdb.cmd,>00,80
     7484 0000 
     7486 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 7488 C120  34         mov   @cmdb.yxprompt,tmp0
     748A A310 
0040 748C 0584  14         inc   tmp0
0041 748E C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     7490 A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 7492 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 7494 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 7496 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7498 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 749A 045B  20         b     *r11                  ; Return to caller
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
0075 749C 0649  14         dect  stack
0076 749E C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 74A0 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     74A2 2A8E 
0081 74A4 A327                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     74A6 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 74A8 C820  54         mov   @waux1,@outparm1     ; Save length of string
     74AA 833C 
     74AC 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 74AE C2F9  30         mov   *stack+,r11           ; Pop r11
0090 74B0 045B  20         b     *r11                  ; Return to caller
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
0115 74B2 0649  14         dect  stack
0116 74B4 C64B  30         mov   r11,*stack            ; Save return address
0117 74B6 0649  14         dect  stack
0118 74B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 74BA 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     74BC 749C 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Assert
0125                       ;------------------------------------------------------
0126 74BE C120  34         mov   @outparm1,tmp0        ; Check length
     74C0 2F30 
0127 74C2 1300  14         jeq   cmdb.cmd.history.add.exit
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
0139 74C4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 74C6 C2F9  30         mov   *stack+,r11           ; Pop r11
0141 74C8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0133                       ;-----------------------------------------------------------------------
0134                       ; File handling
0135                       ;-----------------------------------------------------------------------
0136                       copy  "fm.browse.asm"       ; File manager browse support routines
**** **** ****     > fm.browse.asm
0001               * FILE......: fm.browse.asm
0002               * Purpose...: File Manager - File browse support routines
0003               
0004               *---------------------------------------------------------------
0005               * Increase/Decrease last-character of current filename
0006               *---------------------------------------------------------------
0007               * bl   @fm.browse.fname.suffix
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * parm1        = Pointer to device and filename
0011               * parm2        = Increase (>FFFF) or Decrease (>0000) ASCII
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0, tmp1
0015               ********|*****|*********************|**************************
0016               fm.browse.fname.suffix.incdec:
0017 74CA 0649  14         dect  stack
0018 74CC C64B  30         mov   r11,*stack            ; Save return address
0019 74CE 0649  14         dect  stack
0020 74D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 74D2 0649  14         dect  stack
0022 74D4 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Assert
0025                       ;------------------------------------------------------
0026 74D6 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     74D8 2F20 
0027 74DA 1334  14         jeq   fm.browse.fname.suffix.exit
0028                                                   ; Exit early if pointer is nill
0029               
0030 74DC 0284  22         ci    tmp0,txt.newfile
     74DE 369A 
0031 74E0 1331  14         jeq   fm.browse.fname.suffix.exit
0032                                                   ; Exit early if "New file"
0033                       ;------------------------------------------------------
0034                       ; Get last character in filename
0035                       ;------------------------------------------------------
0036 74E2 D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0037 74E4 0985  56         srl   tmp1,8                ; MSB to LSB
0038               
0039 74E6 A105  18         a     tmp1,tmp0             ; Move to last character
0040 74E8 04C5  14         clr   tmp1
0041 74EA D154  26         movb  *tmp0,tmp1            ; Get character
0042 74EC 0985  56         srl   tmp1,8                ; MSB to LSB
0043 74EE 132A  14         jeq   fm.browse.fname.suffix.exit
0044                                                   ; Exit early if empty filename
0045                       ;------------------------------------------------------
0046                       ; Check mode (increase/decrease) character ASCII value
0047                       ;------------------------------------------------------
0048 74F0 C1A0  34         mov   @parm2,tmp2           ; Get mode
     74F2 2F22 
0049 74F4 1314  14         jeq   fm.browse.fname.suffix.dec
0050                                                   ; Decrease ASCII if mode = 0
0051                       ;------------------------------------------------------
0052                       ; Increase ASCII value last character in filename
0053                       ;------------------------------------------------------
0054               fm.browse.fname.suffix.inc:
0055 74F6 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     74F8 0030 
0056 74FA 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0057 74FC 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     74FE 0039 
0058 7500 1109  14         jlt   !                     ; Next character
0059 7502 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0060                                                   ; Swith to alpha range A..Z
0061 7504 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     7506 005A 
0062 7508 131D  14         jeq   fm.browse.fname.suffix.exit
0063                                                   ; Already last alpha character, so exit
0064 750A 1104  14         jlt   !                     ; Next character
0065                       ;------------------------------------------------------
0066                       ; Invalid character, crash and burn
0067                       ;------------------------------------------------------
0068               fm.browse.fname.suffix.inc.crash:
0069 750C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     750E FFCE 
0070 7510 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7512 2026 
0071                       ;------------------------------------------------------
0072                       ; Increase ASCII value last character in filename
0073                       ;------------------------------------------------------
0074 7514 0585  14 !       inc   tmp1                  ; Increase ASCII value
0075 7516 1014  14         jmp   fm.browse.fname.suffix.store
0076               fm.browse.fname.suffix.inc.alpha:
0077 7518 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     751A 0041 
0078 751C 1011  14         jmp   fm.browse.fname.suffix.store
0079                       ;------------------------------------------------------
0080                       ; Decrease ASCII value last character in filename
0081                       ;------------------------------------------------------
0082               fm.browse.fname.suffix.dec:
0083 751E 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     7520 0030 
0084 7522 1310  14         jeq   fm.browse.fname.suffix.exit
0085                                                   ; Already first numeric character, so exit
0086 7524 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7526 0039 
0087 7528 1207  14         jle   !                     ; Previous character
0088 752A 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     752C 0041 
0089 752E 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0090                                                   ; Switch to numeric range 0..9
0091 7530 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0092                                                   ; Invalid character
0093 7532 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     7534 0084 
0094 7536 1306  14         jeq   fm.browse.fname.suffix.exit
0095 7538 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0096 753A 1002  14         jmp   fm.browse.fname.suffix.store
0097               fm.browse.fname.suffix.dec.numeric:
0098 753C 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     753E 0039 
0099                       ;------------------------------------------------------
0100                       ; Store updatec character
0101                       ;------------------------------------------------------
0102               fm.browse.fname.suffix.store:
0103 7540 0A85  56         sla   tmp1,8                ; LSB to MSB
0104 7542 D505  30         movb  tmp1,*tmp0            ; Store updated character
0105                       ;------------------------------------------------------
0106                       ; Exit
0107                       ;------------------------------------------------------
0108               fm.browse.fname.suffix.exit:
0109 7544 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0110 7546 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111 7548 C2F9  30         mov   *stack+,r11           ; Pop R11
0112 754A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0137                       copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation
**** **** ****     > fm.fastmode.asm
0001               * FILE......: fm.fastmode.asm
0002               * Purpose...: Turn fastmode on/off for file operation
0003               
0004               ***************************************************************
0005               * fm.fastmode
0006               * Turn on fast mode for supported devices
0007               ***************************************************************
0008               * bl  @fm.fastmode
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *---------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0, tmp1
0018               ********|*****|*********************|**************************
0019               fm.fastmode:
0020 754C 0649  14         dect  stack
0021 754E C64B  30         mov   r11,*stack            ; Save return address
0022 7550 0649  14         dect  stack
0023 7552 C644  30         mov   tmp0,*stack           ; Push tmp0
0024               
0025 7554 C120  34         mov   @fh.offsetopcode,tmp0
     7556 A44E 
0026 7558 1307  14         jeq   !
0027                       ;------------------------------------------------------
0028                       ; Turn fast mode off
0029                       ;------------------------------------------------------
0030 755A 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     755C A44E 
0031 755E 0204  20         li    tmp0,txt.keys.load
     7560 3748 
0032 7562 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7564 A322 
0033 7566 1008  14         jmp   fm.fastmode.exit
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode on
0036                       ;------------------------------------------------------
0037 7568 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     756A 0040 
0038 756C C804  38         mov   tmp0,@fh.offsetopcode
     756E A44E 
0039 7570 0204  20         li    tmp0,txt.keys.load2
     7572 3782 
0040 7574 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7576 A322 
0041               *--------------------------------------------------------------
0042               * Exit
0043               *--------------------------------------------------------------
0044               fm.fastmode.exit:
0045 7578 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 757A C2F9  30         mov   *stack+,r11           ; Pop R11
0047 757C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0138                       ;-----------------------------------------------------------------------
0139                       ; User hook, background tasks
0140                       ;-----------------------------------------------------------------------
0141                       copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 757E 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7580 200A 
0009 7582 1612  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 7584 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7586 833C 
     7588 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 758A 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     758C 200A 
0016 758E 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     7590 2F40 
     7592 2F42 
0017 7594 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0018               *--------------------------------------------------------------
0019               * New key pressed
0020               *--------------------------------------------------------------
0021 7596 0204  20         li    tmp0,250              ; \
     7598 00FA 
0022 759A 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0023 759C 16FE  14         jne   -!                    ; /
0024 759E C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     75A0 2F40 
     75A2 2F42 
0025 75A4 0460  28         b     @edkey.key.process    ; Process key
     75A6 60E4 
0026               *--------------------------------------------------------------
0027               * Clear keyboard buffer if no key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.clear_kbbuffer:
0030 75A8 04E0  34         clr   @keycode1
     75AA 2F40 
0031 75AC 04E0  34         clr   @keycode2
     75AE 2F42 
0032               *--------------------------------------------------------------
0033               * Delay to avoid key bouncing
0034               *--------------------------------------------------------------
0035               hook.keyscan.bounce:
0036 75B0 0204  20         li    tmp0,2000             ; Avoid key bouncing
     75B2 07D0 
0037                       ;------------------------------------------------------
0038                       ; Delay loop
0039                       ;------------------------------------------------------
0040               hook.keyscan.bounce.loop:
0041 75B4 0604  14         dec   tmp0
0042 75B6 16FE  14         jne   hook.keyscan.bounce.loop
0043 75B8 0460  28         b     @hookok               ; Return
     75BA 2D0E 
0044               
**** **** ****     > stevie_b1.asm.464228
0142                       copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 75BC 0649  14         dect  stack
0009 75BE C64B  30         mov   r11,*stack            ; Save return address
0010 75C0 0649  14         dect  stack
0011 75C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 75C4 0649  14         dect  stack
0013 75C6 C660  46         mov   @wyx,*stack           ; Push cursor position
     75C8 832A 
0014                       ;------------------------------------------------------
0015                       ; ALPHA-Lock key down?
0016                       ;------------------------------------------------------
0017               task.vdp.panes.alpha_lock:
0018 75CA 20A0  38         coc   @wbit10,config
     75CC 200C 
0019 75CE 1305  14         jeq   task.vdp.panes.alpha_lock.down
0020                       ;------------------------------------------------------
0021                       ; AlPHA-Lock is up
0022                       ;------------------------------------------------------
0023 75D0 06A0  32         bl    @putat
     75D2 2444 
0024 75D4 1D4F                   byte   pane.botrow,79
0025 75D6 36E0                   data   txt.alpha.up
0026 75D8 1004  14         jmp   task.vdp.panes.cmdb.check
0027                       ;------------------------------------------------------
0028                       ; AlPHA-Lock is down
0029                       ;------------------------------------------------------
0030               task.vdp.panes.alpha_lock.down:
0031 75DA 06A0  32         bl    @putat
     75DC 2444 
0032 75DE 1D4F                   byte   pane.botrow,79
0033 75E0 36E2                   data   txt.alpha.down
0034                       ;------------------------------------------------------
0035                       ; Command buffer visible ?
0036                       ;------------------------------------------------------
0037               task.vdp.panes.cmdb.check
0038 75E2 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     75E4 A302 
0039 75E6 1308  14         jeq   !                     ; No, skip CMDB pane
0040                       ;-------------------------------------------------------
0041                       ; Draw command buffer pane if dirty
0042                       ;-------------------------------------------------------
0043               task.vdp.panes.cmdb.draw:
0044 75E8 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     75EA A318 
0045 75EC 131F  14         jeq   task.vdp.panes.exit   ; No, skip update
0046               
0047 75EE 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     75F0 7A30 
0048 75F2 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     75F4 A318 
0049 75F6 101A  14         jmp   task.vdp.panes.exit   ; Exit early
0050                       ;-------------------------------------------------------
0051                       ; Check if frame buffer dirty
0052                       ;-------------------------------------------------------
0053 75F8 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     75FA A116 
0054 75FC 130E  14         jeq   task.vdp.panes.statlines
0055                                                   ; No, skip update
0056               
0057 75FE C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     7600 A11A 
     7602 2F20 
0058 7604 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7606 6B24 
0059                                                   ; \ i  @parm1 = number of lines to dump
0060                                                   ; /
0061                       ;------------------------------------------------------
0062                       ; Color the lines in the framebuffer (TAT)
0063                       ;------------------------------------------------------
0064 7608 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     760A A110 
0065 760C 1302  14         jeq   task.vdp.panes.dumped ; Skip if flag reset
0066               
0067 760E 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     7610 6B6A 
0068                       ;-------------------------------------------------------
0069                       ; Finished with frame buffer
0070                       ;-------------------------------------------------------
0071               task.vdp.panes.dumped:
0072 7612 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     7614 A116 
0073 7616 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     7618 A118 
0074                       ;-------------------------------------------------------
0075                       ; Refresh top and bottom line
0076                       ;-------------------------------------------------------
0077               task.vdp.panes.statlines:
0078 761A C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     761C A118 
0079 761E 1306  14         jeq   task.vdp.panes.exit   ; No, skip update
0080               
0081 7620 06A0  32         bl    @pane.topline         ; Draw top line
     7622 7B14 
0082 7624 06A0  32         bl    @pane.botline         ; Draw bottom line
     7626 7C60 
0083 7628 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     762A A118 
0084                       ;------------------------------------------------------
0085                       ; Exit task
0086                       ;------------------------------------------------------
0087               task.vdp.panes.exit:
0088 762C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     762E 832A 
0089 7630 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0090 7632 C2F9  30         mov   *stack+,r11           ; Pop r11
0091 7634 0460  28         b     @slotok
     7636 2D8A 
**** **** ****     > stevie_b1.asm.464228
0143                       copy  "task.vdp.cursor.sat.asm"    ; Copy cursor SAT to VDP
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 7638 0649  14         dect  stack
0009 763A C64B  30         mov   r11,*stack            ; Save return address
0010 763C 0649  14         dect  stack
0011 763E C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7640 0649  14         dect  stack
0013 7642 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7644 0649  14         dect  stack
0015 7646 C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 7648 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     764A A01E 
0020               
0021 764C 0284  22         ci    tmp0,pane.focus.fb
     764E 0000 
0022 7650 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7652 0284  22         ci    tmp0,pane.focus.cmdb
     7654 0001 
0025 7656 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 7658 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     765A FFCE 
0031 765C 06A0  32         bl    @cpu.crash            ; / Halt system.
     765E 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7660 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7662 A30A 
     7664 832A 
0037 7666 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7668 2020 
0038 766A 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     766C 26B6 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 766E 1006  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 7670 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7672 2020 
0048 7674 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7676 26B6 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 7678 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline bar
     767A 0800 
0053                       ;------------------------------------------------------
0054                       ; Dump sprite attribute table
0055                       ;------------------------------------------------------
0056               task.vdp.copy.sat.write:
0057 767C C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     767E 2F5A 
0058               
0059 7680 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7682 244C 
0060 7684 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     7686 2F5A 
     7688 0004 
0061                                                   ; | i  tmp1 = ROM/RAM source
0062                                                   ; / i  tmp2 = Number of bytes to write
0063                       ;------------------------------------------------------
0064                       ; Exit
0065                       ;------------------------------------------------------
0066               task.vdp.copy.sat.exit:
0067 768A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0068 768C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0069 768E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7690 C2F9  30         mov   *stack+,r11           ; Pop r11
0071 7692 0460  28         b     @slotok               ; Exit task
     7694 2D8A 
**** **** ****     > stevie_b1.asm.464228
0144                       copy  "task.vdp.cursor.blink.asm"  ; Set cursor shape in VDP (blink)
**** **** ****     > task.vdp.cursor.blink.asm
0001               * FILE......: task.vdp.cursor.blink.asm
0002               * Purpose...: VDP sprite cursor shape
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ***************************************************************
0007               task.vdp.cursor:
0008 7696 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     7698 A112 
0009 769A 1303  14         jeq   task.vdp.cursor.visible
0010 769C 04E0  34         clr   @ramsat+2              ; Hide cursor
     769E 2F5C 
0011 76A0 1015  14         jmp   task.vdp.cursor.copy.sat
0012                                                    ; Update VDP SAT and exit task
0013               task.vdp.cursor.visible:
0014 76A2 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     76A4 A20A 
0015 76A6 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0016                       ;------------------------------------------------------
0017                       ; Cursor in insert mode
0018                       ;------------------------------------------------------
0019               task.vdp.cursor.visible.insert_mode:
0020 76A8 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     76AA A01E 
0021 76AC 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0022                                                    ; Framebuffer has focus
0023 76AE 0284  22         ci    tmp0,pane.focus.cmdb
     76B0 0001 
0024 76B2 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0025                       ;------------------------------------------------------
0026                       ; Editor cursor (insert mode)
0027                       ;------------------------------------------------------
0028               task.vdp.cursor.visible.insert_mode.fb:
0029 76B4 04C4  14         clr   tmp0                   ; Cursor FB insert mode
0030 76B6 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0031                       ;------------------------------------------------------
0032                       ; Command buffer cursor (insert mode)
0033                       ;------------------------------------------------------
0034               task.vdp.cursor.visible.insert_mode.cmdb:
0035 76B8 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     76BA 0100 
0036 76BC 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0037                       ;------------------------------------------------------
0038                       ; Cursor in overwrite mode
0039                       ;------------------------------------------------------
0040               task.vdp.cursor.visible.overwrite_mode:
0041 76BE 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     76C0 0200 
0042                       ;------------------------------------------------------
0043                       ; Set cursor shape
0044                       ;------------------------------------------------------
0045               task.vdp.cursor.visible.cursorshape:
0046 76C2 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     76C4 A014 
0047 76C6 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     76C8 A014 
     76CA 2F5C 
0048                       ;------------------------------------------------------
0049                       ; Copy SAT
0050                       ;------------------------------------------------------
0051               task.vdp.cursor.copy.sat:
0052 76CC 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     76CE 244C 
0053 76D0 2180                   data sprsat,ramsat,4   ; \ i  p0 = VDP destination
     76D2 2F5A 
     76D4 0004 
0054                                                    ; | i  p1 = ROM/RAM source
0055                                                    ; / i  p2 = Number of bytes to write
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               task.vdp.cursor.exit:
0060 76D6 0460  28         b     @slotok                ; Exit task
     76D8 2D8A 
**** **** ****     > stevie_b1.asm.464228
0145                       copy  "task.oneshot.asm"           ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 76DA C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     76DC A020 
0010 76DE 1301  14         jeq   task.oneshot.exit
0011               
0012 76E0 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 76E2 0460  28         b     @slotok                ; Exit task
     76E4 2D8A 
**** **** ****     > stevie_b1.asm.464228
0146                       ;-----------------------------------------------------------------------
0147                       ; Screen pane utilities
0148                       ;-----------------------------------------------------------------------
0149                       copy  "pane.utils.asm"             ; Pane utility functions
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
0020 76E6 0649  14         dect  stack
0021 76E8 C64B  30         mov   r11,*stack            ; Push return address
0022 76EA 0649  14         dect  stack
0023 76EC C660  46         mov   @wyx,*stack           ; Push cursor position
     76EE 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 76F0 06A0  32         bl    @hchar
     76F2 2788 
0028 76F4 0034                   byte 0,52,32,18
     76F6 2012 
0029 76F8 FFFF                   data EOL              ; Clear message
0030               
0031 76FA 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     76FC A020 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 76FE C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7700 832A 
0037 7702 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 7704 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.464228
0150                       copy  "pane.utils.hint.asm"        ; Show hint in pane
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
0021 7706 0649  14         dect  stack
0022 7708 C64B  30         mov   r11,*stack            ; Save return address
0023 770A 0649  14         dect  stack
0024 770C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 770E 0649  14         dect  stack
0026 7710 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7712 0649  14         dect  stack
0028 7714 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7716 0649  14         dect  stack
0030 7718 C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 771A C820  54         mov   @parm1,@wyx           ; Set cursor
     771C 2F20 
     771E 832A 
0035 7720 C160  34         mov   @parm2,tmp1           ; Get string to display
     7722 2F22 
0036 7724 06A0  32         bl    @xutst0               ; Display string
     7726 2422 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 7728 C120  34         mov   @parm2,tmp0
     772A 2F22 
0041 772C D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 772E 0984  56         srl   tmp0,8                ; Right justify
0043 7730 C184  18         mov   tmp0,tmp2
0044 7732 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 7734 0506  16         neg   tmp2
0046 7736 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7738 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 773A C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     773C 2F20 
0051 773E A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 7740 C804  38         mov   tmp0,@wyx             ; / Set cursor
     7742 832A 
0053               
0054 7744 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7746 23FC 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 7748 0205  20         li    tmp1,32               ; Byte to fill
     774A 0020 
0059               
0060 774C 06A0  32         bl    @xfilv                ; Clear line
     774E 2296 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 7750 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 7752 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 7754 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 7756 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 7758 C2F9  30         mov   *stack+,r11           ; Pop R11
0073 775A 045B  20         b     *r11                  ; Return to caller
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
0095 775C C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     775E 2F20 
0096 7760 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7762 2F22 
0097 7764 0649  14         dect  stack
0098 7766 C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 7768 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     776A 7706 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 776C C2F9  30         mov   *stack+,r11           ; Pop R11
0108 776E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0151                       copy  "pane.utils.cursor.asm"      ; Cursor utility functions
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
0020 7770 0649  14         dect  stack
0021 7772 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 7774 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7776 2290 
0026 7778 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     777A 0000 
     777C 0004 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 777E 06A0  32         bl    @clslot
     7780 2DE6 
0031 7782 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 7784 06A0  32         bl    @clslot
     7786 2DE6 
0034 7788 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 778A C2F9  30         mov   *stack+,r11           ; Pop R11
0040 778C 045B  20         b     *r11                  ; Return to caller
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
0060 778E 0649  14         dect  stack
0061 7790 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 7792 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7794 2290 
0066 7796 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7798 0000 
     779A 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0070 779C 06A0  32         bl    @mkslot
     779E 2DC8 
0071 77A0 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     77A2 7638 
0072 77A4 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     77A6 7696 
0073 77A8 FFFF                   data eol
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077               pane.cursor.blink.exit:
0078 77AA C2F9  30         mov   *stack+,r11           ; Pop R11
0079 77AC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0152                       copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes
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
0017 77AE 0649  14         dect  stack
0018 77B0 C64B  30         mov   r11,*stack            ; Push return address
0019 77B2 0649  14         dect  stack
0020 77B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 77B6 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     77B8 A012 
0023 77BA 0284  22         ci    tmp0,tv.colorscheme.entries
     77BC 0009 
0024                                                   ; Last entry reached?
0025 77BE 1103  14         jlt   !
0026 77C0 0204  20         li    tmp0,1                ; Reset color scheme index
     77C2 0001 
0027 77C4 1001  14         jmp   pane.action.colorscheme.switch
0028 77C6 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 77C8 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     77CA A012 
0034               
0035 77CC 06A0  32         bl    @pane.action.colorscheme.load
     77CE 780C 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 77D0 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     77D2 832A 
     77D4 833C 
0041               
0042 77D6 06A0  32         bl    @putnum
     77D8 2A18 
0043 77DA 003E                   byte 0,62
0044 77DC A012                   data tv.colorscheme,rambuf,>3020
     77DE 2F6A 
     77E0 3020 
0045               
0046 77E2 06A0  32         bl    @putat
     77E4 2444 
0047 77E6 0034                   byte 0,52
0048 77E8 3A1C                   data txt.colorscheme  ; Show color palette message
0049               
0050 77EA C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     77EC 833C 
     77EE 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 77F0 0204  20         li    tmp0,12000
     77F2 2EE0 
0055 77F4 0604  14 !       dec   tmp0
0056 77F6 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 77F8 0204  20         li    tmp0,pane.clearmsg.task.callback
     77FA 76E6 
0061 77FC C804  38         mov   tmp0,@tv.task.oneshot
     77FE A020 
0062               
0063 7800 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     7802 2DF4 
0064 7804 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 7806 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7808 C2F9  30         mov   *stack+,r11           ; Pop R11
0071 780A 045B  20         b     *r11                  ; Return to caller
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
0084               *--------------------------------------------------------------
0085               * OUTPUT
0086               * none
0087               *--------------------------------------------------------------
0088               * Register usage
0089               * tmp0,tmp1,tmp2,tmp3,tmp4
0090               ********|*****|*********************|**************************
0091               pane.action.colorscheme.load:
0092 780C 0649  14         dect  stack
0093 780E C64B  30         mov   r11,*stack            ; Save return address
0094 7810 0649  14         dect  stack
0095 7812 C644  30         mov   tmp0,*stack           ; Push tmp0
0096 7814 0649  14         dect  stack
0097 7816 C645  30         mov   tmp1,*stack           ; Push tmp1
0098 7818 0649  14         dect  stack
0099 781A C646  30         mov   tmp2,*stack           ; Push tmp2
0100 781C 0649  14         dect  stack
0101 781E C647  30         mov   tmp3,*stack           ; Push tmp3
0102 7820 0649  14         dect  stack
0103 7822 C648  30         mov   tmp4,*stack           ; Push tmp4
0104 7824 0649  14         dect  stack
0105 7826 C660  46         mov   @parm1,*stack         ; Push parm1
     7828 2F20 
0106                       ;-------------------------------------------------------
0107                       ; Turn screen of
0108                       ;-------------------------------------------------------
0109 782A C120  34         mov   @parm1,tmp0
     782C 2F20 
0110 782E 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7830 FFFF 
0111 7832 1302  14         jeq   !                     ; Yes, so skip screen off
0112 7834 06A0  32         bl    @scroff               ; Turn screen off
     7836 2654 
0113                       ;-------------------------------------------------------
0114                       ; Get FG/BG colors framebuffer text
0115                       ;-------------------------------------------------------
0116 7838 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     783A A012 
0117 783C 0604  14         dec   tmp0                  ; Internally work with base 0
0118               
0119 783E 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0120 7840 0224  22         ai    tmp0,tv.colorscheme.table
     7842 3434 
0121                                                   ; Add base for color scheme data table
0122 7844 C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0123 7846 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7848 A018 
0124                       ;-------------------------------------------------------
0125                       ; Get and save cursor color
0126                       ;-------------------------------------------------------
0127 784A C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0128 784C 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     784E 00FF 
0129 7850 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7852 A016 
0130                       ;-------------------------------------------------------
0131                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0132                       ;-------------------------------------------------------
0133 7854 C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0134 7856 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7858 FF00 
0135 785A 0988  56         srl   tmp4,8                ; MSB to LSB
0136               
0137 785C C134  30         mov   *tmp0+,tmp0           ; Get colors IJKL
0138               
0139 785E C144  18         mov   tmp0,tmp1             ; \ Right align IJ and
0140 7860 0985  56         srl   tmp1,8                ; | save to @tv.busycolor
0141 7862 C805  38         mov   tmp1,@tv.busycolor    ; /
     7864 A01C 
0142               
0143 7866 C144  18         mov   tmp0,tmp1             ; \ Right align KL and
0144 7868 0245  22         andi  tmp1,>00ff            ; | save to @tv.markcolor
     786A 00FF 
0145 786C C805  38         mov   tmp1,@tv.markcolor    ; /
     786E A01A 
0146               
0147                       ;-------------------------------------------------------
0148                       ; Dump colors to VDP register 7 (text mode)
0149                       ;-------------------------------------------------------
0150 7870 C147  18         mov   tmp3,tmp1             ; Get work copy
0151 7872 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0152 7874 0265  22         ori   tmp1,>0700
     7876 0700 
0153 7878 C105  18         mov   tmp1,tmp0
0154 787A 06A0  32         bl    @putvrx               ; Write VDP register
     787C 2336 
0155                       ;-------------------------------------------------------
0156                       ; Dump colors for frame buffer pane (TAT)
0157                       ;-------------------------------------------------------
0158 787E 0204  20         li    tmp0,vdp.fb.toprow.tat
     7880 1850 
0159                                                   ; VDP start address (frame buffer area)
0160 7882 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0161 7884 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0162 7886 0206  20         li    tmp2,(pane.botrow-1)*80
     7888 08C0 
0163                                                   ; Number of bytes to fill
0164 788A 06A0  32         bl    @xfilv                ; Fill colors
     788C 2296 
0165                                                   ; i \  tmp0 = start address
0166                                                   ; i |  tmp1 = byte to fill
0167                                                   ; i /  tmp2 = number of bytes to fill
0168               
0169 788E 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     7890 A110 
0170 7892 06A0  32         bl    @fb.colorlines
     7894 6B6A 
0171                       ;-------------------------------------------------------
0172                       ; Dump colors for CMDB pane (TAT)
0173                       ;-------------------------------------------------------
0174               pane.action.colorscheme.cmdbpane:
0175 7896 C120  34         mov   @cmdb.visible,tmp0
     7898 A302 
0176 789A 1315  14         jeq   pane.action.colorscheme.errpane
0177                                                   ; Skip if CMDB pane is hidden
0178               
0179 789C 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     789E 1FD0 
0180                                                   ; VDP start address (CMDB top line)
0181               
0182 78A0 C160  34         mov   @tv.color,tmp1        ; set color for header line
     78A2 A018 
0183 78A4 0245  22         andi  tmp1,>00ff
     78A6 00FF 
0184 78A8 C185  18         mov   tmp1,tmp2
0185 78AA 0A45  56         sla   tmp1,4
0186 78AC 0946  56         srl   tmp2,4
0187 78AE E146  18         soc   tmp2,tmp1             ; OR
0188               
0189 78B0 0206  20         li    tmp2,4*80             ; Number of bytes to fill
     78B2 0140 
0190 78B4 06A0  32         bl    @xfilv                ; Fill colors
     78B6 2296 
0191                                                   ; i \  tmp0 = start address
0192                                                   ; i |  tmp1 = byte to fill
0193                                                   ; i /  tmp2 = number of bytes to fill
0194               
0195 78B8 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     78BA 2020 
0196                                                   ; VDP start address (CMDB top line + 1)
0197 78BC C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0198 78BE 0206  20         li    tmp2,4*80             ; Number of bytes to fill
     78C0 0140 
0199 78C2 06A0  32         bl    @xfilv                ; Fill colors
     78C4 2296 
0200                                                   ; i \  tmp0 = start address
0201                                                   ; i |  tmp1 = byte to fill
0202                                                   ; i /  tmp2 = number of bytes to fill
0203                       ;-------------------------------------------------------
0204                       ; Dump colors for error line (TAT)
0205                       ;-------------------------------------------------------
0206               pane.action.colorscheme.errpane:
0207 78C6 C120  34         mov   @tv.error.visible,tmp0
     78C8 A024 
0208 78CA 130A  14         jeq   pane.action.colorscheme.statline
0209                                                   ; Skip if error line pane is hidden
0210               
0211 78CC 0205  20         li    tmp1,>00f6            ; White on dark red
     78CE 00F6 
0212 78D0 C805  38         mov   tmp1,@parm1           ; Pass color combination
     78D2 2F20 
0213               
0214 78D4 0205  20         li    tmp1,pane.botrow-1    ;
     78D6 001C 
0215 78D8 C805  38         mov   tmp1,@parm2           ; Error line on screen
     78DA 2F22 
0216               
0217 78DC 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78DE 7954 
0218                                                   ; \ i  @parm1 = Color combination
0219                                                   ; / i  @parm2 = Row on physical screen
0220                       ;-------------------------------------------------------
0221                       ; Dump colors for top line and bottom line (TAT)
0222                       ;-------------------------------------------------------
0223               pane.action.colorscheme.statline:
0224 78E0 C160  34         mov   @tv.color,tmp1
     78E2 A018 
0225 78E4 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     78E6 00FF 
0226 78E8 C805  38         mov   tmp1,@parm1           ; Set color combination
     78EA 2F20 
0227               
0228               
0229 78EC 04E0  34         clr   @parm2                ; Top row on screen
     78EE 2F22 
0230 78F0 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78F2 7954 
0231                                                   ; \ i  @parm1 = Color combination
0232                                                   ; / i  @parm2 = Row on physical screen
0233               
0234 78F4 0205  20         li    tmp1,pane.botrow
     78F6 001D 
0235 78F8 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     78FA 2F22 
0236 78FC 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78FE 7954 
0237                                                   ; \ i  @parm1 = Color combination
0238                                                   ; / i  @parm2 = Row on physical screen
0239                       ;-------------------------------------------------------
0240                       ; Dump cursor FG color to sprite table (SAT)
0241                       ;-------------------------------------------------------
0242               pane.action.colorscheme.cursorcolor:
0243 7900 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     7902 A016 
0244               
0245 7904 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7906 A01E 
0246 7908 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     790A 0000 
0247 790C 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0248                                                   ; Yes, set cursor color
0249               
0250               pane.action.colorscheme.cursorcolor.cmdb:
0251 790E 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     7910 00F0 
0252 7912 0A48  56         sla   tmp4,4                ; Move to MSB
0253 7914 1003  14         jmp   !
0254               
0255               pane.action.colorscheme.cursorcolor.fb:
0256 7916 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     7918 000F 
0257 791A 0A88  56         sla   tmp4,8                ; Move to MSB
0258               
0259 791C D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     791E 2F5D 
0260 7920 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7922 A015 
0261                       ;-------------------------------------------------------
0262                       ; Exit
0263                       ;-------------------------------------------------------
0264               pane.action.colorscheme.load.exit:
0265 7924 06A0  32         bl    @scron                ; Turn screen on
     7926 265C 
0266 7928 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     792A 2F20 
0267 792C C239  30         mov   *stack+,tmp4          ; Pop tmp4
0268 792E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0269 7930 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0270 7932 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0271 7934 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0272 7936 C2F9  30         mov   *stack+,r11           ; Pop R11
0273 7938 045B  20         b     *r11                  ; Return to caller
0274               
0275               
0276               
0277               ***************************************************************
0278               * pane.action.colorscheme.statline
0279               * Set color combination for bottom status line
0280               ***************************************************************
0281               * bl @pane.action.colorscheme.statlines
0282               *--------------------------------------------------------------
0283               * INPUT
0284               * @parm1 = Color combination to set
0285               *--------------------------------------------------------------
0286               * OUTPUT
0287               * none
0288               *--------------------------------------------------------------
0289               * Register usage
0290               * tmp0, tmp1, tmp2
0291               ********|*****|*********************|**************************
0292               pane.action.colorscheme.statlines:
0293 793A 0649  14         dect  stack
0294 793C C64B  30         mov   r11,*stack            ; Save return address
0295 793E 0649  14         dect  stack
0296 7940 C644  30         mov   tmp0,*stack           ; Push tmp0
0297                       ;------------------------------------------------------
0298                       ; Bottom line
0299                       ;------------------------------------------------------
0300 7942 0204  20         li    tmp0,pane.botrow
     7944 001D 
0301 7946 C804  38         mov   tmp0,@parm2           ; Last row on screen
     7948 2F22 
0302 794A 06A0  32         bl    @colors.line.set      ; Load color combination for line
     794C 7954 
0303                                                   ; \ i  @parm1 = Color combination
0304                                                   ; / i  @parm2 = Row on physical screen
0305                       ;------------------------------------------------------
0306                       ; Exit
0307                       ;------------------------------------------------------
0308               pane.action.colorscheme.statlines.exit:
0309 794E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0310 7950 C2F9  30         mov   *stack+,r11           ; Pop R11
0311 7952 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0153                       ;-----------------------------------------------------------------------
0154                       ; Screen panes
0155                       ;-----------------------------------------------------------------------
0156                       copy  "colors.line.set.asm" ; Set color combination for line
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
0021 7954 0649  14         dect  stack
0022 7956 C64B  30         mov   r11,*stack            ; Save return address
0023 7958 0649  14         dect  stack
0024 795A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 795C 0649  14         dect  stack
0026 795E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7960 0649  14         dect  stack
0028 7962 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7964 0649  14         dect  stack
0030 7966 C660  46         mov   @parm1,*stack         ; Push parm1
     7968 2F20 
0031 796A 0649  14         dect  stack
0032 796C C660  46         mov   @parm2,*stack         ; Push parm2
     796E 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 7970 C120  34         mov   @parm2,tmp0           ; Get target line
     7972 2F22 
0037 7974 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7976 0050 
0038 7978 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 797A C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 797C 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     797E 1800 
0042 7980 C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     7982 2F20 
0043 7984 0206  20         li    tmp2,80               ; Number of bytes to fill
     7986 0050 
0044               
0045 7988 06A0  32         bl    @xfilv                ; Fill colors
     798A 2296 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 798C C839  50         mov   *stack+,@parm2        ; Pop @parm2
     798E 2F22 
0054 7990 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7992 2F20 
0055 7994 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7996 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7998 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 799A C2F9  30         mov   *stack+,r11           ; Pop R11
0059 799C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0157                       copy  "pane.cmdb.asm"       ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.464228
0158                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
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
0022 799E 0649  14         dect  stack
0023 79A0 C64B  30         mov   r11,*stack            ; Save return address
0024 79A2 0649  14         dect  stack
0025 79A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 79A6 C820  54         mov   @wyx,@cmdb.fb.yxsave
     79A8 832A 
     79AA A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 79AC 0204  20         li    tmp0,pane.botrow
     79AE 001D 
0033 79B0 6120  34         s     @cmdb.scrrows,tmp0
     79B2 A306 
0034 79B4 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     79B6 A11A 
0035               
0036 79B8 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 79BA C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     79BC A30E 
0038               
0039 79BE 0224  22         ai    tmp0,>0100
     79C0 0100 
0040 79C2 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     79C4 A310 
0041 79C6 0584  14         inc   tmp0
0042 79C8 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     79CA A30A 
0043               
0044 79CC 0720  34         seto  @cmdb.visible         ; Show pane
     79CE A302 
0045 79D0 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     79D2 A318 
0046               
0047 79D4 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     79D6 0001 
0048 79D8 C804  38         mov   tmp0,@tv.pane.focus   ; /
     79DA A01E 
0049               
0050 79DC 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     79DE 7C2E 
0051               
0052 79E0 0720  34         seto  @parm1                ; Do not turn screen off while
     79E2 2F20 
0053                                                   ; reloading color scheme
0054               
0055 79E4 06A0  32         bl    @pane.action.colorscheme.load
     79E6 780C 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 79E8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 79EA C2F9  30         mov   *stack+,r11           ; Pop r11
0065 79EC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0159                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
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
0023 79EE 0649  14         dect  stack
0024 79F0 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 79F2 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     79F4 A11C 
     79F6 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 79F8 C820  54         mov   @tv.error.visible,@tv.error.visible
     79FA A024 
     79FC A024 
0033 79FE 1302  14         jeq   !
0034 7A00 0620  34         dec   @fb.scrrows
     7A02 A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 7A04 06A0  32 !       bl    @hchar
     7A06 2788 
0039 7A08 1C00                   byte pane.botrow-1,0,32,80*2
     7A0A 20A0 
0040 7A0C FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Hide command buffer pane (rest)
0043                       ;------------------------------------------------------
0044 7A0E C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7A10 A304 
     7A12 832A 
0045 7A14 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7A16 A302 
0046 7A18 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7A1A A116 
0047 7A1C 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7A1E A01E 
0048                       ;------------------------------------------------------
0049                       ; Reload current color scheme
0050                       ;------------------------------------------------------
0051 7A20 0720  34         seto  @parm1                ; Do not turn screen off while
     7A22 2F20 
0052                                                   ; reloading color scheme
0053               
0054 7A24 06A0  32         bl    @pane.action.colorscheme.load
     7A26 780C 
0055                                                   ; Reload color scheme
0056                                                   ; i  parm1 = Skip screen off if >FFFF
0057                       ;------------------------------------------------------
0058                       ; Show cursor again
0059                       ;------------------------------------------------------
0060 7A28 06A0  32         bl    @pane.cursor.blink
     7A2A 778E 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               pane.cmdb.hide.exit:
0065 7A2C C2F9  30         mov   *stack+,r11           ; Pop r11
0066 7A2E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0160                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
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
0017 7A30 0649  14         dect  stack
0018 7A32 C64B  30         mov   r11,*stack            ; Save return address
0019 7A34 0649  14         dect  stack
0020 7A36 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7A38 0649  14         dect  stack
0022 7A3A C645  30         mov   tmp1,*stack           ; Push tmp1
0023 7A3C 0649  14         dect  stack
0024 7A3E C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;------------------------------------------------------
0026                       ; Command buffer header line
0027                       ;------------------------------------------------------
0028 7A40 C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     7A42 A31C 
     7A44 2F20 
0029 7A46 0204  20         li    tmp0,80
     7A48 0050 
0030 7A4A C804  38         mov   tmp0,@parm2           ; Set requested length
     7A4C 2F22 
0031 7A4E 0204  20         li    tmp0,1
     7A50 0001 
0032 7A52 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7A54 2F24 
0033 7A56 0204  20         li    tmp0,rambuf
     7A58 2F6A 
0034 7A5A C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A5C 2F26 
0035               
0036               
0037 7A5E 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A60 32D6 
0038                                                   ; \ i  @parm1 = Pointer to string
0039                                                   ; | i  @parm2 = Requested length
0040                                                   ; | i  @parm3 = Fill character
0041                                                   ; | i  @parm4 = Pointer to buffer with
0042                                                   ; /             output string
0043               
0044 7A62 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7A64 A30E 
     7A66 832A 
0045 7A68 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     7A6A 2F30 
0046 7A6C 06A0  32         bl    @xutst0               ; /
     7A6E 2422 
0047                       ;------------------------------------------------------
0048                       ; Check dialog id
0049                       ;------------------------------------------------------
0050 7A70 04E0  34         clr   @waux1                ; Default is show prompt
     7A72 833C 
0051               
0052 7A74 C120  34         mov   @cmdb.dialog,tmp0
     7A76 A31A 
0053 7A78 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     7A7A 0063 
0054 7A7C 120E  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0055 7A7E 0720  34         seto  @waux1                ; /
     7A80 833C 
0056                       ;------------------------------------------------------
0057                       ; Show info message instead of prompt
0058                       ;------------------------------------------------------
0059 7A82 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     7A84 A31E 
0060 7A86 1309  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0061               
0062 7A88 06A0  32         bl    @at
     7A8A 2694 
0063 7A8C 1A00                   byte pane.botrow-3,0  ; Position cursor
0064               
0065 7A8E D815  46         movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
     7A90 A326 
0066 7A92 D195  26         movb  *tmp1,tmp2            ; |
0067 7A94 0986  56         srl   tmp2,8                ; |
0068 7A96 06A0  32         bl    @xutst0               ; /  Display info message
     7A98 2422 
0069                       ;------------------------------------------------------
0070                       ; Clear lines after prompt in command buffer
0071                       ;------------------------------------------------------
0072               pane.cmdb.draw.clear:
0073 7A9A C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7A9C A326 
0074 7A9E 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0075 7AA0 A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7AA2 A310 
0076 7AA4 C804  38         mov   tmp0,@wyx             ; /
     7AA6 832A 
0077               
0078 7AA8 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7AAA 23FC 
0079                                                   ; \ i  @wyx = Cursor position
0080                                                   ; / o  tmp0 = VDP target address
0081               
0082 7AAC 0205  20         li    tmp1,32
     7AAE 0020 
0083               
0084 7AB0 C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7AB2 A326 
0085 7AB4 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0086 7AB6 0506  16         neg   tmp2                  ; | Based on command & prompt length
0087 7AB8 0226  22         ai    tmp2,2*80 - 1         ; /
     7ABA 009F 
0088               
0089 7ABC 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7ABE 2296 
0090                                                   ; | i  tmp0 = VDP target address
0091                                                   ; | i  tmp1 = Byte to fill
0092                                                   ; / i  tmp2 = Number of bytes to fill
0093                       ;------------------------------------------------------
0094                       ; Display pane hint in command buffer
0095                       ;------------------------------------------------------
0096               pane.cmdb.draw.hint:
0097 7AC0 0204  20         li    tmp0,pane.botrow - 1  ; \
     7AC2 001C 
0098 7AC4 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0099 7AC6 C804  38         mov   tmp0,@parm1           ; Set parameter
     7AC8 2F20 
0100 7ACA C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7ACC A320 
     7ACE 2F22 
0101               
0102 7AD0 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7AD2 7706 
0103                                                   ; \ i  parm1 = Pointer to string with hint
0104                                                   ; / i  parm2 = YX position
0105                       ;------------------------------------------------------
0106                       ; Display keys in status line
0107                       ;------------------------------------------------------
0108 7AD4 0204  20         li    tmp0,pane.botrow      ; \
     7AD6 001D 
0109 7AD8 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0110 7ADA C804  38         mov   tmp0,@parm1           ; Set parameter
     7ADC 2F20 
0111 7ADE C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7AE0 A322 
     7AE2 2F22 
0112               
0113 7AE4 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7AE6 7706 
0114                                                   ; \ i  parm1 = Pointer to string with hint
0115                                                   ; / i  parm2 = YX position
0116                       ;------------------------------------------------------
0117                       ; ALPHA-Lock key down?
0118                       ;------------------------------------------------------
0119 7AE8 20A0  38         coc   @wbit10,config
     7AEA 200C 
0120 7AEC 1305  14         jeq   pane.cmdb.draw.alpha.down
0121                       ;------------------------------------------------------
0122                       ; AlPHA-Lock is up
0123                       ;------------------------------------------------------
0124 7AEE 06A0  32         bl    @putat
     7AF0 2444 
0125 7AF2 1D4F                   byte   pane.botrow,79
0126 7AF4 36E0                   data   txt.alpha.up
0127               
0128 7AF6 1004  14         jmp   pane.cmdb.draw.promptcmd
0129                       ;------------------------------------------------------
0130                       ; AlPHA-Lock is down
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.alpha.down:
0133 7AF8 06A0  32         bl    @putat
     7AFA 2444 
0134 7AFC 1D4F                   byte   pane.botrow,79
0135 7AFE 36E2                   data   txt.alpha.down
0136                       ;------------------------------------------------------
0137                       ; Command buffer content
0138                       ;------------------------------------------------------
0139               pane.cmdb.draw.promptcmd:
0140 7B00 C120  34         mov   @waux1,tmp0           ; Flag set?
     7B02 833C 
0141 7B04 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0142 7B06 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7B08 7420 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               pane.cmdb.draw.exit:
0147 7B0A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0148 7B0C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0149 7B0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0150 7B10 C2F9  30         mov   *stack+,r11           ; Pop r11
0151 7B12 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.464228
0161               
0162                       copy  "pane.topline.asm"    ; Top line
**** **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: Pane "status top line"
0003               
0004               ***************************************************************
0005               * pane.topline.draw
0006               * Draw top line
0007               ***************************************************************
0008               * bl  @pane.topline.draw
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.topline:
0017 7B14 0649  14         dect  stack
0018 7B16 C64B  30         mov   r11,*stack            ; Save return address
0019 7B18 0649  14         dect  stack
0020 7B1A C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7B1C 0649  14         dect  stack
0022 7B1E C660  46         mov   @wyx,*stack           ; Push cursor position
     7B20 832A 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7B22 06A0  32         bl    @hchar
     7B24 2788 
0027 7B26 0032                   byte 0,50,16,1        ; Vertical line 1
     7B28 1001 
0028 7B2A 0046                   byte 0,70,16,1        ; Vertical line 2
     7B2C 1001 
0029 7B2E FFFF                   data eol
0030                       ;------------------------------------------------------
0031                       ; Show buffer number
0032                       ;------------------------------------------------------
0033 7B30 06A0  32         bl    @putat
     7B32 2444 
0034 7B34 0000                   byte  0,0
0035 7B36 3696                   data  txt.bufnum
0036                       ;------------------------------------------------------
0037                       ; Show current file
0038                       ;------------------------------------------------------
0039 7B38 C820  54         mov   @edb.filename.ptr,@parm1
     7B3A A212 
     7B3C 2F20 
0040                                                   ; Get string to display
0041 7B3E 0204  20         li    tmp0,47
     7B40 002F 
0042 7B42 C804  38         mov   tmp0,@parm2           ; Set requested length
     7B44 2F22 
0043 7B46 0204  20         li    tmp0,32
     7B48 0020 
0044 7B4A C804  38         mov   tmp0,@parm3           ; Set character to fill
     7B4C 2F24 
0045 7B4E 0204  20         li    tmp0,rambuf
     7B50 2F6A 
0046 7B52 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7B54 2F26 
0047               
0048               
0049 7B56 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B58 32D6 
0050                                                   ; \ i  @parm1 = Pointer to string
0051                                                   ; | i  @parm2 = Requested length
0052                                                   ; | i  @parm3 = Fill characgter
0053                                                   ; | i  @parm4 = Pointer to buffer with
0054                                                   ; /             output string
0055               
0056 7B5A 06A0  32         bl    @setx
     7B5C 26AA 
0057 7B5E 0003                   data 3                ; Position cursor
0058               
0059 7B60 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7B62 2F30 
0060 7B64 06A0  32         bl    @xutst0               ; /
     7B66 2422 
0061                       ;------------------------------------------------------
0062                       ; Show M1 marker
0063                       ;------------------------------------------------------
0064 7B68 C120  34         mov   @edb.block.m1,tmp0    ; \
     7B6A A20C 
0065 7B6C 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0066 7B6E 1326  14         jeq   pane.topline.exit     ; /
0067               
0068 7B70 06A0  32         bl    @putat
     7B72 2444 
0069 7B74 0034                   byte 0,52
0070 7B76 36AC                   data txt.m1           ; Show M1 marker message
0071               
0072 7B78 C820  54         mov   @edb.block.m1,@parm1
     7B7A A20C 
     7B7C 2F20 
0073 7B7E 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B80 32AA 
0074                                                   ; \ i @parm1           = uint16
0075                                                   ; / o @unpacked.string = Output string
0076               
0077 7B82 0204  20         li    tmp0,>0500
     7B84 0500 
0078 7B86 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B88 2F44 
0079               
0080 7B8A 06A0  32         bl    @putat
     7B8C 2444 
0081 7B8E 0037                   byte 0,55
0082 7B90 2F44                   data unpacked.string  ; Show M1 value
0083                       ;------------------------------------------------------
0084                       ; Show M2 marker
0085                       ;------------------------------------------------------
0086 7B92 C120  34         mov   @edb.block.m2,tmp0    ; \
     7B94 A20E 
0087 7B96 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0088 7B98 1311  14         jeq   pane.topline.exit     ; /
0089               
0090 7B9A 06A0  32         bl    @putat
     7B9C 2444 
0091 7B9E 003E                   byte 0,62
0092 7BA0 36B0                   data txt.m2           ; Show M2 marker message
0093               
0094 7BA2 C820  54         mov   @edb.block.m2,@parm1
     7BA4 A20E 
     7BA6 2F20 
0095 7BA8 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7BAA 32AA 
0096                                                   ; \ i @parm1           = uint16
0097                                                   ; / o @unpacked.string = Output string
0098               
0099               
0100 7BAC 0204  20         li    tmp0,>0500
     7BAE 0500 
0101 7BB0 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7BB2 2F44 
0102               
0103 7BB4 06A0  32         bl    @putat
     7BB6 2444 
0104 7BB8 0041                   byte 0,65
0105 7BBA 2F44                   data unpacked.string  ; Show M2 value
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               pane.topline.exit:
0110 7BBC C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7BBE 832A 
0111 7BC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 7BC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0113 7BC4 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.464228
0163                       copy  "pane.errline.asm"    ; Error line
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
0022 7BC6 0649  14         dect  stack
0023 7BC8 C64B  30         mov   r11,*stack            ; Save return address
0024 7BCA 0649  14         dect  stack
0025 7BCC C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7BCE 0649  14         dect  stack
0027 7BD0 C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7BD2 0205  20         li    tmp1,>00f6            ; White on dark red
     7BD4 00F6 
0030 7BD6 C805  38         mov   tmp1,@parm1
     7BD8 2F20 
0031               
0032 7BDA 0205  20         li    tmp1,pane.botrow-1    ;
     7BDC 001C 
0033 7BDE C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BE0 2F22 
0034               
0035 7BE2 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BE4 7954 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7BE6 0204  20         li    tmp0,tv.error.msg
     7BE8 A026 
0043 7BEA C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7BEC 2F20 
0044               
0045 7BEE 0204  20         li    tmp0,80
     7BF0 0050 
0046 7BF2 C804  38         mov   tmp0,@parm2           ; Set requested length
     7BF4 2F22 
0047               
0048 7BF6 0204  20         li    tmp0,32
     7BF8 0020 
0049 7BFA C804  38         mov   tmp0,@parm3           ; Set character to fill
     7BFC 2F24 
0050               
0051 7BFE 0204  20         li    tmp0,rambuf
     7C00 2F6A 
0052 7C02 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7C04 2F26 
0053               
0054 7C06 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7C08 32D6 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7C0A 06A0  32         bl    @at
     7C0C 2694 
0064 7C0E 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7C10 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7C12 2F30 
0067 7C14 06A0  32         bl    @xutst0               ; /
     7C16 2422 
0068               
0069 7C18 C120  34         mov   @fb.scrrows.max,tmp0
     7C1A A11C 
0070 7C1C 0604  14         dec   tmp0
0071 7C1E C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7C20 A11A 
0072               
0073 7C22 0720  34         seto  @tv.error.visible     ; Error line is visible
     7C24 A024 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7C26 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7C28 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7C2A C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7C2C 045B  20         b     *r11                  ; Return to caller
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
0103 7C2E 0649  14         dect  stack
0104 7C30 C64B  30         mov   r11,*stack            ; Save return address
0105 7C32 0649  14         dect  stack
0106 7C34 C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7C36 06A0  32         bl    @errline.init         ; Clear error line
     7C38 323E 
0111               
0112 7C3A C120  34         mov   @tv.color,tmp0        ; Get colors
     7C3C A018 
0113 7C3E 0984  56         srl   tmp0,8                ; Right aligns
0114 7C40 C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7C42 2F20 
0115               
0116               
0117 7C44 0205  20         li    tmp1,pane.botrow-1    ;
     7C46 001C 
0118 7C48 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7C4A 2F22 
0119               
0120 7C4C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7C4E 7954 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7C50 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7C52 A024 
0125 7C54 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7C56 A11C 
     7C58 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7C5A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7C5C C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7C5E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.464228
0164                       copy  "pane.botline.asm"    ; Bottom line
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
0017 7C60 0649  14         dect  stack
0018 7C62 C64B  30         mov   r11,*stack            ; Save return address
0019 7C64 0649  14         dect  stack
0020 7C66 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7C68 0649  14         dect  stack
0022 7C6A C660  46         mov   @wyx,*stack           ; Push cursor position
     7C6C 832A 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7C6E 06A0  32         bl    @hchar
     7C70 2788 
0027 7C72 1D32                   byte pane.botrow,50,16,1       ; Vertical line 1
     7C74 1001 
0028 7C76 1D47                   byte pane.botrow,71,16,1       ; Vertical line 2
     7C78 1001 
0029 7C7A FFFF                   data eol
0030                       ;------------------------------------------------------
0031                       ; Show block shortcuts if set
0032                       ;------------------------------------------------------
0033 7C7C C120  34         mov   @edb.block.m2,tmp0    ; \
     7C7E A20E 
0034 7C80 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0035                                                   ; /
0036 7C82 1304  14         jeq   pane.botline.show_mode
0037               
0038 7C84 06A0  32         bl    @putat
     7C86 2444 
0039 7C88 1D00                   byte pane.botrow,0
0040 7C8A 36B4                   data txt.keys.block   ; Show block shortcuts
0041                       ;------------------------------------------------------
0042                       ; Show text editing mode
0043                       ;------------------------------------------------------
0044               pane.botline.show_mode:
0045 7C8C C120  34         mov   @edb.insmode,tmp0
     7C8E A20A 
0046 7C90 1605  14         jne   pane.botline.show_mode.insert
0047                       ;------------------------------------------------------
0048                       ; Overwrite mode
0049                       ;------------------------------------------------------
0050 7C92 06A0  32         bl    @putat
     7C94 2444 
0051 7C96 1D34                   byte  pane.botrow,52
0052 7C98 360A                   data  txt.ovrwrite
0053 7C9A 1004  14         jmp   pane.botline.show_changed
0054                       ;------------------------------------------------------
0055                       ; Insert  mode
0056                       ;------------------------------------------------------
0057               pane.botline.show_mode.insert:
0058 7C9C 06A0  32         bl    @putat
     7C9E 2444 
0059 7CA0 1D34                   byte  pane.botrow,52
0060 7CA2 360E                   data  txt.insert
0061                       ;------------------------------------------------------
0062                       ; Show if text was changed in editor buffer
0063                       ;------------------------------------------------------
0064               pane.botline.show_changed:
0065 7CA4 C120  34         mov   @edb.dirty,tmp0
     7CA6 A206 
0066 7CA8 1305  14         jeq   pane.botline.show_linecol
0067                       ;------------------------------------------------------
0068                       ; Show "*"
0069                       ;------------------------------------------------------
0070 7CAA 06A0  32         bl    @putat
     7CAC 2444 
0071 7CAE 1D38                   byte pane.botrow,56
0072 7CB0 3612                   data txt.star
0073 7CB2 1000  14         jmp   pane.botline.show_linecol
0074                       ;------------------------------------------------------
0075                       ; Show "line,column"
0076                       ;------------------------------------------------------
0077               pane.botline.show_linecol:
0078 7CB4 C820  54         mov   @fb.row,@parm1
     7CB6 A106 
     7CB8 2F20 
0079 7CBA 06A0  32         bl    @fb.row2line          ; Row to editor line
     7CBC 6A2A 
0080                                                   ; \ i @fb.topline = Top line in frame buffer
0081                                                   ; | i @parm1      = Row in frame buffer
0082                                                   ; / o @outparm1   = Matching line in EB
0083               
0084 7CBE 05A0  34         inc   @outparm1             ; Add base 1
     7CC0 2F30 
0085                       ;------------------------------------------------------
0086                       ; Show line
0087                       ;------------------------------------------------------
0088 7CC2 06A0  32         bl    @putnum
     7CC4 2A18 
0089 7CC6 1D3B                   byte  pane.botrow,59  ; YX
0090 7CC8 2F30                   data  outparm1,rambuf
     7CCA 2F6A 
0091 7CCC 3020                   byte  48              ; ASCII offset
0092                             byte  32              ; Padding character
0093                       ;------------------------------------------------------
0094                       ; Show comma
0095                       ;------------------------------------------------------
0096 7CCE 06A0  32         bl    @putat
     7CD0 2444 
0097 7CD2 1D40                   byte  pane.botrow,64
0098 7CD4 35FB                   data  txt.delim
0099                       ;------------------------------------------------------
0100                       ; Show column
0101                       ;------------------------------------------------------
0102 7CD6 06A0  32         bl    @film
     7CD8 2238 
0103 7CDA 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7CDC 0020 
     7CDE 000C 
0104               
0105 7CE0 C820  54         mov   @fb.column,@waux1
     7CE2 A10C 
     7CE4 833C 
0106 7CE6 05A0  34         inc   @waux1                ; Offset 1
     7CE8 833C 
0107               
0108 7CEA 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7CEC 299A 
0109 7CEE 833C                   data  waux1,rambuf
     7CF0 2F6A 
0110 7CF2 3020                   byte  48              ; ASCII offset
0111                             byte  32              ; Fill character
0112               
0113 7CF4 06A0  32         bl    @trimnum              ; Trim number to the left
     7CF6 29F2 
0114 7CF8 2F6A                   data  rambuf,rambuf+5,32
     7CFA 2F6F 
     7CFC 0020 
0115               
0116 7CFE 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7D00 0600 
0117 7D02 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7D04 2F6F 
0118               
0119                       ;------------------------------------------------------
0120                       ; Decide if row length is to be shown
0121                       ;------------------------------------------------------
0122 7D06 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7D08 A10C 
0123 7D0A 0584  14         inc   tmp0                  ; /
0124 7D0C 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7D0E A108 
0125 7D10 1101  14         jlt   pane.botline.show_linecol.linelen
0126 7D12 102B  14         jmp   pane.botline.show_linecol.colstring
0127                                                   ; Yes, skip showing row length
0128                       ;------------------------------------------------------
0129                       ; Add '/' delimiter and length of line to string
0130                       ;------------------------------------------------------
0131               pane.botline.show_linecol.linelen:
0132 7D14 C120  34         mov   @fb.column,tmp0       ; \
     7D16 A10C 
0133 7D18 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7D1A 2F71 
0134 7D1C 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7D1E 0009 
0135 7D20 1101  14         jlt   !                     ; | column.
0136 7D22 0585  14         inc   tmp1                  ; /
0137               
0138 7D24 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7D26 2D00 
0139 7D28 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0140               
0141 7D2A C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7D2C 833C 
0142               
0143 7D2E 06A0  32         bl    @mknum
     7D30 299A 
0144 7D32 A108                   data  fb.row.length,rambuf
     7D34 2F6A 
0145 7D36 3020                   byte  48              ; ASCII offset
0146                             byte  32              ; Padding character
0147               
0148 7D38 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7D3A 833C 
0149               
0150 7D3C C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7D3E A108 
0151 7D40 0284  22         ci    tmp0,10               ; /
     7D42 000A 
0152 7D44 110B  14         jlt   pane.botline.show_line.1digit
0153                       ;------------------------------------------------------
0154                       ; Assert
0155                       ;------------------------------------------------------
0156 7D46 0284  22         ci    tmp0,80
     7D48 0050 
0157 7D4A 1204  14         jle   pane.botline.show_line.2digits
0158                       ;------------------------------------------------------
0159                       ; Asserts failed
0160                       ;------------------------------------------------------
0161 7D4C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7D4E FFCE 
0162 7D50 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7D52 2026 
0163                       ;------------------------------------------------------
0164                       ; Show length of line (2 digits)
0165                       ;------------------------------------------------------
0166               pane.botline.show_line.2digits:
0167 7D54 0204  20         li    tmp0,rambuf+3
     7D56 2F6D 
0168 7D58 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0169 7D5A 1002  14         jmp   pane.botline.show_line.rest
0170                       ;------------------------------------------------------
0171                       ; Show length of line (1 digits)
0172                       ;------------------------------------------------------
0173               pane.botline.show_line.1digit:
0174 7D5C 0204  20         li    tmp0,rambuf+4
     7D5E 2F6E 
0175               pane.botline.show_line.rest:
0176 7D60 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0177 7D62 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D64 2F6A 
0178 7D66 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D68 2F6A 
0179                       ;------------------------------------------------------
0180                       ; Show column string
0181                       ;------------------------------------------------------
0182               pane.botline.show_linecol.colstring:
0183 7D6A 06A0  32         bl    @putat
     7D6C 2444 
0184 7D6E 1D41                   byte pane.botrow,65
0185 7D70 2F6F                   data rambuf+5         ; Show string
0186                       ;------------------------------------------------------
0187                       ; Show lines in buffer unless on last line in file
0188                       ;------------------------------------------------------
0189 7D72 C820  54         mov   @fb.row,@parm1
     7D74 A106 
     7D76 2F20 
0190 7D78 06A0  32         bl    @fb.row2line
     7D7A 6A2A 
0191 7D7C 8820  54         c     @edb.lines,@outparm1
     7D7E A204 
     7D80 2F30 
0192 7D82 1605  14         jne   pane.botline.show_lines_in_buffer
0193               
0194 7D84 06A0  32         bl    @putat
     7D86 2444 
0195 7D88 1D49                   byte pane.botrow,73
0196 7D8A 3604                   data txt.bottom
0197               
0198 7D8C 1009  14         jmp   pane.botline.exit
0199                       ;------------------------------------------------------
0200                       ; Show lines in buffer
0201                       ;------------------------------------------------------
0202               pane.botline.show_lines_in_buffer:
0203 7D8E C820  54         mov   @edb.lines,@waux1
     7D90 A204 
     7D92 833C 
0204               
0205 7D94 06A0  32         bl    @putnum
     7D96 2A18 
0206 7D98 1D49                   byte pane.botrow,73   ; YX
0207 7D9A 833C                   data waux1,rambuf
     7D9C 2F6A 
0208 7D9E 3020                   byte 48
0209                             byte 32
0210                       ;------------------------------------------------------
0211                       ; Exit
0212                       ;------------------------------------------------------
0213               pane.botline.exit:
0214 7DA0 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7DA2 832A 
0215 7DA4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0216 7DA6 C2F9  30         mov   *stack+,r11           ; Pop r11
0217 7DA8 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.464228
0165                       ;-----------------------------------------------------------------------
0166                       ; Stubs using trampoline
0167                       ;-----------------------------------------------------------------------
0168                       copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "fm.loadfile"
0006               * bank2 vec.1
0007               ********|*****|*********************|**************************
0008               fm.loadfile:
0009 7DAA 0649  14         dect  stack
0010 7DAC C64B  30         mov   r11,*stack            ; Save return address
0011 7DAE 0649  14         dect  stack
0012 7DB0 C644  30         mov   tmp0,*stack           ; Push tmp0
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 1
0015                       ;------------------------------------------------------
0016 7DB2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DB4 3008 
0017 7DB6 6004                   data bank2            ; | i  p0 = bank address
0018 7DB8 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0019 7DBA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Show "Unsaved changes" dialog if editor buffer dirty
0022                       ;------------------------------------------------------
0023 7DBC C120  34         mov   @outparm1,tmp0
     7DBE 2F30 
0024 7DC0 1304  14         jeq   fm.loadfile.exit
0025               
0026 7DC2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0027 7DC4 C2F9  30         mov   *stack+,r11           ; Pop r11
0028 7DC6 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7DC8 7E18 
0029                       ;------------------------------------------------------
0030                       ; Exit
0031                       ;------------------------------------------------------
0032               fm.loadfile.exit:
0033 7DCA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 7DCC C2F9  30         mov   *stack+,r11           ; Pop r11
0035 7DCE 045B  20         b     *r11                  ; Return to caller
0036               
0037               
0038               ***************************************************************
0039               * Stub for "fm.savefile"
0040               * bank2 vec.2
0041               ********|*****|*********************|**************************
0042               fm.savefile:
0043 7DD0 0649  14         dect  stack
0044 7DD2 C64B  30         mov   r11,*stack            ; Save return address
0045                       ;------------------------------------------------------
0046                       ; Call function in bank 1
0047                       ;------------------------------------------------------
0048 7DD4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DD6 3008 
0049 7DD8 6004                   data bank2            ; | i  p0 = bank address
0050 7DDA 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0051 7DDC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 7DDE C2F9  30         mov   *stack+,r11           ; Pop r11
0056 7DE0 045B  20         b     *r11                  ; Return to caller
0057               
0058               
0059               ***************************************************************
0060               * Stub for "About dialog"
0061               * bank3 vec.1
0062               ********|*****|*********************|**************************
0063               edkey.action.about:
0064 7DE2 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DE4 7770 
0065                       ;------------------------------------------------------
0066                       ; Show dialog
0067                       ;------------------------------------------------------
0068 7DE6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DE8 3008 
0069 7DEA 6006                   data bank3            ; | i  p0 = bank address
0070 7DEC 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0071 7DEE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0072                       ;------------------------------------------------------
0073                       ; Exit
0074                       ;------------------------------------------------------
0075 7DF0 0460  28         b     @edkey.action.cmdb.show
     7DF2 692A 
0076                                                   ; Show dialog in CMDB pane
0077               
0078               
0079               ***************************************************************
0080               * Stub for "Load DV80 file"
0081               * bank3 vec.2
0082               ********|*****|*********************|**************************
0083               dialog.load:
0084 7DF4 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DF6 7770 
0085                       ;------------------------------------------------------
0086                       ; Show dialog
0087                       ;------------------------------------------------------
0088 7DF8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DFA 3008 
0089 7DFC 6006                   data bank3            ; | i  p0 = bank address
0090 7DFE 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0091 7E00 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095 7E02 0460  28         b     @edkey.action.cmdb.show
     7E04 692A 
0096                                                   ; Show dialog in CMDB pane
0097               
0098               
0099               ***************************************************************
0100               * Stub for "Save DV80 file"
0101               * bank3 vec.3
0102               ********|*****|*********************|**************************
0103               dialog.save:
0104 7E06 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E08 7770 
0105                       ;------------------------------------------------------
0106                       ; Show dialog
0107                       ;------------------------------------------------------
0108 7E0A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E0C 3008 
0109 7E0E 6006                   data bank3            ; | i  p0 = bank address
0110 7E10 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0111 7E12 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115 7E14 0460  28         b     @edkey.action.cmdb.show
     7E16 692A 
0116                                                   ; Show dialog in CMDB pane
0117               
0118               
0119               ***************************************************************
0120               * Stub for "Unsaved Changes"
0121               * bank3 vec.4
0122               ********|*****|*********************|**************************
0123               dialog.unsaved:
0124 7E18 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E1A 7770 
0125                       ;------------------------------------------------------
0126                       ; Show dialog
0127                       ;------------------------------------------------------
0128 7E1C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E1E 3008 
0129 7E20 6006                   data bank3            ; | i  p0 = bank address
0130 7E22 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0131 7E24 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0132                       ;------------------------------------------------------
0133                       ; Exit
0134                       ;------------------------------------------------------
0135 7E26 0460  28         b     @edkey.action.cmdb.show
     7E28 692A 
0136                                                   ; Show dialog in CMDB pane
0137               
0138               
0139               
0140               
0141               ***************************************************************
0142               * Stub for Dialog "Move/Copy/Delete block"
0143               * bank3 vec.5
0144               ********|*****|*********************|**************************
0145               dialog.block:
0146 7E2A 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E2C 7770 
0147                       ;------------------------------------------------------
0148                       ; Show dialog
0149                       ;------------------------------------------------------
0150 7E2E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7E30 3008 
0151 7E32 6006                   data bank3            ; | i  p0 = bank address
0152 7E34 7FA4                   data vec.5            ; | i  p1 = Vector with target address
0153 7E36 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157 7E38 0460  28         b     @edkey.action.cmdb.show
     7E3A 692A 
0158                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.464228
0169                       ;-----------------------------------------------------------------------
0170                       ; Program data
0171                       ;-----------------------------------------------------------------------
0172                       copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
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
0011 7E3C 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7E3E 0000 
     7E40 6678 
0012 7E42 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7E44 0000 
     7E46 6172 
0013 7E48 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7E4A 0000 
     7E4C 618C 
0014 7E4E 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7E50 0000 
     7E52 62A4 
0015 7E54 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7E56 0000 
     7E58 62FE 
0016 7E5A BF00             data  key.fctn.h, pane.focus.fb, edkey.action.home
     7E5C 0000 
     7E5E 61A8 
0017 7E60 C000             data  key.fctn.j, pane.focus.fb, edkey.action.pword
     7E62 0000 
     7E64 61EA 
0018 7E66 C100             data  key.fctn.k, pane.focus.fb, edkey.action.nword
     7E68 0000 
     7E6A 6240 
0019 7E6C C200             data  key.fctn.l, pane.focus.fb, edkey.action.end
     7E6E 0000 
     7E70 61C8 
0020 7E72 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7E74 0000 
     7E76 6372 
0021 7E78 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7E7A 0000 
     7E7C 63AE 
0022 7E7E 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7E80 0000 
     7E82 63E8 
0023 7E84 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7E86 0000 
     7E88 6404 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7E8A 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7E8C 0000 
     7E8E 6476 
0028 7E90 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7E92 0000 
     7E94 6528 
0029 7E96 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7E98 0000 
     7E9A 64F4 
0030                       ;-------------------------------------------------------
0031                       ; Modifier keys - Insert
0032                       ;-------------------------------------------------------
0033 7E9C 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7E9E 0000 
     7EA0 658A 
0034 7EA2 B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7EA4 0000 
     7EA6 66F0 
0035 7EA8 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7EAA 0000 
     7EAC 6604 
0036                       ;-------------------------------------------------------
0037                       ; Block marking/modifier
0038                       ;-------------------------------------------------------
0039 7EAE 9600             data  key.ctrl.v, pane.focus.fb, edkey.action.block.mark
     7EB0 0000 
     7EB2 67C4 
0040 7EB4 9200             data  key.ctrl.r, pane.focus.fb, edkey.action.block.reset
     7EB6 0000 
     7EB8 67CC 
0041 7EBA 8300             data  key.ctrl.c, pane.focus.fb, edkey.action.block.copy
     7EBC 0000 
     7EBE 67D8 
0042 7EC0 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.block.delete
     7EC2 0000 
     7EC4 6814 
0043 7EC6 8D00             data  key.ctrl.m, pane.focus.fb, edkey.action.block.move
     7EC8 0000 
     7ECA 683E 
0044 7ECC 8700             data  key.ctrl.g, pane.focus.fb, edkey.action.block.goto.m1
     7ECE 0000 
     7ED0 6870 
0045                       ;-------------------------------------------------------
0046                       ; Other action keys
0047                       ;-------------------------------------------------------
0048 7ED2 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7ED4 0000 
     7ED6 676C 
0049 7ED8 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7EDA 0000 
     7EDC 77AE 
0050                       ;-------------------------------------------------------
0051                       ; Dialog keys
0052                       ;-------------------------------------------------------
0053 7EDE 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7EE0 0000 
     7EE2 677E 
0054 7EE4 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7EE6 0000 
     7EE8 678A 
0055 7EEA 0100             data  key.fctn.7, pane.focus.fb, edkey.action.about
     7EEC 0000 
     7EEE 7DE2 
0056 7EF0 9300             data  key.ctrl.s, pane.focus.fb, dialog.save
     7EF2 0000 
     7EF4 7E06 
0057 7EF6 8F00             data  key.ctrl.o, pane.focus.fb, dialog.load
     7EF8 0000 
     7EFA 7DF4 
0058                       ;-------------------------------------------------------
0059                       ; End of list
0060                       ;-------------------------------------------------------
0061 7EFC FFFF             data  EOL                           ; EOL
0062               
0063               
0064               
0065               
0066               *---------------------------------------------------------------
0067               * Action keys mapping table: Command Buffer (CMDB)
0068               *---------------------------------------------------------------
0069               keymap_actions.cmdb:
0070                       ;-------------------------------------------------------
0071                       ; Dialog specific: File load
0072                       ;-------------------------------------------------------
0073 7EFE 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7F00 000A 
     7F02 6A0A 
0074 7F04 0D00             data  key.enter, id.dialog.load, edkey.action.cmdb.load
     7F06 000A 
     7F08 693C 
0075                       ;-------------------------------------------------------
0076                       ; Dialog specific: Unsaved changes
0077                       ;-------------------------------------------------------
0078 7F0A 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7F0C 0065 
     7F0E 69E0 
0079 7F10 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7F12 0065 
     7F14 7E06 
0080                       ;-------------------------------------------------------
0081                       ; Dialog specific: File save
0082                       ;-------------------------------------------------------
0083 7F16 0D00             data  key.enter, id.dialog.save, edkey.action.cmdb.save
     7F18 000B 
     7F1A 6980 
0084 7F1C 0D00             data  key.enter, id.dialog.saveblock, edkey.action.cmdb.save
     7F1E 000C 
     7F20 6980 
0085                       ;-------------------------------------------------------
0086                       ; Dialog specific: About
0087                       ;-------------------------------------------------------
0088 7F22 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
     7F24 0067 
     7F26 6A16 
0089                       ;-------------------------------------------------------
0090                       ; Movement keys
0091                       ;-------------------------------------------------------
0092 7F28 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7F2A 0001 
     7F2C 688A 
0093 7F2E 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7F30 0001 
     7F32 689C 
0094 7F34 BF00             data  key.fctn.h, pane.focus.cmdb, edkey.action.cmdb.home
     7F36 0001 
     7F38 68B4 
0095 7F3A C200             data  key.fctn.l, pane.focus.cmdb, edkey.action.cmdb.end
     7F3C 0001 
     7F3E 68C8 
0096                       ;-------------------------------------------------------
0097                       ; Modifier keys
0098                       ;-------------------------------------------------------
0099 7F40 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7F42 0001 
     7F44 68E0 
0100                       ;-------------------------------------------------------
0101                       ; Other action keys
0102                       ;-------------------------------------------------------
0103 7F46 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7F48 0001 
     7F4A 6A16 
0104 7F4C 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7F4E 0001 
     7F50 676C 
0105 7F52 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7F54 0001 
     7F56 77AE 
0106                       ;------------------------------------------------------
0107                       ; End of list
0108                       ;-------------------------------------------------------
0109 7F58 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.464228
0173                       ;-----------------------------------------------------------------------
0174                       ; Bank specific vector table
0175                       ;-----------------------------------------------------------------------
0179 7F5A 7F5A                   data $                ; Bank 1 ROM size OK.
0181                       ;-------------------------------------------------------
0182                       ; Vector table bank 1: >7f9c - >7fff
0183                       ;-------------------------------------------------------
0184                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 6D70     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0010 7F9E 6C28     vec.2   data  idx.entry.update      ;    for index functions.
0011 7FA0 6CD6     vec.3   data  idx.entry.delete      ;
0012 7FA2 6C7A     vec.4   data  idx.pointer.get       ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 6E58     vec.10  data  edb.line.pack.fb      ;
0019 7FB0 6F22     vec.11  data  edb.line.unpack.fb    ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 692A     vec.15  data  edkey.action.cmdb.show
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 746A     vec.19  data  cmdb.cmd.clear        ;
0028 7FC2 6AB4     vec.20  data  fb.refresh            ;
0029 7FC4 6B24     vec.21  data  fb.vdpdump            ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 778E     vec.28  data  pane.cursor.blink     ;
0037 7FD4 7770     vec.29  data  pane.cursor.hide      ;
0038 7FD6 7BC6     vec.30  data  pane.errline.show     ;
0039 7FD8 780C     vec.31  data  pane.action.colorscheme.load
0040 7FDA 793A     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.464228
0185               
0186               
0187               
0188               
0189               *--------------------------------------------------------------
0190               * Video mode configuration
0191               *--------------------------------------------------------------
0192      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0193      0004     spfbck  equ   >04                   ; Screen background color.
0194      336E     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0195      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0196      0050     colrow  equ   80                    ; Columns per row
0197      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0198      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0199      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0200      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
